import 'package:fl_chart/fl_chart.dart';
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
  late WebSocketChannel commandsChannel;
  bool device_isConnected = false;
  TextEditingController _speedFieldController = TextEditingController();
  TextEditingController _setpointFieldController = TextEditingController();
  TextEditingController _kpFieldController = TextEditingController();
  TextEditingController _kiFieldController = TextEditingController();
  TextEditingController _kdFieldController = TextEditingController();

  Map<String, dynamic> _receivedData = {}; // Store parsed JSON data
  int command = 0;
  bool mode = false;
  int ultrasonic = 0;
  bool relay = false;

  List<FlSpot> dataPoints = [];

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    try {
      commandsChannel = IOWebSocketChannel.connect(
        Uri.parse(DeviceWebsocketAddress.commandsURL),
        pingInterval: Duration(milliseconds: 1000),
        connectTimeout: null,
      );
      commandsChannel.stream.listen(
        (data) {
          print('Received: $data');
          final parsedData = jsonDecode(data);
          setState(() {
            _receivedData = parsedData;
            device_isConnected = true;

            final newDataPoint = FlSpot(
                dataPoints.length.toDouble(), // X-axis value (time)
                _receivedData['ultrasonic_value'].toDouble());

            dataPoints.add(newDataPoint);
            if (dataPoints.length == 50) {
              dataPoints = [];
            }
          });
        },
        onDone: () {
          print('WebSocket closes gracefully');
        },
        onError: (error) {
          print('WebSocket error: $error');
          _reconnectWebSocket();
        },
      );
    }
    //
    catch (error) {
      device_isConnected = false;
      print('WebSocket connection failed: $error');
      _reconnectWebSocket();
    }
  }

  void _reconnectWebSocket() {
    if (device_isConnected) {
      commandsChannel.sink.close();
      _connectWebSocket();
    }
  }

  void _sendJsonPacket() {
    final String speed = _speedFieldController.text;
    final String setpoint = _setpointFieldController.text;
    final String kp = _kpFieldController.text;
    final String ki = _kiFieldController.text;
    final String kd = _kdFieldController.text;

    final Map<String, dynamic> packet = {
      'stepper_command': command,
      'stepper_speed': speed,
      'PID_setpoint': setpoint,
      'PID_Kp': kp,
      'PID_Ki': ki,
      'PID_Kd': kd,
      'stepper_mode': mode,
      'ultrasonic_value': ultrasonic,
      'relay_flag': relay,
    };

    final String jsonPacket = jsonEncode(packet);
    if (device_isConnected) {
      print('Sent: ' + jsonPacket);
      commandsChannel.sink.add(jsonPacket);
    } else {
      print('Not connected to WebSocket');
    }
  }

  @override
  void dispose() {
    commandsChannel.sink.close();
    _speedFieldController.dispose();
    _setpointFieldController.dispose();
    _kpFieldController.dispose();
    _kiFieldController.dispose();
    _kdFieldController.dispose();

    // here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(device_isConnected ? 'Device Connected' : 'Device Disconnected'),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 219, 197, 0)),
                  onPressed: () {
                    mode = !mode;
                    print(mode);
                    _sendJsonPacket();
                  },
                  child: Text('Mode'),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    relay = false;
                    _reconnectWebSocket();
                  },
                  child: Text('RECONNECT DEVICE'),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _speedFieldController,
                    decoration: InputDecoration(labelText: 'Set Speed'),
                  ),
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
                    Text('Stepper Speed: ${_speedFieldController.text}'),
                    Text('Set Point: ${_setpointFieldController.text}'),
                    Text('Kp: ${_kpFieldController.text}'),
                    Text('Ki: ${_kiFieldController.text}'),
                    Text('Kd: ${_kdFieldController.text}'),
                    Text('Stepper Mode: $mode'),
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
                    Text('Set Point: ${_receivedData['PID_setpoint']}'),
                    Text('Kp: ${_receivedData['PID_Kp']}'),
                    Text('Ki: ${_receivedData['PID_Ki']}'),
                    Text('Kd: ${_receivedData['PID_Kd']}'),
                    Text('Stepper Mode: $mode'),
                    Text(
                        'Ultrasonic Value: ${_receivedData['ultrasonic_value']}'),
                    Text('Relay Flag: ${_receivedData['relay_flag']}'),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _setpointFieldController,
                    decoration: InputDecoration(labelText: 'Set Setpoint'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _kpFieldController,
                    decoration: InputDecoration(labelText: 'Kp'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _kiFieldController,
                    decoration: InputDecoration(labelText: 'Ki'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _kdFieldController,
                    decoration: InputDecoration(labelText: 'Kd'),
                  ),
                ),
              ),
            ],
          ),

          Container(
            height: 200, // Adjust the height as needed
            padding: EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color(0xff37434d),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: dataPoints.length.toDouble(),
                minY: 0,
                maxY: 30000, // Adjust the Y-axis range as needed
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    colors: [Colors.blue],
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
