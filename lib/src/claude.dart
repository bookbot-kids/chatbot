import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:chatbot/src/llm.dart';
import 'package:chatbot/src/prompt_config.dart';

/// Claude service
class Claude extends LLM {
  late AnthropicClient serviceSdk;

  Claude({required super.key, super.serviceConfig}) {
    serviceSdk = AnthropicClient(apiKey: key);
  }

  @override
  Future<Iterable<String>> generateText(
      LLMMessage message, PromptConfig config) async {
    final MessageRole role;
    if (message.role == 'assistant') {
      role = MessageRole.assistant;
    } else {
      role = MessageRole.user;
    }

    final toolChoice = config.toolChoice != null
        ? ToolChoice.fromJson(config.toolChoice)
        : null;
    final tools = config.tools?.map(Tool.fromJson).toList();
    final request = CreateMessageRequest(
      model: Model.modelId(config.engine),
      maxTokens: config.maxTokens ?? 4096,
      messages: [
        Message(content: MessageContent.text(message.message), role: role)
      ],
      toolChoice: toolChoice,
      tools: tools,
    );

    final response = await serviceSdk.createMessage(request: request);
    return [response.content.text];
  }

  @override
  Future<Iterable<String>> generateImage(String prompt, PromptConfig config) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<String>> generateConversation(
      List<LLMMessage> messages, PromptConfig config) async {
    final conversations = messages.map((e) {
      final MessageRole role;
      if (e.role == 'assistant') {
        role = MessageRole.assistant;
      } else {
        role = MessageRole.user;
      }

      return Message(content: MessageContent.text(e.message), role: role);
    }).toList();

    final toolChoice = config.toolChoice != null
        ? ToolChoice.fromJson(config.toolChoice)
        : null;
    final tools = config.tools?.map(Tool.fromJson).toList();
    final request = CreateMessageRequest(
      model: Model.modelId(config.engine),
      maxTokens: config.maxTokens ?? 4096,
      messages: conversations,
      toolChoice: toolChoice,
      tools: tools,
    );

    final response = await serviceSdk.createMessage(request: request);
    return [response.content.text];
  }

  @override
  Stream<Iterable<String>> generateStream(
      List<LLMMessage> messages, PromptConfig config) {
    final conversations = messages.map((e) {
      final MessageRole role;
      if (e.role == 'assistant') {
        role = MessageRole.assistant;
      } else {
        role = MessageRole.user;
      }

      return Message(content: MessageContent.text(e.message), role: role);
    }).toList();
    final toolChoice = config.toolChoice != null
        ? ToolChoice.fromJson(config.toolChoice)
        : null;
    final tools = config.tools?.map(Tool.fromJson).toList();
    final request = CreateMessageRequest(
      model: Model.modelId(config.engine),
      maxTokens: config.maxTokens ?? 4096,
      messages: conversations,
      toolChoice: toolChoice,
      tools: tools,
    );
    final stream = serviceSdk.createMessageStream(request: request);
    return stream.map((data) {
      final result = data.map(
            messageStart: (MessageStartEvent v) {},
            messageDelta: (MessageDeltaEvent v) {},
            messageStop: (MessageStopEvent v) {},
            contentBlockStart: (ContentBlockStartEvent v) {},
            contentBlockDelta: (ContentBlockDeltaEvent v) {
              return v.delta.text;
            },
            contentBlockStop: (ContentBlockStopEvent v) {},
            ping: (PingEvent v) {},
          ) ??
          '';
      return [result];
    });
  }
}
