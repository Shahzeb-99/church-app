// To parse this JSON data, do
//
//     final getYoutubeVideoResponse = getYoutubeVideoResponseFromJson(jsonString);

import 'dart:convert';

GetYoutubeVideoResponse getYoutubeVideoResponseFromJson(String str) => GetYoutubeVideoResponse.fromJson(json.decode(str));

String getYoutubeVideoResponseToJson(GetYoutubeVideoResponse data) => json.encode(data.toJson());

class GetYoutubeVideoResponse {
  final String? kind;
  final String? etag;
  final String? nextPageToken;
  final String? regionCode;
  final PageInfo? pageInfo;
  final List<Item>? items;

  GetYoutubeVideoResponse({
    this.kind,
    this.etag,
    this.nextPageToken,
    this.regionCode,
    this.pageInfo,
    this.items,
  });

  GetYoutubeVideoResponse copyWith({
    String? kind,
    String? etag,
    String? nextPageToken,
    String? regionCode,
    PageInfo? pageInfo,
    List<Item>? items,
  }) =>
      GetYoutubeVideoResponse(
        kind: kind ?? this.kind,
        etag: etag ?? this.etag,
        nextPageToken: nextPageToken ?? this.nextPageToken,
        regionCode: regionCode ?? this.regionCode,
        pageInfo: pageInfo ?? this.pageInfo,
        items: items ?? this.items,
      );

  factory GetYoutubeVideoResponse.fromJson(Map<String, dynamic> json) => GetYoutubeVideoResponse(
    kind: json["kind"],
    etag: json["etag"],
    nextPageToken: json["nextPageToken"],
    regionCode: json["regionCode"],
    pageInfo: json["pageInfo"] == null ? null : PageInfo.fromJson(json["pageInfo"]),
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "etag": etag,
    "nextPageToken": nextPageToken,
    "regionCode": regionCode,
    "pageInfo": pageInfo?.toJson(),
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  final String? kind;
  final String? etag;
  final Id? id;
  final Snippet? snippet;

  Item({
    this.kind,
    this.etag,
    this.id,
    this.snippet,
  });

  Item copyWith({
    String? kind,
    String? etag,
    Id? id,
    Snippet? snippet,
  }) =>
      Item(
        kind: kind ?? this.kind,
        etag: etag ?? this.etag,
        id: id ?? this.id,
        snippet: snippet ?? this.snippet,
      );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    kind: json["kind"],
    etag: json["etag"],
    id: json["id"] == null ? null : Id.fromJson(json["id"]),
    snippet: json["snippet"] == null ? null : Snippet.fromJson(json["snippet"]),
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "etag": etag,
    "id": id?.toJson(),
    "snippet": snippet?.toJson(),
  };
}

class Id {
  final String? kind;
  final String? videoId;

  Id({
    this.kind,
    this.videoId,
  });

  Id copyWith({
    String? kind,
    String? videoId,
  }) =>
      Id(
        kind: kind ?? this.kind,
        videoId: videoId ?? this.videoId,
      );

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    kind: json["kind"],
    videoId: json["videoId"],
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "videoId": videoId,
  };
}

class Snippet {
  final DateTime? publishedAt;
  final String? channelId;
  final String? title;
  final String? description;
  final Thumbnails? thumbnails;
  final String? channelTitle;
  final String? liveBroadcastContent;
  final DateTime? publishTime;

  Snippet({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
    this.liveBroadcastContent,
    this.publishTime,
  });

  Snippet copyWith({
    DateTime? publishedAt,
    String? channelId,
    String? title,
    String? description,
    Thumbnails? thumbnails,
    String? channelTitle,
    String? liveBroadcastContent,
    DateTime? publishTime,
  }) =>
      Snippet(
        publishedAt: publishedAt ?? this.publishedAt,
        channelId: channelId ?? this.channelId,
        title: title ?? this.title,
        description: description ?? this.description,
        thumbnails: thumbnails ?? this.thumbnails,
        channelTitle: channelTitle ?? this.channelTitle,
        liveBroadcastContent: liveBroadcastContent ?? this.liveBroadcastContent,
        publishTime: publishTime ?? this.publishTime,
      );

  factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    channelId: json["channelId"],
    title: json["title"],
    description: json["description"],
    thumbnails: json["thumbnails"] == null ? null : Thumbnails.fromJson(json["thumbnails"]),
    channelTitle: json["channelTitle"],
    liveBroadcastContent: json["liveBroadcastContent"],
    publishTime: json["publishTime"] == null ? null : DateTime.parse(json["publishTime"]),
  );

  Map<String, dynamic> toJson() => {
    "publishedAt": publishedAt?.toIso8601String(),
    "channelId": channelId,
    "title": title,
    "description": description,
    "thumbnails": thumbnails?.toJson(),
    "channelTitle": channelTitle,
    "liveBroadcastContent": liveBroadcastContent,
    "publishTime": publishTime?.toIso8601String(),
  };
}

class Thumbnails {
  final Default? thumbnailsDefault;
  final Default? medium;
  final Default? high;

  Thumbnails({
    this.thumbnailsDefault,
    this.medium,
    this.high,
  });

  Thumbnails copyWith({
    Default? thumbnailsDefault,
    Default? medium,
    Default? high,
  }) =>
      Thumbnails(
        thumbnailsDefault: thumbnailsDefault ?? this.thumbnailsDefault,
        medium: medium ?? this.medium,
        high: high ?? this.high,
      );

  factory Thumbnails.fromJson(Map<String, dynamic> json) => Thumbnails(
    thumbnailsDefault: json["default"] == null ? null : Default.fromJson(json["default"]),
    medium: json["medium"] == null ? null : Default.fromJson(json["medium"]),
    high: json["high"] == null ? null : Default.fromJson(json["high"]),
  );

  Map<String, dynamic> toJson() => {
    "default": thumbnailsDefault?.toJson(),
    "medium": medium?.toJson(),
    "high": high?.toJson(),
  };
}

class Default {
  final String? url;
  final int? width;
  final int? height;

  Default({
    this.url,
    this.width,
    this.height,
  });

  Default copyWith({
    String? url,
    int? width,
    int? height,
  }) =>
      Default(
        url: url ?? this.url,
        width: width ?? this.width,
        height: height ?? this.height,
      );

  factory Default.fromJson(Map<String, dynamic> json) => Default(
    url: json["url"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "width": width,
    "height": height,
  };
}

class PageInfo {
  final int? totalResults;
  final int? resultsPerPage;

  PageInfo({
    this.totalResults,
    this.resultsPerPage,
  });

  PageInfo copyWith({
    int? totalResults,
    int? resultsPerPage,
  }) =>
      PageInfo(
        totalResults: totalResults ?? this.totalResults,
        resultsPerPage: resultsPerPage ?? this.resultsPerPage,
      );

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
    totalResults: json["totalResults"],
    resultsPerPage: json["resultsPerPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalResults": totalResults,
    "resultsPerPage": resultsPerPage,
  };
}
