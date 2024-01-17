import 'package:flutter/material.dart';
import 'package:gwc_customer_web/screens/home_screens/gut_health_tracker_screens/sweat_quality_screen.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;

import '../../../model/error_model.dart';
import '../../../model/success_message_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/home_repo/home_repository.dart';
import '../../../services/home_service/home_service.dart';
import '../../../utils/SharedPreferenceUtil.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class HungerQualityScreen extends StatefulWidget {
  const HungerQualityScreen({Key? key}) : super(key: key);

  @override
  State<HungerQualityScreen> createState() => _HungerQualityScreenState();
}

class _HungerQualityScreenState extends State<HungerQualityScreen> {
  int selectedQue1 = -1;

  bool isSyncing = false;

  int? healthy, unhealthy = 0;
  String overall = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          buildHunger(),
          Image(
            height: 15.h,
            image: const AssetImage(
                "assets/images/gut_health_tracker/Mask Group 6.png"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: 1.h, top: 1.h),
            child: buildAppBar(
              () {
                Navigator.pop(context);
              },
              showNotificationIcon: false,
              isBackEnable: false,
              showLogo: true,
              showChild: false,
            ),
          ),
        ],
      ),
    );
  }

  buildHeadingText(String title) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: eUser().mainHeadingColor,
        fontFamily: eUser().userFieldLabelFont,
        fontSize: eUser().buttonTextSize,
      ),
    );
  }

  buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: const Divider(
        color: Color(0xffD1D1D1),
        height: 0.5,
        thickness: 0.5,
      ),
    );
  }

  buildHungerSelection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 18.h, left: 5.w, right: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How do I know if I am Hunger?",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: eUser().mainHeadingColor,
                  fontFamily: eUser().userFieldLabelFont,
                  fontSize: eUser().buttonTextSize,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "When:",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: eUser().mainHeadingColor,
                  fontFamily: eUser().userFieldLabelFont,
                  fontSize: eUser().buttonTextSize,
                ),
              ),
              CheckboxListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                dense: true,
                title: Text(
                  'I Feel the need to eat, but you can wait',
                  style: buildTextStyle(
                    color: selectedQue1 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue1 == 0 ? kFontMedium : kFontBook,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: gsecondaryColor,
                value: selectedQue1 == 0 ? true : false,
                onChanged: (value) {
                  if (value!) {
                    setState(() {
                      selectedQue1 = 0;
                    });
                  }
                },
              ),
              CheckboxListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                dense: true,
                title: Text(
                  'My Stomach starts to growl',
                  style: buildTextStyle(
                    color: selectedQue1 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue1 == 1 ? kFontMedium : kFontBook,
                  ),
                ),
                activeColor: gsecondaryColor,
                controlAffinity: ListTileControlAffinity.leading,
                value: selectedQue1 == 1 ? true : false,
                onChanged: (value) {
                  if (value!) {
                    setState(() {
                      selectedQue1 = 1;
                    });
                  }
                },
              ),
              CheckboxListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                dense: true,
                title: Text(
                  'I feel agitated, irritable, have low energy levels, stomach growls frequently',
                  style: buildTextStyle(
                    color: selectedQue1 == 2 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue1 == 2 ? kFontMedium : kFontBook,
                  ),
                ),
                activeColor: gsecondaryColor,
                controlAffinity: ListTileControlAffinity.leading,
                value: selectedQue1 == 2 ? true : false,
                onChanged: (value) {
                  if (value!) {
                    setState(() {
                      selectedQue1 = 2;
                    });
                  }
                },
              ),
              CheckboxListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                dense: true,
                title: Text(
                  'I feel weak / dizzy/ burning sensation in stomach',
                  style: buildTextStyle(
                    color: selectedQue1 == 3 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue1 == 3 ? kFontMedium : kFontBook,
                  ),
                ),
                activeColor: gsecondaryColor,
                controlAffinity: ListTileControlAffinity.leading,
                value: selectedQue1 == 3 ? true : false,
                onChanged: (value) {
                  if (value!) {
                    setState(() {
                      selectedQue1 = 3;
                    });
                  }
                },
              ),
              // ...whenCheckBox.map((e) => buildWhenCheckBox(e)).toList(),
              // const Divider(
              //   color: kLineColor,
              //   thickness: 1,
              // ),
              // Text(
              //   "Do you also eat when:",
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     color: eUser().mainHeadingColor,
              //     fontFamily: eUser().userFieldLabelFont,
              //     fontSize: eUser().buttonTextSize,
              //   ),
              // ),
              // ...eatWhenCheckBox
              //     .map((e) => buildEatWhenCheckBox(e))
              //     .toList(),
            ],
          ),
        ),
      ),
    );
  }

  buildHunger() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHungerSelection(),
        InkWell(
          onTap: isSyncing
              ? null
              : () {
                  if (selectedQue1 == -1) {
                    AppConfig().showSnackbar(context, 'Select Hunger Question',
                        isError: true);
                  } else {
                    if (selectedQue1 == 4) {
                      healthy = 1;
                      unhealthy = 1;
                    } else {
                      healthy = 2;
                      unhealthy = 0;
                    }

                    if (healthy! > unhealthy!) {
                      overall = "1";
                      // int val = Integer.valueOf(preferenceSettings.getOnecnt()+1);
                      int val = SharedPreferenceUtil.getInt(
                              AppConfig.gutHealthTrackerOneCount) +
                          1;
                      SharedPreferenceUtil.putInt(
                          AppConfig.gutHealthTrackerOneCount, val);
                    } else if (unhealthy! > healthy!) {
                      overall = "0";
                      // int val = Integer.valueOf(preferenceSettings.getZerocnt()+1);
                      // preferenceSettings.setZerocnt(val);
                      int val = SharedPreferenceUtil.getInt(
                              AppConfig.gutHealthTrackerZeroCount) +
                          1;
                      SharedPreferenceUtil.putInt(
                          AppConfig.gutHealthTrackerZeroCount, val);
                    } else {
                      overall = "1";
                      // int val = Integer.valueOf(preferenceSettings.getOnecnt()+1);
                      // preferenceSettings.setOnecnt(val);
                      int val = SharedPreferenceUtil.getInt(
                              AppConfig.gutHealthTrackerOneCount) +
                          1;
                      SharedPreferenceUtil.putInt(
                          AppConfig.gutHealthTrackerOneCount, val);
                    }
                    // callSaveDataAPI();
                    var data =
                        "Indicates you have true hunger. When you are hungry truly it means, it is the right time to eat your meals. Eating meals when your truly hungers sets functional balance in mind-body";

                    showResultHUngerPopUp(data);
                  }
                },
          child: Center(
            child: IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                margin: EdgeInsets.only(top: 5.h),
                decoration: BoxDecoration(
                  color: kNumberCircleRed,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gGreyColor.withOpacity(0.5),
                      offset: const Offset(4, 5),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: (isSyncing)
                      ? buildThreeBounceIndicator(
                          color: eUser().threeBounceIndicatorColor)
                      : Text(
                          'Submit',
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().mainHeadingFontSize,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Image(
            height: 25.h,
            image: const AssetImage(
                "assets/images/gut_health_tracker/Path 8144.png"),
          ),
        ),
      ],
    );
  }

  void callSaveDataAPI() async {
    setState(() {
      isSyncing = true;
    });

    Map sendDetailsMap = {
      "fem_id": SharedPreferenceUtil.getString(AppConfig.USER_ID),
      "tools_id": '2',
      "tool_categorie_id": '2',
      "healthy": healthy,
      "unhealthy": unhealthy,
      "healthy_value": overall,
      "overall_value": '',
      "overall_healthy": '',
      "overall_unhealthy": '',
    };

    print(sendDetailsMap);
    final res = await HomeService(repository: repository)
        .gutHealthTrackerService(sendDetailsMap);

    if (res.runtimeType == ErrorModel) {
      setState(() {
        isSyncing = false;
      });
      final result = res as ErrorModel;
      print("Submit error: ${res.message}");
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    } else {
      setState(() {
        isSyncing = false;
      });
      final result = res as SuccessMessageModel;
      // AppConfig().showSnackbar(context, result.errorMsg ?? '');
      String data = '';
      if (selectedQue1 == 4) {
        data =
            "Indicates you are stressed or some functional change has happened in your metabolism. Drink a glass of room temperature water to tune the metabolism. Avoid eating any meal or snack when you are stressed / emotional.";
      } else {
        data =
            "Indicates you have true hunger. When you are hungry truly it means, it is the right time to eat your meals. Eating meals when your truly hungers sets functional balance in mind-body";
      }

      showResultHUngerPopUp(data);
      // bool res = await showBsheetNext();
      print(result);
      print("submit success");
    }

    // var dio = Dio();
    //
    // var body;
    // Response response;
    // try {
    //   response = await dio.post(
    //     Constants.kBaseUrl + 'fem_SaveToolsEvaluation_v1',
    //     queryParameters: {
    //       "fem_id": SharedPreferenceUtil.getString(Constants.kfem_id),
    //       "tools_id": '2',
    //       "tool_categorie_id": '2',
    //       "healthy": healthy,
    //       "unhealthy": unhealthy,
    //       "healthy_value": overall,
    //       "overall_value": '',
    //       "overall_healthy": '',
    //       "overall_unhealthy": '',
    //     },
    //     options: Options(headers: {
    //       HttpHeaders.contentTypeHeader: "application/json",
    //     }, contentType: 'application/json; charset=UTF-8'),
    //   );
    //   setState(() {
    //     _isSyncing = false;
    //   });
    //   body = json.decode(response.toString());
    //
    //   if (response.statusCode == 200) {
    //     Map loginMap = jsonDecode(response.toString());
    //
    //     body = json.decode(response.toString());
    //     print(response.toString());
    //
    //     if (body['status'] == 'success') {
    //       Constants.toastMessage(body['msg']);
    //
    //       String data = '';
    //       if (selectedQue1 == 4) {
    //         data =
    //         "Indicates you are stressed or some functional change has happened in your metabolism. Drink a glass of room temperature water to tune the metabolism. Avoid eating any meal or snack when you are stressed / emotional.";
    //       } else {
    //         data =
    //         "Indicates you have true hunger. When you are hungry truly it means, it is the right time to eat your meals. Eating meals when your truly hungers sets functional balance in mind-body";
    //       }
    //
    //       showBottomSheetProceedToSaliva(data);
    //       /*      bool res = await showBsheetNext();
    //       if (res) {
    //         Navigator.pop(context, true);
    //       }*/
    //     } else {
    //       Constants.toastMessage(body['msg']);
    //     }
    //   } else {
    //     Constants.toastMessage(body['msg']);
    //   }
    // } on DioError catch (error) {
    //   setState(() {
    //     _isSyncing = false;
    //   });
    //   body = json.decode(error.response.toString());
    //   Constants.toastMessage(body['msg']);
    // }
  }

  final HomeRepository repository = HomeRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  showResultHUngerPopUp(String title) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return AnimatedPadding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 100),
            child: Container(
              decoration: const BoxDecoration(
                color: gBackgroundColor,
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: 80.h,
              child: Stack(
                children: [
                  Image(
                    height: 15.h,
                    image: const AssetImage(
                        "assets/images/gut_health_tracker/Group 5476.png"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      Stack(
                        children: [
                          Container(
                            height: 2.5.h,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  gsecondaryColor,
                                  gsecondaryColor,
                                  gBackgroundColor,
                                  gBackgroundColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: gGreyColor.withOpacity(0.5),
                                  offset: const Offset(4, 5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: Text(
                                  "Hunger",
                                  style: TextStyle(
                                    fontFamily: kFontBook,
                                    color: gHintTextColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            left: 28.w,
                            child: Image(
                              height: 5.h,
                              image: const AssetImage(
                                  "assets/images/gut_health_tracker/Group 5946.png"),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            right: 28.w,
                            child: Image(
                              height: 5.h,
                              image: const AssetImage(
                                  "assets/images/gut_health_tracker/Group 5944.png"),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                        child: Text(
                          title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            height: 1.5,
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SweatQualityScreen();
                              },
                            ),
                          );
                        },
                        child: Center(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 10.w),
                              margin: EdgeInsets.only(top: 5.h),
                              decoration: BoxDecoration(
                                color: kNumberCircleRed,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: gGreyColor.withOpacity(0.5),
                                    offset: const Offset(4, 5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Proceed to Sweat',
                                  style: TextStyle(
                                    color: eUser().threeBounceIndicatorColor,
                                    fontFamily: eUser().userFieldLabelFont,
                                    fontSize: eUser().mainHeadingFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image(
                      height: 15.h,
                      image: const AssetImage(
                          "assets/images/gut_health_tracker/Path 8284.png"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).whenComplete(() {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SweatQualityScreen(),
        ),
      );
    });
  }

  // final whenCheckBox = [
  //   CheckBoxSettings(title: "I Feel the need to eat, but you can wait"),
  //   CheckBoxSettings(title: "My Stomach starts to growl"),
  //   CheckBoxSettings(
  //       title:
  //           "I feel agitated, irritable, have low energy levels, stomach growls frequently"),
  //   CheckBoxSettings(
  //       title: "I feel weak / dizzy/ burning sensation in stomach"),
  // ];
  //
  // List<String> selectedWhen = [];
  //
  // final eatWhenCheckBox = [
  //   CheckBoxSettings(title: "You are content, neither hungry nor full"),
  //   CheckBoxSettings(title: "You are comfortable but feel a little full"),
  //   CheckBoxSettings(
  //       title: "Hunger is gone, but you feel a little uncomfortable"),
  //   CheckBoxSettings(
  //       title: "You feel stuffed; Your stomach hurts; you are restless"),
  // ];
  //
  // List<String> selectedEatWhen = [];
  //
  // buildWhenCheckBox(CheckBoxSettings whenCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             whenCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color:
  //                     whenCheckBox.value == true ? kTextColor : gHintTextColor,
  //                 fontFamily:
  //                     whenCheckBox.value == true ? kFontMedium : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: whenCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedWhen.add(whenCheckBox.title!);
  //               whenCheckBox.value = v;
  //               print(selectedWhen);
  //             } else {
  //               selectedWhen.remove(whenCheckBox.title!);
  //               whenCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // buildEatWhenCheckBox(CheckBoxSettings eatWhenCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             eatWhenCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: eatWhenCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily:
  //                     eatWhenCheckBox.value == true ? kFontMedium : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: eatWhenCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedEatWhen.add(eatWhenCheckBox.title!);
  //               eatWhenCheckBox.value = v;
  //               print(selectedEatWhen);
  //             } else {
  //               selectedEatWhen.remove(eatWhenCheckBox.title!);
  //               eatWhenCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
}
