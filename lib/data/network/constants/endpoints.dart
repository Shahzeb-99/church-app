class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://jsonplaceholder.typicode.com";

  // receiveTimeout
  static const Duration receiveTimeout = Duration(milliseconds:15000);

  // connectTimeout
  static const Duration connectionTimeout = Duration(milliseconds: 30000);

  // booking endpoints
  static const String getPosts = baseUrl + "/posts";
  static const String getVideos = 'https://www.googleapis.com/youtube/v3/search';
  static const String getEvents = 'https://www.googleapis.com/calendar/v3/calendars/stpopekyrillosvi%40gmail.com/events';
}