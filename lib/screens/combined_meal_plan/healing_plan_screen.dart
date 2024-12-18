/*
Healing plan

this screen is called in combinedmealplan screen under healing tab

we r showing the day number from the details object in response

for tracker we r sending the selected followed/unfollwed to the trackerui

for showing completed clap we using buildDayCompletedClap() function

Api used:
/api/getData/NutriDelight

 */

import 'dart:convert';
import 'dart:ui';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:easy_scroll_to_index/easy_scroll_to_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:gwc_customer_web/model/program_model/program_days_model/child_program_day.dart';
import 'package:gwc_customer_web/screens/combined_meal_plan/video_player/yoga_video_screen.dart';
import 'package:gwc_customer_web/screens/combined_meal_plan/widgets/thumbnail_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/combined_meal_model/detox_nourish_model/child_detox_model.dart';
import '../../model/combined_meal_model/detox_nourish_model/detox_healing_common_model/child_meal_plan_details_model1.dart';
import '../../model/combined_meal_model/detox_nourish_model/detox_healing_common_model/detox_healing_model.dart';
import '../../model/combined_meal_model/meal_plan_tracker_modl/send_meal_plan_tracker_model.dart';
import '../../model/combined_meal_model/new_detox_model.dart';
import '../../model/combined_meal_model/new_healing_model.dart';
import '../../model/error_model.dart';
import '../../model/program_model/proceed_model/get_proceed_model.dart';
import '../../repository/api_service.dart';
import '../../repository/program_repository/program_repository.dart';
import '../../services/program_service/program_service.dart';
import '../../services/vlc_service/check_state.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/open_alert_box.dart';
import '../../widgets/pip_package.dart';
import '../../widgets/unfocus_widget.dart';
import '../../widgets/video/normal_video.dart';
import '../../widgets/widgets.dart';
import '../dashboard_screen.dart';
import '../prepratory plan/new/meal_plan_recipe_details.dart';
import '../profile_screens/my_yoga_screens/meal_plan_yoga_video.dart';
import '../program_plans/meal_pdf.dart';
import 'combined_meal_screen.dart';
import 'meal_plan_portrait_video.dart';
import 'tracker_widgets/new-day_tracker.dart';

class HealingPlanScreen extends StatefulWidget {
  final String? transStage;
  final String? receipeVideoLink;
  final String? trackerVideoLink;
  final bool viewDay1Details;
  final bool showBlur;
  final String mealNote;
  final bool isNourishStarted;
  final TabController tabIndex;
  final ValueSetter<bool>? onChanged;
  final NewDetoxModel? detoxModel;
  final NewHealingModel? healingModel;
  const HealingPlanScreen(
      {Key? key,
      this.transStage,
      this.receipeVideoLink,
      this.trackerVideoLink,
      this.viewDay1Details = false,
      this.showBlur = false,
      this.isNourishStarted = false,
      this.onChanged,
      required this.tabIndex,
      this.detoxModel,
      this.healingModel,
      required this.mealNote})
      : super(key: key);

  @override
  State<HealingPlanScreen> createState() => _HealingPlanScreenState();
}

class _HealingPlanScreenState extends State<HealingPlanScreen> {
  final _pref = AppConfig().preferences;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();

  int planStatus = 0;
  String headerText = "";
  Color textColor = gWhiteColor;
  String? planNotePdfLink;
  bool showToolTip = true;
  bool shoppingToolTip = true;

  String btnText = "Next"; //'Proceed to Symptoms Tracker';

  bool isLoading = false;

  String errorMsg = 'Something Went Wrong!';

  List<ChildMealPlanDetailsModel1>? shoppingData;

  Map<String, List<ChildMealPlanDetailsModel1>> mealPlanData1 = {};

  final tableHeadingBg = gHintTextColor.withOpacity(0.4);

  List<String> list = [
    "Followed",
    "Unfollowed",
  ];

  List<String> sendList = [
    "followed",
    "unfollowed",
  ];

  //****************  video player variables  *************

