import '../../data/ai_chat_mock_data.dart';

/// Builds context string for the LLM. No hardcoded city/category lists; uses live search or a simple sample.
class AiChatContext {
  AiChatContext._();

  /// Returns a context string for the LLM.
  /// When [comparisonSections] is provided (e.g. for "compare rice and lentils" or "rice in Kanpur vs Delhi"), each entry is a label and list of sellers; the LLM should compare prices across these sections.
  static String buildContext(String query, {List<AiChatSeller>? liveSellers, Map<String, List<AiChatSeller>>? comparisonSections}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return 'No specific context.';

    final buffer = StringBuffer();
    const maxResults = 5;

    final hasComparison = comparisonSections != null && comparisonSections.isNotEmpty;
    if (hasComparison) {
      buffer.writeln('The user wants to COMPARE prices. Below are separate sections (by product or by city). For each section list sellers with Name, Location, Product, Price, MOQ, Link. Then give a clear comparison: which product/city/seller has lowest or highest price, or a short comparison table.');
      buffer.writeln();
      for (final entry in comparisonSections.entries) {
        final label = entry.key;
        final sellers = entry.value.take(maxResults).toList();
        buffer.writeln('=== $label ===');
        if (sellers.isEmpty) {
          buffer.writeln('(No results)');
        } else {
          for (final s in sellers) {
            final linkPart = (s.url != null && s.url!.isNotEmpty) ? ' Link: ${s.url}' : '';
            buffer.writeln('- ${s.supplierName} | Location: ${s.location} | Product: ${s.productTitle} | Price: ${s.priceRange} | ${s.moq ?? ""}$linkPart');
          }
        }
        buffer.writeln();
      }
      buffer.writeln('Compare the above sections by Price. Say which has the lowest/highest or summarize.');
    } else {
      final fromLiveSearch = liveSellers != null && liveSellers.isNotEmpty;
      final sellers = fromLiveSearch ? liveSellers.take(maxResults).toList() : <AiChatSeller>[];

      if (sellers.isNotEmpty) {
        buffer.writeln(
            'Live search results from IndiaMART for "$query". List sellers with Name, Location, Product, Price, MOQ, Link. When the user asks to compare prices between two sellers, use the Price field and name both sellers with their prices.');
        buffer.writeln();
        for (final s in sellers) {
          final linkPart = (s.url != null && s.url!.isNotEmpty) ? ' Link: ${s.url}' : '';
          buffer.writeln(
              '- ${s.supplierName} | Location: ${s.location} | Product: ${s.productTitle} | Price: ${s.priceRange} | ${s.moq ?? ""}$linkPart');
        }
        buffer.writeln();
      } else {
        buffer.writeln(
            'No IndiaMART listing results found for "$query". Suggest the user try: different product keywords, or add a city. Do not invent or list any sellers.');
      }
    }

    // FAQ: when query looks like a question or matches FAQ keywords
    final isQuestion = q.contains('?') ||
        q.contains('what ') ||
        q.contains('how ') ||
        q.contains('can i') ||
        q.contains('why ') ||
        q.contains('when ');
    if (isQuestion) {
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

    return buffer.toString();
  }

  /// When the API is unavailable (e.g. 429), format [contextString] into a short reply.
  static String fallbackReplyFromContext(String contextString) {
    final lines = contextString.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (lines.isEmpty) {
      return 'I couldn\'t reach the AI right now. Try again in a moment or rephrase your search.';
    }
    final buffer = StringBuffer();
    final sellerLines = lines.where((l) => l.startsWith('- ') && l.contains(',')).take(5).toList();
    final faqAnswers = <String>[];
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('A: ')) faqAnswers.add(lines[i].substring(3).trim());
    }
    if (sellerLines.isNotEmpty) {
      buffer.writeln('Here’s what we have from our database (tap a link to open):');
      for (final line in sellerLines) {
        buffer.writeln(line.substring(2)); // drop "- " (keeps "Link: https://..." in line)
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
