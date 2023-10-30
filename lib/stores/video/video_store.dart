import 'package:saintpopekerollosvi/models/video/get_video_response.dart';
import 'package:mobx/mobx.dart';
import 'package:saintpopekerollosvi/models/video/get_video_statistics_response.dart';
import '../../data/network/video_repository.dart';

part 'video_store.g.dart';

class VideoStore = _VideoStore with _$VideoStore;

abstract class _VideoStore with Store {
  // repository instance
  final VideoRepository _videoRepository;

  @observable
  GetYoutubeVideoResponse? getYoutubeVideoResponse;

  @observable
  GetYoutubeVideoResponse? getYoutubeLiveVideoResponse;

  @observable
  GetVideoStatisticsResponse? getVideoStatisticsResponse;

  // constructor:---------------------------------------------------------------
  _VideoStore(VideoRepository repository) : this._videoRepository = repository {}

  static ObservableFuture<GetYoutubeVideoResponse?> emptyGetYoutubeVideoResponseFuture = ObservableFuture.value(null);
  static ObservableFuture<GetYoutubeVideoResponse?> emptyGetYoutubeLiveVideoResponseFuture = ObservableFuture.value(null);
  static ObservableFuture<GetYoutubeVideoResponse?> emptyGetMoreYoutubeVideoResponseFuture = ObservableFuture.value(null);
  static ObservableFuture<GetYoutubeVideoResponse?> emptyGetMoreYoutubeLiveVideoResponseFuture = ObservableFuture.value(null);
  static ObservableFuture<GetVideoStatisticsResponse?> emptyGetVideoStatisticsResponseFuture = ObservableFuture.value(null);

  @observable
  ObservableFuture<GetYoutubeVideoResponse?> getYoutubeVideoResponseFuture = emptyGetYoutubeVideoResponseFuture;

  @observable
  ObservableFuture<GetYoutubeVideoResponse?> getYoutubeLiveVideoResponseFuture = emptyGetYoutubeLiveVideoResponseFuture;

  @observable
  ObservableFuture<GetYoutubeVideoResponse?> getMoreYoutubeVideoResponseFuture = emptyGetMoreYoutubeVideoResponseFuture;

  @observable
  ObservableFuture<GetYoutubeVideoResponse?> getMoreYoutubeLiveVideoResponseFuture = emptyGetMoreYoutubeLiveVideoResponseFuture;

  @observable
  ObservableFuture<GetVideoStatisticsResponse?> getVideoStatisticsResponseFuture = emptyGetVideoStatisticsResponseFuture;

  @observable
  ObservableList<Item> videoList = ObservableList<Item>();

  @observable
  ObservableList<Item> liveVideoList = ObservableList<Item>();

  @observable
  String? nextPage;

  @observable
  String? liveNextPage;

  @computed
  bool get isGetYoutubeVideoInProcess => getYoutubeVideoResponseFuture.status == FutureStatus.pending;

  @computed
  bool get isGetYoutubeLiveVideoInProcess => getYoutubeLiveVideoResponseFuture.status == FutureStatus.pending;

  @computed
  bool get isGetMoreYoutubeVideoInProcess => getMoreYoutubeVideoResponseFuture.status == FutureStatus.pending;

  @computed
  bool get isGetMoreYoutubeLiveVideoInProcess => getMoreYoutubeLiveVideoResponseFuture.status == FutureStatus.pending;

  @computed
  bool get isGetVideoStatisticsInProcess => getVideoStatisticsResponseFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideo() async {
    videoList.clear();

    final future = _videoRepository.getVideos(null);
    getYoutubeVideoResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value.items?.isNotEmpty ?? false) {
        this.getYoutubeVideoResponse = value;
        videoList.addAll(value.items ?? []);
        nextPage = getYoutubeVideoResponse?.nextPageToken;
      } else {
        print('failed to getVideo');
      }
    }).catchError((e) {
      print(e);

      throw e;
    });
  }

  @action
  Future getLiveVideo() async {
    liveVideoList.clear();

    final future = _videoRepository.getLiveVideos(null);
    getYoutubeLiveVideoResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value.items?.isNotEmpty ?? false) {
        this.getYoutubeLiveVideoResponse = value;
        liveVideoList.addAll(value.items ?? []);
        liveNextPage = getYoutubeLiveVideoResponse?.nextPageToken;
      } else {
        print('failed to getVideo');
      }
    }).catchError((e) {
      print(e);

      throw e;
    });
  }

  @action
  Future getMoreVideos() async {
    final future = _videoRepository.getVideos(nextPage!);
    getMoreYoutubeVideoResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value.items?.isNotEmpty ?? false) {
        videoList.addAll(value.items ?? []);
        nextPage = value.nextPageToken;
      } else {
        print('failed to getMoreVideos');
      }
    }).catchError((e) {
      print(e);
      throw e;
    });
  }


  @action
  Future getMoreLiveVideos() async {
    final future = _videoRepository.getLiveVideos(liveNextPage!);
    getMoreYoutubeLiveVideoResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value.items?.isNotEmpty ?? false) {
        liveVideoList.addAll(value.items ?? []);
        liveNextPage = value.nextPageToken;
      } else {
        print('failed to getMoreVideos');
      }
    }).catchError((e) {
      print(e);
      throw e;
    });
  }

  @action
  Future getVideoStatistics(String id) async {
    final future = _videoRepository.getVideoStatistics(id);
    getVideoStatisticsResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value.items?.isNotEmpty ?? false) {
        this.getVideoStatisticsResponse = value;
      } else {
        print('failed to getVideoStatistics');
      }
    }).catchError((e) {
      print(e);
      throw e;
    });
  }
}
