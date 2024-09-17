import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:video_player/video_player.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class MealPlanYogaVideo extends StatefulWidget {
  final String videoUrl;
  final String heading;
  const MealPlanYogaVideo(
      {Key? key, required this.videoUrl, required this.heading})
      : super(key: key);

  @override
  State<MealPlanYogaVideo> createState() => _MealPlanYogaVideoState();
}

class _MealPlanYogaVideoState extends State<MealPlanYogaVideo> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
        });
        videoPlayerController?.play(); // Auto-play after initialization
      });

    print("yoga video : ${widget.videoUrl}");

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: true,
      // customControls: const CustomControls(), // Set your custom controls here
      overlay: widget.videoUrl.split('.').last == "mp4"
          ? const SizedBox()
          : _buildOverlay(), // Custom overlay
    );
  }

  Widget _buildOverlay() {
    return Center(
      child: Image.asset(
        'assets/images/Gut welness logo.png',
        height: 20.h,
      ), // Center image overlay
    );
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("---- YOGA VIDEO ----");
    return Scaffold(
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Chewie(
              controller: chewieController!,
            ),
    );
  }
}

class CustomControls extends StatelessWidget {
  const CustomControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.replay_10, color: Colors.white),
            onPressed: () {
              final controller = ChewieController.of(context);
              controller.videoPlayerController.seekTo(
                controller.videoPlayerController.value.position -
                    Duration(seconds: 10),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.pause, color: Colors.white),
            onPressed: () {
              ChewieController.of(context).pause();
            },
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () {
              ChewieController.of(context).play();
            },
          ),
          IconButton(
            icon: const Icon(Icons.forward_10, color: Colors.white),
            onPressed: () {
              final controller = ChewieController.of(context);
              controller.videoPlayerController.seekTo(
                controller.videoPlayerController.value.position +
                    Duration(seconds: 10),
              );
            },
          ),
        ],
      ),
    );
  }
}

//   VideoPlayerController? videoPlayerController;
//   ChewieController? chewieController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     print("video url : ${widget.videoUrl}");
//
//     videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//
//     chewieController = ChewieController(
//       videoPlayerController: videoPlayerController!,
//       autoInitialize: true,
//       autoPlay: true,
//       showOptions: true,
//       showControls: true,
//       placeholder: Align(
//         alignment: Alignment.topLeft,
//         child: Padding(
//           padding: EdgeInsets.only(top: 2.h, left: 3.w),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   print("video");
//                   setState(() {
//                     videoPlayerController?.pause();
//                     videoPlayerController?.dispose();
//
//                     Navigator.pop(context);
//                   });
//                 },
//                 child: Icon(
//                   Icons.arrow_back_ios,
//                   size: 3.5.h,
//                   color: gBlackColor,
//                 ),
//               ),
//               Text(
//                 widget.heading,
//                 style: TextStyle(
//                     fontFamily: eUser().mainHeadingFont,
//                     color: eUser().mainHeadingColor,
//                     fontSize: eUser().mainHeadingFontSize),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // placeholder: Align(
//       //   alignment: Alignment.topLeft,
//       //   child: Icon(
//       //     Icons.arrow_back_ios,
//       //     size: 2.5.h,
//       //     color: gWhiteColor,
//       //   ),
//       // ),
//       // customControls: Align(
//       //   alignment: Alignment.topLeft,
//       //   child: Icon(
//       //     Icons.arrow_back_ios,
//       //     size: 2.5.h,
//       //     color: gWhiteColor,
//       //   ),
//       // ),
//     );
//   }
//
//   @override
//   void dispose() {
//     videoPlayerController!.dispose();
//     chewieController!.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: SafeArea(
//           child: SizedBox(
//             width: double.maxFinite,
//             height: double.maxFinite,
//             child: Chewie(
//               controller: chewieController!,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _onWillPop() async {
//     print('back pressed splash');
//
//     videoPlayerController?.pause();
//     videoPlayerController?.dispose();
//
//     Navigator.pop(context);
//     return Future.value(false);
//   }
// }
