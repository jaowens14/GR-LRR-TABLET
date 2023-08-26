import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: 'WebSocket App',
    home: WebSocketPage(),
  ));
}

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  TextEditingController _textFieldController = TextEditingController();
  String _receivedData = '';
  int command = 0;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    try {
      final channel =
          WebSocketChannel.connect(Uri.parse('ws://192.168.3.1:8080'));
      _channel = channel;

      _channel.stream.listen(
        (data) {
          print('Received: $data');
          setState(() {
            _receivedData = data;
          });
        },
        onDone: () {
          _reconnectWebSocket();
        },
        onError: (error) {
          print('WebSocket error: $error');
          _reconnectWebSocket();
        },
      );

      setState(() {
        _isConnected = true;
      });
    } catch (error) {
      print('WebSocket connection failed: $error');
      _reconnectWebSocket();
    }
  }

  void _reconnectWebSocket() {
    if (_isConnected) {
      _channel.sink.close();
      _connectWebSocket();
    }
  }

  void _sendJsonPacket() {
    final String speed = _textFieldController.text;

    final Map<String, dynamic> packet = {
      'stepper_command': command,
      'stepper_speed': speed,
    };

    final String jsonPacket = jsonEncode(packet);
    if (_isConnected) {
      _channel.sink.add(jsonPacket);
    } else {
      print('Not connected to WebSocket');
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Communication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isConnected ? 'Connected' : 'Disconnected'),
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(labelText: 'Enter Data'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendJsonPacket;
                command = 0;
              },
              child: Text('Send Stop Command'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendJsonPacket;
                command = 1;
              },
              child: Text('Send Forward Command'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendJsonPacket;
                command = 2;
              },
              child: Text('Send Backward Command'),
            ),
            ElevatedButton(
              onPressed: () => _sendJsonPacket,
              child: Text('Send F Command'),
            ),
            ElevatedButton(
              onPressed: _sendJsonPacket,
              child: Text('Send JSON Packet'),
            ),
            SizedBox(height: 20),
            Text('Received JSON Packet:'),
            SizedBox(height: 5),
            Text(_receivedData),
          ],
        ),
      ),
    );
  }
}
