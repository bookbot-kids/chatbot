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
  Future<Iterable<String>> generate(String prompt, PromptConfig config) async {
    final message = {'content': prompt};
    if (config.user != null) {
      message['role'] = config.user!;
    }

    final request = ChatCompleteText(
        messages: [message],
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
