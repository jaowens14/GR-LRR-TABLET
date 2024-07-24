import 'package:flutter/material.dart';
import 'package:gr_lrr/appbar.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Placeholder(
            child: Text("Setup"),
          )),
    );
  }
}
