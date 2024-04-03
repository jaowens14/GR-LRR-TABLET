import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

import 'package:gr_lrr/control_screen.dart';

enum TopLevelModules { control }

bool logged = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppContent(),
    );
  }
}

class MyAppContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: AppRouterDelegate(),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}

class AppRouterDelegate extends RouterDelegate<TopLevelModules>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TopLevelModules> {
  TopLevelModules _screen = TopLevelModules.control;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('GR-LRR CONTROL'),
          //IconButton(
          //  icon: Icon(Icons.login_rounded),
          //  onPressed: () {
          //    _setNewRoutePath(TopLevelModules.home);
          //  },
          //  tooltip: 'login',
          //),
          //IconButton(
          //  icon: Icon(Icons.login_rounded),
          //  onPressed: () {
          //    _setNewRoutePath(TopLevelModules.login);
          //  },
          //  tooltip: 'login',
          //),
          IconButton(
            icon: Icon(Icons.dashboard_rounded),
            onPressed: () {
              _setNewRoutePath(TopLevelModules.control);
              //Navigator.pop(context);
            },
            tooltip: 'control',
          ),
          //IconButton(
          //  icon: Icon(Icons.checklist_rounded),
          //  onPressed: () {
          //    _setNewRoutePath(TopLevelModules.setup);
          //  },
          //  tooltip: 'setup',
          //),
        ],
      )),
      body: Navigator(
        key: navigatorKey,
        pages: [
          //MaterialPage(
          //  key: ValueKey('HomeScreen'),
          //  child: HomeScreen(),
          //),
          //if (_screen == TopLevelModules.login)
          //  MaterialPage(
          //    key: ValueKey('LoginScreen'),
          //    child: LoginScreen(),
          //  ),
          if (_screen == TopLevelModules.control)
            MaterialPage(
              key: ValueKey('dogbonesScreen'),
              child: ControlScreen(),
            ),
          //if (_screen == TopLevelModules.setup)
          //  MaterialPage(
          //    key: ValueKey('SetupScreen'),
          //    child: SetupScreen(),
          //  ),
        ],
        onPopPage: (route, result) {
          // Handle pop actions
          return route.didPop(result);
        },
      ),
    );
  }

  void _setNewRoutePath(TopLevelModules configuration) {
    logged = true;
    if (logged) {
      if (_screen != configuration) {
        _screen = configuration;
        notifyListeners();
      }
    } else {
      _screen = TopLevelModules.control;
      notifyListeners();
    }
  }

  @override
  TopLevelModules get currentConfiguration => _screen;

  @override
  Future<void> setNewRoutePath(TopLevelModules configuration) async {
    _setNewRoutePath(configuration);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();
}

class AppRouteInformationParser
    extends RouteInformationParser<TopLevelModules> {
  @override
  Future<TopLevelModules> parseRouteInformation(
      RouteInformation routeInformation) async {
    switch (routeInformation.uri.path) {
      case '/':
        return TopLevelModules.control;
      //case '/login':
      //  return TopLevelModules.login;
      //case '/control':
      //  return TopLevelModules.control;
      //case '/setup':
      //  return TopLevelModules.setup;
      default:
        return TopLevelModules.control;
    }
  }

  @override
  RouteInformation restoreRouteInformation(TopLevelModules configuration) {
    switch (configuration) {
      //case TopLevelModules.control:
      //  return RouteInformation(uri: Uri.parse('/'));
//
      //case TopLevelModules.login:
      //  return RouteInformation(uri: Uri.parse('/login'));

      case TopLevelModules.control:
        return RouteInformation(uri: Uri.parse('/control'));

      //case TopLevelModules.setup:
      //  return RouteInformation(uri: Uri.parse('/setup'));
      //default:
      //  return RouteInformation(uri: Uri.parse('/'));
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
}
