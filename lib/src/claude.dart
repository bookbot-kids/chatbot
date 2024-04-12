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
  Future<Iterable<String>> generate(String prompt, PromptConfig config) async {
    final request = Request(
        model: config.engine,
        maxTokens: config.maxTokens,
        messages: [Message(role: 'user', content: prompt)]);
    final response = await service.sendRequest(
        request: request, debug: serviceConfig.enableLog);
    final content = response.content ?? [];
    return content.map((e) => e.text ?? '');
  }
}
