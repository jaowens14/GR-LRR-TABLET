import 'package:flutter/material.dart';
import 'package:gr_lrr/src/video_stream/video_stream.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/app_settings/settings_controller.dart';
import 'src/app_settings/settings_service.dart';
import 'package:gr_lrr/src/navigation/title_setter.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  final videoStream = VideoStream();
  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(ChangeNotifierProvider(
      create: (_) => AppBarTitleNotifier(),
      child: MyApp(
        settingsController: settingsController,
        videoStream: videoStream,
      )));
}
