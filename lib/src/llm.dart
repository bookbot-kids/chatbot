import 'package:chatbot/src/service_config.dart';
import 'package:chatbot/src/prompt_config.dart';

/// Abstract LLM class
abstract class LLM {
  /// API Key for service
  final String key;

  /// Config for service
  final ServiceConfig serviceConfig;

  LLM({required this.key, this.serviceConfig = const ServiceConfig()});

  /// Generate text from AI service, given prompt and configs
  /// Return list of string result
  Future<Iterable<String>> generate(String prompt, PromptConfig config);
}