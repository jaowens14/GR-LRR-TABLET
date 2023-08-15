import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Flutter to Arduino',
      home: WebSocketScreen(),
    );
  }
}

class WebSocketScreen extends StatefulWidget {
  @override
  _WebSocketScreenState createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://192.168.0.254:8080');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Flutter to Arduino'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Send Message to Arduino'),
              onPressed: () {
                channel.sink.add('Hello, Arduino!'); // Send message to Arduino
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
