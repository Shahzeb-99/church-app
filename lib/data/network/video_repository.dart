import 'dart:async';

import 'package:saintpopekerollosvi/data/local/datasources/post/post_datasource.dart';
import 'package:saintpopekerollosvi/data/sharedpref/shared_preference_helper.dart';
import 'package:saintpopekerollosvi/models/post/post.dart';
import 'package:saintpopekerollosvi/models/post/post_list.dart';
import 'package:saintpopekerollosvi/models/video/get_video_statistics_response.dart';
import 'package:sembast/sembast.dart';

import '../../constants/secret.dart';
import '../../models/video/get_video_response.dart';
import 'apis/video/video_api.dart';

class VideoRepository {
  // api objects
  final VideoApi _videoApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  VideoRepository(
    this._videoApi,
    this._sharedPrefsHelper,
  );

  /// Fetch video from youtube
  /// Returns a [GetYoutubeVideoResponse].
  Future<GetYoutubeVideoResponse> getVideos(String? pageToken) async {
    return await _videoApi.getVideos(pageToken, Secrets.youtubeApiKey);
  }

  /// Fetch video from youtube
  /// Returns a [GetYoutubeVideoResponse].
  Future<GetYoutubeVideoResponse> getLiveVideos(String? pageToken) async {
    return await _videoApi.getLiveVideos(pageToken, Secrets.youtubeApiKey);
  }

  /// Fetch video statistics from youtube
  /// Returns a [GetVideoStatisticsResponse].
  Future<GetVideoStatisticsResponse> getVideoStatistics(
    String id,
  ) async {
    return await _videoApi.getVideoStatistics(Secrets.youtubeApiKey, id);
  }
}
