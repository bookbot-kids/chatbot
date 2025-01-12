import 'package:flutter/material.dart';
import 'package:universal_chatbot/universal_chatbot.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal Chatbot Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Universal Chatbot Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = '...';
  Future<void> _requestLLM() async {
    const modelConfig = ServiceConfig(enableLog: true);
    final LLM model =
        Claude(key: dotenv.env['CLAUDE_KEY']!, serviceConfig: modelConfig);
    final promptConfig = DefaultClaudeConfig();
    final response = (await model.generateText(
            LLMMessage(message: 'Tell a story'), promptConfig))
        .toList();
    setState(() {
      text = response.join('\n');
    });
  }

  @override
  void initState() {
    dotenv.load(fileName: "../.env");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _requestLLM,
        tooltip: 'Requests',
        child: const Icon(Icons.send),
      ),
    );
  }
}
