import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer_web/screens/home_screens/recent_tips/recent_tips.dart';
import 'package:gwc_customer_web/screens/home_screens/story/home_story.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;

import '../../model/error_model.dart';
import '../../model/home_model/bmi_bmr_model.dart';
import '../../model/new_user_model/about_program_model/about_program_model.dart';
import '../../model/new_user_model/about_program_model/feeds_model/feedsListModel.dart';
import '../../repository/api_service.dart';
import '../../repository/home_repo/home_repository.dart';
import '../../repository/new_user_repository/about_program_repository.dart';
import '../../services/home_service/home_service.dart';
import '../../services/new_user_service/about_program_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../notification_screen.dart';
import 'bmi/bmi_calculate.dart';
import 'gut_health_tracker_screens/parameters_of_tracker.dart';
import 'meal_plan_progress.dart';
import 'water_intake/water_level_screen.dart';
import 'new_screens/fertility_screen.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  // final carouselController = CarouselController();
  String? badgeNotification;
  final SharedPreferences _pref = AppConfig().preferences!;
  String? currentUser,bmi,bmr;
  int _current = 0;
  bool isLoading = false;

  List reviewList = [
    "assets/images/eval.png",
    "assets/images/slide_start_popup.png",
    "assets/images/Pop up.png",
    "assets/images/meal_popup.png",
    "assets/images/chk_user_report.png",
  ];

  @override
  void initState() {
    super.initState();
    getStories();
    getBmiBmrDetails();
    print("_currentUser: ${_pref.getString(AppConfig.User_Name)}");
    currentUser = _pref.getString(AppConfig.User_Name) ?? '';
  }

  String generateAvatarFromName(String string, int limitTo) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0; i < (limitTo); i++) {
      buffer.write(split[i][0]);
    }
    return buffer.toString();
  }

  Future? feedsListFuture;

  List<FeedsListModel> storyList = [];

  List<FeedsListModel> scrollList = [];

  List<FeedsListModel> recentTipsList = [];

  late final AboutProgramService aboutProgramService =
      AboutProgramService(repository: repository);

  late final HomeService homeService =
  HomeService(repository: homeRepository);

  getStories() async {
    setState(() {
      isLoading = true;
    });
    final result =
        await aboutProgramService.serverAboutProgramService().then((value) {
      print("result: $value");

      if (value.runtimeType == AboutProgramModel) {
        setState(() {
          isLoading = false;
        });

        print("Ticket List");
        AboutProgramModel model = value as AboutProgramModel;
        if (model.data?.feedsList != null) {
          for (var element in model.data!.feedsList!) {
            print("element :$element");
            if (element.feed?.isFeed == "2") {
              storyList.add(element);

              print("story : $storyList");
            }

            if (element.feed?.isFeed == "5") {
              scrollList.add(element);

              print("recentTipsList : $recentTipsList");
            }

            if (element.feed?.isFeed == "4") {
              recentTipsList.add(element);

              print("recentTipsList : $recentTipsList");
            }
          }
        }
      } else {
        ErrorModel model = value as ErrorModel;
        setState(() {
          isLoading = false;
        });
        print("error: ${model.message}");
      }

      print(value);
    });
  }

  getBmiBmrDetails() async {
    final result =
    await homeService.getBmiBmrService().then((value) {
      print("result: $value");

      if (value.runtimeType == BmiBmrModel) {
        print("Ticket List");
        BmiBmrModel model = value as BmiBmrModel;
        setState(() {
          bmi = model.data?.bmi;
          bmr = model.data?.bmr;
        });
      } else {
        ErrorModel model = value as ErrorModel;
        print("error: ${model.message}");
      }
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.w, bottom: 1.h, top: 1.h),
              child: buildAppBar(
                () {},
                badgeNotification: badgeNotification,
                showNotificationIcon: true,
                isBackEnable: false,
                showLogo: false,
                showChild: true,
                notificationOnTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 2.5.h,
                      backgroundColor: kNumberCircleRed,
                      child: Center(
                        child: Text(
                          generateAvatarFromName("$currentUser", 2),
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().userFieldLabelFontSize,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello..!!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().mainHeadingFont,
                            fontSize: eUser().userFieldLabelFontSize,
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          "$currentUser",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().userFieldLabelFontSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            (isLoading)
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    child: buildCircularIndicator(),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeStory(
                            storyList: storyList,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: const Divider(
                              color: kLineColor,
                              thickness: 1,
                            ),
                          ),
                          buildCards(),
                          buildYourActivity(),
                          RecentTips(
                            recentTipsList: recentTipsList,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  buildCards() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
      child: Column(
        children: [
          SizedBox(
            height: 18.h,
            width: double.maxFinite,
            child: CarouselSlider(
              // carouselController: carouselController,
              options: CarouselOptions(
                  viewportFraction: .6,
                  aspectRatio: 1.2,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: scrollList
                  .map(
                    (e) => Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: kNumberCircleRed.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                            "${e.feed?.photo}",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // child: Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(bottom: 1.h),
                      //     child: Text(
                      //       "${e.feed?.title}",
                      //       style: TextStyle(
                      //         color: eUser().threeBounceIndicatorColor,
                      //         fontFamily: eUser().userFieldLabelFont,
                      //         fontSize: eUser().anAccountTextFontSize,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: scrollList.map((url) {
              int index = scrollList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? gsecondaryColor
                      : kNumberCircleRed.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  buildYourActivity() {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h, left: 2.w, right: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "Your Activity",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: eUser().mainHeadingColor,
                fontFamily: eUser().mainHeadingFont,
                fontSize: eUser().buttonTextSize,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 20.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCircleAmber,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gGreyColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(
                            "assets/images/faq/challenges_faq.png"),
                        height: 6.h,
                        color: eUser().threeBounceIndicatorColor,
                      ),
                      SizedBox(height: 1.h),
                      // Text(
                      //   "Start to track your meal progress",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: eUser().threeBounceIndicatorColor,
                      //     fontFamily: eUser().userTextFieldFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      Text(
                        "Lets click start to calculate Water Level",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: eUser().threeBounceIndicatorColor,
                          fontFamily: eUser().userTextFieldFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return WaterLevelScreen();
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 1.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: kNumberCircleRed,
                              borderRadius: BorderRadius.circular(
                                  eUser().buttonBorderRadius),
                              // border: Border.all(
                              //     color: eUser().buttonBorderColor,
                              //     width: eUser().buttonBorderWidth
                              // ),
                            ),
                            child: Center(
                              child: Text(
                                'START',
                                style: TextStyle(
                                  fontFamily: eUser().buttonTextFont,
                                  color: eUser().buttonTextColor,
                                  fontSize: eUser().resendOtpFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCirclePurple,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gBlackColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                              "assets/images/faq/challenges_faq.png"),
                          height: 5.h,
                          color: eUser().threeBounceIndicatorColor,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Your BMI : $bmi, BMR : $bmr\nLets click start to calculate your BMI",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().resendOtpFontSize,
                          ),
                        ),
                        IntrinsicWidth(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const BMICalculate();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 1.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: kNumberCircleRed,
                                borderRadius: BorderRadius.circular(
                                    eUser().buttonBorderRadius),
                                // border: Border.all(
                                //     color: eUser().buttonBorderColor,
                                //     width: eUser().buttonBorderWidth
                                // ),
                              ),
                              child: Center(
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                    fontFamily: eUser().buttonTextFont,
                                    color: eUser().buttonTextColor,
                                    fontSize: eUser().resendOtpFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCircleAmber,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gGreyColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(
                            "assets/images/faq/challenges_faq.png"),
                        height: 6.h,
                        color: eUser().threeBounceIndicatorColor,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Start to track your meal progress",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: eUser().threeBounceIndicatorColor,
                          fontFamily: eUser().userTextFieldFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MealPlanProgress();
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 1.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: kNumberCircleRed,
                              borderRadius: BorderRadius.circular(
                                  eUser().buttonBorderRadius),
                              // border: Border.all(
                              //     color: eUser().buttonBorderColor,
                              //     width: eUser().buttonBorderWidth
                              // ),
                            ),
                            child: Center(
                              child: Text(
                                'START',
                                style: TextStyle(
                                  fontFamily: eUser().buttonTextFont,
                                  color: eUser().buttonTextColor,
                                  fontSize: eUser().resendOtpFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCirclePurple,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gBlackColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                              "assets/images/faq/challenges_faq.png"),
                          height: 5.h,
                          color: eUser().threeBounceIndicatorColor,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Fertility Tracker",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                        IntrinsicWidth(
                          child: GestureDetector(
                            // onTap: (showLoginProgress) ? null : () {
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FertilityScreen();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 1.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: kNumberCircleRed,
                                borderRadius: BorderRadius.circular(
                                    eUser().buttonBorderRadius),
                                // border: Border.all(
                                //     color: eUser().buttonBorderColor,
                                //     width: eUser().buttonBorderWidth
                                // ),
                              ),
                              child: Center(
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                    fontFamily: eUser().buttonTextFont,
                                    color: eUser().buttonTextColor,
                                    fontSize: eUser().resendOtpFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCirclePurple,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gBlackColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                              "assets/images/faq/challenges_faq.png"),
                          height: 5.h,
                          color: eUser().threeBounceIndicatorColor,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Gut Health Tracker",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                        IntrinsicWidth(
                          child: GestureDetector(
                            // onTap: (showLoginProgress) ? null : () {
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ParametersOfTracker();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 1.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: kNumberCircleRed,
                                borderRadius: BorderRadius.circular(
                                    eUser().buttonBorderRadius),
                                // border: Border.all(
                                //     color: eUser().buttonBorderColor,
                                //     width: eUser().buttonBorderWidth
                                // ),
                              ),
                              child: Center(
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                    fontFamily: eUser().buttonTextFont,
                                    color: eUser().buttonTextColor,
                                    fontSize: eUser().resendOtpFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final HomeRepository homeRepository = HomeRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
