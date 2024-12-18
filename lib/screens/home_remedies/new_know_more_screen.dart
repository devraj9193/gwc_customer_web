/*
not using this screen
 */

import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/video/normal_video.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:video_player/video_player.dart';

class NewKnowMoreScreen extends StatefulWidget {
  final String title;
  final String knowMore;
  final String healAtHome;
  final String healAnywhere;
  final String whenToReachUs;
  const NewKnowMoreScreen(
      {Key? key,
        required this.knowMore,
        required this.healAtHome,
        required this.healAnywhere,
        required this.whenToReachUs,
        required this.title})
      : super(key: key);

  @override
  State<NewKnowMoreScreen> createState() => _NewKnowMoreScreenState();
}

class _NewKnowMoreScreenState extends State<NewKnowMoreScreen> {
  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;

  addUrlToVideoPlayerChewie(String url) {
    print("url" + url);
    videoPlayerController = VideoPlayerController.network(url);
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        // customControls: Center(
        //   child: FittedBox(
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepBackward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.replay_10),
        //         ),
        //         IconButton(
        //           onPressed: (){
        //             if(videoPlayerController!.value.isPlaying){
        //               videoPlayerController!.pause();
        //             }
        //             else{
        //               videoPlayerController!.play();
        //             }
        //             setState(() {
        //
        //             });
        //           },
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: (videoPlayerController!.value.isPlaying) ? Icon(Icons.pause)  : Icon(Icons.play_arrow),
        //         ),
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepForward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.forward_10),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        hideControlsTimer: Duration(seconds: 3),
        showControls: false);
  }

  // final _key = GlobalKey<VlcPlayerWithControlsState>();
  // VlcPlayerController? _videoPlayerController;
  // addUrlToVideoPlayer(String url) {
  //   print("url" + url);
  //   _videoPlayerController = VlcPlayerController.network(
  //     Uri.parse(url).toString(),
  //     //  "https://gwc.disol.in/dist/img/GMG-Podcast-%20CMN.mp4",
  //     //  'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.disabled,
  //     autoPlay: true,
  //     options: VlcPlayerOptions(
  //       advanced: VlcAdvancedOptions([
  //         VlcAdvancedOptions.networkCaching(2000),
  //       ]),
  //       subtitle: VlcSubtitleOptions([
  //         VlcSubtitleOptions.boldStyle(true),
  //         VlcSubtitleOptions.fontSize(30),
  //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
  //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
  //         // works only on externally added subtitles
  //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
  //       ]),
  //       http: VlcHttpOptions([
  //         VlcHttpOptions.httpReconnect(true),
  //       ]),
  //       rtp: VlcRtpOptions([
  //         VlcRtpOptions.rtpOverRtsp(true),
  //       ]),
  //     ),
  //   );
  // }

  @override
  void dispose() async {
    super.dispose();
    print('dispose');
    if (videoPlayerController != null) videoPlayerController!.dispose();
    if (_chewieController != null) _chewieController!.dispose();
    // if(_videoPlayerController != null){
    //   await _videoPlayerController!.stop();
    //   await _videoPlayerController!.stopRendererScanning();
    //   await _videoPlayerController!.dispose();
    // }
  }

  @override
  void initState() {
    super.initState();
    loadAsset('placeholder.png');
  }

  ByteData? placeHolderImage;

  void loadAsset(String name) async {
    var data = await rootBundle.load('assets/images/$name');
    setState(() => placeHolderImage = data);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                buildAppBar(
                      () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 2.h),
                TabBar(
                  // padding: EdgeInsets.symmetric(horizontal: 3.w),
                    labelColor: gBlackColor,
                    unselectedLabelColor: gHintTextColor,
                    isScrollable: true,
                    indicatorColor: gsecondaryColor,
                    labelPadding:
                    EdgeInsets.only(right: 8.w, top: 1.h, bottom: 1.h),
                    // indicatorPadding: EdgeInsets.only(right: 5.w),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: kFontBook,
                        color: gHintTextColor,
                        fontSize: 12.dp),
                    labelStyle: TextStyle(
                        fontFamily: kFontMedium,
                        color: gBlackColor,
                        fontSize: 15.dp),
                    tabs: const [
                      Text('Know More'),
                      Text("Heal At Home"),
                      // Text('Heal Anywhere'),
                      Text("When To Reach Us?"),
                    ]),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    padding: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: gsecondaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      widget.title ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: eUser().mainHeadingFont,
                          color: eUser().buttonTextColor,
                          fontSize: eUser().mainHeadingFontSize),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        buildKnowMoreDetails(),
                        buildHealAtHomeDetails(),
                        // buildHealAnywhereDetails(),
                        buildWhenToReachUsDetails(),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildKnowMoreDetails() {
    final a = widget.knowMore;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      addUrlToVideoPlayerChewie(a);
      // addUrlToVideoPlayer(a);
    }
    print("KnowMore : ${widget.knowMore}");
    return buildZoomImage(widget.knowMore);
  }

  buildHealAtHomeDetails() {
    final a = widget.healAtHome;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      addUrlToVideoPlayerChewie(a);
    }
    return buildZoomImage(widget.healAtHome);
  }

  buildHealAnywhereDetails() {
    final a = widget.healAnywhere;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      addUrlToVideoPlayerChewie(a);
    }
    return  buildZoomImage(widget.healAnywhere);
  }

  buildWhenToReachUsDetails() {
    final a = widget.whenToReachUs;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      addUrlToVideoPlayerChewie(a);
    }
    return  buildZoomImage(widget.whenToReachUs);
  }

  buildZoomImage(String knowMore) {
    final file = knowMore.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Center(
          child: buildTestimonial(),
        ),
      );
    }
    else {
      return Padding(
        padding: EdgeInsets.only(bottom: 5.h,top: 1.h),
        child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: Center(
            child:  ImageNetwork(
              image: knowMore,
              height: 100.h,
              width: 100.w,
              fitAndroidIos: BoxFit.contain,
              fitWeb: BoxFitWeb.contain,
              onLoading: const CircularProgressIndicator(
                color: Colors.indigoAccent,
              ),
              onError: Image.asset(
                  "assets/images/placeholder.png"),
              onTap: () {
                debugPrint("©gabriel_patrick_souza");
              },
            ),
            // FadeInImage(
            //   placeholder: AssetImage("assets/images/placeholder.png"),
            //   image: NetworkImage("${Uri.parse(knowMore)}"),
            //   imageErrorBuilder: (_, __, ___) {
            //     return Image.asset("assets/images/placeholder.png");
            //   },
            // ),
            // child: FadeInImage.memoryNetwork(
            //   placeholder: placeHolderImage!.buffer.asUint8List(),
            //   image: "${Uri.parse(knowMore)}",
            // ),
          ),
          // Image.network(
          //   "${Uri.parse(knowMore)}",
          // ),
          // child: Center(
          //   child: PhotoView(
          //     imageProvider:
          //         CachedNetworkImageProvider("${Uri.parse(widget.knowMore)}"),
          //   ),
          // ),
        ),
      );
    }
  }

  buildTestimonial() {
    if (_chewieController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: gPrimaryColor, width: 1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     blurRadius: 20,
            //     offset: const Offset(2, 10),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Center(
              child: OverlayVideo(
                controller: _chewieController!,
              ),
            ),
          ),
          // child: Stack(
          //   children: <Widget>[
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(5),
          //       child: Center(
          //         child: VlcPlayer(
          //           controller: _videoPlayerController!,
          //           aspectRatio: 16 / 9,
          //           virtualDisplay: false,
          //           placeholder: Center(child: CircularProgressIndicator()),
          //         ),
          //       ),
          //     ),
          //     ControlsOverlay(controller: _videoPlayerController,)
          //   ],
          // ),
        ),
      );
    }
    // else if (_videoPlayerController != null){
    //   return AspectRatio(
    //     aspectRatio: 16 / 9,
    //     child: Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //         border: Border.all(color: gPrimaryColor, width: 1),
    //         // boxShadow: [
    //         //   BoxShadow(
    //         //     color: Colors.grey.withOpacity(0.3),
    //         //     blurRadius: 20,
    //         //     offset: const Offset(2, 10),
    //         //   ),
    //         // ],
    //       ),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(5),
    //         child: Center(
    //           child: VlcPlayerWithControls(
    //             key: _key,
    //             controller: _videoPlayerController!,
    //             showVolume: false,
    //             showVideoProgress: false,
    //             seekButtonIconSize: 10.sp,
    //             playButtonIconSize: 14.sp,
    //             replayButtonSize: 10.sp,
    //           ),
    //           // child: VlcPlayer(
    //           //   controller: _videoPlayerController!,
    //           //   aspectRatio: 16 / 9,
    //           //   virtualDisplay: false,
    //           //   placeholder: Center(child: CircularProgressIndicator()),
    //           // ),
    //         ),
    //       ),
    //       // child: Stack(
    //       //   children: <Widget>[
    //       //     ClipRRect(
    //       //       borderRadius: BorderRadius.circular(5),
    //       //       child: Center(
    //       //         child: VlcPlayer(
    //       //           controller: _videoPlayerController!,
    //       //           aspectRatio: 16 / 9,
    //       //           virtualDisplay: false,
    //       //           placeholder: Center(child: CircularProgressIndicator()),
    //       //         ),
    //       //       ),
    //       //     ),
    //       //     ControlsOverlay(controller: _videoPlayerController,)
    //       //   ],
    //       // ),
    //     ),
    //   );
    // }
    else {
      return const SizedBox.shrink();
    }
  }
}
