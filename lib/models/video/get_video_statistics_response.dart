// To parse this JSON data, do
//
//     final getVideoStatisticsResponse = getVideoStatisticsResponseFromJson(jsonString);

import 'dart:convert';

GetVideoStatisticsResponse getVideoStatisticsResponseFromJson(String str) => GetVideoStatisticsResponse.fromJson(json.decode(str));

String getVideoStatisticsResponseToJson(GetVideoStatisticsResponse data) => json.encode(data.toJson());

class GetVideoStatisticsResponse {
  final String? kind;
  final String? etag;
  final List<StatisticsItem>? items;
  final PageInfo? pageInfo;

  GetVideoStatisticsResponse({
    this.kind,
    this.etag,
    this.items,
    this.pageInfo,
  });

  GetVideoStatisticsResponse copyWith({
    String? kind,
    String? etag,
    List<StatisticsItem>? items,
    PageInfo? pageInfo,
  }) =>
      GetVideoStatisticsResponse(
        kind: kind ?? this.kind,
        etag: etag ?? this.etag,
        items: items ?? this.items,
        pageInfo: pageInfo ?? this.pageInfo,
      );

  factory GetVideoStatisticsResponse.fromJson(Map<String, dynamic> json) => GetVideoStatisticsResponse(
    kind: json["kind"],
    etag: json["etag"],
    items: json["items"] == null ? [] : List<StatisticsItem>.from(json["items"]!.map((x) => StatisticsItem.fromJson(x))),
    pageInfo: json["pageInfo"] == null ? null : PageInfo.fromJson(json["pageInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "etag": etag,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "pageInfo": pageInfo?.toJson(),
  };
}

class StatisticsItem {
  final String? kind;
  final String? etag;
  final String? id;
  final Statistics? statistics;

  StatisticsItem({
    this.kind,
    this.etag,
    this.id,
    this.statistics,
  });

  StatisticsItem copyWith({
    String? kind,
    String? etag,
    String? id,
    Statistics? statistics,
  }) =>
      StatisticsItem(
        kind: kind ?? this.kind,
        etag: etag ?? this.etag,
        id: id ?? this.id,
        statistics: statistics ?? this.statistics,
      );

  factory StatisticsItem.fromJson(Map<String, dynamic> json) => StatisticsItem(
    kind: json["kind"],
    etag: json["etag"],
    id: json["id"],
    statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "etag": etag,
    "id": id,
    "statistics": statistics?.toJson(),
  };
}

class Statistics {
  final String? viewCount;
  final String? likeCount;
  final String? favoriteCount;
  final String? commentCount;

  Statistics({
    this.viewCount,
    this.likeCount,
    this.favoriteCount,
    this.commentCount,
  });

  Statistics copyWith({
    String? viewCount,
    String? likeCount,
    String? favoriteCount,
    String? commentCount,
  }) =>
      Statistics(
        viewCount: viewCount ?? this.viewCount,
        likeCount: likeCount ?? this.likeCount,
        favoriteCount: favoriteCount ?? this.favoriteCount,
        commentCount: commentCount ?? this.commentCount,
      );

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    viewCount: json["viewCount"],
    likeCount: json["likeCount"],
    favoriteCount: json["favoriteCount"],
    commentCount: json["commentCount"],
  );

  Map<String, dynamic> toJson() => {
    "viewCount": viewCount,
    "likeCount": likeCount,
    "favoriteCount": favoriteCount,
    "commentCount": commentCount,
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
