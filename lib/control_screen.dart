import 'package:flutter/material.dart';
import 'package:gr_lrr/video_widget.dart';
import 'communication.dart';
import 'package:gr_lrr/appbar.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: VideoStream(),
                ),
                Expanded(
                  flex: 1,
                  child: DisplacementWidget(),
                ),
                Expanded(
                  flex: 1,
                  child: ZoneSelector(),
                ),
                Expanded(
                  flex: 2,
                  child: Placeholder(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: ScatterPlotWidget(),
                ),
                Expanded(
                  flex: 1,
                  child: Placeholder(),
                ),
                Expanded(
                  flex: 2,
                  child: Placeholder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onPressed() {}
}

class ZoneSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          children: [
            ElevatedButton(onPressed: selectZone, child: Text("Zone 1")),
            ElevatedButton(onPressed: selectZone, child: Text("Zone 1")),
            ElevatedButton(onPressed: selectZone, child: Text("Zone 1")),
            ElevatedButton(onPressed: selectZone, child: Text("Zone 1")),
            ElevatedButton(onPressed: selectZone, child: Text("Zone 1")),
          ],
        ),
      ),
    );
  }

  void selectZone() {}
}
