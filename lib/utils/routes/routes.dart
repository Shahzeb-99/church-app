import 'package:saintpopekerollosvi/ui/home/home.dart';
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
    home: (BuildContext context) => CalendarScreen(),
    pageView: (BuildContext context) => PageViewScreen(),
  };
}
