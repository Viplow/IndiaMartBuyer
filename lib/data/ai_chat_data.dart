import 'dart:convert';

import 'package:flutter/services.dart';

import 'ai_chat_mock_data.dart';

/// Sellers for AI chat: from website only (assets/ai_chat_sellers.json via tool/fetch_indiamart_data.dart).
class AiChatData {
  AiChatData._();

  static List<AiChatSeller>? _scrapedSellers;

  /// Sellers from scraped website data only. Empty if JSON not loaded.
  static List<AiChatSeller> get sellers =>
      _scrapedSellers ?? <AiChatSeller>[];

  /// Load sellers from assets/ai_chat_sellers.json (run: dart run tool/fetch_indiamart_data.dart [categories]).
  static Future<void> loadScrapedSellers() async {
    try {
      final data = await rootBundle.load('assets/ai_chat_sellers.json');
      final json = utf8.decode(data.buffer.asUint8List());
      final decoded = jsonDecode(json) as List<dynamic>;
      final parsed = decoded
          .map((e) => AiChatSeller.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((s) =>
              s.supplierName.isNotEmpty &&
              s.category.isNotEmpty &&
              s.location.isNotEmpty)
          .toList();
      _scrapedSellers = parsed.isNotEmpty ? parsed : null;
    } catch (_) {
      _scrapedSellers = null;
    }
  }
}