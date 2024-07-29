import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatbot/src/llm.dart';
import 'package:chatbot/src/prompt_config.dart';

/// ChatGPT service
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
        model: ChatModelFromValue(model: config.engine));

    final response = await openAI.onChatCompletion(request: request);
    final choices = response?.choices ?? [];
    return choices.map((e) => e.message?.content ?? '');
  }

  @override
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
        model: ChatModelFromValue(model: config.engine));

    final response = await openAI.onChatCompletion(request: request);
    final choices = response?.choices ?? [];
    return choices.map((e) => e.message?.content ?? '');
  }
}
