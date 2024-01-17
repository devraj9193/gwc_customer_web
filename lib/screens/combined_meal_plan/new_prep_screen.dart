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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../model/combined_meal_model/meal_slot_model.dart';
import '../../model/combined_meal_model/new_prep_model.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../prepratory plan/new/meal_plan_recipe_details.dart';
import '../prepratory plan/prepratory_meal_completed_screen.dart';

class NewPrepScreen extends StatefulWidget {
  final ChildPrepModel prepPlanDetails;
  final int selectedDay;
  final int? totalDays;

  /// this will be used when we came from start program screen
  final bool viewDay1Details;

  NewPrepScreen({
    Key? key,
    required this.prepPlanDetails,
    this.selectedDay = 1,
    this.viewDay1Details = false,
    this.totalDays,
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
    getPrepItemsAndStore(widget.prepPlanDetails);
    getInitialIndex();
    // selectedItemName = slotNamesForTabs.values.first.subItems!.keys.first;
  }

  int selectedIndex = 0;

  bool showPrepTrackerBtn = false;
  final _pref = AppConfig().preferences;
  late bool isPrepTrackerCompleted =
      _pref?.getBool(AppConfig.isPrepTrackerCompleted) ?? false;

  getInitialIndex() {
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

  void getPrepItemsAndStore(ChildPrepModel childPrepModel) {
    _childPrepModel = childPrepModel;
    print("prep--");
    print(_childPrepModel!.toJson());
    if (_childPrepModel != null) {
      slotNamesForTabs.addAll(_childPrepModel!.details!);

      print(slotNamesForTabs);

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
              padding: EdgeInsets.only(left: 3.w, top: 2.h, bottom: 0.h),
              child: Text(
                'Preparatory Phase',
                style: TextStyle(
                    fontFamily: eUser().mainHeadingFont,
                    color: eUser().mainHeadingColor,
                    fontSize: eUser().mainHeadingFontSize),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Text(
                (presentDay == 0)
                    ? 'Your Prep will start from tomorrow'
                    : presentDay == null
                        ? 'Day 1 of Day ${totalDays}'
                        : 'Day ${presentDay} of Day ${totalDays}',
                style: TextStyle(
                    fontFamily: kFontMedium,
                    color: eUser().mainHeadingColor,
                    fontSize: 12.dp),
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
                            fontSize: 12.dp),
                        labelStyle: TextStyle(
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                            fontSize: 15.dp),
                        indicatorColor: newDashboardGreenButtonColor,
                        labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                        indicatorPadding:
                            EdgeInsets.symmetric(horizontal: -2.w),
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
                            selectedItemName = slotNamesForTabs[selectedSlot]!
                                .subItems!
                                .keys
                                .first;
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
          child: SizedBox(
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
                      if (meals.length > 1) orFiled(index),
                    ],
                  );
                }),
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
                builder: (context) => PrepratoryMealCompletedScreen()),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          left: 2.w,
          right: 0,
          top: 6.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            margin: EdgeInsets.symmetric(horizontal: 0.w),
            decoration: BoxDecoration(
              color: gWhiteColor,
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 13.h,
                  ),
                  Text(
                    meal?.name ?? '',
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize),
                  ),
                  SizedBox(height: 2.h),
                  (meal?.benefits != null)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...meal!.benefits!.split('* ').map((element) {
                              if (element.isNotEmpty) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.3.h),
                                      child: Icon(
                                        Icons.circle_sharp,
                                        color: gGreyColor,
                                        size: 1.5.h,
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    Expanded(
                                      child: Text(
                                        element ?? '',
                                        style: TextStyle(
                                            fontFamily:
                                                eUser().userTextFieldFont,
                                            height: 1.2,
                                            color: eUser().userTextFieldColor,
                                            fontSize: eUser()
                                                .userTextFieldHintFontSize),
                                      ),
                                    ),
                                  ],
                                );
                              } else
                                return SizedBox();
                            })
                          ],
                        )
                      : const SizedBox(),
                  (widget.viewDay1Details)
                      ? const SizedBox()
                      : (meal!.howToPrepare != null)
                          ? GestureDetector(
                              onTap: () {
                                print("/// Recipe Details ///");
                                Get.to(
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
              child: CircleAvatar(
                  radius: 7.h,
                  backgroundImage: NetworkImage(meal?.itemPhoto ?? '')
                  // AssetImage("assets/images/Group 3252.png"),
                  ),
            ),
          ),
        ),
      ],
    );
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
                  key.capitalize ?? '',
                  style: TextStyle(
                    color:
                        selectedItemName == key ? gBlackColor : gHintTextColor,
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
