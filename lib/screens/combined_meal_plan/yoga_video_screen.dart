import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class YogaVideoPlayer extends StatefulWidget {
  final String url;
  const YogaVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<YogaVideoPlayer> createState() => _YogaVideoPlayerState();
}

class _YogaVideoPlayerState extends State<YogaVideoPlayer> {
  VideoPlayerController? _sheetVideoController, _yogaVideoController;
  ChewieController? _sheetChewieController, _yogaChewieController;

  initChewieView(String? url) {
    print("init url: $url");
    _yogaVideoController =
        VideoPlayerController.network(Uri.parse(url!).toString());
    _yogaChewieController = ChewieController(
      videoPlayerController: _yogaVideoController!,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      showOptions: false,
      autoPlay: true,
      allowedScreenSleep: false,
      hideControlsTimer: Duration(seconds: 3),
      showControls: true,

    );

    // final _ori = MediaQuery.of(context).orientation;
    // print(_ori.name);
    // bool isPortrait = _ori == Orientation.portrait;
    // if (isPortrait) {
    //   AutoOrientation.landscapeAutoMode();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return initChewieView(widget.url);
  }
}
