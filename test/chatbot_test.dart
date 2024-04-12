import 'dart:io';
import 'package:chatbot/src/llm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatbot/chatbot.dart';

void main() {
  setUpAll(() async {
    dotenv.testLoad(fileInput: File('.env').readAsStringSync());
  });

  const prompt =
      'Translate the following to Bahasa Indonesia: I love you. Only give the Bahasa Indonesia translation without explanation';
  const modelConfig = ServiceConfig(enableLog: true);

  test('run ChatGPT prompt', () async {
    final LLM model =
        ChatGPT(key: dotenv.env['CHATGPT_KEY']!, serviceConfig: modelConfig);
    final promptConfig = GPT4Config(user: 'user');
    final response = (await model.generate(prompt, promptConfig)).toList();
    debugPrint('ChatGPT response: ${response.join('\n')}');
    expect(response.isNotEmpty, true);
    expect(response.first, equals('Aku cinta kamu.'));
  });

  test('run claude prompt', () async {
    final LLM model =
        Claude(key: dotenv.env['CLAUDE_KEY']!, serviceConfig: modelConfig);
    final promptConfig = DefaultClaudeConfig();
    final response = (await model.generate(prompt, promptConfig)).toList();
    debugPrint('claude response: ${response.join('\n')}');
    expect(response.isNotEmpty, true);
    expect(response.first, equals('Aku cinta kamu.'));
  });
}