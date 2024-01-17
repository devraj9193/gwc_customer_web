import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:tcard/tcard.dart';

import '../../model/error_model.dart';
import '../../model/new_user_model/register/register_model.dart';
import '../../repository/api_service.dart';
import '../../repository/medical_program_feedback_repo/medical_feedback_repo.dart';
import '../../services/medical_program_feedback_service/medical_feedback_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;

import '../dashboard_screen.dart';
import '../evalution_form/check_box_settings.dart';

class PostGutTypeDiagnosis extends StatefulWidget {
  const PostGutTypeDiagnosis({Key? key}) : super(key: key);

  @override
  State<PostGutTypeDiagnosis> createState() => _PostGutTypeDiagnosisState();
}

class _PostGutTypeDiagnosisState extends State<PostGutTypeDiagnosis> {
  final TCardController _controller = TCardController();
  bool isLoading = false;

  int _index = 0;
  int submittedIndex = -1;

  TextEditingController selectedSymptomsAfterMealController =
      TextEditingController();
  TextEditingController selectedSymptomsAfterStomachUpsetController =
      TextEditingController();

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
  ];

  List<Widget> cards = [];

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
            ? slider1(index)
            : index == 1
                ? slider2(index)
                : index == 2
                    ? slider3(index)
                    : index == 3
                        ? slider4(index)
                        : index == 4
                            ? slider5(index)
                            : index == 5
                                ? slider6(index)
                                : index == 6
                                    ? slider7(index)
                                    : index == 7
                                        ? slider8(index)
                                        : index == 8
                                            ? slider9(index)
                                            : Container();
      },
    );
  }

  final hungerPattern = [
    CheckBoxSettings(title: "Inconsistent(Non-predictable)"),
    CheckBoxSettings(title: "Mild hunger (Tolerable hunger)"),
    CheckBoxSettings(title: "Intense hunger/Cant tolerate hunger"),
    CheckBoxSettings(title: "On time(3 hours after previous meal)"),
    CheckBoxSettings(title: "Don’t feel hungry but eat at a given time"),
  ];
  String selectedHungerPattern = '';

  final stoolConsistency = [
    CheckBoxSettings(
        title: "Separate hard lumps, like nuts(Difficult to pass)"),
    CheckBoxSettings(title: "Sausage-shaped, but lumpy."),
    CheckBoxSettings(title: "Like a sausage with cracks on the surface."),
    CheckBoxSettings(title: "Like a smooth, soft sausage or snake."),
    CheckBoxSettings(title: "Soft blobs with clear-cut edges (easy to pass)."),
    CheckBoxSettings(title: "Fluffy pieces with ragged edges, a mushy stool."),
    CheckBoxSettings(title: "Watery, entirely liquid"),
  ];
  String selectedStoolConsistency = '';

  final evacuationTime = [
    CheckBoxSettings(title: "Longer evacuation time"),
    CheckBoxSettings(title: "Normal/ easy evacuation within minimal time"),
    CheckBoxSettings(title: "Very quick evacuation with urgency"),
  ];
  String selectedEvacuationTime = '';

  final effort = [
    CheckBoxSettings(
        title:
            "Requires straining to evacuate like holding breath to initiate"),
    CheckBoxSettings(title: "Moderate effort like deep breathing"),
    CheckBoxSettings(title: "Minimal strain"),
    CheckBoxSettings(title: "Effortless and immediate"),
  ];
  String selectedEffort = '';

  final satisfactionAfterEvacuation = [
    CheckBoxSettings(title: "Feeling of Incomplete evacuation"),
    CheckBoxSettings(title: "Always Satisfactory"),
    CheckBoxSettings(title: "Mostly satisfactory"),
    CheckBoxSettings(title: "Wanting to go again after passing motion"),
  ];
  String selectedSatisfactionAfterEvacuation = '';

  final frequency = [
    CheckBoxSettings(
        title:
            "Not passing everyday/Unspecific time/Irregular (Within 24 - 48 hours)"),
    CheckBoxSettings(title: "Once in 24hrs"),
    CheckBoxSettings(title: "Two times in 24hrs"),
    CheckBoxSettings(title: "Multiple times"),
  ];
  String selectedFrequency = '';

  final stimulation = [
    CheckBoxSettings(title: "Need stimulant like warm water, tea, smoke etc"),
    CheckBoxSettings(title: "No need for stimulants"),
    CheckBoxSettings(
        title:
            "Loose stools/Urge to evacuate with spicy or after meals/milk inducing easy stools"),
    CheckBoxSettings(
        title: "Easy urge in the morning without any external aid"),
  ];
  String selectedStimulation = '';

  final symptomsAfterMeal = [
    CheckBoxSettings(title: "Bloating/Bulged stomach/Gassiness"),
    CheckBoxSettings(title: "Fullness of stomach"),
    CheckBoxSettings(title: "Urge to defecate after any meal"),
    CheckBoxSettings(title: "Absence of any symptoms"),
    CheckBoxSettings(title: "Other"),
  ];
  String selectedSymptomsAfterMeal = '';
  bool symptomsAfterMealOtherSelected = false;

  final symptomsAfterStomachUpset = [
    CheckBoxSettings(title: "Constipation/Bloating"),
    CheckBoxSettings(title: "Heaviness of abdomen/Loss of appetite"),
    CheckBoxSettings(title: "Loose stools/Burning"),
    CheckBoxSettings(title: "Other"),
  ];
  String selectedSymptomsAfterStomachUpset = '';
  bool symptomsAfterStomachUpsetOtherSelected = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildAppBar(
                  () {
                    Navigator.pop(context);
                  },
                  isBackEnable: true,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Gut Type Diagnosis after the Program",
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
                  "Your insights will enable us to gain a better understanding of your gut type, allowing us to provide you with tailored Gut Maintenance Guide and support moving forward.",
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
                Center(
                  child: TCard(
                    cards: cards,
                    lockYAxis: true,
                    size: Size(MediaQuery.of(context).size.shortestSide < 600 ? double.maxFinite : 60.w, 80.h),
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
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        fontSize: 13.dp,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  slider1(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle(
                  'Hunger pattern (When do you feel the true hunger?)',
                  'True hunger is the urge felt after previous food is completely digested. NOT a craving or stress based need to eat.',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
              ListView.separated(
                  itemCount: hungerPattern.length,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var success = hungerPattern[index];
                    return Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: gWhiteColor,
                            disabledColor: gsecondaryColor),
                        child: RadioListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4), //

                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: success.title.toString(),

                          activeColor: gsecondaryColor,
                          splashRadius: 0,
                          tileColor: gWhiteColor,
                          groupValue: selectedHungerPattern,
                          // controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setstate(() {
                              selectedHungerPattern = value.toString();
                              print(
                                  "selectedHungerPattern: $selectedHungerPattern");
                            });
                          },
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              success.title ?? '',
                              style: TextStyle(
                                color: gWhiteColor,
                                height: 1.3,
                                fontFamily: kFontBook,
                                fontSize: subHeadingFont,
                              ),
                              // style: AllListText().subHeadingText(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              GestureDetector(
                onTap: () {
                  if (selectedHungerPattern.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Any One !",
                        isError: true, bottomPadding: 10);
                  } else {
                    submittedIndex = 0;
                    _controller.forward();
                  }
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                        color: gWhiteColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.done_outlined,
                        color: gsecondaryColor,
                        size: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  slider2(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle(
                  'Stool consistency', 'Refer below given Bristol Stool chart',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
             Expanded(child:  SingleChildScrollView(
               child: ListView.separated(
                    itemCount: stoolConsistency.length,
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      var success = stoolConsistency[index];
                      return Transform.translate(
                        offset: const Offset(-10, 0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor: gWhiteColor,
                              disabledColor: gsecondaryColor),
                          child: RadioListTile(
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4), //
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: success.title.toString(),
                            activeColor: gsecondaryColor,
                            splashRadius: 0,
                            groupValue: selectedStoolConsistency,
                            // controlAffinity: ListTileControlAffinity.trailing,
                            onChanged: (value) {
                              setstate(() {
                                selectedStoolConsistency = value.toString();
                                print(
                                    "selectedStoolConsistency: $selectedStoolConsistency");
                              });
                            },
                            title: Transform.translate(
                              offset: const Offset(-10, 0),
                              child: Text(
                                success.title ?? '',
                                style: TextStyle(
                                  color: gWhiteColor,
                                  height: 1.3,
                                  fontFamily: kFontBook,
                                  fontSize: subHeadingFont,
                                ),
                                // style: AllListText().subHeadingText(),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
             ),),
              GestureDetector(
                onTap: () {
                  if (selectedStoolConsistency.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Any One !",
                        isError: true, bottomPadding: 10);
                  } else {
                    submittedIndex = 1;
                    _controller.forward();
                  }
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                        color: gWhiteColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.done_outlined,
                        color: gsecondaryColor,
                        size: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // slider3(int index) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return Container(
  //       padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
  //       decoration: BoxDecoration(
  //         color: colors[index].withOpacity(1),
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
  //           // crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SizedBox(height: 2.h),
  //             buildQuestionTitle('Bristol Stool chart image', '',
  //                 fontSize: headingFont),
  //             SizedBox(height: 4.h),
  //             SizedBox(
  //               height: 18.h,
  //               child: const Image(
  //                 image: AssetImage("assets/images/stool_image.png"),
  //                 fit: BoxFit.fill,
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 submittedIndex = 2;
  //                 _controller.forward();
  //               },
  //               child: Center(
  //                 child: Container(
  //                   padding: EdgeInsets.all(5),
  //                   margin: EdgeInsets.symmetric(vertical: 4.h),
  //                   decoration: BoxDecoration(
  //                       color: gWhiteColor, shape: BoxShape.circle),
  //                   child: Center(
  //                     child: Icon(
  //                       Icons.done_outlined,
  //                       color: gsecondaryColor,
  //                       size: 2.h,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  slider3(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle('Evacuation time',
                  'Time taken from the time you sit on the pot to wash',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
              ListView.separated(
                  itemCount: evacuationTime.length,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var success = evacuationTime[index];
                    return Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: gWhiteColor,
                            disabledColor: gsecondaryColor),
                        child: RadioListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4), //
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: success.title.toString(),
                          activeColor: gsecondaryColor,
                          splashRadius: 0,
                          groupValue: selectedEvacuationTime,
                          // controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setstate(() {
                              selectedEvacuationTime = value.toString();
                              print(
                                  "selectedEvacuationTime: $selectedEvacuationTime");
                            });
                          },
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              success.title ?? '',
                              style: TextStyle(
                                color: gWhiteColor,
                                height: 1.3,
                                fontFamily: kFontBook,
                                fontSize: subHeadingFont,
                              ),
                              // style: AllListText().subHeadingText(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              GestureDetector(
                onTap: () {
                  if (selectedEvacuationTime.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Any One !",
                        isError: true, bottomPadding: 10);
                  } else {
                    submittedIndex = 2;
                    _controller.forward();
                  }
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                        color: gWhiteColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.done_outlined,
                        color: gsecondaryColor,
                        size: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  slider4(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle('Effort', 'The push or strain to pass motion.',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
              ListView.separated(
                  itemCount: effort.length,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var success = effort[index];
                    return Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: gWhiteColor,
                            disabledColor: gsecondaryColor),
                        child: RadioListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4), //
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: success.title.toString(),
                          activeColor: gsecondaryColor,
                          splashRadius: 0,
                          groupValue: selectedEffort,
                          // controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setstate(() {
                              selectedEffort = value.toString();
                              print("selectedEffort: $selectedEffort");
                            });
                          },
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              success.title ?? '',
                              style: TextStyle(
                                color: gWhiteColor,
                                height: 1.3,
                                fontFamily: kFontBook,
                                fontSize: subHeadingFont,
                              ),
                              // style: AllListText().subHeadingText(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              GestureDetector(
                onTap: () {
                  if (selectedEffort.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Any One !",
                        isError: true, bottomPadding: 10);
                  } else {
                    submittedIndex = 3;
                    _controller.forward();
                  }
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                        color: gWhiteColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.done_outlined,
                        color: gsecondaryColor,
                        size: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  slider5(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle(
                  'Frequency', 'The push or strain to pass motion.',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
              ListView.separated(
                  itemCount: frequency.length,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var success = frequency[index];
                    return Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: gWhiteColor,
                            disabledColor: gsecondaryColor),
                        child: RadioListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4), //
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: success.title.toString(),
                          activeColor: gsecondaryColor,
                          splashRadius: 0,
                          groupValue: selectedFrequency,
                          // controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setstate(() {
                              selectedFrequency = value.toString();
                              print("selectedFrequency: $selectedFrequency");
                            });
                          },
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              success.title ?? '',
                              style: TextStyle(
                                color: gWhiteColor,
                                height: 1.3,
                                fontFamily: kFontBook,
                                fontSize: subHeadingFont,
                              ),
                              // style: AllListText().subHeadingText(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              GestureDetector(
                onTap: () {
                  if (selectedFrequency.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Any One !",
                        isError: true, bottomPadding: 10);
                  } else {
                    submittedIndex = 4;
                    _controller.forward();
                  }
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                        color: gWhiteColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.done_outlined,
                        color: gsecondaryColor,
                        size: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  slider6(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle('Stimulation',
                  'Do you need any aid or is there a trigger that help you  pass motion',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
              ListView.separated(
                  itemCount: stimulation.length,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var success = stimulation[index];
                    return Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: gWhiteColor,
                            disabledColor: gsecondaryColor),
                        child: RadioListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4), //
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: success.title.toString(),
                          activeColor: gsecondaryColor,
                          splashRadius: 0,
                          groupValue: selectedStimulation,
                          // controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setstate(() {
                              selectedStimulation = value.toString();
                              print(
                                  "selectedStimulation: $selectedStimulation");
                            });
                          },
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              success.title ?? '',
                              style: TextStyle(
                                color: gWhiteColor,
                                height: 1.3,
                                fontFamily: kFontBook,
                                fontSize: subHeadingFont,
                              ),
                              // style: AllListText().subHeadingText(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              GestureDetector(
                onTap: () {
                  if (selectedStimulation.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Any One !",
                        isError: true, bottomPadding: 10);
                  } else {
                    submittedIndex = 5;
                    _controller.forward();
                  }
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                        color: gWhiteColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.done_outlined,
                        color: gsecondaryColor,
                        size: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  slider7(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle('Satisfaction after evacuation',
                  'The feeling of excreting completely & feeling complete relief',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
              ListView.separated(
                  itemCount: satisfactionAfterEvacuation.length,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var success = satisfactionAfterEvacuation[index];
                    return Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: gWhiteColor,
                            disabledColor: gsecondaryColor),
                        child: RadioListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4), //
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: success.title.toString(),
                          activeColor: gsecondaryColor,
                          splashRadius: 0,
                          groupValue: selectedSatisfactionAfterEvacuation,
                          // controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setstate(() {
                              selectedSatisfactionAfterEvacuation =
                                  value.toString();
                              print(
                                  "selectedSatisfactionAfterEvacuation: $selectedSatisfactionAfterEvacuation");
                            });
                          },
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              success.title ?? '',
                              style: TextStyle(
                                color: gWhiteColor,
                                height: 1.3,
                                fontFamily: kFontBook,
                                fontSize: subHeadingFont,
                              ),
                              // style: AllListText().subHeadingText(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              GestureDetector(
                onTap: () {
                  if (selectedSatisfactionAfterEvacuation.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Any One !",
                        isError: true, bottomPadding: 10);
                  } else {
                    submittedIndex = 6;
                    _controller.forward();
                  }
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                        color: gWhiteColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.done_outlined,
                        color: gsecondaryColor,
                        size: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  slider8(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle(
                  'What are the usual or common symptoms you experience even after the normal meal?',
                  'This is not regular but a tendency which occurs occasionally when you have either over eaten or had certain types of food',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
              ListView.separated(
                  itemCount: symptomsAfterMeal.length,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var success = symptomsAfterMeal[index];
                    return Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: gWhiteColor,
                            disabledColor: gsecondaryColor),
                        child: RadioListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4), //
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: success.title.toString(),
                          activeColor: gsecondaryColor,
                          splashRadius: 0,
                          groupValue: selectedSymptomsAfterMeal,
                          // controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setstate(() {
                              selectedSymptomsAfterMeal = value.toString();
                              print(
                                  "selectedSymptomsAfterMeal: $selectedSymptomsAfterMeal");
                            });
                          },
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              success.title ?? '',
                              style: TextStyle(
                                color: gWhiteColor,
                                height: 1.3,
                                fontFamily: kFontBook,
                                fontSize: subHeadingFont,
                              ),
                              // style: AllListText().subHeadingText(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              Visibility(
                visible: selectedSymptomsAfterMeal == "Other",
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: selectedSymptomsAfterMealController,
                  cursorColor: kPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty &&
                        selectedSymptomsAfterMeal == "Other") {
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
              GestureDetector(
                onTap: () {
                  if (selectedSymptomsAfterMeal.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Any One !",
                        isError: true, bottomPadding: 10);
                  } else if (selectedSymptomsAfterMeal == 'Other' &&
                      selectedSymptomsAfterMealController.text.isEmpty) {
                    AppConfig().showSnackbar(
                        context, "Please Enter your answer",
                        isError: true, bottomPadding: 10);
                  } else {
                    submittedIndex = 7;
                    _controller.forward();
                  }
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                        color: gWhiteColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.done_outlined,
                        color: gsecondaryColor,
                        size: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  slider9(int index) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              buildQuestionTitle(
                  'What are the usual symptoms whenever you have a stomach upset?',
                  'We are trying to assess the tendency of your gut when you have a stomach upset',
                  fontSize: headingFont),
              SizedBox(height: 1.h),
              ListView.separated(
                  itemCount: symptomsAfterStomachUpset.length,
                  controller: ScrollController(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    var success = symptomsAfterStomachUpset[index];
                    return Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: gWhiteColor,
                            disabledColor: gsecondaryColor),
                        child: RadioListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4), //
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: success.title.toString(),
                          activeColor: gsecondaryColor,
                          splashRadius: 0,
                          groupValue: selectedSymptomsAfterStomachUpset,
                          // controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setstate(() {
                              selectedSymptomsAfterStomachUpset =
                                  value.toString();
                              print(
                                  "selectedSymptomsAfterStomachUpset: $selectedSymptomsAfterStomachUpset");
                            });
                          },
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              success.title ?? '',
                              style: TextStyle(
                                color: gWhiteColor,
                                height: 1.3,
                                fontFamily: kFontBook,
                                fontSize: subHeadingFont,
                              ),
                              // style: AllListText().subHeadingText(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              Visibility(
                visible: selectedSymptomsAfterStomachUpset == "Other",
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: selectedSymptomsAfterStomachUpsetController,
                  cursorColor: kPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty &&
                        selectedSymptomsAfterStomachUpset == "Other") {
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
              Center(
                child: IntrinsicWidth(
                  child: GestureDetector(
                    onTap: () {
                      if (!isLoading) {
                        if (selectedSymptomsAfterStomachUpset.isEmpty) {
                          AppConfig().showSnackbar(
                              context, "Please Select Any One !",
                              isError: true, bottomPadding: 10);
                        } else if (selectedSymptomsAfterStomachUpset == 'Other' &&
                            selectedSymptomsAfterStomachUpsetController
                                .text.isEmpty) {
                          AppConfig().showSnackbar(
                              context, "Please Enter your answer",
                              isError: true, bottomPadding: 10);
                        } else {
                          submitGutDiagnosisForm(setstate);
                        }
                      }
                    },
                    child: Container(padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: 5.w),
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      decoration: BoxDecoration(
                        color: eUser().buttonColor,
                        borderRadius:
                            BorderRadius.circular(eUser().buttonBorderRadius),
                        // border: Border.all(
                        //     color: eUser().buttonBorderColor,
                        //     width: eUser().buttonBorderWidth
                        // ),
                      ),
                      child: (isLoading)
                          ? buildThreeBounceIndicator(
                              color: eUser().threeBounceIndicatorColor)
                          : Center(
                              child: Text(
                              'Submit',
                              style: TextStyle(
                                fontFamily: eUser().buttonTextFont,
                                color: eUser().buttonTextColor,
                                fontSize: eUser().buttonTextSize,
                              ),
                            )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  buildQuestionTitle(String name, String notes,
      {double? fontSize, double textScleFactor = 0.9, Key? key}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          key: key,
          text: TextSpan(
              text: name,
              style: TextStyle(
                fontSize: fontSize ?? 9.sp,
                color: gWhiteColor,
                height: 1.35,
                fontFamily: kFontMedium,
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: kPrimaryColor,
                    fontFamily: "PoppinsSemiBold",
                  ),
                )
              ]),
          textScaler: TextScaler.linear(textScleFactor),
        ),
        Text(
          "Note: $notes",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: kFontBook,
              color: gWhiteColor,
              height: 1.3,
              fontSize: subHeadingFont),
        ),
      ],
    );
  }

  final FeedbackRepo repository = FeedbackRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void submitGutDiagnosisForm(
    Function setstate,
  ) async {
    Map formDetails = {
      'hunger_pattern': selectedHungerPattern,
      'stool_consistency': selectedStoolConsistency,
      'evacuation_time': selectedEvacuationTime,
      'effort': selectedEffort,
      'satisfaction_after_evacuation': selectedSatisfactionAfterEvacuation,
      'frequency': selectedFrequency,
      'stimulation': selectedStimulation,
      'symptoms_after_meal': selectedSymptomsAfterMeal,
      'symptoms_after_stomach_upset': selectedSymptomsAfterStomachUpset,
    };

    setstate(() {
      isLoading = true;
    });
    final res =
        await medicalFeedbackService?.submitGutDiagnosisService(formDetails);

    print("submitGutDiagnosisForm:$res");
    print("res.runtimeType: ${res.runtimeType}");

    if (res.runtimeType == RegisterResponse) {
      RegisterResponse response = res;
      AppConfig().showSnackbar(context, response.errorMsg.toString(),
          isError: true, duration: 4);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => const DashboardScreen(
      //         index: 2,
      //       ),
      //     ),
      //     (route) => false);
    } else {
      String result = (res as ErrorModel).message ?? '';
      AppConfig().showSnackbar(context, result, isError: true, duration: 4);

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => const FinalFeedbackForm(),
      //     ),
      //         (route) => route.isFirst
      // );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(
              index: 2,
            ),
          ),
          (route) => route.isFirst);
    }
    setstate(() {
      isLoading = false;
    });
  }
}
