/*
This screen is called from CombinedMealPlan Screen
under prep tab

we r showing the tracker button when
* isPreptrackerCompleted parameter will becomes false
* post dinner will come based on the time

isPreptrackerCompleted will taken from dashboard api
once we got we r storing that in sharedpreferences

we r accessing in this screen using "AppConfig.isPrepTrackerCompleted" key



 */
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/combined_meal_plan/tracker_widgets/new-day_tracker.dart';
import '../../model/combined_meal_model/meal_plan_tracker_modl/send_meal_plan_tracker_model.dart';
import '../../model/combined_meal_model/meal_slot_model.dart';
import '../../model/combined_meal_model/new_prep_model.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../combined_meal_plan/meal_plan_portrait_video.dart';
import '../prepratory plan/new/meal_plan_recipe_details.dart';
import 'package:url_launcher/url_launcher.dart';

class NewPrepScreen extends StatefulWidget {
  final ChildPrepModel prepPlanDetails;
  final int selectedDay;
  final int? totalDays;
  final String mealNote;

  /// this will be used when we came from start program screen
  final bool viewDay1Details;

  const NewPrepScreen({
    Key? key,
    required this.prepPlanDetails,
    this.selectedDay = 1,
    this.viewDay1Details = false,
    this.totalDays,
    required this.mealNote,
  }) : super(key: key);

  @override
  State<NewPrepScreen> createState() => _NewPrepScreenState();
}

