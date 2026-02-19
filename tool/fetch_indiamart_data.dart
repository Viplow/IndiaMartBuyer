// Run from project root: dart run tool/fetch_indiamart_data.dart
// Fetches seller listings from IndiaMART category pages and writes assets/ai_chat_sellers.json.
// If the site blocks or structure changes, the app falls back to mock data.

import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

const _userAgent =
    'Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0';

final _cityRegex = RegExp(
  r'\b(Noida|Delhi|Mumbai|Pune|Chennai|Bangalore|Bengaluru|Kolkata|Hyderabad|'
  r'Ahmedabad|Faridabad|Gurgaon|Ghaziabad|Vadodara|Thane|Coimbatore|Lucknow|'
  r'Madurai|Agra|Sangli|Bhubaneswar|Howrah|Erode|Mysuru|Theni|Tiruchirappalli|'
  r'Virudhunagar|Karnal|Gautam Buddha Nagar|Kandur|Shirala|Achnera|Muzaffarpur|'
  r'Bhandara|Nilokheri|Theni|Washermanpet|Narol|Bharatpur|Khordha)\b',
  caseSensitive: false,
);

final _distRegex = RegExp(r'Dist\.\s*([A-Za-z\s]+)', caseSensitive: false);

const _baseCategoryUrl = 'https://dir.indiamart.com/impcat';

/// Default categories if no args. Pass category slugs as args for any category:
/// dart run tool/fetch_indiamart_data.dart rice machinery cotton-fabric
final _defaultSlugs = [
  'rice',
  'industrial-machinery',
  'cotton-fabric',
  'industrial-chemicals',
  'packaging-materials',
  'construction-materials',
  'electronic-components',
  'steel-products',
  'agricultural-machinery',
];

void main(List<String> args) async {
  final client = http.Client();
  final results = <Map<String, dynamic>>[];

  final slugs = args.isEmpty ? _defaultSlugs : args;

  for (final slug in slugs) {
    final category = slug.replaceAll('-', ' ');
    final url = '$_baseCategoryUrl/$slug.html';
    try {
      print('Fetching $category: $url');
      final res = await client
          .get(Uri.parse(url), headers: {'User-Agent': _userAgent})
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) {
        print('  -> ${res.statusCode}, skipping');
        continue;
      }
      final doc = parser.parse(res.body);
      final list = _extractSellers(doc, category, url);
      results.addAll(list);
      print('  -> ${list.length} sellers');
    } catch (e) {
      print('  -> error: $e');
    }
  }

  client.close();

  // Dedupe by supplierName+location
  final seen = <String>{};
  final deduped = results.where((m) {
    final k = '${m['supplierName']}|${m['location']}';
    if (seen.contains(k)) return false;
    seen.add(k);
    return true;
  }).toList();

  final outDir = Directory('assets');
  if (!await outDir.exists()) await outDir.create(recursive: true);
  final file = File('assets/ai_chat_sellers.json');
  await file.writeAsString(
    const JsonEncoder.withIndent('  ').convert(deduped),
  );
  print('Wrote ${deduped.length} sellers to ${file.path}');
}

List<Map<String, dynamic>> _extractSellers(
    dynamic doc, String category, String pageUrl) {
  final list = <Map<String, dynamic>>[];
  final links = doc.querySelectorAll('a[href*="www.indiamart.com"]');
  final productTitle = _categoryToProductTitle(category);
  final pageUri = Uri.parse(pageUrl);

  for (final a in links) {
    var href = (a.attributes['href'] ?? '').trim();
    if (href.isEmpty || href.contains('dir.indiamart') || href.contains('search')) continue;
    if (!href.startsWith('http')) {
      href = pageUri.resolve(href).toString();
    }
    final name = a.text.trim();
    if (name.length < 2 || name.length > 80) continue;
    if (name.toLowerCase() == 'indiamart') continue;

    String location = '';
    var parent = a.parent;
    for (var i = 0; i < 5 && parent != null; i++) {
      final text = parent.text;
      final cityMatch = _cityRegex.firstMatch(text);
      if (cityMatch != null) {
        location = cityMatch.group(0)!;
        final distMatch = _distRegex.firstMatch(text);
        if (distMatch != null) {
          final dist = distMatch.group(1)?.trim() ?? '';
          if (dist.isNotEmpty) location = '$location, Dist. $dist';
        }
        break;
      }
      parent = parent.parent;
    }
    if (location.isEmpty) location = 'India';
    if (location.length > 50) location = location.substring(0, 50).trim();

    list.add({
      'category': category,
      'location': location,
      'supplierName': name,
      'productTitle': productTitle,
      'priceRange': 'Contact for price',
      'moq': null,
      'url': href,
    });
  }

  return list;
}

String _categoryToProductTitle(String category) {
  return category
      .split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
