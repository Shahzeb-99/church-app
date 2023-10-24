// To parse this JSON data, do
//
//     final getGoogleCalendarEventsResponse = getGoogleCalendarEventsResponseFromJson(jsonString);

import 'dart:convert';

GetGoogleCalendarEventsResponse getGoogleCalendarEventsResponseFromJson(String str) => GetGoogleCalendarEventsResponse.fromJson(json.decode(str));

String getGoogleCalendarEventsResponseToJson(GetGoogleCalendarEventsResponse data) => json.encode(data.toJson());

class GetGoogleCalendarEventsResponse {
  final String? kind;
  final String? etag;
  final String? summary;
  final String? description;
  final DateTime? updated;
  final String? timeZone;
  final String? accessRole;
  final List<dynamic>? defaultReminders;
  final String? nextPageToken;
  final List<Item>? items;

  GetGoogleCalendarEventsResponse({
    this.kind,
    this.etag,
    this.summary,
    this.description,
    this.updated,
    this.timeZone,
    this.accessRole,
    this.defaultReminders,
    this.nextPageToken,
    this.items,
  });

  GetGoogleCalendarEventsResponse copyWith({
    String? kind,
    String? etag,
    String? summary,
    String? description,
    DateTime? updated,
    String? timeZone,
    String? accessRole,
    List<dynamic>? defaultReminders,
    String? nextPageToken,
    List<Item>? items,
  }) =>
      GetGoogleCalendarEventsResponse(
        kind: kind ?? this.kind,
        etag: etag ?? this.etag,
        summary: summary ?? this.summary,
        description: description ?? this.description,
        updated: updated ?? this.updated,
        timeZone: timeZone ?? this.timeZone,
        accessRole: accessRole ?? this.accessRole,
        defaultReminders: defaultReminders ?? this.defaultReminders,
        nextPageToken: nextPageToken ?? this.nextPageToken,
        items: items ?? this.items,
      );

  factory GetGoogleCalendarEventsResponse.fromJson(Map<String, dynamic> json) => GetGoogleCalendarEventsResponse(
    kind: json["kind"],
    etag: json["etag"],
    summary: json["summary"],
    description: json["description"],
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
    timeZone: json["timeZone"],
    accessRole: json["accessRole"],
    defaultReminders: json["defaultReminders"] == null ? [] : List<dynamic>.from(json["defaultReminders"]!.map((x) => x)),
    nextPageToken: json["nextPageToken"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "etag": etag,
    "summary": summary,
    "description": description,
    "updated": updated?.toIso8601String(),
    "timeZone": timeZone,
    "accessRole": accessRole,
    "defaultReminders": defaultReminders == null ? [] : List<dynamic>.from(defaultReminders!.map((x) => x)),
    "nextPageToken": nextPageToken,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  final String? kind;
  final String? etag;
  final String? id;
  final String? status;
  final String? htmlLink;
  final DateTime? created;
  final DateTime? updated;
  final String? summary;
  final Creator? creator;
  final Creator? organizer;
  final End? start;
  final End? end;
  final String? recurringEventId;
  final End? originalStartTime;
  final String? iCalUid;
  final int? sequence;
  final String? eventType;

  Item({
    this.kind,
    this.etag,
    this.id,
    this.status,
    this.htmlLink,
    this.created,
    this.updated,
    this.summary,
    this.creator,
    this.organizer,
    this.start,
    this.end,
    this.recurringEventId,
    this.originalStartTime,
    this.iCalUid,
    this.sequence,
    this.eventType,
  });

  Item copyWith({
    String? kind,
    String? etag,
    String? id,
    String? status,
    String? htmlLink,
    DateTime? created,
    DateTime? updated,
    String? summary,
    Creator? creator,
    Creator? organizer,
    End? start,
    End? end,
    String? recurringEventId,
    End? originalStartTime,
    String? iCalUid,
    int? sequence,
    String? eventType,
  }) =>
      Item(
        kind: kind ?? this.kind,
        etag: etag ?? this.etag,
        id: id ?? this.id,
        status: status ?? this.status,
        htmlLink: htmlLink ?? this.htmlLink,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        summary: summary ?? this.summary,
        creator: creator ?? this.creator,
        organizer: organizer ?? this.organizer,
        start: start ?? this.start,
        end: end ?? this.end,
        recurringEventId: recurringEventId ?? this.recurringEventId,
        originalStartTime: originalStartTime ?? this.originalStartTime,
        iCalUid: iCalUid ?? this.iCalUid,
        sequence: sequence ?? this.sequence,
        eventType: eventType ?? this.eventType,
      );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    kind: json["kind"],
    etag: json["etag"],
    id: json["id"],
    status: json["status"],
    htmlLink: json["htmlLink"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
    summary: json["summary"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    organizer: json["organizer"] == null ? null : Creator.fromJson(json["organizer"]),
    start: json["start"] == null ? null : End.fromJson(json["start"]),
    end: json["end"] == null ? null : End.fromJson(json["end"]),
    recurringEventId: json["recurringEventId"],
    originalStartTime: json["originalStartTime"] == null ? null : End.fromJson(json["originalStartTime"]),
    iCalUid: json["iCalUID"],
    sequence: json["sequence"],
    eventType: json["eventType"],
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "etag": etag,
    "id": id,
    "status": status,
    "htmlLink": htmlLink,
    "created": created?.toIso8601String(),
    "updated": updated?.toIso8601String(),
    "summary": summary,
    "creator": creator?.toJson(),
    "organizer": organizer?.toJson(),
    "start": start?.toJson(),
    "end": end?.toJson(),
    "recurringEventId": recurringEventId,
    "originalStartTime": originalStartTime?.toJson(),
    "iCalUID": iCalUid,
    "sequence": sequence,
    "eventType": eventType,
  };
}

class Creator {
  final String? email;
  final bool? self;

  Creator({
    this.email,
    this.self,
  });

  Creator copyWith({
    String? email,
    bool? self,
  }) =>
      Creator(
        email: email ?? this.email,
        self: self ?? this.self,
      );

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    email: json["email"],
    self: json["self"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "self": self,
  };
}

class End {
  final DateTime? dateTime;
  final String? timeZone;

  End({
    this.dateTime,
    this.timeZone,
  });

  End copyWith({
    DateTime? dateTime,
    String? timeZone,
  }) =>
      End(
        dateTime: dateTime ?? this.dateTime,
        timeZone: timeZone ?? this.timeZone,
      );

  factory End.fromJson(Map<String, dynamic> json) => End(
    dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
    timeZone: json["timeZone"],
  );

  Map<String, dynamic> toJson() => {
    "dateTime": dateTime?.toIso8601String(),
    "timeZone": timeZone,
  };
}
