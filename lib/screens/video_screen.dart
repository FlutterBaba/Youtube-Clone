import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtubeapi/models/channel_model.dart';
import 'package:youtubeapi/models/video_model.dart';
import 'package:youtubeapi/services/api_service.dart';
import 'package:youtubeapi/widgets/build_video.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  final Channel? channel;
  final Video? video;
  VideoScreen({required this.id, required this.channel, required this.video});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool _isLoading = false;
  _loadMoreVideos() async {
    _isLoading = true;
    List moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: widget.channel!.uploadPlaylistId);
    List<dynamic> allVideos = widget.channel!.videos..addAll(moreVideos);
    if (mounted) {
      setState(() {
        widget.channel!.videos = allVideos;
      });
    }
    _isLoading = false;
  }

  YoutubePlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: widget.channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    widget.channel!.videos.length !=
                        int.parse(widget.channel!.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.channel!.videos.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        YoutubePlayer(
                          
                          controller: _controller!,
                          showVideoProgressIndicator: true,
                          onReady: () {
                            print('Player is ready.');
                          },
                        ),
                        VideoInfo(
                          channel: widget.channel!,
                          video: widget.video!,
                        ),
                      ],
                    );
                  }
                  // Video video = widget.channel!.videos[index];
                  Video video = widget.channel!.videos[index - 1];
                  return BuildVideo(
                    video: video,
                    channel: widget.channel,
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).indicatorColor, // Red
                ),
              ),
            ),
    );
  }
}

class VideoInfo extends StatelessWidget {
  final Video video;
  final Channel? channel;
  const VideoInfo({
    required this.channel,
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.title,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 15.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            "",
            // '${video.viewCount} views • ${timeago.format(video.timestamp)}',
            style:
                Theme.of(context).textTheme.caption!.copyWith(fontSize: 14.0),
          ),
          const Divider(),
          _ActionsRow(video: video),
          const Divider(),
          _AuthorInfo(
            channel: channel,
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final Video video;

  const _ActionsRow({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAction(context, Icons.thumb_up_outlined, "78"),
        _buildAction(context, Icons.thumb_down_outlined, "10"),
        _buildAction(context, Icons.reply_outlined, 'Share'),
        _buildAction(context, Icons.download_outlined, 'Download'),
        _buildAction(context, Icons.library_add_outlined, 'Save'),
      ],
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 6.0),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final Channel? channel;

  const _AuthorInfo({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Navigate to profile'),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(channel!.profilePictureUrl),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    channel!.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15.0),
                  ),
                ),
                Flexible(
                  child: Text(
                    '${channel!.subscriberCount} subscribers',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'SUBSCRIBE',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
