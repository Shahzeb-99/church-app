
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

import '../models/announcment/announcement.dart';

class AnnouncementWidget extends StatelessWidget {
  final NotificationItem announcement;

  const AnnouncementWidget({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(announcement.title ?? '',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor)),
            SizedBox(height: 8),
            Text(
              announcement.body ?? '',
              style: TextStyle(color: Colors.grey[800]),
            ),
            SizedBox(height: 8),
            Text(
              timeago.format(announcement.timestamp ?? DateTime.now()),
              style: TextStyle(color: Colors.grey),
            ),
            if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                   imageUrl: announcement.imageUrl!,
                    progressIndicatorBuilder: (context,s,a)=>CupertinoActivityIndicator(),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
