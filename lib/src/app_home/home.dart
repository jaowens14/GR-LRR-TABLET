import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gr_lrr/src/navigation/app_bar.dart';
import 'package:gr_lrr/src/navigation/drawer.dart';
import 'package:gr_lrr/src/video_stream/video_stream.dart';

class MyHome extends StatefulWidget {
  static const routeName = '/';

  final VideoStream videoStream; // Add this line

  MyHome({required this.videoStream}); // Add this constructor

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late VideoStream _videoStream; // Add this line

  @override
  void initState() {
    super.initState();
    _videoStream =
        widget.videoStream; // Initialize the videoStream in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: MyDrawer(),
      body: Center(
        child: Column(children: [
          Expanded(
            flex: 2,
            child: _videoStream,
          ),
          Expanded(flex: 2, child: Text("test")),
        ]),
      ), // Use the videoStream from the widget parameter
    );
  }
}
