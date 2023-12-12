import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/vlc_service/check_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../pip_package.dart';
import 'package:video_player/video_player.dart';

class NormalVideo extends StatefulWidget {
  const NormalVideo({Key? key}) : super(key: key);

  @override
  State<NormalVideo> createState() => _NormalVideoState();
}

class _NormalVideoState extends State<NormalVideo> {

  VideoPlayerController? videoPlayerController;
  ChewieController ? _chewieController;

  String url = 'https://gwc.disol.in/storage/uploads/users/feedback/L%20R%20Narayanan,_1_1_1_1_1_1_1.mp4';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initVideo();
  }

  initVideo(){
    videoPlayerController = VideoPlayerController.network(url);
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16/9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        hideControlsTimer: Duration(seconds: 3),
      showControls: true

    );
    // final _ori = MediaQuery.of(context).orientation;
    // print(_ori.name);
    // bool isPortrait = _ori == Orientation.portrait;
    // if(isPortrait){
    //   AutoOrientation.landscapeAutoMode();
    // }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      // body: videoView(),
      body: OverlayVideo(
        controller: _chewieController!,
      ),
      // body: Center(
      //   child: AspectRatio(
      //     aspectRatio: 16/9,
      //     child: Chewie(
      //       controller: _chewieController!,
      //     ),
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }
  bool isEnabled = false;
  videoView(){
    return PIPStack(
      shrinkAlignment: Alignment.bottomRight,
      backgroundWidget: Center(
        child: Container(
          child: TextButton(
            onPressed: (){
              initVideo();
              setState(() {
                isEnabled = !isEnabled;
              });
            },
            child: Text("Video"),
          ),
        ),
      ),
      pipWidget: isEnabled
          ? Consumer<CheckState>(
        builder: (_, model, __) {
          WakelockPlus.enable();
          print("model.isChanged: ${model.isChanged} $isEnabled");
          if (model.isChanged) {}
          // return AspectRatio(
          //   aspectRatio: 16 / 9,
          //   child: md.MeeduVideoPlayer(
          //     controller: _meeduPlayerController,
          //   ),
          // );

          return Chewie(controller: _chewieController!);
        },
      )
          : const SizedBox(),
      pipEnabled: isEnabled,
      pipExpandedHeight: double.infinity,
      onClosed: () async {
        // await _controller.stop();
        // await _controller.dispose();
        setState(() {
          isEnabled = !isEnabled;
        });
        if (await WakelockPlus.enabled) {
          WakelockPlus.disable();
        }
        if (_chewieController != null) _chewieController!.pause();
      },
      onPip: () async {
        setState(() {
          isEnabled = true;
        });
        final _ori = MediaQuery.of(context).orientation;
        print(_ori.name);
        bool isPortrait = _ori == Orientation.portrait;
        if (!isPortrait) {
          AutoOrientation.portraitUpMode();
        }
      },
    );
  }

  bool isVisible = false;
  // overlayVideo(){
  //   return (_chewieController != null)
  //       ? GestureDetector(
  //     onTap: (){
  //       print("tapped");
  //       toggleControls();
  //     },
  //     child: Stack(
  //       children: [
  //         ColoredBox(
  //           color: Colors.black,
  //           child: AspectRatio(
  //             aspectRatio: 16/9,
  //             child: Chewie(
  //               controller: _chewieController!,
  //             ),
  //           ),
  //         ),
  //         if(isVisible)Positioned(child: AspectRatio(
  //           aspectRatio: 16/9,
  //           child: Center(
  //             child: FittedBox(
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   IconButton(
  //                     onPressed: () => _seekRelative(_seekStepBackward),
  //                     color: Colors.white,
  //                     iconSize: _seekButtonIconSize,
  //                     icon: Icon(Icons.replay_10),
  //                   ),
  //                   IconButton(
  //                     onPressed: (){
  //                       if(videoPlayerController!.value.isPlaying){
  //                         videoPlayerController!.pause();
  //                       }
  //                       else{
  //                         videoPlayerController!.play();
  //                       }
  //                       setState(() {
  //
  //                       });
  //                     },
  //                     color: Colors.white,
  //                     iconSize: _playButtonIconSize,
  //                     icon: (videoPlayerController!.value.isPlaying) ? Icon(Icons.pause)  : Icon(Icons.play_arrow),
  //                   ),
  //                   IconButton(
  //                     onPressed: () => _seekRelative(_seekStepForward),
  //                     color: Colors.white,
  //                     iconSize: _seekButtonIconSize,
  //                     icon: Icon(Icons.forward_10),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ))
  //       ],
  //     ),
  //   )
  //       : ColoredBox(
  //     color: Colors.black,
  //     child: AspectRatio(
  //       aspectRatio: 16/9,
  //       child: CircularProgressIndicator(color: Colors.white,),
  //     ),
  //   );
  // }

  toggleControls(){
    setState(() {
      isVisible = !isVisible;
    });
  }
}


class OverlayVideo extends StatefulWidget {
  final ChewieController controller;
  bool isControlsVisible;
  OverlayVideo({Key? key, required this.controller, this.isControlsVisible = true}) : super(key: key);

  static const double _playButtonIconSize = 40;
  static const double _seekButtonIconSize = 28;

  static const Duration _seekStepForward = Duration(seconds: 10);
  static const Duration _seekStepBackward = Duration(seconds: -10);

  @override
  State<OverlayVideo> createState() => _OverlayVideoState();
}

class _OverlayVideoState extends State<OverlayVideo> {

  bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVisible = widget.isControlsVisible;

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toggleControls(),
      child: Stack(
        children: [
          ColoredBox(
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: 16/9,
              child: Chewie(
                controller: widget.controller,
              ),
            ),
          ),
          if(isVisible)Positioned(child: AspectRatio(
            aspectRatio: 16/9,
            child: Center(
              child: FittedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _seekRelative(OverlayVideo._seekStepBackward),
                      color: Colors.white,
                      iconSize: OverlayVideo._seekButtonIconSize,
                      icon: Icon(Icons.replay_10),
                    ),
                    IconButton(
                      onPressed: (){
                        if(widget.controller.videoPlayerController.value.isPlaying){
                          widget.controller.videoPlayerController.pause();
                        }
                        else{
                          widget.controller.videoPlayerController.play();
                        }
                        toggleControls();
                        setState(() {

                        });
                      },
                      color: Colors.white,
                      iconSize: OverlayVideo._playButtonIconSize,
                      icon: (widget.controller.videoPlayerController.value.isPlaying) ? Icon(Icons.pause)  : Icon(Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: () => _seekRelative(OverlayVideo._seekStepForward),
                      color: Colors.white,
                      iconSize: OverlayVideo._seekButtonIconSize,
                      icon: Icon(Icons.forward_10),
                    ),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Future<void> _seekRelative(Duration seekStep) async {
    if (widget.controller.videoPlayerController.value.duration != null) {
      await widget.controller.videoPlayerController.seekTo(widget.controller.videoPlayerController.value.position + seekStep);
    }
  }

  toggleControls(){
    setState(() {
      isVisible = !isVisible;
    });
  }
}
