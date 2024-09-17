import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import '../../../model/combined_meal_model/get_user_yoga_list_model.dart';
import '../../../model/error_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/program_repository/program_repository.dart';
import '../../../services/program_service/program_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../../profile_screens/my_yoga_screens/meal_plan_yoga_video.dart';

class MyYogaScreen extends StatefulWidget {
  const MyYogaScreen({Key? key}) : super(key: key);

  @override
  State<MyYogaScreen> createState() => _MyYogaScreenState();
}

class _MyYogaScreenState extends State<MyYogaScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  final _pref = AppConfig().preferences!;
  String userId = "";

  @override
  void initState() {
    super.initState();
    print("User Id : ${_pref.getInt(AppConfig.userId)}");
    getProgramData(userId);
  }

  final List<Map<String, String>> yogaTimeLists = [
    {
      "time": "B/W 6-8am",
    },
    {
      "time": "B/W 6-8pm",
    },
    {
      "time": "During Sleep",
    },
  ];

  late Map<String, List<YogaList>> groupedItems;
  late List<String> uniqueTypes;
  List<YogaList> yogaLists = [];

  List<YogaList> morningList = [];
  List<YogaList> eveningList = [];
  List<YogaList> nightList = [];

  bool showProgress = false;

  getProgramData(String userId) async {
    setState(() {
      showProgress = true;
    });

    print("YOGA LIST");

    final result = await ProgramService(repository: repository)
        .getUserYogaListService("${_pref.getInt(AppConfig.userId)}");
    print("result: $result");

    if (result.runtimeType == GetUserYogaListModel) {
      GetUserYogaListModel model = result as GetUserYogaListModel;

      yogaLists = model.data ?? [];

      groupItemsByType(yogaLists);

      groupedItems = groupItemsByType(yogaLists);
      uniqueTypes = groupedItems.keys.toList();

      print("UNIQUE TYPES : $uniqueTypes");

      print("UNIQUE TYPES : $groupedItems");

      if (model.data != null) {
        model.data?.forEach((e) {
          if (e.time == "B/W 6-8am") {
            morningList.add(e);
          } else if (e.time == "B/W 6-8pm") {
            eveningList.add(e);
          } else if (e.time == "During Sleep") {
            nightList.add(e);
          }
        });
      }
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showProgress = false;
    });
    print(result);
  }

  Map<String, List<YogaList>> groupItemsByType(List<YogaList> items) {
    Map<String, List<YogaList>> groupedItems = {};

    for (var item in items) {
      String type = item.time!;
      if (!groupedItems.containsKey(type)) {
        groupedItems[type] = [];
      }
      groupedItems[type]!.add(item);
    }
    return groupedItems;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(
              () {
                Navigator.pop(context);
              },
              isBackEnable: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: Text(
                "My Yoga's",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: kFontBold, color: gBlackColor, fontSize: 16.dp),
              ),
            ),
            (showProgress)
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      child: buildCircularIndicator(),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            morningList.isNotEmpty
                                ? buildTimeTapWidget(
                                    "B/W 6-8am",
                                    () {},
                                    0,
                                  )
                                : const SizedBox(),
                            eveningList.isNotEmpty
                                ? buildTimeTapWidget(
                                    "B/W 6-8pm",
                                    () {},
                                    1,
                                  )
                                : const SizedBox(),
                            nightList.isNotEmpty
                                ? buildTimeTapWidget(
                                    "During Sleep",
                                    () {},
                                    2,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      selectedTime == 0
                          ? yogaListWidget(morningList)
                          : selectedTime == 1
                              ? yogaListWidget(eveningList)
                              : yogaListWidget(nightList),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  int selectedTime = 0;

  void onTimeTapped(int index) {
    setState(() {
      selectedTime = index;
      print("selectedTime : $selectedTime");
    });
  }

  buildTimeTapWidget(
    String title,
    func,
    int index,
  ) {
    bool isSelected = selectedTime == index;
    return GestureDetector(
      onTap: () => onTimeTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? gsecondaryColor.withOpacity(0.1)
              : profileBackGroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? gBlackColor : gGreyColor.withOpacity(0.5),
            fontFamily: kFontMedium,
            fontSize: 15.dp,
          ),
        ),
      ),
    );
  }

  yogaListWidget(List<YogaList> list) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            // height: 70.h,
            width: MediaQuery.of(context).size.shortestSide > 600
                ? 40.w
                : double.maxFinite,
            child: Stack(
              children: [
                Container(
                  height: 50.h,
                  margin: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: MediaQuery.of(context).size.shortestSide > 600
                          ? 7.w
                          : 10.w),
                  decoration: BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: PageView.builder(
                    itemCount: list.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      YogaList lst = list[index];
                      return Column(
                        children: [
                          SizedBox(height: 4.h),
                          // Text(
                          //   lst.time ?? '',
                          //   style: TextStyle(
                          //     height: 1.5,
                          //     color: MealPlanConstants().mealNameTextColor,
                          //     fontSize: 15.dp,
                          //     fontFamily: MealPlanConstants().mealNameFont,
                          //   ),
                          // ),
                          Container(
                            height: 120,
                            width: 160,
                            margin: EdgeInsets.only(top: 2.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/yoga_placeholder.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (areAnyTwoParametersNotEmpty(lst.url,
                                  lst.audioOnlyUrl, lst.videoOnlyUrl)) {
                                showVideoType(lst);
                              } else {
                                if (lst.url.isNotEmpty) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MealPlanYogaVideo(
                                        videoUrl: lst.url.toString(),
                                        heading: lst.name.toString(),
                                      ),
                                    ),
                                  );
                                } else if (lst.audioOnlyUrl.isNotEmpty) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MealPlanYogaVideo(
                                        videoUrl: lst.audioOnlyUrl.toString(),
                                        heading: lst.name.toString(),
                                      ),
                                    ),
                                  );
                                } else if (lst.videoOnlyUrl.isNotEmpty) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MealPlanYogaVideo(
                                        videoUrl: lst.videoOnlyUrl.toString(),
                                        heading: lst.name.toString(),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: SizedBox(
                              height: 12.h,
                              child: Lottie.asset(
                                  'assets/lottie/Animation - 1701175879899.json'),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            lst.name ?? '',
                            style: TextStyle(
                              fontSize: MealPlanConstants().mealNameFontSize,
                              fontFamily: MealPlanConstants().mealNameFont,
                              color: gHintTextColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              list.length > 1 ? Positioned(
                  top: 15.h,
                  left: 0.w,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: previousPage,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      margin: EdgeInsets.only(bottom: 18.h, left: 5.w),
                      decoration: const BoxDecoration(
                        color: gWhiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: gGreyColor,
                          size: 4.h,
                        ),
                      ),
                    ),
                  ),
                ) : const SizedBox(),
                list.length > 1 ?  Positioned(
                  top: 15.h,
                  right: 0.w,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      nextPage(list);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      margin: EdgeInsets.only(bottom: 18.h, right: 5.w),
                      decoration: const BoxDecoration(
                        color: gWhiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: gGreyColor,
                          size: 4.h,
                        ),
                      ),
                    ),
                  ),
                ) : const SizedBox(),
              ],
            ),
          ),
        ),
        list.length > 1 ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            list.length,
            (index) => buildDot(index, yogaLists[index].time),
          ),
        ) : const SizedBox(),
      ],
    );
  }

  void nextPage(List<YogaList> lst) {
    if (currentPage < lst.length - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildDot(int index, String? time) {
    bool isSelected = currentPage == index;
    // bool morningTime = time == "B/W 6-8am";
    // bool eveningTime = time == "B/W 6-8pm";
    // bool nightTime = time == "During Sleep";

    // if (morningTime) {
    //   return AnimatedContainer(
    //     duration: const Duration(milliseconds: 300),
    //     margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2.h),
    //     height: 12,
    //     width: isSelected ? 24 : 12,
    //     decoration: BoxDecoration(
    //       color: isSelected
    //           ? morningTime
    //               ? gsecondaryColor
    //               : gGreyColor
    //           : Colors.transparent,
    //       borderRadius: BorderRadius.circular(6),
    //     ),
    //   );
    // } else if (eveningTime) {
    //   return AnimatedContainer(
    //     duration: const Duration(milliseconds: 300),
    //     margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2.h),
    //     height: 12,
    //     width: isSelected ? 24 : 12,
    //     decoration: BoxDecoration(
    //       color: isSelected
    //           ? eveningTime
    //               ? kNumberCirclePurple
    //               : gGreyColor
    //           : Colors.transparent,
    //       borderRadius: BorderRadius.circular(6),
    //     ),
    //   );
    // }else if (nightTime) {
    //   return AnimatedContainer(
    //     duration: const Duration(milliseconds: 300),
    //     margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2.h),
    //     height: 12,
    //     width: isSelected ? 24 : 12,
    //     decoration: BoxDecoration(
    //       color: isSelected
    //           ? nightTime
    //           ? kNumberCircleAmber
    //           : gGreyColor
    //           : Colors.transparent,
    //       borderRadius: BorderRadius.circular(6),
    //     ),
    //   );
    // }else {return Container();}

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2.h),
      height: 12,
      width: isSelected ? 24 : 12,
      decoration: BoxDecoration(
        color: isSelected
            ?  gsecondaryColor : gsecondaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  bool areAnyTwoParametersNotEmpty(
      String? param1, String? param2, String? param3) {
    param1 = param1?.trim() ?? '';
    param2 = param2?.trim() ?? '';
    param3 = param3?.trim() ?? '';
    int nonEmptyCount = 0;
    if (param1.isNotEmpty) nonEmptyCount++;
    if (param2.isNotEmpty) nonEmptyCount++;
    if (param3.isNotEmpty) nonEmptyCount++;

    print("count : $nonEmptyCount");

    return nonEmptyCount >= 2;
  }

  showVideoType(YogaList urls) {
    return Get.bottomSheet(
      StatefulBuilder(builder: (context, setstate) {
        return Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.close,
                    size: 3.h,
                    color: gBlackColor,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 1.5.h),
                  child: Text(
                    'Type',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gBlackColor,
                      fontFamily: kFontBold,
                      fontSize: 18.dp,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Choose how you'd like to play this media",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gBlackColor,
                    fontFamily: kFontMedium,
                    fontSize: 14.dp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.h, bottom: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    urls.audioOnlyUrl.isNotEmpty
                        ? buildContainer(Icons.audiotrack_outlined,
                            "Audio only", () {}, 0, setstate)
                        : const SizedBox(),
                    urls.url.isNotEmpty
                        ? buildContainer(Icons.ondemand_video,
                            "Video with\ninstructions", () {}, 1, setstate)
                        : const SizedBox(),
                    urls.videoOnlyUrl.isNotEmpty
                        ? buildContainer(Icons.video_camera_back_outlined,
                            "Video without\ninstructions", () {}, 2, setstate)
                        : const SizedBox(),
                  ],
                ),
              ),
              Center(
                child: IntrinsicWidth(
                  child: GestureDetector(
                    onTap: () {
                      if (selectedIndex == 0) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MealPlanYogaVideo(
                              videoUrl: urls.audioOnlyUrl.toString(),
                              heading: urls.name.toString(),
                            ),
                          ),
                        );
                      } else if (selectedIndex == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MealPlanYogaVideo(
                              videoUrl: urls.url.toString(),
                              heading: urls.name.toString(),
                            ),
                          ),
                        );
                      } else if (selectedIndex == 2) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MealPlanYogaVideo(
                              videoUrl: urls.videoOnlyUrl.toString(),
                              heading: urls.name.toString(),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 3.h, bottom: 1.h),
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: gsecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily: eUser().buttonTextFont,
                            color: gWhiteColor,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      isDismissible: false,
    );
  }

  int selectedIndex = -1;

  void onItemTapped(int index, Function setstate) {
    setstate(() {
      selectedIndex = index;
      print("selected : $selectedIndex");
    });
  }

  buildContainer(
      IconData icons, String title, func, int index, Function setstate) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index, setstate),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: kLineColor.withOpacity(0.3),
        ),
        child: Container(
          height: 10.h,
          width: 17.w,
          // padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
          color: isSelected ? gsecondaryColor : gWhiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icons,
                color: isSelected ? gWhiteColor : gBlackColor,
                size: 3.5.h,
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? gWhiteColor : gBlackColor,
                  fontFamily: kFontMedium,
                  fontSize: 10.dp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
