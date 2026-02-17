/// Gemini API configuration.
/// For production, use --dart-define=GEMINI_API_KEY=your_key or env.
class AiConfig {
  AiConfig._();

  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyDIf5zRFeM9j1QUhx5MAq8m6qZjycJMGEo',
  );

  static const String geminiModel = 'gemini-2.5-flash';
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
}
