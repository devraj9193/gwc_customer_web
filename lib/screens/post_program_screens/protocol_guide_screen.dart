import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/post_program_model/protocol_guide_day_score.dart';
import 'package:gwc_customer_web/repository/post_program_repo/post_program_repository.dart';
import 'package:gwc_customer_web/screens/post_program_screens/protcol_guide_details.dart';
import 'package:gwc_customer_web/services/post_program_service/post_program_service.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../repository/api_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'guide_status.dart';
import 'package:http/http.dart' as http;

class ProtocolGuideScreen extends StatefulWidget {
  const ProtocolGuideScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolGuideScreen> createState() => _ProtocolGuideScreenState();
}

class _ProtocolGuideScreenState extends State<ProtocolGuideScreen> {
  Future? getDayProtocolFuture;
  String selectedStatus = "";
  Color? containerColor;
  List optionSelectedList = [];

  String protocolGuidePdfLink = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFuture();
  }

  getFuture({String? dayNumber}) {
    getDayProtocolFuture = PostProgramService(repository: postProgramRepository).getProtocolDayDetailsService(dayNumber: dayNumber);
  }

  PostProgramRepository postProgramRepository =
      PostProgramRepository(apiClient: ApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildAppBar(() {
                    Navigator.pop(context);
                  }),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProtocolGuideDetails(pdfLink: protocolGuidePdfLink,),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 3.5.h,
                      child: Lottie.asset('assets/lottie/alert.json'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            FutureBuilder(
                future: getDayProtocolFuture,
                builder: (_, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if (snapshot.hasData) {
                      optionSelectedList.clear();
                      if (snapshot.data.runtimeType == ErrorModel) {
                        ErrorModel model = snapshot.data as ErrorModel;
                        return Center(child: Text(model.message ?? ''));
                      } else {
                        ProtocolGuideDayScoreModel model =
                        snapshot.data as ProtocolGuideDayScoreModel;
                        optionSelectedList.add(model.breakfast);
                        optionSelectedList.add(model.lunch);
                        optionSelectedList.add(model.dinner);
                        protocolGuidePdfLink = model.protocolGuidePdf ?? '';
                        print("optionSelectedList: $optionSelectedList");
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Protocol Guide",
                                    style: TextStyle(
                                        fontFamily: "GothamBold",
                                        color: gPrimaryColor,
                                        fontSize: 12.sp),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    "Day ${model.day}",
                                    style: TextStyle(
                                        fontFamily: "GothamMedium",
                                        color: gPrimaryColor,
                                        fontSize: 9.sp),
                                  ),
                                  buildReactions(model.score),
                                ],
                              ),
                            ),
                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 6.w),
                              margin: EdgeInsets.symmetric(vertical: 1.h),
                              color: gHintTextColor.withOpacity(0.1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Score : ${model.score}",
                                    style: TextStyle(
                                        fontFamily: kFontBook,
                                        color: gBlackColor,
                                        fontSize: 9.sp),
                                  ),
                                  Text(
                                    "Percentage: ${model.percentage.toString()}",
                                    style: TextStyle(
                                        fontFamily: "GothamBook",
                                        color: gBlackColor,
                                        fontSize: 9.sp),
                                  ),
                                ],
                              ),
                            ),
                            buildTile(
                              "assets/lottie/breakfast.json",
                              "BreakFast",
                              optionSelectedList[0].toString(),
                              model.day,
                            ),
                            buildTile(
                              "assets/lottie/lunch.json",
                              "Lunch",
                              optionSelectedList[1].toString(),
                              model.day,
                            ),
                            buildTile(
                              "assets/lottie/dinner.json",
                              "Dinner",
                              optionSelectedList[2].toString(),
                              model.day,
                            ),
                          ],
                        );
                      }
                    }
                    else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                  }
                  return SizedBox(
                    height: 80.h,
                    child: buildCircularIndicator(),
                  );
                })
          ],
        ),
      ),
    );
  }

  buildTile(String lottie, String title, String value, int? day) {
    print(value);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 3.w),
      margin: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: buildTextColor(value),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Lottie.asset(lottie, height: 7.h),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: "GothamBook",
                color: value == '0' ? gBlackColor : gWhiteColor,
                fontSize: 11.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // print(optionSelectedList[index].runtimeType);
              await Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => GuideStatus(
                    title: title,
                    dayNumber: day,
                    isSelected: value != '0',
                  ),
                ),
              )
                  .then((value) {
                    print("pop value $value");
                if (value != null) {
                  // setState(() {
                  //   selectedStatus = value;
                  // });
                  print("day== $day" );
                  getFuture(dayNumber: day.toString());
                  setState(() {

                  });
                }
              });
            },
            child: Image(
              image: const AssetImage("assets/images/noun-arrow-1018952.png"),
              height: 2.5.h,
              color: value == '0' ? gBlackColor : gWhiteColor,
            ),
          )
        ],
      ),
    );
  }

  buildReactions(int? score) {
    if (score == 1) {
      return Lottie.asset('assets/lottie/boy_waiting.json');
    } else if (score == 2) {
      return Lottie.asset('assets/lottie/boy_looking_error.json');
    } else if (score == 3) {
      return Lottie.asset('assets/lottie/happy_boy.json');
    } else {
      return Lottie.asset('assets/lottie/women_saying_hi.json');
    }
  }

  Color? buildTextColor(String value) {
    if (value == '1') {
      return containerColor = gPrimaryColor;
    } else if (value == '2') {
      return containerColor = gsecondaryColor;
    } else if (value == '3') {
      return containerColor = gMainColor;
    } else {
      return containerColor = gWhiteColor;
    }
  }
}
