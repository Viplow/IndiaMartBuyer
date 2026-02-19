import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/ai_config.dart';
import 'ai_chat_context.dart';

/// Result of extracting search intent from a user message. LLM is the single source of truth; no pattern matching.
class SearchIntent {
  final String? product;
  final String? location;
  /// Short phrase for web/search use (e.g. "paper bags jaipur", "sunglasses"). Use this for DuckDuckGo and slug building when present.
  final String? searchQuery;
  final String? comparison;
  final List<String> compareProducts;
  final List<String> compareLocations;

  const SearchIntent({
    this.product,
    this.location,
    this.searchQuery,
    this.comparison,
    this.compareProducts = const [],
    this.compareLocations = const [],
  });

  bool get hasAny => (product != null && product!.trim().isNotEmpty) ||
      (location != null && location!.trim().isNotEmpty) ||
      (searchQuery != null && searchQuery!.trim().isNotEmpty);
  bool get isCompareProducts => comparison == 'products' && compareProducts.length >= 2;
  bool get isCompareCities => comparison == 'cities' && compareLocations.length >= 2 && product != null && product!.trim().isNotEmpty;
  bool get isCompareSellers => comparison == 'sellers';
}

/// Calls LLM Gateway (OpenAI-compatible) with context from mock data.
class GeminiChatService {
  GeminiChatService._();

  static final _client = http.Client();

  static const _extractIntentPrompt = '''
You understand what the user wants for a B2B marketplace (India). The user can type ANYTHING: any language, any phrasing.

Important: Product + city can appear WITH or WITHOUT "in". Treat the same:
- "ps sellers noida" = product "ps" or "ps sellers", location "noida"
- "ps sellers in noida" = same
- "rice delhi", "rice in delhi" = product "rice", location "delhi"
- "steel mumbai", "paper bag jaipur" = product + location (last word or two is often the city)
Common Indian cities: Noida, Delhi, Mumbai, Bangalore, Chennai, Kolkata, Hyderabad, Pune, Jaipur, Kanpur, Ahmedabad, etc. If the last word (or two) is a city name, set it as location and the rest as product.

Always return:
1. product: what they want to buy (1-4 words, English). Empty if not clear.
2. location: city/place if mentioned. Empty if not.
3. searchQuery: short phrase for search (product + location). E.g. "ps noida", "rice delhi", "paper bags jaipur".

If the user wants to COMPARE:
- Compare two or more products (e.g. "compare rice and lentils"): "comparison":"products", "compareProducts":["rice","lentils"].
- Compare same product in different cities (e.g. "rice in kanpur vs delhi"): "comparison":"cities", "product":"rice", "compareLocations":["kanpur","delhi"].
- Compare two sellers: "comparison":"sellers", "product":"rice".
Otherwise omit comparison, compareProducts, compareLocations.

Reply with ONLY valid JSON. No markdown, no explanation. Example: {"product":"paper bag","location":"jaipur","searchQuery":"paper bags jaipur"}
''';

