/// SDUI (Server-Driven UI) configuration for production.
///
/// Set [sduiBaseUrl] at build time or leave empty to use bundled assets only:
///   flutter run --dart-define=SDUI_BASE_URL=https://api.example.com
///   flutter build apk --dart-define=SDUI_BASE_URL=https://api.example.com
///
/// Optional [sduiApiKey] for authenticated screen endpoints (e.g. Bearer or X-API-Key).
class SDUIConfig {
  SDUIConfig._();

  /// Base URL for SDUI screen API (no trailing slash). Empty = use assets only.
  static const String sduiBaseUrl = String.fromEnvironment(
    'SDUI_BASE_URL',
    defaultValue: '',
  );

  /// Optional API key for SDUI requests (e.g. Bearer token or X-API-Key value).
  static const String sduiApiKey = String.fromEnvironment(
    'SDUI_API_KEY',
    defaultValue: '',
  );

  /// Request timeout for fetching a screen.
  static const Duration sduiTimeout = Duration(seconds: 10);

  /// Whether to use server-driven screens (base URL is set).
  static bool get useServerSdui => sduiBaseUrl.isNotEmpty;
}
