import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/ai_config.dart';
import 'ai_chat_context.dart';

/// Calls Gemini generateContent API with context from mock data.
class GeminiChatService {
  GeminiChatService._();

  static final _client = http.Client();

  static const _systemPromptPrefix = '''
You are a helpful B2B marketplace assistant for IndiaMART. Answer in 2-4 short sentences. Be friendly and concise.
Use ONLY the context below to answer. If the context does not contain the answer, say so and suggest the user try the search or Get Instant Quotes.
Do not make up seller names, prices, or locations.
''';

  /// Sends [userMessage] to Gemini with [contextFromMockData] and returns the model's reply.
  /// Returns null on network/API error.
  static Future<String?> getReply({
    required String userMessage,
    required String contextFromMockData,
  }) async {
    final url = Uri.parse(
    '${AiConfig.geminiBaseUrl}/models/'
    '${AiConfig.geminiModel}:generateContent'
    '?key=${AiConfig.geminiApiKey}',
  );

    final systemText = '$_systemPromptPrefix\n\nContext:\n$contextFromMockData';

    final body = {
      'systemInstruction': {
        'parts': [
          {'text': systemText}
        ]
      },
      'contents': [
        {
          'parts': [
            {'text': userMessage}
          ]
        }
      ],
      'generationConfig': {
        'maxOutputTokens': 256,
        'temperature': 0.4,
      }
    };

    const headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response = await _client
          .post(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      // Retry once after a short delay on 429 (rate limit)
      if (response.statusCode == 429) {
        await Future<void>.delayed(const Duration(seconds: 3));
        response = await _client
            .post(
              url,
              headers: headers,
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 30));
      }

      if (response.statusCode == 429) {
        return AiChatContext.fallbackReplyFromContext(contextFromMockData);
      }
      if (response.statusCode != 200) {
        return 'Sorry, the assistant could not respond (${response.statusCode}). Please try again.';
      }

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = map['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        final blockReason = map['promptFeedback']?['blockReason'];
        return blockReason != null
            ? 'Request was blocked. Please rephrase.'
            : 'No response from the assistant. Try again.';
      }

      final parts = candidates.first['content']?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) return null;

      final text = parts.first['text'] as String?;
      return text?.trim() ?? null;
    } catch (e) {
      // Network/timeout/parse error: still show an answer from our data
      return AiChatContext.fallbackReplyFromContext(contextFromMockData);
    }
  }
}
