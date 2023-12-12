/*
we hiding 2nd video player which is for about program video

we r storing the pdf about program pdf in local using [getCachedPdfViewer]

from getCachedPdfViewer we r checking data is null or not -
*  if null than fetching from Network else fetching from file

Api used->
var getAboutProgramUrl = "${AppConfig().BASE_URL}/api/list/welcome_screen";


 */

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../model/error_model.dart';
import '../../../model/new_user_model/about_program_model/about_program_model.dart';
import '../../../model/new_user_model/about_program_model/child_about_program.dart';
import '../../../model/new_user_model/about_program_model/feedback_list_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/new_user_repository/about_program_repository.dart';
import '../../../services/new_user_service/about_program_service.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/video/normal_video.dart';
import '../../../widgets/vlc_player/controls_overlay.dart';
import '../../../widgets/widgets.dart';
import 'choose_your_problem_screen.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:video_player/video_player.dart';

class AboutTheProgram extends StatefulWidget {
  final bool isFromSitBackScreen;
  AboutTheProgram({Key? key, this.isFromSitBackScreen = false})
      : super(key: key);

  @override
  State<AboutTheProgram> createState() => _AboutTheProgramState();
}

class _AboutTheProgramState extends State<AboutTheProgram> {
  // final _key = GlobalKey<VlcPlayerWithControlsState>();
  // final _abtProgramVideoKey = GlobalKey<VlcPlayerWithControlsState>();

  double rating = 4.5;
  final pageController = PageController();
  final reviewPageController = PageController();

  late AboutProgramService _aboutProgramService;

