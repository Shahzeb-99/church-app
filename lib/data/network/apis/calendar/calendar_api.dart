import 'dart:async';
import 'package:intl/intl.dart';
import 'package:saintpopekerollosvi/data/network/constants/endpoints.dart';
import 'package:saintpopekerollosvi/data/network/dio_client.dart';
import '../../../../models/announcment/announcement.dart';
import '../../../../models/calendar/get_calendar_event_response.dart';
import '../../../../models/video/get_video_response.dart';

class CalendarApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  CalendarApi(
    this._dioClient,
  );

  /// Returns [GetGoogleCalendarEventsResponse] object in response
  Future<GetGoogleCalendarEventsResponse> getEvents(String? nextPageToken, String key) async {
    try {
      final res = await _dioClient.get(Endpoints.getEvents, queryParameters: {
        'key': key,
        if (nextPageToken != null) 'nextPageToken': nextPageToken,
        'timeMin': DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()) ,
        'singleEvents': true,
        'orderBy': 'startTime',
        'maxResults': 1000,
      });
      return GetGoogleCalendarEventsResponse.fromJson(res);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  /// Returns [GetAllNotificationResponse] object in response
  Future<GetAllNotificationResponse> getNotification() async {
    try {
      final res = await _dioClient.get(Endpoints.getAllNotifications, );
      return GetAllNotificationResponse.fromJson(res);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
