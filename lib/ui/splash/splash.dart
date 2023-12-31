import 'dart:async';

import 'package:saintpopekerollosvi/constants/assets.dart';
import 'package:saintpopekerollosvi/data/sharedpref/constants/preferences.dart';
import 'package:saintpopekerollosvi/utils/routes/routes.dart';
import 'package:saintpopekerollosvi/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Center(child: AppIconWidget(image: Assets.appLogo)),
    );
  }

  startTimer() {
    var _duration = Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  navigate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool(Preferences.is_logged_in) ?? false) {
      Navigator.of(context).pushReplacementNamed(Routes.pageView);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.pageView);
    }
  }
}
