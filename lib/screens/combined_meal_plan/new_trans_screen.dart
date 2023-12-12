/*
new UI same like prep

here we r not calling any get Apis all get meals will be called from combinedmealplanscreen only

once transmeal plan all days completed than we r showing clap screen in bottomsheet

in that we r calling start post program api

var startPostProgramUrl = "${AppConfig().BASE_URL}/api/submitForm/post_program";


Note:
for showing tracker button we r checking 3 conditions:-
* if viewDay1Details: false
* if currentday status: 0
if both 2 conditions are true and
when stage becomes post program than showTrackerBtn variable becomes true

if all condition satisfied than tracker button will be showing

clap sheet Note:
presentDay == totalDays && _childPrepModel!.currentDayStatus == "1"

* if present day and total days will be equal
* if currentday status is 1
* if postprogramstage is null or is empty

if all 3 conditions satisfy than postprogram start clap will be showing
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gwc_customer_web/model/combined_meal_model/detox_nourish_model/child_nourish_model.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../model/combined_meal_model/meal_slot_model.dart';
import '../../model/error_model.dart';
import '../../model/prepratory_meal_model/prep_meal_model.dart';
import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
import '../../model/program_model/start_post_program_model.dart';
import '../../repository/api_service.dart';
import '../../repository/post_program_repo/post_program_repository.dart';
import '../../services/post_program_service/post_program_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import 'package:http/http.dart' as http;
import '../dashboard_screen.dart';
import '../prepratory plan/new/meal_plan_recipe_details.dart';
import '../program_plans/day_tracker_ui/day_tracker.dart';
import '../program_plans/meal_pdf.dart';
import '../program_plans/program_start_screen.dart';

class NourishPlanScreen extends StatefulWidget {
  /// getting this details from combinedmealplanscreen
  final ChildNourishModel prepPlanDetails;
  final String? totalDays;
  final int selectedDay;
  /// this value if false by default
  /// if we come from start screen and clicked on view button
  /// than this will true
  final bool viewDay1Details;
  final String? trackerVideoLink;
  /// we r using this parameter to check whether post program started or not
  /// if there is a value than clap sheet not showing
  final String? postProgramStage;

  const NourishPlanScreen({
    Key? key,
    required this.prepPlanDetails,
    this.selectedDay = 1,
    this.totalDays,
    this.trackerVideoLink,
    this.postProgramStage,
    this.viewDay1Details = false,
  }) : super(key: key);

  @override
  State<NourishPlanScreen> createState() => _NourishPlanScreenState();
}

class _NourishPlanScreenState extends State<NourishPlanScreen>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Offset checkedPositionOffset = Offset(0, 0);
  Offset lastCheckOffset = Offset(0, 0);
  Offset animationOffset = Offset(0, 0);
  late Animation _animation;

  bool isPostProgramStarted = false;

  TabController? _tabController;

  ChildNourishModel? _childPrepModel;
  Map<String, SubItems> slotNamesForTabs = {};
  int tabSize = 1;

  bool showTrackerBtn = false;

  String selectedSlot = "";
  String selectedItemName = "";
  int selectedIndex = 0;
  int? presentDay;
  int? totalDays;
  List<String> _list = [];
  List<Map<String, List<MealSlot>>> selectedTabs = [];
  String selectedSubTab = "";

  String currentDayStatus = "0";
  String? previousDayStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrepItemsAndStore(widget.prepPlanDetails);
    getInitialIndex();
  }

  bool symptomTrackerSheet = false;

  void getPrepItemsAndStore(ChildNourishModel childPrepModel) {
    _childPrepModel = childPrepModel;
    print("Nourish--");
    print(_childPrepModel!.toJson());
    if(_childPrepModel != null){
      final dataList = _childPrepModel?.data ?? {};

      totalDays = int.tryParse(widget.totalDays ?? "0") ?? -1;


      currentDayStatus = _childPrepModel?.currentDayStatus ?? '0';
      previousDayStatus = _childPrepModel?.previousDayStatus;

      isPostProgramStarted = _childPrepModel?.isPostProgramStarted == '0' || _childPrepModel?.isPostProgramStarted == 'null'  ? false : true;

      print("previousDayStatus: $previousDayStatus");
      print("currentDayStatus: $currentDayStatus");

      if(_childPrepModel!.currentDay != null){
        presentDay = int.tryParse(_childPrepModel!.currentDay!) ?? 1;
      }

      print("presentDay: $presentDay");

      if(_childPrepModel!.currentDay != null){
        presentDay = int.tryParse(_childPrepModel!.currentDay!) ?? 1;
      }

      print("presentDay: $presentDay");


      slotNamesForTabs.addAll(dataList);

      print(slotNamesForTabs);

      if(slotNamesForTabs.isNotEmpty){
        selectedIndex = 0;
        // selectedSlot = slotNamesForTabs.keys.first;
        // selectedItemName = slotNamesForTabs.values.first.subItems!.keys.first;
      }
      tabSize = slotNamesForTabs.length;
    }
    // updateTabSize();
    _tabController = TabController(vsync: this, length: tabSize);

    if (!widget.viewDay1Details) {
      if(!isPostProgramStarted){
        // this is previousDayStatus change from cron
        // if (previousDayStatus == "0") {
        // this is when we change from db
        if (previousDayStatus == "0") {
          Future.delayed(Duration(seconds: 0)).then((value) {
            if (!symptomTrackerSheet) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => TrackerUI(
                      from: ProgramMealType.transition.name,
                      isPreviousDaySheet: true,
                      proceedProgramDayModel: ProceedProgramDayModel(day: (presentDay!-1).toString()),
                      trackerVideoLink: widget.trackerVideoLink
                  ),),);
            }
          });
        }
        if ((presentDay == totalDays && _childPrepModel!.currentDayStatus == "1" || _childPrepModel!.isNourishCompleted == "1") &&
            (widget.postProgramStage == null ||
                widget.postProgramStage!.isEmpty))
        {
          Future.delayed(Duration(seconds: 0)).then((value) {
            return buildDayCompletedClap();
          });
        }
      }
    }
  }

  /// not using this function
  // void getPrepItemsAndStore1(ChildNourishModel childPrepModel) {
  //   _childPrepModel = childPrepModel;
  //   print("prep--");
  //   print(_childPrepModel!.toJson());
  //   if (_childPrepModel != null) {
  //     final dataList = _childPrepModel?.data ?? {};
  //
  //     currentDayStatus = _childPrepModel?.currentDayStatus ?? '0';
  //     previousDayStatus = _childPrepModel?.previousDayStatus;
  //
  //     isPostProgramStarted = _childPrepModel?.isPostProgramStarted == '0' || _childPrepModel?.isPostProgramStarted == 'null'  ? false : true;
  //
  //     print("previousDayStatus: $previousDayStatus");
  //     print("currentDayStatus: $currentDayStatus");
  //
  //     if(_childPrepModel!.currentDay != null){
  //       presentDay = int.tryParse(_childPrepModel!.currentDay!) ?? 1;
  //     }
  //
  //     print("presentDay: $presentDay");
  //
  //     slotNamesForTabs.addAll(dataList);
  //
  //     _list.clear();
  //     slotNamesForTabs.forEach((key, value) {
  //       _list.add(key);
  //
  //       print("$key ==> ${value.subItems!.length}");
  //     });
  //   }
  //   updateTabSize();
  //
  //   print("widget.postProgramStage: ${widget.postProgramStage}");
  //
  //   if (!widget.viewDay1Details && (currentDayStatus == "1")) {
  //     if(!isPostProgramStarted){
  //       // this is previousDayStatus change from cron
  //       // if (previousDayStatus == "0") {
  //       // this is when we change from db
  //       if (previousDayStatus == "0") {
  //         Future.delayed(Duration(seconds: 0)).then((value) {
  //           if (!symptomTrackerSheet) {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (ctx) => TrackerUI(
  //                     from: ProgramMealType.transition.name,
  //                     isPreviousDaySheet: true,
  //                     proceedProgramDayModel: ProceedProgramDayModel(day: (presentDay!-1).toString()),
  //                     trackerVideoLink: widget.trackerVideoLink
  //                 ),),);
  //
  //             // return showSymptomsTrackerSheet(
  //             //     context, (int.parse(widget.dayNumber) - 1).toString(),
  //             //     isPreviousDaySheet: true)
  //             //     .then((value) {
  //             //   // when we close bottomsheet from close icon than we r  not calling this
  //             //   if (!fromBottomSheet) getTransitionMeals();
  //             // });
  //           }
  //         });
  //       }
  //       if (_childPrepModel!.isNourishCompleted == "1" &&
  //           (widget.postProgramStage == null ||
  //               widget.postProgramStage!.isEmpty))
  //       {
  //         Future.delayed(Duration(seconds: 0)).then((value) {
  //           return buildDayCompletedClap();
  //         });
  //       }
  //     }
  //   }
  //
  // }

  /// to get the initial index to show time based tabs
  getInitialIndex() {
    print("HOur : $selectedIndex ${DateTime.now().hour}");
    print("HOur : $selectedIndex : ${DateTime.now().hour >= DateTime.now().hour}");
    if (DateTime.now().hour >= 0 && DateTime.now().hour <= 7) {
      print(
          "Early Morning : ${DateTime.now().hour >= 7}");
      selectedIndex = 0;
    } else if (DateTime.now().hour >= 7 && DateTime.now().hour <= 10) {
      print(
          "Breakfast : ${DateTime.now().hour <= 7}");
      selectedIndex = 1;
    } else if (DateTime.now().hour >= 10 && DateTime.now().hour <= 12) {
      print(
          "Mid Day : ${DateTime.now().hour <= 10}");
      selectedIndex = 2;
    }
    else if (DateTime.now().hour > 12 && DateTime.now().hour <= 14) {
      print("Lunch : ${DateTime.now().hour <= 11}");
      selectedIndex = 3;
    }
    else if (DateTime.now().hour > 14 && DateTime.now().hour <= 18) {
      print(
          "Evening : ${DateTime.now().hour <= 13}");
      selectedIndex = 4;
    } else if (DateTime.now().hour > 18 && DateTime.now().hour <= 21) {
      print(
          "Dinner : ${DateTime.now().hour <= 18}");
      selectedIndex = 5;
    } else if (DateTime.now().hour > 21 && DateTime.now().hour <= 0) {
      print(
          "Post Dinner : ${DateTime.now().hour <= 21}");
      selectedIndex = 6;
      showTrackerBtn = true;
    }
    setState(() {
      selectedSlot = slotNamesForTabs.keys.elementAt(selectedIndex);
      selectedItemName = slotNamesForTabs[selectedSlot]!.subItems!.keys.first;
    });
    print("selectedSlot: $selectedSlot");
    print("selectedItemName: $selectedItemName");
    _tabController!.animateTo(selectedIndex);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabSize,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 3.w,top: 2.h,bottom: 1.h),
              child: Text(
                'Nourish Phase',
                style: TextStyle(
                    fontFamily: eUser().mainHeadingFont,
                    color: eUser().mainHeadingColor,
                    fontSize: eUser().mainHeadingFontSize),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Text(
                (presentDay == 0) ? 'Your Nourish will start from tomorrow' : 'Day ${presentDay} of Day ${widget.totalDays}',
                style: TextStyle(
                    fontFamily: kFontMedium,
                    color: eUser().mainHeadingColor,
                    fontSize: 10.sp),
              ),
            ),
            // SizedBox(height: 1.h),
            // Padding(
            //   padding: EdgeInsets.only(left: 3.w),
            //   child: Text(
            //     '2 Days Remaining',
            //     style: TextStyle(
            //         fontFamily: eUser().userTextFieldFont,
            //         color: eUser().userTextFieldColor,
            //         fontSize: eUser().userTextFieldHintFontSize),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffC8DE95).withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.black,
                        labelColor: gWhiteColor,
                        controller: _tabController,
                        unselectedLabelStyle: TextStyle(
                            fontFamily: kFontBook,
                            color: gHintTextColor,
                            fontSize: 9.sp),
                        labelStyle: TextStyle(
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                            fontSize: 11.sp),
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
                          selectedSlot =
                              slotNamesForTabs.keys.elementAt(index);
                          selectedIndex = index;
                          setState(() {
                            selectedItemName = slotNamesForTabs[selectedSlot]!.subItems!.keys.first;
                            print(selectedItemName);
                          });
                          // _buildList(index);
                        },
                        tabs: slotNamesForTabs.keys
                            .map((e) => Tab(
                          text: e,
                        ))
                            .toList(),
                      ),
                    ),
                  ],
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
          ],
        ),
      ),
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

  updateTabSize() {
    selectedTabs.clear();
    slotNamesForTabs.forEach((key, value) {
      if (_list[selectedIndex] == key) {
        print("tabsize: ${value?.subItems!.length}");
        setState(() {
          tabSize = value.subItems!.length;
          selectedTabs.add(value.subItems!.cast<String, List<MealSlot>>());
        });
      }
    });

    _tabController = TabController(vsync: this, length: tabSize);
    selectedSubTab = selectedTabs.first.keys.first;

    print("selectedTabs: $selectedTabs");
  }

  buildTabView(SubItems mealNames) {
    List<MealSlot> meals = [];
    List<String> subItems = [];
    slotNamesForTabs.entries.map((e) {
      print("compare");
      print(e.value.subItems == mealNames.subItems);
      if(e.value.subItems == mealNames.subItems){
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
    return Row(
      children: [
        Stack(
          children: <Widget>[
            Container(
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xffC8DE95).withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  // topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildList(subItems),
              ),
            ),
            // Positioned(
            //   top: animationOffset.dy,
            //   left: animationOffset.dx,
            //   child: CustomPaint(
            //     painter: CheckPointPainter(Offset(10, 0)),
            //   ),
            // )
          ],
        ),
        Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 65.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(
                                left: 3.w, right: 3.w, top: 5.h, bottom: 5.h),
                            padding: EdgeInsets.only(bottom: 2.h),
                            decoration: BoxDecoration(
                              color: gBackgroundColor,
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
                          if(meals.length > 1)orFiled(index),
                        ],
                      );
                    }),
              ),
              // btn(),
              //&& showTrackerBtn
              if (currentDayStatus == "0" && !widget.viewDay1Details && showTrackerBtn) btn(),
              Visibility(
                visible: currentDayStatus == "1",
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
                            SizedBox(width: 8,),
                            Text(
                              // "Day ${widget.day} Meal Plan",
                              "Day ${presentDay} Submitted",
                              style: TextStyle(
                                  fontFamily: eUser().mainHeadingFont,
                                  color: gTextColor,
                                  fontSize:
                                  eUser().mainHeadingFontSize),
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
        )
        ),
      ],
    );
  }

  List<Widget> _buildList(List<String>? subItems) {
    List<Widget> WidgetList = [];

    if (subItems != null) {
      print("subItems: $subItems");
      subItems.forEach((key) {
        WidgetList.add(
            GestureDetector(
                onTap: () {
                  print(key);
                  rotatedBoxOnclick(key);
                },
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                    decoration: selectedItemName == key
                        ? const BoxDecoration(
                      color: gWhiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    )
                        : const BoxDecoration(),
                    child: Text(
                      key,
                      style: TextStyle(
                        color: selectedItemName == key ? gBlackColor : gWhiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )));
      });
    }
    print(WidgetList);
    return WidgetList;
  }

  /// this function is used for the rotated tabs line main...
  /// for rotated sub items click we need to handle here
  void rotatedBoxOnclick(String selected) {
    print("${selectedItemName} == $selected");

    selectedItemName = "";
    setState(() {
      selectedItemName = selected;
      // calcuteCheckOffset();
      addAnimation();
    });
  }


  // /// this function design has changed
  // /// now we r not using this design
  // buildTabView1(List<MealSlot> value) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: 58.h,
  //           child: ListView.builder(
  //               shrinkWrap: true,
  //               scrollDirection: Axis.horizontal,
  //               // physics: const NeverScrollableScrollPhysics(),
  //               itemCount: value.length,
  //               itemBuilder: (context, index) {
  //                 return Row(
  //                   children: [
  //                     Container(
  //                       width: 300,
  //                       margin: EdgeInsets.symmetric(
  //                         horizontal: 3.w,
  //                         vertical: 2.h,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: gBackgroundColor,
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: buildReceipeDetails(value[index]),
  //                     ),
  //                     if (value.last.id != value[index].id) orFiled(index),
  //                   ],
  //                 );
  //               }),
  //         ),
  //         // btn()
  //         if (currentDayStatus == "0" && !widget.viewDay1Details && showTrackerBtn) btn(),
  //         Visibility(
  //           visible: currentDayStatus == "1",
  //           child: Center(
  //             child: IntrinsicWidth(
  //               child: Container(
  //                 padding: EdgeInsets.all(8),
  //                 margin: EdgeInsets.symmetric(vertical: 5),
  //                 child: Center(
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Container(
  //                         padding: EdgeInsets.all(5),
  //                         decoration: BoxDecoration(
  //                             color: gPrimaryColor, shape: BoxShape.circle),
  //                         child: Center(
  //                           child: Icon(
  //                             Icons.done_outlined,
  //                             color: gWhiteColor,
  //                             size: 3.h,
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 8,),
  //                       Text(
  //                         // "Day ${widget.day} Meal Plan",
  //                         "Day ${presentDay} Submitted",
  //                         style: TextStyle(
  //                             fontFamily: eUser().mainHeadingFont,
  //                             color: gTextColor,
  //                             fontSize:
  //                             eUser().mainHeadingFontSize),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  buildReceipeDetails(MealSlot? meal) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    meal?.name ?? '',
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize),
                  ),
                  SizedBox(
                    height: 2.h
                  ),
                  (meal?.benefits != null)
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...meal!.benefits!.split('* ').map((element) {
                        if(element.isNotEmpty) {
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
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  element ?? '',
                                  style: TextStyle(
                                      fontFamily: eUser().userTextFieldFont,
                                      height: 1.2,
                                      color: eUser().userTextFieldColor,
                                      fontSize: eUser()
                                          .userTextFieldHintFontSize),
                                ),
                              ),
                            ],
                          );
                        } else return SizedBox();

                      })
                    ],
                  )
                      : SizedBox(),
                  SizedBox(height: 5.h),
                  (meal?.howToPrepare != null)
                      ? Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                              () => MealPlanRecipeDetails(
                            meal: meal,
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
              child: (meal?.itemPhoto != null && meal!.itemPhoto!.isNotEmpty)
                  ? CircleAvatar(
                radius: 8.h,
                backgroundImage: NetworkImage("${meal.itemPhoto}"),
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

  orFiled(int index) {
    if (index.isEven) {
      return const Center(
        child: Text(
          'OR',
          style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  btn() {
    return Center(
      child: GestureDetector(
        onTap: () {
          print("(presentDay).toString(): ${(presentDay).toString()}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => TrackerUI(
                  from: ProgramMealType.transition.name,
                  proceedProgramDayModel: ProceedProgramDayModel(day: (presentDay == 0 ? 1 : presentDay).toString()),
                  trackerVideoLink: widget.trackerVideoLink
              ),),);
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
    );
  }

  /// this function is used for rotatedbox click events
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
                    "You Have completed the Nourish Plan, Now you can proceed to Post Program",
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



/*
old ui
 */
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gwc_customer/model/combined_meal_model/detox_nourish_model/child_nourish_model.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sizer/sizer.dart';
// import '../../model/combined_meal_model/new_prep_model.dart';
// import '../../model/error_model.dart';
// import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
// import '../../model/program_model/start_post_program_model.dart';
// import '../../repository/api_service.dart';
// import '../../repository/post_program_repo/post_program_repository.dart';
// import '../../services/post_program_service/post_program_service.dart';
// import '../../utils/app_config.dart';
// import '../../widgets/constants.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../dashboard_screen.dart';
// import '../prepratory plan/new/meal_plan_recipe_details.dart';
// import '../program_plans/day_tracker_ui/day_tracker.dart';
// import '../program_plans/meal_pdf.dart';
// import '../program_plans/program_start_screen.dart';
//
// class NourishPlanScreen extends StatefulWidget {
//   final ChildNourishModel prepPlanDetails;
//   final String? totalDays;
//   final int selectedDay;
//   final bool viewDay1Details;
//   final bool isPrepStarted;
//   final String? trackerVideoLink;
//   final String? postProgramStage;
//
//   const NourishPlanScreen({
//     Key? key,
//     required this.prepPlanDetails,
//     this.selectedDay = 1,
//     this.totalDays,
//     this.isPrepStarted = false,
//     this.trackerVideoLink,
//     this.postProgramStage,
//     this.viewDay1Details = false,
//   }) : super(key: key);
//
//   @override
//   State<NourishPlanScreen> createState() => _NourishPlanScreenState();
// }
//
// class _NourishPlanScreenState extends State<NourishPlanScreen>
//     with TickerProviderStateMixin {
//   AnimationController? _animationController;
//   Offset checkedPositionOffset = Offset(0, 0);
//   Offset lastCheckOffset = Offset(0, 0);
//   Offset animationOffset = Offset(0, 0);
//   late Animation _animation;
//
//   bool isPostProgramStarted = false;
//
//   TabController? _tabController;
//
//   ChildNourishModel? _childPrepModel;
//   Map<String, TransSubItems> slotNamesForTabs = {};
//   int tabSize = 1;
//
//   String selectedSlot = "";
//   String selectedItemName = "";
//   int selectedIndex = 0;
//   int? presentDay;
//   List<String> _list = [];
//   List<Map<String, List<TransMealSlot>>> selectedTabs = [];
//   String selectedSubTab = "";
//
//   String currentDayStatus = "0";
//   String? previousDayStatus;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getInitialIndex();
//     getPrepItemsAndStore(widget.prepPlanDetails);
//   }
//
//   bool symptomTrackerSheet = false;
//
//   void getPrepItemsAndStore(ChildNourishModel childPrepModel) {
//     _childPrepModel = childPrepModel;
//     print("prep--");
//     print(_childPrepModel!.toJson());
//     if (_childPrepModel != null) {
//       final dataList = _childPrepModel?.data ?? {};
//
//       currentDayStatus = _childPrepModel?.currentDayStatus ?? '0';
//       previousDayStatus = _childPrepModel?.previousDayStatus;
//
//       isPostProgramStarted = _childPrepModel?.isPostProgramStarted == '0' || _childPrepModel?.isPostProgramStarted == 'null'  ? false : true;
//
//       print("previousDayStatus: $previousDayStatus");
//       print("currentDayStatus: $currentDayStatus");
//
//       if(_childPrepModel!.currentDay != null){
//         presentDay = int.tryParse(_childPrepModel!.currentDay!) ?? 1;
//       }
//
//       print("presentDay: $presentDay");
//
//       slotNamesForTabs.addAll(dataList);
//
//       _list.clear();
//       slotNamesForTabs.forEach((key, value) {
//         _list.add(key);
//
//         print("$key ==> ${value.subItems!.length}");
//       });
//     }
//     updateTabSize();
//     _tabController = TabController(vsync: this, length: tabSize);
//
//     if (!widget.viewDay1Details) {
//       if(!isPostProgramStarted){
//         // this is previousDayStatus change from cron
//         // if (previousDayStatus == "0") {
//         // this is when we change from db
//         if (previousDayStatus == "0") {
//           Future.delayed(Duration(seconds: 0)).then((value) {
//             if (!symptomTrackerSheet) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (ctx) => TrackerUI(
//                     from: ProgramMealType.transition.name,
//                     isPreviousDaySheet: true,
//                     proceedProgramDayModel: ProceedProgramDayModel(day: (presentDay!-1).toString()),
//                     trackerVideoLink: widget.trackerVideoLink
//                   ),),);
//
//               // return showSymptomsTrackerSheet(
//               //     context, (int.parse(widget.dayNumber) - 1).toString(),
//               //     isPreviousDaySheet: true)
//               //     .then((value) {
//               //   // when we close bottomsheet from close icon than we r  not calling this
//               //   if (!fromBottomSheet) getTransitionMeals();
//               // });
//             }
//           });
//         }
//         if (_childPrepModel!.isNourishCompleted == "1" &&
//             (widget.postProgramStage == null ||
//                 widget.postProgramStage!.isEmpty))
//           {
//           Future.delayed(Duration(seconds: 0)).then((value) {
//             return buildDayCompletedClap();
//           });
//         }
//       }
//         }
//   }
//
//   getInitialIndex() {
//     print("HOur : $selectedIndex ${DateTime.now().hour}");
//     print("HOur : $selectedIndex : ${DateTime.now().hour >= DateTime.now().hour}");
//     if (DateTime.now().hour >= 0 && DateTime.now().hour <= 7) {
//       print(
//           "Early Morning : ${DateTime.now().hour >= 7}");
//       return selectedIndex = 0;
//     } else if (DateTime.now().hour >= 7 && DateTime.now().hour <= 10) {
//       print(
//           "Breakfast : ${DateTime.now().hour <= 7}");
//       return selectedIndex = 1;
//     } else if (DateTime.now().hour >= 10 && DateTime.now().hour <= 12) {
//       print(
//           "Mid Day : ${DateTime.now().hour <= 10}");
//       return selectedIndex = 2;
//     }
//     else if (DateTime.now().hour > 12 && DateTime.now().hour <= 14) {
//       print("Lunch : ${DateTime.now().hour <= 11}");
//       return selectedIndex = 3;
//     }
//     else if (DateTime.now().hour > 14 && DateTime.now().hour <= 18) {
//       print(
//           "Evening : ${DateTime.now().hour <= 13}");
//       return selectedIndex = 4;
//     } else if (DateTime.now().hour > 18 && DateTime.now().hour <= 21) {
//       print(
//           "Dinner : ${DateTime.now().hour <= 18}");
//       return selectedIndex = 5;
//     } else if (DateTime.now().hour > 21 && DateTime.now().hour <= 0) {
//       print(
//           "Post Dinner : ${DateTime.now().hour <= 21}");
//       return selectedIndex = 6;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: tabSize,
//       child: SafeArea(
//         child: Scaffold(
//           // backgroundColor: const Color(0xffC8DE95).withOpacity(0.6),
//             body: StatefulBuilder(
//               builder: (_, setstate) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 1.h),
//                     Text(
//                       'Nourish Phase',
//                       style: TextStyle(
//                           fontFamily: eUser().mainHeadingFont,
//                           color: eUser().mainHeadingColor,
//                           fontSize: eUser().mainHeadingFontSize),
//                     ),
//                     SizedBox(height: 1.h),
//                     Visibility(
//                       visible: !widget.viewDay1Details,
//                       child: Text(
//                         "Day ${presentDay} of Day ${(int.parse(widget.totalDays ?? '0'))}",
//                         // '${(int.parse(totalDays ?? '0') - int.parse(currentDay ?? '0')).abs()} Days Remaining',
//                         style: TextStyle(
//                             fontFamily: eUser().userTextFieldFont,
//                             color: gTextColor,
//                             fontSize: eUser().userTextFieldHintFontSize),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 28.w, vertical: 2.h),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               if (selectedIndex == 0) {
//                               } else {
//                                 setstate(() {
//                                   if (selectedIndex > 0) {
//                                     selectedIndex--;
//                                   }
//                                   updateTabSize();
//                                   print(selectedIndex);
//                                 });
//                               }
//                             },
//                             child: Icon(
//                               Icons.arrow_back_ios,
//                               color: eUser().mainHeadingColor,
//                             ),
//                           ),
//                           FittedBox(
//                             child: Text(
//                               _list[selectedIndex],
//                               style: TextStyle(
//                                   fontFamily: eUser().mainHeadingFont,
//                                   color: eUser().mainHeadingColor,
//                                   fontSize: eUser().mainHeadingFontSize),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               setstate(() {
//                                 if (selectedIndex == _list.length - 1) {
//                                 } else {
//                                   if (selectedIndex >= 0 &&
//                                       selectedIndex != _list.length - 1) {
//                                     selectedIndex++;
//                                   }
//                                   print(selectedIndex);
//                                   updateTabSize();
//                                   print(selectedIndex);
//                                 }
//                               });
//                             },
//                             child: Icon(
//                               Icons.arrow_forward_ios,
//                               color: eUser().mainHeadingColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 1.h),
//                     SizedBox(
//                       height: 3.h,
//                       child: TabBar(
//                         // padding: EdgeInsets.symmetric(horizontal: 3.w),
//                           isScrollable: true,
//                           unselectedLabelColor: tabBarHintColor,
//                           labelColor: gWhiteColor,
//                           controller: _tabController,
//                           unselectedLabelStyle: TextStyle(
//                               fontFamily: kFontBook,
//                               color: gHintTextColor,
//                               fontSize: 9.sp),
//                           labelStyle: TextStyle(
//                               fontFamily: kFontMedium,
//                               color: gBlackColor,
//                               fontSize: 9.sp),
//                           indicator: BoxDecoration(
//                             color: kNumberCircleGreen,
//                             borderRadius: const BorderRadius.only(
//                               topRight: Radius.circular(10),
//                               bottomLeft: Radius.circular(10),
//                             ),
//                           ),
//                           onTap: (index) {
//                             print("ontap: $index");
//                             // print(slotNamesForTabs.keys.elementAt(index));
//                             selectedSlot =
//                                 slotNamesForTabs.keys.elementAt(index);
//                             setState(() {
//                               selectedItemName = slotNamesForTabs[selectedSlot]!.subItems!.keys.first;
//                               print(selectedItemName);
//                             });
//                             // _buildList(index);
//                             // print("ontap: $index");
//                             //
//                             // selectedTabs.forEach((element) {
//                             //   print(element.keys.elementAt(index));
//                             //   setstate(() {
//                             //     selectedSubTab =
//                             //         element.keys.elementAt(index);
//                             //   });
//                             // });
//                           },
//                           tabs: buildTabs()
//                         // [selectedTabs.map((e) => _buildTabs(e)).to]
//
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         margin: EdgeInsets.only(top: 3.h),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 0.w, vertical: 1.h),
//                         decoration: const BoxDecoration(
//                           color: gBackgroundColor,
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(40),
//                               topRight: Radius.circular(40)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: kLineColor,
//                               offset: Offset(2, 3),
//                               blurRadius: 5,
//                             )
//                           ],
//                           // border: Border.all(
//                           //   width: 1,
//                           //   color: kLineColor,
//                           // ),
//                         ),
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: TabBarView(
//                                 controller: _tabController,
//                                 physics:
//                                 const NeverScrollableScrollPhysics(),
//                                 children: buildTabBarView(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             )),
//       ),
//     );
//   }
//
//   buildTabs() {
//     List<Widget> widgetList = [];
//
//     selectedTabs.forEach((element) {
//       element.forEach((key, value) {
//         widgetList.add(Tab(
//           text: key,
//         ));
//       });
//     });
//     return widgetList;
//   }
//
//   updateTabSize() {
//     selectedTabs.clear();
//     slotNamesForTabs.forEach((key, value) {
//       if (_list[selectedIndex] == key) {
//         print("tabsize: ${value.subItems!.length}");
//         setState(() {
//           tabSize = value.subItems!.length;
//           selectedTabs.add(value.subItems!.cast<String, List<TransMealSlot>>());
//         });
//       }
//     });
//
//     selectedSubTab = selectedTabs.first.keys.first;
//
//     print("selectedTabs: $selectedTabs");
//   }
//
//   buildTabBarView() {
//     print("buildTabBarView");
//     List<Widget> widgetList = [];
//
//     print(selectedSubTab);
//
//     selectedTabs.forEach((element) {
//       element.forEach((key, value) {
//         widgetList.add(buildTabView(value));
//       });
//     });
//     // selectedTabs.forEach((element) {
//     //   element.forEach((key, value) {
//     //     if(key == selectedSubTab){
//     //       print("$key // $value");
//     //       widgetList.add(buildTabView(value));
//     //     }
//     //   });
//     // });
//
//     return widgetList;
//   }
//
//   buildTabView(List<TransMealSlot> value) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(
//             height: 58.h,
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 // physics: const NeverScrollableScrollPhysics(),
//                 itemCount: value.length,
//                 itemBuilder: (context, index) {
//                   return Row(
//                     children: [
//                       Container(
//                         width: 300,
//                         margin: EdgeInsets.symmetric(
//                           horizontal: 3.w,
//                           vertical: 2.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: gBackgroundColor,
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: buildReceipeDetails(value[index]),
//                       ),
//                       if (value.last.id != value[index].id) orFiled(),
//                     ],
//                   );
//                 }),
//           ),
//           // btn()
//           if (currentDayStatus == "0" && !widget.viewDay1Details) btn(),
//           Visibility(
//             visible: currentDayStatus == "1",
//             child: Center(
//               child: IntrinsicWidth(
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   margin: EdgeInsets.symmetric(vertical: 5),
//                   child: Center(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                               color: gPrimaryColor, shape: BoxShape.circle),
//                           child: Center(
//                             child: Icon(
//                               Icons.done_outlined,
//                               color: gWhiteColor,
//                               size: 3.h,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 8,),
//                         Text(
//                           // "Day ${widget.day} Meal Plan",
//                           "Day ${presentDay} Submitted",
//                           style: TextStyle(
//                               fontFamily: eUser().mainHeadingFont,
//                               color: gTextColor,
//                               fontSize:
//                               eUser().mainHeadingFontSize),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   buildReceipeDetails(TransMealSlot value) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Positioned(
//           bottom: 0,
//           left: 2.w,
//           right: 0,
//           top: 6.h,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 3.w),
//             margin: EdgeInsets.symmetric(horizontal: 2.w),
//             decoration: BoxDecoration(
//               color: gWhiteColor,
//               borderRadius: BorderRadius.circular(40),
//               border:
//               Border.all(color: kLineColor.withOpacity(0.2), width: 0.9),
//               // boxShadow: [
//               //   BoxShadow(
//               //     color: gBlackColor.withOpacity(0.1),
//               //     offset: Offset(2, 3),
//               //     blurRadius: 5,
//               //   )
//               // ],
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 15.h,
//                   ),
//                   Text(
//                     value.name ?? '',
//                     style: TextStyle(
//                         fontFamily: eUser().mainHeadingFont,
//                         color: eUser().mainHeadingColor,
//                         fontSize: eUser().mainHeadingFontSize),
//                   ),
//                   SizedBox(
//                     height: 1.h,
//                   ),
//                   (value.benefits != null)
//                       ? Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ...value.benefits!.split(' -').map((element) {
//                         return Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.circle_sharp,
//                               color: gGreyColor,
//                               size: 1.h,
//                             ),
//                             SizedBox(width: 3.w),
//                             Expanded(
//                               child: Text(
//                                 element.replaceAll("-", "") ?? '',
//                                 style: TextStyle(
//                                     fontFamily: eUser().userTextFieldFont,
//                                     height: 1.5,
//                                     color: eUser().userTextFieldColor,
//                                     fontSize: eUser()
//                                         .userTextFieldHintFontSize),
//                               ),
//                             ),
//                           ],
//                         );
//                       })
//                     ],
//                   )
//                       : SizedBox(),
//                   SizedBox(height: 5.h),
//                   (value.howToPrepare != null)
//                       ? Center(
//                     child: GestureDetector(
//                       onTap: () {
//                         // Get.to(
//                         //       () => MealPlanRecipeDetails(
//                         //     meal: MealSlot.fromJson(value.toJson()),
//                         //   ),
//                         // );
//                       },
//                       child: Container(
//                         // margin: EdgeInsets.symmetric(horizontal: 5.w),
//                         padding: EdgeInsets.symmetric(
//                             vertical: 1.h, horizontal: 5.w),
//                         decoration: BoxDecoration(
//                           color: newDashboardGreenButtonColor,
//                           borderRadius: const BorderRadius.only(
//                             topRight: Radius.circular(15),
//                             bottomLeft: Radius.circular(15),
//                           ),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: kLineColor,
//                               offset: Offset(2, 3),
//                               blurRadius: 5,
//                             )
//                           ],
//                           // border: Border.all(
//                           //   width: 1,
//                           //   color: kLineColor,
//                           // ),
//                         ),
//                         child: Text(
//                           "Recipe",
//                           style: TextStyle(
//                             color: gWhiteColor,
//                             fontFamily: kFontBook,
//                             fontSize: 11.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                       : const SizedBox(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 0.h,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: newDashboardGreenButtonColor,
//               boxShadow: [
//                 BoxShadow(
//                   color: gBlackColor.withOpacity(0.1),
//                   offset: Offset(2, 3),
//                   blurRadius: 5,
//                 )
//               ],
//             ),
//             child: Center(
//               child: (value.itemPhoto != null && value.itemPhoto!.isNotEmpty)
//                   ? CircleAvatar(
//                 radius: 8.h,
//                 backgroundImage: NetworkImage("${value.itemPhoto}"),
//                 //AssetImage("assets/images/Group 3252.png"),
//               )
//                   : CircleAvatar(
//                 radius: 8.h,
//                 backgroundImage: const AssetImage(
//                     "assets/images/meal_placeholder.png"),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   showPdf(String itemUrl) {
//     print(itemUrl);
//     String? url;
//     if (itemUrl.contains('drive.google.com')) {
//       url = itemUrl;
//       // url = 'https://drive.google.com/uc?export=view&id=1LV33e5XOl0YM8r6AqhU6B4oZniWwXcTZ';
//       // String baseUrl = 'https://drive.google.com/uc?export=view&id=';
//       // print(itemUrl.split('/')[5]);
//       // url = baseUrl + itemUrl.split('/')[5];
//     } else {
//       url = itemUrl;
//     }
//     print(url);
//     if (url.isNotEmpty)
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (ctx) => MealPdf(
//                 pdfLink: url!,
//                 heading: url.split('/').last,
//               )));
//   }
//
//   orFiled() {
//     return const Center(
//       child: Text(
//         'OR',
//         style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
//       ),
//     );
//   }
//
//   btn() {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (ctx) => TrackerUI(
//                   from: ProgramMealType.transition.name,
//                 proceedProgramDayModel: ProceedProgramDayModel(day: (presentDay).toString()),
//                   trackerVideoLink: widget.trackerVideoLink
//               ),),);
//           // showSymptomsTrackerSheet(context, widget.dayNumber).then((value) {
//           //   getTransitionMeals();
//           // });
//         },
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 2.h),
//           width: 60.w,
//           height: 5.h,
//           decoration: BoxDecoration(
//             color: eUser().buttonColor,
//             borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
//             // border: Border.all(color: eUser().buttonBorderColor,
//             //     width: eUser().buttonBorderWidth),
//           ),
//           child: Center(
//             child: Text(
//               'Next',
//               // 'Proceed to Day $proceedToDay',
//               style: TextStyle(
//                 fontFamily: eUser().buttonTextFont,
//                 color: eUser().buttonTextColor,
//                 // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
//                 fontSize: eUser().buttonTextSize,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void addAnimation() {
//     _animationController =
//     AnimationController(duration: Duration(milliseconds: 300), vsync: this)
//       ..addListener(() {
//         setState(() {
//           animationOffset =
//               Offset(checkedPositionOffset.dx, _animation.value);
//         });
//       });
//
//     _animation = Tween(begin: lastCheckOffset.dy, end: checkedPositionOffset.dy)
//         .animate(CurvedAnimation(
//         parent: _animationController!, curve: Curves.easeInOutBack));
//     _animationController!.forward();
//   }
//
//   bool isOpened = false;
//
//   buildDayCompletedClap() {
//     return AppConfig().showSheet(
//         context,
//         WillPopScope(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     border: Border.all(color: gMainColor),
//                   ),
//                   child: Lottie.asset(
//                     "assets/lottie/clap.json",
//                     height: 20.h,
//                   ),
//                 ),
//                 SizedBox(height: 1.5.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 3.w),
//                   child: Text(
//                     "You Have completed the Nourish Plan, Now you can proceed to Post Program",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       height: 1.2,
//                       color: gTextColor,
//                       fontSize: bottomSheetSubHeadingXLFontSize,
//                       fontFamily: bottomSheetSubHeadingMediumFont,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isOpened = true;
//                     });
//                     Future.delayed(Duration(seconds: 0)).whenComplete(() {
//                       // openProgressDialog(context);
//                     });
//                     startPostProgram();
//                   },
//                   child: Container(
//                     padding:
//                     EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
//                     decoration: BoxDecoration(
//                       color: gsecondaryColor,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: gMainColor, width: 1),
//                     ),
//                     child: Text(
//                       'Next',
//                       style: TextStyle(
//                         fontFamily: kFontMedium,
//                         color: gWhiteColor,
//                         fontSize: 11.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             onWillPop: () => Future.value(false)),
//         circleIcon: bsHeadPinIcon,
//         bottomSheetHeight: 60.h,
//         isSheetCloseNeeded: true, sheetCloseOnTap: () {
//       Navigator.pop(context);
//       Navigator.pop(context);
//     });
//   }
//
//   startPostProgram() async {
//     final res = await PostProgramService(repository: _postProgramRepository)
//         .startPostProgramService();
//
//     if (res.runtimeType == ErrorModel) {
//       ErrorModel model = res as ErrorModel;
//       Navigator.pop(context);
//       AppConfig().showSnackbar(context, model.message ?? '', isError: true);
//     } else {
//       Navigator.pop(context);
//       if (res.runtimeType == StartPostProgramModel) {
//         StartPostProgramModel model = res as StartPostProgramModel;
//         print("start program: ${model.response}");
//         // AppConfig().showSnackbar(context, "Post Program started" ?? '');
//         Future.delayed(Duration(seconds: 2)).then((value) {
//           Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => DashboardScreen()),
//                   (route) => true);
//         });
//       }
//     }
//   }
//
//   final PostProgramRepository _postProgramRepository = PostProgramRepository(
//     apiClient: ApiClient(
//       httpClient: http.Client(),
//     ),
//   );
//
// }
//
//
// // import 'package:chewie/chewie.dart';
// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';
// // import 'package:get/get.dart';
// // import 'package:gwc_customer/model/error_model.dart';
// // import 'package:gwc_customer/model/prepratory_meal_model/prep_meal_model.dart';
// // import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
// // import 'package:gwc_customer/model/program_model/start_post_program_model.dart';
// // import 'package:gwc_customer/repository/api_service.dart';
// // import 'package:gwc_customer/repository/prepratory_repository/prep_repository.dart';
// // import 'package:gwc_customer/screens/dashboard_screen.dart';
// // import 'package:gwc_customer/screens/prepratory%20plan/new/meal_plan_recipe_details.dart';
// // import 'package:gwc_customer/screens/program_plans/day_tracker_ui/day_tracker.dart';
// // import 'package:gwc_customer/screens/program_plans/meal_pdf.dart';
// // import 'package:gwc_customer/screens/program_plans/program_start_screen.dart';
// // import 'package:gwc_customer/services/post_program_service/post_program_service.dart';
// // import 'package:gwc_customer/utils/app_config.dart';
// // import 'package:gwc_customer/widgets/constants.dart';
// // import 'package:gwc_customer/widgets/vlc_player/vlc_player_with_controls.dart';
// // import 'package:gwc_customer/widgets/widgets.dart';
// // import 'package:lottie/lottie.dart';
// // import 'package:sizer/sizer.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:wakelock_plus/wakelock_plus.dart';
// //
// // import '../../../repository/post_program_repo/post_program_repository.dart';
// // import '../../../services/prepratory_service/prepratory_service.dart';
// // import '../../../widgets/video/normal_video.dart';
// // import '../../model/combined_meal_model/detox_nourish_model/child_nourish_model.dart';
// //
// // class NewTransDesign extends StatefulWidget {
// //   String totalDays;
// //   String dayNumber;
// //   ChildNourishModel childNourishModel;
// //   final String? trackerVideoLink;
// //   final String? postProgramStage;
// //   final bool viewDay1Details;
// //   NewTransDesign(
// //       {Key? key,
// //         required this.dayNumber,
// //         required this.totalDays,
// //         required this.childNourishModel,
// //         this.trackerVideoLink,
// //         this.postProgramStage,
// //         this.viewDay1Details = false})
// //       : super(key: key);
// //
// //   @override
// //   State<NewTransDesign> createState() => _NewTransDesignState();
// // }
// //
// // class _NewTransDesignState extends State<NewTransDesign>
// //     with SingleTickerProviderStateMixin {
// //   TabController? _tabController;
// //   //
// //   // final List<String> _list = [
// //   //   "Breakfast",
// //   //   "Mid Day",
// //   //   "Lunch",
// //   //   "Dinner",
// //   //   "Post Dinner"
// //   // ];
// //
// //   /// this is for storing Early morning, lunch dinner
// //   List<String> _list = [];
// //
// //   Map<String, List<TransMealSlot>> tabs = {};
// //
// //   Map<String, TransSubItems> slotNamesForTabs = {};
// //
// //   int tabSize = 1;
// //
// //   bool showLoading = true;
// //
// //   String selectedItemName = "";
// //
// //   String currentDayStatus = '';
// //
// //   // getTransitionMeals() async {
// //   //   final result = await PrepratoryMealService(repository: repository)
// //   //       .getTransitionMealService();
// //   //
// //   //   if (result.runtimeType == ErrorModel) {
// //   //     final res = result as ErrorModel;
// //   //     return Center(
// //   //       child: Text(
// //   //         res.message ?? '',
// //   //         style: TextStyle(
// //   //           fontSize: 10.sp,
// //   //           fontFamily: kFontMedium,
// //   //         ),
// //   //       ),
// //   //     );
// //   //   } else {
// //   //     TransitionMealModel res = result as TransitionMealModel;
// //   //     currentDayStatus = res.currentDayStatus.toString();
// //   //     print("currentDayStatus top: ${currentDayStatus}");
// //   //     final dataList = res.data ?? {};
// //   //     if (res.currentDay != null) currentDay = res.currentDay;
// //   //     if (res.totalDays != null) totalDays = res.totalDays ?? "1";
// //   //     planNotePdfLink = res.dosDontPdfLink;
// //   //
// //   //     slotNamesForTabs.addAll(dataList);
// //   //
// //   //     _list.clear();
// //   //     slotNamesForTabs.forEach((key, value) {
// //   //       _list.add(key);
// //   //
// //   //       print("$key ==> ${value.subItems!.length}");
// //   //     });
// //   //
// //   //     Future.delayed(Duration.zero).whenComplete(() {
// //   //       if (!widget.viewDay1Details) {
// //   //         print("previous day status: ${res.previousDayStatus}");
// //   //         if (res.previousDayStatus == "0") {
// //   //           Future.delayed(Duration(seconds: 0)).then((value) {
// //   //             if (!symptomTrackerSheet) {
// //   //               Navigator.push(
// //   //                 context,
// //   //                 MaterialPageRoute(
// //   //                   builder: (ctx) => TrackerUI(
// //   //
// //   //                       from: ProgramMealType.transition.name,
// //   //                       isPreviousDaySheet: true,
// //   //                       proceedProgramDayModel: ProceedProgramDayModel(day: (int.parse(widget.dayNumber) - 1).toString()),
// //   //                       trackerVideoLink: widget.trackerVideoLink
// //   //                   ),),);
// //   //
// //   //               // return showSymptomsTrackerSheet(
// //   //               //     context, (int.parse(widget.dayNumber) - 1).toString(),
// //   //               //     isPreviousDaySheet: true)
// //   //               //     .then((value) {
// //   //               //   // when we close bottomsheet from close icon than we r  not calling this
// //   //               //   if (!fromBottomSheet) getTransitionMeals();
// //   //               // });
// //   //             }
// //   //           });
// //   //         }
// //   //         if (res.isTransMealCompleted == "1" &&
// //   //             (widget.postProgramStage == null ||
// //   //                 widget.postProgramStage!.isEmpty)) {
// //   //           Future.delayed(Duration(seconds: 0)).then((value) {
// //   //             return buildDayCompletedClap();
// //   //           });
// //   //         }
// //   //       }
// //   //     });
// //   //
// //   //     updateTabSize();
// //   //   }
// //   //   setState(() {
// //   //     showLoading = false;
// //   //   });
// //   // }
// //
// //   String selectedSubTab = "";
// //   List<Map<String, List<TransMealSlot>>> selectedTabs = [];
// //
// //   updateTabSize() {
// //     selectedTabs.clear();
// //     slotNamesForTabs.forEach((key, value) {
// //       if (_list[selectedIndex] == key) {
// //         print("tabsize: ${value.subItems!.length}");
// //         setState(() {
// //           tabSize = value.subItems!.length;
// //           selectedTabs.add(value.subItems!);
// //         });
// //       }
// //     });
// //
// //     selectedSubTab = selectedTabs.first.keys.first;
// //
// //     print("selectedTabs: $selectedTabs");
// //
// //     setState(() {
// //       showLoading = false;
// //     });
// //   }
// //
// //   buildTimeDate() {
// //     DateTime date = DateTime.now();
// //     String amPm = 'AM';
// //     if (date.hour >= 12) {
// //       amPm = 'PM';
// //     }
// //     String hour = date.hour.toString();
// //     if (date.hour > 12) {
// //       hour = (date.hour - 12).toString();
// //     }
// //
// //     String minute = date.minute.toString();
// //     if (date.minute < 10) {
// //       minute = '0${date.minute}';
// //     }
// //     return "$hour : $minute $amPm";
// //   }
// //
// //   getInitialIndex() {
// //     print("HOur : $selectedIndex");
// //     print("HOur : $selectedIndex : ${DateTime.now()}");
// //     print(DateTime.now().hour >= 18 && DateTime.now().hour == 21);
// //     if (DateTime.now().hour >= 0 && DateTime.now().hour <= 7) {
// //       print(
// //           "Early Morning : ${DateTime.now().hour >= 7}");
// //       return selectedIndex = 0;
// //     } else if (DateTime.now().hour >= 7 && DateTime.now().hour <= 10) {
// //       print(
// //           "Breakfast : ${DateTime.now().hour <= 7}");
// //       return selectedIndex = 1;
// //     } else if (DateTime.now().hour >= 10 && DateTime.now().hour <= 12) {
// //       print(
// //           "Mid Day : ${DateTime.now().hour <= 10}");
// //       return selectedIndex = 2;
// //     }
// //     else if (DateTime.now().hour >= 12 && DateTime.now().hour <= 14) {
// //       print("Lunch : ${DateTime.now().hour <= 11}");
// //       return selectedIndex = 3;
// //     }
// //     else if (DateTime.now().hour >= 14 && DateTime.now().hour <= 18) {
// //       print(
// //           "Evening : ${DateTime.now().hour <= 13}");
// //       return selectedIndex = 4;
// //     } else if (DateTime.now().hour >= 18 && DateTime.now().hour <= 21) {
// //       print(
// //           "Dinner : ${DateTime.now().hour <= 18}");
// //       return selectedIndex = 5;
// //     } else if (DateTime.now().hour >= 21 && DateTime.now().hour <= 0) {
// //       print(
// //           "Post Dinner : ${DateTime.now().hour <= 21}");
// //       return selectedIndex = 6;
// //     }
// //   }
// //
// //   String? planNotePdfLink;
// //   String? currentDay;
// //   String? totalDays;
// //
// //   ChildNourishModel? _childNourishModel;
// //
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //
// //     _childNourishModel = widget.childNourishModel;
// //
// //     currentDay = widget.dayNumber;
// //     totalDays = widget.totalDays;
// //
// //     getInitialIndex();
// //
// //     print("initstate");
// //
// //     // planNotePdfLink = ;
// //
// //     slotNamesForTabs.addAll(_childNourishModel!.data!);
// //
// //
// //     _list.clear();
// //     slotNamesForTabs.forEach((key, value) {
// //       _list.add(key);
// //
// //       print("$key ==> ${value.subItems!.length}");
// //     });
// //
// //     Future.delayed(Duration.zero).whenComplete(() {
// //       if (!widget.viewDay1Details) {
// //         print("previous day status: ${_childNourishModel!.previousDayStatus}");
// //         if (_childNourishModel!.previousDayStatus == "0") {
// //           Future.delayed(Duration(seconds: 0)).then((value) {
// //             if (!symptomTrackerSheet) {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (ctx) => TrackerUI(
// //
// //                       from: ProgramMealType.transition.name,
// //                       isPreviousDaySheet: true,
// //                       proceedProgramDayModel: ProceedProgramDayModel(day: (int.parse(widget.dayNumber) - 1).toString()),
// //                       trackerVideoLink: widget.trackerVideoLink
// //                   ),),);
// //
// //               // return showSymptomsTrackerSheet(
// //               //     context, (int.parse(widget.dayNumber) - 1).toString(),
// //               //     isPreviousDaySheet: true)
// //               //     .then((value) {
// //               //   // when we close bottomsheet from close icon than we r  not calling this
// //               //   if (!fromBottomSheet) getTransitionMeals();
// //               // });
// //             }
// //           });
// //         }
// //         if (_childNourishModel!.isNourishCompleted == "1" &&
// //             (widget.postProgramStage == null ||
// //                 widget.postProgramStage!.isEmpty)) {
// //           Future.delayed(Duration(seconds: 0)).then((value) {
// //             return buildDayCompletedClap();
// //           });
// //         }
// //       }
// //     });
// //
// //     updateTabSize();
// //     // getTransitionMeals();
// //   }
// //
// //   @override
// //   void dispose() {
// //     if (mealPlayerController != null) mealPlayerController!.dispose();
// //     if (_chewieController != null) _chewieController!.dispose();
// //
// //     super.dispose();
// //   }
// //
// //   final PrepratoryRepository repository = PrepratoryRepository(
// //     apiClient: ApiClient(
// //       httpClient: http.Client(),
// //     ),
// //   );
// //
// //   int selectedIndex = 0;
// //   int initialIndex = 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //           backgroundColor: showLoading
// //               ? kWhiteColor
// //               : const Color(0xffC8DE95).withOpacity(0.6),
// //           body: showLoading
// //               ? Center(
// //             child: buildCircularIndicator(),
// //           )
// //               : DefaultTabController(
// //             length: tabSize,
// //             child: StatefulBuilder(
// //               builder: (_, setstate) {
// //                 return Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     SizedBox(height: 1.h),
// //                     Text(
// //                       'Transition Meal Plan',
// //                       style: TextStyle(
// //                           fontFamily: eUser().mainHeadingFont,
// //                           color: eUser().buttonTextColor,
// //                           fontSize: eUser().mainHeadingFontSize),
// //                     ),
// //                     SizedBox(height: 1.h),
// //                     Visibility(
// //                       visible: !widget.viewDay1Details,
// //                       child: Text(
// //                         "Day ${currentDay} of Day ${(int.parse(totalDays ?? '0'))}",
// //                         // '${(int.parse(totalDays ?? '0') - int.parse(currentDay ?? '0')).abs()} Days Remaining',
// //                         style: TextStyle(
// //                             fontFamily: eUser().userTextFieldFont,
// //                             color: eUser().buttonTextColor,
// //                             fontSize: eUser().userTextFieldHintFontSize),
// //                       ),
// //                     ),
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(
// //                           horizontal: 28.w, vertical: 4.h),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: <Widget>[
// //                           GestureDetector(
// //                             onTap: () {
// //                               if (selectedIndex == 0) {
// //                               } else {
// //                                 setstate(() {
// //                                   if (selectedIndex > 0) {
// //                                     selectedIndex--;
// //                                   }
// //                                   updateTabSize();
// //                                   print(selectedIndex);
// //                                 });
// //                               }
// //                             },
// //                             child: Icon(
// //                               Icons.arrow_back_ios,
// //                               color: eUser().buttonTextColor,
// //                             ),
// //                           ),
// //                           FittedBox(
// //                             child: Text(
// //                               _list[selectedIndex],
// //                               style: TextStyle(
// //                                   fontFamily: eUser().mainHeadingFont,
// //                                   color: eUser().buttonTextColor,
// //                                   fontSize: eUser().mainHeadingFontSize),
// //                             ),
// //                           ),
// //                           GestureDetector(
// //                             onTap: () {
// //                               setstate(() {
// //                                 if (selectedIndex == _list.length - 1) {
// //                                 } else {
// //                                   if (selectedIndex >= 0 &&
// //                                       selectedIndex != _list.length - 1) {
// //                                     selectedIndex++;
// //                                   }
// //                                   print(selectedIndex);
// //                                   updateTabSize();
// //                                   print(selectedIndex);
// //                                 }
// //                               });
// //                             },
// //                             child: Icon(
// //                               Icons.arrow_forward_ios,
// //                               color: eUser().buttonTextColor,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       height: 30,
// //                       child: TabBar(
// //                         // padding: EdgeInsets.symmetric(horizontal: 3.w),
// //                           isScrollable: true,
// //                           unselectedLabelColor: tabBarHintColor,
// //                           labelColor: gBlackColor,
// //                           controller: _tabController,
// //                           unselectedLabelStyle: TextStyle(
// //                               fontFamily: kFontBook,
// //                               color: gHintTextColor,
// //                               fontSize: 9.sp),
// //                           labelStyle: TextStyle(
// //                               fontFamily: kFontMedium,
// //                               color: gBlackColor,
// //                               fontSize: 9.sp),
// //                           indicator: BoxDecoration(
// //                             color: gWhiteColor,
// //                             borderRadius: const BorderRadius.only(
// //                               topRight: Radius.circular(10),
// //                               bottomLeft: Radius.circular(10),
// //                             ),
// //                           ),
// //                           onTap: (index) {
// //                             print("ontap: $index");
// //
// //                             selectedTabs.forEach((element) {
// //                               print(element.keys.elementAt(index));
// //                               setstate(() {
// //                                 selectedSubTab =
// //                                     element.keys.elementAt(index);
// //                               });
// //                             });
// //                           },
// //                           tabs: buildTabs()
// //                         // [selectedTabs.map((e) => _buildTabs(e)).to]
// //
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: Container(
// //                         margin: EdgeInsets.only(top: 3.h),
// //                         padding: EdgeInsets.symmetric(
// //                             horizontal: 0.w, vertical: 1.h),
// //                         decoration: const BoxDecoration(
// //                           color: gBackgroundColor,
// //                           borderRadius: BorderRadius.only(
// //                               topLeft: Radius.circular(40),
// //                               topRight: Radius.circular(40)),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: kLineColor,
// //                               offset: Offset(2, 3),
// //                               blurRadius: 5,
// //                             )
// //                           ],
// //                           // border: Border.all(
// //                           //   width: 1,
// //                           //   color: kLineColor,
// //                           // ),
// //                         ),
// //                         child: Column(
// //                           children: [
// //                             Expanded(
// //                               child: TabBarView(
// //                                 controller: _tabController,
// //                                 physics:
// //                                 const NeverScrollableScrollPhysics(),
// //                                 children: buildTabBarView(),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           )),
// //     );
// //   }
// //
// //   buildTabs() {
// //     List<Widget> widgetList = [];
// //
// //     selectedTabs.forEach((element) {
// //       element.forEach((key, value) {
// //         widgetList.add(Tab(
// //           text: key,
// //         ));
// //       });
// //     });
// //     return widgetList;
// //   }
// //
// //   buildTabBarView() {
// //     print("buildTabBarView");
// //     List<Widget> widgetList = [];
// //
// //     print(selectedSubTab);
// //
// //     selectedTabs.forEach((element) {
// //       element.forEach((key, value) {
// //         widgetList.add(buildTabView(value));
// //       });
// //     });
// //     // selectedTabs.forEach((element) {
// //     //   element.forEach((key, value) {
// //     //     if(key == selectedSubTab){
// //     //       print("$key // $value");
// //     //       widgetList.add(buildTabView(value));
// //     //     }
// //     //   });
// //     // });
// //
// //     return widgetList;
// //   }
// //
// //   buildTabView(List<TransMealSlot> value) {
// //     return SingleChildScrollView(
// //       child: Column(
// //         children: [
// //           SizedBox(
// //             height: 58.h,
// //             child: ListView.builder(
// //                 shrinkWrap: true,
// //                 scrollDirection: Axis.horizontal,
// //                 // physics: const NeverScrollableScrollPhysics(),
// //                 itemCount: value.length,
// //                 itemBuilder: (context, index) {
// //                   return Row(
// //                     children: [
// //                       Container(
// //                         width: 300,
// //                         margin: EdgeInsets.symmetric(
// //                           horizontal: 3.w,
// //                           vertical: 2.h,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: gBackgroundColor,
// //                           borderRadius: BorderRadius.circular(40),
// //                         ),
// //                         child: buildReceipeDetails(value[index]),
// //                       ),
// //                       if (value.last.id != value[index].id) orFiled(),
// //                     ],
// //                   );
// //                 }),
// //           ),
// //           // btn()
// //           if (currentDayStatus == "0" && !widget.viewDay1Details) btn(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   buildReceipeDetails(TransMealSlot value) {
// //     return Stack(
// //       fit: StackFit.expand,
// //       children: [
// //         Positioned(
// //           bottom: 0,
// //           left: 2.w,
// //           right: 0,
// //           top: 6.h,
// //           child: Container(
// //             padding: EdgeInsets.symmetric(horizontal: 3.w),
// //             margin: EdgeInsets.symmetric(horizontal: 2.w),
// //             decoration: BoxDecoration(
// //               color: gWhiteColor,
// //               borderRadius: BorderRadius.circular(40),
// //               border:
// //               Border.all(color: kLineColor.withOpacity(0.2), width: 0.9),
// //               // boxShadow: [
// //               //   BoxShadow(
// //               //     color: gBlackColor.withOpacity(0.1),
// //               //     offset: Offset(2, 3),
// //               //     blurRadius: 5,
// //               //   )
// //               // ],
// //             ),
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   SizedBox(
// //                     height: 15.h,
// //                   ),
// //                   Text(
// //                     value.name ?? '',
// //                     style: TextStyle(
// //                         fontFamily: eUser().mainHeadingFont,
// //                         color: eUser().mainHeadingColor,
// //                         fontSize: eUser().mainHeadingFontSize),
// //                   ),
// //                   SizedBox(
// //                     height: 1.h,
// //                   ),
// //                   (value.benefits != null)
// //                       ? Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       ...value.benefits!.split(' -').map((element) {
// //                         return Row(
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           children: [
// //                             Icon(
// //                               Icons.circle_sharp,
// //                               color: gGreyColor,
// //                               size: 1.h,
// //                             ),
// //                             SizedBox(width: 3.w),
// //                             Expanded(
// //                               child: Text(
// //                                 element.replaceAll("-", "") ?? '',
// //                                 style: TextStyle(
// //                                     fontFamily: eUser().userTextFieldFont,
// //                                     height: 1.5,
// //                                     color: eUser().userTextFieldColor,
// //                                     fontSize: eUser()
// //                                         .userTextFieldHintFontSize),
// //                               ),
// //                             ),
// //                           ],
// //                         );
// //                       })
// //                     ],
// //                   )
// //                       : SizedBox(),
// //                   SizedBox(height: 5.h),
// //                   (value.howToPrepare != null)
// //                       ? Center(
// //                     child: GestureDetector(
// //                       onTap: () {
// //                         Get.to(
// //                               () => MealPlanRecipeDetails(
// //                             meal: MealSlot.fromJson(value.toJson()),
// //                           ),
// //                         );
// //                       },
// //                       child: Container(
// //                         // margin: EdgeInsets.symmetric(horizontal: 5.w),
// //                         padding: EdgeInsets.symmetric(
// //                             vertical: 1.h, horizontal: 5.w),
// //                         decoration: BoxDecoration(
// //                           color: newDashboardGreenButtonColor,
// //                           borderRadius: const BorderRadius.only(
// //                             topRight: Radius.circular(15),
// //                             bottomLeft: Radius.circular(15),
// //                           ),
// //                           boxShadow: const [
// //                             BoxShadow(
// //                               color: kLineColor,
// //                               offset: Offset(2, 3),
// //                               blurRadius: 5,
// //                             )
// //                           ],
// //                           // border: Border.all(
// //                           //   width: 1,
// //                           //   color: kLineColor,
// //                           // ),
// //                         ),
// //                         child: Text(
// //                           "Recipe",
// //                           style: TextStyle(
// //                             color: gWhiteColor,
// //                             fontFamily: kFontBook,
// //                             fontSize: 11.sp,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   )
// //                       : const SizedBox(),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         Positioned(
// //           top: 0.h,
// //           left: 0,
// //           right: 0,
// //           child: Container(
// //             padding: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               color: newDashboardGreenButtonColor,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: gBlackColor.withOpacity(0.1),
// //                   offset: Offset(2, 3),
// //                   blurRadius: 5,
// //                 )
// //               ],
// //             ),
// //             child: Center(
// //               child: (value.itemPhoto != null && value.itemPhoto!.isNotEmpty)
// //                   ? CircleAvatar(
// //                 radius: 8.h,
// //                 backgroundImage: NetworkImage("${value.itemPhoto}"),
// //                 //AssetImage("assets/images/Group 3252.png"),
// //               )
// //                   : CircleAvatar(
// //                 radius: 8.h,
// //                 backgroundImage: const AssetImage(
// //                     "assets/images/meal_placeholder.png"),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   showPdf(String itemUrl) {
// //     print(itemUrl);
// //     String? url;
// //     if (itemUrl.contains('drive.google.com')) {
// //       url = itemUrl;
// //       // url = 'https://drive.google.com/uc?export=view&id=1LV33e5XOl0YM8r6AqhU6B4oZniWwXcTZ';
// //       // String baseUrl = 'https://drive.google.com/uc?export=view&id=';
// //       // print(itemUrl.split('/')[5]);
// //       // url = baseUrl + itemUrl.split('/')[5];
// //     } else {
// //       url = itemUrl;
// //     }
// //     print(url);
// //     if (url.isNotEmpty)
// //       Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //               builder: (ctx) => MealPdf(
// //                 pdfLink: url!,
// //                 heading: url.split('/').last,
// //               )));
// //   }
// //
// //   orFiled() {
// //     return const Center(
// //       child: Text(
// //         'OR',
// //         style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
// //       ),
// //     );
// //   }
// //
// //   btn() {
// //     return Center(
// //       child: GestureDetector(
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (ctx) => TrackerUI(
// //                   from: ProgramMealType.transition.name,
// //                   proceedProgramDayModel: ProceedProgramDayModel(day: widget.dayNumber),
// //                   trackerVideoLink: widget.trackerVideoLink
// //               ),),);
// //           // showSymptomsTrackerSheet(context, widget.dayNumber).then((value) {
// //           //   getTransitionMeals();
// //           // });
// //         },
// //         child: Container(
// //           margin: EdgeInsets.symmetric(vertical: 2.h),
// //           width: 60.w,
// //           height: 5.h,
// //           decoration: BoxDecoration(
// //             color: eUser().buttonColor,
// //             borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
// //             // border: Border.all(color: eUser().buttonBorderColor,
// //             //     width: eUser().buttonBorderWidth),
// //           ),
// //           child: Center(
// //             child: Text(
// //               'Next',
// //               // 'Proceed to Day $proceedToDay',
// //               style: TextStyle(
// //                 fontFamily: eUser().buttonTextFont,
// //                 color: eUser().buttonTextColor,
// //                 // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
// //                 fontSize: eUser().buttonTextSize,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   bool showMealVideo = false;
// //
// //   videoMp4Widget({required VoidCallback onTap, String? videoName}) {
// //     return InkWell(
// //       onTap: onTap,
// //       child: Card(
// //           child: Row(children: [
// //             Image.asset(
// //               "assets/images/meal_placeholder.png",
// //               height: 35,
// //               width: 40,
// //             ),
// //             Expanded(
// //                 child: Text(
// //                   videoName ?? "Symptom Tracker.mp4",
// //                   style: TextStyle(fontFamily: kFontBook),
// //                 )),
// //             Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Image.asset(
// //                 "assets/images/arrow_for_video.png",
// //                 height: 35,
// //               ),
// //             )
// //           ])),
// //     );
// //   }
// //
// //   VideoPlayerController? mealPlayerController;
// //   ChewieController? _chewieController;
// //
// //   addUrlToVideoPlayerChewie(String url) async {
// //     print("url" + url);
// //     mealPlayerController = VideoPlayerController.network(url);
// //     _chewieController = ChewieController(
// //         videoPlayerController: mealPlayerController!,
// //         aspectRatio: 16 / 9,
// //         autoInitialize: true,
// //         showOptions: false,
// //         autoPlay: true,
// //         allowedScreenSleep: false,
// //         hideControlsTimer: Duration(seconds: 3),
// //         showControls: false);
// //     if (await Wakelock.enabled == false) {
// //       Wakelock.enable();
// //     }
// //   }
// //   // VlcPlayerController? _mealPlayerController;
// //   // final _trackerSheetKey = GlobalKey<VlcPlayerWithControlsState>();
// //   //
// //   // addUrlToVideoPlayer(String url) async {
// //   //   print("url" + url);
// //   //   _mealPlayerController = VlcPlayerController.network(
// //   //     Uri.parse(url).toString(),
// //   //     // url,
// //   //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
// //   //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
// //   //     hwAcc: HwAcc.auto,
// //   //     autoPlay: true,
// //   //     options: VlcPlayerOptions(
// //   //       advanced: VlcAdvancedOptions([
// //   //         VlcAdvancedOptions.networkCaching(2000),
// //   //       ]),
// //   //       subtitle: VlcSubtitleOptions([
// //   //         VlcSubtitleOptions.boldStyle(true),
// //   //         VlcSubtitleOptions.fontSize(30),
// //   //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
// //   //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
// //   //         // works only on externally added subtitles
// //   //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
// //   //       ]),
// //   //       http: VlcHttpOptions([
// //   //         VlcHttpOptions.httpReconnect(true),
// //   //       ]),
// //   //       rtp: VlcRtpOptions([
// //   //         VlcRtpOptions.rtpOverRtsp(true),
// //   //       ]),
// //   //     ),
// //   //   );
// //   //   if (await Wakelock.enabled == false) {
// //   //     Wakelock.enable();
// //   //   }
// //   // }
// //
// //   buildMealVideo({required VoidCallback onTap}) {
// //     if (mealPlayerController != null) {
// //       return Column(
// //         children: [
// //           Stack(
// //             children: [
// //               AspectRatio(
// //                 aspectRatio: 16 / 9,
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(5),
// //                     border: Border.all(color: gPrimaryColor, width: 1),
// //                   ),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(5),
// //                     child: Center(
// //                       child: OverlayVideo(
// //                         isControlsVisible: false,
// //                         controller: _chewieController!,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Positioned(
// //                   child: AspectRatio(
// //                     aspectRatio: 16 / 9,
// //                     child: GestureDetector(
// //                       onTap: () {
// //                         print("onTap");
// //                         if (_chewieController != null) {
// //                           if (_chewieController!
// //                               .videoPlayerController.value.isPlaying) {
// //                             _chewieController!.videoPlayerController.pause();
// //                           } else {
// //                             _chewieController!.videoPlayerController.play();
// //                           }
// //                         }
// //                       },
// //                     ),
// //                   ))
// //             ],
// //           ),
// //           Center(
// //               child: IconButton(
// //                 icon: Icon(
// //                   Icons.cancel_outlined,
// //                   color: gsecondaryColor,
// //                 ),
// //                 onPressed: onTap,
// //               ))
// //         ],
// //       );
// //     } else {
// //       return SizedBox.shrink();
// //     }
// //   }
// //
// //   bool symptomTrackerSheet = false;
// //
// //   bool fromBottomSheet = false;
// //
// //   Future showSymptomsTrackerSheet(BuildContext context, String day,
// //       {bool isPreviousDaySheet = false}) {
// //     symptomTrackerSheet = true;
// //     return AppConfig().showSheet(
// //         context,
// //         StatefulBuilder(builder: (_, setState) {
// //           return WillPopScope(
// //               child: Column(
// //                 children: [
// //                   videoMp4Widget(
// //                       videoName: "Know more about Symptoms Tracker",
// //                       onTap: () {
// //                         if (widget.trackerVideoLink == null) {
// //                           Future.delayed(Duration.zero).whenComplete(() {
// //                             Get.snackbar(
// //                               "",
// //                               'Video link is Empty',
// //                               titleText: SizedBox.shrink(),
// //                               colorText: gWhiteColor,
// //                               snackPosition: SnackPosition.BOTTOM,
// //                               backgroundColor:
// //                               gsecondaryColor.withOpacity(0.55),
// //                             );
// //                           });
// //                         } else {
// //                           addUrlToVideoPlayerChewie(
// //                               widget.trackerVideoLink ?? '');
// //                           setState(() {
// //                             showMealVideo = true;
// //                           });
// //                         }
// //                       }),
// //                   Stack(
// //                     children: [
// //                       TrackerUI(
// //                         from: ProgramMealType.transition.name,
// //                         proceedProgramDayModel:
// //                         ProceedProgramDayModel(day: day),
// //                       ),
// //                       Visibility(
// //                         visible: showMealVideo,
// //                         child: Positioned(child:
// //                         Center(child: buildMealVideo(onTap: () async {
// //                           setState(() {
// //                             showMealVideo = false;
// //                           });
// //                           if (await Wakelock.enabled == true) {
// //                             Wakelock.disable();
// //                           }
// //                           if (mealPlayerController != null)
// //                             mealPlayerController!.dispose();
// //                           if (_chewieController != null)
// //                             _chewieController!.dispose();
// //
// //                           // await _mealPlayerController!.stopRendererScanning();
// //                           // await _mealPlayerController!.dispose();
// //                         }))),
// //                       )
// //                     ],
// //                   )
// //                 ],
// //               ),
// //               onWillPop: () => isPreviousDaySheet
// //                   ? Future.value(false)
// //                   : Future.value(false));
// //         }),
// //         circleIcon: bsHeadPinIcon,
// //         bottomSheetHeight: 90.h,
// //         isSheetCloseNeeded: true,
// //         sheetCloseOnTap: () {
// //           if (isPreviousDaySheet) {
// //             fromBottomSheet = true;
// //             Navigator.pop(context);
// //             Navigator.pop(context);
// //           } else {
// //             Navigator.pop(context);
// //           }
// //         });
// //     return showModalBottomSheet(
// //         isDismissible: false,
// //         isScrollControlled: true,
// //         backgroundColor: Colors.transparent,
// //         context: context,
// //         enableDrag: false,
// //         builder: (ctx) {
// //           return Wrap(
// //             children: [
// //               TrackerUI(
// //                 from: ProgramMealType.transition.name,
// //                 proceedProgramDayModel: ProceedProgramDayModel(day: day),
// //               )
// //             ],
// //           );
// //         }).then((value) {
// //       setState(() {});
// //       // getTransitionMeals();
// //     });
// //   }
// //
// //   bool isOpened = false;
// //
// //   buildDayCompletedClap() {
// //     return AppConfig().showSheet(
// //         context,
// //         WillPopScope(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               children: [
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(5),
// //                     border: Border.all(color: gMainColor),
// //                   ),
// //                   child: Lottie.asset(
// //                     "assets/lottie/clap.json",
// //                     height: 20.h,
// //                   ),
// //                 ),
// //                 SizedBox(height: 1.5.h),
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 3.w),
// //                   child: Text(
// //                     "You Have completed the Transition Plan, Now you can proceed to Post Program",
// //                     textAlign: TextAlign.center,
// //                     style: TextStyle(
// //                       height: 1.2,
// //                       color: gTextColor,
// //                       fontSize: bottomSheetSubHeadingXLFontSize,
// //                       fontFamily: bottomSheetSubHeadingMediumFont,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 5.h),
// //                 GestureDetector(
// //                   onTap: () {
// //                     setState(() {
// //                       isOpened = true;
// //                     });
// //                     Future.delayed(Duration(seconds: 0)).whenComplete(() {
// //                       // openProgressDialog(context);
// //                     });
// //                     startPostProgram();
// //                   },
// //                   child: Container(
// //                     padding:
// //                     EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
// //                     decoration: BoxDecoration(
// //                       color: gsecondaryColor,
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(color: gMainColor, width: 1),
// //                     ),
// //                     child: Text(
// //                       'Next',
// //                       style: TextStyle(
// //                         fontFamily: kFontMedium,
// //                         color: gWhiteColor,
// //                         fontSize: 11.sp,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             onWillPop: () => Future.value(false)),
// //         circleIcon: bsHeadPinIcon,
// //         bottomSheetHeight: 60.h,
// //         isSheetCloseNeeded: true, sheetCloseOnTap: () {
// //       Navigator.pop(context);
// //       Navigator.pop(context);
// //     });
// //   }
// //
// //   startPostProgram() async {
// //     final res = await PostProgramService(repository: _postProgramRepository)
// //         .startPostProgramService();
// //
// //     if (res.runtimeType == ErrorModel) {
// //       ErrorModel model = res as ErrorModel;
// //       Navigator.pop(context);
// //       AppConfig().showSnackbar(context, model.message ?? '', isError: true);
// //     } else {
// //       Navigator.pop(context);
// //       if (res.runtimeType == StartPostProgramModel) {
// //         StartPostProgramModel model = res as StartPostProgramModel;
// //         print("start program: ${model.response}");
// //         // AppConfig().showSnackbar(context, "Post Program started" ?? '');
// //         Future.delayed(Duration(seconds: 2)).then((value) {
// //           Navigator.pushAndRemoveUntil(
// //               context,
// //               MaterialPageRoute(builder: (_) => DashboardScreen()),
// //                   (route) => true);
// //         });
// //       }
// //     }
// //   }
// //
// //   final PostProgramRepository _postProgramRepository = PostProgramRepository(
// //     apiClient: ApiClient(
// //       httpClient: http.Client(),
// //     ),
// //   );
// // }
