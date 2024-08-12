import 'package:flutter/material.dart';
import 'package:gr_lrr/src/device_communications/CommunicationData.dart';

class DebugWidget extends StatelessWidget {
  final CommunicationData communicationData;

  const DebugWidget({
    Key? key,
    required this.communicationData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sent JSON Packet:'),
            Text('Motor Command: ${communicationData.motorCommand}'),
            Text('Motor Speed 1: ${communicationData.speedField1.text}'),
            Text('Motor Speed 2: ${communicationData.speedField2.text}'),
            Text(
                'Target Height : ${communicationData.targetGlueHeightField.text}'),
            Text('UT Kp: ${communicationData.UTkpField.text}'),
            Text('UT Ki: ${communicationData.UTkiField.text}'),
            Text('UT Kd: ${communicationData.UTkdField.text}'),
            Text('Motor Kp: ${communicationData.MkpField.text}'),
            Text('Motor Ki: ${communicationData.MkiField.text}'),
            Text('Motor Kd: ${communicationData.MkdField.text}'),
            Text('Motor Mode: ${communicationData.motorMode ? 'PID' : 'Set'}'),
            Text('E-Stop: ${communicationData.estop ? 'Inctive' : 'Active'}'),
          ],
        ),

        // Display Received JSON Packet Fields
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Received JSON Packet Fields:'),
            Text(
                'Motor Command: ${communicationData.receivedData['motorDirection']}'),
            Text(
                'Motor Speed: ${communicationData.receivedData['motorSpeed']}'),
            Text(
                'Set Point: ${communicationData.receivedData['targetGlueHeight']}'),
            Text('UT Kp: ${communicationData.UTkpField.text}'),
            Text('UT Ki: ${communicationData.UTkiField.text}'),
            Text('UT Kd: ${communicationData.UTkdField.text}'),
            Text('Motor Kp: ${communicationData.MkpField.text}'),
            Text('Motor Ki: ${communicationData.MkiField.text}'),
            Text('Motor Kd: ${communicationData.MkdField.text}'),
            Text('Motor Mode: ${communicationData.motorMode ? 'PID' : 'Set'}'),
            Text('E-Stop: ${communicationData.estop ? 'Inactive' : 'Active'}'),
            Text('Uptime (min): ${communicationData.receivedData['uptime']}'),
          ],
        ),
      ],
    );
  }
}
