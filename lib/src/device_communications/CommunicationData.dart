import 'package:flutter/material.dart';

class CommunicationData {
  late TextEditingController speedField1;
  late TextEditingController speedField2;
  late TextEditingController speedField3;
  late TextEditingController speedField4;

  late TextEditingController setpointField;
  late TextEditingController targetGlueHeightField;
  late TextEditingController MkpField;
  late TextEditingController MkiField;
  late TextEditingController MkdField;
  late TextEditingController UTkpField;
  late TextEditingController UTkiField;
  late TextEditingController UTkdField;
  late TextEditingController wheelDiameterField;

  late Map<String, dynamic> receivedData;
  int motorCommand = 0;
  bool motorMode = false;
  int ultrasonic = 0;
  int battery = 0;
  bool motorEnable = true;
  bool estop = false;
  int uptime = 0;
  bool debug = false;
  bool deviceIsConnected = true;
  String messageType = '';

  late Map<String, dynamic> cameraData;
  int leftPercent = 0;
  int rightPercent = 0;

  CommunicationData() {
    speedField1 = TextEditingController(text: '0');
    speedField2 = TextEditingController(text: '0');
    speedField3 = TextEditingController(text: '0');
    speedField4 = TextEditingController(text: '0');

    setpointField = TextEditingController(text: '0');
    targetGlueHeightField = TextEditingController(text: '0');
    MkpField = TextEditingController(text: '25.0');
    MkiField = TextEditingController(text: '15.0');
    MkdField = TextEditingController(text: '0.0');

    UTkpField = TextEditingController(text: '0.05');
    UTkiField = TextEditingController(text: '0.0');
    UTkdField = TextEditingController(text: '0.0');
    wheelDiameterField = TextEditingController(text: '0.05');
    receivedData = {};
  }
}
