// To parse this JSON data, do
//
//     final getAllNotificationResponse = getAllNotificationResponseFromJson(jsonString);

import 'dart:convert';

GetAllNotificationResponse getAllNotificationResponseFromJson(String str) => GetAllNotificationResponse.fromJson(json.decode(str));

String getAllNotificationResponseToJson(GetAllNotificationResponse data) => json.encode(data.toJson());

class GetAllNotificationResponse {
  bool? status;
  List<NotificationItem>? notifications;

  GetAllNotificationResponse({
    this.status,
    this.notifications,
  });

  GetAllNotificationResponse copyWith({
    bool? status,
    List<NotificationItem>? notifications,
  }) =>
      GetAllNotificationResponse(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
      );

  factory GetAllNotificationResponse.fromJson(Map<String, dynamic> json) => GetAllNotificationResponse(
    status: json["status"],
    notifications: json["notifications"] == null ? [] : List<NotificationItem>.from(json["notifications"]!.map((x) => NotificationItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
  };
}

class NotificationItem {
  String? id;
  String? title;
  String? body;
  String? imageUrl;
  DateTime? timestamp;

  NotificationItem({
    this.id,
    this.title,
    this.body,
    this.imageUrl,
    this.timestamp,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    DateTime? timestamp,
  }) =>
      NotificationItem(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        imageUrl: imageUrl ?? this.imageUrl,
        timestamp: timestamp ?? this.timestamp,
      );

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    imageUrl: json["imageUrl"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "imageUrl": imageUrl,
    "timestamp": timestamp?.toIso8601String(),
  };
}
