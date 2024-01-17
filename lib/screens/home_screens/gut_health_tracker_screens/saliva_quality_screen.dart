import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import '../../../model/error_model.dart';
import '../../../model/success_message_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/home_repo/home_repository.dart';
import '../../../services/home_service/home_service.dart';
import '../../../utils/SharedPreferenceUtil.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'hunger_quality_screen.dart';
import 'package:http/http.dart' as http;

class SalivaQualityScreen extends StatefulWidget {
  const SalivaQualityScreen({Key? key}) : super(key: key);

  @override
  State<SalivaQualityScreen> createState() => _SalivaQualityScreenState();
}

class _SalivaQualityScreenState extends State<SalivaQualityScreen> {
  int selectedQue1 = -1;

  int healthy = 0, unhealthy = 0;
  String overall = '0';

  bool isSyncing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNumberCirclePurple,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: 3.h, top: 3.h),
            child: buildAppBar(
              () {
                Navigator.pop(context);
              },
              showNotificationIcon: false,
              isBackEnable: false,
              showLogo: false,
              showChild: true,
              child: Text(
                "My Saliva is:",
                textAlign: TextAlign.start,
                style: TextStyle(
                  height: 1.5,
                  color: eUser().threeBounceIndicatorColor,
                  fontFamily: eUser().userFieldLabelFont,
                  fontSize: eUser().mainHeadingFontSize,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              decoration: const BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                ),
              ),
              child: buildSaliva(),
            ),
          ),
        ],
      ),
    );
  }

  buildSaliva() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                controlAffinity: ListTileControlAffinity.leading,
                title: Transform.translate(
                  offset: const Offset(-10, 0),
                  child: Text(
                    'Thin watery tasting more like water',
                    style: buildTextStyle(
                        color: selectedQue1 == 0 ? kTextColor : gHintTextColor,
                        fontFamily:
                            selectedQue1 == 0 ? kFontMedium : kFontBook),
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
                    'Thick with a different taste (sweet / acidic / bitter / salty / metallic)',
                    style: buildTextStyle(
                        color: selectedQue1 == 1 ? kTextColor : gHintTextColor,
                        fontFamily:
                            selectedQue1 == 1 ? kFontMedium : kFontBook),
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
              // ...salivaCheckBox.map((e) => buildSalivaCheckBox(e)).toList(),
            ],
          ),
        ),
        InkWell(
          onTap: isSyncing ? null : () {
            if (selectedQue1 == -1) {
              AppConfig()
                  .showSnackbar(context, 'Select Saliva Question', isError: true);
            }
           else if (selectedQue1 != -1) {
              if (healthy > unhealthy) {
                overall = "1";
                /* int val = Integer.valueOf(preferenceSettings.getOnecnt()+1);
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
                  'Indicates you are stressed or some functional change has happened in your metabolism. Drink a glass of room temperature water to tune the metabolism. Avoid eating any meal or snack when you are stressed / emotional.';

              showResultSalivaPopUp(data);
              // callSaveDataAPI();
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
                  child: (isSyncing) ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                      :  Text(
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
      "tool_categorie_id": '3',
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
      if (selectedQue1 == 0) {
        data =
            'Indicates you have true hunger. When you are hungry truly it means, it is the right time to eat your meals. Eating meals when your are truly hungry sets functional balance in mind-body.';

        // dynamicSeekBarView.setProgress(65);
      } else if (selectedQue1 == 1) {
        // dynamicSeekBarView.setProgress(5);
        data =
            'Indicates you are stressed or some functional change has happened in your metabolism. Drink a glass of room temperature water to tune the metabolism. Avoid eating any meal or snack when you are stressed / emotional.';
      }

      showResultSalivaPopUp(data);
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
    //       "tool_categorie_id": '1',
    //       "healthy": healthy,
    //       "unhealthy": unhealthy,
    //       "healthy_value": healthy_value,
    //       "overall_value": '',
    //       "overall_healthy": '',
    //       "overall_unhealthy": '',
    //
    //     },
    //     options: Options(headers: {
    //       HttpHeaders.contentTypeHeader: "application/json",
    //     }, contentType: 'application/json; charset=UTF-8'),
    //   );
    //   setState(() {
    //     isSyncing = false;
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
    //       if(healthy>unhealthy){
    //         // dynamicSeekBarView.setProgress(0);
    //         data = 'Thank you for taking time to Know your Body!\n\nAs per your choice, the evaluation indicates that your\n'
    //             'Body has detoxed well and intestinal motility is healthy';
    //
    //       }else{
    //         // dynamicSeekBarView.setProgress(65);
    //         data = 'Thank you for taking time to Know your Body!\n\nAs per your choice, the evaluation indicates that your\n'
    //             'Gut biome may be functionally dis-balanced. It may also indicate high protein diet.\n'
    //             'It needs correction after further analysis. Correction of functional imbalance is usually through a combination of appropriate diet; physical activity and mind practices';
    //       }
    //       showResultStoolsPopUp(data);
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

  showResultSalivaPopUp(String title) {
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
              decoration: BoxDecoration(
                color: kNumberCirclePurple,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(top: 5.h),
              height: 70.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: const BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  "Saliva",
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
                                  "assets/images/gut_health_tracker/Group 5925.png"),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            right: 28.w,
                            child: Image(
                              height: 5.h,
                              image: const AssetImage(
                                  "assets/images/gut_health_tracker/Group 5921.png"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
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
                      // Padding(
                      //   padding:
                      //       EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: Icon(
                      //           Icons.circle_sharp,
                      //           color: kNumberCircleRed,
                      //           size: 1.5.h,
                      //         ),
                      //       ),
                      //       SizedBox(width: 1.w),
                      //       Expanded(
                      //         child: Text(
                      //           "Lorem ipsum dolor sit amet, consetetur",
                      //           textAlign: TextAlign.start,
                      //           style: TextStyle(
                      //             height: 1.5,
                      //             color: eUser().mainHeadingColor,
                      //             fontFamily: eUser().userFieldLabelFont,
                      //             fontSize: eUser().buttonTextSize,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding:
                      //       EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: Icon(
                      //           Icons.circle_sharp,
                      //           color: kNumberCircleRed,
                      //           size: 1.5.h,
                      //         ),
                      //       ),
                      //       SizedBox(width: 1.w),
                      //       Expanded(
                      //         child: Text(
                      //           "Lorem ipsum dolor sit amet, consetetur",
                      //           textAlign: TextAlign.start,
                      //           style: TextStyle(
                      //             height: 1.5,
                      //             color: eUser().mainHeadingColor,
                      //             fontFamily: eUser().userFieldLabelFont,
                      //             fontSize: eUser().buttonTextSize,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding:
                      //       EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: Icon(
                      //           Icons.circle_sharp,
                      //           color: kNumberCircleRed,
                      //           size: 1.5.h,
                      //         ),
                      //       ),
                      //       SizedBox(width: 1.w),
                      //       Expanded(
                      //         child: Text(
                      //           "Lorem ipsum dolor sit amet, consetetur",
                      //           textAlign: TextAlign.start,
                      //           style: TextStyle(
                      //             height: 1.5,
                      //             color: eUser().mainHeadingColor,
                      //             fontFamily: eUser().userFieldLabelFont,
                      //             fontSize: eUser().buttonTextSize,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const HungerQualityScreen();
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
                                  'Proceed to Hunger',
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
                ),
              ),
            ),
          );
        }).whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HungerQualityScreen(),
        ),
      );
    });
  }

  // final salivaCheckBox = [
  //   CheckBoxSettings(title: "Thin watery tasting more like water"),
  //   CheckBoxSettings(
  //       title:
  //       "Thick with a different taste (sweet / acidic / bitter / salty / metallic)"),
  // ];
  //
  // List<String> selectedSaliva = [];

// buildSalivaCheckBox(CheckBoxSettings salivaCheckBox) {
//   return StatefulBuilder(builder: (_, setstate) {
//     return IntrinsicWidth(
//       child: CheckboxListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
//         controlAffinity: ListTileControlAffinity.leading,
//         title: Transform.translate(
//           offset: const Offset(-10, 0),
//           child: Text(
//             salivaCheckBox.title.toString(),
//             style: buildTextStyle(
//                 color: salivaCheckBox.value == true
//                     ? kTextColor
//                     : gHintTextColor,
//                 fontFamily:
//                     salivaCheckBox.value == true ? kFontMedium : kFontBook),
//           ),
//         ),
//         dense: true,
//         activeColor: kPrimaryColor,
//         value: salivaCheckBox.value,
//         onChanged: (v) {
//           setstate(() {
//             if (v == true) {
//               selectedSaliva.add(salivaCheckBox.title!);
//               salivaCheckBox.value = v;
//               print(selectedSaliva);
//             } else {
//               selectedSaliva.remove(salivaCheckBox.title!);
//               salivaCheckBox.value = v;
//             }
//           });
//         },
//       ),
//     );
//   });
// }
}
