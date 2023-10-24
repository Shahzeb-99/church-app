import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saintpopekerollosvi/models/video/get_video_response.dart';
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

  @override
  void initState() {
    super.initState();

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
                            Text(
                              widget.item.snippet?.description ?? 'No description added',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
