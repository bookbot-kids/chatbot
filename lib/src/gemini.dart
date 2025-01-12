import 'package:chatbot/src/llm.dart';
import 'package:chatbot/src/prompt_config.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

/// The GeminiClient class extends the LLM class and provides methods for interacting with the Gemini AI model.
class GeminiClient extends LLM {
  GeminiClient({required super.key, super.serviceConfig}) {
    Gemini.init(apiKey: key);
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

  /// Generate an image based on the given prompt.
  ///
  /// The [prompt] parameter is a text description of the image to be generated.
  ///
  /// The [config] parameter is used to set the model and other parameters
  /// for the generation request.
  ///
  /// The response will be a list of strings, each string being a URI that can be used to access the generated image.
  Future<Iterable<String>> generateImage(
      String prompt, PromptConfig config) async {
    throw UnimplementedError();
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

  /// Generate a text response to the given message.
  ///
  /// The message is expected to have a role of either 'assistant' or 'user'.
  /// The response will be a single string.
  ///
  /// The [config] parameter is used to set the model and other parameters
  /// for the generation request.
  Future<Iterable<String>> generateText(
      LLMMessage message, PromptConfig config) async {
    final result = await Gemini.instance
        .prompt(parts: [Part.text(message.message)], model: config.engine);
    return [result?.output ?? ''];
  }
}
