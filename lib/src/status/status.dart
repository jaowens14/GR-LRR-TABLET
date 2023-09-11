import 'package:flutter/material.dart';
import 'package:gr_lrr/src/navigation/app_bar.dart';
import '../navigation/drawer.dart';

class MyStatus extends StatelessWidget {
  const MyStatus({Key? key});

  static const routeName = '/mystatus';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        drawer: MyDrawer(),
        body: const Text("device status info"));
  }
}
