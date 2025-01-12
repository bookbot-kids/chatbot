import 'package:universal_chatbot/src/service_config.dart';
import 'package:universal_chatbot/src/prompt_config.dart';

/// LLM conversation message
/// Default role is user
class LLMMessage {
  /// Prompt message
  final String message;

  /// User or System role
  final String role;

  LLMMessage({required this.message, this.role = 'user'});
}

/// Abstract LLM class
/// Each service has its own implementation and configuration
abstract class LLM {
  /// API Key for service
  final String key;

  /// Config for service
  final ServiceConfig serviceConfig;

  /// Initialize with key and default service configurations
  LLM({required this.key, this.serviceConfig = const ServiceConfig()});

  /// Generate text from AI service, given prompt and configs
  /// Return list of string result
  Future<Iterable<String>> generateText(
      LLMMessage message, PromptConfig config);

  /// Generate image from AI service, given prompt and configs
  /// Return list of base64 file string
  Future<Iterable<String>> generateImage(String prompt, PromptConfig config);

  /// Generate conversation and keep thread going
  /// Each message has its own role, usually the AI role is assistant
  Future<Iterable<String>> generateConversation(
      List<LLMMessage> messages, PromptConfig config);

  /// Generate conversation stream
  /// Each message has its own role, usually the AI role is assistant
  Stream<Iterable<String>> generateStream(
      List<LLMMessage> messages, PromptConfig config);
}
