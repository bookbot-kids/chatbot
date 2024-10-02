import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatbot/chatbot.dart';

void main() {
  setUpAll(() async {
    dotenv.testLoad(fileInput: File('.env').readAsStringSync());
  });

  const modelConfig = ServiceConfig(enableLog: true);

  test('run ChatGPT prompt', () async {
    final LLM model =
        ChatGPT(key: dotenv.env['CHATGPT_KEY']!, serviceConfig: modelConfig);
    final promptConfig = GPT4Config(user: 'user');
    final response = (await model.generateText(
            LLMMessage(
                message:
                    'Translate the following to Bahasa Indonesia: I love you. Only give the Bahasa Indonesia translation without explanation'),
            promptConfig))
        .toList();
    debugPrint('ChatGPT response: ${response.join('\n')}');
    expect(response.isNotEmpty, true);
  });

  test('run claude prompt', () async {
    final LLM model =
        Claude(key: dotenv.env['CLAUDE_KEY']!, serviceConfig: modelConfig);
    final promptConfig = DefaultClaudeConfig();
    final response = (await model.generateText(
            LLMMessage(
                message:
                    'Translate the following to Bahasa Indonesia: I love you. Only give the Bahasa Indonesia translation without explanation'),
            promptConfig))
        .toList();
    debugPrint('claude response: ${response.join('\n')}');
    expect(response.isNotEmpty, true);
  });

  test('run ChatGPT image prompt', () async {
    final LLM model =
        ChatGPT(key: dotenv.env['CHATGPT_KEY']!, serviceConfig: modelConfig);
    final promptConfig = GPT4Config(
        engine: 'dall-e-3',
        user: 'user',
        imageModel: 'dall-e-3',
        imageSize: '1024');
    final response =
        (await model.generateImage('draw a robot image', promptConfig))
            .toList();
    debugPrint('ChatGPT response: ${response.join('\n')}');
    expect(response.isNotEmpty, true);
  });

  test('run ChatGPT conversation', () async {
    final LLM model =
        ChatGPT(key: dotenv.env['CHATGPT_KEY']!, serviceConfig: modelConfig);
    final promptConfig = GPT4Config();
    final conversations = <LLMMessage>[];
    conversations.add(
        LLMMessage(message: 'Who won the world series in 2020?', role: 'user'));
    final answer1 =
        await model.generateConversation(conversations, promptConfig);
    debugPrint('ChatGPT response: ${answer1.join('\n')}');
    expect(answer1.isNotEmpty, true);
    conversations.add(LLMMessage(message: answer1.first, role: 'assistant'));
    conversations
        .add(LLMMessage(message: 'Where was it played?', role: 'user'));
    final answer2 =
        await model.generateConversation(conversations, promptConfig);
    debugPrint('ChatGPT response: ${answer2.join('\n')}');
    expect(answer2.isNotEmpty, true);
  });

  test('run Claude conversation', () async {
    final LLM model =
        Claude(key: dotenv.env['CLAUDE_KEY']!, serviceConfig: modelConfig);
    final promptConfig = DefaultClaudeConfig();
    final conversations = <LLMMessage>[];
    conversations.add(
        LLMMessage(message: 'Who won the world series in 2020?', role: 'user'));
    final answer1 =
        await model.generateConversation(conversations, promptConfig);
    debugPrint('Claude response: ${answer1.join('\n')}');
    expect(answer1.isNotEmpty, true);
    conversations.add(LLMMessage(message: answer1.first, role: 'assistant'));
    conversations
        .add(LLMMessage(message: 'Where was it played?', role: 'user'));
    final answer2 =
        await model.generateConversation(conversations, promptConfig);
    debugPrint('Claude response: ${answer2.join('\n')}');
    expect(answer2.isNotEmpty, true);
  });

  test('run ChatGPT stream', () async {
    final LLM model =
        ChatGPT(key: dotenv.env['CHATGPT_KEY']!, serviceConfig: modelConfig);
    final promptConfig = GPT4Config();
    final conversations = <LLMMessage>[];
    conversations
        .add(LLMMessage(message: 'Tell a short funny story', role: 'user'));
    final completer = Completer<void>();
    final resultMessages = <String>[];
    final stream = model.generateStream(conversations, promptConfig);
    stream.listen((data) {
      debugPrint('ChatGPT stream response: ${data.first}');
      resultMessages.addAll(data);
    }, onError: (e) => completer.complete(), onDone: completer.complete);
    await completer.future;
    expect(resultMessages.isNotEmpty, true);
  });

  test('run Claude stream', () async {
    final LLM model =
        Claude(key: dotenv.env['CLAUDE_KEY']!, serviceConfig: modelConfig);
    final promptConfig = DefaultClaudeConfig();
    final conversations = <LLMMessage>[];
    conversations
        .add(LLMMessage(message: 'Tell a short funny story', role: 'user'));
    final completer = Completer<void>();
    final resultMessages = <String>[];
    final stream = model.generateStream(conversations, promptConfig);
    stream.listen((data) {
      debugPrint('Claude stream response: ${data.first}');
      resultMessages.addAll(data);
    }, onError: (e) => completer.complete(), onDone: completer.complete);
    await completer.future;
    expect(resultMessages.isNotEmpty, true);
  });
}
