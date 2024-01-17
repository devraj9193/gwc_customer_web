import 'package:flutter/material.dart';
import 'package:gwc_customer_web/screens/home_screens/gut_health_tracker_screens/urine_quality_screen.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../model/error_model.dart';
import '../../../model/success_message_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/home_repo/home_repository.dart';
import '../../../services/home_service/home_service.dart';
import '../../../utils/SharedPreferenceUtil.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'package:http/http.dart' as http;

class SweatQualityScreen extends StatefulWidget {
  const SweatQualityScreen({Key? key}) : super(key: key);

  @override
  State<SweatQualityScreen> createState() => _SweatQualityScreenState();
}

class _SweatQualityScreenState extends State<SweatQualityScreen> {
  int selectedQue1 = -1;
  int selectedQue2 = -1;
  int selectedQue3 = -1;
  int selectedQue4 = -1;
  int selectedQue5 = -1;
  int selectedQue6 = -1;

  int healthy = 0, unhealthy = 0;
  String overall = '0';

  bool isSyncing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            buildSweat(),
            const Image(
              image: AssetImage(
                  "assets/images/gut_health_tracker/Mask Group 1.png"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.w, bottom: 1.h, top: 1.h),
              child: buildAppBar(
                () {
                  Navigator.pop(context);
                },
                showNotificationIcon: false,
                isBackEnable: false,
                showLogo: false,
                showChild: true,
                child: Text(
                  "My Sweat is:",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    height: 1.5,
                    color: eUser().mainHeadingColor,
                    fontFamily: eUser().userFieldLabelFont,
                    fontSize: eUser().buttonTextSize,
                  ),
                ),
              ),
            ),
          ],
        ),
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

  buildSweatSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText("A) Usually, I sweat:"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Considerably even at rest / profusely on exertion',
                style: buildTextStyle(
                    color: selectedQue1 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue1 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Considerably only on sever exertion',
                style: buildTextStyle(
                    color: selectedQue1 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue1 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue1 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue1 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildRecentlySweatSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText(
              "B) Recently, there has been changes in how much I sweat and this concerns me"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Yes',
                style: buildTextStyle(
                    color: selectedQue2 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue2 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue2 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue2 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'No',
                style: buildTextStyle(
                    color: selectedQue2 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue2 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue2 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue2 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildBodyOdourSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText("C) When I sweat, my body odor is:"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Intolerably offensive',
                style: buildTextStyle(
                    color: selectedQue3 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue3 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue3 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue3 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Not very offensive',
                style: buildTextStyle(
                    color: selectedQue3 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue3 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue3 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue3 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildRecentlyBodyOdourSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText(
              "D) Recently, there has been changes in my body odour and this concerns me"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Yes',
                style: buildTextStyle(
                    color: selectedQue4 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue4 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue4 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue4 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'No',
                style: buildTextStyle(
                    color: selectedQue4 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue4 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue4 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue4 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildSweatMoreOnSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText(
              "E) Click that applies most to you: Usually, When I sweat I sweat more on :"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Palms of hands / Soles of Feet',
                style: buildTextStyle(
                    color: selectedQue5 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue5 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue5 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue5 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Folds of elbow / folds of knee / exposed skin surfaces like arms / neck etc.',
                style: buildTextStyle(
                    color: selectedQue5 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue5 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue5 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue5 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildSweatConcernsSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText(
              "F) Recently, I have observed changes in the place where I sweat more that concerns me and it is on:"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Palms of hands / Soles of Feet',
                style: buildTextStyle(
                    color: selectedQue6 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Folds of elbow / folds of knee / exposed skin surfaces like arms / neck etc.',
                style: buildTextStyle(
                    color: selectedQue6 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 1;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Scalp / Armpit / Groin / Pubic area',
                style: buildTextStyle(
                    color: selectedQue6 == 2 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 2 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 2 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 2;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Forehead / Face - Normal',
                style: buildTextStyle(
                    color: selectedQue6 == 3 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 3 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 3 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 3;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildSweat() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSweatSelection(),
              buildDivider(),
              buildRecentlySweatSelection(),
              buildDivider(),
              buildBodyOdourSelection(),
              buildDivider(),
              buildRecentlyBodyOdourSelection(),
              buildDivider(),
              buildSweatMoreOnSelection(),
              buildDivider(),
              buildSweatConcernsSelection(),
              // Text(
              //   "A) Usually, I sweat:",
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     color: eUser().mainHeadingColor,
              //     fontFamily: eUser().userFieldLabelFont,
              //     fontSize: eUser().buttonTextSize,
              //   ),
              // ),
              // ...sweatCheckBox.map((e) => buildSweatCheckBox(e)).toList(),
              // const Divider(
              //   color: kLineColor,
              //   thickness: 1,
              // ),
              // Text(
              //   "B) Recently, there has been changes in how much I sweat and this concerns me",
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     color: eUser().mainHeadingColor,
              //     fontFamily: eUser().userFieldLabelFont,
              //     fontSize: eUser().buttonTextSize,
              //   ),
              // ),
              // ...recentlySweatCheckBox
              //     .map((e) => buildRecentlySweatCheckBox(e))
              //     .toList(),
              // const Divider(
              //   color: kLineColor,
              //   thickness: 1,
              // ),
              // Text(
              //   "C) When I sweat, my body odor is:",
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     color: eUser().mainHeadingColor,
              //     fontFamily: eUser().userFieldLabelFont,
              //     fontSize: eUser().buttonTextSize,
              //   ),
              // ),
              // ...bodyOdourCheckBox
              //     .map((e) => buildBodyOdourCheckBox(e))
              //     .toList(),
              // const Divider(
              //   color: kLineColor,
              //   thickness: 1,
              // ),
              // Text(
              //   "D) Recently, there has been changes in my body odour and this concerns me",
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     color: eUser().mainHeadingColor,
              //     fontFamily: eUser().userFieldLabelFont,
              //     fontSize: eUser().buttonTextSize,
              //   ),
              // ),
              // ...recentlyBodyOdourCheckBox
              //     .map((e) => buildRecentlyBodyOdourCheckBox(e))
              //     .toList(),
              // const Divider(
              //   color: kLineColor,
              //   thickness: 1,
              // ),
              // Text(
              //   "E) Click that applies most to you: Usually, When I sweat I sweat more on :",
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     color: eUser().mainHeadingColor,
              //     fontFamily: eUser().userFieldLabelFont,
              //     fontSize: eUser().buttonTextSize,
              //   ),
              // ),
              // ...sweatMoreOnCheckBox
              //     .map((e) => buildSweatMoreOnCheckBox(e))
              //     .toList(),
              // const Divider(
              //   color: kLineColor,
              //   thickness: 1,
              // ),
              // Text(
              //   "F) Recently, I have observed changes in the place where I sweat more that concerns me and it is on:",
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     color: eUser().mainHeadingColor,
              //     fontFamily: eUser().userFieldLabelFont,
              //     fontSize: eUser().buttonTextSize,
              //   ),
              // ),
              // ...sweatConcernsCheckBox.map((e) => buildSweatConcernsCheckBox(e)).toList(),
              GestureDetector(
                onTap: isSyncing
                    ? null
                    : () {
                        if (validation()) {
                          if (selectedQue1 == 0) {
                            healthy++;
                          } else if (selectedQue1 == 1) {
                            healthy++;
                          }

                          if (selectedQue2 == 0) {
                            healthy++;
                          } else if (selectedQue2 == 1) {
                            unhealthy++;
                          }

                          if (selectedQue3 == 0) {
                            healthy++;
                          } else if (selectedQue3 == 1) {
                            unhealthy++;
                          }

                          if (selectedQue4 == 0) {
                            healthy++;
                          } else if (selectedQue4 == 1) {
                            unhealthy++;
                          }

                          if (selectedQue6 == 0) {
                            unhealthy++;
                          } else if (selectedQue6 == 1) {
                            healthy++;
                          } else if (selectedQue6 == 2) {
                            unhealthy++;
                          } else if (selectedQue6 == 3) {
                            healthy++;
                          } else if (selectedQue6 == 4) {
                            healthy++;
                          }

                          // if (healthy + unhealthy != 5) {
                          //   AppConfig().showSnackbar(
                          //       context, 'Select All Questions',
                          //       isError: true);
                          //   return;
                          // }

                          if (healthy > unhealthy) {
                            overall = "1";
                            /*int val = Integer.valueOf(preferenceSettings.getOnecnt()+1);
                                        preferenceSettings.setOnecnt(val);*/
                            int val = SharedPreferenceUtil.getInt(
                                    AppConfig.gutHealthTrackerOneCount) +
                                1;
                            SharedPreferenceUtil.putInt(
                                AppConfig.gutHealthTrackerOneCount, val);
                          } else if (unhealthy > healthy) {
                            overall = "0";
                            /*int val = Integer.valueOf(preferenceSettings.getZerocnt()+1);
                                        preferenceSettings.setZerocnt(val);*/
                            int val = SharedPreferenceUtil.getInt(
                                    AppConfig.gutHealthTrackerZeroCount) +
                                1;
                            SharedPreferenceUtil.putInt(
                                AppConfig.gutHealthTrackerZeroCount, val);
                          }

                          var data =
                              "As per your choice, the evaluation indicates that there could be functional Metabolic / hormonal changes happening inside your body. A higher intake of Fats, proteins, Salts and Spices could also trigger similar changes. This could have also triggered a functional change eventually. It needs correction after further analysis and discussion with your consultant. Correction of functional imbalance is usually through a combination of appropriate diet; physical activity and mind practices";

                          showResultSweatPopUp(data);
                          // callSaveDataAPI();
                        }
                      },
                child: Center(
                  child: IntrinsicWidth(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
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
              const Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                  image: AssetImage(
                      "assets/images/gut_health_tracker/Mask Group 2.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validation() {
    if (selectedQue1 == -1) {
      AppConfig().showSnackbar(context, 'Select All Questions', isError: true);
      return false;
    } else if (selectedQue2 == -1) {
      AppConfig().showSnackbar(context, 'Select All Questions', isError: true);
      return false;
    } else if (selectedQue3 == -1) {
      AppConfig().showSnackbar(context, 'Select All Questions', isError: true);
      return false;
    } else if (selectedQue4 == -1) {
      AppConfig().showSnackbar(context, 'Select All Questions', isError: true);
      return false;
    } else if (selectedQue5 == -1) {
      AppConfig().showSnackbar(context, 'Select All Questions', isError: true);
      return false;
    } else if (selectedQue6 == -1) {
      AppConfig().showSnackbar(context, 'Select All Questions', isError: true);
      return false;
    } else {
      return true;
    }
  }

  void callSaveDataAPI() async {
    setState(() {
      isSyncing = true;
    });

    Map sendDetailsMap = {
      "fem_id": SharedPreferenceUtil.getString(AppConfig.USER_ID),
      "tools_id": '2',
      "tool_categorie_id": '4',
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
      if (selectedQue2 != -1 || selectedQue4 != -1 || selectedQue6 != -1) {
        data = "As per your choice, the evaluation indicates that this is your tendency or nature to sweat. There is nothing wrong with your metabolism as long as no other complications like skin problems etc are associated. \n" +
            "\n" +
            "\u2022 Bath regularly twice a day with room temperature water. \n" +
            "\u2022 Use herbs like neem or vetiveria roots in bath water. \n" +
            "\u2022 Use cologne sprays after drying your body. \n" +
            "\u2022 Wear neat fresh breathable cotton cloths. \n" +
            "\u2022 Limit Fat and protein intake during noon hours.  \n";
      } else {
        data =
            "As per your choice, the evaluation indicates that there could be functional Metabolic / hormonal changes happening inside your body. A higher intake of Fats, proteins, Salts and Spices could also trigger similar changes. This could have also triggered a functional change eventually. It needs correction after further analysis and discussion with your consultant. Correction of functional imbalance is usually through a combination of appropriate diet; physical activity and mind practices";
      }

      showResultSweatPopUp(data);
      // bool res = await showBsheetNext();
      print(result);
      print("submit success");
    }
  }

  final HomeRepository repository = HomeRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  showResultSweatPopUp(String title) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          var splitTitle = title.split('\n');
          var firstTitle = splitTitle.first;
          var secondTitle = splitTitle.last;
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
                        "assets/images/gut_health_tracker/Mask Group 1.png"),
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
                                  "Sweat",
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
                                  "assets/images/gut_health_tracker/Group 5927.png"),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            right: 28.w,
                            child: Image(
                              height: 5.h,
                              image: const AssetImage(
                                  "assets/images/gut_health_tracker/Group 5926.png"),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          firstTitle,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            height: 1.5,
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ...secondTitle.split('\n').map((element) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0.5.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.7.h),
                                child: Icon(
                                  Icons.circle_sharp,
                                  color: gGreyColor,
                                  size: 1.h,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  element.replaceAll("\n", ""),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize:
                                          MealPlanConstants().benifitsFontSize,
                                      fontFamily:
                                          MealPlanConstants().benifitsFont),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const UrineQualityScreen();
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
                                  'Proceed to Urine',
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
                          "assets/images/gut_health_tracker/Mask Group 2.png"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).whenComplete(() {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UrineQualityScreen(),
        ),
      );
    });
  }

  // buildSweatCheckBox(CheckBoxSettings sweatCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             sweatCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color:
  //                 sweatCheckBox.value == true ? kTextColor : gHintTextColor,
  //                 fontFamily:
  //                 sweatCheckBox.value == true ? kFontMedium : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: sweatCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedSweat.add(sweatCheckBox.title!);
  //               sweatCheckBox.value = v;
  //               print(selectedSweat);
  //             } else {
  //               selectedSweat.remove(sweatCheckBox.title!);
  //               sweatCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // buildRecentlySweatCheckBox(CheckBoxSettings recentlySweatCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             recentlySweatCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: recentlySweatCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: recentlySweatCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: recentlySweatCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedRecentlySweat.add(recentlySweatCheckBox.title!);
  //               recentlySweatCheckBox.value = v;
  //               print(selectedRecentlySweat);
  //             } else {
  //               selectedRecentlySweat.remove(recentlySweatCheckBox.title!);
  //               recentlySweatCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // buildBodyOdourCheckBox(CheckBoxSettings bodyOdourCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             bodyOdourCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: bodyOdourCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: bodyOdourCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: bodyOdourCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedBodyOdour.add(bodyOdourCheckBox.title!);
  //               bodyOdourCheckBox.value = v;
  //               print(selectedBodyOdour);
  //             } else {
  //               selectedBodyOdour.remove(bodyOdourCheckBox.title!);
  //               bodyOdourCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // buildRecentlyBodyOdourCheckBox(CheckBoxSettings recentlyBodyOdourCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             recentlyBodyOdourCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: recentlyBodyOdourCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: recentlyBodyOdourCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: recentlyBodyOdourCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedRecentlyBodyOdour.add(recentlyBodyOdourCheckBox.title!);
  //               recentlyBodyOdourCheckBox.value = v;
  //               print(selectedRecentlyBodyOdour);
  //             } else {
  //               selectedRecentlyBodyOdour.remove(recentlyBodyOdourCheckBox.title!);
  //               recentlyBodyOdourCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // buildSweatMoreOnCheckBox(CheckBoxSettings sweatMoreOnCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             sweatMoreOnCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: sweatMoreOnCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: sweatMoreOnCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: sweatMoreOnCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedSweatMoreOn.add(sweatMoreOnCheckBox.title!);
  //               sweatMoreOnCheckBox.value = v;
  //               print(selectedSweatMoreOn);
  //             } else {
  //               selectedSweatMoreOn.remove(sweatMoreOnCheckBox.title!);
  //               sweatMoreOnCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // buildSweatConcernsCheckBox(CheckBoxSettings sweatConcernsCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             sweatConcernsCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color:
  //                 sweatConcernsCheckBox.value == true ? kTextColor : gHintTextColor,
  //                 fontFamily:
  //                 sweatConcernsCheckBox.value == true ? kFontMedium : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: sweatConcernsCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedSweatConcerns.add(sweatConcernsCheckBox.title!);
  //               sweatConcernsCheckBox.value = v;
  //               print(selectedSweatConcerns);
  //             } else {
  //               selectedSweatConcerns.remove(sweatConcernsCheckBox.title!);
  //               sweatConcernsCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // final sweatCheckBox = [
  //   CheckBoxSettings(
  //       title: "Considerably even at rest / profusely on exertion"),
  //   CheckBoxSettings(title: "Considerably only on sever exertion"),
  // ];
  //
  // List<String> selectedSweat = [];
  //
  // final recentlySweatCheckBox = [
  //   CheckBoxSettings(title: "Yes"),
  //   CheckBoxSettings(title: "No"),
  // ];
  //
  // List<String> selectedRecentlySweat = [];
  //
  // final bodyOdourCheckBox = [
  //   CheckBoxSettings(title: "Intolerably offensive"),
  //   CheckBoxSettings(
  //       title:
  //       "Not very offensive"),
  // ];
  //
  // List<String> selectedBodyOdour = [];
  //
  // final recentlyBodyOdourCheckBox = [
  //   CheckBoxSettings(title: "Yes"),
  //   CheckBoxSettings(title: "No"),
  // ];
  //
  // List<String> selectedRecentlyBodyOdour= [];
  //
  // final sweatMoreOnCheckBox = [
  //   CheckBoxSettings(title: "Palms of hands / Soles of Feet"),
  //   CheckBoxSettings(title: "Folds of elbow / folds of knee / exposed skin surfaces like arms / neck etc."),
  // ];
  //
  // List<String> selectedSweatMoreOn = [];
  //
  // final sweatConcernsCheckBox = [
  //   CheckBoxSettings(
  //       title: "Palms of hands / Soles of Feet"),
  //   CheckBoxSettings(title: "Folds of elbow / folds of knee / exposed skin surfaces like arms / neck etc."),
  //   CheckBoxSettings(
  //       title:
  //       "Scalp / Armpit / Groin / Pubic area"),
  //   CheckBoxSettings(
  //       title:
  //       "Forehead / Face - Normal"),
  // ];
  //
  // List<String> selectedSweatConcerns = [];
}
