import 'package:flutter/material.dart';
import 'package:gr_lrr/src/app_navigation/app_bar.dart';
import 'package:gr_lrr/src/app_navigation/app_drawer.dart';
import 'package:gr_lrr/src/device_communications/CommunicationsWidget.dart';
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
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Scaffold(
            appBar: const MyAppBar(),
            drawer: MyDrawer(),
            body: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      SizedBox(width: 1200, height: 800, child: _videoStream),
                      MyCommunication(),
                    ],
                  ),
                ),
              ),
            ), // Use the videoStream from the widget parameter
          );
        },
      ),
    );
  }
}
