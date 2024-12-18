/*
we have put card height to 80.h
if any problem in ui need to change that

submit final Program feedback Api:

var submitProgramFeedbackFormUrl = "${AppConfig().BASE_URL}/api/submitForm/program_feedback";

 */

import 'dart:io';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:gwc_customer_web/screens/medical_program_feedback_screen/post_gut_type_diagnosis.dart';
import 'package:http/http.dart';
import 'package:async/async.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:reviews_slider/reviews_slider.dart';
import 'package:tcard/tcard.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import '../../model/error_model.dart';
import '../../model/new_user_model/register/register_model.dart';
import '../../repository/api_service.dart';
import '../../repository/medical_program_feedback_repo/medical_feedback_repo.dart';
import '../../services/medical_program_feedback_service/medical_feedback_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../evalution_form/check_box_settings.dart';

class TCardPage extends StatefulWidget {
  final int programContinuesdStatus;
  final bool isFromWeb;
  const TCardPage({Key? key, required this.programContinuesdStatus,this.isFromWeb = false})
      : super(key: key);

  @override
  State<TCardPage> createState() => _TCardPageState();
}

class _TCardPageState extends State<TCardPage> {
  final TCardController _controller = TCardController();
  bool isLoading = false;
  List<File> _finalFiles = [];
  int _index = 0;
  int? programContinuesdStatus;
  int submittedIndex = -1;
  String selectedProgramStatus = "";
  String selectedPercentage = "";
  String selectedBreathing = "";
  String mealyesno = "";
  String yogayesno = "";
  String supportPlans = "";
  String rating1 = "";
  String rating2 = "";
  String rating3 = "";

  bool? influsionsValue;
  TextEditingController afterTheProgramController = TextEditingController();
  TextEditingController mealHighLightController = TextEditingController();
  TextEditingController improvedHealthController = TextEditingController();
  TextEditingController positiveController = TextEditingController();
  TextEditingController negativeController = TextEditingController();
  TextEditingController kitItemsController = TextEditingController();
  TextEditingController suggestionsController = TextEditingController();
  TextEditingController testimonialController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController ifDiscontinuedController = TextEditingController();

  String emptyStringMsg = AppConfig().emptyStringMsg;

  List<String> list = [
    "I have successfully completed my program.",
    "I have discontinued my program before I finish my transition period."
  ];

  List<String> yesNo = ["Yes", "No", "Maybe Later"];

  List<String> gutIssuesList = [
    "Below 50%",
    "50% - 60%",
    "60% - 70%",
    "70% - 80%",
    "80% - 90%",
    "90% - 100%",
  ];

  List<String> breathingList = [
    "0%",
    "20%",
    "40%",
    "60%",
    "80%",
    "100%",
  ];

  final feedbackOnKitItems = [
    CheckBoxSettings(title: "Quantity was sufficient"),
    CheckBoxSettings(title: "I liked the taste"),
    CheckBoxSettings(title: "Easy to prepare"),
    CheckBoxSettings(title: "I want to use this regularly"),
    CheckBoxSettings(title: "Quickly reduced my symptoms"),
  ];

  List<String> selectedInfusions = [];
  List<String> selectedSoups = [];
  List<String> selectedPorridges = [];
  List<String> selectedPodi = [];
  List<String> selectedKheer = [];

  final afterTheProgram = [
    CheckBoxSettings(
        title:
            "My energy levels are fairly high and stable as compared to earlier"),
    CheckBoxSettings(title: "I experience adequate sleep"),
    CheckBoxSettings(
        title: "My hunger and appetite is better as compared to earlier"),
    CheckBoxSettings(title: "My body feels light and relaxed"),
    CheckBoxSettings(
        title: "My evacuation has been fairly better as compared to earlier"),
    CheckBoxSettings(title: "I feel calm & at peace"),
    CheckBoxSettings(title: "Other:"),
  ];

  List<String> selectedAfterTheProgram = [];
  List<PlatformFile> medicalRecords = [];
  List<File> fileFormatList = [];
  List<MultipartFile> newList = <MultipartFile>[];

  List<Color> colors = [
    kNumberCircleRed,
    kNumberCircleAmber,
    kNumberCirclePurple,
    kNumberCircleGreen,
    kNumberCircleRed,
    kNumberCirclePurple,
    kNumberCircleAmber,
    kNumberCircleGreen,
    kNumberCircleRed,
    kNumberCircleAmber,
    gGreyColor,
    kNumberCircleGreen,
    kNumberCircleRed,
    kNumberCirclePurple,
    kNumberCircleAmber,
    kNumberCircleGreen,
    kNumberCircleRed,
  ];

  List<Widget> cards = [];

//
// List<String> images = [
//   'https://gank.io/images/5ba77f3415b44f6c843af5e149443f94',
//   'https://gank.io/images/02eb8ca3297f4931ab64b7ebd7b5b89c',
//   'https://gank.io/images/31f92f7845f34f05bc10779a468c3c13',
//   'https://gank.io/images/b0f73f9527694f44b523ff059d8a8841',
//   'https://gank.io/images/1af9d69bc60242d7aa2e53125a4586ad',
// ];

  String programStatus = "";
  Map m = {
    0: [{}, {}],
    1: {}
  };

  MedicalFeedbackService? medicalFeedbackService;

  @override
  void initState() {
    super.initState();
    buildCards();
    medicalFeedbackService = MedicalFeedbackService(feedbackRepo: repository);
  }

