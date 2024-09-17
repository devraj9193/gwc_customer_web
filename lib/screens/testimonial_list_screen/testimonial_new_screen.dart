import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

import '../../model/error_model.dart';
import '../../model/new_user_model/about_program_model/about_program_model.dart';
import '../../model/new_user_model/about_program_model/feedback_list_model.dart';
import '../../repository/api_service.dart';
import '../../repository/new_user_repository/about_program_repository.dart';
import '../../services/new_user_service/about_program_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/video/normal_video.dart';
import '../../widgets/widgets.dart';

class TestimonialNewScreen extends StatefulWidget {
  const TestimonialNewScreen({Key? key}) : super(key: key);

  @override
  State<TestimonialNewScreen> createState() => _TestimonialNewScreenState();
}

class _TestimonialNewScreenState extends State<TestimonialNewScreen> {
  late AboutProgramService _aboutProgramService;
  VideoPlayerController? _sheetVideoController;
  ChewieController? _sheetChewieController;

  late Future _getTestimonialList;

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aboutProgramService = AboutProgramService(repository: repository);
    getFuture();
    wake();
  }

  wake() async {
    if (await WakelockPlus.enabled == false) {
      WakelockPlus.enable();
    }
  }

  getFuture() {
    _getTestimonialList = _aboutProgramService.serverAboutProgramService();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: gBackgroundColor,
        body: Column(
          children: [
            Container(
              height: h/2.2,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.grey,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 1.h,
                    left: 2.w,
                    right: 0,
                    child: buildAppBar(
                      () {},
                      isBackEnable: false,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 4.h,
                    child: Column(
                      children: [
                        Image(
                          image: const AssetImage(
                            "assets/images/Group 9757.png",
                          ),
                          height: 30.h,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Feedback",
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontSize: eUser().mainHeadingFontSize,
                            fontFamily: kFontBold,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          "Here are our success stories",
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontSize: eUser().mainHeadingFontSize,
                            fontFamily: kFontBook,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(width: MediaQuery.of(context).size.shortestSide > 600 ? 50.w : double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: newUI(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  newUI() {
    return FutureBuilder(
        future: _getTestimonialList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.runtimeType == ErrorModel) {
                var model = snapshot.data as ErrorModel;
                return Center(
                  child: Text(
                    model.message ?? '',
                    style: TextStyle(fontFamily: kFontMedium, fontSize: 10.sp),
                  ),
                );
              } else {
                var model = snapshot.data as AboutProgramModel;
                List<FeedbackList> feedbackList =
                    model.data?.feedbackList ?? [];
                if (feedbackList.isEmpty) {
                  return noData();
                } else {
                  return ListView.builder(
                      itemCount: feedbackList.length,
                      itemBuilder: (_, index) {
                        print(
                            "feedbackList[index].file: ${feedbackList[index].file.runtimeType}");
                        return showCardViews(
                          userProfile:
                              feedbackList[index].addedBy?.profile ?? '',
                          feedbackTime: DateFormat('dd MMM yyyy , hh:mm a')
                              .format(DateTime.parse(
                                      feedbackList[index].addedBy?.createdAt ??
                                          '')
                                  .toLocal()),
                          feedbackUser: feedbackList[index].addedBy?.name ?? '',
                          feedback: feedbackList[index].feedback,
                          imagePath: (feedbackList[index].file == null)
                              ? null
                              : feedbackList[index].file?.first,
                          rating: feedbackList[index].rating,
                        );
                      });
                }
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(fontFamily: kFontMedium, fontSize: 10.sp),
                ),
              );
            }
          }
          return Center(
            child: buildCircularIndicator(),
          );
        });
  }

  noData() {
    return const Center(
      child: Image(
        image: AssetImage("assets/images/no_data_found.png"),
        fit: BoxFit.scaleDown,
      ),
    );
  }

  showCardViews({
    String? userProfile,
    String? feedbackUser,
    String? feedbackTime,
    String? feedback,
    String? imagePath,
    String? rating,
  }) {
    final a = imagePath;
    print("testimonial url : $a");
    final file = a?.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      if (a != null) addUrlToVideoPlayerChewie(a);
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: gHintTextColor.withOpacity(0.35),
                // spreadRadius: 0.3,
                blurRadius: 5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10.h,
                width: 8.w,
                decoration: BoxDecoration(
                  color: gsecondaryColor,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: AssetImage("assets/images/meal_placeholder.png"),
                    fit: BoxFit.fill
                  ),
                ),
                // child: Image(
                //   image: AssetImage("assets/images/meal_placeholder.png"),
                //   // CachedNetworkImageProvider(userProfile ?? ''),
                //   fit: BoxFit.fill,
                // ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedbackUser ?? '',
                      style: TextStyle(
                          fontSize: 15.dp, fontFamily: kFontBold, height: 1.5),
                    ),
                    Text(
                      feedbackTime ?? '',
                      style: TextStyle(
                          fontSize: 12.5.dp, fontFamily: kFontBook, height: 1.5),
                    ),
                    buildRating(
                      double.parse(
                        rating.toString(),
                      ),
                    ),
                    // Text(
                    //   rating ?? '',
                    //   style: TextStyle(
                    //       fontSize: 9.5.sp, fontFamily: kFontBook, height: 1.5),
                    // ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showImage(imagePath ?? '');
                  // addTrackerUrlToVideoPlayer(widget.trackerVideoLink ?? '');
                },
                child: SizedBox(
                  height: 12.h,
                  child: Lottie.asset(
                      'assets/lottie/Animation - 1701175879899.json'),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.5.h),
            child: Text(
              feedback ??
                  "Lorem Ipsum is simply dummy text of the print and typesetting industry",
              style: TextStyle(
                  fontSize: 13.dp, fontFamily: kFontMedium, height: 1.5),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.format_quote_rounded,
              color: gGreyColor.withOpacity(0.5),
              size: 7.h,
            ),
          ),
          // SizedBox(
          //   height: 1.h,
          // ),
          // if (format == "mp4") buildTestimonial(),
          // Visibility(
          //   visible: imagePath != null && format != "mp4",
          //   child: Center(
          //     child: Container(
          //       width: 70.w,
          //       height: 30.h,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(14),
          //           image: DecorationImage(
          //               image: CachedNetworkImageProvider(
          //             imagePath ?? '',
          //             errorListener: (message) {
          //               Image.asset('assets/images/placeholder.png');
          //             },
          //             // placeholder: (_, __){
          //             //   return Image.asset('assets/images/top-view-indian-food-assortment.png');
          //             // },
          //           ))),
          //       // child: Card(
          //       //   child: CachedNetworkImage(
          //       //     imageUrl: imagePath ?? '',
          //       //     placeholder: (_, __){
          //       //       return Image.asset('assets/images/top-view-indian-food-assortment.png');
          //       //     },
          //       //   ),
          //       // ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildRating(double rating) {
    return SmoothStarRating(
      color: kBottomSheetHeadYellow,
      borderColor: gWhiteColor,
      rating: rating,
      size: 15,
      filledIconData: Icons.star_sharp,
      halfFilledIconData: Icons.star_half_sharp,
      defaultIconData: Icons.star_outline_sharp,
      starCount: 5,
      allowHalfRating: false,
      spacing: 1.0,
    );
  }

  Future showImage(String attachmentUrl) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent.withOpacity(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0.dp),
          ),
        ),
        contentPadding: EdgeInsets.only(top: 1.h),
        content: buildTestimonial(),
      ),
    );
  }

  buildTestimonial() {
    if (_chewieController != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                videoPlayerController?.pause();
              },
              child: Icon(
                Icons.close,
                color: gWhiteColor,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          AspectRatio(
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
                  isControlsVisible: true,
                )),
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
          ),
        ],
      );
    }
    // else if (_videoPlayerController != null) {
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

  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;

  addUrlToVideoPlayerChewie(String url) {
    print("url" + url);
    videoPlayerController =
        VideoPlayerController.network(Uri.parse(url).toString());
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: false,
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
  //     // "https://gwc.disol.in/dist/img/GMG-Podcast-%20CMN.mp4",
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     //'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.disabled,
  //     autoPlay: false,
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
    print('dispose testimonials');
    if (await WakelockPlus.enabled == true) {
      WakelockPlus.disable();
    }
    if (_chewieController != null) _chewieController!.dispose();
    if (videoPlayerController != null) videoPlayerController!.dispose();
    // if(_videoPlayerController != null){
    //   await _videoPlayerController!.stop();
    //   await _videoPlayerController!.stopRendererScanning();
    //   await _videoPlayerController!.dispose();
    // }
  }

  loadAsset(String name) {
    rootBundle.load('assets/images/$name').then((value) {
      if (value != null) {
        return value.buffer.asUint8List();
      }
    });
  }
}
