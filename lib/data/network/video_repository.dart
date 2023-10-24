import 'dart:async';

import 'package:saintpopekerollosvi/data/local/datasources/post/post_datasource.dart';
import 'package:saintpopekerollosvi/data/sharedpref/shared_preference_helper.dart';
import 'package:saintpopekerollosvi/models/post/post.dart';
import 'package:saintpopekerollosvi/models/post/post_list.dart';
import 'package:sembast/sembast.dart';

import '../../models/video/get_video_response.dart';
import 'apis/video/video_api.dart';

class VideoRepository {

  // api objects
  final VideoApi _videoApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  VideoRepository(this._videoApi, this._sharedPrefsHelper, );


  /// Fetch video from youtube
  /// Returns a [GetYoutubeVideoResponse].
  Future<GetYoutubeVideoResponse> getVideos( String? pageToken  ) async {

    final String key = 'AIzaSyDN04-VrDqLBMoTq2J-yGqiranue2DVf6o';
    return await _videoApi.getVideos(pageToken,key);
  }



}