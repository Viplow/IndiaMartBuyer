import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../config/sdui_config.dart';

/// Production SDUI screen loader: fetches screen JSON from server with in-memory cache and asset fallback.
///
/// - When [SDUIConfig.sduiBaseUrl] is set, GET {baseUrl}/screens/{screenId} (or /app/screens/{screenId}).
/// - On success, response body must be JSON: `{"type":"HomeScreen","attributes":{...}}`.
/// - On failure (network, 4xx/5xx, invalid JSON) or when base URL is empty, loads from bundled asset.
/// - Results are cached in memory for the session to avoid refetch on back/navigation.
class SDUIScreenService {
  SDUIScreenService._();

  static const _screensPath = 'screens';
  static final _cache = <String, Map<String, dynamic>>{};

  /// Asset path for each screen id when server is unavailable.
  static const Map<String, String> _assetFallbacks = {
    'home': 'assets/sdui/home_screen.json',
    'sign-in': 'assets/sdui/sign_in_screen.json',
    'login': 'assets/sdui/login_screen.json',
    'listing': 'assets/sdui/listing_screen.json',
  };

  /// Returns screen JSON for [screenId]. Tries server first when configured, then asset fallback. Cached per [screenId].
  static Future<Map<String, dynamic>> getScreen(String screenId) async {
    final cached = _cache[screenId];
    if (cached != null) return cached;

    if (SDUIConfig.useServerSdui) {
      try {
        final json = await _fetchFromServer(screenId);
        if (json != null && _isValidScreenJson(json)) {
          _cache[screenId] = json;
          return json;
        }
      } catch (_) {
        // Fall through to asset
      }
    }

    final assetPath = _assetFallbacks[screenId] ?? 'assets/sdui/${screenId}_screen.json';
    final json = await _loadFromAsset(assetPath);
    _cache[screenId] = json;
    return json;
  }

  /// Clears in-memory cache (e.g. after logout or when forcing refresh).
  static void clearCache() {
    _cache.clear();
  }

  static Future<Map<String, dynamic>?> _fetchFromServer(String screenId) async {
    final base = SDUIConfig.sduiBaseUrl.replaceAll(RegExp(r'/$'), '');
    final url = '$base/$_screensPath/$screenId';
    final uri = Uri.parse(url);
    final headers = <String, String>{
      'Accept': 'application/json',
      'User-Agent': 'B2BMarketplace/1.0',
    };
    if (SDUIConfig.sduiApiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${SDUIConfig.sduiApiKey}';
    }
    final response = await http
        .get(uri, headers: headers)
        .timeout(SDUIConfig.sduiTimeout);
    if (response.statusCode != 200) return null;
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return null;
    return decoded;
  }

  static bool _isValidScreenJson(Map<String, dynamic> json) {
    return json.containsKey('type') && json['type'] is String;
  }

  static Future<Map<String, dynamic>> _loadFromAsset(String assetPath) async {
    try {
      final str = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(str);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      // Return minimal valid screen so app doesn't crash
    }
    return const {'type': 'HomeScreen', 'attributes': {'userName': ''}};
  }
}

