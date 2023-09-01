// lib/ui/home_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grover_tablet/widgets/buttons.dart';
import 'package:grover_tablet/widgets/text_fields.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Communication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Screen'),
            CommandButtons(
              onPressed: (int command) {
                // Handle button press here, e.g., pass the command to WebSocketPage
              },
            ), // Add any other UI widgets related to the home screen
            SpeedTextField(
              controller: TextEditingController(),
            ),
          ],
        ),
      ),
    );
  }
}
