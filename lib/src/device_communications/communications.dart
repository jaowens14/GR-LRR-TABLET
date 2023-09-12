import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:async'; // Import the async library for Timer
import 'package:gr_lrr/src/device_communications/device_ws_ip.dart';

class MyCommunication extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<MyCommunication> {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  TextEditingController _textFieldController = TextEditingController();
  Map<String, dynamic> _receivedData = {}; // Store parsed JSON data
  int command = 0;
  int ultrasonic = 0;
  bool relay = false;

  late Timer _pingTimer; // Timer for sending pings

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    try {
      final channel = IOWebSocketChannel.connect(
          Uri.parse(DeviceWebsocketAddress.commandsURL),
          pingInterval: Duration(milliseconds: 500));
      _channel = channel;

      _channel.stream.listen(
        (data) {
          print('Received: $data');
          final parsedData = jsonDecode(data);
          setState(() {
            _receivedData = parsedData;
          });
        },
        onDone: () {
          _reconnectWebSocket();
        },
        onError: (error) {
          setState(() {
            _isConnected = false;
          });
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
      'ultrasonic_value': ultrasonic,
      'relay_flag': relay,
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
    _pingTimer.cancel(); // Cancel the ping timer
    _channel.sink.close();
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_isConnected ? 'Device Connected' : 'Device Disconnected'),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    command = 0;
                    _sendJsonPacket();
                  },
                  child: Text('Stop'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    command = 1;
                    _sendJsonPacket();
                  },
                  child: Text('Forward'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    command = 2;
                    _sendJsonPacket();
                  },
                  child: Text('Backward'),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    relay = true;
                    _sendJsonPacket();
                  },
                  child: Text('E-STOP'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    relay = false;
                    _sendJsonPacket();
                  },
                  child: Text('RESET E-STOP'),
                ),
              ),
            ],
          ),

          // Display Sent JSON Packet Fields
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sent JSON Packet:'),
                    Text('Stepper Command: $command'),
                    Text('Stepper Speed: ${_textFieldController.text}'),
                    Text('Ultrasonic Value: $ultrasonic'),
                    Text('Relay Flag: $relay'),
                  ],
                ),
              ),

              // Display Received JSON Packet Fields
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Received JSON Packet Fields:'),
                    Text(
                        'Stepper Command: ${_receivedData['stepper_command']}'),
                    Text('Stepper Speed: ${_receivedData['stepper_speed']}'),
                    Text(
                        'Ultrasonic Value: ${_receivedData['ultrasonic_value']}'),
                    Text('Relay Flag: ${_receivedData['relay_flag']}'),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(labelText: 'Set Speed'),
            ),
          ),
        ],
      ),
    );
  }
}