import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/calendar/get_calendar_event_response.dart';

class GoogleDataSource extends CalendarDataSource {
  final List<Item> appointments;
  final BuildContext context;

  GoogleDataSource(this.appointments,this.context);

  @override
  DateTime getStartTime(int index) {
    return appointments[index].start?.dateTime ?? DateTime.now();
  }



  @override
  DateTime getEndTime(int index) {
    return appointments![index].end?.dateTime ?? DateTime.now();
  }

  @override
  String getSubject(int index) {
    return appointments![index].summary ?? '';
  }


  @override
  getColor(int index){
    return Color(0xFF5D0000);

  }
  @override
  bool isAllDay(int index) {
    return appointments![index].end == null;
  }
}
