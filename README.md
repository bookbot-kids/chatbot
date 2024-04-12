The Flutter Chatbot package is a comprehensive solution that enables developers to integrate various AI services seamlessly into their Flutter applications. With this package, you can harness the power of cutting-edge language models and image generation capabilities from renowned AI providers such as OpenAI, Anthropic, GitHub Copilot, and more, all within a single, unified interface.

## Features
- Multi-Service Integration: Leverage the strengths of multiple AI services, including text generation, image generation, and more, through a single package.
- Seamless Integration: Easily incorporate AI capabilities into your Flutter applications with a user-friendly API.
- Flexible Configuration: Customize the package's behavior and settings to suit your specific project requirements.
- Cross-Platform Support: Develop AI-enabled applications that run seamlessly on both iOS and Android platforms.

## Getting started

To get started with the Flutter Chatbot package, follow these steps:

Add the package to your Flutter project's dependencies:
```
dependencies:
  chatbot: ^0.0.1
```

Run the package installation command:

```
flutter pub get
```

Import the package in your Dart file:
```
import 'package:chatbot/chatbot.dart';
```

## Usage

Here's an example of how to generate text using the package:

```dart
// chatgpt
final LLM model =
        ChatGPT(key: 'YOUR_CHATGPT_KEY', serviceConfig: modelConfig);
final promptConfig = GPT4Config(user: 'user');
final response = await model.generateText('Translate the following to Bahasa Indonesia: I love you. Only give the Bahasa Indonesia translation without explanation', promptConfig);

// claude
final LLM model =
        Claude(key: 'YOUR_CLAUDE_KEY', serviceConfig: modelConfig);
    final promptConfig = DefaultClaudeConfig();
    final response = await model.generateText(
            'Translate the following to Bahasa Indonesia: I love you. Only give the Bahasa Indonesia translation without explanation',
            promptConfig);
```

You can also generate images by providing a text description:
```dart
 final LLM model =
        ChatGPT(key: 'YOUR_CHATGPT_KEY', serviceConfig: modelConfig);
    final promptConfig = GPT4Config(
        engine: 'dall-e-3',
        user: 'user',
        imageModel: 'dall-e-3',
        imageSize: '1024');
    final response = await model.generateImage('draw a robot image', promptConfig);
```

## Issues and Feedback

Please file any issues, bugs, or feature requests in the [issue tracker](https://github.com/bookbot-kids/chatbot/issues).

## License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
