import 'package:saintpopekerollosvi/ui/home/home.dart';
import 'package:saintpopekerollosvi/ui/login/login.dart';
import 'package:saintpopekerollosvi/ui/splash/splash.dart';
import 'package:flutter/material.dart';

import '../../ui/page_view/page_view.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  // static const String login = '/login';
  static const String home = '/home';
  static const String pageView = '/pageView';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    // login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    pageView: (BuildContext context) => PageViewScreen(),
  };
}



