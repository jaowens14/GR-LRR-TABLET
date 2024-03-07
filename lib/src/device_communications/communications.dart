import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:async'; // Import the async library for Timer
import 'package:gr_lrr/src/device_communications/device_ws_ip.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:list_utilities/list_utilities.dart';

class MyCommunication extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<MyCommunication> {
  late WebSocketChannel commandsChannel;
  bool device_isConnected = false;
  TextEditingController _speedFieldController =
      TextEditingController(text: '0');
  TextEditingController _setpointFieldController =
      TextEditingController(text: '0');
  TextEditingController _targetSpeedFieldController =
      TextEditingController(text: '0');
  TextEditingController _kpFieldController = TextEditingController(text: '100');
  TextEditingController _kiFieldController = TextEditingController(text: '10');
  TextEditingController _kdFieldController = TextEditingController(text: '20');

  Map<String, dynamic> _receivedData = {}; // Store parsed JSON data
  int motorCommand = 0;
  bool motorMode = false;
  int ultrasonic = 0;
  int battery = 0;
  bool motorEnable = true;
  bool estop = false;
  int uptime = 0;

  bool debug = false;

  List<ScatterSpot> dataPoints = [];
  List<ScatterSpot> uPoints = [];
  int count = 0;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    try {
      commandsChannel = IOWebSocketChannel.connect(
        Uri.parse(DeviceWebsocketAddress.commandsURL),
        pingInterval: Duration(milliseconds: 2000),
        connectTimeout: null,
      );
      commandsChannel.stream.listen(
        (data) {
          print('Received: $data');
          final parsedData = jsonDecode(data);
          setState(() {
            _receivedData = parsedData;
            device_isConnected = true;
            motorCommand = _receivedData['motorDirection'];
            estop = _receivedData['estop'];
            final newDataPoint = ScatterSpot(
                count.toDouble(), _receivedData['ultrasonicValue'].toDouble(),
                radius: 4, color: Colors.green);

            dataPoints.add(newDataPoint);
            if (dataPoints.length == 100) {
              dataPoints.removeFirst();
            }
            count++;
            if (count == 100) {
              count = 0;
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
    final String motorSpeed = _speedFieldController.text;
    final String setpoint = _setpointFieldController.text;
    final String motorTargetSpeed = _targetSpeedFieldController.text;
    final String kp = _kpFieldController.text;
    final String ki = _kiFieldController.text;
    final String kd = _kdFieldController.text;

    final Map<String, dynamic> packet = {
      'motorDirection': motorCommand,
      'motorSpeed': motorSpeed,
      'motorMode': motorMode,
      'motorEnable': motorEnable,
      'targetMotorSpeed': motorTargetSpeed,
      'PID_setpoint': setpoint,
      'PID_Kp': kp,
      'PID_Ki': ki,
      'PID_Kd': kd,
      'ultrasonicValue': ultrasonic,
      'batteryLevel': battery,
      'estop': estop,
      'uptime': uptime,
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
    _targetSpeedFieldController.dispose();
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
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ScatterChart(
                ScatterChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: 100,
                  minY: 0,
                  maxY: 10, // Adjust the Y-axis range as needed
                  scatterSpots: dataPoints,
                ),
              ),
            ),
          ),
          Visibility(
            visible: debug,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sent JSON Packet:'),
                      Text('Stepper Command: $motorCommand'),
                      Text('Stepper Speed: ${_speedFieldController.text}'),
                      Text('Set Point: ${_setpointFieldController.text}'),
                      Text('Target Speed:${_targetSpeedFieldController.text}'),
                      Text('Kp: ${_kpFieldController.text}'),
                      Text('Ki: ${_kiFieldController.text}'),
                      Text('Kd: ${_kdFieldController.text}'),
                      Text('Stepper Mode: ${motorMode ? 'PID' : 'Set'}'),
                      Text('Ultrasonic Value: $ultrasonic'),
                      Text('E-Stop: ${estop ? 'Active' : 'Inactive'}'),
                    ],
                  ),
                ),

                // Display Received JSON Packet Fields
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Received JSON Packet Fields:'),
                      Text('Motor Command: ${_receivedData['motorDirection']}'),
                      Text('Stepper Speed: ${_receivedData['motorSpeed']}'),
                      Text('Set Point: ${_receivedData['PID_setpoint']}'),
                      Text('Kp: ${_receivedData['PID_Kp']}'),
                      Text('Ki: ${_receivedData['PID_Ki']}'),
                      Text('Kd: ${_receivedData['PID_Kd']}'),
                      Text('Motor Mode: ${motorMode ? 'PID' : 'Set'}'),
                      Text(
                          'Ultrasonic Value: ${_receivedData['ultrasonicValue']}'),
                      Text('E-Stop: ${estop ? 'Inactive' : 'Active'}'),
                      Text('Uptime (min): ${_receivedData['uptime']}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size.fromHeight(75)),
                    onPressed: () {
                      HapticFeedback.vibrate();
                      motorCommand = 0;
                      _sendJsonPacket();
                    },
                    child: Text('STOP'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size.fromHeight(75)),
                    onPressed: () {
                      HapticFeedback.vibrate();
                      motorCommand = 1;
                      _sendJsonPacket();
                    },
                    child: Text('GO FORWARD'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size.fromHeight(75)),
                    onPressed: () {
                      HapticFeedback.vibrate();
                      motorCommand = 2;
                      _sendJsonPacket();
                    },
                    child: Text('GO BACKWARD'),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: estop ? Text('ESTOP INACTIVE') : Text('ESTOP ACTIVE')),
              Expanded(
                flex: 1,
                child: SwitchListTile(
                  title: Text(
                    'PID',
                    textScaleFactor: 0.8,
                  ),
                  value: motorMode,
                  onChanged: (bool value) {
                    setState(() {
                      motorMode = value;
                    });
                    HapticFeedback.vibrate();
                    print(motorMode);
                    _sendJsonPacket();
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: SwitchListTile(
                  dense: true,
                  title: Text(
                    'DEBUG',
                    textScaleFactor: 0.8,
                  ),
                  value: debug,
                  onChanged: (bool value) {
                    setState(() {
                      debug = value;
                    });
                    HapticFeedback.vibrate();
                  },
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: SwitchListTile(
                  title: Text(
                    'MOTORS ENABLED: ',
                    textScaleFactor: 0.8,
                  ),
                  value: motorEnable,
                  onChanged: (bool value) {
                    setState(() {
                      motorEnable = value;
                    });
                    HapticFeedback.vibrate();
                    print(motorEnable);
                    _sendJsonPacket();
                  },
                ),
              ),
              Expanded(flex: 1, child: Text('battery: $battery')),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size.fromHeight(75)),
                    onPressed: () {
                      HapticFeedback.vibrate();
                      _reconnectWebSocket();
                    },
                    child: device_isConnected
                        ? Text('RECONNECT DEVICE')
                        : Text("CONNECTING..."),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _speedFieldController,
                    decoration: InputDecoration(labelText: 'Speed'),
                  ),
                ),
              ),
            ],
          ),

          // Display Sent JSON Packet Fields
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _setpointFieldController,
                    decoration:
                        InputDecoration(labelText: 'Target Ultrasonic Value'),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _targetSpeedFieldController,
                    decoration: InputDecoration(labelText: 'Target Speed'),
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
        ],
      ),
    );
  }
}
