import 'package:chatbot/src/llm.dart';
import 'package:chatbot/src/prompt_config.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiClient extends LLM {
  GeminiClient({required super.key, super.serviceConfig}) {
    Gemini.init(apiKey: key);
  }

  @override
  Future<Iterable<String>> generateConversation(
      List<LLMMessage> messages, PromptConfig config) async {
    final result = await Gemini.instance.chat(
        messages
            .map((e) => Content(
                  parts: [Part.text(e.message)],
                  role: e.role,
                ))
            .toList(),
        modelName: config.engine);
    return result?.content?.parts
            ?.map((e) => e as TextPart?)
            .map((e) => e?.text ?? '')
            .toList() ??
        [];
  }

  @override
  Future<Iterable<String>> generateImage(
      String prompt, PromptConfig config) async {
    throw UnimplementedError();
  }

  @override
  Stream<Iterable<String>> generateStream(
      List<LLMMessage> messages, PromptConfig config) {
    final stream = Gemini.instance.promptStream(
        parts: [Part.text(messages.last.message)], model: config.engine);
    return stream.map((e) {
      return e?.content?.parts
              ?.map((e) => e as TextPart?)
              .map((e) => e?.text ?? '')
              .toList() ??
          [];
    });
  }

  @override
  Future<Iterable<String>> generateText(
      LLMMessage message, PromptConfig config) async {
    final result = await Gemini.instance
        .prompt(parts: [Part.text(message.message)], model: config.engine);
    return [result?.output ?? ''];
  }
}
