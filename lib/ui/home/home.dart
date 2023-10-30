import 'dart:developer';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendarApi;

import 'package:saintpopekerollosvi/data/sharedpref/constants/preferences.dart';
import 'package:saintpopekerollosvi/di/components/service_locator.dart';
import 'package:saintpopekerollosvi/stores/calendar/calendar_store.dart';
import 'package:saintpopekerollosvi/utils/routes/routes.dart';
import 'package:saintpopekerollosvi/stores/language/language_store.dart';
import 'package:saintpopekerollosvi/stores/post/post_store.dart';
import 'package:saintpopekerollosvi/stores/theme/theme_store.dart';
import 'package:saintpopekerollosvi/utils/locale/app_localization.dart';
import 'package:saintpopekerollosvi/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'calendar_source.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  late PostStore _postStore;
  late ThemeStore _themeStore;
  late LanguageStore _languageStore;

  CalendarStore _calendarStore = getIt<CalendarStore>();

  @override
  void didChangeDependencies() {
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _postStore = Provider.of<PostStore>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _calendarStore.getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Observer(builder: (context) {
          print(_calendarStore.eventList.length);

          return SfCalendar(
            dataSource: GoogleDataSource(_calendarStore.getCalendarEventResponse?.items ?? [], context),
            view: CalendarView.month,
            monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              showAgenda: true,
            ),
          );
        }));
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Events'),
      // actions: _buildActions(context),
    );
  }
  //
  // List<Widget> _buildActions(BuildContext context) {
  //   return <Widget>[
  //     _buildGoogleSignInButton(),
  //     // _buildLanguageButton(),
  //     _buildThemeButton(),
  //     _buildLogoutButton(),
  //   ];
  // }

  hmm() {
    calendarApi.Event event = calendarApi.Event(); // Create object of event
    event.summary = 'summardsggdsfsdfdsfdsfsdfsdfyText'; //Setting summary of object

    calendarApi.EventDateTime start = new calendarApi.EventDateTime(); //Setting start time
    start.dateTime = DateTime.now();
    start.timeZone = "GMT+05:00";
    event.start = start;

    calendarApi.EventDateTime end = new calendarApi.EventDateTime(); //setting end time
    end.timeZone = "GMT+05:00";
    end.dateTime = DateTime.now().add(Duration(days: 5));
    event.end = end;

    insertEvent(event);
  }

  insertEvent(calendarApi.Event event) {
    try {
      clientViaUserConsent(
          ClientId('289605575676-5csing7me517q35f22up995qg6ucimr4.apps.googleusercontent.com',
              ),
          [calendarApi.CalendarApi.calendarEventsScope], (value) async {
        if (await canLaunch(
          value,
        )) {
          await launchUrlString(
            value,
          );
        } else {
          throw 'Could not launch $value';
        }
      } ).then((AuthClient client) {
        var calendar = calendarApi.CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            log('Event added in google calendar');
          } else {
            log("Unable to add event in google calendar");
          }
        });
      });
    } catch (e) {
      log('Error creating event $e');
    }
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          icon: Icon(
            _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }
  //
  // Widget _buildLogoutButton() {
  //   return IconButton(
  //     onPressed: () {
  //       SharedPreferences.getInstance().then((preference) {
  //         preference.setBool(Preferences.is_logged_in, false);
  //         Navigator.of(context).pushReplacementNamed(Routes.login);
  //       });
  //     },
  //     icon: Icon(
  //       Icons.power_settings_new,
  //     ),
  //   );
  // }

  // Widget _buildLanguageButton() {
  //   return IconButton(
  //     onPressed: () {
  //       _buildLanguageDialog();
  //     },
  //     icon: Icon(
  //       Icons.language,
  //     ),
  //   );
  // }

  // Widget _buildGoogleSignInButton() {
  //   return IconButton(
  //     onPressed: () async {
  //       final GoogleSignIn _googleSignIn = GoogleSignIn(
  //         // clientId: '289605575676-5csing7me517q35f22up995qg6ucimr4.apps.googleusercontent.com',
  //         scopes: <String>[calendarApi.CalendarApi.calendarEventsScope],
  //       );
  //       await _googleSignIn.signIn();
  //       hmm();
  //       print((_googleSignIn.scopes)!);
  //     },
  //     icon: Icon(
  //       Icons.login,
  //     ),
  //   );
  // }

  // // body methods:--------------------------------------------------------------
  // Widget _buildBody() {
  //   return Stack(
  //     children: <Widget>[
  //       _handleErrorMessage(),
  //       _buildMainContent(),
  //     ],
  //   );
  // }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _postStore.loading ? CustomProgressIndicatorWidget() : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    return _postStore.postList != null
        ? ListView.separated(
            itemCount: _postStore.postList!.posts!.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItem(position);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListItem(int position) {
    return ListTile(
      dense: true,
      leading: Icon(Icons.cloud_circle),
      title: Text(
        '${_postStore.postList?.posts?[position].title}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subtitle: Text(
        '${_postStore.postList?.posts?[position].body}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_postStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_postStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          AppLocalizations.of(context).translate('home_tv_choose_language'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Colors.white,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop();
        },
        children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  object.language!,
                  style: TextStyle(
                    color: _languageStore.locale == object.locale
                        ? Theme.of(context).primaryColor
                        : _themeStore.darkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // change user language based on selected locale
                  _languageStore.changeLanguage(object.locale!);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