  buildCards() {
    return cards = List.generate(
      colors.length,
      (int index) {
        return index == 0
            ? slider2(index)
            : index == 1
                ? slider3(index)
                : index == 2
                    ? slider4(index)
                    : index == 3
                        ? slider5(index)
                        : index == 4
                            ? slider6(index)
                            : index == 5
                                ? slider7(index)
                                : index == 6
                                    ? slider8(index)
                                    : index == 7
                                        ? slider9(index)
                                        : index == 8
                                            ? slider10(index)
                                            : index == 9
                                                ? slider11(index)
                                                : index == 10
                                                    ? slider12(index)
                                                    : index == 11
                                                        ? slider13(index)
                                                        : index == 12
                                                            ? slider14(index)
                                                            : index == 13
                                                                ? slider15(
                                                                    index)
                                                                : index == 14
                                                                    ? slider16(
                                                                        index)
                                                                    : index ==
                                                                            15
                                                                        ? slider17(
                                                                            index)
                                                                        : index ==
                                                                                16
                                                                            ? slider18(index)
                                                                            : Container();
      },
    );
  }

  buildLabelTextField(String name,
      {double? fontSize,
      double textScleFactor = 0.9,
      bool isMandatory = true}) {
    return RichText(
        textScaleFactor: textScleFactor,
        textAlign: TextAlign.center,
        text: TextSpan(
            text: name,
            style: TextStyle(
              fontSize: fontSize ?? 13.sp,
              color: gWhiteColor,
              height: 1.35,
              fontFamily: kFontMedium,
            ),
            children: [
              TextSpan(
                text: (isMandatory) ? ' *' : '',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: kPrimaryColor,
                  fontFamily: "PoppinsSemiBold",
                ),
              )
            ]));
  }

  void changedIndex(String index) {
    setState(() {
      selectedProgramStatus = index;
      print(selectedProgramStatus);
    });
  }

  buildButtonText(String title, int status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          changedIndex(title);
          if (title == list[0]) {
            programContinuesdStatus = 1;
          } else {
            programContinuesdStatus = 0;
          }
        });
        submittedIndex = status;
        print("submittedIndex : $submittedIndex");
        _controller.forward();
        print("programContinuesdStatus == $programContinuesdStatus");
      },
      child: Container(
        width: double.maxFinite,
        height: 7.h,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color:
              (selectedProgramStatus == title) ? gsecondaryColor : gWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: kLineColor.withOpacity(0.3),
              offset: Offset(2, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  (selectedProgramStatus == title) ? gWhiteColor : gBlackColor,
              height: 1.3,
              fontFamily:
                  (selectedProgramStatus == title) ? kFontMedium : kFontBook,
              fontSize: subHeadingFont,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFromWeb ? buildMainView() : SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(
                height: 1.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Gut Wellness Club Program Feedback ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: kFontBold,
                        color: gBlackColor,
                        height: 1.5,
                        fontSize: headingFont),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: kLineColor,
                    ),
                  ),
                ],
              ),
              Text(
                "We'd Love To Know How We Made You Feel",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gHintTextColor,
                    height: 1.3,
                    fontSize: subHeadingFont),
              ),
              SizedBox(
                height: 1.h,
              ),
              // (programContinuesdStatus == null) ?  Container(
              //   height: 60.h,
              //   width: double.maxFinite,
              //   padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              //   decoration: BoxDecoration(
              //     color: colors[0].withOpacity(1),
              //     borderRadius: BorderRadius.circular(16.0),
              //     boxShadow: [
              //       BoxShadow(
              //         offset: const Offset(0, 17),
              //         blurRadius: 10.0,
              //         color: gWhiteColor.withOpacity(0.3),
              //       )
              //     ],
              //   ),
              //   child: Center(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         buildLabelTextField('Tell us about your program status ',
              //             fontSize: headingFont),
              //         SizedBox(height: 3.h),
              //         buildButtonText(list[0], 0),
              //         buildButtonText(list[1], 0),
              //         SizedBox(height: 2.h),
              //       ],
              //     ),
              //   ),
              // ):
              Expanded(child:
              buildMainView(),),
            ],
          ),
        ),
      ),
    );
  }

  buildMainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: TCard(
              cards: cards,
              lockYAxis: true,
              size: Size(
                  MediaQuery.of(context).size.shortestSide < 600
                      ? double.maxFinite
                      : 50.w,
                  80.h),
              delaySlideFor: 300,
              controller: _controller,
              onForward: (index, info) {
                print("onForward");
                print("${submittedIndex + 1}  $index");

                if (submittedIndex + 1 != index &&
                    (submittedIndex + 1 < index)) {
                  _controller.back();
                } else {
                  _index = index;
                  print("index: $index");
                  print("Direction : ${info.direction}");
                }
                setState(() {});
              },
              onBack: (index, info) {
                print("onBack");
                _index = index;
                setState(() {});
              },
              onEnd: () {
                print('end');
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _controller.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  "${_index + 1} of ${colors.length}",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: gHintTextColor,
                    height: 1.35,
                    fontFamily: kFontMedium,
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () {
                    print(_index);
                    print(submittedIndex);
                    print(_index == colors.length - 1);
                    if (submittedIndex == _index &&
                        _index != colors.length - 1) {
                      _controller.forward();
                    } else {}
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: (submittedIndex == _index &&
                        _index != colors.length - 1)
                        ? gBlackColor
                        : gGreyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildHealthCheckBox(
      CheckBoxSettings healthCheckBox, String from, Function setstate) {
    return IntrinsicWidth(
      child: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.white),
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          controlAffinity: ListTileControlAffinity.leading,
          title: Transform.translate(
            offset: const Offset(-10, 0),
            child: Text(
              healthCheckBox.title.toString(),
              style: buildTextStyle(
                  color:
                      healthCheckBox.value == true ? gWhiteColor : gWhiteColor,
                  fontFamily:
                      healthCheckBox.value == true ? kFontMedium : kFontBook),
            ),
          ),
          dense: true,
          activeColor: gsecondaryColor,
          value: healthCheckBox.value,
          tileColor: gWhiteColor,
          checkColor: gWhiteColor,
          side: WidgetStateBorderSide.resolveWith(
            (states) => const BorderSide(width: 1.5, color: gWhiteColor),
          ),
          shape: const RoundedRectangleBorder(),
          onChanged: (v) {
            if (from == 'afterProgram') {
              if (healthCheckBox.title == afterTheProgram.last.title) {
                print("if");
                setstate(() {
                  selectedAfterTheProgram.clear();
                  afterTheProgram.forEach((element) {
                    if (element != afterTheProgram.last.title) {
                      element.value = false;
                    }
                  });
                  if (v == true) {
                    selectedAfterTheProgram.add(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  } else {
                    selectedAfterTheProgram.remove(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  }
                });
              } else {
                print("else");
                if (selectedAfterTheProgram
                    .contains(afterTheProgram.last.title)) {
                  print("if");
                  setstate(() {
                    selectedAfterTheProgram.clear();
                    afterTheProgram[6].value = false;
                  });
                }
                if (v == true) {
                  setstate(() {
                    selectedAfterTheProgram.add(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  });
                } else {
                  setstate(() {
                    selectedAfterTheProgram.remove(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  });
                }
              }
              print(selectedAfterTheProgram);
            }
          },
        ),
      ),
    );
  }

  void changedIndex1(String index) {
    setState(() {
      selectedPercentage = index;
      print(selectedPercentage);
    });
  }

  void changedIndex2(String index) {
    setState(() {
      selectedBreathing = index;
      print(selectedBreathing);
    });
  }

  void changedIndex3(String index) {
    setState(() {
      mealyesno = index;
      print(mealyesno);
    });
  }

  void changedIndex4(String index) {
    setState(() {
      yogayesno = index;
      print(yogayesno);
    });
  }

  void changedIndex5(String index) {
    setState(() {
      supportPlans = index;
      print(supportPlans);
    });
  }

  buildPercentageButton(String title, Color color, func) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ButtonWidget(
        text: title,
        onPressed: func,
        isLoading: false,
        textColor: (selectedProgramStatus == title) ? gWhiteColor : gBlackColor,
        radius: 10,
        buttonWidth: MediaQuery.of(context).size.shortestSide > 600
            ? 10.w  : 23.w,
        color: color,
        font: (selectedProgramStatus == title) ? kFontMedium : kFontBook,
      ),
    );
    GestureDetector(
      onTap: func,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: kLineColor.withOpacity(0.3),
              offset: const Offset(2, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  (selectedProgramStatus == title) ? gWhiteColor : gBlackColor,
              height: 1.3,
              fontFamily:
                  (selectedProgramStatus == title) ? kFontMedium : kFontBook,
              fontSize: subHeadingFont,
            ),
          ),
        ),
      ),
    );
  }

  // slider1(int index) {
  //   return StatefulBuilder(builder: (_, setState) {
  //     return Container(
  //       padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
  //       decoration: BoxDecoration(
  //         color: colors[0].withOpacity(1),
  //         borderRadius: BorderRadius.circular(16.0),
  //         boxShadow: [
  //           BoxShadow(
  //             offset: const Offset(0, 17),
  //             blurRadius: 10.0,
  //             color: gWhiteColor.withOpacity(0.3),
  //           )
  //         ],
  //       ),
  //       child: Center(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             buildLabelTextField('Tell us about your program status ',
  //                 fontSize: headingFont),
  //             SizedBox(height: 3.h),
  //             buildButtonText(list[0], 0),
  //             buildButtonText(list[1], 0),
  //             SizedBox(height: 2.h),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  slider2(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                buildLabelTextField(
                    'Changes I see after the program\n(Pick all that apply)',
                    fontSize: headingFont),
                SizedBox(height: 1.h),
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ...afterTheProgram
                        .map((e) =>
                            buildHealthCheckBox(e, 'afterProgram', setstate))
                        .toList(),
                    Visibility(
                      visible: selectedAfterTheProgram.any(
                          (element) => element == afterTheProgram.last.title),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: afterTheProgramController,
                        cursorColor: kPrimaryColor,
                        validator: (value) {
                          if (value!.isEmpty &&
                              selectedAfterTheProgram.any(
                                  (element) => element.contains("Other:"))) {
                            return 'Please Mention Other Details with minimum 2 characters';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Your Answer",
                          hintStyle: TextStyle(
                              fontFamily: eUser().userTextFieldHintFont,
                              fontSize: eUser().userTextFieldHintFontSize,
                              color: gWhiteColor),
                          counterText: "",
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: gWhiteColor,
                                width: 1.0,
                                style: BorderStyle.solid),
                          ),
                          // suffixIcon: suffixIcon,
                          // enabledBorder: enabledBorder,
                          // focusedBorder: focusBoder,
                        ),
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                  onTap: () {
                    if (selectedAfterTheProgram.isEmpty) {
                      AppConfig().showSnackbar(
                          context, "Please Select Any One !",
                          isError: true, bottomPadding: 10);
                    } else if (selectedAfterTheProgram
                            .any((element) => element.contains("Other:")) &&
                        afterTheProgramController.text.isEmpty) {
                      AppConfig().showSnackbar(
                          context, "Please Enter your answer",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 0;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider3(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    'To What Extent Did The Program Heal Your Gut Issues',
                    fontSize: headingFont),
                SizedBox(height: 1.h),
                buildPercentageButton(
                    gutIssuesList[0],
                    selectedPercentage == gutIssuesList[0]
                        ? gsecondaryColor
                        : gWhiteColor, () {
                  submittedIndex = 1;
                  setState(() {
                    changedIndex1(
                      gutIssuesList[0],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    gutIssuesList[1],
                    selectedPercentage == gutIssuesList[1]
                        ? gsecondaryColor
                        : gWhiteColor, () {
                  submittedIndex = 1;
                  setState(() {
                    changedIndex1(
                      gutIssuesList[1],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    gutIssuesList[2],
                    selectedPercentage == gutIssuesList[2]
                        ? gMainColor
                        : gWhiteColor, () {
                  submittedIndex = 1;
                  setState(() {
                    changedIndex1(
                      gutIssuesList[2],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    gutIssuesList[3],
                    selectedPercentage == gutIssuesList[3]
                        ? gMainColor
                        : gWhiteColor, () {
                  submittedIndex = 1;
                  setState(() {
                    changedIndex1(
                      gutIssuesList[3],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    gutIssuesList[4],
                    selectedPercentage == gutIssuesList[4]
                        ? newDashboardGreenButtonColor
                        : gWhiteColor, () {
                  submittedIndex = 1;
                  setState(() {
                    changedIndex1(
                      gutIssuesList[4],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    gutIssuesList[5],
                    selectedPercentage == gutIssuesList[5]
                        ? newDashboardGreenButtonColor
                        : gWhiteColor, () {
                  submittedIndex = 1;
                  setState(() {
                    changedIndex1(
                      gutIssuesList[5],
                    );
                    // _controller.forward();
                  });
                }),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (selectedPercentage.isEmpty) {
                      AppConfig().showSnackbar(
                          context, "Please Select Gut Issues",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 1;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider4(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    'How well did you stick to the plan given to you (meal plan / yoga plan / breathing exercises)? ',
                    fontSize: headingFont),
                SizedBox(height: 1.h),
                buildPercentageButton(
                    breathingList[0],
                    selectedBreathing == breathingList[0]
                        ? gsecondaryColor
                        : gWhiteColor, () {
                  submittedIndex = 2;
                  setState(() {
                    changedIndex2(
                      breathingList[0],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    breathingList[1],
                    selectedBreathing == breathingList[1]
                        ? gsecondaryColor
                        : gWhiteColor, () {
                  submittedIndex = 2;
                  setState(() {
                    changedIndex2(
                      breathingList[1],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    breathingList[2],
                    selectedBreathing == breathingList[2]
                        ? gMainColor
                        : gWhiteColor, () {
                  submittedIndex = 2;
                  setState(() {
                    changedIndex2(
                      breathingList[2],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    breathingList[3],
                    selectedBreathing == breathingList[3]
                        ? gMainColor
                        : gWhiteColor, () {
                  submittedIndex = 2;
                  setState(() {
                    changedIndex2(
                      breathingList[3],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    breathingList[4],
                    selectedBreathing == breathingList[4]
                        ? newDashboardGreenButtonColor
                        : gWhiteColor, () {
                  submittedIndex = 2;
                  setState(() {
                    changedIndex2(
                      breathingList[4],
                    );
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(
                    breathingList[5],
                    selectedBreathing == breathingList[5]
                        ? newDashboardGreenButtonColor
                        : gWhiteColor, () {
                  submittedIndex = 2;
                  setState(() {
                    changedIndex2(
                      breathingList[5],
                    );
                    // _controller.forward();
                  });
                }),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (selectedBreathing.isEmpty) {
                      AppConfig().showSnackbar(
                          context, "Please Select Plan Given to you.",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 2;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider5(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField('Was The Meal Plan Easy To Follow',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                buildPercentageButton(yesNo[0],
                    mealyesno == yesNo[0] ? gsecondaryColor : gWhiteColor, () {
                  setState(() {
                    changedIndex3(
                      yesNo[0],
                    );
                    submittedIndex = 3;
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(yesNo[1],
                    mealyesno == yesNo[1] ? gsecondaryColor : gWhiteColor, () {
                  setState(() {
                    changedIndex3(
                      yesNo[1],
                    );
                    submittedIndex = 3;
                    // _controller.forward();
                  });
                }),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () {
                    if (mealyesno.isEmpty) {
                      AppConfig().showSnackbar(
                          context, "Please Select Meal Plan Easy To Follow.",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 3;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider6(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField('Was The Yoga Plan Easy To Follow',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                buildPercentageButton(yesNo[0],
                    yogayesno == yesNo[0] ? gsecondaryColor : gWhiteColor, () {
                  setState(() {
                    changedIndex4(
                      yesNo[0],
                    );
                    submittedIndex = 4;
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(yesNo[1],
                    yogayesno == yesNo[1] ? gsecondaryColor : gWhiteColor, () {
                  setState(() {
                    changedIndex4(
                      yesNo[1],
                    );
                    submittedIndex = 4;
                    // _controller.forward();
                  });
                }),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () {
                    if (yogayesno.isEmpty) {
                      AppConfig().showSnackbar(
                          context, "Please Select Yoga Plan Easy To Follow.",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 4;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider7(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField('Comments On The Meal Or Yoga Plans',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                Container(
                  height: 10.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    maxLines: null, // Set this
                    textCapitalization: TextCapitalization.sentences,
                    controller: mealHighLightController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Answer';
                      } else if (value.length < 2) {
                        return emptyStringMsg;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Your Answer",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: eUser().userTextFieldHintFont,
                        color: eUser().userTextFieldHintColor,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    // textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 2.h),
                buildLabelTextField(
                    'Has The Program Improved Your Health In Another Way Apart From Your Gut Issues? Please mention',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                Container(
                  height: 10.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    maxLines: null, // Set this
                    textCapitalization: TextCapitalization.sentences,
                    controller: improvedHealthController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Answer';
                      } else if (value.length < 2) {
                        return emptyStringMsg;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Your Answer",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: eUser().userTextFieldHintFont,
                        color: eUser().userTextFieldHintColor,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    // textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (mealHighLightController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else if (improvedHealthController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 5;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider8(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    'What Were The Positive Highlights Of Your Program',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                Container(
                  height: 10.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    maxLines: null, // Set this
                    textCapitalization: TextCapitalization.sentences,
                    controller: positiveController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Answer';
                      } else if (value.length < 2) {
                        return emptyStringMsg;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Your Answer",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: eUser().userTextFieldHintFont,
                        color: eUser().userTextFieldHintColor,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    // textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 2.h),
                buildLabelTextField(
                    'What Were The Negative Highlights Of Your Program',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                Container(
                  height: 10.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    maxLines: null, // Set this
                    textCapitalization: TextCapitalization.sentences,
                    controller: negativeController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Answer';
                      } else if (value.length < 2) {
                        return emptyStringMsg;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Your Answer",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: eUser().userTextFieldHintFont,
                        color: eUser().userTextFieldHintColor,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    // textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (positiveController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else if (negativeController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 6;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider9(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    "Feedback on Infusions\n(Pick all that apply)",
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ...feedbackOnKitItems
                        .map((e) => buildKitItemsListButton(
                            e, 'influsions', selectedInfusions))
                        .toList(),
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (selectedInfusions.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Select Any One",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 7;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider10(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField("Feedback on Soups\n(Pick all that apply)",
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ...feedbackOnKitItems
                        .map((e) =>
                            buildKitItemsListButton(e, 'soups', selectedSoups))
                        .toList(),
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (selectedSoups.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Select Any One",
                          isError: true, bottomPadding: 10);
                    } else {
                      _controller.forward();
                      submittedIndex = 8;
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider11(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    "Feedback on Porridges\n(Pick all that apply)",
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ...feedbackOnKitItems
                        .map((e) => buildKitItemsListButton(
                            e, 'porridges', selectedPorridges))
                        .toList(),
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (selectedPorridges.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Select Any One",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 9;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider12(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField("Feedback on Podi\n(Pick all that apply)",
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ...feedbackOnKitItems
                        .map((e) =>
                            buildKitItemsListButton(e, 'podi', selectedPodi))
                        .toList(),
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (selectedPodi.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Select Any One",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 10;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider13(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField("Feedback on Kheer\n(Pick all that apply)",
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ...feedbackOnKitItems
                        .map((e) =>
                            buildKitItemsListButton(e, 'kheer', selectedKheer))
                        .toList(),
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (selectedKheer.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Select Any One",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 11;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider14(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    'Please let us know if there is anything about the kit items that you think we could improve ',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                Container(
                  height: 10.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    maxLines: null, // Set this
                    textCapitalization: TextCapitalization.sentences,
                    controller: kitItemsController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Answer';
                      } else if (value.length < 2) {
                        return emptyStringMsg;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Your Answer",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: eUser().userTextFieldHintFont,
                        color: eUser().userTextFieldHintColor,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    // textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 2.h),
                buildLabelTextField(
                    'If you feel that we could use some improvement, kindly offer your suggestions. ',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                Container(
                  height: 10.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    maxLines: null, // Set this
                    textCapitalization: TextCapitalization.sentences,
                    controller: suggestionsController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Answer';
                      } else if (value.length < 2) {
                        return emptyStringMsg;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Your Answer",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: eUser().userTextFieldHintFont,
                        color: eUser().userTextFieldHintColor,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    // textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (kitItemsController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else if (suggestionsController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 12;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider15(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    'Can We Get A Brief Testimonial (50-100 words)',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                Container(
                  height: 10.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    maxLines: null, // Set this
                    textCapitalization: TextCapitalization.sentences,
                    controller: testimonialController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Answer';
                      } else if (value.length < 2) {
                        return emptyStringMsg;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Your Answer",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: eUser().userTextFieldHintFont,
                        color: eUser().userTextFieldHintColor,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    // textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 2.h),
                buildLabelTextField(
                    'Please Mention Names & Numbers Of People You did Like To Refer This Program To (If Any)',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                Container(
                  height: 10.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    maxLines: null, // Set this
                    textCapitalization: TextCapitalization.sentences,
                    controller: referenceController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Your Answer';
                      } else if (value.length < 2) {
                        return emptyStringMsg;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Your Answer",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: eUser().userTextFieldHintFont,
                        color: eUser().userTextFieldHintColor,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    // textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (testimonialController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else if (referenceController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 13;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider16(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    'Would You Like To Sign Up For Our Membership That Gives You Support Plans, Lifestyle Management & Discounts On Future Programs & Consultations',
                    fontSize: headingFont),
                SizedBox(height: 3.h),
                buildPercentageButton(yesNo[0],
                    supportPlans == yesNo[0] ? gsecondaryColor : gWhiteColor,
                    () {
                  setState(() {
                    changedIndex5(
                      yesNo[0],
                    );
                    submittedIndex = 14;
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(yesNo[1],
                    supportPlans == yesNo[1] ? gsecondaryColor : gWhiteColor,
                    () {
                  setState(() {
                    changedIndex5(
                      yesNo[1],
                    );
                    submittedIndex = 14;
                    // _controller.forward();
                  });
                }),
                buildPercentageButton(yesNo[2],
                    supportPlans == yesNo[2] ? gsecondaryColor : gWhiteColor,
                    () {
                  setState(() {
                    changedIndex5(
                      yesNo[2],
                    );
                    submittedIndex = 14;
                    // _controller.forward();
                  });
                }),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () {
                    if (supportPlans.isEmpty) {
                      AppConfig().showSnackbar(
                          context, "Please Select Support Plan.",
                          isError: true, bottomPadding: 10);
                    } else {
                      submittedIndex = 14;
                      _controller.forward();
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider17(int index) {
    return StatefulBuilder(builder: (_, setState) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 17),
              blurRadius: 10.0,
              color: gWhiteColor.withOpacity(0.3),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabelTextField(
                    "Can We Get A Picture Of You To Put A Face To This Feedback?",
                    fontSize: headingFont,
                    isMandatory: false),
                SizedBox(height: 3.h),
                GestureDetector(
                  onTap: () async {
                    final result = await FilePicker.platform
                        .pickFiles(withReadStream: true, allowMultiple: false);

                    if (result == null) return;
                    if (result.files.first.extension!.contains("png") ||
                        result.files.first.extension!.contains("jpg") ||
                        result.files.first.extension!.contains("jpeg")) {
                      var path3 = result.files.single.name;
                      File file = File(path3 ?? "");
                      medicalRecords.add(result.files.first);
                      _finalFiles.add(file);
                      // addFilesToList(File(result.paths.first!));
                    } else {
                      AppConfig().showSnackbar(
                          context, "Please select png/jpg/jpeg files",
                          isError: true);
                    }

                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: gHintTextColor.withOpacity(0.3), width: 1),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          color: gsecondaryColor,
                          size: 2.5.h,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Add File',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: gsecondaryColor,
                            fontFamily: "GothamMedium",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                (_finalFiles.isEmpty)
                    ? SizedBox()
                    : Center(
                        child: SizedBox(
                          height: 27.h,
                          child: ListView.builder(
                            itemCount: _finalFiles.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final file = _finalFiles[index];
                              return buildFile(file, index);
                            },
                          ),
                        ),
                      ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    submittedIndex = 15;
                    _controller.forward();
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.done_outlined,
                          color: gsecondaryColor,
                          size: 3.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  slider18(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 5),
              blurRadius: 10.0,
              color: gGreyColor.withOpacity(0.5),
            )
          ],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: buildLabelTextField("Give us a feedback on",
                      fontSize: headingFont),
                ),
                SizedBox(height: 1.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Support from Doctors during the program",
                    style: TextStyle(
                      fontSize: 13.dp,
                      color: gWhiteColor,
                      // height: 1.35,
                      fontFamily: kFontBook,
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          fontSize: 13.dp,
                          color: kPrimaryColor,
                          fontFamily: "PoppinsSemiBold",
                        ),
                      ),
                    ],
                  ),
                ),
                buildRating1(),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Chat Support",
                    style: TextStyle(
                      fontSize: 13.dp,
                      color: gWhiteColor,
                      // height: 1.35,
                      fontFamily: kFontBook,
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          fontSize: 13.dp,
                          color: kPrimaryColor,
                          fontFamily: "PoppinsSemiBold",
                        ),
                      ),
                    ],
                  ),
                ),
                buildRating2(),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Home remedies during the program",
                    style: TextStyle(
                      fontSize: 13.dp,
                      color: gWhiteColor,
                      // height: 1.35,
                      fontFamily: kFontBook,
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          fontSize: 13.dp,
                          color: kPrimaryColor,
                          fontFamily: "PoppinsSemiBold",
                        ),
                      ),
                    ],
                  ),
                ),
                buildRating3(),
                // SizedBox(height: 1.h),
                ButtonWidget(
                  text: 'Submit',
                  onPressed: () {
                    if (!isLoading) {
                      if (rating1.isEmpty ||
                          rating2.isEmpty ||
                          rating3.isEmpty) {
                        AppConfig().showSnackbar(
                            context, "Please Select All Rating",
                            isError: true, bottomPadding: 10);
                      } else {
                        submitProgramFeedbackForm(
                            setstate,
                            widget.programContinuesdStatus,
                            selectedAfterTheProgram.toString(),
                            afterTheProgramController.text.toString(),
                            selectedPercentage.toString(),
                            selectedBreathing.toString(),
                            mealyesno.toString(),
                            yogayesno.toString(),
                            mealHighLightController.text.toString(),
                            positiveController.text.toString(),
                            negativeController.text.toString(),
                            selectedInfusions.toString(),
                            selectedSoups.toString(),
                            selectedPorridges.toString(),
                            selectedPodi.toString(),
                            selectedKheer.toString(),
                            kitItemsController.text.toString(),
                            rating1.toString(),
                            rating2.toString(),
                            rating3.toString(),
                            improvedHealthController.text.toString(),
                            suggestionsController.text.toString(),
                            testimonialController.text.toString(),
                            referenceController.text.toString(),
                            supportPlans.toString(),
                            "0"
                            // ifDiscontinuedController.text.toString(),
                            );
                      }
                    }
                  },
                  isLoading: isLoading,
                  radius: 10,
                  buttonWidth: 20.w,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  int ratings1 = 4;
  int ratings2 = 4;
  int ratings3 = 4;

  buildRating1() {
    return StatefulBuilder(builder: (_, setstate) {
      return Padding(
        padding: EdgeInsets.only(top: 1.h, left: 5.w,right: 5.w),
        child: Transform.scale(
          scale: 0.8,
          child: ReviewSlider(
              initialValue: ratings1,
              circleDiameter: 45,
              onChange: (int value) {
                ratings1 = value;
                if (ratings1 == 4.0) {
                  rating1 = "Very Good";
                } else if (ratings1 == 3.0) {
                  rating1 = "Good";
                } else if (ratings1 == 2.0) {
                  rating1 = "Average";
                } else if (ratings1 == 1.0) {
                  rating1 = "Below Average";
                } else if (ratings1 == 0.0) {
                  rating1 = "Poor";
                }
                print("ratings1 : $ratings1");
              }),
        ),
      );
    });
  }

  buildRating2() {
    return Padding(
      padding: EdgeInsets.only(top: 1.h, left: 5.w,right: 5.w),
      child: Transform.scale(
        scale: 0.8,
        child: ReviewSlider(
            initialValue: ratings2,
            circleDiameter: 45,
            onChange: (int value) {
              ratings2 = value;
              if (ratings2 == 4.0) {
                rating2 = "Very Good";
              } else if (ratings2 == 3.0) {
                rating2 = "Good";
              } else if (ratings2 == 2.0) {
                rating2 = "Average";
              } else if (ratings2 == 1.0) {
                rating2 = "Below Average";
              } else if (ratings2 == 0.0) {
                rating2 = "Poor";
              }
              print("ratings2 : $ratings2");
            }),
      ),
    );
  }

  buildRating3() {
    return Padding(
      padding: EdgeInsets.only(top: 1.h, left: 5.w,right: 5.w),
      child: Transform.scale(
        scale: 0.8,
        child: ReviewSlider(
            initialValue: ratings3,
            circleDiameter: 45,
            onChange: (int value) {
              ratings3 = value;
              if (ratings3 == 4.0) {
                rating3 = "Very Good";
              } else if (ratings3 == 3.0) {
                rating3 = "Good";
              } else if (ratings3 == 2.0) {
                rating3 = "Average";
              } else if (ratings3 == 1.0) {
                rating3 = "Below Average";
              } else if (ratings3 == 0.0) {
                rating3 = "Poor";
              }
              print("ratings3 : $ratings3");
            }),
      ),
    );
  }

  buildKitItemsListButton(
      CheckBoxSettings kitItems, String from, List<String> selectedItems) {
    return StatefulBuilder(builder: (_, setState) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
          child: ButtonWidget(text: kitItems.title.toString(),
            onPressed: () {
            setState(() {
              if (from == 'influsions') {
                setState(() {
                  if (!selectedItems.contains(kitItems.title)) {
                    selectedItems.add(kitItems.title!);
                    kitItems.value = influsionsValue;
                  } else {
                    setState(() {
                      if (selectedItems.contains(kitItems.title)) {
                        selectedItems.remove(kitItems.title!);
                        kitItems.value = influsionsValue;
                      }
                    });
                  }
                });
              } else if (from == 'soups') {
                setState(() {
                  if (!selectedItems.contains(kitItems.title)) {
                    selectedItems.add(kitItems.title!);
                    kitItems.value = influsionsValue;
                  } else {
                    setState(() {
                      if (selectedItems.contains(kitItems.title)) {
                        selectedItems.remove(kitItems.title!);
                        kitItems.value = influsionsValue;
                      }
                    });
                  }
                });
              } else if (from == 'porridges') {
                setState(() {
                  if (!selectedItems.contains(kitItems.title)) {
                    selectedItems.add(kitItems.title!);
                    kitItems.value = influsionsValue;
                  } else {
                    setState(() {
                      if (selectedItems.contains(kitItems.title)) {
                        selectedItems.remove(kitItems.title!);
                        kitItems.value = influsionsValue;
                      }
                    });
                  }
                });
              } else if (from == 'podi') {
                setState(() {
                  if (!selectedItems.contains(kitItems.title)) {
                    selectedItems.add(kitItems.title!);
                    kitItems.value = influsionsValue;
                  } else {
                    setState(() {
                      if (selectedItems.contains(kitItems.title)) {
                        selectedItems.remove(kitItems.title!);
                        kitItems.value = influsionsValue;
                      }
                    });
                  }
                });
              } else if (from == 'kheer') {
                setState(() {
                  if (!selectedItems.contains(kitItems.title)) {
                    selectedItems.add(kitItems.title!);
                    kitItems.value = influsionsValue;
                  } else {
                    setState(() {
                      if (selectedItems.contains(kitItems.title)) {
                        selectedItems.remove(kitItems.title!);
                        kitItems.value = influsionsValue;
                      }
                    });
                  }
                });
              }
              print(selectedItems);
            });
          },
            isLoading: false,
            color: selectedItems.contains(kitItems.title)
                ? gsecondaryColor
                : gWhiteColor,
            textColor:  selectedItems.contains(kitItems.title)
                ? gWhiteColor
                : gBlackColor,
            buttonWidth: double.maxFinite,
            radius: 10,
            font: selectedItems.contains(kitItems.title)
                ? kFontMedium
                : kFontBook,
          ),
        ),
        // IntrinsicWidth(
        //   child: GestureDetector(
        //     onTap: () {
        //       setState(() {
        //         if (from == 'influsions') {
        //           setState(() {
        //             if (!selectedItems.contains(kitItems.title)) {
        //               selectedItems.add(kitItems.title!);
        //               kitItems.value = influsionsValue;
        //             } else {
        //               setState(() {
        //                 if (selectedItems.contains(kitItems.title)) {
        //                   selectedItems.remove(kitItems.title!);
        //                   kitItems.value = influsionsValue;
        //                 }
        //               });
        //             }
        //           });
        //         } else if (from == 'soups') {
        //           setState(() {
        //             if (!selectedItems.contains(kitItems.title)) {
        //               selectedItems.add(kitItems.title!);
        //               kitItems.value = influsionsValue;
        //             } else {
        //               setState(() {
        //                 if (selectedItems.contains(kitItems.title)) {
        //                   selectedItems.remove(kitItems.title!);
        //                   kitItems.value = influsionsValue;
        //                 }
        //               });
        //             }
        //           });
        //         } else if (from == 'porridges') {
        //           setState(() {
        //             if (!selectedItems.contains(kitItems.title)) {
        //               selectedItems.add(kitItems.title!);
        //               kitItems.value = influsionsValue;
        //             } else {
        //               setState(() {
        //                 if (selectedItems.contains(kitItems.title)) {
        //                   selectedItems.remove(kitItems.title!);
        //                   kitItems.value = influsionsValue;
        //                 }
        //               });
        //             }
        //           });
        //         } else if (from == 'podi') {
        //           setState(() {
        //             if (!selectedItems.contains(kitItems.title)) {
        //               selectedItems.add(kitItems.title!);
        //               kitItems.value = influsionsValue;
        //             } else {
        //               setState(() {
        //                 if (selectedItems.contains(kitItems.title)) {
        //                   selectedItems.remove(kitItems.title!);
        //                   kitItems.value = influsionsValue;
        //                 }
        //               });
        //             }
        //           });
        //         } else if (from == 'kheer') {
        //           setState(() {
        //             if (!selectedItems.contains(kitItems.title)) {
        //               selectedItems.add(kitItems.title!);
        //               kitItems.value = influsionsValue;
        //             } else {
        //               setState(() {
        //                 if (selectedItems.contains(kitItems.title)) {
        //                   selectedItems.remove(kitItems.title!);
        //                   kitItems.value = influsionsValue;
        //                 }
        //               });
        //             }
        //           });
        //         }
        //         print(selectedItems);
        //       });
        //     },
        //     child: Container(
        //       margin: EdgeInsets.symmetric(vertical: 1.h),
        //       padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
        //       decoration: BoxDecoration(
        //         color: selectedItems.contains(kitItems.title)
        //             ? gsecondaryColor
        //             : gWhiteColor,
        //         borderRadius: BorderRadius.circular(10),
        //         boxShadow: [
        //           BoxShadow(
        //             color: kLineColor.withOpacity(0.3),
        //             offset: const Offset(2, 3),
        //             blurRadius: 5,
        //           ),
        //         ],
        //       ),
        //       child: Center(
        //         child: Text(
        //           kitItems.title.toString(),
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //             color: gBlackColor,
        //             height: 1.3,
        //             fontFamily: kFontBook,
        //             fontSize: subHeadingFont,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      );
    });
  }

  addFilesToList(File file) async {
    newList.clear();
    setState(() {
      fileFormatList.add(file);
    });

    for (int i = 0; i < fileFormatList.length; i++) {
      var stream =
          http.ByteStream(DelegatingStream.typed(fileFormatList[i].openRead()));
      var length = await fileFormatList[i].length();
      var multipartFile = http.MultipartFile("face_to_feedback", stream, length,
          filename: fileFormatList[i].path);
      newList.add(multipartFile);
      print("newList : $newList");
    }

    setState(() {});
  }

  Widget buildFile(File file, int index) {
    return ListTile(
      shape: Border(bottom: BorderSide()),
      // leading: SizedBox(
      //     width: 50, height: 50, child: Image.file(File(filename.path!))),
      title: Text(
        file.path.split("/").last,
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: kFontBold,
          fontSize: 11.sp,
        ),
      ),
      trailing: GestureDetector(
          onTap: () {
            medicalRecords.removeAt(index!);
            _finalFiles.removeAt(index);
            setState(() {});
          },
          child: const Icon(
            Icons.delete_outline_outlined,
            color: gMainColor,
          )),
    );
  }

  final FeedbackRepo repository = FeedbackRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  submitProgramFeedbackForm(
    Function setstate,
    int programStatus,
    String changesAfterProgram,
    String otherChangesAfterProgram,
    String didProgramHeal,
    String stickToPlan,
    String mealPlanEasyToFollow,
    String yogaPlanEasyToFollow,
    String commentsOnMealYogaPlans,
    String programPositiveHighlights,
    String programNegativeHighlights,
    String infusions,
    String soups,
    String porridges,
    String podi,
    String kheer,
    String kitItemsImproveSuggestions,
    String supportFromDoctors,
    String supportInWhatsappGroup,
    String homeRemediesDuringProgram,
    String improvementAndSuggestions,
    String programImproveHealthAnotherWay,
    String briefTestimonial,
    String referProgram,
    String membership,
    String reasonOfProgramDiscontinue,
  ) async {
    setstate(() {
      isLoading = true;
    });
    final res = await medicalFeedbackService?.submitProgramFeedbackService(
      programStatus: programStatus,
      changesAfterProgram: changesAfterProgram,
      otherChangesAfterProgram: otherChangesAfterProgram,
      didProgramHeal: didProgramHeal,
      stickToPlan: stickToPlan,
      mealPlanEasyToFollow: mealPlanEasyToFollow,
      yogaPlanEasyToFollow: yogaPlanEasyToFollow,
      commentsOnMealYogaPlans: commentsOnMealYogaPlans,
      programPositiveHighlights: programPositiveHighlights,
      programNegativeHighlights: programNegativeHighlights,
      infusions: infusions,
      soups: soups,
      porridges: porridges,
      podi: podi,
      kheer: kheer,
      kitItemsImproveSuggestions: kitItemsImproveSuggestions,
      supportFromDoctors: supportFromDoctors,
      supportInWhatsappGroup: supportInWhatsappGroup,
      homeRemediesDuringProgram: homeRemediesDuringProgram,
      improvementAndSuggestions: improvementAndSuggestions,
      programImproveHealthAnotherWay: programImproveHealthAnotherWay,
      briefTestimonial: briefTestimonial,
      referProgram: referProgram,
      membership: membership,
      faceToFeedback: medicalRecords,
      reasonOfProgramDiscontinue: reasonOfProgramDiscontinue,
    );

    print("medicalFeedbackForm:$res");
    print("res.runtimeType: ${res.runtimeType}");

    if (res.runtimeType == RegisterResponse) {
      RegisterResponse response = res;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const PostGutTypeDiagnosis(),
          ),
          (route) => route.isFirst);
    } else {
      String result = (res as ErrorModel).message ?? '';
      AppConfig().showSnackbar(context, result, isError: true, duration: 4);
    }
    setstate(() {
      isLoading = false;
    });
  }
}
