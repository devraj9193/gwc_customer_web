/*
This screen is called whenever we need to show the pdfviewer
using syncfusion_flutter_pdfviewer package

if there is a video link than we r showing video on top of ui
for video we r using chewie package
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer_web/widgets/video/normal_video.dart';
import 'package:sizer/sizer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MealPdf extends StatefulWidget {
  final String? heading;
  final String pdfLink;
  final String? mealVideoLink;
  final String? videoName;

  /// pass true if mealVideoLink is not empty
  final bool isVideoWidgetVisible;

  /// By default topHeadColor is [kBottomSheetHeadYellow]
  final Color? topHeadColor;

  /// By default headCircleIcon is [bsHeadBellIcon]
  final String? headCircleIcon;


  /// if this is true than pass sheetCloseOnTap parameter
  final bool isSheetCloseNeeded;

  /// its null is isSheetCloseNeeded is false
  VoidCallback? sheetCloseOnTap;
  MealPdf({Key? key, required this.pdfLink, this.heading, this.mealVideoLink,
    this.topHeadColor, this.headCircleIcon, this.isVideoWidgetVisible = true,
    this.videoName, this.isSheetCloseNeeded = false, this.sheetCloseOnTap
  }) : super(key: key);

  @override
  State<MealPdf> createState() => _MealPdfState();
}

class _MealPdfState extends State<MealPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                    child: buildAppBar(() {}, isBackEnable: false),
                  ),
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        // padding: EdgeInsets.symmetric(
                        //     vertical: 1.h, horizontal: 3.w),
                        decoration: const BoxDecoration(
                          color: gBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22)
                          ),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: this.widget.topHeadColor ?? kBottomSheetHeadYellow,
                                  ),
                                  child: Center(
                                    child: Image.asset(bsHeadStarsIcon,
                                      alignment: Alignment.topRight,
                                      fit: BoxFit.scaleDown,
                                      width: 30.w,
                                      height: 10.h,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 70.h,
                                    child: SingleChildScrollView(
                                      child:  Column(
                                        // shrinkWrap: true,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SizedBox(height: 1.5.h),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.center,
                                          //   mainAxisSize: MainAxisSize.min,
                                          //   children: [
                                          //     // SizedBox(width: 26.w),
                                          //     Expanded(
                                          //       child: Center(
                                          //         child: Text(
                                          //           heading ?? 'Meal Item',
                                          //           style: TextStyle(
                                          //               fontFamily: "GothamRoundedBold_21016",
                                          //               color: gTextColor,
                                          //               fontSize: 12.sp),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     // SizedBox(width: 26.w),
                                          //     InkWell(
                                          //       onTap: () {
                                          //         Navigator.pop(context);
                                          //       },
                                          //       child: Container(
                                          //         padding: const EdgeInsets.all(1),
                                          //         decoration: BoxDecoration(
                                          //           borderRadius: BorderRadius.circular(30),
                                          //           border: Border.all(
                                          //               color: gMainColor, width: 1),
                                          //         ),
                                          //         child: Icon(
                                          //           Icons.clear,
                                          //           color: gMainColor,
                                          //           size: 1.6.h,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     SizedBox(width: 5,)
                                          //   ],
                                          // ),
                                          // Container(
                                          //   margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                                          //   height: 1,
                                          //   color: gMainColor,
                                          // ),
                                          // SizedBox(height: 1.h),
                                          Visibility(
                                              visible: widget.isVideoWidgetVisible,
                                              child: videoMp4Widget(
                                              onTap: (){
                                                if(widget.mealVideoLink != null && widget.mealVideoLink!.isNotEmpty){
                                                  addChewieVideoPlayer(widget.mealVideoLink ?? '');
                                                  setState(() {
                                                    showMealVideo = true;
                                                  });
                                                }

                                              })),
                                          Flexible(
                                            child: Stack(
                                              children: [
                                                IntrinsicHeight(
                                                  child: SfPdfViewer.network(
                                                      widget.pdfLink
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: showMealVideo,
                                                  child: Positioned(
                                                      child: Center(
                                                          child: buildMealVideo(
                                                              onTap: () async{
                                                                setState(() {
                                                                  showMealVideo = false;
                                                                });
                                                                if(await WakelockPlus.enabled == true){
                                                                  WakelockPlus.disable();
                                                                }
                                                                if(_mealVideoController != null)_mealVideoController!.dispose();
                                                                if(_chewieController != null)_chewieController!.dispose();

                                                                // await _mealPlayerController!.stopRendererScanning();
                                                                // await _mealPlayerController!.dispose();
                                                              }
                                                          )
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )

                              ],
                            ),
                            Positioned(
                                top: 8.h,
                                left: 5,
                                right: 5,
                                child: Container(
                                    decoration: BoxDecoration(
                                      // color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(blurRadius: 5, color: gHintTextColor.withOpacity(0.8))
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      maxRadius: 40.sp,
                                      backgroundColor: kBottomSheetHeadCircleColor,
                                      child: Image.asset(this.widget.headCircleIcon ?? bsHeadBellIcon,
                                        fit: BoxFit.scaleDown,
                                        width: 45,
                                        height: 45,
                                      ),
                                    )
                                )
                            ),
                            Visibility(
                              visible: widget.isSheetCloseNeeded,
                              child: Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                      onTap: widget.sheetCloseOnTap ?? (){},
                                      child: Icon(Icons.cancel_outlined, color: gsecondaryColor,size: 28,))),
                            )
                          ],
                        ),

                      ),
                      // child: Container(
                      //   width: double.maxFinite,
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: 1.h, horizontal: 3.w),
                      //   decoration: BoxDecoration(
                      //     color: kWhiteColor,
                      //     boxShadow: [
                      //       BoxShadow(
                      //           blurRadius: 2,
                      //           color: Colors.grey.withOpacity(0.5))
                      //     ],
                      //     borderRadius: const BorderRadius.only(
                      //       topLeft: Radius.circular(50),
                      //       topRight: Radius.circular(50),
                      //     ),
                      //   ),
                      //   child: Column(
                      //     // shrinkWrap: true,
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: <Widget>[
                      //       SizedBox(height: 1.5.h),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           // SizedBox(width: 26.w),
                      //           Expanded(
                      //             child: Center(
                      //               child: Text(
                      //                 heading ?? 'Meal Item',
                      //                 style: TextStyle(
                      //                     fontFamily: "GothamRoundedBold_21016",
                      //                     color: gTextColor,
                      //                     fontSize: 12.sp),
                      //               ),
                      //             ),
                      //           ),
                      //           // SizedBox(width: 26.w),
                      //           InkWell(
                      //             onTap: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: Container(
                      //               padding: const EdgeInsets.all(1),
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(30),
                      //                 border: Border.all(
                      //                     color: gMainColor, width: 1),
                      //               ),
                      //               child: Icon(
                      //                 Icons.clear,
                      //                 color: gMainColor,
                      //                 size: 1.6.h,
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(width: 5,)
                      //         ],
                      //       ),
                      //       Container(
                      //         margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      //         height: 1,
                      //         color: gMainColor,
                      //       ),
                      //       // SizedBox(height: 1.h),
                      //       Expanded(
                      //         child: SfPdfViewer.network(
                      //             pdfLink
                      //         ),
                      //       ),
                      //       // Text(
                      //       //   'Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.It has survived not only five centuries,but also the leap into electronic typesetting,remaining essentially unchanged.It was popularised in the 1960s with the release of Letraset sheets containing Lorem lpsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem lpsum. long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem lpsum is that it has amore_or_less normal distribution of letters, as opposed to using \'Content here,content here\',making it look like readable english. Many desktop publishing packages and web page editors now use Lorem lpsum as their default model text,and asearch for \'lorem lpsum\' will uncover many web sites still in their infancy.Various versions have evolved over the years,sometimes by accident, sometimes on purpose(injected humour and the like).',
                      //       //   style: TextStyle(
                      //       //       height: 1.5,
                      //       //       fontFamily: "GothamMedium",
                      //       //       color: gTextColor,
                      //       //       fontSize: 10.sp),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  videoMp4Widget({required VoidCallback onTap}){
    print("widget.mealVideoLink?.split('/').last: ${widget.mealVideoLink}");
    return InkWell(
      onTap: onTap,
      child: Card(
          child: Row(
              children:[
                Image.asset("assets/images/meal_placeholder.png",
                  height: 35,
                  width: 40,
                ),
                Expanded(child: Text(widget.videoName ?? "Symptom Tracker.mp4",
                  style: TextStyle(
                      fontFamily: kFontBook
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/arrow_for_video.png",
                    height: 35,
                  ),
                )
              ]
          )
      ),
    );
  }
  VideoPlayerController? _mealVideoController;
  ChewieController? _chewieController;

  bool showMealVideo = false;

  addChewieVideoPlayer(String url) async{
    _mealVideoController = VideoPlayerController.network(Uri.parse(url).toString());
    _chewieController = ChewieController(
        videoPlayerController: _mealVideoController!,
        aspectRatio: 16/9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        hideControlsTimer: Duration(seconds: 3),
        showControls: false

    );
    if(await WakelockPlus.enabled == false){
      WakelockPlus.enable();
    }
  }

  @override
  dispose(){
    if(_mealVideoController != null) _mealVideoController!.dispose();
    if(_chewieController != null) _chewieController!.dispose();
    super.dispose();
  }
  buildMealVideo({required VoidCallback onTap}) {
    if(_chewieController != null){
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 16/9,
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
                    )
                  // child: VlcPlayerWithControls(
                  //   key: _mealKey,
                  //   controller: _mealPlayerController!,
                  //   showVolume: false,
                  //   showVideoProgress: false,
                  //   seekButtonIconSize: 10.sp,
                  //   playButtonIconSize: 14.sp,
                  //   replayButtonSize: 10.sp,
                  // ),
                ),
              ),
            ),
          ),
          Center(
              child: IconButton(
                icon: Icon(Icons.cancel_outlined,
                  color: gsecondaryColor,
                ),
                onPressed: onTap,
              )
          )
        ],
      );
    }
    else {
      return SizedBox.shrink();
    }
  }
}
