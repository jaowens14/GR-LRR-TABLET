// lib/main.dart
import 'package:flutter/material.dart';
import 'ui/home_screen.dart'; // Import the HomeScreen widget

void main() {
  runApp(MaterialApp(
    title: 'WebSocket App',
    home: HomeScreen(), // Use the HomeScreen widget
  ));
}
