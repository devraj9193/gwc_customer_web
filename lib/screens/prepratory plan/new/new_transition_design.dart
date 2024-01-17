/*
After NutriDelight api
not using this screen
 */

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/prepratory_meal_model/prep_meal_model.dart';
import 'package:gwc_customer_web/model/prepratory_meal_model/transition_meal_model.dart';
import 'package:gwc_customer_web/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer_web/model/program_model/start_post_program_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/prepratory_repository/prep_repository.dart';
import 'package:gwc_customer_web/screens/dashboard_screen.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/new/meal_plan_recipe_details.dart';
import 'package:gwc_customer_web/screens/program_plans/day_tracker_ui/day_tracker.dart';
import 'package:gwc_customer_web/screens/program_plans/meal_pdf.dart';
import 'package:gwc_customer_web/screens/program_plans/program_start_screen.dart';
import 'package:gwc_customer_web/services/post_program_service/post_program_service.dart';
import 'package:gwc_customer_web/utils/app_config.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/vlc_player/vlc_player_with_controls.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../repository/post_program_repo/post_program_repository.dart';
import '../../../services/prepratory_service/prepratory_service.dart';
import '../../../widgets/video/normal_video.dart';

class NewTransitionDesign extends StatefulWidget {
  String totalDays;
  String dayNumber;
  final String? trackerVideoLink;
  final String? postProgramStage;
  final bool viewDay1Details;
  NewTransitionDesign(
      {Key? key,
        required this.dayNumber,
        required this.totalDays,
        this.trackerVideoLink,
        this.postProgramStage,
        this.viewDay1Details = false})
      : super(key: key);

  @override
  State<NewTransitionDesign> createState() => _NewTransitionDesignState();
}

