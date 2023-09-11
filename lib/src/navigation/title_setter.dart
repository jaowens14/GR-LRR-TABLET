import 'package:flutter/foundation.dart';

class AppBarTitleNotifier with ChangeNotifier {
  String _title = 'HUD';

  String get title => _title;

  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}
