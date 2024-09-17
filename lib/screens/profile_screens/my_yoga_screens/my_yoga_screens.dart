import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:gwc_customer_web/screens/profile_screens/my_yoga_screens/yoga_audio_screen.dart';
import 'package:http/http.dart' as http;
import '../../../model/combined_meal_model/get_user_yoga_list_model.dart';
import '../../../model/error_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/program_repository/program_repository.dart';
import '../../../services/program_service/program_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'meal_plan_yoga_video.dart';

class MyYogaScreens extends StatefulWidget {
  const MyYogaScreens({Key? key}) : super(key: key);

  @override
  State<MyYogaScreens> createState() => _MyYogaScreensState();
}

class _MyYogaScreensState extends State<MyYogaScreens> {
  final _pref = AppConfig().preferences!;
  String userId = "";

  @override
  void initState() {
    super.initState();
    print("User Id : ${_pref.getInt(AppConfig.userId)}");
    getProgramData(userId);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                "My Yoga's",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: kFontBold, color: gBlackColor, fontSize: 16.dp),
              ),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: SingleChildScrollView(
                child: (showProgress)
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.h),
                          child: buildCircularIndicator(),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Center(
                          child: SizedBox(width: MediaQuery.of(context).size.shortestSide > 600 ? 40.w : double.maxFinite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildMorningList(),
                                buildEveningList(),
                                buildNightList(),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildMorningList() {
    return morningList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Text(
                  "B/W 6-8am",
                  style: TextStyle(
                    height: 1.5,
                    color: MealPlanConstants().mealNameTextColor,
                    fontSize: 15.dp,
                    fontFamily: MealPlanConstants().mealNameFont,
                  ),
                ),
              ),
              buildYogaLists(morningList),
            ],
          )
        : const SizedBox();
  }

  buildEveningList() {
    return eveningList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Text(
                  "B/W 6-8pm",
                  style: TextStyle(
                    height: 1.5,
                    color: MealPlanConstants().mealNameTextColor,
                    fontSize: 15.dp,
                    fontFamily: MealPlanConstants().mealNameFont,
                  ),
                ),
              ),
              buildYogaLists(eveningList),
            ],
          )
        : const SizedBox();
  }

  buildNightList() {
    return nightList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Text(
                  "During Sleep",
                  style: TextStyle(
                    height: 1.5,
                    color: MealPlanConstants().mealNameTextColor,
                    fontSize: 15.dp,
                    fontFamily: MealPlanConstants().mealNameFont,
                  ),
                ),
              ),
              buildYogaLists(nightList),
            ],
          )
        : const SizedBox();
  }

  buildYogaLists(List<YogaList> lst) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: lst.length,
      itemBuilder: ((context, index) {
        YogaList e = lst[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          if (areAnyTwoParametersNotEmpty(
                              e.url, e.audioOnlyUrl, e.videoOnlyUrl)) {
                            showVideoType(e);
                          } else {
                            if (e.url.isNotEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MealPlanYogaVideo(
                                    videoUrl: e.url.toString(),
                                    heading: e.name.toString(),
                                  ),
                                ),
                              );
                            } else if (e.audioOnlyUrl.isNotEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MealPlanYogaVideo(
                                    videoUrl: e.audioOnlyUrl.toString(),
                                    heading: e.name.toString(),
                                  ),
                                ),
                              );
                            } else if (e.videoOnlyUrl.isNotEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MealPlanYogaVideo(
                                    videoUrl: e.videoOnlyUrl.toString(),
                                    heading: e.name.toString(),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 120,
                          width: 160,
                          margin: EdgeInsets.only(top: 0.6.h),
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
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name ?? '',
                            style: TextStyle(
                                fontSize: MealPlanConstants().mealNameFontSize,
                                fontFamily: MealPlanConstants().mealNameFont,
                                color: gHintTextColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        );
      }),
    );
  }

  bool areAnyTwoParametersNotEmpty(
      String? param1, String? param2, String? param3) {
    // Convert null values to empty strings for easier comparison
    param1 = param1?.trim() ?? '';
    param2 = param2?.trim() ?? '';
    param3 = param3?.trim() ?? '';

    // Check if at least two parameters are not empty
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
                padding: EdgeInsets.only(top: 3.h,bottom: 1.h),
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
                      margin: EdgeInsets.only(top: 3.h,bottom: 1.h),
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
        margin: EdgeInsets.symmetric(horizontal: 3.w),
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