class _NewTransitionDesignState extends State<NewTransitionDesign>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  //
  // final List<String> _list = [
  //   "Breakfast",
  //   "Mid Day",
  //   "Lunch",
  //   "Dinner",
  //   "Post Dinner"
  // ];

  /// this is for storing Early morning, lunch dinner
  List<String> _list = [];

  Map<String, List<TransMealSlot>> tabs = {};

  Map<String, TransSubItems> slotNamesForTabs = {};

  int tabSize = 1;

  bool showLoading = true;

  String selectedItemName = "";

  String currentDayStatus = '';

  getTransitionMeals() async {
    final result = await PrepratoryMealService(repository: repository)
        .getTransitionMealService();

    if (result.runtimeType == ErrorModel) {
      final res = result as ErrorModel;
      return Center(
        child: Text(
          res.message ?? '',
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: kFontMedium,
          ),
        ),
      );
    } else {
      TransitionMealModel res = result as TransitionMealModel;
      currentDayStatus = res.currentDayStatus.toString();
      print("currentDayStatus top: ${currentDayStatus}");
      final dataList = res.data ?? {};
      if (res.currentDay != null) currentDay = res.currentDay;
      if (res.totalDays != null) totalDays = res.totalDays ?? "1";
      planNotePdfLink = res.dosDontPdfLink;

      slotNamesForTabs.addAll(dataList);

      _list.clear();
      slotNamesForTabs.forEach((key, value) {
        _list.add(key);

        print("$key ==> ${value.subItems!.length}");
      });

      Future.delayed(Duration.zero).whenComplete(() {
        if (!widget.viewDay1Details) {
          print("previous day status: ${res.previousDayStatus}");
          if (res.previousDayStatus == "0") {
            Future.delayed(Duration(seconds: 0)).then((value) {
              if (!symptomTrackerSheet) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => TrackerUI(
                        from: ProgramMealType.transition.name,
                        isPreviousDaySheet: true,
                        proceedProgramDayModel: ProceedProgramDayModel(day: (int.parse(widget.dayNumber) - 1).toString()),
                        trackerVideoLink: widget.trackerVideoLink
                    ),),);

                // return showSymptomsTrackerSheet(
                //     context, (int.parse(widget.dayNumber) - 1).toString(),
                //     isPreviousDaySheet: true)
                //     .then((value) {
                //   // when we close bottomsheet from close icon than we r  not calling this
                //   if (!fromBottomSheet) getTransitionMeals();
                // });
              }
            });
          }
          if (res.isTransMealCompleted == "1" &&
              (widget.postProgramStage == null ||
                  widget.postProgramStage!.isEmpty)) {
            Future.delayed(Duration(seconds: 0)).then((value) {
              return buildDayCompletedClap();
            });
          }
        }
      });

      updateTabSize();
    }
    setState(() {
      showLoading = false;
    });
  }

  String selectedSubTab = "";
  List<Map<String, List<TransMealSlot>>> selectedTabs = [];

  updateTabSize() {
    selectedTabs.clear();
    slotNamesForTabs.forEach((key, value) {
      if (_list[selectedIndex] == key) {
        print("tabsize: ${value.subItems!.length}");
        setState(() {
          tabSize = value.subItems!.length;
          selectedTabs.add(value.subItems!);
        });
      }
    });

    selectedSubTab = selectedTabs.first.keys.first;

    print("selectedTabs: $selectedTabs");
  }

  buildTimeDate() {
    DateTime date = DateTime.now();
    String amPm = 'AM';
    if (date.hour >= 12) {
      amPm = 'PM';
    }
    String hour = date.hour.toString();
    if (date.hour > 12) {
      hour = (date.hour - 12).toString();
    }

    String minute = date.minute.toString();
    if (date.minute < 10) {
      minute = '0${date.minute}';
    }
    return "$hour : $minute $amPm";
  }

  getInitialIndex() {
    print("HOur : $selectedIndex");
    print("HOur : $selectedIndex : ${DateTime.now().hour >= DateTime.now().hour}");
    if (DateTime.now().hour >= 0 && DateTime.now().hour <= 7) {
      print(
          "Early Morning : ${DateTime.now().hour >= 7}");
      return selectedIndex = 0;
    } else if (DateTime.now().hour >= 7 && DateTime.now().hour <= 10) {
      print(
          "Breakfast : ${DateTime.now().hour <= 7}");
      return selectedIndex = 1;
    } else if (DateTime.now().hour >= 10 && DateTime.now().hour <= 12) {
      print(
          "Mid Day : ${DateTime.now().hour <= 10}");
      return selectedIndex = 2;
    }
    else if (DateTime.now().hour >= 12 && DateTime.now().hour <= 14) {
      print("Lunch : ${DateTime.now().hour <= 11}");
      return selectedIndex = 3;
    }
    else if (DateTime.now().hour >= 14 && DateTime.now().hour <= 18) {
      print(
          "Evening : ${DateTime.now().hour <= 13}");
      return selectedIndex = 4;
    } else if (DateTime.now().hour >= 18 && DateTime.now().hour == 21) {
      print(
          "Dinner : ${DateTime.now().hour <= 18}");
      return selectedIndex = 5;
    } else if (DateTime.now().hour >= 21 && DateTime.now().hour <= 0) {
      print(
          "Post Dinner : ${DateTime.now().hour <= 21}");
      return selectedIndex = 6;
    }
  }

  String? planNotePdfLink;
  String? currentDay;
  String? totalDays;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialIndex();
    currentDay = widget.dayNumber;
    totalDays = widget.totalDays;
    print("initstate");
    getTransitionMeals();
  }

  @override
  void dispose() {
    if (mealPlayerController != null) mealPlayerController!.dispose();
    if (_chewieController != null) _chewieController!.dispose();

    super.dispose();
  }

  final PrepratoryRepository repository = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  int selectedIndex = 0;
  int initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: showLoading
              ? kWhiteColor
              : const Color(0xffC8DE95).withOpacity(0.6),
          body: showLoading
              ? Center(
            child: buildCircularIndicator(),
          )
              : DefaultTabController(
            length: tabSize,
            child: StatefulBuilder(
              builder: (_, setstate) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1.h, left: 3.w),
                      child: buildAppBar(
                              () {
                            Navigator.pop(context);
                          },
                          showHelpIcon: true,
                          helpIconColor: gWhiteColor,
                          helpOnTap: () {
                            if (planNotePdfLink != null ||
                                planNotePdfLink!.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => MealPdf(
                                      pdfLink: planNotePdfLink!,
                                      heading: planNotePdfLink
                                          ?.split('/')
                                          .last ??
                                          '',
                                      isVideoWidgetVisible: false,
                                      headCircleIcon: bsHeadPinIcon,
                                      topHeadColor: kBottomSheetHeadGreen,
                                      isSheetCloseNeeded: true,
                                      sheetCloseOnTap: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              );
                            }
                            else {
                              AppConfig().showSnackbar(
                                  context, "Note Link Not available",
                                  isError: true);
                            }
                          }),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Transition Meal Plan',
                      style: TextStyle(
                          fontFamily: eUser().mainHeadingFont,
                          color: eUser().buttonTextColor,
                          fontSize: eUser().mainHeadingFontSize),
                    ),
                    SizedBox(height: 1.h),
                    Visibility(
                      visible: !widget.viewDay1Details,
                      child: Text(
                        "Day ${currentDay} of Day ${(int.parse(totalDays ?? '0'))}",
                        // '${(int.parse(totalDays ?? '0') - int.parse(currentDay ?? '0')).abs()} Days Remaining',
                        style: TextStyle(
                            fontFamily: eUser().userTextFieldFont,
                            color: eUser().buttonTextColor,
                            fontSize: eUser().userTextFieldHintFontSize),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 28.w, vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (selectedIndex == 0) {
                              } else {
                                setstate(() {
                                  if (selectedIndex > 0) {
                                    selectedIndex--;
                                  }
                                  updateTabSize();
                                  print(selectedIndex);
                                });
                              }
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: eUser().buttonTextColor,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              _list[selectedIndex],
                              style: TextStyle(
                                  fontFamily: eUser().mainHeadingFont,
                                  color: eUser().buttonTextColor,
                                  fontSize: eUser().mainHeadingFontSize),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setstate(() {
                                if (selectedIndex == _list.length - 1) {
                                } else {
                                  if (selectedIndex >= 0 &&
                                      selectedIndex != _list.length - 1) {
                                    selectedIndex++;
                                  }
                                  print(selectedIndex);
                                  updateTabSize();
                                  print(selectedIndex);
                                }
                              });
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: eUser().buttonTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TabBar(
                        // padding: EdgeInsets.symmetric(horizontal: 3.w),
                          isScrollable: true,
                          unselectedLabelColor: tabBarHintColor,
                          labelColor: gBlackColor,
                          controller: _tabController,
                          unselectedLabelStyle: TextStyle(
                              fontFamily: kFontBook,
                              color: gHintTextColor,
                              fontSize: 9.sp),
                          labelStyle: TextStyle(
                              fontFamily: kFontMedium,
                              color: gBlackColor,
                              fontSize: 9.sp),
                          indicator: BoxDecoration(
                            color: gWhiteColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          onTap: (index) {
                            print("ontap: $index");

                            selectedTabs.forEach((element) {
                              print(element.keys.elementAt(index));
                              setstate(() {
                                selectedSubTab =
                                    element.keys.elementAt(index);
                              });
                            });
                          },
                          tabs: buildTabs()
                        // [selectedTabs.map((e) => _buildTabs(e)).to]

                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 3.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.w, vertical: 1.h),
                        decoration: const BoxDecoration(
                          color: gBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                          boxShadow: [
                            BoxShadow(
                              color: kLineColor,
                              offset: Offset(2, 3),
                              blurRadius: 5,
                            )
                          ],
                          // border: Border.all(
                          //   width: 1,
                          //   color: kLineColor,
                          // ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                physics:
                                const NeverScrollableScrollPhysics(),
                                children: buildTabBarView(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )),
    );
  }

  buildTabs() {
    List<Widget> widgetList = [];

    selectedTabs.forEach((element) {
      element.forEach((key, value) {
        widgetList.add(Tab(
          text: key,
        ));
      });
    });
    return widgetList;
  }

  buildTabBarView() {
    print("buildTabBarView");
    List<Widget> widgetList = [];

    print(selectedSubTab);

    selectedTabs.forEach((element) {
      element.forEach((key, value) {
        widgetList.add(buildTabView(value));
      });
    });
    // selectedTabs.forEach((element) {
    //   element.forEach((key, value) {
    //     if(key == selectedSubTab){
    //       print("$key // $value");
    //       widgetList.add(buildTabView(value));
    //     }
    //   });
    // });

    return widgetList;
  }

  buildTabView(List<TransMealSlot> value) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 58.h,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        width: 300,
                        margin: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: gBackgroundColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: buildReceipeDetails(value[index]),
                      ),
                      if (value.last.id != value[index].id) orFiled(),
                    ],
                  );
                }),
          ),
          // btn()
          if (currentDayStatus == "0" && !widget.viewDay1Details) btn(),
        ],
      ),
    );
  }

  buildReceipeDetails(TransMealSlot value) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          left: 2.w,
          right: 0,
          top: 6.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(40),
              border:
              Border.all(color: kLineColor.withOpacity(0.2), width: 0.9),
              // boxShadow: [
              //   BoxShadow(
              //     color: gBlackColor.withOpacity(0.1),
              //     offset: Offset(2, 3),
              //     blurRadius: 5,
              //   )
              // ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    value.name ?? '',
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  (value.benefits != null)
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...value.benefits!.split(' -').map((element) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle_sharp,
                              color: gGreyColor,
                              size: 1.h,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                element.replaceAll("-", "") ?? '',
                                style: TextStyle(
                                    fontFamily: eUser().userTextFieldFont,
                                    height: 1.5,
                                    color: eUser().userTextFieldColor,
                                    fontSize: eUser()
                                        .userTextFieldHintFontSize),
                              ),
                            ),
                          ],
                        );
                      })
                    ],
                  )
                      : SizedBox(),
                  SizedBox(height: 5.h),
                  (value.howToPrepare != null)
                      ? Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                              () => MealPlanRecipeDetails(
                            // meal: MealSlot.fromJson(value.toJson()),
                          ),
                        );
                      },
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 5.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: newDashboardGreenButtonColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: kLineColor,
                              offset: Offset(2, 3),
                              blurRadius: 5,
                            )
                          ],
                          // border: Border.all(
                          //   width: 1,
                          //   color: kLineColor,
                          // ),
                        ),
                        child: Text(
                          "Recipe",
                          style: TextStyle(
                            color: gWhiteColor,
                            fontFamily: kFontBook,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.h,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: newDashboardGreenButtonColor,
              boxShadow: [
                BoxShadow(
                  color: gBlackColor.withOpacity(0.1),
                  offset: Offset(2, 3),
                  blurRadius: 5,
                )
              ],
            ),
            child: Center(
              child: (value.itemPhoto != null && value.itemPhoto!.isNotEmpty)
                  ? CircleAvatar(
                radius: 8.h,
                backgroundImage: NetworkImage("${value.itemPhoto}"),
                //AssetImage("assets/images/Group 3252.png"),
              )
                  : CircleAvatar(
                radius: 8.h,
                backgroundImage: const AssetImage(
                    "assets/images/meal_placeholder.png"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showPdf(String itemUrl) {
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
    if (url.isNotEmpty)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => MealPdf(
                pdfLink: url!,
                heading: url.split('/').last,
              )));
  }

  orFiled() {
    return const Center(
      child: Text(
        'OR',
        style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
      ),
    );
  }

  btn() {
    return Visibility(
      visible: DateTime.now().hour >= 21 && DateTime.now().hour <= 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => TrackerUI(
                    from: ProgramMealType.transition.name,
                    proceedProgramDayModel: ProceedProgramDayModel(day: widget.dayNumber),
                    trackerVideoLink: widget.trackerVideoLink
                ),),);
            // showSymptomsTrackerSheet(context, widget.dayNumber).then((value) {
            //   getTransitionMeals();
            // });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            width: 60.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: eUser().buttonColor,
              borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
              // border: Border.all(color: eUser().buttonBorderColor,
              //     width: eUser().buttonBorderWidth),
            ),
            child: Center(
              child: Text(
                'Next',
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
    );
  }

  bool showMealVideo = false;

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

  VideoPlayerController? mealPlayerController;
  ChewieController? _chewieController;

  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    mealPlayerController = VideoPlayerController.network(url);
    _chewieController = ChewieController(
        videoPlayerController: mealPlayerController!,
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
  // VlcPlayerController? _mealPlayerController;
  // final _trackerSheetKey = GlobalKey<VlcPlayerWithControlsState>();
  //
  // addUrlToVideoPlayer(String url) async {
  //   print("url" + url);
  //   _mealPlayerController = VlcPlayerController.network(
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
  //   if (await Wakelock.enabled == false) {
  //     Wakelock.enable();
  //   }
  // }

  buildMealVideo({required VoidCallback onTap}) {
    if (mealPlayerController != null) {
      return Column(
        children: [
          Stack(
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
                        isControlsVisible: false,
                        controller: _chewieController!,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: GestureDetector(
                      onTap: () {
                        print("onTap");
                        if (_chewieController != null) {
                          if (_chewieController!
                              .videoPlayerController.value.isPlaying) {
                            _chewieController!.videoPlayerController.pause();
                          } else {
                            _chewieController!.videoPlayerController.play();
                          }
                        }
                      },
                    ),
                  ))
            ],
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
    } else {
      return SizedBox.shrink();
    }
  }

  bool symptomTrackerSheet = false;

  bool fromBottomSheet = false;

  Future showSymptomsTrackerSheet(BuildContext context, String day,
      {bool isPreviousDaySheet = false}) {
    symptomTrackerSheet = true;
    return AppConfig().showSheet(
        context,
        StatefulBuilder(builder: (_, setState) {
          return WillPopScope(
              child: Column(
                children: [
                  videoMp4Widget(
                      videoName: "Know more about Symptoms Tracker",
                      onTap: () {
                        if (widget.trackerVideoLink == null) {
                          Future.delayed(Duration.zero).whenComplete(() {
                            Get.snackbar(
                              "",
                              'Video link is Empty',
                              titleText: SizedBox.shrink(),
                              colorText: gWhiteColor,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor:
                              gsecondaryColor.withOpacity(0.55),
                            );
                          });
                        } else {
                          addUrlToVideoPlayerChewie(
                              widget.trackerVideoLink ?? '');
                          setState(() {
                            showMealVideo = true;
                          });
                        }
                      }),
                  Stack(
                    children: [
                      TrackerUI(
                        from: ProgramMealType.transition.name,
                        proceedProgramDayModel:
                        ProceedProgramDayModel(day: day),
                      ),
                      Visibility(
                        visible: showMealVideo,
                        child: Positioned(child:
                        Center(child: buildMealVideo(onTap: () async {
                          setState(() {
                            showMealVideo = false;
                          });
                          if (await WakelockPlus.enabled == true) {
                            WakelockPlus.disable();
                          }
                          if (mealPlayerController != null)
                            mealPlayerController!.dispose();
                          if (_chewieController != null)
                            _chewieController!.dispose();

                          // await _mealPlayerController!.stopRendererScanning();
                          // await _mealPlayerController!.dispose();
                        }))),
                      )
                    ],
                  )
                ],
              ),
              onWillPop: () => isPreviousDaySheet
                  ? Future.value(false)
                  : Future.value(false));
        }),
        circleIcon: bsHeadPinIcon,
        bottomSheetHeight: 90.h,
        isSheetCloseNeeded: true,
        sheetCloseOnTap: () {
          if (isPreviousDaySheet) {
            fromBottomSheet = true;
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        });
    return showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              TrackerUI(
                from: ProgramMealType.transition.name,
                proceedProgramDayModel: ProceedProgramDayModel(day: day),
              )
            ],
          );
        }).then((value) {
      setState(() {});
      getTransitionMeals();
    });
  }

  bool isOpened = false;

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
                    "You Have completed the Transition Plan, Now you can proceed to Post Program",
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
                    Future.delayed(Duration(seconds: 0)).whenComplete(() {
                      // openProgressDialog(context);
                    });
                    startPostProgram();
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
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onWillPop: () => Future.value(false)),
        circleIcon: bsHeadPinIcon,
        bottomSheetHeight: 60.h,
        isSheetCloseNeeded: true, sheetCloseOnTap: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  startPostProgram() async {
    final res = await PostProgramService(repository: _postProgramRepository)
        .startPostProgramService();

    if (res.runtimeType == ErrorModel) {
      ErrorModel model = res as ErrorModel;
      Navigator.pop(context);
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    } else {
      Navigator.pop(context);
      if (res.runtimeType == StartPostProgramModel) {
        StartPostProgramModel model = res as StartPostProgramModel;
        print("start program: ${model.response}");
        // AppConfig().showSnackbar(context, "Post Program started" ?? '');
        Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen(index: 2,)),
                  (route) => true);
        });
      }
    }
  }

  final PostProgramRepository _postProgramRepository = PostProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );


}
