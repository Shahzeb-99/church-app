import 'dart:async';
import 'package:saintpopekerollosvi/data/network/constants/endpoints.dart';
import 'package:saintpopekerollosvi/data/network/dio_client.dart';
import '../../../../models/video/get_video_response.dart';
import '../../../../models/video/get_video_statistics_response.dart';

class VideoApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  VideoApi(
    this._dioClient,
  );

  /// Returns [GetYoutubeVideoResponse] object in response
  Future<GetYoutubeVideoResponse> getVideos(String? pageToken, String key) async {
    try {
      final res = await _dioClient.get(Endpoints.getVideoList, queryParameters: {
        'part': 'snippet',
        'channelId': 'UCovfThYKTmUW-CDmm0RG3Tg',
        'type': 'video',
        'order': 'date',
        'maxResults': 10,
        'key': key,
        if (pageToken != null) 'pageToken': pageToken,
      });
      return GetYoutubeVideoResponse.fromJson(res);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  /// Returns [GetYoutubeVideoResponse] object in response
  Future<GetYoutubeVideoResponse> getLiveVideos(String? pageToken, String key) async {
    try {
      final res = await _dioClient.get(Endpoints.getVideoList, queryParameters: {
        'part': 'snippet',
        'channelId': 'UCovfThYKTmUW-CDmm0RG3Tg',
        'type': 'video',
        'eventType': 'live',
        'order': 'date',
        'maxResults': 10,
        'key': key,
        if (pageToken != null) 'pageToken': pageToken,
      });
      return GetYoutubeVideoResponse.fromJson(res);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  /// Returns [GetVideoStatisticsResponse] object in response
  Future<GetVideoStatisticsResponse> getVideoStatistics(String key, String id) async {
    try {
      final res = await _dioClient.get(Endpoints.getVideo, queryParameters: {
        'part': 'statistics',
        'id': id,
        'key': key,
      });
      return GetVideoStatisticsResponse.fromJson(res);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