  /// Calls the LLM once to extract product and location from [userQuery]. Works with any language or informal phrasing.
  /// Returns empty intent when LLM is unavailable or response is not parseable.
  static Future<SearchIntent> extractSearchIntent(String userQuery) async {
    final q = userQuery.trim();
    if (q.isEmpty) return const SearchIntent();

    final url = Uri.parse('${AiConfig.llmGatewayBaseUrl}/v1/chat/completions');
    final body = {
      'model': AiConfig.llmGatewayModel,
      'messages': [
        {'role': 'system', 'content': _extractIntentPrompt},
        {'role': 'user', 'content': q},
      ],
      'max_tokens': 150,
      'temperature': 0.1,
    };
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AiConfig.llmGatewayKey}',
    };

    try {
      final response = await _client
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return const SearchIntent();

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = map['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) return const SearchIntent();

      final message = choices.first['message'] as Map<String, dynamic>?;
      final text = message?['content'] as String?;
      if (text == null || text.trim().isEmpty) return const SearchIntent();

      return _parseIntentResponse(text.trim());
    } catch (_) {
      return const SearchIntent();
    }
  }

  static SearchIntent _parseIntentResponse(String text) {
    String? product;
    String? location;
    String? searchQuery;
    String? comparison;
    List<String> compareProducts = [];
    List<String> compareLocations = [];

    String extractJson(String raw) {
      final block = RegExp(r'```(?:json)?\s*([\s\S]*?)```').firstMatch(raw);
      if (block != null) return block.group(1)!.trim();
      final brace = RegExp(r'\{[\s\S]*\}').firstMatch(raw);
      return brace?.group(0) ?? raw;
    }

    try {
      final jsonStr = extractJson(text);
      final obj = jsonDecode(jsonStr) as Map<String, dynamic>;
      product = obj['product']?.toString().trim();
      location = obj['location']?.toString().trim();
      searchQuery = obj['searchQuery']?.toString().trim();
      if (product != null && product!.isEmpty) product = null;
      if (location != null && location!.isEmpty) location = null;
      if (searchQuery != null && searchQuery!.isEmpty) searchQuery = null;
      comparison = obj['comparison']?.toString().trim();
      if (comparison != null && comparison!.isEmpty) comparison = null;
      final cp = obj['compareProducts'];
      if (cp is List) compareProducts = cp.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
      final cl = obj['compareLocations'];
      if (cl is List) compareLocations = cl.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
      if (searchQuery == null && (product != null || location != null)) {
        searchQuery = [product, location].where((e) => e != null && e.isNotEmpty).join(' ');
      }
      return SearchIntent(
        product: product,
        location: location,
        searchQuery: searchQuery,
        comparison: comparison,
        compareProducts: compareProducts,
        compareLocations: compareLocations,
      );
    } catch (_) {}

    final productMatch = RegExp(r'"product"\s*:\s*"([^"]*)"', caseSensitive: false).firstMatch(text);
    final locationMatch = RegExp(r'"location"\s*:\s*"([^"]*)"', caseSensitive: false).firstMatch(text);
    final searchQueryMatch = RegExp(r'"searchQuery"\s*:\s*"([^"]*)"', caseSensitive: false).firstMatch(text);
    if (productMatch != null) product = productMatch.group(1)?.trim();
    if (locationMatch != null) location = locationMatch.group(1)?.trim();
    if (searchQueryMatch != null) searchQuery = searchQueryMatch.group(1)?.trim();
    if (product != null && product!.isEmpty) product = null;
    if (location != null && location!.isEmpty) location = null;
    if (searchQuery != null && searchQuery!.isEmpty) searchQuery = null;
    if (searchQuery == null && (product != null || location != null)) {
      searchQuery = [product, location].where((e) => e != null && e.isNotEmpty).join(' ');
    }
    return SearchIntent(product: product, location: location, searchQuery: searchQuery);
  }

  static const _systemPromptPrefix = '''
You are a helpful B2B marketplace assistant for IndiaMART. Be friendly and concise.
Use ONLY the context below to answer.

PRICES: Always show the Price for each seller when the context provides it. Do not make up prices.

COMPARISON (when context has multiple sections or user asks to compare): Always show the comparison in a TABLE format.
Format as a markdown table with pipes. CRITICAL: each table ROW must be on a SINGLE line (all cells in one line separated by |). Do NOT put each cell on its own line.
Example for comparing cities (one line per row):
| City | Price | Link |
|----|----|----|
| Delhi | ₹92 | https://www.indiamart.com/... |
| Kanpur | ₹95 | https://www.indiamart.com/... |

Use 3–4 columns: City/Product/Seller, Price, Location (if useful), Link (full URL). One line per row. After the table add one short summary line (e.g. "Rice prices are lower in Delhi.").
- Comparing PRODUCTS: one row per product with price and link on the same line.
- Comparing CITIES: one row per city with price and link on the same line.
- Comparing SELLERS: one row per seller with price and link on the same line.
Always include the full Link URL in the table so the user can tap to open.

LISTING: When the context lists sellers, list up to 5 with: Supplier Name, Location, Product, Price, MOQ (if any), and full Link.

Do not invent seller names, prices, or locations. If the context has no data, suggest trying search or Get Instant Quotes.
''';

  /// Sends [userMessage] to the LLM with [contextFromMockData] and returns the model's reply.
  /// Returns null on network/API error.
  static Future<String?> getReply({
    required String userMessage,
    required String contextFromMockData,
  }) async {
    final url = Uri.parse('${AiConfig.llmGatewayBaseUrl}/v1/chat/completions');

    final systemText = '$_systemPromptPrefix\n\nContext:\n$contextFromMockData';

    final body = {
      'model': AiConfig.llmGatewayModel,
      'messages': [
        {'role': 'system', 'content': systemText},
        {'role': 'user', 'content': userMessage},
      ],
      'max_tokens': 512,
      'temperature': 0.7,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AiConfig.llmGatewayKey}',
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
      final choices = map['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        final err = map['error'] as Map<String, dynamic>?;
        final msg = err?['message'] as String?;
        return msg != null ? 'Request failed: $msg' : 'No response from the assistant. Try again.';
      }

      final message = choices.first['message'] as Map<String, dynamic>?;
      final text = message?['content'] as String?;
      return text?.trim() ?? null;
    } catch (e) {
      // Network/timeout/parse error: still show an answer from our data
      return AiChatContext.fallbackReplyFromContext(contextFromMockData);
    }
  }
}
