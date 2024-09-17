import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String videoUrl;
  final DataSourceType dataSourceType;
  const VideoPlayerView(
      {Key? key, required this.videoUrl, required this.dataSourceType})
      : super(key: key);

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();

    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
        break;
      case DataSourceType.network:
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        break;
      case DataSourceType.file:
        videoPlayerController =
            VideoPlayerController.file(File(widget.videoUrl));
        break;
      case DataSourceType.contentUri:
        videoPlayerController =
            VideoPlayerController.contentUri(Uri.parse(widget.videoUrl));
        break;
    }

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,

    );
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoPlayerController!.value.aspectRatio,
      child: Chewie(
        controller: chewieController!,
      ),
    );
  }
}
