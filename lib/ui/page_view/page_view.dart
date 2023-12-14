import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../announcement/announcement.dart';
import '../home/home.dart';
import '../live/live_video.dart';
import '../video/video.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({Key? key}) : super(key: key);

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent,systemNavigationBarColor: Colors.transparent),
    );
    super.initState();
  }

  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get getTitle {
    if (currentPageIndex == 3) {
      return 'Profile';
    } else if (currentPageIndex == 2) {
      return 'Task';
    } else {
      return 'RealTechCRM';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildBottomNavBar(),
      body: _buildCurrentIndexWidget(),
    );
  }

// Builds the widget that displays the current page
  Widget _buildCurrentIndexWidget() {
    // This function builds the widget that displays the current page, based on the value of the `currentIndex` variable.
    return const <Widget>[
      AnnouncementScreen(),
      CalendarScreen(),
      LiveVideoScreen(),
      VideoScreen(),
    ][currentPageIndex];
  }

// Builds the list of navigation destinations
  List<NavigationDestination> _buildDestinationList() {
    // This function builds the list of navigation destinations, which will be displayed in the bottom navigation bar.
    return [
      NavigationDestination(
        icon: Icon(
          Icons.announcement,
          color: currentPageIndex == 0 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Announcements',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.calendar_today,
          color: currentPageIndex == 1 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Calendar',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.live_tv,
          color: currentPageIndex == 2 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Live Video',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.video_collection_rounded,
          color: currentPageIndex == 3 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Videos',
      ),
    ];
  }


// Builds the bottom navigation bar
  Widget _buildBottomNavBar() {
    // This function builds the bottom navigation bar, which allows users to switch between the different pages of the app.
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: _buildDestinationList(),
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }
}
