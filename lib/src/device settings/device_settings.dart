import 'package:flutter/material.dart';
import 'package:gr_lrr/src/navigation/app_bar.dart';
import 'package:gr_lrr/src/navigation/drawer.dart';

class DeviceSettings extends StatelessWidget {
  const DeviceSettings({Key? key});

  static const routeName = '/device';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        drawer: MyDrawer(),
        body: const Text("Device Settings"));
  }
}
