// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../data/network/calendar_repository.dart'; // Importing calendar repository
import '../../models/announcment/announcement.dart'; // Importing announcement model
import '../../models/calendar/get_calendar_event_response.dart'; // Importing calendar event response model

part 'calendar_store.g.dart'; // Part file for MobX code generation

// Defining a class for CalendarStore using MobX
class CalendarStore = _CalendarStore with _$CalendarStore;

// Abstract class implementing the actual logic for CalendarStore
abstract class _CalendarStore with Store {
  // Instance of the CalendarRepository for fetching data
  final CalendarRepository _calendarRepository;

  // Observable variables to store fetched responses

  @observable
  GetGoogleCalendarEventsResponse? getCalendarEventResponse;

  @observable
  GetAllNotificationResponse? getAllNotificationResponse;

  // Constructor to initialize the repository
  _CalendarStore(CalendarRepository repository) : this._calendarRepository = repository {}

  // Static ObservableFuture variables initialized with null values
  // These are placeholders for futures with null values initially
  static ObservableFuture<GetGoogleCalendarEventsResponse?> emptyGetCalendarEventResponseFuture = ObservableFuture.value(null);
  static ObservableFuture<GetAllNotificationResponse?> emptyGetAllNotificationResponseFuture = ObservableFuture.value(null);
  static ObservableFuture<GetGoogleCalendarEventsResponse?> emptyGetMoreCalendarEventResponseFuture = ObservableFuture.value(null);

  // ObservableFuture variables holding futures for respective responses
  // These variables will hold the ongoing or completed futures for different actions
  @observable
  ObservableFuture<GetGoogleCalendarEventsResponse?> getCalendarEventResponseFuture = emptyGetCalendarEventResponseFuture;

  @observable
  ObservableFuture<GetAllNotificationResponse?> getAllNotificationResponseFuture = emptyGetAllNotificationResponseFuture;

  @observable
  ObservableFuture<GetGoogleCalendarEventsResponse?> getMoreCalendarEventResponseFuture = emptyGetMoreCalendarEventResponseFuture;

  // ObservableList to hold a list of events
  @observable
  ObservableList<Item> eventList = ObservableList<Item>();

  // Variable to hold the next page token for pagination
  @observable
  String? nextPage;

  // Computed properties to check if fetching events or notifications are in progress
  // These properties will be used to observe the state of ongoing processes
  @computed
  bool get isGetCalendarEventInProcess => getCalendarEventResponseFuture.status == FutureStatus.pending;

  @computed
  bool get isGetNotificationInProcess => getAllNotificationResponseFuture.status == FutureStatus.pending;

  // Actions to fetch events, notifications, and more events
  // These actions perform asynchronous operations via the repository
  @action
  Future getEvents() async {
    final future = _calendarRepository.getEvents(null); // Fetching events
    getCalendarEventResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      // Processing the received response
      if (value.items?.isNotEmpty ?? false) {
        this.getCalendarEventResponse = value; // Storing fetched events response
        eventList.addAll(value.items ?? []); // Adding items to eventList
        nextPage = getCalendarEventResponse?.nextPageToken; // Setting next page token
      } else {
        print('failed to login'); // Log message if events fetching fails
      }
    }).catchError((e) {
      print(e); // Handling errors and printing the error message
      throw e;
    });
  }

  @action
  Future getNotification(BuildContext context) async {
    final future = _calendarRepository.getNotification(); // Fetching notifications
    getAllNotificationResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      // Processing the received response
      if (value.status ?? false) {
        this.getAllNotificationResponse = value; // Storing fetched notification response

        if (context.mounted && (value.notifications ?? []).isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No Announcements'),
            backgroundColor: Colors.amber,
          ));
        }
      } else {
        print('failed to getNotification'); // Log message if fetching notifications fails
      }
    }).catchError((e) {
      print(e); // Handling errors and printing the error message
      throw e;
    });
  }

  @action
  Future getMoreEvents() async {
    final future = _calendarRepository.getEvents(nextPage!); // Fetching more events
    getMoreCalendarEventResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      // Processing the received response
      if (value.items?.isNotEmpty ?? false) {
        eventList.addAll(value.items ?? []); // Adding more items to eventList
        nextPage = value.nextPageToken; // Updating next page token for pagination
      } else {
        print('failed to login'); // Log message if fetching more events fails
      }
    }).catchError((e) {
      print(e); // Handling errors and printing the error message
      throw e;
    });
  }
}
