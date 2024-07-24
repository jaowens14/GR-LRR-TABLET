import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gr_lrr/auth_service.dart';
import 'package:gr_lrr/control_screen.dart';
import 'package:gr_lrr/setup_screen.dart';
import 'package:gr_lrr/login_screen.dart';

enum TopLevelModules { register, login, control, setup }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => MaterialApp.router(
          routerDelegate: AppRouterDelegate(),
          routeInformationParser: AppRouteInformationParser(),
        ),
      ),
    );
  }
}

class AppRouterDelegate extends RouterDelegate<TopLevelModules>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TopLevelModules> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  TopLevelModules _screen = TopLevelModules.login;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_screen == TopLevelModules.login)
          MaterialPage(
            key: ValueKey('login'),
            child: LoginScreen(),
          ),
        if (_screen == TopLevelModules.control)
          MaterialPage(
            key: ValueKey('ControlScreen'),
            child: ControlScreen(),
          ),
        if (_screen == TopLevelModules.setup)
          MaterialPage(
            key: ValueKey('SetupScreen'),
            child: SetupScreen(),
          ),
      ],
      onPopPage: (route, result) {
        // Handle pop actions
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(TopLevelModules configuration) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final authService = Provider.of<AuthService>(context, listen: false);

    // Only update the screen configuration if the user is logged in
    if (authService.loggedIn) {
      if (_screen != configuration) {
        _screen = configuration;
        notifyListeners();
      }
    } else {
      // Redirect to login screen if the user is not logged in
      _screen = TopLevelModules.login;
      notifyListeners();
    }
  }
}

class AppRouteInformationParser
    extends RouteInformationParser<TopLevelModules> {
  @override
  Future<TopLevelModules> parseRouteInformation(
      RouteInformation routeInformation) async {
    switch (routeInformation.uri.path) {
      case '/login':
        return TopLevelModules.login;
      case '/control':
        return TopLevelModules.control;
      case '/setup':
        return TopLevelModules.setup;
      default:
        return TopLevelModules.control;
    }
  }

  @override
  RouteInformation restoreRouteInformation(TopLevelModules configuration) {
    switch (configuration) {
      case TopLevelModules.login:
        return RouteInformation(uri: Uri.parse('/login'));
      case TopLevelModules.control:
        return RouteInformation(uri: Uri.parse('/control'));
      case TopLevelModules.setup:
        return RouteInformation(uri: Uri.parse('/setup'));
      default:
        return RouteInformation(uri: Uri.parse('/login'));
    }
  }
}

AppRouterDelegate getRouterDelegate(BuildContext context) {
  return Router.of(context).routerDelegate as AppRouterDelegate;
}

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
}
