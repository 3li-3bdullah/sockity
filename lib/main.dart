import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter WebSocket Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebSocketExample(),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  const WebSocketExample({super.key});

  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  // Create a WebSocket channel that connects to echo.websocket.org
  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  final TextEditingController _controller = TextEditingController();
  StreamSubscription? _subscription;
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    // Listen for incoming messages and add them to the list
    _subscription = channel.stream.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller and close the WebSocket connection
    _controller.dispose();
    channel.sink.close();
    _subscription?.cancel();
    super.dispose();
  }

  // Send a message over WebSocket
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Echo Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Send a message',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Send'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
