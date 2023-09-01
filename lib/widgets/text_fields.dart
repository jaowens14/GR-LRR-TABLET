// lib/widgets/text_fields.dart
import 'package:flutter/material.dart';

class SpeedTextField extends StatelessWidget {
  final TextEditingController controller;

  SpeedTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: 'Set Speed'),
    );
  }
}
