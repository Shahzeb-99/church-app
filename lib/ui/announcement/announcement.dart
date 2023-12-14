import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:saintpopekerollosvi/di/components/service_locator.dart';
import 'package:saintpopekerollosvi/stores/calendar/calendar_store.dart';
import 'package:saintpopekerollosvi/widgets/progress_indicator_widget.dart';
import '../../models/announcment/announcement.dart';
import '../../widgets/announcment_widget.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  CalendarStore _calendarStore = getIt<CalendarStore>();

  @override
  void initState() {
    _calendarStore.getNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
      ),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            _calendarStore.isGetNotificationInProcess
                ? ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: _calendarStore.getAllNotificationResponse?.notifications?.length ?? 0,
                    itemBuilder: (context, index) {
                      return AnnouncementWidget(announcement: _calendarStore.getAllNotificationResponse!.notifications![index]);
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          child: OverflowBox(
                            minHeight: 250,
                            maxHeight: 250,
                            child: Lottie.asset('assets/animations/404_lottie.json'),
                          ),
                        ),
                        Text(
                          'Not Announcements',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
            Observer(builder: (context) {
              return _calendarStore.isGetNotificationInProcess ? CustomProgressIndicatorWidget() : SizedBox.shrink();
            })
          ],
        );
      }),
    );
  }
}