class _NewPrepScreenState extends State<NewPrepScreen>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Offset checkedPositionOffset = Offset(0, 0);
  Offset lastCheckOffset = Offset(0, 0);
  Offset animationOffset = Offset(0, 0);
  late Animation _animation;

  TabController? _tabController;

  ChildPrepModel? _childPrepModel;
  Map<String, SubItems> slotNamesForTabs = {};
  int tabSize = 1;

  String selectedSlot = "";
  String selectedItemName = "";

  int? presentDay;

  int? totalDays;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.totalDays != null) {
      totalDays = widget.totalDays;
    }
    getPrepItemsAndStore(widget.prepPlanDetails, widget.mealNote);
    getInitialIndex(widget.mealNote);
    // selectedItemName = slotNamesForTabs.values.first.subItems!.keys.first;
  }

  int selectedIndex = 0;

  bool showPrepTrackerBtn = false;
  final _pref = AppConfig().preferences;
  late bool isPrepTrackerCompleted =
      _pref?.getBool(AppConfig.isPrepTrackerCompleted) ?? false;

  getInitialIndex(String mealNote) {
    // print("HOur : $selectedIndex ${DateTime.now().hour}");
    // print("HOur : $selectedIndex : ${DateTime.now().hour >= DateTime.now().hour}");
    if (DateTime.now().hour >= 0 && DateTime.now().hour <= 7) {
      print("Early Morning : ${DateTime.now().hour >= 7}");
      selectedIndex = 0;
    } else if (DateTime.now().hour >= 7 && DateTime.now().hour <= 10) {
      print("Breakfast : ${DateTime.now().hour <= 7}");
      selectedIndex = 1;
    } else if (DateTime.now().hour >= 10 && DateTime.now().hour <= 12) {
      print("Mid Day : ${DateTime.now().hour <= 10}");
      selectedIndex = 2;
    } else if (DateTime.now().hour > 12 && DateTime.now().hour <= 14) {
      print("Lunch : ${DateTime.now().hour <= 11}");
      selectedIndex = 3;
    } else if (DateTime.now().hour > 14 && DateTime.now().hour <= 18) {
      print("Evening : ${DateTime.now().hour <= 13}");
      selectedIndex = 4;
    } else if (DateTime.now().hour > 18 && DateTime.now().hour <= 21) {
      print("Dinner : ${DateTime.now().hour <= 18}");
      selectedIndex = 5;
    } else if (DateTime.now().hour > 21 && DateTime.now().hour <= 0) {
      print("Post Dinner : ${DateTime.now().hour <= 21}");

      if (totalDays != null && presentDay != null) {
        if (totalDays == presentDay) {
          showPrepTrackerBtn = true;
        }
      }
      selectedIndex = 6;
    }
    setState(() {
      selectedSlot = slotNamesForTabs.keys.elementAt(selectedIndex);
      selectedItemName = slotNamesForTabs[selectedSlot]!.subItems!.keys.first;
    });
    print("selectedSlot: $selectedSlot");
    print("selectedItemName: $selectedItemName");
    _tabController!.animateTo(selectedIndex);
  }

  void getPrepItemsAndStore(ChildPrepModel childPrepModel, String mealNote) {
    _childPrepModel = childPrepModel;

    print("prep--");
    print(_childPrepModel!.toJson());
    if (_childPrepModel != null) {
      slotNamesForTabs.addAll(_childPrepModel!.details!);

      print(slotNamesForTabs);

      print("meal note : $mealNote");

      if (mealNote == "null" || mealNote == "") {
      } else {
        Future.delayed(const Duration(seconds: 0)).then((value) {
          return showMoreBenefitsTextSheet(mealNote, isMealNote: true);
        });
      }

      if (slotNamesForTabs.isNotEmpty) {
        selectedIndex = 0;
        // selectedSlot = slotNamesForTabs.keys.first;
        // selectedItemName = slotNamesForTabs.values.first.subItems!.keys.first;
      }
      tabSize = slotNamesForTabs.length;

      presentDay = _childPrepModel!.currentDay;
    }
    _tabController = TabController(vsync: this, length: tabSize);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabSize,
      child: Scaffold(
        backgroundColor: gWhiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 3.w, top: 2.h, bottom: 0.h, right: 3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Preparatory Phase',
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize),
                  ),
                  (widget.mealNote == "null" || widget.mealNote == "")
                      ? const SizedBox()
                      : GestureDetector(
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
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: (presentDay == 0)
                  ? Text(
                      'Your Prep will start from tomorrow',
                      style: TextStyle(
                          fontFamily: kFontMedium,
                          color: eUser().mainHeadingColor,
                          fontSize: 12.dp),
                    )
                  : RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: presentDay == null
                                ? 'Day 1'
                                : 'Day $presentDay',
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 12.dp,
                              fontFamily: kFontBold,
                              color: gsecondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: ' of Day $totalDays',
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 12.dp,
                              fontFamily: kFontBook,
                              color: gBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: SizedBox(
                height: 30,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  unselectedLabelColor: Colors.black,
                  labelColor: gWhiteColor,
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  unselectedLabelStyle: TextStyle(
                      fontFamily: kFontBook,
                      color: gHintTextColor,
                      fontSize: 12.dp),
                  labelStyle: TextStyle(
                      fontFamily: kFontMedium,
                      color: gBlackColor,
                      fontSize: 15.dp),
                  indicatorColor: newDashboardGreenButtonColor,
                  labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: -2.w),
                  indicator: BoxDecoration(
                    color: newDashboardGreenButtonColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  onTap: (index) {
                    print("ontap: $index");
                    // print(slotNamesForTabs.keys.elementAt(index));
                    selectedSlot = slotNamesForTabs.keys.elementAt(index);
                    selectedIndex = index;
                    setState(() {
                      selectedItemName =
                          slotNamesForTabs[selectedSlot]!.subItems!.keys.first;
                      print(selectedItemName);
                    });
                    // _buildList(index);
                  },
                  tabs: slotNamesForTabs.keys
                      .map(
                        (e) => Tab(
                          text: e,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ...slotNamesForTabs.values
                      .map(
                        (e) => buildTabView(e),
                      )
                      .toList(),
                ],
              ),
            ),
            // btn()
            if (showPrepTrackerBtn && !isPrepTrackerCompleted) btn()
          ],
        ),
      ),
    );
  }

  buildTabView(SubItems mealNames) {
    List<MealSlot> meals = [];
    List<String> subItems = [];
    slotNamesForTabs.entries.map((e) {
      print("compare");
      print(e.value.subItems == mealNames.subItems);
      if (e.value.subItems == mealNames.subItems) {
        mealNames.subItems!.forEach((key, element) {
          subItems.add(key);
          print("$key -- $element");
          if (key == selectedItemName) {
            meals.addAll(element);
          }
        });
      }
    }).toList();
    // print("meals.length: ${meals.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 1.5.h, left: 0.w, right: 3.w),
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
          height: 6.h,
          decoration: BoxDecoration(
            color: const Color(0xffC8DE95).withOpacity(0.6),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              // bottomRight: Radius.circular(30),
            ),
          ),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              itemCount: subItems.length,
              itemBuilder: (context, index) {
                String key = subItems[index];
                return GestureDetector(
                    onTap: () {
                      print(key);
                      indexChecked(key);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.5.h, horizontal: 3.w),
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      decoration: selectedItemName == key
                          ? const BoxDecoration(
                              color: gWhiteColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            )
                          : const BoxDecoration(),
                      child: Text(
                        key.capitalize ?? '',
                        style: TextStyle(
                          color: selectedItemName == key
                              ? gBlackColor
                              : gHintTextColor,
                          fontSize: 13.dp,
                        ),
                      ),
                    ));
              }),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 60.h,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const ScrollPhysics(),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          width: 300,
                          margin: EdgeInsets.symmetric(
                              vertical: 3.5.h, horizontal: 5.w),
                          padding: EdgeInsets.only(bottom: 2.h),
                          decoration: BoxDecoration(
                            color: gWhiteColor,
                            // gSitBackBgColor,
                            borderRadius: BorderRadius.circular(40),

                            // boxShadow:  [
                            //   BoxShadow(
                            //     color: gWhiteColor,
                            //     offset: Offset(0.0, 0.75),
                            //     blurRadius: 5,
                            //   )
                            // ],
                          ),
                          child: buildReceipeDetails(meals[index]),
                        ),
                        meals[index].mealTypeName == "yoga"
                            ? const SizedBox()
                            : (meals.length > 1 && index != meals.length - 1)
                                ? orFiled(index)
                                : const SizedBox(),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  btn() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewDayTracker(
                      phases: "1",
                      proceedProgramDayModel: SubmitMealPlanTrackerModel(
                        day: 1.toString(),
                      ),
                    )
                // const PrepratoryMealCompletedScreen(),
                ),
          );
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
              'Prep Tracker',
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
    );
  }

  buildReceipeDetails(MealSlot? meal) {
    print("Meal Slot : ${meal}");

    print("start program : ${widget.viewDay1Details}");

    print("mealPlanRecipes Name :${meal?.name}");

    print("mealPlanRecipes Image : ${meal?.recipeVideoUrl}");

    print("mealPlanRecipes howToPrepare : ${meal?.howToPrepare}");

    final a = meal?.recipeVideoUrl;

    final file = a?.split(".").last;

    String format = file.toString();

    print("video : $format");

    String ben = (meal?.benefits != null || meal?.benefits != "")
        ? "${meal?.benefits!.replaceAll(RegExp(r'[^\w\s]+'), '')}"
        : '';

    print("benefits : ${meal?.name} ${ben.length}");

    print("prep yoga video : ${meal?.yogaVideoUrl}");

    final yogaVideo = meal?.yogaVideoUrl?.split(".").last;

    String yogaVideoFormat = yogaVideo.toString();

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          left: 2.w,
          right: 0,
          top: 6.h,
          child: Container(
            padding: EdgeInsets.only(left: 3.w, right: 1.w),
            margin: EdgeInsets.symmetric(horizontal: 0.w),
            decoration: BoxDecoration(
              color: gBackgroundColor,
              borderRadius: BorderRadius.circular(40),
              border:
                  Border.all(color: kLineColor.withOpacity(0.2), width: 0.9),
              // boxShadow:  [
              //   BoxShadow(
              //     color: gBlackColor.withOpacity(0.1),
              //     offset: Offset(2, 3),
              //     blurRadius: 5,
              //   )
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 13.h,
                ),
                meal?.mealTypeName == "null" ||
                        meal?.mealTypeName == "" ||
                        meal?.mealTypeName == "yoga"
                    ? Text(
                        meal?.name ?? '',
                        style: TextStyle(
                            fontSize: MealPlanConstants().mealNameFontSize,
                            fontFamily: MealPlanConstants().mealNameFont,
                            color: gHintTextColor),
                      )
                    : Text(
                        meal?.mealTypeName ?? '',
                        style: TextStyle(
                            fontSize: MealPlanConstants().mealNameFontSize,
                            fontFamily: MealPlanConstants().mealNameFont,
                            color: gHintTextColor),
                      ),
                // Text(
                //   meal?.name ?? '',
                //   style: TextStyle(
                //       fontFamily: eUser().mainHeadingFont,
                //       color: eUser().mainHeadingColor,
                //       fontSize: eUser().mainHeadingFontSize),
                // ),
                SizedBox(height: 2.h),

                Expanded(
                  child: (meal?.benefits == null || meal?.benefits == "")
                      ? const SizedBox()
                      : RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: ben.substring(
                                        0,
                                        int.parse(
                                            "${(ben.length * 0.258).toInt()}")) +
                                    "...",
                                style: TextStyle(
                                    height: 1.6,
                                    fontFamily: kFontBook,
                                    color: eUser().mainHeadingColor,
                                    fontSize: bottomSheetSubHeadingSFontSize),
                              ),
                              WidgetSpan(
                                child: InkWell(
                                  mouseCursor: SystemMouseCursors.click,
                                  onTap: () {
                                    showMoreBenefitsTextSheet(
                                        meal?.benefits ?? '');
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
                        ),
                ),
                // (meal?.benefits != null)
                //     ? Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           ...meal!.benefits!.split('* ').map((element) {
                //             if (element.isNotEmpty) {
                //               return Row(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Padding(
                //                     padding: EdgeInsets.only(top: 0.3.h),
                //                     child: Icon(
                //                       Icons.circle_sharp,
                //                       color: gGreyColor,
                //                       size: 1.5.h,
                //                     ),
                //                   ),
                //                   SizedBox(width: 1.w),
                //                   Expanded(
                //                     child: Text(
                //                       element ?? '',
                //                       style: TextStyle(
                //                           fontFamily:
                //                               eUser().userTextFieldFont,
                //                           height: 1.2,
                //                           color: eUser().userTextFieldColor,
                //                           fontSize: eUser()
                //                               .userTextFieldHintFontSize),
                //                     ),
                //                   ),
                //                 ],
                //               );
                //             } else
                //               return SizedBox();
                //           })
                //         ],
                //       )
                //     : const SizedBox(),
                // (widget.viewDay1Details)
                //     ? const SizedBox()
                //     :
                (meal?.mealTypeName == "yoga")
                    ? GestureDetector(
                        onTap: yogaVideoFormat == "mp4"
                            ? () {
                                print("/// Recipe Details ///");

                                Get.to(
                                  () => MealPlanPortraitVideo(
                                    videoUrl: meal?.yogaVideoUrl ?? '',
                                    heading: meal?.mealTypeName == "null" ||
                                            meal?.mealTypeName == ""
                                        ? meal?.name ?? ''
                                        : meal?.mealTypeName ?? '',
                                  ),
                                );
                              }
                            : () async {
                                if (await canLaunchUrl(
                                    Uri.parse(meal?.yogaVideoUrl ?? ''))) {
                                  launch(meal?.yogaVideoUrl ?? '');
                                } else {
                                  // can't launch url, there is some error
                                  throw "Could not launch ${meal?.yogaVideoUrl}";
                                }
                              },
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 3.w),
                            decoration: const BoxDecoration(
                              color: newDashboardGreenButtonColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: kLineColor,
                                  offset: Offset(2, 3),
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: Text(
                              "Play Yoga",
                              style: TextStyle(
                                color: gWhiteColor,
                                fontFamily: kFontBook,
                                fontSize: 14.dp,
                              ),
                            ),
                          ),
                        ),
                      )
                    : (meal?.howToPrepare != null || format == "mp4")
                        ? GestureDetector(
                            onTap: () {
                              print("/// Recipe Details ///");

                              format == "mp4"
                                  ? Get.to(
                                      () => MealPlanPortraitVideo(
                                        videoUrl: meal?.recipeVideoUrl ?? '',
                                        heading: meal?.mealTypeName == "null" ||
                                                meal?.mealTypeName == ""
                                            ? meal?.name ?? ''
                                            : meal?.mealTypeName ?? '',
                                      ),
                                    )
                                  : Get.to(
                                      () => MealPlanRecipeDetails(
                                        meal: meal,
                                      ),
                                    );
                            },
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.5.h, horizontal: 3.w),
                                decoration: const BoxDecoration(
                                  color: newDashboardGreenButtonColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kLineColor,
                                      offset: Offset(2, 3),
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: Text(
                                  "Recipe",
                                  style: TextStyle(
                                    color: gWhiteColor,
                                    fontFamily: kFontBook,
                                    fontSize: 14.dp,
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
        Positioned(
          top: 0.h,
          left: 0,
          // right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: newDashboardGreenButtonColor,
              boxShadow: [
                BoxShadow(
                  color: gBlackColor.withOpacity(0.1),
                  offset: const Offset(2, 5),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: (meal?.itemPhoto != null && meal!.itemPhoto!.isNotEmpty)
                  ? CircleAvatar(
                radius: 7.h,
                backgroundImage: NetworkImage("${meal.itemPhoto}"),
                //AssetImage("assets/images/Group 3252.png"),
              )
                  : CircleAvatar(
                radius: 7.h,
                backgroundImage: const AssetImage(
                    "assets/images/meal_placeholder.png"),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4.7.h,
          right: MediaQuery.of(context).size.shortestSide < 600 ? 8.w : 3.w,
          child: meal?.mealTypeName == "null" ||
                  meal?.mealTypeName == "" ||
                  meal?.mealTypeName == "yoga"
              ? const SizedBox()
              : Container(
                  height: 10.h,
                  width: MediaQuery.of(context).size.shortestSide < 600
                      ? 12.w
                      : 6.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          // AssetImage("assets/images/Lable Green .png"),
                          AssetImage("assets/images/Lable.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Product",
                      style: TextStyle(
                        fontFamily: eUser().userFieldLabelFont,
                        color: eUser().threeBounceIndicatorColor,
                        fontSize: 10.dp,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
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

  orFiled(int index) {
    // if (index.isEven) {
    return const Center(
      child: Text(
        'OR',
        style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
      ),
    );
    // } else {
    //   return const SizedBox();
    // }
  }

  List<Widget> _buildList(List<String>? subItems) {
    List<Widget> WidgetList = [];

    if (subItems != null) {
      print("subItems: $subItems");
      subItems.forEach((key) {
        WidgetList.add(GestureDetector(
            onTap: () {
              print(key);
              indexChecked(key);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
              decoration: selectedItemName == key
                  ? const BoxDecoration(
                      color: gWhiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    )
                  : const BoxDecoration(),
              child: Text(
                key.capitalize ?? '',
                style: TextStyle(
                  color: selectedItemName == key ? gBlackColor : gHintTextColor,
                  fontSize: 13.dp,
                ),
              ),
            )));
      });
    }
    print(WidgetList);
    return WidgetList;
  }

  void indexChecked(String selected) {
    print("${selectedItemName} == $selected");
    // if (selectedItemName == selected) return;

    selectedItemName = "";
    setState(() {
      selectedItemName = selected;
      // calcuteCheckOffset();
      addAnimation();
    });
  }

  void addAnimation() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this)
          ..addListener(() {
            setState(() {
              animationOffset =
                  Offset(checkedPositionOffset.dx, _animation.value);
            });
          });

    _animation = Tween(begin: lastCheckOffset.dy, end: checkedPositionOffset.dy)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.easeInOutBack));
    _animationController!.forward();
  }
}
