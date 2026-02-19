import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../../data/ai_chat_mock_data.dart';

class IndiaMartSearchService {
  IndiaMartSearchService._();

  static const _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/109.0';
  static const _baseDir = 'https://dir.indiamart.com';
  static const _baseWww = 'https://www.indiamart.com';
  static const _ddgHtml = 'https://html.duckduckgo.com/html/';
  static const _timeout = Duration(seconds: 12);
  static const _maxResults = 5;
  static const _maxTries = 35;
  static const _maxSearchResultsToFetch = 8;

  /// Uses DuckDuckGo HTML search (site:indiamart.com) to find IndiaMART URLs.
  /// [preferredQuery] when set (e.g. from LLM intent "rice kanpur") is used as the search phrase instead of [query].
  static Future<List<String>> _indiamartUrlsFromSearch(String query, http.Client client, {String? preferredQuery}) async {
    final q = (preferredQuery ?? query).trim();
    if (q.isEmpty) return [];
    final searchQuery = 'site:indiamart.com $q';
    final uri = Uri.parse(_ddgHtml).replace(queryParameters: {'q': searchQuery});
    try {
      final res = await client.get(uri, headers: {'User-Agent': _userAgent}).timeout(_timeout);
      if (res.statusCode != 200) return [];
      final doc = parser.parse(res.body);
      final out = <String>[];
      final seen = <String>{};
      for (final a in doc.querySelectorAll('a[href*="duckduckgo.com/l/"]')) {
        final href = a.attributes['href'];
        if (href == null || !href.contains('uddg=')) continue;
        final parsed = Uri.tryParse(href);
        final uddg = parsed?.queryParameters['uddg'];
        if (uddg == null || uddg.isEmpty) continue;
        final realUrl = Uri.decodeComponent(uddg);
        if (!realUrl.contains('indiamart.com')) continue;
        final normalized = realUrl.split('?').first;
        if (normalized.isEmpty || seen.contains(normalized)) continue;
        seen.add(normalized);
        out.add(normalized);
        if (out.length >= _maxSearchResultsToFetch) break;
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  static List<String> _words(String query) {
    return query
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w.replaceAll(RegExp(r'[^a-z0-9-]'), ''))
        .where((w) => w.isNotEmpty)
        .toList();
  }

  static String _toSlug(List<String> words, int start, int end) {
    if (start >= end) return '';
    return words.sublist(start, end).join('-');
  }

  static String _phraseToSlug(String phrase) {
    return phrase
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w.replaceAll(RegExp(r'[^a-z0-9-]'), ''))
        .where((w) => w.isNotEmpty)
        .join('-');
  }

  /// Add slug variants (woolen/woollen, clothes/clothing, plural/singular) to improve match on IndiaMART.
  static List<String> _slugVariants(String slug) {
    final out = <String>{slug};
    if (slug.contains('woolen') && !slug.contains('woollen')) out.add(slug.replaceAll('woolen', 'woollen'));
    if (slug.contains('woollen') && !slug.contains('woolen')) out.add(slug.replaceAll('woollen', 'woolen'));
    if (slug.endsWith('clothes')) out.add('${slug.replaceAll(RegExp(r'clothes$'), '')}clothing');
    if (slug.endsWith('clothing')) out.add('${slug.replaceAll(RegExp(r'clothing$'), '')}clothes');
    // Plural/singular for multi-word slugs (e.g. paper-bag <-> paper-bags)
    if (slug.contains('-')) {
      if (slug.endsWith('s') && !slug.endsWith('ss')) out.add(slug.substring(0, slug.length - 1));
      else if (!slug.endsWith('s')) {
        final lastHyphen = slug.lastIndexOf('-');
        if (lastHyphen >= 0) out.add('${slug.substring(0, lastHyphen + 1)}${slug.substring(lastHyphen + 1)}s');
        else out.add('${slug}s');
      }
    }
    // Single-word: sunglass <-> sunglasses (IndiaMART may use either)
    if (slug == 'sunglasses') out.add('sunglass');
    if (slug == 'sunglass') out.add('sunglasses');
    return out.toList();
  }

  /// URL candidates from LLM-extracted product/location or searchQuery only. No pattern matching.
  static List<String> _intentUrlCandidates(String? product, String? location) {
    if (product == null || product.trim().isEmpty) return [];
    final productSlug = _phraseToSlug(product.trim());
    if (productSlug.isEmpty) return [];
    final candidates = <String>[];
    final seen = <String>{};
    void add(String u) {
      if (!seen.contains(u)) { seen.add(u); candidates.add(u); }
    }
    if (location != null && location.trim().isNotEmpty) {
      final locationSlug = _phraseToSlug(location.trim());
      if (locationSlug.length >= 2) add('$_baseDir/$locationSlug/$productSlug.html');
    }
    for (final v in _slugVariants(productSlug)) {
      if (v.isNotEmpty) add('$_baseDir/impcat/$v.html');
    }
    return candidates;
  }

  /// Builds URL candidates from LLM intent only. When no intent, minimal fallback from raw query words.
  static List<String> _urlCandidates(String query, {String? intentProduct, String? intentLocation, String? intentSearchQuery}) {
    final words = _words(query);
    final seen = <String>{};
    final candidates = <String>[];

    void add(String u) {
      if (!seen.contains(u)) { seen.add(u); candidates.add(u); }
    }

    // 1) LLM intent: product/location (from intent extraction—single source of truth)
    if (intentProduct != null || intentLocation != null) {
      for (final u in _intentUrlCandidates(intentProduct, intentLocation)) {
        add(u);
      }
    }

    // 2) LLM intent: searchQuery when product/location not separate (e.g. "paper bags jaipur" as one phrase)
    if (intentSearchQuery != null && intentSearchQuery.trim().isNotEmpty) {
      final sq = intentSearchQuery.trim();
      final sqSlug = _phraseToSlug(sq);
      if (sqSlug.isNotEmpty) {
        for (final v in _slugVariants(sqSlug)) {
          if (v.isNotEmpty) add('$_baseDir/impcat/$v.html');
        }
        final sqWords = _words(sq);
        if (sqWords.length >= 2) {
          final loc = sqWords.last;
          final prodSlug = _toSlug(sqWords, 0, sqWords.length - 1);
          if (prodSlug.isNotEmpty && loc.length >= 2) add('$_baseDir/$loc/$prodSlug.html');
        }
      }
    }

    // 3) Minimal fallback when LLM returned nothing: use raw query words for impcat only
    if (candidates.isEmpty && words.isNotEmpty) {
      final fullSlug = words.join('-');
      for (final slug in [fullSlug, ..._slugVariants(fullSlug)]) {
        if (slug.isNotEmpty) add('$_baseDir/impcat/$slug.html');
      }
      for (var len = words.length; len >= 1; len--) {
        final slug = _toSlug(words, 0, len);
        if (slug.isNotEmpty) add('$_baseDir/impcat/$slug.html');
      }
    }

    return candidates;
  }

  /// Uses LLM intent: [searchQuery] for DuckDuckGo; [product] and [location] for URL candidates. No pattern matching—intent is the single source.
  static Future<List<AiChatSeller>> search(String query, {String? product, String? location, String? searchQuery}) async {
    final q = query.trim();
    if (q.isEmpty && product == null && location == null && searchQuery == null) return [];

    final client = http.Client();
    final allSellers = <AiChatSeller>[];
    final seenKeys = <String>{};

    final preferredQuery = searchQuery?.trim().isNotEmpty == true
        ? searchQuery!.trim()
        : ((product != null && product.isNotEmpty) || (location != null && location.isNotEmpty))
            ? [product, location].where((e) => e != null && e.toString().trim().isNotEmpty).join(' ')
            : null;

    try {
      // 1) Search-engine method: DuckDuckGo with intent-based query when available
      final searchUrls = await _indiamartUrlsFromSearch(q, client, preferredQuery: preferredQuery);
      for (final url in searchUrls) {
        if (allSellers.length >= _maxResults) break;
        try {
          final res = await client
              .get(Uri.parse(url), headers: {'User-Agent': _userAgent})
              .timeout(_timeout);
          if (res.statusCode != 200) continue;
          if (url.contains(_baseDir) || url.contains('/impcat/') || url.contains('dir.indiamart')) {
            final list = _parseListing(res.body, url, q);
            for (final s in list) {
              final k = '${s.supplierName}|${s.url ?? ''}';
              if (seenKeys.contains(k)) continue;
              seenKeys.add(k);
              allSellers.add(s);
              if (allSellers.length >= _maxResults) break;
            }
          } else if (url.startsWith(_baseWww)) {
            final seller = _parseCompany(res.body, url, q);
            if (seller != null) {
              final k = '${seller.supplierName}|${seller.url ?? ''}';
              if (!seenKeys.contains(k)) {
                seenKeys.add(k);
                allSellers.add(seller);
              }
            }
          }
        } catch (_) {
          continue;
        }
      }

      if (allSellers.isNotEmpty) return allSellers.take(_maxResults).toList();

      // 2) Fallback: URL candidates from LLM intent only (product/location or searchQuery), else minimal from raw query words
      final candidates = _urlCandidates(q, intentProduct: product, intentLocation: location, intentSearchQuery: searchQuery);
      var attempts = 0;
      for (final url in candidates) {
        if (attempts >= _maxTries) break;
        attempts++;
        try {
          final res = await client
              .get(Uri.parse(url), headers: {'User-Agent': _userAgent})
              .timeout(_timeout);
          if (res.statusCode != 200) continue;
          if (url.contains(_baseDir) || url.contains('/impcat/')) {
            final list = _parseListing(res.body, url, q);
            if (list.isNotEmpty) return list.take(_maxResults).toList();
          } else if (url.startsWith(_baseWww)) {
            final seller = _parseCompany(res.body, url, q);
            if (seller != null) return [seller];
          }
        } catch (_) {
          continue;
        }
      }
      return [];
    } finally {
      client.close();
    }
  }

  // ===========================
  // LISTING PAGE
  // ===========================
  static List<AiChatSeller> _parseListing(
      String html, String pageUrl, String query) {
    final doc = parser.parse(html);
    final sellers = <AiChatSeller>[];
    final pageUri = Uri.parse(pageUrl);
    final links = doc.querySelectorAll('a[href*="indiamart.com"]');
    final seen = <String>{};

    for (final a in links) {
      if (sellers.length >= _maxResults) break;

      var href = (a.attributes['href'] ?? '').trim();
      if (href.isEmpty) continue;
      if (!href.startsWith('http')) href = pageUri.resolve(href).toString();
      if (!href.contains('www.indiamart.com')) continue;
      if (href.contains('dir.indiamart') || href.contains('/search') || href.contains('/impcat/')) continue;

      final name = a.text.trim();
      if (name.length < 2 || name.length > 100) continue;
      if (name.toLowerCase() == 'indiamart') continue;

      final key = '$name|$href';
      if (seen.contains(key)) continue;
      seen.add(key);

      var text = a.parent?.text ?? '';
      var node = a.parent;
      for (var i = 0; i < 6 && node != null; i++) {
        final t = node.text;
        if (t.length > text.length) text = t;
        node = node.parent;
      }

      String? imageUrl;
      var parent = a.parent;
      for (var i = 0; i < 5 && parent != null; i++) {
        final img = parent.querySelector('img');
        final src = img?.attributes['src'] ?? img?.attributes['data-src'];
        if (src != null && src.isNotEmpty) {
          imageUrl = src.startsWith('http') ? src : pageUri.resolve(src).toString();
          break;
        }
        parent = parent.parent;
      }

      sellers.add(
        AiChatSeller(
          category: query,
          supplierName: name,
          productTitle: _extractProduct(text, query),
          location: _extractLocation(text),
          priceRange: _extractPrice(text),
          moq: _extractMoq(text),
          url: href,
          imageUrl: imageUrl,
        ),
      );
    }
    return sellers;
  }

  // ===========================
  // COMPANY PAGE
  // ===========================
  static AiChatSeller? _parseCompany(
      String html, String url, String query) {
    final doc = parser.parse(html);

    final h1 = doc.querySelector('h1')?.text.trim();
    final title = doc.querySelector('title')?.text.trim();
    final name = h1?.isNotEmpty == true ? h1! : title;

    if (name == null || name.isEmpty) return null;

    String? imageUrl;
    String? description;
    for (final meta in doc.querySelectorAll('meta')) {
      final prop = meta.attributes['property'] ?? meta.attributes['name'];
      final content = meta.attributes['content']?.trim();
      if (content == null || content.isEmpty) continue;
      if (prop == 'og:image') imageUrl = content.startsWith('http') ? content : Uri.parse(url).resolve(content).toString();
      if (prop == 'og:description' || prop == 'description') description = content.length > 200 ? '${content.substring(0, 197)}...' : content;
    }

    return AiChatSeller(
      category: 'Company',
      supplierName: name,
      productTitle: query,
      location: _extractLocation(doc.body?.text ?? ''),
      priceRange: 'Get Quote',
      moq: null,
      url: url,
      imageUrl: imageUrl,
      description: description,
    );
  }

  // ===========================
  // HELPERS
  // ===========================
  static String _extractLocation(String text) {
    final m = RegExp(r'[A-Za-z ]+,\s*[A-Za-z ]+').firstMatch(text);
    return m?.group(0) ?? 'India';
  }

  static String _extractPrice(String text) {
    // ₹ range or single
    var m = RegExp(r'₹\s*[\d,]+(?:\s*[-–]\s*₹?\s*[\d,]+)?').firstMatch(text);
    if (m != null) return m.group(0)!.trim();
    // Rs. / INR (with optional space)
    m = RegExp(r'(?:Rs\.?|INR)\s*[\d,]+(?:\s*[-–]\s*[\d,]+)?', caseSensitive: false).firstMatch(text);
    if (m != null) return m.group(0)!.trim();
    // "Price: Rs 100" or "Rate: ₹100"
    m = RegExp(r'(?:Price|Rate|MRP)\s*[:\s]*(?:₹|Rs\.?|INR)?\s*[\d,]+(?:\s*[-–]\s*[\d,]+)?', caseSensitive: false).firstMatch(text);
    if (m != null) return m.group(0)!.trim();
    // Naked number range that looks like price (e.g. "100 - 500" or "1,000/piece")
    m = RegExp(r'[\d,]+(?:\s*[-–]\s*[\d,]+)?\s*(?:/|\s*per\s+)(?:unit|piece|kg|pc\.?)', caseSensitive: false).firstMatch(text);
    if (m != null) return m.group(0)!.trim();
    return 'Contact for price';
  }

  static String? _extractMoq(String text) {
    final m = RegExp(
      r'(MOQ|Minimum Order)[^0-9]*([\d,]+)',
      caseSensitive: false,
    ).firstMatch(text);
    return m?.group(0);
  }

  static String _extractProduct(String text, String fallback) {
    for (final line in text.split('\n')) {
      final t = line.trim();
      if (t.length > 5 && t.length < 80) return t;
    }
    return fallback;
  }
}
