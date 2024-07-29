import 'package:chatbot/src/llm.dart';
import 'package:chatbot/src/prompt_config.dart';
import 'package:anthropic_dart/anthropic_dart.dart';

/// Claude service
class Claude extends LLM {
  late AnthropicService service;
  Claude({required super.key, super.serviceConfig}) {
    service = AnthropicService(key);
  }

  @override
  Future<Iterable<String>> generateText(
      LLMMessage message, PromptConfig config) async {
    final request = Request(
        model: config.engine,
        maxTokens: config.maxTokens,
        messages: [Message(role: message.role, content: message.message)]);
    final response = await service.sendRequest(
        request: request, debug: serviceConfig.enableLog);
    final content = response.content ?? [];
    return content.map((e) => e.text ?? '');
  }

  @override
  Future<Iterable<String>> generateImage(String prompt, PromptConfig config) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<String>> generateConversation(
      List<LLMMessage> messages, PromptConfig config) async {
    final conversations =
        messages.map((e) => Message(content: e.message, role: e.role)).toList();

    final request = Request(
        model: config.engine,
        maxTokens: config.maxTokens,
        messages: conversations);
    final response = await service.sendRequest(
        request: request, debug: serviceConfig.enableLog);
    final content = response.content ?? [];
    return content.map((e) => e.text ?? '');
  }
}
