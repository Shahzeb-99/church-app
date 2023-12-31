import 'dart:async';

import 'package:saintpopekerollosvi/data/local/datasources/post/post_datasource.dart';
import 'package:saintpopekerollosvi/data/sharedpref/shared_preference_helper.dart';
import 'package:saintpopekerollosvi/models/announcment/announcement.dart';
import 'package:saintpopekerollosvi/models/calendar/get_calendar_event_response.dart';
import 'package:saintpopekerollosvi/models/post/post.dart';
import 'package:saintpopekerollosvi/models/post/post_list.dart';
import 'package:sembast/sembast.dart';

import '../../constants/secret.dart';
import '../../models/video/get_video_response.dart';
import 'apis/calendar/calendar_api.dart';
import 'apis/video/video_api.dart';

class CalendarRepository {
  // api objects
  final CalendarApi _calendarApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  CalendarRepository(
    this._calendarApi,
    this._sharedPrefsHelper,
  );

  /// Fetch events from Google Calendar
  /// Returns a [GetGoogleCalendarEventsResponse].
  Future<GetGoogleCalendarEventsResponse> getEvents(String? pageToken) async {

    return await _calendarApi.getEvents(pageToken, Secrets.calendarApiKey);
  }
  /// Fetch events from Google Calendar
  /// Returns a [GetAllNotificationResponse].
  Future<GetAllNotificationResponse> getNotification( ) async {
    return await _calendarApi.getNotification( );
  }
}
