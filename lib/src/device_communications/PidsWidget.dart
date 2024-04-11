import 'package:flutter/material.dart';
import 'package:gr_lrr/src/device_communications/CommunicationData.dart';

class PidWidget extends StatelessWidget {
  final CommunicationData communicationData;

  const PidWidget({
    Key? key,
    required this.communicationData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.targetGlueHeightField,
                  decoration:
                      InputDecoration(labelText: 'target Glue Height (mm)'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.UTkpField,
                  decoration: InputDecoration(labelText: 'UT Kp'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.UTkiField,
                  decoration: InputDecoration(labelText: 'UT Ki'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.UTkdField,
                  decoration: InputDecoration(labelText: 'UT Kd'),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.speedField,
                  decoration: InputDecoration(labelText: 'Speed (m/s)'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.MkpField,
                  decoration: InputDecoration(labelText: 'Motor Kp'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.MkiField,
                  decoration: InputDecoration(labelText: 'Motor Ki'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.MkdField,
                  decoration: InputDecoration(labelText: 'Motor Kd'),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: communicationData.wheelDiameterField,
                  decoration: InputDecoration(labelText: 'Wheel Diameter (m)'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
