/// LLM Gateway API configuration.
/// Use --dart-define=LLM_GATEWAY_KEY=your_key for the Bearer token.
class AiConfig {
  AiConfig._();

  static const String llmGatewayKey = String.fromEnvironment(
    'LLM_GATEWAY_KEY',
    defaultValue: '',
  );

  static const String llmGatewayBaseUrl = 'https://imllm.intermesh.net';
  static const String llmGatewayModel = 'google/gemini-2.5-flash';
}
