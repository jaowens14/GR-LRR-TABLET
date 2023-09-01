// lib/utils/websocket_utils.dart
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:async';
import '../models/data_model.dart';

class WebSocketUtils {
  late WebSocketChannel _channel;
  bool _isConnected = false;

  WebSocketUtils() {
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    try {
      final channel = IOWebSocketChannel.connect(
          Uri.parse('ws://192.168.3.1:8080'),
          pingInterval: Duration(milliseconds: 250));
      _channel = channel;

      // Add WebSocket event listeners here
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

  // Add other WebSocket utility methods here
}
