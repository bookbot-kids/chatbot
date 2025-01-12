import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:universal_chatbot/src/llm.dart';
import 'package:universal_chatbot/src/prompt_config.dart';

/// Claude service
/// The Claude class extends the LLM class and provides methods for generating text, images, and conversations using the Claude model.
/// It implements the generateConversation method to generate a conversation based on the given messages.
class Claude extends LLM {
  late AnthropicClient serviceSdk;

  Claude({required super.key, super.serviceConfig}) {
    serviceSdk = AnthropicClient(apiKey: key);
  }

  @override

  /// Generate a text response to the given message.
  ///
  /// The message is expected to have a role of either 'assistant' or 'user'.
  /// The response will be a single string.
  ///
  /// The [config] parameter is used to set the model and other parameters
  /// for the generation request.
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

  /// Generate an image based on the provided text prompt.
  ///
  /// This method takes a [prompt] describing the desired image and a
  /// [config] for configuring the prompt settings. It returns a future
  /// containing an iterable of strings, which represent the generated
  /// image data.

  Future<Iterable<String>> generateImage(String prompt, PromptConfig config) {
    throw UnimplementedError();
  }

  @override

  /// Generate a conversation based on the given messages.
  ///
  /// The messages are expected to have either 'assistant' or 'user' as their role.
  /// The response will be a single string.
  ///
  /// The [config] parameter is used to set the model and other parameters
  /// for the generation request.
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

  /// Generate a stream of strings based on the given messages.
  ///
  /// The messages are expected to have either 'assistant' or 'user' as their role.
  /// The response will be a stream of strings, where each string is a generated
  /// continuation of the conversation.
  ///
  /// The [config] parameter is used to set the model and other parameters
  /// for the generation request.
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
            error: (ErrorEvent value) {},
          ) ??
          '';
      return [result];
    });
  }
}
