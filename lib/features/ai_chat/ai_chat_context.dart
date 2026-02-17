import '../../data/ai_chat_mock_data.dart';

/// Builds context string from mock data for the Gemini prompt.
class AiChatContext {
  AiChatContext._();

  static const _locations = [
    'noida',
    'delhi',
    'mumbai',
    'pune',
    'chennai',
    'bangalore',
    'kolkata',
    'hyderabad',
    'ahmedabad',
    'gurgaon',
    'faridabad',
    'ghaziabad',
    'vadodara',
    'ncr',
  ];

  static const _categories = [
    'rice',
    'machinery',
    'raw materials',
    'steel',
    'electronics',
    'grains',
    'cnc',
    'hydraulic',
    'copper',
    'wire',
    'basmati',
    'components',
    // Textiles & Garments
    'textile',
    'garment',
    'fabric',
    'cotton',
    'yarn',
    'denim',
    // Chemicals
    'chemical',
    // Packaging
    'packaging',
    'corrugated',
    'box',
    'film',
    // Construction & Building
    'construction',
    'building',
    'cement',
    'tiles',
    'tmt',
    'aggregate',
    // Industrial Equipment
    'industrial',
    'equipment',
    'pump',
    'motor',
    'generator',
    'compressor',
    'boiler',
    'conveyor',
    // Food & Beverage
    'food',
    'beverage',
    'edible oil',
    'spice',
    'pulse',
    'snack',
    // Plastics & Polymers
    'plastic',
    'polymer',
    'pp',
    'pe',
    'pvc',
    'hdpe',
    // Rubber
    'rubber',
    'gasket',
    // Paper
    'paper',
    'kraft',
    'tissue',
    // Paints & Coatings
    'paint',
    'coating',
    // Tools & Hardware
    'tools',
    'hardware',
    'fastener',
    'abrasive',
    // Electrical
    'electrical',
    'cable',
    'solar',
    'inverter',
    'switchgear',
    // Safety
    'safety',
    'ppe',
    'fire extinguisher',
    // Medical & Pharma
    'medical',
    'pharma',
    // Agriculture
    'agriculture',
    'fertilizer',
    'seed',
    'pesticide',
    'tractor',
    // Auto Parts
    'auto',
    'automobile',
    'spare',
    'bicycle',
    'bike',
    // Furniture & Office
    'furniture',
    'office',
    'chair',
    'desk',
    // Lab & Scientific
    'lab',
    'scientific',
    'testing equipment',
  ];

  /// Returns a context string for the LLM: relevant sellers and FAQ based on [query].
  static String buildContext(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return 'No specific context.';

    final buffer = StringBuffer();

    // Detect location and category from query
    String? matchedLocation;
    for (final loc in _locations) {
      if (q.contains(loc)) {
        matchedLocation = loc;
        break;
      }
    }
    if (matchedLocation == 'delhi' || matchedLocation == 'ncr') matchedLocation = 'delhi ncr';

    final matchedCategories = <String>[];
    for (final cat in _categories) {
      if (q.contains(cat)) matchedCategories.add(cat);
    }
    // Map some terms to our category names
    if (q.contains('steel') || q.contains('copper') || q.contains('wire')) {
      if (!matchedCategories.contains('raw materials')) matchedCategories.add('raw materials');
    }
    if (q.contains('cnc') || q.contains('hydraulic') || q.contains('press')) {
      if (!matchedCategories.contains('machinery')) matchedCategories.add('machinery');
    }
    if (q.contains('basmati') || q.contains('grains')) {
      if (!matchedCategories.contains('rice')) matchedCategories.add('rice');
    }

    // Sellers: filter by location and/or category
    final sellers = AiChatMockData.sellers.where((s) {
      final locMatch = matchedLocation == null ||
          s.location.toLowerCase().contains(matchedLocation) ||
          matchedLocation.contains(s.location.toLowerCase().split(' ').first);
      final catMatch = matchedCategories.isEmpty ||
          matchedCategories.any((c) =>
              s.category.toLowerCase().contains(c) ||
              c.contains(s.category.toLowerCase()));
      return locMatch && catMatch;
    }).toList();

    if (sellers.isNotEmpty) {
      buffer.writeln('Sellers / products (use only this data when answering about local sellers or prices):');
      for (final s in sellers.take(8)) {
        buffer.writeln(
            '- ${s.supplierName}, ${s.location}: ${s.productTitle}. Price: ${s.priceRange}. ${s.moq ?? ""}');
      }
      buffer.writeln();
    }

    // FAQ: if query looks like a question, add relevant FAQ
    final isQuestion = q.contains('?') ||
        q.contains('what ') ||
        q.contains('how ') ||
        q.contains('can i') ||
        q.contains('why ') ||
        q.contains('when ');
    if (isQuestion || matchedCategories.isEmpty) {
      final relevantFaq = AiChatMockData.faq.where((e) {
        return e.keywords.any((k) => q.contains(k));
      }).toList();
      if (relevantFaq.isNotEmpty) {
        buffer.writeln('Relevant FAQ (use when answering buyer questions):');
        for (final f in relevantFaq.take(3)) {
          buffer.writeln('Q: ${f.keywords.join(", ")}');
          buffer.writeln('A: ${f.answer}');
        }
      }
    }

    if (buffer.isEmpty) {
      buffer.writeln(
          'No specific data for this query. General categories we have: Rice, Machinery, Raw Materials, Electronics, Textiles & Garments, Chemicals, Packaging, Construction & Building, Industrial Equipment, Food & Beverage, Plastics & Polymers, Rubber, Paper, Paints & Coatings, Tools & Hardware, Electrical Equipment, Safety Equipment, Medical & Pharma, Agriculture, Auto Parts, Furniture & Office, Lab & Scientific. Locations: Noida, Delhi NCR, Mumbai, Pune, Chennai, Bangalore, Vadodara. Suggest the user try "local sellers for [product] in [city]" or ask about MOQ, quotes, payment, delivery.');
    }

    return buffer.toString();
  }

  /// When the API is unavailable (e.g. 429), format [contextString] into a short reply.
  static String fallbackReplyFromContext(String contextString) {
    final lines = contextString.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (lines.isEmpty) {
      return 'I couldn\'t reach the AI right now. Try asking for "local sellers for Rice in Noida" or "What is MOQ?" in a moment.';
    }
    final buffer = StringBuffer();
    final sellerLines = lines.where((l) => l.startsWith('- ') && l.contains(',')).take(6).toList();
    final faqAnswers = <String>[];
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('A: ')) faqAnswers.add(lines[i].substring(3).trim());
    }
    if (sellerLines.isNotEmpty) {
      buffer.writeln('Here’s what we have from our database:');
      for (final line in sellerLines) {
        buffer.writeln(line.substring(2)); // drop "- "
      }
    }
    if (faqAnswers.isNotEmpty && buffer.isNotEmpty) buffer.writeln();
    if (faqAnswers.isNotEmpty) {
      buffer.write(faqAnswers.first);
    }
    if (buffer.isEmpty) {
      buffer.write(lines.first);
    }
    buffer.write('\n\n(Reply from our database; AI is temporarily limited.)');
    return buffer.toString();
  }
}
