import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gr_lrr/src/device_communications/CommunicationData.dart';

class ControlsWidget extends StatefulWidget {
  final CommunicationData communicationData;
  final VoidCallback sendJsonPacket;
  final VoidCallback reconnectWebSocket;

  const ControlsWidget({
    Key? key,
    required this.communicationData,
    required this.sendJsonPacket,
    required this.reconnectWebSocket,
  }) : super(key: key);

  @override
  _ControlsWidgetState createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                    widget.communicationData.speedField1.text = '0.0';
                    widget.communicationData.speedField2.text = '0.0';
                    widget.communicationData.speedField3.text = '0.0';
                    widget.communicationData.speedField4.text = '0.0';

                    widget.sendJsonPacket();
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
                    widget.communicationData.messageType = 'set';
                    widget.communicationData.motorCommand = 1;
                    widget.sendJsonPacket();
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
                    widget.communicationData.messageType = "get";
                    widget.sendJsonPacket();
                  },
                  child: Text('SEND GET MESSAGE'),
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
                    widget.reconnectWebSocket();
                  },
                  child: widget.communicationData.deviceIsConnected
                      ? Text('RECONNECT DEVICE')
                      : Text("CONNECTING..."),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: SwitchListTile(
                  title: Text(
                    'PID',
                    textScaleFactor: 0.8,
                  ),
                  value: widget.communicationData.motorMode,
                  onChanged: (bool value) {
                    setState(() {
                      widget.communicationData.motorMode = value;
                    });
                    HapticFeedback.vibrate();
                    print(widget.communicationData.motorMode);
                    widget.sendJsonPacket();
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: SwitchListTile(
                  title: Text(
                    'DEBUG',
                  ),
                  value: widget.communicationData.debug,
                  onChanged: (bool value) {
                    print("debug value: $value");
                    setState(() {
                      widget.communicationData.debug = value;
                    });
                    HapticFeedback.vibrate();
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: SwitchListTile(
                  title: Text(
                    'ESTOP',
                  ),
                  value: widget.communicationData.estop,
                  onChanged: (bool value) {},
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: SwitchListTile(
                  title: Text(
                    'MOTORS ON/OFF: ',
                  ),
                  value: widget.communicationData.motorEnable,
                  onChanged: (bool value) {
                    setState(() {
                      widget.communicationData.motorEnable = value;
                    });
                    HapticFeedback.vibrate();
                    print(widget.communicationData.motorEnable);
                    widget.sendJsonPacket();
                  },
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('battery: ${widget.communicationData.battery}'),
              ),
              Expanded(
                flex: 1,
                child: Text(
                    'ultrasonic: ${widget.communicationData.receivedData['ultrasonicValue']}'),
              ),
              Expanded(
                flex: 1,
                child: Text(
                    'measured Motor Speed: ${widget.communicationData.receivedData['measuredMotorSpeed']}'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
