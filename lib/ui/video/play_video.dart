import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:saintpopekerollosvi/di/components/service_locator.dart';
import 'package:saintpopekerollosvi/models/video/get_video_response.dart';
import 'package:saintpopekerollosvi/models/video/get_video_statistics_response.dart';
import 'package:saintpopekerollosvi/stores/video/video_store.dart';
import 'package:saintpopekerollosvi/widgets/progress_indicator_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:timeago/timeago.dart' as timeago;

class YoutubePlayer extends StatefulWidget {
  final Item item;

  YoutubePlayer({Key? key, required this.item}) : super(key: key);

  @override
  _YoutubePlayerState createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<YoutubePlayer> {
  late YoutubePlayerController _ytbPlayerController;
  VideoStore _videoStore = getIt<VideoStore>();

  @override
  void initState() {
    _videoStore.getVideoStatistics(widget.item.id?.videoId ?? '');
    super.initState();

    print(widget.item.id?.videoId ?? '');

    setState(() {
      _ytbPlayerController = YoutubePlayerController.fromVideoId(
        videoId: widget.item.id?.videoId ?? '',
        autoPlay: true,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.snippet?.title ?? ''),
      ),
      body: SafeArea(
        child: YoutubePlayerScaffold(
          controller: _ytbPlayerController,
          aspectRatio: 16 / 9,
          builder: (context, player) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                player,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.snippet?.title ?? '',
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            timeago.format(widget.item.snippet?.publishedAt ?? DateTime.now()),
                            style:
                                Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 15),
                          ),
                          if (widget.item.snippet?.description != null && widget.item.snippet!.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                widget.item.snippet?.description ?? 'No description added',
                                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Observer(builder: (context) {
                  return AnimatedSwitcher(
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 500),
                    reverseDuration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.elasticOut,
                    switchOutCurve: Curves.easeInExpo,
                    child: _videoStore.isGetVideoStatisticsInProcess
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              elevation: 0,
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 38.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            key: ValueKey<int>(1),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: StatisticsCard(
                              statistics: _videoStore.getVideoStatisticsResponse!.items!.first.statistics!,
                            ),
                          ),
                  );
                })
              ],
            );
          },
        ),
      ),
    );
  }
}

class StatisticsCard extends StatefulWidget {
  final Statistics statistics;

  const StatisticsCard({required this.statistics});

  @override
  State<StatisticsCard> createState() => _StatisticsCardState();
}

class _StatisticsCardState extends State<StatisticsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticRow(FontAwesomeIcons.solidEye, "View Count", widget.statistics.viewCount ?? ''),
            _buildStatisticRow(FontAwesomeIcons.solidThumbsUp, "Like Count", widget.statistics.likeCount ?? ''),
            //_buildStatisticRow(FontAwesomeIcons.solidHeart, "Favorite Count", widget.statistics.favoriteCount??''),
            _buildStatisticRow(FontAwesomeIcons.solidComment, "Comment Count", widget.statistics.commentCount ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: ',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
