import 'package:flutter/material.dart';
import 'package:gr_lrr/src/app_about/about.dart';
import 'package:gr_lrr/src/device_settings/device_settings.dart';
import 'package:gr_lrr/src/app_navigation/title_setter.dart';
import 'package:gr_lrr/src/app_home/home.dart';
import 'package:provider/provider.dart';

import '../app_settings/settings_view.dart';

class MyDrawer extends StatelessWidget {
  static const headerTitle = "GR-LRR";
  static const homeTitle = "HUD";
  static const deviceSettingTitle = "Device Status and Settings";
  static const appSettingTitle = "App Settings";
  static const aboutTitle = "About";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(headerTitle),
          ),
          ListTile(
            title: const Text(homeTitle),
            onTap: () {
              Provider.of<AppBarTitleNotifier>(context, listen: false)
                  .setTitle(homeTitle);
              Navigator.of(context).pushNamed(MyHome.routeName);
            },
          ),
          ListTile(
            title: const Text(deviceSettingTitle),
            onTap: () {
              Provider.of<AppBarTitleNotifier>(context, listen: false)
                  .setTitle(deviceSettingTitle);
              Navigator.of(context).pushNamed(DeviceSettings.routeName);
            },
          ),
          ListTile(
            title: const Text(appSettingTitle),
            onTap: () {
              Provider.of<AppBarTitleNotifier>(context, listen: false)
                  .setTitle(appSettingTitle);
              Navigator.of(context).pushNamed(SettingsView.routeName);
            },
          ),
          ListTile(
            title: const Text(aboutTitle),
            onTap: () {
              Provider.of<AppBarTitleNotifier>(context, listen: false)
                  .setTitle(aboutTitle);
              Navigator.of(context).pushNamed(MyAbout.routeName);
            },
          ),
        ],
      ),
    );
  }
}
