/*
After NutriDelight api
not using this screen
 */

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/prepratory_meal_model/prep_meal_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/prepratory_repository/prep_repository.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/new/dos_donts_program_screen.dart';
import 'package:gwc_customer_web/screens/program_plans/meal_pdf.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
import '../../../model/combined_meal_model/meal_slot_model.dart';
import '../../../services/prepratory_service/prepratory_service.dart';
import 'meal_plan_recipe_details.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PreparatoryPlanScreen extends StatefulWidget {
  String? totalDays;
  String? dayNumber;
  bool viewDay1Details;
  bool isPrepStarted;
  PreparatoryPlanScreen(
      {Key? key,
        required this.dayNumber,
        required this.totalDays,
        this.viewDay1Details = false,
        this.isPrepStarted = false,
      })
      : super(key: key);

  @override
  State<PreparatoryPlanScreen> createState() => _PreparatoryPlanScreenState();
}

class _PreparatoryPlanScreenState extends State<PreparatoryPlanScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final List<String> _list = ["MAINS", "CHUTNEYS", "JUICES", "SOUPS"];

  Offset checkedPositionOffset = Offset(0, 0);
  Offset lastCheckOffset = Offset(0, 0);

  Offset animationOffset = Offset(0, 0);
  late Animation _animation;
  AnimationController? _animationController;

  String? planNotePdfLink;

  Map<String, SubItems> slotNamesForTabs = {};
  int tabSize = 1;

  bool showLoading = true;

  String selectedSlot = "";
  String selectedItemName = "";

  String? doDontPdfLink;

  getPrepratoryMeals() async {
    final result = await PrepratoryMealService(repository: repository)
        .getPrepratoryMealService();

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
      PrepratoryMealModel res = result as PrepratoryMealModel;
      final dataList = res.data ?? {};
      print("dataList ==> $dataList");
      planNotePdfLink = res.note;
      doDontPdfLink = res.dosDontPdfLink;
      if (res.days != null) totalDays = res.days;
      if (res.currentDay != null) dayNumber = res.currentDay;

      slotNamesForTabs.addAll(dataList);

      slotNamesForTabs.forEach((key, value) {
        print("$key == ${value.subItems}");
      });
      selectedSlot = slotNamesForTabs.keys.first;
      selectedItemName = slotNamesForTabs.values.first.subItems!.keys.first;
      tabSize = slotNamesForTabs.length;

      print("selectedItemName: $selectedItemName");

      print("tabSize: $tabSize");

      // return SizedBox();
      // return customMealPlanTile(dataList);
    }
    setState(() {
      showLoading = false;
    });
    _tabController = TabController(vsync: this, length: tabSize);
  }

  String? totalDays;
  String? dayNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalDays = widget.totalDays;
    dayNumber = widget.dayNumber;
    getPrepratoryMeals();
  }

  final PrepratoryRepository repository = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("build called");
    return SafeArea(
      child: Scaffold(
        backgroundColor: gBackgroundColor,
        body: showLoading
            ? Center(
          child: buildCircularIndicator(),
        )
            : DefaultTabController(
          length: tabSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
                child: buildAppBar(
                        () {
                      Navigator.pop(context);
                    },
                    showHelpIcon: true,
                    helpOnTap: (){
                      // if(doDontPdfLink != null || doDontPdfLink!.isNotEmpty){
                      //   Navigator.push(context, MaterialPageRoute(builder: (ctx)=>
                      //       MealPdf(pdfLink: doDontPdfLink! ,
                      //           heading: doDontPdfLink?.split('/').last ?? '',
                      //           isVideoWidgetVisible: false,
                      //           headCircleIcon: bsHeadPinIcon,
                      //           topHeadColor: kBottomSheetHeadGreen,
                      //           isSheetCloseNeeded: true,
                      //           sheetCloseOnTap: (){
                      //             Navigator.pop(context);
                      //           }
                      //       )));
                      // }
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> DosDontsProgramScreen(pdfLink: doDontPdfLink!,)));
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3.w,top: 2.h,bottom: 1.h),
                child: Text(
                  'Preparatory Phase',
                  style: TextStyle(
                      fontFamily: eUser().mainHeadingFont,
                      color: eUser().mainHeadingColor,
                      fontSize: eUser().mainHeadingFontSize),
                ),
              ),
              widget.isPrepStarted ?   Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Text(
                  'Day ${widget.dayNumber} of Day ${widget.totalDays}',
                  style: TextStyle(
                      fontFamily: kFontMedium,
                      color: eUser().mainHeadingColor,
                      fontSize: 10.sp),
                ),
              ) : SizedBox(),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  buildTabBarIndex() {
    print("Tab : ${_tabController?.previousIndex}");
    // if (_tabController?.index == 1) {
    //   for (int i = 0; i < _list.length; i++) {
    //     WidgetList.add(
    //       GestureDetector(
    //         onTap: () {
    //           indexChecked(i);
    //         },
    //         child: VerticalText(
    //           _list1[i],
    //           // _keys[i],
    //           checkIndex == i &&
    //               (_animationController != null &&
    //                   _animationController!.isCompleted),
    //         ),
    //       ),
    //     );
    //   }
    // }
  }

  // veticalSliderText() {
  //   return RotatedBox(
  //     quarterTurns: 3,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
  //       decoration: widget.checked
  //           ? const BoxDecoration(
  //               color: gWhiteColor,
  //               borderRadius: BorderRadius.only(
  //                 topRight: Radius.circular(20),
  //                 bottomLeft: Radius.circular(20),
  //               ),
  //             )
  //           : const BoxDecoration(),
  //       child: Text(
  //         widget.name,
  //         style: TextStyle(
  //           color: widget.checked ? gBlackColor : gWhiteColor,
  //           fontSize: 16,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
        ),
      ],
    );
  }

  buildReceipeDetails(MealSlot meal) {
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
                    height: 20.h,
                  ),
                  Text(
                    meal.name ?? '',
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  (meal.benefits != null)
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...meal.benefits!.split('-').map((element) {
                        if(element.isNotEmpty) return Row(
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
                                element ?? '',
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
                        else return SizedBox();

                      })
                    ],
                  )
                      : const SizedBox(),
                  SizedBox(height: 5.h),
                  (meal.howToPrepare != null)
                      ? GestureDetector(
                    onTap: () {
                      Get.to(
                            () => MealPlanRecipeDetails(
                          // meal: meal,
                        ),
                      );
                    },
                    child: Center(
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 5.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
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
                )
              ],
            ),
            child: Center(
              child: CircleAvatar(
                  radius: 8.h,
                  backgroundImage:
                  CachedNetworkImageProvider(meal.itemPhoto ?? '')
                // AssetImage("assets/images/Group 3252.png"),
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
}