  // VlcPlayerController? _controller, _trackerVideoPlayerController;
  // final _key = GlobalKey<VlcPlayerWithControlsState>();
  //
  // initVideoView(String? url) {
  //   print("init url: $url");
  //   _controller = VlcPlayerController.network(
  //     // url ??
  //     Uri.parse(url!
  //       // 'https://gwc.disol.in/storage/uploads/users/recipes/Calm Module - Functional (AR).mp4'
  //     )
  //         .toString(),
  //     hwAcc: HwAcc.full,
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
  //
  //   print(
  //       "_controller.isReadyToInitialize: ${_controller!.isReadyToInitialize}");
  //   _controller!.addOnInitListener(() async {
  //     await _controller!.startRendererScanning();
  //   });
  //   final _ori = MediaQuery.of(context).orientation;
  //   print(_ori.name);
  //   bool isPortrait = _ori == Orientation.portrait;
  //   if (isPortrait) {
  //     AutoOrientation.landscapeAutoMode();
  //   }
  // }
  //

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
        showControls: true);

    final _ori = MediaQuery.of(context).orientation;
    print(_ori.name);
    bool isPortrait = _ori == Orientation.portrait;
    if (isPortrait) {
      AutoOrientation.landscapeAutoMode();
    }
  }

  // for tracker video player
  // final _trackerKey = GlobalKey<VlcPlayerWithControlsState>();

  var checkState;

  /// to check enable / disable
  bool isEnabled = false;

  String videoName = '';
  String mealTime = '';

  final _scrollController = ScrollToIndexController();

  // *******************************************************

  // ***************** getDay Api Params *******************

  int? nextDay;
  int? presentDay;
  int? selectedDay;
  bool? isDayCompleted;
  bool? isTrackerSubmitted;
  List<ChildProgramDayModel> listData = [];

  bool isOpened = false;

  // *****************      End   ************************

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  // buildDays(ProgramDayModel model) {
  //   listData = model.data!;
  //   print("listData.last.isCompleted: ${listData.last.isCompleted}");
  //   // this is for bottomsheet
  //   if (listData.last.isCompleted == 1) {
  //     print("widget.postProgramStage: ${widget.transStage}");
  //     if (widget.transStage == null || widget.transStage!.isEmpty) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (!isOpened) {
  //           setState(() {
  //             isOpened = true;
  //           });
  //           buildDayCompletedClap();
  //         }
  //       });
  //     }
  //   }
  //   for (int i = 0; i < presentDay!; i++) {
  //     print(presentDay);
  //     if (listData[i].isCompleted == 0 && i + 1 != selectedDay!) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         showMoreTextSheet(listData[i].dayNumber);
  //       });
  //       break;
  //     }
  //   }
  // }

  /// this is used to show the alert when previous day tracker and meal data not submitted
  showMoreTextSheet(String? dayNumber, {bool? previousDay = false}) {
    return AppConfig().showSheet(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "It is key to complete your Previous day tracker before moving on to the Current day. ",
                    style: TextStyle(
                        fontSize: subHeadingFont,
                        fontFamily: kFontBook,
                        height: 1.4),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  previousDay!
                      ? GestureDetector(
                          onTap: () {
                            selectedDay = int.parse(dayNumber!);
                            // getMeals();
                            getMealFromDay(selectedDay!);
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: gsecondaryColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: gMainColor, width: 1),
                              ),
                              child: Text(
                                'Fill Day${dayNumber}',
                                style: TextStyle(
                                  fontFamily: kFontMedium,
                                  color: gWhiteColor,
                                  fontSize: 13.dp,
                                ),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            selectedDay = int.parse(dayNumber!);
                            // getMeals();
                            getMealFromDay(selectedDay!);
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: gsecondaryColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: gMainColor, width: 1),
                              ),
                              child: Text(
                                'Go to - Day${dayNumber}',
                                style: TextStyle(
                                  fontFamily: kFontMedium,
                                  color: gWhiteColor,
                                  fontSize: 13.dp,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          SizedBox(height: 1.h)
        ],
      ),
      bottomSheetHeight: 40.h,
      circleIcon: bsHeadPinIcon,
    );
  }

  /// used to show when user completed last day or when isHealingCompleted param becomes true
  buildDayCompletedClap() {
    return AppConfig().showSheet(
        context,
        WillPopScope(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: gMainColor),
                  ),
                  child: Lottie.asset(
                    "assets/lottie/clap.json",
                    height: 20.h,
                  ),
                ),
                SizedBox(height: 1.5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Text(
                    "You Have completed the ${totalDays} days Healing Plan, Now you can proceed to Nourish",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.2,
                      color: gTextColor,
                      fontSize: bottomSheetSubHeadingXLFontSize,
                      fontFamily: bottomSheetSubHeadingMediumFont,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOpened = true;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DashboardScreen(
                                  index: 2,
                                )),
                        (route) => true);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: gsecondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gWhiteColor,
                        fontSize: 13.dp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onWillPop: () => Future.value(false)),
        circleIcon: bsHeadPinIcon,
        bottomSheetHeight: 60.h);
  }

  // startPostProgram() async {
  //   final res = await PostProgramService(repository: _postProgramRepository)
  //       .startPostProgramService();
  //
  //   if (res.runtimeType == ErrorModel) {
  //     ErrorModel model = res as ErrorModel;
  //     Navigator.pop(context);
  //     AppConfig().showSnackbar(context, model.message ?? '', isError: true);
  //   } else {
  //     Navigator.pop(context);
  //     if (res.runtimeType == StartPostProgramModel) {
  //       StartPostProgramModel model = res as StartPostProgramModel;
  //       print("start program: ${model.response}");
  //       AppConfig().showSnackbar(context, "Post Program started" ?? '');
  //       Future.delayed(Duration(seconds: 2)).then((value) {
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (_) => DashboardScreen()),
  //                 (route) => true);
  //       });
  //     }
  //   }
  // }
  //
  // final PostProgramRepository _postProgramRepository = PostProgramRepository(
  //   apiClient: ApiClient(
  //     httpClient: http.Client(),
  //   ),
  // );

  bool _checked = false;

  // video player code
  final videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

  ChildDetoxModel? _childDetoxModel;
  bool isHealingCompleted = false;

  int? totalDays;

  @override
  void initState() {
    // chkDetoxPlans();
    super.initState();
    getProgramData(widget.healingModel, widget.detoxModel, widget.mealNote);
    // if (!widget.viewDay1Details) getProgramDays();
    // if (widget.viewDay1Details) {
    //   selectedDay = 1;
    //   getMeals();
    // }
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   commentController.addListener(() {
    //     setState(() {});
    //   });
    // });
    hideToolTip();
  }

  ChildDetoxModel? _chkDetoxPlan;
  List<ChildProgramDayModel> listDetoxDay = [];
  bool isDetoxDayCompleted = false;

  showPendingDetoxPlan(String? dayNumber, {bool? previousDay = false}) {
    return AppConfig().showSheet(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "It is key to complete your Detox day tracker before moving on to the Healing.",
                    style: TextStyle(
                        fontSize: subHeadingFont,
                        fontFamily: kFontBook,
                        height: 1.4),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CombinedPrepMealTransScreen(
                              stage: 1,
                            ),
                          ),
                        );
                      });
                      // Get.to(() => CombinedPrepMealTransScreen(
                      //       stage: 2,
                      //     ));
                    },
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: gsecondaryColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gMainColor, width: 1),
                        ),
                        child: Text(
                          'Fill Detox Day $dayNumber',
                          style: TextStyle(
                            fontFamily: kFontMedium,
                            color: gWhiteColor,
                            fontSize: 13.dp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 1.h)
        ],
      ),
      bottomSheetHeight: 40.h,
      circleIcon: bsHeadPinIcon,
    );
  }

  hideToolTip() {
    Future.delayed(Duration(seconds: 5)).then((value) {
      setState(() {
        shoppingToolTip = false;
        showToolTip = false;
      });
    });
  }

  showAlert(
    BuildContext context,
    String status, {
    bool isSingleButton = true,
    required VoidCallback positiveButton,
  }) {
    return openAlertBox(
        context: context,
        barrierDismissible: false,
        content: errorMsg,
        titleNeeded: false,
        isSingleButton: isSingleButton,
        positiveButtonName: (status == '401') ? 'Go Back' : 'Retry',
        positiveButton: positiveButton,
        negativeButton: isSingleButton
            ? null
            : () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
        negativeButtonName: isSingleButton ? null : 'Go Back');
  }

  @override
  void dispose() async {
    super.dispose();
    commentController.dispose();

    if (_sheetVideoController != null) _sheetVideoController!.dispose();
    if (_sheetChewieController != null) _sheetChewieController!.dispose();

    // if (_trackerVideoPlayerController != null) _trackerVideoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: videoPlayerView(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final _ori = MediaQuery.of(context).orientation;
    bool isPortrait = _ori == Orientation.portrait;
    if (!isPortrait) {
      AutoOrientation.portraitUpMode();
      // setState(() {
      //   isEnabled = false;
      // });
    }
    print(isEnabled);
    return !isEnabled ? true : false;
    // return false;
  }

  bool showShimmer = false;
  dayItems(int index) {
    return GestureDetector(
      onTap: (widget.viewDay1Details)
          ? () {
              setState(() {
                showShimmer = true;
                selectedDay = int.parse(listData[index].dayNumber!);
              });
              getMealFromDay(selectedDay!);
            }
          : checkOnTapCondition(index, listData)
              ? () {
                  setState(() {
                    showShimmer = true;
                    selectedDay = int.parse(listData[index].dayNumber!);
                    isDayCompleted = listData[index].isCompleted == 1;
                    isTrackerSubmitted = listData[index].isTrackerSubmitted == 1;
                    commentController.clear();
                  });
                  print("isDayCompleted: $isDayCompleted");
                  getMealFromDay(selectedDay!);
                  // // selectedDay = int.parse(listData[index].dayNumber!);
                  // print(
                  //     "day number : ${int.parse(listData[index].dayNumber!)}");
                  // print("selected day : ${selectedDay!}");
                  // print("isDay Completed : ${listData[index].isCompleted!}");
                  // print("present day : $presentDay");
                  // if (listData[index].isCompleted != 1) {
                  //   if (int.parse(listData[index].dayNumber!) > presentDay!) {
                  //     setState(() {
                  //       showShimmer = true;
                  //       // selectedDay = int.parse(listData[index].dayNumber!);
                  //       isDayCompleted = listData[index].isCompleted == 1;
                  //       commentController.clear();
                  //     });
                  //     showMoreTextSheet("$selectedDay",previousDay: true);
                  //   } else if(int.parse(listData[index].dayNumber!) == presentDay!){
                  //
                  //   }else {
                  //     setState(() {
                  //       showShimmer = true;
                  //       selectedDay = int.parse(listData[index].dayNumber!);
                  //       isDayCompleted = listData[index].isCompleted == 1;
                  //       commentController.clear();
                  //     });
                  //     getMealFromDay(selectedDay!);
                  //   }
                  // } else {
                  //   setState(() {
                  //     showShimmer = true;
                  //     selectedDay = int.parse(listData[index].dayNumber!);
                  //     isDayCompleted = listData[index].isCompleted == 1;
                  //     commentController.clear();
                  //   });
                  //   print("isDayCompleted: $isDayCompleted");
                  //   getMealFromDay(selectedDay!);
                  //   // getMeals();
                  //   // Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(
                  //   //     builder: (context) => MealPlanScreen(
                  //   //       // day: dayPlansData[index]["day"],
                  //   //       isCompleted: listData[index].isCompleted == 1 ? true : null,
                  //   //       day: listData[index].dayNumber!,
                  //   //       presentDay: model.presentDay.toString(),
                  //   //       nextDay: nextDay.toString() ?? "-1",
                  //   //     ),
                  //   //   ),
                  //   // );
                  // }
                  // // setState(() {
                  // //   showShimmer = true;
                  // //   selectedDay = int.parse(listData[index].dayNumber!);
                  // //   isDayCompleted = listData[index].isCompleted == 1;
                  // //   commentController.clear();
                  // // });
                  // // print("isDayCompleted: $isDayCompleted");
                  // // getMealFromDay(selectedDay!);
                  // // // getMeals();
                  // // // Navigator.push(
                  // // //   context,
                  // // //   MaterialPageRoute(
                  // // //     builder: (context) => MealPlanScreen(
                  // // //       // day: dayPlansData[index]["day"],
                  // // //       isCompleted: listData[index].isCompleted == 1 ? true : null,
                  // // //       day: listData[index].dayNumber!,
                  // // //       presentDay: model.presentDay.toString(),
                  // // //       nextDay: nextDay.toString() ?? "-1",
                  // // //     ),
                  // // //   ),
                  // // // );
                  if (int.parse(listData[index].dayNumber!) == 1) {
                  } else {
                    for (int i = 0; i < presentDay! - 1; i++) {
                      setState(() {
                        showShimmer = true;
                        selectedDay = int.parse(listData[index].dayNumber!);
                        isDayCompleted = listData[index].isCompleted == 1;
                        isTrackerSubmitted = listData[index].isTrackerSubmitted == 1;
                        commentController.clear();
                      });
                      print(presentDay);
                      print("index : ${index != i}");
                      if (listData[i].isTrackerSubmitted == 0 && index != i) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showMoreTextSheet(listData[i].dayNumber);
                        });
                        break;
                      } else {
                        setState(() {
                          showShimmer = true;
                          selectedDay = int.parse(listData[index].dayNumber!);
                          isDayCompleted = listData[index].isCompleted == 1;
                          isTrackerSubmitted = listData[index].isTrackerSubmitted == 1;
                          commentController.clear();
                        });
                        print("isDayCompleted: $isDayCompleted");
                        getMealFromDay(selectedDay!);
                      }
                    }
                  }
                }
              : () {
                  print("disable");
                },
      child: Opacity(
        opacity: (widget.viewDay1Details) ? 1.0 : getOpacity(index, listData),
        child: Container(
            // height: 5.h,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: MealPlanConstants().dayBorderColor),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                color: (listData[index].dayNumber == selectedDay.toString())
                    ? kNumberCircleAmber
                    : (listData[index].isCompleted == 1)
                        ? MealPlanConstants().dayBgSelectedColor
                        : (listData[index].dayNumber == presentDay.toString())
                            ? MealPlanConstants().dayBgPresentdayColor
                            : MealPlanConstants().dayBgNormalColor),
            margin: EdgeInsets.symmetric(vertical: 0.h, horizontal: 1.w),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.h),
            child: Center(
              child: Text(
                'DAY ${listData[index].dayNumber!}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize:
                        (listData[index].dayNumber == presentDay.toString() ||
                                listData[index].dayNumber == nextDay.toString())
                            ? MealPlanConstants().presentDayTextSize
                            : MealPlanConstants().DisableDayTextSize,
                    fontFamily:
                        (listData[index].dayNumber == presentDay.toString() ||
                                listData[index].dayNumber == nextDay.toString())
                            ? MealPlanConstants().dayTextFontFamily
                            : MealPlanConstants().dayUnSelectedTextFontFamily,
                    color: (listData[index].isCompleted == 1 ||
                            listData[index].dayNumber == presentDay.toString())
                        ? MealPlanConstants().dayTextSelectedColor
                        : MealPlanConstants().dayTextColor),
              ),
            )),
      ),
    );
  }

  getMealFromDay(int day) {
    lst.clear();
    statusList.clear();
    _childDetoxModel!.details!.forEach((key, value) {
      print("value==> $key $value");
      DetoxHealingModel _model = value;
      if (key == day.toString()) {
        mealPlanData1 = _model.data!;
      }
    });

    for (var element in mealPlanData1.values) {
      for (var item in element) {
        lst.add(item);
      }
    }

    print("isDayCompleted: $isDayCompleted");
    if (isDayCompleted != null && isDayCompleted == true) {
      mealPlanData1.forEach((key, value) {
        for (var element in (value)) {
          statusList.putIfAbsent(
              element.itemId, () => element.status.toString().capitalize);
        }
      });

      _childDetoxModel!.details!.forEach((key, value) {
        if (key == selectedDay.toString()) {
          commentController.text = value.comment ?? '';
        }
      });
    }
    // else{
    //   if(selectedDay == presentDay){
    //     if(_pref!.getString(AppConfig.STORE_MEAL_DATA) != null && _pref!.getString(AppConfig.STORE_MEAL_DATA)!.isNotEmpty) {
    //       final localMealData = json.decode(_pref!.getString(AppConfig.STORE_MEAL_DATA)!);
    //
    //       print("localMealData: $localMealData");
    //       // (localMealData['selected_meal'] as Map).forEach((key, value) {
    //       //   print("$key -- $value");
    //       // });
    //
    //       if(localMealData['selected_meal'] != null){
    //         String m = localMealData['selected_meal'];
    //         final l = m.replaceAll("{", '').replaceAll('}', '').split(',');
    //         Map _m = {};
    //         l.forEach((element) {
    //           _m.putIfAbsent(int.parse(element.split(':').first.trim()), () => element.split(':').last.trim());
    //         });
    //         statusList.addAll(_m);
    //       }
    //       commentController.text = localMealData['comments'];
    //
    //
    //     }
    //   }
    // }

    print(mealPlanData1);

    setState(() {
      showShimmer = false;
    });
  }

  checkOnTapCondition(int index, List<ChildProgramDayModel> listData) {
    if (index == 0) {
      return true;
    } else if (listData[index - 1].isCompleted == 1) {
      return true;
    } else if (index != listData.length - 1 &&
        listData[index + 1].dayNumber == (nextDay).toString()) {
      return true;
    } else if (listData[listData.length - 2].isCompleted == 1 &&
        index == listData.length - 1) {
      return true;
    } else if (int.parse(listData[index].dayNumber!) == nextDay ||
        int.parse(listData[index].dayNumber!) == presentDay) {
      return true;
    } else if (int.parse(listData[index].dayNumber!) < presentDay! &&
        listData[index].isCompleted == 0) {
      return true;
    } else {
      return false;
    }
    // ((index == 0) || listData[index-1].isCompleted == 1)
  }

  getOpacity(int index, List<ChildProgramDayModel> listData) {
    print("=>>$index ${listData[index].dayNumber} $presentDay");
    if (index == 0) {
      return 1.0;
    } else if (listData[index - 1].isCompleted == 1) {
      print("else if1");
      return 1.0;
    } else if (index != listData.length - 1 &&
        listData[index + 1].dayNumber == (presentDay! + 1).toString()) {
      print("else if2");
      return 1.0;
    } else if (listData[listData.length - 2].isCompleted == 1 &&
        index == listData.length - 1) {
      print("else if3");
      return 1.0;
    } else if (int.parse(listData[index].dayNumber!) == nextDay ||
        int.parse(listData[index].dayNumber!) == presentDay) {
      print("else if4");
      return 1.0;
    } else if (int.parse(listData[index].dayNumber!) < presentDay! &&
        listData[index].isCompleted == 0) {
      print("else if5");
      return 1.0;
    } else {
      return 0.4;
    }
  }

  getBgColor(int index, List<ChildProgramDayModel> listData) {
    if (index == 0) {
      return 1.0;
    } else if (listData[index - 1].isCompleted == 1) {
      return 1.0;
    } else if (index != listData.length - 1 &&
        listData[index + 1].dayNumber == (presentDay! + 1).toString()) {
      return 1.0;
    } else if (listData[listData.length - 2].isCompleted == 1 &&
        index == listData.length - 1) {
      return 1.0;
    } else if (int.parse(listData[index].dayNumber!) == nextDay) {
      return 1.0;
    } else {
      return 0.7;
    }
  }

  bool showNoteVideo = false;

  backgroundWidgetForPIP() {
    return IgnorePointer(
      ignoring: widget.showBlur,
      child: Center(
        child: SizedBox(width: MediaQuery.of(context).size.shortestSide > 600 ? 50.w : double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(top: 1.h, left: 3.w, right: 3.w),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // need to change padding
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               SizedBox(
              //                 width: 2.h,
              //                 child: IconButton(
              //                   onPressed: () {
              //                     Navigator.pop(context);
              //                   },
              //                   icon: Icon(
              //                     Icons.arrow_back_ios,
              //                     color: gMainColor,
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(
              //                 width: 15,
              //               ),
              //               SizedBox(
              //                 height: 6.h,
              //                 child: const Image(
              //                   image:
              //                   AssetImage("assets/images/Gut welness logo.png"),
              //                 ),
              //                 //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
              //               ),
              //             ],
              //           ),
              //           Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               // SimpleTooltip(
              //               //   borderColor: gWhiteColor,
              //               //   maxWidth: 50.w,
              //               //   ballonPadding: EdgeInsets.symmetric(
              //               //       horizontal: 0.w, vertical: 0.h),
              //               //   arrowTipDistance: 2,
              //               //   arrowLength: 10,
              //               //   arrowBaseWidth: 10,
              //               //   hideOnTooltipTap: true,
              //               //   // targetCenter: const Offset(3,4),
              //               //   tooltipTap: () {
              //               //     setState(() {
              //               //       shoppingToolTip = false;
              //               //     });
              //               //   },
              //               //   animationDuration: const Duration(seconds: 3),
              //               //   show: shoppingToolTip,
              //               //   tooltipDirection: TooltipDirection.down,
              //               //   child: Align(
              //               //     alignment: Alignment.center,
              //               //     child: GestureDetector(
              //               //       onTap: () {
              //               //           shoppingToolTip = false;
              //               //           Navigator.of(context).push(
              //               //             MaterialPageRoute(
              //               //               builder: (context) => CookKitTracking(
              //               //                 currentStage: '',
              //               //                 initialIndex: 1,
              //               //               ),
              //               //             ),
              //               //           );
              //               //       },
              //               //       child: Image(
              //               //         height: 3.h,
              //               //         image: AssetImage("assets/images/list.png"),
              //               //       ),
              //               //     ),
              //               //   ),
              //               //   content: Text(
              //               //     "Tap here for Shopping List",
              //               //     style: TextStyle(
              //               //         fontSize: PPConstants().topViewSubFontSize,
              //               //         fontFamily: MealPlanConstants().mealNameFont,
              //               //         color: gHintTextColor),
              //               //   ),
              //               // ),
              //               IconButton(
              //                 icon: Icon(
              //                   Icons.help_outline_rounded,
              //                   color: gMainColor,
              //                 ),
              //                 onPressed: () {
              //                   Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                           builder: (ctx) => HomeRemediesScreen()));
              //
              //                   // if (planNotePdfLink != null ||
              //                   //     planNotePdfLink!.isNotEmpty) {
              //                   //   Navigator.push(
              //                   //       context,
              //                   //       MaterialPageRoute(
              //                   //           builder: (ctx) => MealPdf(
              //                   //             pdfLink: planNotePdfLink!,
              //                   //             heading: "Note",
              //                   //             isVideoWidgetVisible: false,
              //                   //             headCircleIcon: bsHeadPinIcon,
              //                   //             topHeadColor: kBottomSheetHeadGreen,
              //                   //             isSheetCloseNeeded: true,
              //                   //             sheetCloseOnTap: () {
              //                   //               Navigator.pop(context);
              //                   //             },
              //                   //           )));
              //                   // } else {
              //                   //   AppConfig().showSnackbar(
              //                   //       context, "Note Link Not available",
              //                   //       isError: true);
              //                   // }
              //                 },
              //               ),
              //             ],
              //           )
              //         ],
              //       ),
              //       SizedBox(height: 1.h),
              Visibility(
                // visible: !widget.viewDay1Details,
                child: Container(
                  padding: EdgeInsets.only(top: 2.h, left: 2.w),
                  height: 6.h,
                  child: EasyScrollToIndex(
                    controller: _scrollController, // ScrollToIndexController
                    itemCount: listData.length,
                    itemWidth: 4.w,
                    itemHeight: 4.h,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return dayItems(index);
                    },
                  ),
                ),
              ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 1.h),
              Expanded(
                child: (isLoading)
                    ? Center(
                        child: buildCircularIndicator(),
                      )
                    : (mealPlanData1 != null)
                        ? UnfocusWidget(
                            child: SizedBox(
                              child: SingleChildScrollView(
                                child: (showShimmer)
                                    ? IgnorePointer(
                                        child: Shimmer.fromColors(
                                        baseColor: Colors.grey.withOpacity(0.3),
                                        highlightColor:
                                            Colors.grey.withOpacity(0.7),
                                        child: mainView(),
                                      ))
                                    : mainView(),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  mainView() {
    return ImageFiltered(
      imageFilter: (widget.showBlur)
          ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
          : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2.h),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // "Day ${widget.day} Meal Plan",
                  (selectedDay == null || presentDay == 0)
                      ? "Healing Plan"
                      : "Day ${selectedDay} Healing Plan",
                  style: TextStyle(
                      fontFamily: eUser().mainHeadingFont,
                      color: eUser().mainHeadingColor,
                      fontSize: eUser().mainHeadingFontSize),
                ),
                (widget.mealNote == "null" || widget.mealNote == "")
                    ? const SizedBox() : GestureDetector(
                  onTap: () {
                    print("meal note : ${widget.mealNote}");
                    Future.delayed(const Duration(seconds: 0))
                        .then((value) {
                      return showMoreBenefitsTextSheet(widget.mealNote,
                          isMealNote: true);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: gsecondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Text(
                      'Important Note',
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gWhiteColor,
                        fontSize: 13.dp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // not showing these when we came from slide screen
            // Visibility(
            //   visible: !widget.viewDay1Details,
            //   child: SizedBox(
            //     height: 1.h,
            //   ),
            // ),
            SizedBox(height: 1.h),
            ...groupList(),
            if (presentDay == 0 && selectedDay == 0)
              Center(
                child: Text(
                  (presentDay == 0)
                      ? 'Your Healing will start from tomorrow'
                      : 'Day ${presentDay} of Day ${totalDays}',
                  style: TextStyle(
                      fontFamily: kFontMedium,
                      color: eUser().mainHeadingColor,
                      fontSize: 12.dp),
                ),
              ),
            if (presentDay != 0)
              Visibility(
                visible: (statusList.isNotEmpty &&
                        statusList.values.any((element) => element
                            .toString()
                            .toLowerCase()
                            .contains('unfollowed'))) ||
                    !widget.viewDay1Details,
                child: IgnorePointer(
                  ignoring: isDayCompleted == true,
                  child: Container(
                    height: 15.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(2, 10),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: commentController,
                      cursorColor: gPrimaryColor,
                      onEditingComplete: () {
                        Map<String, dynamic> storeMealDataLocally = {
                          "selected_meal": statusList.toString(),
                          "comments": commentController.text
                        };
                        _pref!.setString(AppConfig.STORE_MEAL_DATA,
                            json.encode(storeMealDataLocally));
                      },
                      style: TextStyle(
                          fontFamily: "GothamBook",
                          color: gTextColor,
                          fontSize: 11.dp),
                      decoration: InputDecoration(
                        suffixIcon: commentController.text.isEmpty ||
                                isDayCompleted != null
                            ? SizedBox()
                            : InkWell(
                                onTap: () {
                                  commentController.clear();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: gTextColor,
                                ),
                              ),
                        hintText: "Comments",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: "GothamBook",
                          color: gTextColor,
                          fontSize: 9.dp,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
              ),
            if (presentDay != 0)
              Visibility(
                visible: (isDayCompleted == false && isTrackerSubmitted == false),
                // buttonVisibility(),
                child: Center(
                  child: IntrinsicWidth(
                    child: GestureDetector(
                      onTap:isSent ? null :
                          // (){
                          //   print("statusList.length: ${statusList.length}");
                          //   print("lst.length ${lst.length}");
                          //
                          // },
                          (statusList.length != lst.length)
                              ? () => AppConfig().showSnackbar(context,
                                  "Please complete the Meal Plan Status",
                                  isError: true)
                              // : (statusList.values.any((element) => element.toString().toLowerCase() == 'unfollowed') && commentController.text.isEmpty)
                              // ? () => AppConfig().showSnackbar(context, "Please Mention the comments why you unfollowed?", isError: true)
                              : () {
                                  // print("this one $presentDay");
                                  // for (int i = 0; i < presentDay!; i++) {
                                  //   print(presentDay);
                                  //   if (listData[i].isCompleted == 0 &&
                                  //       i + 1 != selectedDay!) {
                                  //     AppConfig().showSnackbar(context,
                                  //         "Please Complete Day ${listData[i].dayNumber}",
                                  //         isError: true);
                                  //     break;
                                  //   } else if (listData[i].isCompleted == 1) {
                                  //     print("completed already");
                                  //   } else if (i + 1 == presentDay ||
                                  //       i + 1 == selectedDay) {
                                  //     print("u can access $presentDay");
                                      sendData();
                                  //     break;
                                  //   } else {
                                  //     print("u r trying else");
                                  //   }
                                  // }
                                },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.5.h),
                        // width:
                        //     btnText.length > 22 ? 75.w : 60.w,
                        // height: 5.h,
                        decoration: BoxDecoration(
                          color: (statusList.length == lst.length)
                              ? eUser().buttonColor
                              : tableHeadingBg,
                          borderRadius:
                              BorderRadius.circular(eUser().buttonBorderRadius),
                          // border: Border.all(color: eUser().buttonBorderColor,
                          //     width: eUser().buttonBorderWidth),
                        ),
                        child: Center(
                          child: isSent
                              ? buildThreeBounceIndicator(color: gWhiteColor)
                              :Text(
                            btnText,
                            // 'Proceed to Day $proceedToDay',
                            style: TextStyle(
                              fontFamily: eUser().buttonTextFont,
                              color: eUser().buttonTextColor,
                              // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Visibility(
              visible: (isDayCompleted == true && isTrackerSubmitted == false),
              // buttonVisibility(),
              child: Center(
                child: IntrinsicWidth(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => NewDayTracker(
                            phases: "3",
                            proceedProgramDayModel: SubmitMealPlanTrackerModel(
                              day: selectedDay.toString(),
                              mealPlanType: "2",
                            ),
                            trackerVideoLink: widget.trackerVideoLink,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 1.5.h),
                      // width:
                      //     btnText.length > 22 ? 75.w : 60.w,
                      // height: 5.h,
                      decoration: BoxDecoration(
                        color: (statusList.length == lst.length)
                            ? eUser().buttonColor
                            : tableHeadingBg,
                        borderRadius:
                        BorderRadius.circular(eUser().buttonBorderRadius),
                        // border: Border.all(color: eUser().buttonBorderColor,
                        //     width: eUser().buttonBorderWidth),
                      ),
                      child: Center(
                        child: isSent
                            ? buildThreeBounceIndicator(color: gWhiteColor)
                            : Text(
                          "Tracker",
                          // 'Proceed to Day $proceedToDay',
                          style: TextStyle(
                            fontFamily: eUser().buttonTextFont,
                            color: eUser().buttonTextColor,
                            // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (isDayCompleted == true && isTrackerSubmitted == true),
              // (!buttonVisibility() &&
              //     ((presentDay ?? 0) >= (selectedDay ?? 1)) &&
              //     !widget.viewDay1Details),
              child: Center(
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: gPrimaryColor, shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.done_outlined,
                                color: gWhiteColor,
                                size: 3.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            // "Day ${widget.day} Meal Plan",
                            "Day ${selectedDay} Submitted",
                            style: TextStyle(
                                fontFamily: eUser().mainHeadingFont,
                                color: gTextColor,
                                fontSize: eUser().mainHeadingFontSize),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  videoPlayerView() {
    return PIPStack(
      shrinkAlignment: Alignment.bottomRight,
      backgroundWidget: backgroundWidgetForPIP(),
      pipWidget: isEnabled
          ? Consumer<CheckState>(
              builder: (_, model, __) {
                WakelockPlus.enable();
                print("model.isChanged: ${model.isChanged} $isEnabled");

                widget.onChanged?.call(model.isChanged);

                if (model.isChanged) {}
                return Container(
                  color: Colors.black,
                  child: Center(
                      child: Chewie(
                    controller: _yogaChewieController!,
                  )),
                );
                // return VlcPlayerWithControls(
                //   key: _key,
                //   controller: _controller!,
                //   showVolume: false,
                //   showVideoProgress: !model.isChanged,
                //   seekButtonIconSize: 10.dp,
                //   playButtonIconSize: 14.dp,
                //   replayButtonSize: 14.dp,
                //   showFullscreenBtn: true,
                // );
              },
            )
          //     ? FutureBuilder(
          //   future: _initializeVideoPlayerFuture,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       // If the VideoPlayerController has finished initialization, use
          //       // the data it provides to limit the aspect ratio of the video.
          //       return VlcPlayer(
          //         controller: _videoPlayerController,
          //         aspectRatio: 16 / 9,
          //         placeholder: Center(child: CircularProgressIndicator()),
          //       );
          //     } else {
          //       // If the VideoPlayerController is still initializing, show a
          //       // loading spinner.
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // )
          //     ? Container(
          //   color: Colors.pink,
          // )
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
        if (_yogaVideoController != null) _yogaVideoController!.dispose();
        if (_yogaChewieController != null) _yogaChewieController!.dispose();

        // if (_trackerVideoPlayerController != null) _trackerVideoPlayerController!.stop();
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

  buildMealPlan() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(2, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            height: 5.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                color: tableHeadingBg),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Container(
            //       margin: EdgeInsets.only(left:10),
            //       child: Text(
            //         'Time',
            //         style: TextStyle(
            //           color: gWhiteColor,
            //           fontSize: 11.dp,
            //           fontFamily: "GothamMedium",
            //         ),
            //       ),
            //     ),
            //     Text(
            //       'Meal/Yoga',
            //       style: TextStyle(
            //         color: gWhiteColor,
            //         fontSize: 11.dp,
            //         fontFamily: "GothamMedium",
            //       ),
            //     ),
            //     Container(
            //       margin: EdgeInsets.only(right:10),
            //       child: Text(
            //         'Status',
            //         style: TextStyle(
            //           color: gWhiteColor,
            //           fontSize: 11.dp,
            //           fontFamily: "GothamMedium",
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
          DataTable(
            headingTextStyle: TextStyle(
              color: gWhiteColor,
              fontSize: 5.dp,
              fontFamily: "GothamMedium",
            ),
            headingRowHeight: 5.h,
            horizontalMargin: 2.w,
            // columnSpacing: 60,
            dataRowHeight: getRowHeight(),
            // headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  ' Time',
                  style: TextStyle(
                    color: eUser().userFieldLabelColor,
                    fontSize: 11.dp,
                    fontFamily: kFontBold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Meal/Yoga',
                  style: TextStyle(
                    color: eUser().userFieldLabelColor,
                    fontSize: 11.dp,
                    fontFamily: kFontBold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  ' Status',
                  style: TextStyle(
                    color: eUser().userFieldLabelColor,
                    fontSize: 11.dp,
                    fontFamily: kFontBold,
                  ),
                ),
              ),
            ],
            rows: dataRowWidget(),
          ),
        ],
      ),
    );
  }

  groupList() {
    List<Column> _data = [];

    mealPlanData1.forEach((dayTime, value) {
      print("dayTime ===> $dayTime");
      value.forEach((element) {
        print("values ==> ${element.toJson()}");
      });

      _data.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Text(
              dayTime,
              style: TextStyle(
                height: 1.5,
                color: MealPlanConstants().mealNameTextColor,
                fontSize: 15.dp,
                fontFamily: MealPlanConstants().mealNameFont,
              ),
            ),
          ),
          ...value.map((e) {

            final a = e.recipeVideoUrl;

            final file = a?.split(".").last;

            String format = file.toString();

            print("video : $format");

            print("indexs : ${value.indexOf(e)}");

            String ben = (e.benefits != null || e.benefits != "")
                ? e.benefits!.replaceAll(RegExp(r'[^\w\s]+'), '')
                : '';

            print("benefits : ${e.name} ${ben.length}");

            return Column(
              children: [
                Container(
                  height: 140,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // (value.indexOf(e) == 0) &&
                                  mealPlanData1.values.toList().indexWhere(
                                          (element) => element == value) ==
                                      1
                              ? SimpleTooltip(
                                  borderColor: gWhiteColor,
                                  maxWidth: 50.w,
                                  ballonPadding: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 0.5.h),
                                  arrowTipDistance: -10,
                                  arrowLength: 10,
                                  arrowBaseWidth: 10,
                                  // targetCenter: const Offset(3,4),
                                  tooltipTap: () {
                                    setState(() {
                                      showToolTip = false;
                                    });
                                  },
                                  animationDuration: const Duration(seconds: 3),
                                  show: showToolTip,
                                  tooltipDirection: TooltipDirection.up,
                                  child: ThumbnailWidget(
                                    mealName: e.mealTypeName,
                                    thumbnail: e.itemImage,
                                    type: e.type,
                                    func: e.type == 'item'
                                        ? (e.howToPrepare == null)
                                        ? () {
                                      AppConfig().showSnackbar(
                                          context, "No Recipe Found",
                                          isError: true,
                                          bottomPadding: 10);
                                    }
                                        : () {
                                      setState(() {
                                        showToolTip = false;
                                      });
                                      format == "mp4"
                                          ? Get.to(
                                            () =>
                                            MealPlanPortraitVideo(
                                              videoUrl:
                                              e.recipeVideoUrl ??
                                                  '',
                                              heading: e.mealTypeName ==
                                                  "null" ||
                                                  e.mealTypeName ==
                                                      ""
                                                  ? e.name ?? ''
                                                  : e.mealTypeName ??
                                                  '',
                                            ),
                                      )
                                          : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MealPlanRecipeDetails(
                                                mealPlanRecipe: e,
                                                isFromProgram: true,
                                              ),
                                        ),
                                      );
                                    }
                                        : () => showVideo(e),
                                  ),
                                  content: Text(
                                    "Tap here for Recipe",
                                    style: TextStyle(
                                        fontSize:
                                            PPConstants().topViewSubFontSize,
                                        fontFamily:
                                            MealPlanConstants().mealNameFont,
                                        color: gHintTextColor),
                                  ),
                                )
                              : ThumbnailWidget(
                                    mealName: e.mealTypeName,
                                    thumbnail: e.itemImage,
                                    type: e.type,
                                    func: e.type == 'item'
                                        ? (e.howToPrepare == null)
                                        ? () {
                                      AppConfig().showSnackbar(
                                          context, "No Recipe Found",
                                          isError: true,
                                          bottomPadding: 10);
                                    }
                                        : () {
                                      setState(() {
                                        showToolTip = false;
                                      });
                                      format == "mp4"
                                          ? Get.to(
                                            () =>
                                            MealPlanPortraitVideo(
                                              videoUrl:
                                              e.recipeVideoUrl ??
                                                  '',
                                              heading: e.mealTypeName ==
                                                  "null" ||
                                                  e.mealTypeName ==
                                                      ""
                                                  ? e.name ?? ''
                                                  : e.mealTypeName ??
                                                  '',
                                            ),
                                      )
                                          : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MealPlanRecipeDetails(
                                                mealPlanRecipe: e,
                                                isFromProgram: true,
                                              ),
                                        ),
                                      );
                                    }
                                        : () => showVideo(e),
                                  ),
                        ],
                      ),
                      SizedBox(width: 1.5.w),
                      Expanded(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible:
                                  e.subTitle != null || e.subTitle!.isNotEmpty,
                              child: Text(
                                e.subTitle ?? "* Must Have",
                                style: TextStyle(
                                  fontSize:
                                      MealPlanConstants().mustHaveFontSize,
                                  fontFamily: MealPlanConstants().mustHaveFont,
                                  color: MealPlanConstants().mustHaveTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            e.mealTypeName == "null" || e.mealTypeName == ""
                                ? Text(
                                    e.name ?? '',
                                    style: TextStyle(
                                        fontSize: MealPlanConstants()
                                            .mealNameFontSize,
                                        fontFamily:
                                            MealPlanConstants().mealNameFont,
                                        color: gHintTextColor),
                                  )
                                : Text(
                                    e.mealTypeName ?? '',
                                    style: TextStyle(
                                        fontSize: MealPlanConstants()
                                            .mealNameFontSize,
                                        fontFamily:
                                            MealPlanConstants().mealNameFont,
                                        color: gHintTextColor),
                                  ),
                            // Text(e.mealTime ?? "B/W 6-8am",
                            //   style: TextStyle(
                            //       fontSize: 9.dp,
                            //       fontFamily: kFontMedium
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            SizedBox(height: 1.5.h),
                            e.type == "item"
                                ? (e.benefits != null || e.benefits != "")
                                    ? RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: ben.substring(
                                                      0,
                                                      int.parse(
                                                          "${(ben.length * 0.208).toInt()}")) +
                                                  "...",
                                              style: TextStyle(
                                                  height: 1.6,
                                                  fontFamily: kFontBook,
                                                  color:
                                                      eUser().mainHeadingColor,
                                                  fontSize:
                                                      bottomSheetSubHeadingSFontSize),
                                            ),
                                            WidgetSpan(
                                              child: InkWell(
                                                mouseCursor:
                                                    SystemMouseCursors.click,
                                                onTap: () {
                                                  showMoreBenefitsTextSheet(
                                                      e.benefits ?? '');
                                                },
                                                child: Text(
                                                  "read more",
                                                  style: TextStyle(
                                                      height: 1.6,
                                                      fontFamily: kFontBook,
                                                      color: gsecondaryColor,
                                                      fontSize:
                                                          bottomSheetSubHeadingSFontSize),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        textScaler: TextScaler.linear(0.85),
                                      )
                                    // Row(
                                    //         children: [
                                    //           Expanded(
                                    //             child: Text(
                                    //               e.benefits?.split(" \n*").first ??
                                    //                   '',
                                    //               style: TextStyle(
                                    //                   fontFamily:
                                    //                       eUser().userTextFieldFont,
                                    //                   height: 1.2,
                                    //                   color:
                                    //                       eUser().userTextFieldColor,
                                    //                   fontSize: 14.dp),
                                    //             ),
                                    //
                                    //           ),
                                    //           WidgetSpan(
                                    //             child: InkWell(
                                    //               mouseCursor: SystemMouseCursors.click,
                                    //               onTap: () {},
                                    //               child: Text(
                                    //                 "more",
                                    //                 style: TextStyle(
                                    //                     height: 1.3,
                                    //                     fontFamily: kFontBook,
                                    //                     color: gsecondaryColor,
                                    //                     fontSize:
                                    //                     bottomSheetSubHeadingSFontSize),
                                    //               ),
                                    //             ),
                                    //           )
                                    //         ],
                                    //       )
                                    // Expanded(
                                    //         child: SingleChildScrollView(
                                    //           child: Column(
                                    //             mainAxisSize: MainAxisSize.min,
                                    //             children: [
                                    //               ...e.benefits!
                                    //                   .split('* ')
                                    //                   .map((element) {
                                    //                 if (element.isNotEmpty) {
                                    //                   return Row(
                                    //                     crossAxisAlignment:
                                    //                         CrossAxisAlignment.start,
                                    //                     children: [
                                    //                       Padding(
                                    //                         padding: EdgeInsets.only(
                                    //                             top: 0.3.h),
                                    //                         child: Icon(
                                    //                           Icons.circle_sharp,
                                    //                           color: gGreyColor,
                                    //                           size: 1.h,
                                    //                         ),
                                    //                       ),
                                    //                       SizedBox(width: 0.5.w),
                                    //                       Expanded(
                                    //                         child: Text(
                                    //                           element ?? '',
                                    //                           style: TextStyle(
                                    //                               fontFamily: eUser()
                                    //                                   .userTextFieldFont,
                                    //                               height: 1.2,
                                    //                               color: eUser()
                                    //                                   .userTextFieldColor,
                                    //                               fontSize: eUser()
                                    //                                   .userTextFieldHintFontSize),
                                    //                         ),
                                    //                       ),
                                    //                     ],
                                    //                   );
                                    //                 } else {
                                    //                   return const SizedBox();
                                    //                 }
                                    //               })
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       )
                                    : const SizedBox()
                                : const SizedBox(),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !widget.viewDay1Details,
                        child: GestureDetector(
                          onTap: () {
                            print(selectedDay);
                            print(presentDay);
                            // if (
                            // !buttonVisibility() &&
                            //     ((presentDay ?? 0) >=
                            //         (selectedDay ?? 1)) &&
                            //     !widget.viewDay1Details) {
                            //   return;
                            // } else {
                            showFollowedSheet(e);
                            // }

                            // if(presentDay == selectedDay){
                            // }

                            // print(
                            //   value.indexWhere((element) {
                            //     print(element.name);
                            //     print(e.name);
                            //     return element.name == e.name;
                            //   }),
                            // );
                          },
                          child: (statusList.isNotEmpty &&
                                  statusList.containsKey(e.itemId) &&
                                  statusList[e.itemId] == list[0])
                              ? Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            eUser().buttonBorderRadius),
                                        color: gPrimaryColor),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Followed',
                                          style: TextStyle(
                                              fontSize: 10.dp,
                                              fontFamily: kFontMedium,
                                              color: gWhiteColor),
                                        ),
                                        Image.asset(
                                          'assets/images/followed2.png',
                                          width: 20,
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : (statusList.isNotEmpty &&
                                      statusList.containsKey(e.itemId) &&
                                      statusList[e.itemId] == list[1])
                                  ? Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                eUser().buttonBorderRadius),
                                            color: gsecondaryColor),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Missed It',
                                              style: TextStyle(
                                                  fontSize: 10.dp,
                                                  fontFamily: kFontMedium,
                                                  color: gWhiteColor),
                                            ),
                                            Image.asset(
                                              'assets/images/unfollowed.png',
                                              width: 20,
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                eUser().buttonBorderRadius),
                                            color: Colors.grey),
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontSize: 10.dp,
                                              fontFamily: kFontMedium,
                                              color: gWhiteColor),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider()
              ],
            );
          }).toList(),
        ],
      ));
    });
    return _data;
  }

  showMoreBenefitsTextSheet(String text, {bool isMealNote = false}) {
    return AppConfig().showSheet(
        context,
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: isMealNote
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Important Note : ',
                        style: TextStyle(
                            fontFamily: eUser().mainHeadingFont,
                            color: eUser().mainHeadingColor,
                            fontSize: eUser().mainHeadingFontSize),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Align(
                      alignment: Alignment.center,
                      child: HtmlWidget(
                        text,
                        // style: AllListText().subHeadingText(),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...text.split('* ').map((element) {
                      if (element.isNotEmpty) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.3.h),
                              child: Icon(
                                Icons.circle_sharp,
                                color: gGreyColor,
                                size: 1.h,
                              ),
                            ),
                            SizedBox(width: 0.5.w),
                            Expanded(
                              child: Text(
                                element ?? '',
                                style: TextStyle(
                                    fontFamily: eUser().userTextFieldFont,
                                    height: 1.2,
                                    color: eUser().userTextFieldColor,
                                    fontSize:
                                        eUser().userTextFieldHintFontSize),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                    SizedBox(height: 1.h)
                  ],
                ),
        ),
        bottomSheetHeight: 50.h,
        circleIcon: bsHeadBulbIcon,
        isDismissible: true,
        isSheetCloseNeeded: true, sheetCloseOnTap: () {
      Navigator.pop(context);
    });
  }

  showFollowedSheet(ChildMealPlanDetailsModel1 e) {
    print("eeeee:$e");
    return AppConfig().showSheet(context, showFollowWidget(e),
        bottomSheetHeight: 50.h,
        circleIcon: bsHeadPinIcon,
        isDismissible: true,
        isSheetCloseNeeded: true, sheetCloseOnTap: () {
      Navigator.pop(context);
    });
  }

  showFollowWidget(ChildMealPlanDetailsModel1 e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Observe. Let's go!",
            style: TextStyle(
                fontSize: bottomSheetHeadingFontSize,
                fontFamily: bottomSheetHeadingFontFamily,
                color: gsecondaryColor,
                height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 1.5.h),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            color: kLineColor,
            thickness: 1.2,
          ),
        ),
        SizedBox(height: 1.5.h),
        Center(
          child: Text(
            "You ate it or you didn't. Tell us about it.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gTextColor,
              fontSize: bottomSheetSubHeadingXFontSize,
              fontFamily: bottomSheetSubHeadingMediumFont,
            ),
          ),
        ),
        SizedBox(height: 4.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                onChangedTab(0, id: e.itemId, title: list[1]);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                decoration: BoxDecoration(
                    color: gsecondaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Missed",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 13.dp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            GestureDetector(
              onTap: () {
                onChangedTab(0, id: e.itemId, title: list[0]);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                decoration: BoxDecoration(
                    color: gPrimaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Followed",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 13.dp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h)
      ],
    );
  }

  showDataRow() {
    return mealPlanData1.entries.map((e) {
      return DataRow(cells: [
        DataCell(
          Text(
            'e.mealTime.toString()',
            style: TextStyle(
              height: 1.5,
              color: gTextColor,
              fontSize: 8.dp,
              fontFamily: "GothamBold",
            ),
          ),
        ),
        DataCell(
          GestureDetector(
            // onTap: e.url == null ? null : e.type == 'item' ? () => showPdf(e.url!) : () => showVideo(e),
            child: Row(
              children: [
                'e.type' == 'yoga'
                    ? GestureDetector(
                        onTap: () {},
                        child: Image(
                          image: const AssetImage(
                              "assets/images/noun-play-1832840.png"),
                          height: 2.h,
                        ),
                      )
                    : const SizedBox(),
                if ('e.type ' == 'yoga') SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    "e.name.toString()",
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.5,
                      color: gTextColor,
                      fontSize: 8.dp,
                      fontFamily: "GothamBook",
                    ),
                  ),
                ),
              ],
            ),
          ),
          placeholder: true,
        ),
        DataCell(
            // (widget.isCompleted == null) ?
            Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: oldPopup(e.value.first),
        )
            // : Text(e.status ?? '',
            //     textAlign: TextAlign.start,
            //     style: TextStyle(
            //       fontFamily: "GothamBook",
            //       color: gTextColor,
            //       fontSize: 8.dp,
            //     ),
            //   ),
            ),
        // DataCell(
        //   Text(
        //     e.key.toString(),
        //     style: TextStyle(
        //       height: 1.5,
        //       color: gTextColor,
        //       fontSize: 8.dp,
        //       fontFamily: "GothamBold",
        //     ),
        //   ),
        // ),
        // DataCell(
        //   ListView.builder(
        //       shrinkWrap: true,
        //       itemCount: e.value.length,
        //       itemBuilder: (_, index){
        //         return GestureDetector(
        //           onTap: e.value[index].url == null ? null : e.value[index].url == 'item' ? () => showPdf(e.value[index].url!) : () => showVideo(e.value[index]),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               e.value[index].type == 'yoga'
        //                   ? GestureDetector(
        //                 onTap: () {},
        //                 child: Image(
        //                   image: const AssetImage(
        //                       "assets/images/noun-play-1832840.png"),
        //                   height: 2.h,
        //                 ),
        //               )
        //                   : const SizedBox(),
        //               if(e.value[index].type == 'yoga') SizedBox(width: 2.w),
        //               Expanded(
        //                 child: Text(
        //                   "${e.value.map((value) => value.name)}",
        //                   // " ${e.name.toString()}",
        //                   maxLines: 3,
        //                   textAlign: TextAlign.start,
        //                   overflow: TextOverflow.ellipsis,
        //                   style: TextStyle(
        //                     height: 1.5,
        //                     color: gTextColor,
        //                     fontSize: 8.dp,
        //                     fontFamily: "GothamBook",
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       }
        //   ),
        //   placeholder: true,
        // ),
        // DataCell(
        //     Theme(
        //       data: Theme.of(context).copyWith(
        //         highlightColor: Colors.transparent,
        //         splashColor: Colors.transparent,
        //       ),
        //       child: oldPopup(e.value[0]),
        //     )
        //   // (widget.isCompleted == null) ?
        //   //   ListView.builder(
        //   //     shrinkWrap: true,
        //   //       itemBuilder: (_, index){
        //   //         return ;
        //   //       }
        //   //   )
        //   // : Text(e.status ?? '',
        //   //     textAlign: TextAlign.start,
        //   //     style: TextStyle(
        //   //       fontFamily: "GothamBook",
        //   //       color: gTextColor,
        //   //       fontSize: 8.dp,
        //   //     ),
        //   //   ),
        // ),
      ]);
    });
    return shoppingData!
        .map((e) => DataRow(
              cells: [
                DataCell(
                  Text(
                    e.mealTime.toString(),
                    style: TextStyle(
                      height: 1.5,
                      color: gTextColor,
                      fontSize: 8.dp,
                      fontFamily: "GothamBold",
                    ),
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: e.url == null
                        ? null
                        : e.type == 'item'
                            ? () => showPdf(e.url!, e.name)
                            : () => showVideo(e),
                    child: Row(
                      children: [
                        e.type == 'yoga'
                            ? GestureDetector(
                                onTap: () {},
                                child: Image(
                                  image: const AssetImage(
                                      "assets/images/noun-play-1832840.png"),
                                  height: 2.h,
                                ),
                              )
                            : const SizedBox(),
                        if (e.type == 'yoga') SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            " ${e.name.toString()}",
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.5,
                              color: gTextColor,
                              fontSize: 8.dp,
                              fontFamily: "GothamBook",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  placeholder: true,
                ),
                DataCell(
                    // (widget.isCompleted == null) ?
                    Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: oldPopup(e),
                )
                    // : Text(e.status ?? '',
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       fontFamily: "GothamBook",
                    //       color: gTextColor,
                    //       fontSize: 8.dp,
                    //     ),
                    //   ),
                    ),
              ],
            ))
        .toList();
  }

  List<DataRow> dataRowWidget() {
    List<DataRow> _data = [];
    mealPlanData1.forEach((dayTime, value) {
      _data.add(DataRow(cells: [
        DataCell(
          Text(
            dayTime,
            style: TextStyle(
              height: 1.5,
              color: gTextColor,
              fontSize: 8.sp,
              fontFamily: kFontMedium,
            ),
          ),
        ),
        DataCell(
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...value
                  .map((e) => GestureDetector(
                        onTap: e.url == null
                            ? null
                            : e.type == 'item'
                                ? () => showPdf(e.url!, e.name)
                                : () => showVideo(e),
                        child: Row(
                          children: [
                            e.type == 'yoga'
                                ? GestureDetector(
                                    onTap: () {},
                                    child: Image(
                                      image: const AssetImage(
                                          "assets/images/noun-play-1832840.png"),
                                      height: 2.h,
                                    ),
                                  )
                                : const SizedBox(),
                            if (e.type == 'yoga') SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                " ${e.name.toString()}",
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.5,
                                  color: gTextColor,
                                  fontSize: 8.sp,
                                  fontFamily: kFontMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList()
            ],
          ),
          placeholder: true,
        ),
        DataCell(
            // (widget.isCompleted == null) ?
            Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // shrinkWrap: true,
          children: [
            ...value.map((e) {
              return Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: oldPopup(e),
              );
            }).toList()
          ],
        )
            // : Text(e.status ?? '',
            //     textAlign: TextAlign.start,
            //     style: TextStyle(
            //       fontFamily: "GothamBook",
            //       color: gTextColor,
            //       fontSize: 8.sp,
            //     ),
            //   ),
            ),
      ]));
    });
    return _data;
  }

  showDataRow1() {
    return shoppingData!
        .map((e) => DataRow(
              cells: [
                DataCell(
                  Text(
                    e.mealTime.toString(),
                    style: TextStyle(
                      height: 1.5,
                      color: gTextColor,
                      fontSize: 8.sp,
                      fontFamily: "GothamBold",
                    ),
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: e.url == null
                        ? null
                        : e.type == 'item'
                            ? () => showPdf(e.url!, e.name)
                            : () => showVideo(e),
                    child: Row(
                      children: [
                        e.type == 'yoga'
                            ? GestureDetector(
                                onTap: () {},
                                child: Image(
                                  image: const AssetImage(
                                      "assets/images/noun-play-1832840.png"),
                                  height: 2.h,
                                ),
                              )
                            : const SizedBox(),
                        if (e.type == 'yoga') SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            " ${e.name.toString()}",
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.5,
                              color: gTextColor,
                              fontSize: 8.sp,
                              fontFamily: "GothamBook",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  placeholder: true,
                ),
                DataCell(
                    // (widget.isCompleted == null) ?
                    Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: oldPopup(e),
                )
                    // : Text(e.status ?? '',
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       fontFamily: "GothamBook",
                    //       color: gTextColor,
                    //       fontSize: 8.sp,
                    //     ),
                    //   ),
                    ),
              ],
            ))
        .toList();
  }

  Map statusList = {};

  List lst = [];

  void onChangedTab(int index, {int? id, String? title}) {
    print('$id  $title');
    setState(() {
      if (id != null && title != null) {
        if (statusList.isNotEmpty && statusList.containsKey(id)) {
          print("contains");
          statusList.update(id, (value) => title);
        } else if (statusList.isEmpty || !statusList.containsKey(id)) {
          print('new');
          statusList.putIfAbsent(id, () => title);
        }
      }
      print(statusList);
      Map<String, dynamic> storeMealDataLocally = {
        "selected_meal": statusList.toString(),
        "comments": commentController.text
      };
      _pref!.setString(
          AppConfig.STORE_MEAL_DATA, json.encode(storeMealDataLocally));
      print(statusList[id].runtimeType);
    });
  }

  getStatusText(int id) {
    print("id: ${id}");
    print('statusList[id]${statusList[id]}');
    return statusList[id];
  }

  getTextColor(int id) {
    setState(() {
      if (statusList.isEmpty) {
        textColor = gWhiteColor;
      } else if (statusList[id] == list[0]) {
        textColor = gPrimaryColor;
      } else if (statusList[id] == list[1]) {
        textColor = gsecondaryColor;
      }
    });
    return textColor;
  }

  void onChangedDummyTab(int index) {
    setState(() {
      planStatus = index;
    });
  }

  Widget buildTabView(
      {required int index,
      required String title,
      required Color color,
      int? itemId}) {
    return GestureDetector(
      onTap: () {
        onChangedTab(index, id: itemId, title: title);
        Get.back();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: kFontBook,
            // color: (planStatus == index) ? color : gTextColor,
            color: (statusList[itemId] == title) ? color : gTextColor,
            fontSize: 9.5.sp,
          ),
        ),
      ),
    );
  }

  Widget buildDummyTabView(
      {required int index,
      required String title,
      required Color color,
      int? itemId}) {
    return GestureDetector(
      onTap: () {
        onChangedDummyTab(index);
        Get.back();
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "GothamBook",
          color: (planStatus == index) ? color : gTextColor,
          fontSize: 8.sp,
        ),
      ),
    );
  }

  String buildDummyHeaderText() {
    if (planStatus == 0) {
      headerText = "     ";
    } else if (planStatus == 1) {
      headerText = "Followed";
    } else if (planStatus == 2) {
      headerText = "UnFollowed";
    }
    return headerText;
  }

  Color? buildDummyTextColor() {
    if (planStatus == 0) {
      textColor = gWhiteColor;
    } else if (planStatus == 1) {
      textColor = gPrimaryColor;
    } else if (planStatus == 2) {
      textColor = gsecondaryColor;
    } else if (planStatus == 3) {
      textColor = gMainColor;
    } else if (planStatus == 4) {
      textColor = gMainColor;
    }
    return textColor;
  }

  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bool isSent = false;

  // void sendData() async {
  //   setState(() {
  //     isSent = true;
  //   });
  //   ProceedProgramDayModel? model;
  //   List<PatientMealTracking> tracking = [];
  //
  //   statusList.forEach((key, value) {
  //     print('$key---$value');
  //     tracking.add(PatientMealTracking(
  //         day: selectedDay,
  //         userMealItemId: key,
  //         status: (value == list[1]) ? sendList[1] : sendList[0]));
  //   });
  //
  //   print(tracking);
  //   model = ProceedProgramDayModel(
  //     patientMealTracking: tracking,
  //     comment: commentController.text.isEmpty ? null : commentController.text,
  //     day: selectedDay.toString(),
  //   );
  //   List dummy = [];
  //   model.patientMealTracking!.forEach((element) {
  //     dummy.add(jsonEncode(element.toJson()));
  //   });
  //   print('dummy: $dummy');
  //
  //   // showSymptomsTrackerSheet(context, model);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (ctx) => TrackerUI(
  //           proceedProgramDayModel: model,
  //           from: ProgramMealType.healing.name,
  //           trackerVideoLink: widget.trackerVideoLink
  //       ),),);
  //   setState(() {
  //     isSent = false;
  //   });
  // }

  void sendData() async {
    setState(() {
      isSent = true;
    });
    SubmitMealPlanTrackerModel? model;
    List<PatientMealTracking> tracking = [];

    statusList.forEach((key, value) {
      print('$key---$value');
      tracking.add(PatientMealTracking(
          day: selectedDay,
          userMealItemId: key,
          status: (value == list[1]) ? sendList[1] : sendList[0]));
    });

    print(tracking);
    model = SubmitMealPlanTrackerModel(
      patientMealTracking: tracking,
      comment: commentController.text.isEmpty ? "" : commentController.text,
      day: selectedDay.toString(),
      mealPlanType:"2",
    );
    List dummy = [];
    model.patientMealTracking!.forEach((element) {
      dummy.add(jsonEncode(element.toJson()));
    });
    print('dummy: $dummy');

    final result = await ProgramService(repository: repository)
        .submitMealPlanService(
        model);

    print("result: $result");

    if (result.runtimeType == GetProceedModel) {
      setState(() {
        isSent = false;
      });
      final _pref = AppConfig().preferences;
      final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => NewDayTracker(
            phases: "3",
            proceedProgramDayModel: model,
            trackerVideoLink: widget.trackerVideoLink,
          ),
          // TrackerUI(
          // proceedProgramDayModel: model,
          // from: ProgramMealType.healing.name,
          // trackerVideoLink: widget.trackerVideoLink),
        ),
      );
    } else {
      setState(() {
        isSent = false;
      });
      ErrorModel model = result as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    }

    // showSymptomsTrackerSheet(context, model);
  }

  showPdf(String itemUrl, String? receipeName) {
    print(itemUrl);
    String? url;
    if (itemUrl.contains('drive.google.com')) {
      url = itemUrl;
      // url = 'https://drive.google.com/uc?export=view&id=1LV33e5XOl0YM8r6AqhU6B4oZniWwXcTZ';
      // String baseUrl = 'https://drive.google.com/uc?export=view&id=';
      // print(itemUrl.split('/')[5]);
      // url = baseUrl + itemUrl.split('/')[5];
    } else {
      url = itemUrl;
    }
    print(url);
    if (url.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => MealPdf(
                  pdfLink: url!,
                  mealVideoLink: widget.receipeVideoLink ?? '',
                  videoName: "Know more about Recipe",
                  heading: receipeName,
                  headCircleIcon: bsHeadBulbIcon,
                  isSheetCloseNeeded: true,
                  sheetCloseOnTap: () {
                    Navigator.pop(context);
                  })));
    } else {
      AppConfig().showSnackbar(context, "Url Not Available", isError: true);
    }
  }

  showVideo(ChildMealPlanDetailsModel1 e) async {
    print("url : ${e.url!.split('.').last}");
    if (e.url!.split('.').last == "mp4") {
      // setState(() {
      //   isEnabled = !isEnabled;
      //   videoName = e.name!;
      //   mealTime = e.mealTime!;
      // });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => YogaVideoPlayer(
                videoUrl: e.url ?? '',
                heading: e.name ?? '',
              )));

      // YogaVideoPlayer(
      //   url: e.url.toString(),
      // );
      // initChewieView(e.url);
      // initVideoView(e.url);
    } else {
      print(e.url);
      if (await canLaunchUrl(Uri.parse(e.url ?? ''))) {
        launch(e.url ?? '');
      } else {
        // can't launch url, there is some error
        throw "Could not launch ${e.url}";
      }
      // setState(() {
      //   isEnabled = !isEnabled;
      //   videoName = e.name!;
      //   mealTime = e.mealTime!;
      // });
      // YogaVideoPlayer(
      //   url: e.url.toString(),
      // );
      // initChewieView(e.url);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (ctx) => Mp3Widget(url: e.url ?? '')));
    }

    // _init(e.url);
    // Navigator.push(context, MaterialPageRoute(builder: (ctx)=> YogaVideoScreen(yogaDetails: e.toJson(),day: widget.day,)));
  }

  oldPopup(ChildMealPlanDetailsModel1 e) {
    return IgnorePointer(
      ignoring: isDayCompleted == true,
      child: Container(
        margin: EdgeInsets.only(bottom: 4),
        child: PopupMenuButton(
          offset: const Offset(0, 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.6.h),
                  buildTabView(
                      index: 1,
                      title: list[0],
                      color: gPrimaryColor,
                      itemId: e.itemId!),
                  SizedBox(height: 0.6.h),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    height: 1,
                    color: gHintTextColor.withOpacity(0.3),
                  ),
                  SizedBox(height: 0.6.h),
                  buildTabView(
                      index: 2,
                      title: list[1],
                      color: gsecondaryColor,
                      itemId: e.itemId!),
                  SizedBox(height: 0.6.h),
                ],
              ),
              onTap: null,
            ),
          ],
          child: Container(
            width: 20.w,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: gMainColor, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    statusList.isEmpty ? '' : getStatusText(e.itemId!) ?? '',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: "GothamBook",
                        color: statusList.isEmpty
                            ? textColor
                            : getTextColor(e.itemId!) ?? textColor,
                        fontSize: 8.sp),
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: gHintTextColor,
                  size: 2.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool buttonVisibility() {
    bool isVisible;
    if (widget.viewDay1Details) {
      isVisible = false;
    } else if (isDayCompleted == true) {
      isVisible = false;
    } else if (nextDay == selectedDay) {
      isVisible = false;
    } else if (isHealingCompleted) {
      isVisible = false;
    } else {
      isVisible = true;
    }
    print("isVisible: $isVisible");
    return isVisible;
    // widget.isCompleted == null || (widget.nextDay == widget.day)
  }

  getRowHeight() {
    if (mealPlanData1.values.length > 1) {
      return 8.h;
    } else {
      return 6.h;
    }
  }

  bool showMealVideo = false;
  // showSymptomsTrackerSheet(BuildContext context, ProceedProgramDayModel model) {
  //   return AppConfig().showSheet(context,
  //       StatefulBuilder(builder: (_, setState) {
  //     return SizedBox(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           videoMp4Widget(
  //               videoName: "Know more about Symptoms Tracker",
  //               onTap: () {
  //                 addTrackerUrlToChewiePlayer(widget.trackerVideoLink ?? '');
  //                 // addTrackerUrlToVideoPlayer(widget.trackerVideoLink ?? '');
  //                 setState(() {
  //                   showMealVideo = true;
  //                 });
  //               }),
  //           Stack(
  //             children: [
  //               TrackerUI(
  //                 proceedProgramDayModel: model,
  //                 from: ProgramMealType.healing.name,
  //               ),
  //               Visibility(
  //                 visible: showMealVideo,
  //                 child: Positioned(
  //                     child: Center(child: buildMealVideo(onTap: () async {
  //                   setState(() {
  //                     showMealVideo = false;
  //                   });
  //                   if (await WakelockPlus.enabled == true) {
  //                     WakelockPlus.disable();
  //                   }
  //                   if (_sheetVideoController != null)
  //                     _sheetVideoController!.dispose();
  //                   if (_sheetChewieController != null)
  //                     _sheetChewieController!.dispose();
  //
  //                   // if (_trackerVideoPlayerController != null) _trackerVideoPlayerController!.dispose();
  //                 }))),
  //               )
  //             ],
  //           )
  //         ],
  //       ),
  //     );
  //   }), circleIcon: bsHeadPinIcon, bottomSheetHeight: 90.h);
  //
  //   return showModalBottomSheet(
  //       isDismissible: false,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       enableDrag: false,
  //       builder: (ctx) {
  //         return Wrap(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: TrackerUI(
  //                 proceedProgramDayModel: model,
  //                 from: ProgramMealType.healing.name,
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }

  videoMp4Widget({required VoidCallback onTap, String? videoName}) {
    return InkWell(
      onTap: onTap,
      child: Card(
          child: Row(children: [
        Image.asset(
          "assets/images/meal_placeholder.png",
          height: 35,
          width: 40,
        ),
        Expanded(
            child: Text(
          videoName ?? "Symptom Tracker.mp4",
          style: TextStyle(fontFamily: kFontBook),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/arrow_for_video.png",
            height: 35,
          ),
        )
      ])),
    );
  }

  // addTrackerUrlToVideoPlayer(String url) async {
  //   print("url" + url);
  //   _trackerVideoPlayerController = VlcPlayerController.network(
  //     Uri.parse(url).toString(),
  //     // url,
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.auto,
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
  //   _trackerVideoPlayerController!.play();
  //   if (await Wakelock.enabled == false) {
  //     Wakelock.enable();
  //   }
  // }
  addTrackerUrlToChewiePlayer(String url) async {
    print("url" + url);
    _sheetVideoController =
        VideoPlayerController.network(Uri.parse(url).toString());
    _sheetChewieController = ChewieController(
        videoPlayerController: _sheetVideoController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        allowedScreenSleep: false,
        hideControlsTimer: Duration(seconds: 3),
        showControls: false);
    if (await WakelockPlus.enabled == false) {
      WakelockPlus.enable();
    }
  }

  buildMealVideo({required VoidCallback onTap}) {
    if (_sheetChewieController != null) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gPrimaryColor, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Center(
                    child: OverlayVideo(
                  controller: _sheetChewieController!,
                  isControlsVisible: false,
                )),
              ),
            ),
          ),
          Center(
              child: IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: gsecondaryColor,
            ),
            onPressed: onTap,
          ))
        ],
      );
    }
    // else if (_trackerVideoPlayerController != null) {
    //   return Column(
    //     children: [
    //       AspectRatio(
    //         aspectRatio: 16 / 9,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5),
    //             border: Border.all(color: gPrimaryColor, width: 1),
    //             // boxShadow: [
    //             //   BoxShadow(
    //             //     color: Colors.grey.withOpacity(0.3),
    //             //     blurRadius: 20,
    //             //     offset: const Offset(2, 10),
    //             //   ),
    //             // ],
    //           ),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(5),
    //             child: Center(
    //                 child: VlcPlayerWithControls(
    //                   key: _trackerKey,
    //                   controller: _trackerVideoPlayerController!,
    //                   showVolume: false,
    //                   showVideoProgress: false,
    //                   seekButtonIconSize: 10.sp,
    //                   playButtonIconSize: 14.sp,
    //                   replayButtonSize: 10.sp,
    //                 )
    //             ),
    //           ),
    //         ),
    //       ),
    //       Center(
    //           child: IconButton(
    //         icon: Icon(
    //           Icons.cancel_outlined,
    //           color: gsecondaryColor,
    //         ),
    //         onPressed: onTap,
    //       ))
    //     ],
    //   );
    // }
    else {
      return SizedBox.shrink();
    }
  }

  getProgramData(NewHealingModel? healingModel, NewDetoxModel? detoxModel,
      String mealNote) async {
    setState(() {
      showShimmer = true;
    });

    ChildDetoxModel? _chkDetoxPlan;
    List<ChildProgramDayModel> listDetoxDay = [];

    if (detoxModel != null) {
      _chkDetoxPlan = detoxModel.value;
      if (detoxModel.totalDays != null) {
        totalDays = detoxModel.totalDays ?? 5;
      }
    }

    var detoxPresentDay = int.tryParse(_chkDetoxPlan!.currentDay!) ?? 1;
    var detoxNextDay = detoxPresentDay + 1;
    var detoxSelectedDay = detoxPresentDay;

    print("healingPresentDay: $detoxPresentDay");
    print("healingNextDay: $detoxNextDay");

    _chkDetoxPlan.details!.forEach((key, value) {
      DetoxHealingModel _model = value;
      print(_model.isDayCompleted);
      listDetoxDay.add(ChildProgramDayModel(
        dayNumber: _model.programDay,
        isCompleted: (_model.isDayCompleted != "")
            ? int.parse(_model.isDayCompleted!)
            : 0,
        isTrackerSubmitted: (_model.isTrackerSubmitted != "")
            ? int.parse(_model.isTrackerSubmitted!)
            : 0,
      ));
    });

    for (var element in listDetoxDay) {
      if (int.parse(element.dayNumber!) == detoxPresentDay) {
        isDayCompleted = element.isTrackerSubmitted == 1 ? true : false;
      }
    }

    if (_chkDetoxPlan.isDetoxCompleted == "1") {
      for (int i = 0; i < detoxPresentDay; i++) {
        print("healing present days : ${listDetoxDay[i].isTrackerSubmitted}");
        if (listDetoxDay[i].isTrackerSubmitted == 0 && i + 1 == detoxSelectedDay) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("Healing Pop Up");
            setState(() {
              showPendingDetoxPlan(listDetoxDay[i].dayNumber);
            });
          });
          break;
        }
      }
    }

    if (healingModel != null) {
      _childDetoxModel = healingModel.value!;

      print("meal note : $mealNote");

      if (mealNote == "null" || mealNote == "") {
      } else {
        Future.delayed(const Duration(seconds: 0)).then((value) {
          return showMoreBenefitsTextSheet(mealNote, isMealNote: true);
        });
      }

      if (healingModel.totalDays != null) {
        totalDays = healingModel.totalDays ?? 5;
      }
    }

    print('healing.values:${healingModel!.value!.details!.entries}');
    healingModel.value!.details!.forEach((key, value) {
      print("day: $key");
      print(value.toMap());
      value.data!.forEach((k, v1) {
        print("$k -- $v1");
      });
    });

    storeDetails();
    // } else {
    //   ErrorModel model = result as ErrorModel;
    //   print("error: ${model.message}");
    //   // errorMsg = model.message ?? '';
    //   // Future.delayed(Duration(seconds: 0)).whenComplete(() {
    //   //   setState(() {
    //   //     showShimmer = false;
    //   //     isLoading = false;
    //   //   });
    //   //   showAlert(context, model.status!,
    //   //       isSingleButton: !(model.status != '401'), positiveButton: () {
    //   //         if (model.status == '401') {
    //   //           Navigator.pop(context);
    //   //           Navigator.pop(context);
    //   //         } else {
    //   //           getMeals();
    //   //           Navigator.pop(context);
    //   //         }
    //   //       });
    //   // });
    // }
    setState(() {
      showShimmer = false;
    });
    // print(result);
  }

  // getProgramData() async {
  //   setState(() {
  //     showShimmer = true;
  //   });
  //   // print(selectedDay);
  //   // statusList.clear();
  //   // lst.clear();
  //   final result =
  //       await ProgramService(repository: repository).getCombinedMealService();
  //   print("result: $result");
  //
  //   if (result.runtimeType == CombinedMealModel) {
  //     print("meal plan");
  //     CombinedMealModel model = result as CombinedMealModel;
  //
  //     if (model.detox != null) {
  //       _chkDetoxPlan = model.detox!.value!;
  //     }
  //
  //     var detoxPresentDay = int.tryParse(_chkDetoxPlan!.currentDay!) ?? 1;
  //     var detoxNextDay = detoxPresentDay + 1;
  //     var detoxSelectedDay = detoxPresentDay;
  //
  //     print("detoxPresentDay: $detoxPresentDay");
  //     print("detoxNextDay: $detoxNextDay");
  //
  //     _chkDetoxPlan!.details!.forEach((key, value) {
  //       DetoxHealingModel _model = value as DetoxHealingModel;
  //       print(_model.isDayCompleted);
  //       listDetoxDay.add(ChildProgramDayModel(
  //           dayNumber: _model.programDay,
  //           isCompleted: (_model.isDayCompleted != "")
  //               ? int.parse(_model.isDayCompleted!)
  //               : 0));
  //     });
  //
  //     listDetoxDay.forEach((element) {
  //       if (int.parse(element.dayNumber!) == detoxPresentDay) {
  //         isDetoxDayCompleted = element.isCompleted == 1 ? true : false;
  //       }
  //     });
  //
  //     if (_chkDetoxPlan?.isDetoxCompleted == "1") {
  //       for (int i = 0; i < detoxPresentDay; i++) {
  //         print("detox present day : ${listDetoxDay[i].isCompleted}");
  //         if (listDetoxDay[i].isCompleted == 0 && i + 1 == detoxSelectedDay) {
  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             print("Detox Pop Up");
  //             showPendingDetoxPlan(listDetoxDay[i].dayNumber);
  //           });
  //           break;
  //         }
  //       }
  //     }
  //     if (model.healing != null) {
  //       _childDetoxModel = model.healing!.value!;
  //       if (model.healing!.totalDays != null) {
  //         totalDays = model.healing!.totalDays ?? 5;
  //       }
  //     }
  //
  //     print('healing.values:${model.healing!.value!.details!.entries}');
  //     model.healing!.value!.details!.forEach((key, value) {
  //       print("day: $key");
  //       print(value.toMap());
  //       value.data!.forEach((k, v1) {
  //         print("$k -- $v1");
  //       });
  //     });
  //
  //     storeDetails();
  //   } else {
  //     ErrorModel model = result as ErrorModel;
  //     print("error: ${model.message}");
  //     // errorMsg = model.message ?? '';
  //     // Future.delayed(Duration(seconds: 0)).whenComplete(() {
  //     //   setState(() {
  //     //     showShimmer = false;
  //     //     isLoading = false;
  //     //   });
  //     //   showAlert(context, model.status!,
  //     //       isSingleButton: !(model.status != '401'), positiveButton: () {
  //     //         if (model.status == '401') {
  //     //           Navigator.pop(context);
  //     //           Navigator.pop(context);
  //     //         } else {
  //     //           getMeals();
  //     //           Navigator.pop(context);
  //     //         }
  //     //       });
  //     // });
  //   }
  //   setState(() {
  //     showShimmer = false;
  //   });
  //   print(result);
  // }

  storeDetails() {
    presentDay = int.tryParse(_childDetoxModel!.currentDay!) ?? 1;
    nextDay = presentDay! + 1;
    selectedDay = presentDay;

    if (_childDetoxModel!.isHealingCompleted != null) {
      isHealingCompleted = (_childDetoxModel!.isHealingCompleted == "0" ||
              _childDetoxModel!.isHealingCompleted == "null")
          ? false
          : true;
    }

    _childDetoxModel!.details!.forEach((key, value) {
      print("value==> $key $value");
      DetoxHealingModel _model = value as DetoxHealingModel;
      listData.add(ChildProgramDayModel(
          dayNumber: _model.programDay,
          isCompleted: (_model.isDayCompleted != "")
              ? int.parse(_model.isDayCompleted!)
              : 0,
        isTrackerSubmitted: (_model.isTrackerSubmitted != "")
            ? int.parse(_model.isTrackerSubmitted!)
            : 0,
      ),);
    });

    getMealFromDay(presentDay!);

    listData.forEach((element) {
      if (int.parse(element.dayNumber!) == presentDay) {
        isDayCompleted = element.isCompleted == 1 ? true : false;
        isTrackerSubmitted = element.isTrackerSubmitted == 1 ? true : false;
      }
    });

    print(isDayCompleted);

    print("mealPlanData1: $mealPlanData1");

    /// made || instead of &&
    /// if && -> than clap will get after isHealingCompleted becomes 1-> this will happpens from cron or when button clicked
    /// if || -> than clap will show once last day has completed
    ///
    // if ((listData.last.isCompleted == 1 ||
    //         _childDetoxModel!.isHealingCompleted == "1") ||
    //     _childDetoxModel!.isHealingCompleted == "1") {
    //   print("widget.isNourishStarted: ${widget.isNourishStarted}");
    //   if (widget.isNourishStarted == false) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       if (!isOpened) {
    //         setState(() {
    //           isOpened = true;
    //         });
    //         buildDayCompletedClap();
    //       }
    //     });
    //   }
    // }

    for (int i = 0; i < presentDay!; i++) {
      print(presentDay);
      if (listData[i].isTrackerSubmitted == 0 && i + 1 != selectedDay!) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showMoreTextSheet(listData[i].dayNumber);
        });
        break;
      }
    }
  }

  final ProgramRepository progrRepository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}

class MealPlanData {
  MealPlanData(this.time, this.title, this.id);

  String time;
  String title;
  int id;
}
