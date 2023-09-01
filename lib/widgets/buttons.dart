// lib/widgets/buttons.dart
import 'package:flutter/material.dart';

class CommandButtons extends StatelessWidget {
  final Function(int) onPressed;

  CommandButtons({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            onPressed(0);
          },
          child: Text('Send Stop Command'),
        ),
        ElevatedButton(
          onPressed: () {
            onPressed(1);
          },
          child: Text('Send Forward Command'),
        ),
        ElevatedButton(
          onPressed: () {
            onPressed(2);
          },
          child: Text('Send Backward Command'),
        ),
        // Add more buttons as needed
      ],
    );
  }
}
