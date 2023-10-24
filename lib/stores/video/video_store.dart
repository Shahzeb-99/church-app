import 'package:saintpopekerollosvi/models/video/get_video_response.dart';
import 'package:mobx/mobx.dart';
import '../../data/network/video_repository.dart';

part 'video_store.g.dart';

class VideoStore = _VideoStore with _$VideoStore;

abstract class _VideoStore with Store {
  // repository instance
  final VideoRepository _videoRepository;

  @observable
  GetYoutubeVideoResponse? getYoutubeVideoResponse;

  // constructor:---------------------------------------------------------------
  _VideoStore(VideoRepository repository) : this._videoRepository = repository {}

  static ObservableFuture<GetYoutubeVideoResponse?> emptyGetYoutubeVideoResponseFuture = ObservableFuture.value(null);
  static ObservableFuture<GetYoutubeVideoResponse?> emptyGetMoreYoutubeVideoResponseFuture = ObservableFuture.value(null);

  @observable
  ObservableFuture<GetYoutubeVideoResponse?> getYoutubeVideoResponseFuture = emptyGetYoutubeVideoResponseFuture;

  @observable
  ObservableFuture<GetYoutubeVideoResponse?> getMoreYoutubeVideoResponseFuture = emptyGetMoreYoutubeVideoResponseFuture;


  @observable
  ObservableList<Item> videoList=ObservableList<Item>();

  @observable
  String? nextPage;

  @computed
  bool get isGetYoutubeVideoInProcess => getYoutubeVideoResponseFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideo() async {
    final future = _videoRepository.getVideos(null);
    getYoutubeVideoResponseFuture = ObservableFuture(future);
    await future.then((value) async {
      if (value.items?.isNotEmpty ?? false) {
        this.getYoutubeVideoResponse = value;
        videoList.addAll(value.items??[]);
        nextPage = getYoutubeVideoResponse?.nextPageToken;
      } else {
        print('failed to login');
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
        print('failed to login');
      }
    }).catchError((e) {
      print(e);

      throw e;
    });
  }
}
