import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:universal_chatbot/src/llm.dart';
import 'package:universal_chatbot/src/prompt_config.dart';

/// ChatGPT service
/// The ChatGPT class extends the LLM class and provides methods for generating text, images, and conversations using the ChatGPT model.
/// It implements the generateConversation method to generate a conversation based on the given messages.
class ChatGPT extends LLM {
  late OpenAI openAI;
  ChatGPT({required super.key, super.serviceConfig}) {
    openAI = OpenAI.instance.build(
        token: key,
        baseOption: HttpSetup(
            receiveTimeout: serviceConfig.receiveTimeout,
            connectTimeout: serviceConfig.connectTimeout),
        enableLog: serviceConfig.enableLog);
  }

  @override

  /// Generates a text response based on the given message using the ChatGPT model.
  ///
  /// This function sends a completion request to the ChatGPT model using the specified
  /// [message] and [config]. The message is expected to have a role of either 'assistant'
  /// or 'user'. The [config] parameter allows customization of the model's behavior,
  /// including maximum tokens, temperature, and other generation parameters.
  ///
  /// Returns an iterable of strings representing the generated text.

  Future<Iterable<String>> generateText(
      LLMMessage message, PromptConfig config) async {
    final conversations = {'content': message.message, 'role': message.role};
    final request = ChatCompleteText(
        messages: [conversations],
        maxToken: config.maxTokens,
        temperature: config.temperature,
        topP: config.topP,
        n: config.n,
        stream: config.stream,
        stop: config.stop,
        presencePenalty: config.presencePenalty,
        frequencyPenalty: config.frequencyPenalty,
        user: config.user,
        logprobs: config.logProbs,
        logitBias: config.logitBias,
        topLogprobs: config.topLogprobs,
        seed: config.seed,
        tools: config.tools,
        toolChoice: config.toolChoice,
        responseFormat: config.responseFormat != null
            ? ResponseFormat(type: config.responseFormat!)
            : null,
        model: ChatModelFromValue(model: config.engine));

    final response = await openAI.onChatCompletion(request: request);
    final choices = response?.choices ?? [];
    return choices.map((e) => e.message?.content ?? '');
  }

  @override

  /// Generates an image based on the given prompt using the ChatGPT model.
  ///
  /// This function sends a generate image request to the ChatGPT model using the
  /// specified [prompt] and [config]. The [config] parameter allows customization
  /// of the model's behavior, including the size of the generated image, the number
  /// of images to generate, and other generation parameters.
  ///
  /// Returns an iterable of strings representing the generated image data as a
  /// base64 encoded JSON string.
  Future<Iterable<String>> generateImage(
      String prompt, PromptConfig config) async {
    ImageSize size;
    switch (config.imageSize) {
      case '1024':
        size = ImageSize.size1024;
      case '512':
        size = ImageSize.size512;
      default:
        size = ImageSize.size256;
    }

    GenerateImageModel model;
    if (config.imageModel == 'DallE2') {
      model = DallE2();
    } else {
      model = DallE3();
    }

    final request = GenerateImage(
      model: model,
      prompt,
      config.n ?? 1,
      size: size,
      responseFormat: Format.b64Json,
      user: config.user ?? '',
    );

    final response = await openAI.generateImage(request);
    final data = response?.data?.nonNulls.toList() ?? [];
    return data.map((e) => e.b64Json ?? '');
  }

  @override

  /// Generates a conversation based on the provided messages using the ChatGPT model.
  ///
  /// This function takes a list of [messages] and a [config] to customize the conversation
  /// generation process. Each message should have a 'content' and a 'role' (e.g., 'user' or 'assistant').
  /// The [config] allows various parameters to be set, such as maximum tokens, temperature, topP,
  /// and penalties to influence the model's responses.
  ///
  /// Returns an iterable of strings, each representing a message generated by the model.
  ///
  /// [messages]: List of messages with content and role for initiating the conversation.
  /// [config]: Configuration settings for the conversation, including model parameters and
  /// generation behavior.

  Future<Iterable<String>> generateConversation(
      List<LLMMessage> messages, PromptConfig config) async {
    final conversations =
        messages.map((e) => {'content': e.message, 'role': e.role}).toList();
    final request = ChatCompleteText(
        messages: conversations,
        maxToken: config.maxTokens,
        temperature: config.temperature,
        topP: config.topP,
        n: config.n,
        stream: config.stream,
        stop: config.stop,
        presencePenalty: config.presencePenalty,
        frequencyPenalty: config.frequencyPenalty,
        user: config.user,
        logprobs: config.logProbs,
        logitBias: config.logitBias,
        topLogprobs: config.topLogprobs,
        seed: config.seed,
        tools: config.tools,
        toolChoice: config.toolChoice,
        responseFormat: config.responseFormat != null
            ? ResponseFormat(type: config.responseFormat!)
            : null,
        model: ChatModelFromValue(model: config.engine));

    final response = await openAI.onChatCompletion(request: request);
    final choices = response?.choices ?? [];
    return choices.map((e) => e.message?.content ?? '');
  }

  @override

  /// Generates a stream of strings based on the given messages using the ChatGPT model.
  ///
  /// This function takes a list of [messages] and a [config] to customize the conversation
  /// generation process. Each message should have a 'content' and a 'role' (e.g., 'user' or 'assistant').
  /// The [config] allows various parameters to be set, such as maximum tokens, temperature, topP,
  /// and penalties to influence the model's responses.
  ///
  /// Returns a stream of strings, each representing a message generated by the model.
  ///
  /// [messages]: List of messages with content and role for initiating the conversation.
  /// [config]: Configuration settings for the conversation, including model parameters and
  /// generation behavior.
  Stream<Iterable<String>> generateStream(
      List<LLMMessage> messages, PromptConfig config) {
    final conversations =
        messages.map((e) => {'content': e.message, 'role': e.role}).toList();
    final request = ChatCompleteText(
        messages: conversations,
        maxToken: config.maxTokens,
        temperature: config.temperature,
        topP: config.topP,
        n: config.n,
        stream: config.stream,
        stop: config.stop,
        presencePenalty: config.presencePenalty,
        frequencyPenalty: config.frequencyPenalty,
        user: config.user,
        logprobs: config.logProbs,
        logitBias: config.logitBias,
        topLogprobs: config.topLogprobs,
        seed: config.seed,
        tools: config.tools,
        toolChoice: config.toolChoice,
        responseFormat: config.responseFormat != null
            ? ResponseFormat(type: config.responseFormat!)
            : null,
        model: ChatModelFromValue(model: config.engine));

    final stream = openAI.onChatCompletionSSE(request: request);
    return stream.map((result) {
      return result.choices?.map((e) => e.message?.content ?? '') ?? [];
    });
  }
}
