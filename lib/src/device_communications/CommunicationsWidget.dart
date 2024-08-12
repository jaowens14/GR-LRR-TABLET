import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async'; // Import the async library for Timer
import 'package:gr_lrr/src/device_communications/DeviceWebsocketIp.dart';

import 'package:gr_lrr/src/device_communications/DebugWidget.dart';
import 'package:gr_lrr/src/device_communications/ControlsWidget.dart';
import 'package:gr_lrr/src/device_communications/PidsWidget.dart';
import 'package:gr_lrr/src/device_communications/CommunicationData.dart';

import 'package:list_utilities/list_utilities.dart';

class MyCommunication extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<MyCommunication> {
  late WebSocketChannel commandsChannel;

  late CommunicationData commData;

  bool debug = false;

  List<ScatterSpot> dataPoints = [];
  int count = 0; // chart count

  @override
  void initState() {
    super.initState();
    commData = CommunicationData();
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    try {
      commandsChannel = WebSocketChannel.connect(
        Uri.parse(DeviceAddresses.commandsURL),
      );
      commandsChannel.stream.listen(
        (data) {
          print('Received: $data');
          final parsedData = jsonDecode(data);
          setState(() {
            commData.receivedData = parsedData;
            commData.deviceIsConnected = true;
            commData.motorCommand = commData.receivedData['motorDirection'];
            commData.estop = commData.receivedData['estop'];
            final newDataPoint = ScatterSpot(count.toDouble(),
                commData.receivedData['ultrasonicValue'].toDouble(),
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
      commData.deviceIsConnected = false;
      print('WebSocket connection failed: $error');
      _reconnectWebSocket();
    }
  }

  void _reconnectWebSocket() {
    print("Attempting reconnect: ");
    if (commData.deviceIsConnected) {
      commandsChannel.sink.close();
      _connectWebSocket();
    }
  }

  void _sendJsonPacket() {
    final String motorSpeed1 = commData.speedField1.text;
    final String motorSpeed2 = commData.speedField2.text;
    final String motorSpeed3 = commData.speedField3.text;
    final String motorSpeed4 = commData.speedField4.text;

    final String targetGlueHeight = commData.targetGlueHeightField.text;

    final String UT_kp = commData.UTkpField.text;
    final String UT_ki = commData.UTkiField.text;
    final String UT_kd = commData.UTkdField.text;

    final String M_kp = commData.MkpField.text;
    final String M_ki = commData.MkiField.text;
    final String M_kd = commData.MkdField.text;

    final String wheelDiameter = commData.wheelDiameterField.text;
    final String messageType = commData.messageType;

    final Map<String, dynamic> packet = {
      'msgtyp': messageType,
      'wheelDiameter': wheelDiameter,
      'motorDirection': commData.motorCommand,
      'motorSpeed1': motorSpeed1, // setpoint for motor pid
      'motorSpeed2': motorSpeed2,
      'motorSpeed3': motorSpeed3, // setpoint for motor pid
      'motorSpeed4': motorSpeed4,
      'motorMode': commData.motorMode,
      'motorEnable': commData.motorEnable,
      'targetGlueHeight': targetGlueHeight, //setpoint for glue height pid
      'UT_Kp': UT_kp,
      'UT_Ki': UT_ki,
      'UT_Kd': UT_kd,
      'M_Kp': M_kp,
      'M_Ki': M_ki,
      'M_Kd': M_kd,
      'ultrasonicValue': commData.ultrasonic,
      'batteryLevel': commData.battery,
      'estop': commData.estop,
      'uptime': commData.uptime,
    };

    final String jsonPacket = jsonEncode(packet);
    if (commData.deviceIsConnected) {
      print('Sent: ' + jsonPacket);
      commandsChannel.sink.add(jsonPacket);
    } else {
      print('Not connected to WebSocket');
    }
  }

  @override
  void dispose() {
    commandsChannel.sink.close();
    commData.speedField1.dispose();
    commData.speedField2.dispose();
    commData.speedField3.dispose();
    commData.speedField4.dispose();

    commData.setpointField.dispose();
    commData.targetGlueHeightField.dispose();
    commData.UTkpField.dispose();
    commData.UTkiField.dispose();
    commData.UTkdField.dispose();

    commData.MkpField.dispose();
    commData.MkiField.dispose();
    commData.MkdField.dispose();

    // here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 2,
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
                      maxY: 300, // Adjust the Y-axis range as needed
                      scatterSpots: dataPoints,
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: commData.debug,
                  child: DebugWidget(
                    communicationData: commData,
                  ))
            ],
          ),
          ControlsWidget(
            communicationData: commData,
            sendJsonPacket: _sendJsonPacket,
            reconnectWebSocket: _reconnectWebSocket,
          ),
          PidWidget(communicationData: commData)
        ],
      ),
    );
  }
}
