import 'package:flutter/material.dart';
import 'package:youtubeapi/models/channel_model.dart';
import 'package:youtubeapi/models/video_model.dart';
import 'package:youtubeapi/screens/video_screen.dart';

class BuildVideo extends StatelessWidget {
  final Video video;
  final Channel? channel;
  const BuildVideo({
    required this.channel,
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(
            id: video.id,
            video: video,
            channel: channel,
          ),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Image.network(
                  video.thumbnailUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8.0,
                right: 20.0,
                child: Container(
                  color: Colors.black,
                  child: Text(
                    "video.title",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => print("Navigate to profile"),
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(channel!.profilePictureUrl),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 15),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          channel!.title,
                          // "${video.author.username}.${video.viewCount} views ${timeago.format(video.timestamp)}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          channel!.subscriberCount,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
