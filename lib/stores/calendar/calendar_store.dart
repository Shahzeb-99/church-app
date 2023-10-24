import 'package:mobx/mobx.dart';
import '../../data/network/calendar_repository.dart';
import '../../models/calendar/get_calendar_event_response.dart';

part 'calendar_store.g.dart';

class CalendarStore = _CalendarStore with _$CalendarStore;

abstract class _CalendarStore with Store {
  // repository instance
  final CalendarRepository _calendarRepository;

  @observable
  GetGoogleCalendarEventsResponse? getCalendarEventResponse;

  // constructor:---------------------------------------------------------------
  _CalendarStore(CalendarRepository repository) : this._calendarRepository = repository {}

  static ObservableFuture<GetGoogleCalendarEventsResponse?> emptyGetCalendarEventResponseFuture = ObservableFuture.value(null);
  static ObservableFuture<GetGoogleCalendarEventsResponse?> emptyGetMoreCalendarEventResponseFuture = ObservableFuture.value(null);

  @observable
  ObservableFuture<GetGoogleCalendarEventsResponse?> getCalendarEventResponseFuture = emptyGetCalendarEventResponseFuture;

  @observable
  ObservableFuture<GetGoogleCalendarEventsResponse?> getMoreCalendarEventResponseFuture = emptyGetMoreCalendarEventResponseFuture;


  @observable
  ObservableList<Item> eventList=ObservableList<Item>();

  @observable
  String? nextPage;

  @computed
  bool get isGetCalendarEventInProcess => getCalendarEventResponseFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getEvents() async {
    final future = _calendarRepository.getEvents(null);
    getCalendarEventResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value.items?.isNotEmpty ?? false) {
        this.getCalendarEventResponse = value;
        eventList.addAll(value.items??[]);
        nextPage = getCalendarEventResponse?.nextPageToken;
      } else {
        print('failed to login');
      }
    }).catchError((e) {
      print(e);

      throw e;
    });
  }

  @action
  Future getMoreEvents() async {
    final future = _calendarRepository.getEvents(nextPage!);
    getMoreCalendarEventResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value.items?.isNotEmpty ?? false) {
        eventList.addAll(value.items ?? []);
        nextPage = value.nextPageToken;
      } else {
        print('failed to login');
      }
    }).catchError((e) {
      print(e);

      throw e;
    });
  }
}
