import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/program_model/proceed_model/get_proceed_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/program_repository/program_repository.dart';
import 'package:gwc_customer_web/screens/dashboard_screen.dart';
import 'package:gwc_customer_web/screens/evalution_form/check_box_settings.dart';
import 'package:gwc_customer_web/services/program_service/program_service.dart';
import 'package:gwc_customer_web/utils/app_config.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import '../../../../widgets/video/normal_video.dart';
import '../../../../widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../model/combined_meal_model/meal_plan_tracker_modl/send_meal_plan_tracker_model.dart';
import '../../combined_meal_plan/combined_meal_screen.dart';
import 'button_widget.dart';
import 'question_widget.dart';

class NewDayTracker extends StatefulWidget {
  final String? trackerVideoLink;

  /// this parameter is used to go back to dashboard
  /// if its true we r navigating back 2 times
  final bool isPreviousDaySheet;

  final SubmitMealPlanTrackerModel? proceedProgramDayModel;

  /// from is used for maintaining api url for meal and transition
  final String? phases;
  const NewDayTracker({
    Key? key,
    this.proceedProgramDayModel,
    this.trackerVideoLink,
    this.isPreviousDaySheet = false,
    this.phases,
  }) : super(key: key);

  @override
  State<NewDayTracker> createState() => _NewDayTrackerState();
}

class _NewDayTrackerState extends State<NewDayTracker> {
  bool showMealVideo = false;
  VideoPlayerController? _sheetVideoController, _yogaVideoController;
  ChewieController? _sheetChewieController, yogaChewieController;
  bool isEnabled = false;
  String? planNotePdfLink;
  VideoPlayerController? mealPlayerController;
  ChewieController? chewieController;

