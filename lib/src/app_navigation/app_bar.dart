import 'package:flutter/material.dart';
import 'package:gr_lrr/src/app_navigation/title_setter.dart';
import 'package:provider/provider.dart';
import 'package:gr_lrr/src/app_settings/settings_view.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    String title = Provider.of<AppBarTitleNotifier>(context).title;

    return AppBar(
      title: Text(title), // Set the title based on the ChangeNotifier
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).pushNamed(SettingsView.routeName);
          },
        ),
      ],
    );
  }
}
