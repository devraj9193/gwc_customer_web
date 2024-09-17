import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class MealPlanPortraitVideo extends StatefulWidget {
  final String videoUrl;
  final String heading;
  const MealPlanPortraitVideo(
      {Key? key, required this.videoUrl, required this.heading})
      : super(key: key);

  @override
  State<MealPlanPortraitVideo> createState() => _MealPlanPortraitVideoState();
}

class _MealPlanPortraitVideoState extends State<MealPlanPortraitVideo> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      aspectRatio: 9 / 16, // Aspect ratio for vertical video
      autoPlay: true,
      looping: true,
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
      body: Center(
        child: Chewie(
          controller: chewieController!,
        ),
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
