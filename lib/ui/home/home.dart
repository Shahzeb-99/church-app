import 'package:saintpopekerollosvi/di/components/service_locator.dart';
import 'package:saintpopekerollosvi/stores/calendar/calendar_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'calendar_source.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarStore _calendarStore = getIt<CalendarStore>();

  @override
  void initState() {
    if (_calendarStore.getCalendarEventResponse == null) {
      _calendarStore.getEvents();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Observer(builder: (context) {
          print(_calendarStore.eventList.length);

          return RefreshIndicator(
            onRefresh: () {
              return _calendarStore.getEvents();
            },
            child: SfCalendar(
              dataSource: GoogleDataSource(_calendarStore.getCalendarEventResponse?.items ?? [], context),
              view: CalendarView.month,
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: true,
              ),
            ),
          );
        }));
  }

  // app bar methods:-----------------------------------------------------------
  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Events'),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4.0),
        child: Observer(
          builder: (_) {
            return _calendarStore.isGetCalendarEventInProcess ? LinearProgressIndicator() : SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
