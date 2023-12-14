import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:saintpopekerollosvi/di/components/service_locator.dart';
import 'package:saintpopekerollosvi/stores/video/video_store.dart';
import 'package:saintpopekerollosvi/ui/video/play_video.dart';
import 'package:saintpopekerollosvi/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
  });

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ScrollController _scrollController = ScrollController();

  VideoStore _videoStore = getIt<VideoStore>();

  @override
  void initState() {
    _videoStore.getVideo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Videos'),
      // actions: _buildActions(context),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Observer(builder: (context) {
      return Stack(
        children: <Widget>[
          _buildMainContent(),
          if (_videoStore.isGetMoreYoutubeVideoInProcess)
            Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(),
            )
        ],
      );
    });
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _videoStore.isGetYoutubeVideoInProcess ? CustomProgressIndicatorWidget() : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _videoStore.getMoreVideos();
      }
    });

    return _videoStore.videoList.isNotEmpty
        ? ListView.separated(
            controller: _scrollController,
            itemCount: _videoStore.videoList.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItem(position);
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: OverflowBox(
                    minHeight: 250,
                    maxHeight: 250,
                    child: Lottie.asset('assets/animations/404_lottie.json'),
                  ),
                ),
                Text(
                  'No Videos Available',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
  }

  Widget _buildListItem(int position) {
    final item = _videoStore.videoList[position].snippet;

    return CustomListItem(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YoutubePlayer(
              item: _videoStore.videoList[position],
            ),
          ),
        );
      },
      imageUrl: item?.thumbnails?.thumbnailsDefault?.url ?? '',
      title: '${item?.title ?? ''}',
      subtitle: timeago.format(item?.publishedAt ?? DateTime.now()),
    );
  }
}

class CustomListItem extends StatelessWidget {
  final Function onTap;
  final String imageUrl;
  final String title;
  final String subtitle;

  CustomListItem({
    required this.onTap,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                progressIndicatorBuilder: (BuildContext context, string, hmm) {
                  return CupertinoActivityIndicator();
                },
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12), // Adjust the spacing according to your requirement
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
