import 'package:flutter/material.dart';
import 'package:gr_lrr/login_screen.dart';

enum AccessLevel { developer, maintainer, operator }

class AuthService extends ChangeNotifier {
  bool loggedIn = false;
  AccessLevel _accessLevel = AccessLevel.operator;

  AccessLevel get accessLevel => _accessLevel;

  void login(AccessLevel level, String password) {
    switch (level) {
      case AccessLevel.developer:
        if (password == developerPassword) {
          loggedIn = true;
          _accessLevel = level;
          notifyListeners();
          print("dev in");
          print(password);
        }
      case AccessLevel.maintainer:
        if (password == maintenancePassword) {
          loggedIn = true;
          _accessLevel = level;
          notifyListeners();
          print("maint in0");
        }
      case AccessLevel.operator:
        if (password == operatorPassword) {
          loggedIn = true;
          _accessLevel = level;
          notifyListeners();
          print("ops in");
        }
    }
  }

  void logout() {
    loggedIn = false;
    _accessLevel = AccessLevel.operator;
    notifyListeners();
  }
}
