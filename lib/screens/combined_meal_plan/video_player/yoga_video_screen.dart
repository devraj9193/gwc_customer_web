import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class YogaVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String heading;
  final bool isRemedies;
  const YogaVideoPlayer(
      {Key? key,
      required this.videoUrl,
      required this.heading,
      this.isRemedies = false})
      : super(key: key);

  @override
  State<YogaVideoPlayer> createState() => _YogaVideoPlayerState();
}

class _YogaVideoPlayerState extends State<YogaVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 / 9, // Adjust aspect ratio according to the video
      autoPlay: true,
      looping: false,
      allowFullScreen: true, // Enables fullscreen mode
      fullScreenByDefault: false, // Fullscreen not enabled by default
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isRemedies
        ? Center(
            child: Chewie(
              controller: _chewieController!,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: buildAppBar(
                () {
                  Navigator.pop(context);
                },
                showLogo: false,
                showChild: true,
                child: Text(
                  widget.heading,
                  style: TextStyle(
                      fontFamily: eUser().mainHeadingFont,
                      color: eUser().mainHeadingColor,
                      fontSize: eUser().mainHeadingFontSize),
                ),
              ),
            ),
            body: Center(
              child: Chewie(
                controller: _chewieController!,
              ),
            ),
          );
  }
}
