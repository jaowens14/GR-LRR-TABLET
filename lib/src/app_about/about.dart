import 'package:flutter/material.dart';
import 'package:gr_lrr/src/app_navigation/app_bar.dart';
import 'package:gr_lrr/src/app_navigation/app_drawer.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyAbout extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
  static const routeName = '/myabout';
}

class _AboutPageState extends State<MyAbout> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadPackageInfo() async {
    WidgetsFlutterBinding.ensureInitialized();
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_packageInfo != null)
              Text(
                'Version: ${_packageInfo!.version}',
                style: TextStyle(fontSize: 18),
              ),
            if (_packageInfo != null)
              Text(
                'Build Number: ${_packageInfo!.buildNumber}',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your app description goes here. You can provide a brief overview of your app, its purpose, and its features.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Developer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your developer information goes here. You can mention your company name or contact details.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
