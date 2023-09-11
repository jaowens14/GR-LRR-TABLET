import 'package:flutter/material.dart';
import 'package:gr_lrr/src/video_stream/video_stream.dart';
import 'package:gr_lrr/src/navigation/app_bar.dart';
import 'package:gr_lrr/src/navigation/drawer.dart';

class MyHome extends StatefulWidget {
  static const routeName = '/';

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: MyDrawer(),
      body: VideoStream(),
    );
  }
}
