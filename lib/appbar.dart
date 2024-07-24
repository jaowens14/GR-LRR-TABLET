import 'package:flutter/material.dart';
import 'package:gr_lrr/login_screen.dart';
import 'package:gr_lrr/main.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const BaseAppBar({super.key, required this.appBar});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('GR-LRR'),
          IconButton(
            icon: Icon(Icons.login_rounded),
            onPressed: () {
              getRouterDelegate(context).setNewRoutePath(TopLevelModules.login);
            },
            tooltip: 'login',
          ),
          IconButton(
            icon: Icon(Icons.dashboard_rounded),
            onPressed: () {
              getRouterDelegate(context)
                  .setNewRoutePath(TopLevelModules.control);
            },
            tooltip: 'control',
          ),
          IconButton(
            icon: Icon(Icons.checklist_rounded),
            onPressed: () {
              getRouterDelegate(context).setNewRoutePath(TopLevelModules.setup);
            },
            tooltip: 'setup',
          ),
          Spacer(),
          Text("Signed in as:  $userName"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