  bool showProgress = false;

  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    mealPlayerController = VideoPlayerController.network(url);
    chewieController = ChewieController(
        videoPlayerController: mealPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        hideControlsTimer: Duration(seconds: 3),
        showControls: true);
    if (await WakelockPlus.enabled == false) {
      WakelockPlus.enable();
    }
  }

  initChewieView(String? url) {
    print("init url: $url");
    _yogaVideoController =
        VideoPlayerController.network(Uri.parse(url!).toString());
    yogaChewieController = ChewieController(
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

  int currentIndex = 0;
  final _pageController = PageController(initialPage: 0);
  String followYourMealPlan = "";
  final missedAnythingMealPlanController = TextEditingController();
  final anyMedicinesController = TextEditingController();
  final additionalConcernsController = TextEditingController();
  String yogaModules = "";
  final missedAnythingYogaPlanController = TextEditingController();
  String sleep = "";
  String selectedAnyMedicines = "";
  String stoolInfo = "";
  String symptomsStopping = "";
  String generalHealth = "";
  String compareToYesterday = "";
  String dizziness = "";
  String vomiting = "";
  String looseMotion = "";
  String noEvacuation = "";
  String headache = "";
  String anxiety = "";
  String nourishSigns = "";

  List<File> mandatoryFileFormatList = [];
  List<PlatformFile> mandatoryListRecords = [];

  List mealPlanList = [
    "Yes I followed with the given timings",
    "No I missed to follow"
  ];

  List yogaList = ["Yes", "No"];

  List sleepList = [
    "Sound sleep / uninterrupted sleep",
    "Disturbed sleep",
    "Difficulty to initiate the sleep",
    "Woke up with tiredness. Lethargy/headache",
    "Was awake the entire night,",
  ];

  List stoolInfoList = [
    "Separate hard lumps, like nuts(Difficult to pass)",
    "Sausage-shaped, but lumpy",
    "Like a sausage with cracks on the surface",
    "Like a smooth, soft sausage or snake",
    "Soft blobs with clear-cut edges (easy to pass)",
    "Fluffy pieces with ragged edges, a mushy stool",
    "Watery, entirely liquid",
    "No Evacuation",
  ];

  List symptomsList = ["Yes", "No"];

  List generalHealthList = [
    "Very good",
    "Good",
    "Fair",
    "Poor",
  ];

  List compareToYesterdayList = [
    "Better",
    "The same",
    "Worse",
    "Much Worse",
  ];

  List symptomsBelowList = [
    "None",
    "Low",
    "Moderate",
    "Severe",
  ];

  List vomitingLooseMotionList = [
    "None",
    "1-2 times",
    "3-4 Times",
    "More than 5 times",
  ];

  List noEvacuationList = [
    "None",
    "Day 1",
    "Day 2",
    "Day 3",
  ];

  final nourishSignsCheckBox = <CheckBoxSettings>[
    CheckBoxSettings(
        title:
            "Satisfactory release of Solid waste matter / Gas from stomach and or Urine"),
    CheckBoxSettings(title: "Lightness in the Chest / Abdomen"),
    CheckBoxSettings(title: "Odour free burps"),
    CheckBoxSettings(title: "Freshness in the Mouth"),
    CheckBoxSettings(title: "Easily getting hungry, thirsty, or both"),
    CheckBoxSettings(
        title:
            "Clear tongue/Sense (absence of discharges from sense organs such as the skin's sweat or perspiration, the ears, the nose, the tongue, and the eyes)"),
    CheckBoxSettings(title: "Odour free breath"),
    CheckBoxSettings(title: "No Body odour"),
    CheckBoxSettings(title: "Weight loss"),
    CheckBoxSettings(title: "Peaceful Sleep"),
    CheckBoxSettings(title: "Easy Digestion"),
    CheckBoxSettings(title: "Increased energy levels"),
    CheckBoxSettings(title: "Reduced / absence of cravings"),
    CheckBoxSettings(title: "Feeling of internal wellbeing and happiness"),
    CheckBoxSettings(
        title:
            "Reduced / Absence of Detox related Recovery symptoms as mentioned in the previous question"),
    CheckBoxSettings(title: "None of the above"),
  ];
  List selectedNourishSigns = [];

  final symptomsPart2CheckBox = <CheckBoxSettings>[
    CheckBoxSettings(title: "Chronic burning sensation in the stomach"),
    CheckBoxSettings(
        title:
            "Sour Regurgitation/ Food Regurgitation.(Food Coming back to your mouth)"),
    CheckBoxSettings(title: "Fatigue"),
    CheckBoxSettings(title: "Frequent belching/burping"),
    CheckBoxSettings(title: "Frequent heartburn"),
    CheckBoxSettings(title: "Cramps in the abdomen"),
    CheckBoxSettings(title: "Something stuck in the throat"),
    CheckBoxSettings(title: "Consistent bloating and gas"),
    CheckBoxSettings(title: "Bitter, metallic taste in mouth in mornings"),
    CheckBoxSettings(
        title:
            "Blood in your stool (bright red blood on the tissue paper after a bowel movement)"),
    CheckBoxSettings(title: "Chronic anger, frustration and/or irritability"),
    CheckBoxSettings(title: "Wake regularly between 1 and 3 a.m."),
    CheckBoxSettings(title: "Frequent bad dreams/nightmares"),
    CheckBoxSettings(title: "Constipation"),
    CheckBoxSettings(title: "Painful bowel movements"),
    CheckBoxSettings(title: "None"),
  ];
  List selectedSymptomsPart2 = [];

  final symptomsPart3CheckBox = <CheckBoxSettings>[
    CheckBoxSettings(title: "Bad breath"),
    CheckBoxSettings(title: "Dry Mouth"),
    CheckBoxSettings(title: "Severe Thirst"),
    CheckBoxSettings(title: "Belching or burping after meals"),
    CheckBoxSettings(title: "Gas immediately following eating"),
    CheckBoxSettings(
        title:
            "Indigestion 1-3 hours after eating (upper abdomen pain, heaviness in the upper abdomen, burning sensation)"),
    CheckBoxSettings(title: "Increased Salivation"),
    CheckBoxSettings(title: "Lower bowel gas several hours after eating"),
    CheckBoxSettings(title: "Fatigue"),
    CheckBoxSettings(title: "Mucus in your stool"),
    CheckBoxSettings(title: "Lower abdominal pain and tenderness"),
    CheckBoxSettings(title: "Excess gas and flatulence"),
    CheckBoxSettings(
        title: "Abdominal pain relieved by bowel movement or passing gas"),
    CheckBoxSettings(
        title: "itching, burning pain and/or inflammation in the rectal area"),
    CheckBoxSettings(title: "None"),
  ];
  List selectedSymptomsPart3 = [];

  @override
  Widget build(BuildContext context) {
    print("Video Player : ${widget.trackerVideoLink}");
    return SafeArea(
      child: Scaffold(
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
                      child: buildAppBar(() {}, isBackEnable: true),
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
                      Container(
                        height: 15.h,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22)),
                          color: kBottomSheetHeadYellow,
                        ),
                        child: Center(
                          child: Image.asset(
                            bsHeadStarsIcon,
                            alignment: Alignment.topRight,
                            fit: BoxFit.scaleDown,
                            width: 30.w,
                            height: 10.h,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            color: gBackgroundColor,
                            // borderRadius: BorderRadius.only(
                            //     topLeft: Radius.circular(22),
                            //     topRight: Radius.circular(22)),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 5.w),
                                child: videoMp4Widget(
                                    videoName:
                                        "Know more about Symptoms Tracker",
                                    onTap: () {
                                      addTrackerUrlToChewiePlayer(
                                          widget.trackerVideoLink ?? '');
                                      // addTrackerUrlToVideoPlayer(widget.trackerVideoLink ?? '');
                                      setState(() {
                                        showMealVideo = true;
                                      });
                                    }),
                              ),
                              SizedBox(height: 1.h),
                              Expanded(
                                  child: Stack(
                                children: [
                                  PageView.builder(
                                      padEnds: false,
                                      itemCount: ("1" == widget.phases)
                                          ? prepQuestions.length
                                          : ("3" == widget.phases ||
                                                  "2" == widget.phases)
                                              ? detoxAndHealingQuestions.length
                                              : nourishQuestions.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: _pageController,
                                      onPageChanged: (page) {
                                        setState(() {
                                          currentIndex = page;
                                          print("Current Page: $currentIndex");
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return ("1" == widget.phases)
                                            ? prepQuestions[index]
                                            : ("3" == widget.phases ||
                                                    "2" == widget.phases)
                                                ? detoxAndHealingQuestions[
                                                    index]
                                                : nourishQuestions[index];
                                      }),
                                  Visibility(
                                    visible: showMealVideo,
                                    child: Positioned(
                                        child: buildMealVideo(onTap: () async {
                                      setState(() {
                                        showMealVideo = false;
                                      });
                                      if (await WakelockPlus.enabled == true) {
                                        WakelockPlus.disable();
                                      }
                                      if (_sheetVideoController != null)
                                        _sheetVideoController!.dispose();
                                      if (_sheetChewieController != null)
                                        _sheetChewieController!.dispose();

                                      // await _mealPlayerController!.stopRendererScanning();
                                      // await _mealPlayerController!.dispose();
                                    })),
                                  )
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 5.h,
                    left: 5,
                    right: 5,
                    child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: gHintTextColor.withOpacity(0.8))
                          ],
                        ),
                        child: CircleAvatar(
                          maxRadius: 40.sp,
                          backgroundColor: kBottomSheetHeadCircleColor,
                          child: Image.asset(
                            bsHeadBellIcon,
                            fit: BoxFit.scaleDown,
                            width: 45,
                            height: 45,
                          ),
                        ))),
                Positioned(
                    top: 12.h,
                    right: 3.w,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if (widget.isPreviousDaySheet) {
                            Navigator.pop(context);
                          }
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: gsecondaryColor,
                          size: 28,
                        ))),
              ],
            );
          },
        ),
      ),
    );
  }

  late List<Widget> prepQuestions = [
    buildMainPage(
      01,
      "Did you follow your Meal plan?",
      buildQuestion2(),
      "Next",
      () {
        if (followYourMealPlan.isNotEmpty) {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        } else {
          AppConfig().showSnackbar(
              context, "Please Select Follow your Meal Plan",
              isError: true);
        }
      },
      "0.12",
    ),
    // buildMainPage(
    //   03,
    //   "If you missed anything in the Meal plan, Please let us know what it is?",
    //   buildQuestion3(),
    //   "Next",
    //   () {
    //     if (missedAnythingMealPlanController.text.isNotEmpty) {
    //       _pageController
    //           .nextPage(
    //               duration: const Duration(milliseconds: 300),
    //               curve: Curves.linear)
    //           .then((value) {});
    //     } else {
    //       AppConfig().showSnackbar(
    //           context, "Please Enter Missed Anything in the Meal Plan",
    //           isError: true);
    //     }
    //   },
    // ),
    buildMainPage(
      02,
      "Did you follow your yoga modules (move, calm and DRT)",
      buildQuestion4(),
      "Next",
      () {
        if (yogaModules.isNotEmpty) {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        } else {
          AppConfig().showSnackbar(context, "Please Select your Yoga modules",
              isError: true);
        }
      },
      "0.24",
    ),
    // buildMainPage(
    //   05,
    //   "If you missed anything in the yoga plan, Please let us know what it is?",
    //   buildQuestion5(),
    //   "Next",
    //   () {
    //     if (missedAnythingYogaPlanController.text.isNotEmpty) {
    //       _pageController
    //           .nextPage(
    //               duration: const Duration(milliseconds: 300),
    //               curve: Curves.linear)
    //           .then((value) {});
    //     } else {
    //       AppConfig().showSnackbar(
    //           context, "Please Enter Missed Anything in the Yoga Plan",
    //           isError: true);
    //     }
    //   },
    // ),
    buildMainPage(
      03,
      "How was your sleep?",
      buildQuestion6(),
      "Next",
      () {
        if (sleep.isNotEmpty) {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        } else {
          AppConfig()
              .showSnackbar(context, "Please Select Sleep", isError: true);
        }
      },
      "0.36",
    ),
    buildMainPage(
      04,
      "Stool formation",
      buildQuestion7(),
      "Next",
      () {
        if (stoolInfo.isNotEmpty) {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        } else {
          AppConfig().showSnackbar(context, "Please Select Stool formation",
              isError: true);
        }
      },
      "0.48",
      questionSub: true,
    ),
    buildMainPage(
      05,
      "Did you have any symptoms because of stopping tea/coffee/smoke/alcohol.",
      buildQuestion8(),
      "Next",
      () {
        if (symptomsStopping.isNotEmpty) {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        } else {
          AppConfig().showSnackbar(context, "Please Select Symptoms Stopping",
              isError: true);
        }
      },
      "0.60",
    ),
    buildMainPage(
      06,
      "Did you have any of the symptoms below",
      buildQuestion11(),
      "Next",
      () {
        if (dizziness.isEmpty) {
          AppConfig()
              .showSnackbar(context, "Please Select Dizziness", isError: true);
        } else if (vomiting.isEmpty) {
          AppConfig()
              .showSnackbar(context, "Please Select Vomiting", isError: true);
        } else if (looseMotion.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Loose Motion",
              isError: true);
        } else if (noEvacuation.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select No Evacuation",
              isError: true);
        } else if (headache.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Extreme Headache",
              isError: true);
        } else if (anxiety.isEmpty) {
          AppConfig().showSnackbar(
              context, "Please Select Anxiety/Panic attacks",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.72",
    ),
    buildMainPage(
      07,
      "Please do let us know if there are any additional concerns you may have besides the symptoms previously mentioned.",
      buildQuestion16(),
      "Next",
      () {
        _pageController
            .nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .then((value) {});
      },
      "0.80",
    ),
    buildMainPage(
      08,
      "Have you had a medical exam or taken any medications during the program?",
      buildQuestion1(),
      "Next",
      () {
        if (selectedAnyMedicines.isNotEmpty) {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        } else {
          AppConfig().showSnackbar(context,
              "Please medical exam or taken any medications during the program",
              isError: true);
        }
      },
      "0.90",
    ),
    buildQuestion15(09),
    // buildMainPage(
    //   10,
    //   "Tongue Picture -",
    //   buildQuestion15(),
    //   "Submit",
    //   () {
    //     if (mandatoryFileFormatList.isEmpty) {
    //       AppConfig().showSnackbar(context, "Please Upload Image",
    //           isError: true, bottomPadding: 100);
    //     } else {
    //       Map<String, String> m = {
    //         "phone": widget.phone,
    //         "phase": "1",
    //         "day": dayOfPhaseController.text.toString(),
    //         "follow_meal_plan": followYourMealPlan,
    //         "anything_missed_in_meal_plan":
    //             missedAnythingMealPlanController.text.toString(),
    //         "follow_yoga_modules": yogaModules,
    //         "missed_anything_in_yoga_plan":
    //             missedAnythingYogaPlanController.text.toString(),
    //         "sleep": sleep,
    //         "stool_formation": stoolInfo,
    //         "any_symptoms": symptomsStopping,
    //         "dazziness_symptoms": dizziness,
    //         "vomiting_symptoms": vomiting,
    //         "loose_motion_symptoms": looseMotion,
    //         "no_evacuation_symptoms": noEvacuation,
    //         "extreme_headache_symptoms": headache,
    //         "anxiety_symptoms": anxiety,
    //       };
    //       proceed(m);
    //     }
    //   },
    // ),
  ];

  late List<Widget> detoxAndHealingQuestions = [
    buildMainPage(
      01,
      "Did you follow your Meal plan?",
      buildQuestion2(),
      "Next",
      () {
        if (followYourMealPlan.isEmpty) {
          AppConfig().showSnackbar(
              context, "Please Select Follow your Meal Plan",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.08",
    ),
    // buildMainPage(
    //   03,
    //   "If you missed anything in the Meal plan, Please let us know what it is?",
    //   buildQuestion3(),
    //   "Next",
    //   () {
    //     if (missedAnythingMealPlanController.text.isEmpty) {
    //       AppConfig().showSnackbar(
    //           context, "Please Enter Missed Anything in the Meal Plan",
    //           isError: true);
    //     } else {
    //       _pageController
    //           .nextPage(
    //               duration: const Duration(milliseconds: 300),
    //               curve: Curves.linear)
    //           .then((value) {});
    //     }
    //   },
    // ),
    buildMainPage(
      02,
      "Did you follow your yoga modules (move, calm and DRT)",
      buildQuestion4(),
      "Next",
      () {
        if (yogaModules.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select your Yoga modules",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.16",
    ),
    // buildMainPage(
    //   05,
    //   "If you missed anything in the yoga plan, Please let us know what it is?",
    //   buildQuestion5(),
    //   "Next",
    //   () {
    //     if (missedAnythingYogaPlanController.text.isEmpty) {
    //       AppConfig().showSnackbar(
    //           context, "Please Enter Missed Anything in the Yoga Plan",
    //           isError: true);
    //     } else {
    //       _pageController
    //           .nextPage(
    //               duration: const Duration(milliseconds: 300),
    //               curve: Curves.linear)
    //           .then((value) {});
    //     }
    //   },
    // ),
    buildMainPage(
      03,
      "How was your sleep?",
      buildQuestion6(),
      "Next",
      () {
        if (sleep.isEmpty) {
          AppConfig()
              .showSnackbar(context, "Please Select Sleep", isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.24",
    ),
    buildMainPage(
      04,
      "Stool formation",
      buildQuestion7(),
      "Next",
      () {
        if (stoolInfo.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Stool formation",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.32",
      questionSub: true,
    ),
    buildMainPage(
      05,
      "How is your general health today?",
      buildQuestion9(),
      "Next",
      () {
        if (generalHealth.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select General Health",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.40",
    ),
    buildMainPage(
      06,
      "How Does this compare to yesterday",
      buildQuestion10(),
      "Next",
      () {
        if (compareToYesterday.isEmpty) {
          AppConfig().showSnackbar(
              context, "Please Select Compare to Yesterday",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.48",
    ),
    buildMainPage(
      07,
      "PART 1: SYMPTOMS",
      buildQuestion11(),
      "Next",
      () {
        if (dizziness.isEmpty) {
          AppConfig()
              .showSnackbar(context, "Please Select Dizziness", isError: true);
        } else if (vomiting.isEmpty) {
          AppConfig()
              .showSnackbar(context, "Please Select Vomiting", isError: true);
        } else if (looseMotion.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Loose Motion",
              isError: true);
        } else if (noEvacuation.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select No Evacuation",
              isError: true);
        } else if (headache.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Extreme Headache",
              isError: true);
        } else if (anxiety.isEmpty) {
          AppConfig().showSnackbar(
              context, "Please Select Anxiety/Panic attacks",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.56",
    ),
    buildMainPage(
      08,
      "PART 2: SYMPTOMS",
      buildQuestion12(),
      "Next",
      () {
        if (selectedSymptomsPart2.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Symptoms Part 2",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.64",
    ),
    buildMainPage(
      09,
      "PART 3: SYMPTOMS",
      buildQuestion13(),
      "Next",
      () {
        if (selectedSymptomsPart3.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Symptoms Part 3",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.72",
    ),
    buildMainPage(
      10,
      widget.phases == "2" ? "Detox Signs" : "Healing Signs",
      buildQuestion14(),
      "Next",
      () {
        if (selectedNourishSigns.isEmpty) {
          AppConfig().showSnackbar(
              context,
              widget.phases == "2"
                  ? "Please Select Detox Signs"
                  : "Please Select Healing Signs",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.80",
    ),
    buildMainPage(
      11,
      "Please do let us know if there are any additional concerns you may have besides the symptoms previously mentioned.",
      buildQuestion16(),
      "Next",
      () {
        _pageController
            .nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .then((value) {});
      },
      "0.88",
    ),
    buildMainPage(
      12,
      "Have you had a medical exam or taken any medications during the program?",
      buildQuestion1(),
      "Next",
      () {
        if (selectedAnyMedicines.isNotEmpty) {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        } else {
          AppConfig().showSnackbar(context,
              "Please medical exam or taken any medications during the program",
              isError: true);
        }
      },
      "0.94",
    ),
    buildQuestion15(13),
    // buildMainPage(
    //   14,
    //   "Tongue Picture -",
    //   buildQuestion15(),
    //   "Submit",
    //   () {
    //     if (mandatoryFileFormatList.isEmpty) {
    //       AppConfig().showSnackbar(context, "Please Upload Image",
    //           isError: true, bottomPadding: 100);
    //     } else {
    //       Map<String, String> m = {
    //         "phone": widget.phone,
    //         "phase": widget.phases == "Detox Phase" ? "2" : "3",
    //         "day": dayOfPhaseController.text.toString(),
    //         "follow_meal_plan": followYourMealPlan,
    //         "anything_missed_in_meal_plan":
    //             missedAnythingMealPlanController.text.toString(),
    //         "follow_yoga_modules": yogaModules,
    //         "missed_anything_in_yoga_plan":
    //             missedAnythingYogaPlanController.text.toString(),
    //         "sleep": sleep,
    //         "stool_formation": stoolInfo,
    //         "general_health": generalHealth,
    //         "compare_yesterday": compareToYesterday,
    //         "dazziness_symptoms": dizziness,
    //         "vomiting_symptoms": vomiting,
    //         "loose_motion_symptoms": looseMotion,
    //         "no_evacuation_symptoms": noEvacuation,
    //         "extreme_headache_symptoms": headache,
    //         "anxiety_symptoms": anxiety,
    //         "part2_symptoms[]": selectedSymptomsPart2.join(","),
    //         "part3_symptoms[]": selectedSymptomsPart3.join(","),
    //         "healing_signs[]": selectedNourishSigns.join(","),
    //       };
    //       proceed(m);
    //     }
    //   },
    // ),
  ];

  late List<Widget> nourishQuestions = [
    buildMainPage(
      01,
      "Did you follow your Meal plan?",
      buildQuestion2(),
      "Next",
      () {
        if (followYourMealPlan.isEmpty) {
          AppConfig().showSnackbar(
              context, "Please Select Follow your Meal Plan",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.09",
    ),
    // buildMainPage(
    //   03,
    //   "If you missed anything in the Meal plan, Please let us know what it is?",
    //   buildQuestion3(),
    //   "Next",
    //   () {
    //     if (missedAnythingMealPlanController.text.isEmpty) {
    //       AppConfig().showSnackbar(
    //           context, "Please Enter Missed Anything in the Meal Plan",
    //           isError: true);
    //     } else {
    //       _pageController
    //           .nextPage(
    //               duration: const Duration(milliseconds: 300),
    //               curve: Curves.linear)
    //           .then((value) {});
    //     }
    //   },
    // ),
    buildMainPage(
      02,
      "Did you follow your yoga modules (move, calm and DRT)",
      buildQuestion4(),
      "Next",
      () {
        if (yogaModules.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select your Yoga modules",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.18",
    ),
    // buildMainPage(
    //   05,
    //   "If you missed anything in the yoga plan, Please let us know what it is?",
    //   buildQuestion5(),
    //   "Next",
    //   () {
    //     if (missedAnythingYogaPlanController.text.isEmpty) {
    //       AppConfig().showSnackbar(
    //           context, "Please Enter Missed Anything in the Yoga Plan",
    //           isError: true);
    //     } else {
    //       _pageController
    //           .nextPage(
    //               duration: const Duration(milliseconds: 300),
    //               curve: Curves.linear)
    //           .then((value) {});
    //     }
    //   },
    // ),
    buildMainPage(
      03,
      "How was your sleep?",
      buildQuestion6(),
      "Next",
      () {
        if (sleep.isEmpty) {
          AppConfig()
              .showSnackbar(context, "Please Select Sleep", isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.27",
    ),
    buildMainPage(
      04,
      "Stool formation",
      buildQuestion7(),
      "Next",
      () {
        if (stoolInfo.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Stool formation",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.36",
      questionSub: true,
    ),
    buildMainPage(
      05,
      "How is your general health today?",
      buildQuestion9(),
      "Next",
      () {
        if (generalHealth.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select General Health",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.45",
    ),
    buildMainPage(
      06,
      "How Does this compare to yesterday",
      buildQuestion10(),
      "Next",
      () {
        if (compareToYesterday.isEmpty) {
          AppConfig().showSnackbar(
              context, "Please Select Compare to Yesterday",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.54",
    ),
    buildMainPage(
      07,
      "Did you have any of the symptoms below",
      buildQuestion11(),
      "Next",
      () {
        if (dizziness.isEmpty) {
          AppConfig()
              .showSnackbar(context, "Please Select Dizziness", isError: true);
        } else if (vomiting.isEmpty) {
          AppConfig()
              .showSnackbar(context, "Please Select Vomiting", isError: true);
        } else if (looseMotion.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Loose Motion",
              isError: true);
        } else if (noEvacuation.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select No Evacuation",
              isError: true);
        } else if (headache.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Extreme Headache",
              isError: true);
        } else if (anxiety.isEmpty) {
          AppConfig().showSnackbar(
              context, "Please Select Anxiety/Panic attacks",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.63",
    ),
    buildMainPage(
      08,
      "Nourish Signs",
      buildQuestion14(),
      "Next",
      () {
        if (selectedNourishSigns.isEmpty) {
          AppConfig().showSnackbar(context, "Please Select Nourish Signs",
              isError: true);
        } else {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        }
      },
      "0.72",
    ),
    buildMainPage(
      09,
      "Please do let us know if there are any additional concerns you may have besides the symptoms previously mentioned.",
      buildQuestion16(),
      "Next",
      () {
        _pageController
            .nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .then((value) {});
      },
      "0.81",
    ),
    buildMainPage(
      10,
      "Have you had a medical exam or taken any medications during the program?",
      buildQuestion1(),
      "Next",
      () {
        if (selectedAnyMedicines.isNotEmpty) {
          _pageController
              .nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear)
              .then((value) {});
        } else {
          AppConfig().showSnackbar(context,
              "Please medical exam or taken any medications during the program",
              isError: true);
        }
      },
      "0.90",
    ),
    buildQuestion15(11),
    // buildMainPage(
    //   12,
    //   "Tongue Picture -",
    //   buildQuestion15(),
    //   "Submit",
    //   () {
    //     if (mandatoryFileFormatList.isEmpty) {
    //       AppConfig().showSnackbar(context, "Please Upload Image",
    //           isError: true, bottomPadding: 100);
    //     } else {
    //       Map<String, String> m = {
    //         "phone": widget.phone,
    //         "phase": "4",
    //         "day": dayOfPhaseController.text.toString(),
    //         "follow_meal_plan": followYourMealPlan,
    //         "anything_missed_in_meal_plan":
    //             missedAnythingMealPlanController.text.toString(),
    //         "follow_yoga_modules": yogaModules,
    //         "missed_anything_in_yoga_plan":
    //             missedAnythingYogaPlanController.text.toString(),
    //         "sleep": sleep,
    //         "stool_formation": stoolInfo,
    //         "general_health": generalHealth,
    //         "compare_yesterday": compareToYesterday,
    //         "dazziness_symptoms": dizziness,
    //         "vomiting_symptoms": vomiting,
    //         "loose_motion_symptoms": looseMotion,
    //         "no_evacuation_symptoms": noEvacuation,
    //         "extreme_headache_symptoms": headache,
    //         "anxiety_symptoms": anxiety,
    //         "nourish_signs[]": selectedNourishSigns.join(",")
    //       };
    //       proceed(m);
    //     }
    //   },
    // ),
  ];

  buildMainPage(int index, String question, Widget child, String btnTitle,
      VoidCallback func, String percentage,
      {bool questionSub = false}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QuestionWidget(
            question: question,
            questionNo: "$index",
            questionSub: questionSub,
            percentage: percentage,
          ),
          IntrinsicWidth(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: child,
            ),
          ),
          ButtonWidget(
            title: btnTitle,
            func: func,
          ),
        ],
      ),
    );
  }

  Widget buildQuestion1() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        children: [
          ...yogaList.map(
            (e) => GestureDetector(
              onTap: () {
                setstate(() {
                  selectedAnyMedicines = e as String;
                  print("Radio Button : $selectedAnyMedicines");
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 12.w),
                height: 7.h,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 3,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e,
                        style: TextStyle(
                            fontFamily: kFontBook,
                            color: gBlackColor,
                            height: 1.5,
                            fontSize: smTextFontSize),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: selectedAnyMedicines,
                      onChanged: (value) {
                        setstate(() {
                          selectedAnyMedicines = value as String;
                          print("Radio Button : $selectedAnyMedicines");
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          selectedAnyMedicines == "Yes"
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                  ),
                  child: Column(
                    children: [
                      buildLabelTextField(
                          "If you had a medical exam or taken any medications during the program, Please let us know what it is?",
                          fontSize: questionFont),
                      buildTextFormField(anyMedicinesController,
                          "'Please Enter any medications';")
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      );
    });
  }

  Widget buildQuestion2() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        children: [
          ...mealPlanList.map(
            (e) => GestureDetector(
              onTap: () {
                setstate(() {
                  followYourMealPlan = e as String;

                  print("Radio Button : $followYourMealPlan");
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
                height: 7.h,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 3,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e,
                        style: TextStyle(
                            fontFamily: kFontBook,
                            color: gBlackColor,
                            height: 1.5,
                            fontSize: smTextFontSize),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: followYourMealPlan,
                      onChanged: (value) {
                        setstate(() {
                          followYourMealPlan = value as String;

                          print("Radio Button : $followYourMealPlan");
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          followYourMealPlan == "No I missed to follow"
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                  ),
                  child: Column(
                    children: [
                      buildLabelTextField(
                          "If you missed anything in the Meal plan, Please let us know what it is?",
                          fontSize: questionFont),
                      buildTextFormField(missedAnythingMealPlanController,
                          "'Please Enter Meal Plan';")
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      );
    });
  }

  // Widget buildQuestion3() {
  //   return buildTextFormField(
  //       missedAnythingMealPlanController, "'Please Enter Meal Plan';");
  // }

  Widget buildQuestion4() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        children: [
          ...yogaList.map(
            (e) => GestureDetector(
              onTap: () {
                setstate(() {
                  yogaModules = e as String;

                  print("Radio Button : $yogaModules");
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
                height: 7.h,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 3,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                    SizedBox(width: 5.w),
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: yogaModules,
                      onChanged: (value) {
                        setstate(() {
                          yogaModules = value as String;

                          print("Radio Button : $yogaModules");
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          yogaModules == "No"
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                  ),
                  child: Column(
                    children: [
                      buildLabelTextField(
                          "If you missed anything in the yoga plan, Please let us know what it is?",
                          fontSize: questionFont),
                      buildTextFormField(missedAnythingYogaPlanController,
                          "'Please Enter Yoga Plan';")
                    ],
                  ),
                )
              : const SizedBox(),
          // yogaModules == "No"
          //     ? buildTextFormField(missedAnythingYogaPlanController,
          //         "'Please Enter Yoga Plan';")
          //     : const SizedBox(),
        ],
      );
    });
  }

  // Widget buildQuestion5() {
  //   return buildTextFormField(
  //       missedAnythingYogaPlanController, "'Please Enter Yoga Plan';");
  // }

  Widget buildQuestion6() {
    return StatefulBuilder(builder: (_, setstate) {
      return Center(
        child: Column(
          children: [
            ...sleepList.map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: GestureDetector(
                  onTap: () {
                    setstate(() {
                      sleep = e;

                      print("Radio Button : $sleep");
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: e,
                        activeColor: gsecondaryColor,
                        groupValue: sleep,
                        onChanged: (value) {
                          setstate(() {
                            sleep = value as String;

                            print("Radio Button : $sleep");
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          e,
                          style: TextStyle(
                              fontFamily: kFontBook,
                              color: gBlackColor,
                              height: 1.5,
                              fontSize: smTextFontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildQuestion7() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        children: [
          SizedBox(height: 1.h),
          Image(
            image: const AssetImage("assets/images/stool_image.png"),
            fit: BoxFit.fill,
            height: 35.h,
          ),
          SizedBox(height: 1.h),
          // buildRadioButtons(stoolInfoList, stoolInfo),
          ...stoolInfoList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    stoolInfo = e;
                    print("Radio Button : $stoolInfo");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: stoolInfo,
                      onChanged: (value) {
                        setstate(() {
                          stoolInfo = value as String;
                          print("Radio Button : $stoolInfo");
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        e,
                        style: TextStyle(
                            fontFamily: kFontBook,
                            color: gBlackColor,
                            height: 1.5,
                            fontSize: smTextFontSize),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildQuestion8() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        children: [
          ...symptomsList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    symptomsStopping = e;

                    print("Radio Button : $symptomsStopping");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: symptomsStopping,
                      onChanged: (value) {
                        setstate(() {
                          symptomsStopping = value as String;

                          print("Radio Button : $symptomsStopping");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildQuestion9() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        children: [
          ...generalHealthList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    generalHealth = e;

                    print("Radio Button : $generalHealth");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: generalHealth,
                      onChanged: (value) {
                        setstate(() {
                          generalHealth = value as String;

                          print("Radio Button : $generalHealth");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildQuestion10() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        children: [
          ...compareToYesterdayList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    compareToYesterday = e;

                    print("Radio Button : $compareToYesterday");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: compareToYesterday,
                      onChanged: (value) {
                        setstate(() {
                          compareToYesterday = value as String;

                          print("Radio Button : $compareToYesterday");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildQuestion11() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          buildLabelTextField("Dizziness", fontSize: questionFont),
          // buildRadioButtons(symptomsBelowList, dizziness),
          ...symptomsBelowList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    dizziness = e;

                    print("Radio Button : $dizziness");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: dizziness,
                      onChanged: (value) {
                        setstate(() {
                          dizziness = value as String;

                          print("Radio Button : $dizziness");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          buildLabelTextField("Vomiting", fontSize: questionFont),
          // buildRadioButtons(symptomsBelowList, vomiting),
          ...vomitingLooseMotionList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    vomiting = e;

                    print("Radio Button : $vomiting");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: vomiting,
                      onChanged: (value) {
                        setstate(() {
                          vomiting = value as String;

                          print("Radio Button : $vomiting");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildLabelTextField("Loose Motion", fontSize: questionFont),
          // buildRadioButtons(symptomsBelowList, looseMotion),
          ...vomitingLooseMotionList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    looseMotion = e;

                    print("Radio Button : $looseMotion");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: looseMotion,
                      onChanged: (value) {
                        setstate(() {
                          looseMotion = value as String;

                          print("Radio Button : $looseMotion");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          buildLabelTextField("No Evacuation", fontSize: questionFont),
          // buildRadioButtons(symptomsBelowList, noEvacuation),
          ...noEvacuationList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    noEvacuation = e;

                    print("Radio Button : $noEvacuation");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: noEvacuation,
                      onChanged: (value) {
                        setstate(() {
                          noEvacuation = value as String;

                          print("Radio Button : $noEvacuation");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildLabelTextField("Headache", fontSize: questionFont),
          // buildRadioButtons(symptomsBelowList, headache),
          ...symptomsBelowList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    headache = e;

                    print("Radio Button : $headache");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: headache,
                      onChanged: (value) {
                        setstate(() {
                          headache = value as String;

                          print("Radio Button : $headache");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          buildLabelTextField("Anxiety/Panic Attacks", fontSize: questionFont),
          // buildRadioButtons(symptomsBelowList, anxiety),
          ...symptomsBelowList.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: GestureDetector(
                onTap: () {
                  setstate(() {
                    anxiety = e;

                    print("Radio Button : $anxiety");
                  });
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: e,
                      activeColor: gsecondaryColor,
                      groupValue: anxiety,
                      onChanged: (value) {
                        setstate(() {
                          anxiety = value as String;

                          print("Radio Button : $anxiety");
                        });
                      },
                    ),
                    Text(
                      e,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: gBlackColor,
                          height: 1.5,
                          fontSize: smTextFontSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildQuestion12() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...symptomsPart2CheckBox
              .map((e) => buildHealthCheckBox(e, "2", setstate))
              .toList(),
        ],
      );
    });
  }

  Widget buildQuestion13() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...symptomsPart3CheckBox
              .map((e) => buildHealthCheckBox(e, "3", setstate))
              .toList(),
        ],
      );
    });
  }

  Widget buildQuestion14() {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...nourishSignsCheckBox
              .map((e) => buildHealthCheckBox(e, "1", setstate))
              .toList(),
        ],
      );
    });
  }

  Widget buildQuestion16() {
    return SizedBox(
      width: double.maxFinite,
      child: buildTextFormField(
          additionalConcernsController, "Please Enter any additional concerns"),
    );
  }

  Widget buildQuestion15(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          QuestionWidget(
            question: "Tongue Picture -",
            questionNo: "$index",
            percentage: "1.0",
          ),
          SizedBox(height: 2.h),
          Visibility(
            visible: mandatoryFileFormatList.isEmpty,
            child: GestureDetector(
              onTap: () async {
                // pickFromFile(setState, isMandatory: true);
                showChooserSheet(setstate, isMandatory: true);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: gHintTextColor.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      color: gsecondaryColor,
                      size: 2.5.h,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Add File',
                      style: TextStyle(
                        fontSize: 10.dp,
                        color: gsecondaryColor,
                        fontFamily: "GothamMedium",
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          ...mandatoryFileFormatList.map((e) {
            return IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
                height: 7.h,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 3,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.path.split("/").last,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: kFontBold,
                          fontSize: 11.dp,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: () {
                        print("delete");

                        setstate(() {
                          mandatoryFileFormatList.removeAt(0);
                        });
                      },
                      child: const Icon(
                        Icons.delete_outline_outlined,
                        color: gMainColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
            // buildMandatoryFileList(e, index, setstate,
            //   isMandatory: true);
          }),
          // (mandatoryFileFormatList.isEmpty)
          //     ? const SizedBox()
          //     : ListView.builder(
          //         itemCount: mandatoryFileFormatList.length,
          //         shrinkWrap: true,
          //         scrollDirection: Axis.vertical,
          //         physics: const ScrollPhysics(),
          //         itemBuilder: (context, index) {
          //           final file = mandatoryFileFormatList[index];
          //           return buildMandatoryFileList(file, index, setstate,
          //               isMandatory: true);
          //         },
          //       ),
          SizedBox(height: 6.h),
          Align(
            alignment: Alignment.bottomCenter,
            child: IntrinsicWidth(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gsecondaryColor,
                  // onSurface: eUser().buttonTextColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: showProgress
                    ? null
                    : () {
                        if (mandatoryListRecords.isEmpty) {
                          AppConfig().showSnackbar(
                              context, "Please Choose File",
                              isError: true);
                        } else {
                          if (widget.phases == "1") {
                            Map<String, String> m = {
                              // "phase": "1",
                              // "day": widget.day,
                              "any_medications": selectedAnyMedicines,
                              "medication_used":
                                  anyMedicinesController.text.toString(),
                              "follow_meal_plan": followYourMealPlan,
                              "anything_missed_in_meal_plan":
                                  missedAnythingMealPlanController.text
                                      .toString(),
                              "follow_yoga_modules": yogaModules,
                              "missed_anything_in_yoga_plan":
                                  missedAnythingYogaPlanController.text
                                      .toString(),
                              "sleep": sleep,
                              "stool_formation": stoolInfo,
                              "any_symptoms": symptomsStopping,
                              "dazziness_symptoms": dizziness,
                              "vomiting_symptoms": vomiting,
                              "loose_motion_symptoms": looseMotion,
                              "no_evacuation_symptoms": noEvacuation,
                              "extreme_headache_symptoms": headache,
                              "anxiety_symptoms": anxiety,
                              "previous_symptoms":
                                  additionalConcernsController.text.toString(),
                            };
                            print("Map : $m");
                            proceed(m, setstate);
                          } else if (widget.phases == "4") {
                            Map<String, String> m = {
                              // "phone": widget.phone,
                              // "phase": "4",
                              // "day": widget.day,
                              "any_medications": selectedAnyMedicines,
                              "medication_used":
                                  anyMedicinesController.text.toString(),
                              "follow_meal_plan": followYourMealPlan,
                              "anything_missed_in_meal_plan":
                                  missedAnythingMealPlanController.text
                                      .toString(),
                              "follow_yoga_modules": yogaModules,
                              "missed_anything_in_yoga_plan":
                                  missedAnythingYogaPlanController.text
                                      .toString(),
                              "sleep": sleep,
                              "stool_formation": stoolInfo,
                              "general_health": generalHealth,
                              "compare_yesterday": compareToYesterday,
                              "dazziness_symptoms": dizziness,
                              "vomiting_symptoms": vomiting,
                              "loose_motion_symptoms": looseMotion,
                              "no_evacuation_symptoms": noEvacuation,
                              "extreme_headache_symptoms": headache,
                              "anxiety_symptoms": anxiety,
                              "nourish_signs[]": selectedNourishSigns.join(","),
                              "previous_symptoms":
                                  additionalConcernsController.text.toString(),
                            };
                            print("Map : $m");
                            proceed(m, setstate);
                          } else {
                            Map<String, String> m = {
                              // "phone": widget.phone,
                              // "phase": widget.phases == "2" ? "2" : "3",
                              // "day": widget.day,
                              "any_medications": selectedAnyMedicines,
                              "medication_used":
                                  anyMedicinesController.text.toString(),
                              "follow_meal_plan": followYourMealPlan,
                              "anything_missed_in_meal_plan":
                                  missedAnythingMealPlanController.text
                                      .toString(),
                              "follow_yoga_modules": yogaModules,
                              "missed_anything_in_yoga_plan":
                                  missedAnythingYogaPlanController.text
                                      .toString(),
                              "sleep": sleep,
                              "stool_formation": stoolInfo,
                              "general_health": generalHealth,
                              "compare_yesterday": compareToYesterday,
                              "dazziness_symptoms": dizziness,
                              "vomiting_symptoms": vomiting,
                              "loose_motion_symptoms": looseMotion,
                              "no_evacuation_symptoms": noEvacuation,
                              "extreme_headache_symptoms": headache,
                              "anxiety_symptoms": anxiety,
                              "part2_symptoms[]":
                                  selectedSymptomsPart2.join(","),
                              "part3_symptoms[]":
                                  selectedSymptomsPart3.join(","),
                              "healing_signs[]": selectedNourishSigns.join(","),
                              "previous_symptoms":
                                  additionalConcernsController.text.toString(),
                            };
                            print("Map : $m");
                            proceed(m, setstate);
                          }
                        }
                      },
                child: Center(
                  child: showProgress
                      ? buildThreeBounceIndicator(color: gWhiteColor)
                      : Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 13.dp,
                            color: gWhiteColor,
                            fontFamily: kFontMedium,
                          ),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      );
    });
  }

  buildTextFormField(TextEditingController controller, String validText,
      {bool isNum = false}) {
    return Container(
      height: 10.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      margin: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.h, bottom: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 3,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: gsecondaryColor,
        maxLength: isNum ? 2 : null,
        validator: (value) {
          if (value!.isEmpty) {
            return validText;
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: "Your Answer",
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontFamily: kFontBook,
            color: gGreyColor,
            fontSize: 12.dp,
          ),
          counterText: "",
        ),
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.start,
        inputFormatters:
            isNum ? [FilteringTextInputFormatter.digitsOnly] : null,
        keyboardType: isNum ? TextInputType.number : TextInputType.name,
      ),
    );
  }

  buildHealthCheckBox(
      CheckBoxSettings healthCheckBox, String from, Function setstate) {
    return CheckboxListTile(
      visualDensity: const VisualDensity(vertical: -3),
      // to compact
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      controlAffinity: ListTileControlAffinity.leading,
      title: Transform.translate(
        offset: const Offset(-10, 0),
        child: Text(
          healthCheckBox.title.toString(),
          style: buildTextStyle(
              color:
                  healthCheckBox.value == true ? gBlackColor : gHintTextColor,
              fontFamily:
                  healthCheckBox.value == true ? kFontMedium : kFontBook),
        ),
      ),
      dense: true,
      activeColor: gsecondaryColor,
      value: healthCheckBox.value,
      onChanged: (v) {
        print(v);
        if (from == '1') {
          if (healthCheckBox.title == nourishSignsCheckBox.last.title) {
            print("if");
            setstate(() {
              selectedNourishSigns.clear();
              for (var element in nourishSignsCheckBox) {
                element.value = false;
              }
              if (v == true) {
                selectedNourishSigns.add(healthCheckBox.title!);
              }
              healthCheckBox.value = v;
            });
          } else {
            print("else");
            if (selectedNourishSigns
                .contains(nourishSignsCheckBox.last.title)) {
              print("if");
              setstate(() {
                selectedNourishSigns.clear();
                nourishSignsCheckBox.last.value = false;
              });
            }
            if (v == true) {
              setstate(() {
                selectedNourishSigns.add(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            } else {
              setstate(() {
                selectedNourishSigns.remove(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            }
          }
          print(selectedNourishSigns);
        } else if (from == '2') {
          if (healthCheckBox.title == symptomsPart2CheckBox.last.title) {
            print("if");
            setstate(() {
              selectedSymptomsPart2.clear();
              for (var element in symptomsPart2CheckBox) {
                element.value = false;
                // if(element.title != symptomsCheckBox2.last.title){
                // }
              }
              if (v == true) {
                selectedSymptomsPart2.add(healthCheckBox.title);
                healthCheckBox.value = v;
              } else {
                selectedSymptomsPart2.remove(healthCheckBox.title!);
                healthCheckBox.value = v;
              }
            });
          } else {
            // print("else");
            if (v == true) {
              // print("if");
              setstate(() {
                if (selectedSymptomsPart2
                    .contains(symptomsPart2CheckBox.last.title)) {
                  // print("if");
                  selectedSymptomsPart2.removeWhere(
                      (element) => element == symptomsPart2CheckBox.last.title);
                  for (var element in symptomsPart2CheckBox) {
                    element.value = false;
                  }
                }
                selectedSymptomsPart2.add(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            } else {
              setstate(() {
                selectedSymptomsPart2.remove(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            }
          }
          print(selectedSymptomsPart2);
        } else if (from == '3') {
          if (healthCheckBox.title == symptomsPart3CheckBox.last.title) {
            print("if");
            setstate(() {
              selectedSymptomsPart3.clear();
              for (var element in symptomsPart3CheckBox) {
                element.value = false;
                // if(element.title != symptomsCheckBox2.last.title){
                // }
              }
              if (v == true) {
                selectedSymptomsPart3.add(healthCheckBox.title);
                healthCheckBox.value = v;
              } else {
                selectedSymptomsPart3.remove(healthCheckBox.title!);
                healthCheckBox.value = v;
              }
            });
          } else {
            // print("else");
            if (v == true) {
              // print("if");
              setstate(() {
                if (selectedSymptomsPart3
                    .contains(symptomsPart3CheckBox.last.title)) {
                  // print("if");
                  selectedSymptomsPart3.removeWhere(
                      (element) => element == symptomsPart3CheckBox.last.title);
                  for (var element in symptomsPart3CheckBox) {
                    element.value = false;
                  }
                }
                selectedSymptomsPart3.add(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            } else {
              setstate(() {
                selectedSymptomsPart3.remove(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            }
          }
          print(selectedSymptomsPart3);
        }
      },
    );
  }

  buildMandatoryFileList(File filename, index, Function setstate,
      {bool isMandatory = false}) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
        height: 7.h,
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 3,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isMandatory
                    ? "${filename.path.split("/").last}.jpg"
                    : filename.path.split("/").last,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: kFontBold,
                  fontSize: 11.dp,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                mandatoryFileFormatList.clear();
                mandatoryFileFormatList.removeAt(index);
                setstate(() {});
              },
              child: const Icon(
                Icons.delete_outline_outlined,
                color: gMainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  showChooserSheet(Function setstate, {bool isMandatory = false}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      child: Text('Choose File Source'),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: gHintTextColor,
                          width: 3.0,
                        ),
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              getImageFromCamera(setstate,
                                  isMandatory: isMandatory);
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_enhance_outlined,
                                  color: gMainColor,
                                ),
                                Text('Camera'),
                              ],
                            )),
                        Container(
                          width: 5,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border(
                            right: BorderSide(
                              color: gHintTextColor,
                              width: 1,
                            ),
                          )),
                        ),
                        TextButton(
                            onPressed: () {
                              pickFromFile(setstate, isMandatory: isMandatory);
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  color: gMainColor,
                                ),
                                Text('File'),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  List<PlatformFile>? _paths;
  PlatformFile? objFile;

  void pickFromFile(Function setstate, {bool isMandatory = false}) async {
    _paths = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    ))
        ?.files;

    var path2 = _paths?.single.bytes;

    var path3 = _paths?.single.name;

    File file = File(path3 ?? "");
    setstate(() {
      objFile = _paths?.single;
      mandatoryListRecords.add(objFile!);
      mandatoryFileFormatList.add(file);
    });

    // isMandatory ?
    // addFilesToMandatoryList(File(result.paths.first!), setstate) :
    // addFilesToList(File(result.paths.first!), setstate);

    setState(() {});
  }

  File? _image;

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  Uint8List? bytes;

  String path = '';

  Future getImageFromCamera(Function setstate,
      {bool isMandatory = false}) async {
    var image = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.camera);

    _image = File(image!.path);

    bytes = await image.readAsBytes();

    path = image.path ?? "";

    addFilesToMandatoryList(_image!, setstate);

    // setstate(() {
    //   _image = File(image!.path);
    //   if (getFileSize(_image!) <= 12) {
    //     print("filesize: ${getFileSize(_image!)}Mb");
    //     isMandatory ? addFilesToMandatoryList(_image!, setstate) :  addFilesToList(_image!, setstate);
    //
    //   } else {
    //     print("filesize: ${getFileSize(_image!)}Mb");
    //
    //     AppConfig()
    //         .showSnackbar(context, "File size must be <12Mb", isError: true);
    //   }
    // });
    print("captured image: $_image ${_image!.path}");
  }

  addFilesToMandatoryList(File file, Function setstate) async {
    print("file: $file");
    setstate(() {
      mandatoryFileFormatList.add(file);
    });

    print("path : ${file.path}");
    //
    // Uint8List bytes = await mandatoryFileFormatList[0].readAsBytes();
    //
    print("bytes : $bytes");
    print("bytes : $path");

    mandatoryListRecords.add(
      PlatformFile(name: "$path.jpg", size: 0, bytes: bytes),
    );

    // for (int i = 0; i < mandatoryFileFormatList.length; i++) {
    //   var stream = http.ByteStream(
    //       DelegatingStream.typed(mandatoryFileFormatList[i].openRead()));
    //   var length = await mandatoryFileFormatList[i].length();
    //   var multipartFile = http.MultipartFile("tongue_image", stream, length,
    //       filename: mandatoryFileFormatList[i].path);
    //   mandatoryList.add(multipartFile);
    //   print("mandatoryList : $mandatoryList");
    // }

    setstate(() {});
  }

  void proceed(Map m, setstate) async {
    setstate(() {
      showProgress = true;
    });

    SubmitMealPlanTrackerModel? model;
    print("day => ${widget.proceedProgramDayModel!.day}");

    model = ("1" == widget.phases)
        ? SubmitMealPlanTrackerModel(
            day: widget.proceedProgramDayModel!.day,
            // userProgramStatusTracking: '1',
            phase: widget.phases,
            anyMedications: selectedAnyMedicines,
            medicationUsed: anyMedicinesController.text.toString(),
            followMealPlan: followYourMealPlan,
            anythingMissedInMealPlan:
                missedAnythingMealPlanController.text.toString(),
            followYogaModules: yogaModules,
            missedAnythingInYogaPlan:
                missedAnythingYogaPlanController.text.toString(),
            sleep: sleep,
            stoolFormation: stoolInfo,
            anySymptoms: symptomsStopping,
            dazzinessSymptoms: dizziness,
            vomitingSymptoms: vomiting,
            looseMotionSymptoms: looseMotion,
            noEvacuationSymptoms: noEvacuation,
            extremeHeadacheSymptoms: headache,
            anxietySymptoms: anxiety,
            previousSymptoms: additionalConcernsController.text.toString(),
          )
        : ("2" == widget.phases || "3" == widget.phases)
            ? SubmitMealPlanTrackerModel(
                patientMealTracking:
                    widget.proceedProgramDayModel!.patientMealTracking,
                comment: widget.proceedProgramDayModel!.comment,
                // userProgramStatusTracking: '1',
                day: widget.proceedProgramDayModel!.day,
                phase: widget.phases == "2" ? "2" : "3",
                anyMedications: selectedAnyMedicines,
                medicationUsed: anyMedicinesController.text.toString(),
                followMealPlan: followYourMealPlan,
                anythingMissedInMealPlan:
                    missedAnythingMealPlanController.text.toString(),
                followYogaModules: yogaModules,
                missedAnythingInYogaPlan:
                    missedAnythingYogaPlanController.text.toString(),
                sleep: sleep,
                stoolFormation: stoolInfo,
                generalHealth: generalHealth,
                compareToYesterday: compareToYesterday,
                dazzinessSymptoms: dizziness,
                vomitingSymptoms: vomiting,
                looseMotionSymptoms: looseMotion,
                noEvacuationSymptoms: noEvacuation,
                extremeHeadacheSymptoms: headache,
                anxietySymptoms: anxiety,
                part2Symptoms: selectedSymptomsPart2.join(","),
                part3Symptoms: selectedSymptomsPart3.join(","),
                healingSigns: selectedNourishSigns.join(","),
                previousSymptoms: additionalConcernsController.text.toString(),
              )
            : SubmitMealPlanTrackerModel(
                day: widget.proceedProgramDayModel!.day,
                // userProgramStatusTracking: '1',
                phase: "4",
                anyMedications: selectedAnyMedicines,
                medicationUsed: anyMedicinesController.text.toString(),
                followMealPlan: followYourMealPlan,
                anythingMissedInMealPlan:
                    missedAnythingMealPlanController.text.toString(),
                followYogaModules: yogaModules,
                missedAnythingInYogaPlan:
                    missedAnythingYogaPlanController.text.toString(),
                sleep: sleep,
                stoolFormation: stoolInfo,
                generalHealth: generalHealth,
                compareToYesterday: compareToYesterday,
                dazzinessSymptoms: dizziness,
                vomitingSymptoms: vomiting,
                looseMotionSymptoms: looseMotion,
                noEvacuationSymptoms: noEvacuation,
                extremeHeadacheSymptoms: headache,
                anxietySymptoms: anxiety,
                nourishSigns: selectedNourishSigns.join(","),
                previousSymptoms: additionalConcernsController.text.toString(),
              );

    final result = await ProgramService(repository: repository)
        .submitMealPlanTrackerService(model, mandatoryListRecords);

    print("result: $result");

    if (result.runtimeType == GetProceedModel) {
      setstate(() {
        showProgress = false;
      });
      final _pref = AppConfig().preferences;
      final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);

      ("1" == widget.phases)
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen(index: 2)
                  // MealPlanScreen()
                  ),
              (route) => route.isFirst)
          : ("2" == widget.phases)
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const CombinedPrepMealTransScreen(stage: 1)
                      // MealPlanScreen()
                      ),
                  (route) => route.isFirst)
              : ("3" == widget.phases)
                  ? Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const CombinedPrepMealTransScreen(stage: 2)
                          // MealPlanScreen()
                          ),
                      (route) => route.isFirst)
                  : Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const CombinedPrepMealTransScreen(stage: 3)
                          // NewTransitionDesign(
                          // totalDays: '', dayNumber: '', trackerVideoLink: trackerUrl),
                          ),
                      (route) => route.isFirst);
    } else {
      setstate(() {
        showProgress = false;
      });
      ErrorModel model = result as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    }
  }

  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

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
      return Container(
        padding: EdgeInsets.only(top: 4.h),
        margin: EdgeInsets.only(left: 5.w,bottom: 2.h,right: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: gBlackColor.withOpacity(0.2),
          // border: Border.all(color: gPrimaryColor, width: 1),
        ),
        child: Column(

          children: [
            Container(
              height: 35.h,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Center(
                    child: OverlayVideo(
                  controller: _sheetChewieController!,
                  isControlsVisible: false,
                )),
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
        ),
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
}

class Question {
  String text;
  Question(this.text);
}
