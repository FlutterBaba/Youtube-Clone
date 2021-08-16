import 'package:flutter/material.dart';
import 'package:youtubeapi/widgets/build_video.dart';
import '../models/channel_model.dart';
import '../models/video_model.dart';
import '../services/api_service.dart';
import '../screens/video_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Channel? _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        // sabir channnel id  UCVYQRygg-Xgh-VSuS8bF7Fw
        // flutterbaba channel id hare UCEvWoZNFpS3UQ4S0Y26JgIQ
        .fetchChannel(channelId: 'UCEvWoZNFpS3UQ4S0Y26JgIQ');
    setState(() {
      _channel = channel;
    });
  }

////////////////////
  _loadMoreVideos() async {
    _isLoading = true;
    List moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel!.uploadPlaylistId);
    List<dynamic> allVideos = _channel!.videos..addAll(moreVideos);
    if (mounted) {
      setState(() {
        _channel!.videos = allVideos;
      });
    }
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset("images/yt_logo_dark.png"),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cast),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            iconSize: 40,
            onPressed: () {},
            icon: _channel == null
                ? CircularProgressIndicator(
                    color: Theme.of(context).indicatorColor,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                      _channel!.profilePictureUrl,
                    ),
                  ),
          )
        ],
      ),
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel!.videos.length !=
                        int.parse(_channel!.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _channel!.videos.length,
                itemBuilder: (BuildContext context, int index) {
                  // if (index == 0) {
                  //   return _buildProfileInfo();
                  // }
                  Video video = _channel!.videos[index];
                  // Video video = _channel!.videos[index - 1];
                  return BuildVideo(
                    video: video,
                    channel: _channel,
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
