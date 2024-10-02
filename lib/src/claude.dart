import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart' as sdk;
import 'package:chatbot/src/llm.dart';
import 'package:chatbot/src/prompt_config.dart';
import 'package:anthropic_dart/anthropic_dart.dart';

/// Claude service
class Claude extends LLM {
  late AnthropicService service;
  late sdk.AnthropicClient serviceSdk;

  Claude({required super.key, super.serviceConfig}) {
    service = AnthropicService(key);
    serviceSdk = sdk.AnthropicClient(apiKey: key);
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

  @override
  Stream<Iterable<String>> generateStream(
      List<LLMMessage> messages, PromptConfig config) {
    final conversations = messages.map((e) {
      final sdk.MessageRole role;
      if (e.role == 'assistant') {
        role = sdk.MessageRole.assistant;
      } else {
        role = sdk.MessageRole.user;
      }

      return sdk.Message(
          content: sdk.MessageContent.text(e.message), role: role);
    }).toList();
    final request = sdk.CreateMessageRequest(
        model: sdk.Model.modelId(config.engine),
        maxTokens: config.maxTokens ?? 4096,
        messages: conversations);
    final stream = serviceSdk.createMessageStream(request: request);
    return stream.map((data) {
      final result = data.map(
            messageStart: (sdk.MessageStartEvent v) {},
            messageDelta: (sdk.MessageDeltaEvent v) {},
            messageStop: (sdk.MessageStopEvent v) {},
            contentBlockStart: (sdk.ContentBlockStartEvent v) {},
            contentBlockDelta: (sdk.ContentBlockDeltaEvent v) {
              return v.delta.text;
            },
            contentBlockStop: (sdk.ContentBlockStopEvent v) {},
            ping: (sdk.PingEvent v) {},
          ) ??
          '';
      return [result];
    });
  }
}
