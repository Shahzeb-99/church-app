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

class LiveVideoScreen extends StatefulWidget {
  const LiveVideoScreen({
    super.key,
  });

  @override
  _LiveVideoScreenState createState() => _LiveVideoScreenState();
}

class _LiveVideoScreenState extends State<LiveVideoScreen> {
  ScrollController _scrollController = ScrollController();

  VideoStore _videoStore = getIt<VideoStore>();

  @override
  void initState() {
    _videoStore.getLiveVideo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Live Stream'),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Observer(builder: (context) {
      return Stack(
        children: <Widget>[
          _buildMainContent(),
          if (_videoStore.isGetMoreYoutubeLiveVideoInProcess)
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
        return _videoStore.isGetYoutubeLiveVideoInProcess ? CustomProgressIndicatorWidget() : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Call your function here
        _videoStore.getMoreLiveVideos(); // Replace this with the function you want to call
      }
    });

    return _videoStore.liveVideoList.isNotEmpty
        ? ListView.separated(
            controller: _scrollController,
            itemCount: _videoStore.liveVideoList.length,
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
                  'Not currently streaming',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
  }

  Widget _buildListItem(int position) {
    final item = _videoStore.liveVideoList[position].snippet;

    return CustomListItem(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YoutubePlayer(
              item: _videoStore.liveVideoList[position],
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
                progressIndicatorBuilder: (BuildContext context, string, _) {
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