  late Future _aboutProgramFuture;

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
    _aboutProgramFuture = _aboutProgramService.serverAboutProgramService();
  }

  addUrlToVideoPlayerChewie(String url) {
    print("url" + url);
    testimonialVideoController =
        VideoPlayerController.network(Uri.parse(url).toString());
    _testimonialChewieController = ChewieController(
        videoPlayerController: testimonialVideoController!,
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

  // VlcPlayerController? _videoPlayerController, _abtProgramPlayerController;
  // addUrlToVideoPlayer(String url){
  //   print("url"+ url);
  //   _videoPlayerController = VlcPlayerController.network(
  //     Uri.parse(url).toString(),
  //     // url,
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.auto,
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
  // addUrlToAboutProgramVideoPlayer(String url){
  //   print("url"+ url);
  //   _abtProgramPlayerController = VlcPlayerController.network(
  //     Uri.parse(url).toString(),
  //     // url,
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.auto,
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

  addUrlToAboutProgramVideoPlayerChewie(String url) {
    videoPlayerController =
        VideoPlayerController.network(Uri.parse(url).toString());
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        hideControlsTimer: Duration(seconds: 3),
        showControls: false);
  }

  @override
  void dispose() async {
    super.dispose();
    print('dispose');
    if (await WakelockPlus.enabled == true) {
      WakelockPlus.disable();
    }
    // if(_videoPlayerController != null){
    //   await _videoPlayerController!.stop();
    //   await _videoPlayerController!.stopRendererScanning();
    //   await _videoPlayerController!.dispose();
    // }
    // if(_abtProgramPlayerController != null){
    //   await _abtProgramPlayerController!.stop();
    //   await _abtProgramPlayerController!.stopRendererScanning();
    //   await _abtProgramPlayerController!.dispose();
    // }

    if (videoPlayerController != null) videoPlayerController!.dispose();
    if (_chewieController != null) _chewieController!.dispose();

    if (testimonialVideoController != null)
      testimonialVideoController!.dispose();
    if (_testimonialChewieController != null)
      _testimonialChewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBack,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: gBackgroundColor,
          body: Padding(
            padding:
                EdgeInsets.only(left: 1.w, right: 1.w, top: 1.h, bottom: 1.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 1.5.w, right: 1.5.w),
                    child: buildAppBar(() {
                      if (_chewieController != null) {
                        _chewieController!.pause();
                        // final show = _chewieController!.videoPlayerController.value.isPlaying;
                        // if(show != null && show == true){
                        //   _chewieController!.pause();
                        // }
                        print("tap");
                        final res;
                        Navigator.pop(context);
                      }
                    })),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                  child: _mainView(),
                ),
                Visibility(
                  visible: !widget.isFromSitBackScreen,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          // pauseAllVideo();
                          if (_chewieController != null) {
                            _chewieController!.pause();
                            // final show = _chewieController!.videoPlayerController.value.isPlaying;
                            // if(show != null && show == true){
                            //   _chewieController!.pause();
                            // }
                            print("tap");
                            final res;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          }
                          // if(_testimonialChewieController != null){
                          //   _testimonialChewieController!.dispose();
                          //
                          //   // final show = _testimonialChewieController!.videoPlayerController.value.isPlaying;
                          //   // if(show != null && show == true){
                          //   //   _testimonialChewieController!.pause();
                          //   // }
                          // }
                        },
                        child: Container(
                          width: 40.w,
                          height: 5.h,
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: eUser().buttonColor,
                            borderRadius: BorderRadius.circular(
                                eUser().buttonBorderRadius),
                            // border: Border.all(
                            //     color: eUser().buttonBorderColor,
                            //     width: eUser().buttonBorderWidth
                            // ),
                          ),
                          child: Center(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontFamily: eUser().buttonTextFont,
                                color: eUser().buttonTextColor,
                                fontSize: eUser().buttonTextSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onBack() async {
    _chewieController?.pause();
    Navigator.pop(context);
    return true;
  }

  bool isAllVideoPause = false;

  _mainView() {
    return Padding(
        padding: EdgeInsets.only(left: 4.w, right: 4.w),
        child: FutureBuilder(
          future: _aboutProgramFuture,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.runtimeType == AboutProgramModel) {
                AboutProgramModel _programModel =
                    snapshot.data as AboutProgramModel;
                ChildAboutProgramModel? _aboutProgramText = _programModel.data;
                // #1
                String aboutProgramPdf =
                    _aboutProgramText?.aboutProgram?.aboutPdf ?? '';
                if (_aboutProgramText!.aboutProgram != null &&
                    _aboutProgramText.aboutProgram!.aboutProgramVideo != null) {
                  String videoLink =
                      _aboutProgramText.aboutProgram?.aboutProgramVideo ?? '';
                  // addUrlToAboutProgramVideoPlayer(videoLink);
                  addUrlToAboutProgramVideoPlayerChewie(videoLink);
                }
                // #2 video player
                // addUrlToVideoPlayerChewie("https://gwc.disol.in/storage/uploads/users/feedback/L%20R%20Narayanan,_1_1_1_1_1_1_1.mp4");

                if (_aboutProgramText.testimonial != null) {
                  String videoLink = _aboutProgramText.testimonial?.video ?? '';
                  // addUrlToVideoPlayer(videoLink);
                  addUrlToVideoPlayerChewie(videoLink);
                }
                // #3 feedback List
                List<FeedbackList> feedbackList =
                    _aboutProgramText.feedbackList ?? [];
                List<String> reviewList = _aboutProgramText.reviewsList ?? [];

                print("feedbackList: $feedbackList");
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About The Program",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: eUser().mainHeadingFont,
                            color: eUser().mainHeadingColor,
                            fontSize: eUser().mainHeadingFontSize),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      buildAboutProgramVideo(),
                      // SizedBox(height: 2.h),
                      Card(
                        elevation: 7,
                        child: SizedBox(
                            height: 30.h,
                            child: FutureBuilder(
                              future: getCachedPdfViewer(aboutProgramPdf),
                              builder: (_, snapFile) {
                                if (snapFile.connectionState ==
                                    ConnectionState.done) {
                                  if (snapFile.data == null) {
                                    print("from: network");
                                    return SfPdfViewer.network(
                                      aboutProgramPdf,
                                      // asset('assets/GWC Program Details.pdf',
                                      scrollDirection:
                                          PdfScrollDirection.horizontal,
                                      onDocumentLoaded: (details) async {
                                        writePdfFile(details, aboutProgramPdf);
                                      },
                                    );
                                  } else {
                                    print("from: file ${snapFile.data}");
                                    return SfPdfViewer.file(
                                      snapFile.data as File,
                                      scrollDirection:
                                          PdfScrollDirection.horizontal,
                                    );
                                  }
                                } else
                                  return SizedBox();
                              },
                            )),
                        // child: Container(
                        //   padding: EdgeInsets.symmetric(
                        //       vertical: 1.h, horizontal: 3.w),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(5),
                        //     border: Border.all(color: gPrimaryColor, width: 1),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.withOpacity(0.3),
                        //         blurRadius: 20,
                        //         offset: const Offset(2, 10),
                        //       ),
                        //     ],
                        //   ),
                        //   child: Image(
                        //     image: AssetImage('assets/images/about_program.jpeg'),
                        //   ),
                        //   // child: Text(
                        //   //   _programText,
                        //   //   // 'Lorem lpsum is simply dummy text of the printing and typesetting industry. Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.',
                        //   //   style: TextStyle(
                        //   //     height: 1.7,
                        //   //     fontFamily: "GothamBook",
                        //   //     color: gTextColor,
                        //   //     fontSize: 9.sp,
                        //   //   ),
                        //   // ),
                        // ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Testimonial",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: eUser().mainHeadingFont,
                            color: eUser().mainHeadingColor,
                            fontSize: eUser().mainHeadingFontSize),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      buildTestimonial(),
                      SizedBox(
                        height: 2.h,
                      ),
                      // buildFeedback(feedbackList),
                      buildReviews(reviewList),
                      SizedBox(height: 2.h),
                    ],
                  ),
                );
              } else {
                ErrorModel data = snapshot.data as ErrorModel;
                print("data.message: ${data.message}");
                if (data.message!.contains(
                    "Connection closed before full header was received")) {
                  getFuture();
                }
                return Center(
                    child: Column(
                  children: [
                    Text(
                      data.message ?? '',
                      style:
                          TextStyle(fontSize: 10.sp, fontFamily: kFontMedium),
                    ),
                    TextButton(
                        onPressed: () {
                          getFuture();
                        },
                        child: Text(
                          "Retry",
                          style: TextStyle(
                              fontSize: 10.sp, fontFamily: kFontMedium),
                        ))
                  ],
                ));
              }
            }
            return buildCircularIndicator();
          },
        ));
  }

  // *********** chewie video player *******************

  VideoPlayerController? videoPlayerController, testimonialVideoController;
  ChewieController? _chewieController, _testimonialChewieController;

  bool showTestVideoControls = false, showAbtVideoControls = false;

  // ***************************************************

  buildAboutProgramVideo() {
    if (_chewieController != null) {
      return Listener(
        onPointerDown: (_) async {
          print("pressed");
          // if(_testimonialChewieController != null){
          //   if(_testimonialChewieController!.videoPlayerController.value.isPlaying == true){
          //     _testimonialChewieController!.videoPlayerController.pause();
          //       showTestVideoControls = false;
          //     // _abtProgramPlayerController!.play();
          //   }
          // }
        },
        child: AspectRatio(
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
                  isControlsVisible: showAbtVideoControls,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  buildTestimonial() {
    if (_testimonialChewieController != null) {
      return Listener(
        onPointerDown: (_) async {
          print("pressed");
          // if(_chewieController != null){
          //   if(_chewieController!.videoPlayerController.value.isPlaying == true){
          //     _chewieController!.videoPlayerController.pause();
          //     showAbtVideoControls = false;
          //     // _abtProgramPlayerController!.play();
          //   }
          // }
        },
        child: AspectRatio(
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
                  controller: _testimonialChewieController!,
                ),
                // child: VlcPlayerWithControls(
                //   key: _key,
                //   controller: _videoPlayerController!,
                //   showVolume: false,
                //   showVideoProgress: false,
                //   seekButtonIconSize: 10.sp,
                //   playButtonIconSize: 14.sp,
                //   replayButtonSize: 10.sp,
                // ),
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
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  buildFeedback(List<FeedbackList> feedbackList) {
    if (feedbackList.isNotEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: kLineColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(2, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
              child: PageView(controller: pageController, children: [
                ...feedbackList.map((e) => buildFeedbackList(e)).toList()
              ]
                  // [
                  //   buildFeedbackList(),
                  //   buildFeedbackList(),
                  //   buildFeedbackList(),
                  // ],
                  ),
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: feedbackList.length,
              axisDirection: Axis.horizontal,
              effect: JumpingDotEffect(
                dotColor: Colors.amberAccent,
                activeDotColor: gsecondaryColor,
                dotHeight: 1.h,
                dotWidth: 2.w,
                jumpScale: 2,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  buildReviews(List<String> reviewList) {
    if (reviewList.isNotEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: kLineColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(2, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
              child: PageView(controller: reviewPageController, children: [
                ...reviewList.map((e) => buildReviewsList(e)).toList()
              ]
                  // [
                  //   buildFeedbackList(),
                  //   buildFeedbackList(),
                  //   buildFeedbackList(),
                  // ],
                  ),
            ),
            SmoothPageIndicator(
              controller: reviewPageController,
              count: reviewList.length,
              axisDirection: Axis.horizontal,
              effect: JumpingDotEffect(
                dotColor: Colors.amberAccent,
                activeDotColor: gsecondaryColor,
                dotHeight: 1.h,
                dotWidth: 2.w,
                jumpScale: 2,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildRating(String starRating) {
    return SmoothStarRating(
      color: Colors.amber,
      borderColor: Colors.amber,
      rating: double.tryParse(starRating) ?? rating,
      size: 2.h,
      filledIconData: Icons.star_sharp,
      halfFilledIconData: Icons.star_half_sharp,
      defaultIconData: Icons.star_outline_sharp,
      starCount: 5,
      allowHalfRating: true,
      spacing: 2.0,
    );
  }

  buildFeedbackList(FeedbackList feedback) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(2, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                  radius: 3.h,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    "assets/images/cheerful.png",
                  )),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback.addedBy?.name ?? '',
                  style: TextStyle(
                      fontFamily: kFontBold,
                      color: gTextColor,
                      fontSize: 10.sp),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  feedback.addedBy?.address ?? '',
                  style: TextStyle(
                      fontFamily: kFontBook,
                      color: gHintTextColor,
                      fontSize: 9.sp),
                ),
                // buildRating(feedback.rating ?? ''),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          feedback.feedback ?? '',
          style: TextStyle(
            height: 1.5,
            fontFamily: kFontBook,
            color: gTextColor,
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  buildReviewsList(String image) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(
        image,
      ))),
    );
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
