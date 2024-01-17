/*

 */

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import '../../../model/evaluation_from_models/evaluation_model_format2.dart';
import '../../../utils/app_config.dart';
import '../../model/dashboard_model/report_upload_model/report_upload_model.dart';
import '../../model/error_model.dart';
import '../../model/evaluation_from_models/evaluation_model_format1.dart';
import '../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import '../../repository/api_service.dart';
import '../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../uvdesk/ticket_details_screen.dart';
import 'check_box_settings.dart';
import 'evaluation_upload_report.dart';
import 'package:http/http.dart' as http;

class PersonalDetailsScreen2 extends StatefulWidget {
  /// taking all the previous screen details
  final EvaluationModelFormat1? evaluationModelFormat1;
  // final List? medicalReportList;
  final bool showData;

  /// this is called when showData is true
  final ChildGetEvaluationDataModel? childGetEvaluationDataModel;
  const PersonalDetailsScreen2({
    Key? key,
    this.evaluationModelFormat1,
    this.childGetEvaluationDataModel,
    this.showData = false,
    // this.medicalReportList
  }) : super(key: key);

  @override
  State<PersonalDetailsScreen2> createState() => _PersonalDetailsScreenState2();
}

class _PersonalDetailsScreenState2 extends State<PersonalDetailsScreen2> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();

  final glassWaterKey = GlobalKey<FormState>();

  final habbitsKey = GlobalKey<FormState>();
  final bowelMealKey = GlobalKey<FormState>();
  final hungerKey = GlobalKey<FormState>();
  final bowelPatternKey = GlobalKey<FormState>();

  final String otherText = "Other";
  TextEditingController digestionController = TextEditingController();
  TextEditingController specialDietController = TextEditingController();
  TextEditingController foodAllergyController = TextEditingController();
  TextEditingController intoleranceController = TextEditingController();
  TextEditingController cravingsController = TextEditingController();
  TextEditingController dislikeFoodController = TextEditingController();

  String emptyStringMsg = AppConfig().emptyStringMsg;

  String glassesOfWater = "";

  final customizedMealCheckBox = [
    "Veg",
    "Non-Veg",
    "Ovo-Vegetarian",
    "Vegan",
    "Others",
  ];
  String customizedMealPlanSelected = "";
  TextEditingController customizedMealPlanOther = TextEditingController();

  TextEditingController morningBeverageController = TextEditingController();
  TextEditingController breakfastController = TextEditingController();
  TextEditingController midDayBeverageController = TextEditingController();
  TextEditingController lunchController = TextEditingController();
  TextEditingController eveningBeverageController = TextEditingController();
  TextEditingController dinnerController = TextEditingController();
  TextEditingController postDinnerController = TextEditingController();

  final _pref = AppConfig().preferences;

  final habitCheckBox = [
    CheckBoxSettings(title: "Alcohol"),
    CheckBoxSettings(title: "Smoking"),
    CheckBoxSettings(title: "Coffee"),
    CheckBoxSettings(title: "Tea"),
    CheckBoxSettings(title: "Soft Drinks/Carbonated Drinks"),
    CheckBoxSettings(title: "Drugs"),
    CheckBoxSettings(title: "None"),
  ];
  bool habitOtherSelected = false;
  List selectedHabitCheckBoxList = [];

  final habitOtherController = TextEditingController();
  final mealPreferenceController = TextEditingController();
  final hungerPatternController = TextEditingController();
  final bowelPatternController = TextEditingController();

  final mealPreferenceList = [
    "To eat something sweet within 2 hrs of having food.",
    "To have something bitter or astringent within an hour of having food",
    "Other:"
  ];
  String mealPreferenceSelected = "";

  final hungerPatternList = [
    "Intense, however, tend to eat small or large portions which differ. Also tend to eat frequently, like every 2hrs than eat large meals.",
    "Intense and prefer to eat large meals when i eat. The gaps between meals may be long or short",
    "Not so intense. Tend to eat small portions when hungry. I am fine with long, unpredictable gaps between my meals.",
    "Other:"
  ];
  String hungerPatternSelected = "";

  final bowelPatternList = [
    "I sometimes have soft stools and/or sometimes constipated dry stools",
    "I have soft well formed and/or watery stools",
    "I am usually constipated with either well formed stools or hard stools",
    "Other:"
  ];
  String bowelPatternSelected = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.showData);
    if (widget.showData) {
      storeData();
    }
  }

  /// this added to get stored data
  /// but not added
  void storeData() {
    final model = widget.childGetEvaluationDataModel;
    print('store');
    print('${model?.hungerPatternOther} ${model?.hungerPattern}');
    digestionController.text = model?.mentionIfAnyFoodAffectsYourDigesion ?? '';
    specialDietController.text = model?.anySpecialDiet ?? '';
    foodAllergyController.text = model?.anyFoodAllergy ?? '';
    intoleranceController.text = model?.anyIntolerance ?? '';
    cravingsController.text = model?.anySevereFoodCravings ?? '';
    dislikeFoodController.text = model?.anyDislikeFood ?? '';
    glassesOfWater = model?.noGalssesDay ?? '';

    // print("model.listProblems:${jsonDecode(model.listProblems ?? '')}");
    selectedHabitCheckBoxList
        .addAll(List.from(jsonDecode(model?.anyHabbitOrAddiction ?? '')));
    // print("selectedHealthCheckBox1[0]:${(selectedHealthCheckBox1[0].split(',') as List).map((e) => e).toList()}");
    selectedHabitCheckBoxList = List.from(
        (selectedHabitCheckBoxList[0].split(',') as List)
            .map((e) => e)
            .toList());
    habitCheckBox.forEach((element) {
      print(selectedHabitCheckBoxList);
      print(
          'selectedHabitCheckBoxList.any((element1) => element1 == element.title): ${selectedHabitCheckBoxList.any((element1) => element1 == element.title)}');
      if (selectedHabitCheckBoxList
          .any((element1) => element1 == element.title)) {
        element.value = true;
      }
      if (selectedHabitCheckBoxList.any(
          (element) => element.toString().toLowerCase().contains("other"))) {
        habitOtherSelected = true;
      }
    });
    habitOtherController.text = model?.anyHabbitOrAddictionOther ?? '';

    mealPreferenceController.text = model?.afterMealPreferenceOther ?? '';
    mealPreferenceSelected = model?.afterMealPreference ?? '';
    hungerPatternController.text = model?.hungerPatternOther ?? '';
    hungerPatternSelected = model?.hungerPattern ?? '';
    bowelPatternSelected = model?.bowelPattern ?? '';
    bowelPatternController.text = model?.bowelPatternOther ?? '';
  }

  hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/eval_bg.png"),
            fit: BoxFit.fitWidth,
            colorFilter:
                const ColorFilter.mode(kPrimaryColor, BlendMode.lighten),),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TicketChatScreen(
                    userName: "${_pref?.getString(AppConfig.User_Name)}",
                    thumbNail:
                    "${_pref?.getString(AppConfig.User_Profile)}",
                    ticketId:
                    "${_pref?.getString(AppConfig.User_ticket_id)}",
                    subject: '',
                    email: "${_pref?.getString(AppConfig.User_Email)}",
                    ticketStatus: 1 ?? -1,
                  ),
                ),
              );
            },
            backgroundColor: gsecondaryColor.withOpacity(0.7),
            child: const ImageIcon(
              AssetImage("assets/images/noun-chat-5153452.png"),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAppBar(() {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Expanded(
                child: GestureDetector(
                  onPanDown: (_) {
                    hideKeyboard();
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          buildHealthDetails(),
                          buildFoodHabitsDetails(),
                          buildLifeStyleDetails(),
                          buildBowelDetails(),
                          Center(
                            child: IntrinsicWidth(
                              child: GestureDetector(
                                onTap: widget.showData
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                EvaluationUploadReport(
                                              showData: widget.showData,
                                              childGetEvaluationDataModel: widget
                                                  .childGetEvaluationDataModel,
                                            ),
                                          ),
                                        );
                                      }
                                    : () {
                                        if (glassesOfWater.isEmpty) {
                                          Scrollable.ensureVisible(
                                              glassWaterKey.currentContext!,
                                              duration: const Duration(
                                                  milliseconds: 1000));
                                          showCustomSnack(
                                              "Please select How Many glass of water do you drink a day");
                                        } else if (selectedHabitCheckBoxList
                                                .isEmpty &&
                                            !habitOtherSelected) {
                                          Scrollable.ensureVisible(
                                              habbitsKey.currentContext!,
                                              duration: const Duration(
                                                  milliseconds: 1000));
                                          showCustomSnack(
                                              "Please select Habits or Addiction");
                                        } else if (mealPreferenceSelected
                                            .isEmpty) {
                                          Scrollable.ensureVisible(
                                              bowelMealKey.currentContext!,
                                              duration: const Duration(
                                                  milliseconds: 1000));
                                          showCustomSnack(
                                              "Please select What is your meal preference");
                                        } else if (hungerPatternSelected
                                            .isEmpty) {
                                          Scrollable.ensureVisible(
                                              hungerKey.currentContext!,
                                              duration: const Duration(
                                                  milliseconds: 1000));
                                          showCustomSnack(
                                              "Please select Hunger Pattern");
                                        } else if (bowelPatternSelected.isEmpty) {
                                          Scrollable.ensureVisible(
                                              bowelPatternKey.currentContext!,
                                              duration: const Duration(
                                                  milliseconds: 1000));
                                          showCustomSnack(
                                              "Please select Bowel Pattern");
                                        } else {
                                          if (formKey1.currentState!.validate()) {
                                            if (formKey2.currentState!
                                                .validate()) {
                                              if (formKey3.currentState!
                                                  .validate()) {
                                                if (formKey4.currentState!
                                                    .validate()) {
                                                  submitFormDetails();
                                                } else {
                                                  Scrollable.ensureVisible(
                                                      formKey4.currentContext!,
                                                      duration: const Duration(
                                                          milliseconds: 1000));
                                                }
                                              } else {
                                                Scrollable.ensureVisible(
                                                    formKey3.currentContext!,
                                                    duration: const Duration(
                                                        milliseconds: 1000));
                                              }
                                            } else {
                                              Scrollable.ensureVisible(
                                                  formKey2.currentContext!,
                                                  duration: const Duration(
                                                      milliseconds: 1000));
                                            }
                                          } else {
                                            Scrollable.ensureVisible(
                                                formKey1.currentContext!,
                                                duration: const Duration(
                                                    milliseconds: 1000));
                                          }
                                        }
                                      },
                                child: Container(
                                 
                                  margin: EdgeInsets.symmetric(vertical: 4.h),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.5.h, horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    color: eUser().buttonColor,
                                    borderRadius: BorderRadius.circular(
                                        eUser().buttonBorderRadius),
                              
                                    // border: Border.all(
                                    //     color: eUser().buttonBorderColor,
                                    //     width: eUser().buttonBorderWidth
                                    // ),
                                  ),
                                  child: widget.showData ? Center(
                                    child: Text(
                                      "Next" ,
                                      style: TextStyle(
                                        fontFamily: eUser().buttonTextFont,
                                        color: eUser().buttonTextColor,
                                        fontSize: eUser().buttonTextSize,
                                      ),
                                    ),) : isSubmitPressed
                                      ? buildThreeBounceIndicator(color: gWhiteColor)
                                      : Center(
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontFamily: eUser().buttonTextFont,
                                        color: eUser().buttonTextColor,
                                        fontSize: eUser().buttonTextSize,
                                      ),
                                    ),),
                                ),
                              ),
                            ),
                          ),
                        ],
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
  }

  buildHealthDetails() {
    return Form(
      key: formKey4,
      child: IgnorePointer(
        ignoring: widget.showData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Diet",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: kFontBold,
                          color: gBlackColor,
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
                // Text(
                //   "To Make Your Meal Plans As Simple & Easy For You To Follow As Possible",
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //       fontFamily: kFontBook,
                //       color: gTextColor,
                //       fontSize: 9.dp
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            buildLabelTextField(
                "To Customize Your Meal Plans & Make It As Simple & Easy For You To Follow As Possible",
                fontSize: questionFont),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          customizedMealPlanSelected =
                              customizedMealCheckBox[0];
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: customizedMealCheckBox[0],
                            activeColor: kPrimaryColor,
                            groupValue: customizedMealPlanSelected,
                            onChanged: (value) {
                              setState(() {
                                customizedMealPlanSelected = value as String;
                              });
                            },
                          ),
                          Text(
                            customizedMealCheckBox[0],
                            style: buildTextStyle(
                                color: customizedMealPlanSelected ==
                                        customizedMealCheckBox[0]
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: customizedMealPlanSelected ==
                                        customizedMealCheckBox[0]
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          customizedMealPlanSelected =
                              customizedMealCheckBox[1];
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: customizedMealCheckBox[1],
                            activeColor: kPrimaryColor,
                            groupValue: customizedMealPlanSelected,
                            onChanged: (value) {
                              setState(() {
                                customizedMealPlanSelected = value as String;
                              });
                            },
                          ),
                          Text(
                            customizedMealCheckBox[1],
                            style: buildTextStyle(
                                color: customizedMealPlanSelected ==
                                        customizedMealCheckBox[1]
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: customizedMealPlanSelected ==
                                        customizedMealCheckBox[1]
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          customizedMealPlanSelected =
                              customizedMealCheckBox[2];
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: customizedMealCheckBox[2],
                            activeColor: kPrimaryColor,
                            groupValue: customizedMealPlanSelected,
                            onChanged: (value) {
                              setState(() {
                                customizedMealPlanSelected = value as String;
                              });
                            },
                          ),
                          Text(
                            customizedMealCheckBox[2],
                            style: buildTextStyle(
                                color: customizedMealPlanSelected ==
                                        customizedMealCheckBox[2]
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: customizedMealPlanSelected ==
                                        customizedMealCheckBox[2]
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          customizedMealPlanSelected =
                              customizedMealCheckBox[3];
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: customizedMealCheckBox[3],
                            activeColor: kPrimaryColor,
                            groupValue: customizedMealPlanSelected,
                            onChanged: (value) {
                              setState(() {
                                customizedMealPlanSelected = value as String;
                              });
                            },
                          ),
                          Text(
                            customizedMealCheckBox[3],
                            style: buildTextStyle(
                                color: customizedMealPlanSelected ==
                                        customizedMealCheckBox[3]
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: customizedMealPlanSelected ==
                                        customizedMealCheckBox[3]
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          customizedMealPlanSelected =
                              customizedMealCheckBox[4];
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: customizedMealCheckBox[4],
                            activeColor: kPrimaryColor,
                            groupValue: customizedMealPlanSelected,
                            onChanged: (value) {
                              setState(() {
                                customizedMealPlanSelected = value as String;
                              });
                            },
                          ),
                          Text(
                            customizedMealCheckBox[4],
                            style: buildTextStyle(
                                color: customizedMealPlanSelected ==
                                        customizedMealCheckBox[4]
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: customizedMealPlanSelected ==
                                        customizedMealCheckBox[4]
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible:
                      customizedMealPlanSelected == customizedMealCheckBox[4],
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: customizedMealPlanOther,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty &&
                          customizedMealPlanSelected
                              .contains(customizedMealCheckBox[4])) {
                        return 'Please Select Customize Meal plan';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Enter Your answer", customizedMealPlanOther),
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
            buildLabelTextField(
              "What Do You Usually Have As Your Morning Beverage/Snack",
              fontSize: questionFont,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: morningBeverageController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Enter Your answer", morningBeverageController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("What Do You Usually Have For Breakfast",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: breakfastController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", breakfastController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "What Do You Usually Have For Mid-Day Snack/Beverage",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: midDayBeverageController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", midDayBeverageController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("What Do You Usually Have For Lunch",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: lunchController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", lunchController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "What Do You Usually Have For Evening Snack/Beverage",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: eveningBeverageController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", eveningBeverageController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("What Do You Usually Have For Dinner",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: dinnerController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", dinnerController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("What Do You Usually Have Post Dinner/Beverage",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: postDinnerController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", postDinnerController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 4.h,
            ),
          ],
        ),
      ),
    );
  }

  buildFoodHabitsDetails() {
    return Form(
      key: formKey1,
      child: IgnorePointer(
        ignoring: widget.showData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Food Habits",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: kFontBold,
                          color: gBlackColor,
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
                // Text(
                //   "To Make Your Meal Plans As Simple & Easy For You To Follow As Possible",
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //       fontFamily: kFontBook,
                //       color: gTextColor,
                //       fontSize: 9.dp
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            buildLabelTextField(
              "Do Certain Food Affect Your Digestion? If So, Please Provide Details.",
              fontSize: questionFont,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: digestionController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Enter Your answer", digestionController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "Do You Follow Any Special Diet(Keto,Etc)? If So, Please Provide Details",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: specialDietController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", specialDietController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "Do You Have Any Known Food Allergy? If So, Please Provide Details.",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: foodAllergyController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", foodAllergyController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "Do You Have Any Known Intolerance? If So, Please Provide Details.",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: intoleranceController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", intoleranceController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "Do You Have Any Severe Food Cravings? If So, Please Provide Details.",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: cravingsController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", cravingsController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "Do You Dislike Any Food? Please Mention All Of Them",
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: dislikeFoodController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide Details';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter Your answer", dislikeFoodController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
              "How Many Glasses Of Water Do You Drink A Day?",
              fontSize: questionFont,
              key: glassWaterKey,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      glassesOfWater = "1-2";
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: "1-2",
                        activeColor: kPrimaryColor,
                        groupValue: glassesOfWater,
                        onChanged: (value) {
                          setState(() {
                            glassesOfWater = value as String;
                          });
                        },
                      ),
                      Text(
                        '1-2',
                        style: buildTextStyle(
                            color: glassesOfWater == "1-2"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: glassesOfWater == "1-2"
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      glassesOfWater = "3-4";
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: "3-4",
                        activeColor: kPrimaryColor,
                        groupValue: glassesOfWater,
                        onChanged: (value) {
                          setState(() {
                            glassesOfWater = value as String;
                          });
                        },
                      ),
                      Text(
                        '3-4',
                        style: buildTextStyle(
                            color: glassesOfWater == "3-4"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: glassesOfWater == "3-4"
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      glassesOfWater = "6-8";
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                          value: "6-8",
                          groupValue: glassesOfWater,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            setState(() {
                              glassesOfWater = value as String;
                            });
                          }),
                      Text(
                        "6-8",
                        style: buildTextStyle(
                            color: glassesOfWater == "6-8"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: glassesOfWater == "6-8"
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      glassesOfWater = "9+";
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                          value: "9+",
                          groupValue: glassesOfWater,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            setState(() {
                              glassesOfWater = value as String;
                            });
                          }),
                      Text(
                        "9+",
                        style: buildTextStyle(
                            color: glassesOfWater == "9+"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: glassesOfWater == "9+"
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
          ],
        ),
      ),
    );
  }

  buildLifeStyleDetails() {
    return Form(
      key: formKey2,
      child: IgnorePointer(
        ignoring: widget.showData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Life Style",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: kFontBold,
                          color: gBlackColor,
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
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            buildLabelTextField("Habits Or Addiction",
                fontSize: questionFont, key: habbitsKey),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    ...habitCheckBox.map(buildWrapingCheckBox).toList(),
                  ],
                ),
                SizedBox(
                  child: CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Text(
                        'Other:',
                        style: buildTextStyle(
                            color: habitOtherSelected
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily:
                                habitOtherSelected ? kFontMedium : kFontBook),
                      ),
                    ),
                    activeColor: kPrimaryColor,
                    value: habitOtherSelected,
                    onChanged: (v) {
                      setState(() {
                        habitOtherSelected = v!;
                        if (habitOtherSelected) {
                          // new code to remove the none if selected
                          if (selectedHabitCheckBoxList
                              .contains(habitCheckBox.last.title)) {
                            selectedHabitCheckBoxList.clear();
                            habitCheckBox.last.value = false;
                          }
                          // old code
                          // selectedHabitCheckBoxList.clear();
                          // habitCheckBox
                          //     .forEach((element) {
                          //   element.value = false;
                          // });
                          selectedHabitCheckBoxList.add(otherText);
                        } else {
                          selectedHabitCheckBoxList.remove(otherText);
                        }
                        print(selectedHabitCheckBoxList);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: habitOtherSelected,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: habitOtherController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty && habitOtherSelected) {
                        return 'Please mention other habits/addiction which not mentioned above';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Enter Your answer", habitOtherController),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

  buildBowelDetails() {
    return Form(
      key: formKey3,
      child: IgnorePointer(
        ignoring: widget.showData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Bowel Type",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: kFontBold,
                          color: gBlackColor,
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
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            buildLabelTextField("What is your after meal preference?",
                fontSize: questionFont, key: bowelMealKey),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      mealPreferenceSelected = mealPreferenceList[0];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: mealPreferenceList[0],
                        activeColor: kPrimaryColor,
                        groupValue: mealPreferenceSelected,
                        onChanged: (value) {
                          setState(() {
                            mealPreferenceSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          mealPreferenceList[0],
                          style: buildTextStyle(
                              color: mealPreferenceSelected ==
                                      mealPreferenceList[0]
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily: mealPreferenceSelected ==
                                      mealPreferenceList[0]
                                  ? kFontMedium
                                  : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      mealPreferenceSelected = mealPreferenceList[1];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: mealPreferenceList[1],
                        activeColor: kPrimaryColor,
                        groupValue: mealPreferenceSelected,
                        onChanged: (value) {
                          setState(() {
                            mealPreferenceSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          mealPreferenceList[1],
                          style: buildTextStyle(
                              color: mealPreferenceSelected ==
                                      mealPreferenceList[1]
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily: mealPreferenceSelected ==
                                      mealPreferenceList[1]
                                  ? kFontMedium
                                  : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      mealPreferenceSelected = mealPreferenceList[2];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: mealPreferenceList[2],
                        activeColor: kPrimaryColor,
                        groupValue: mealPreferenceSelected,
                        onChanged: (value) {
                          setState(() {
                            mealPreferenceSelected = value as String;
                          });
                        },
                      ),
                      Text(
                        mealPreferenceList[2],
                        style: buildTextStyle(
                            color:
                                mealPreferenceSelected == mealPreferenceList[2]
                                    ? kTextColor
                                    : gHintTextColor,
                            fontFamily:
                                mealPreferenceSelected == mealPreferenceList[2]
                                    ? kFontMedium
                                    : kFontBook),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: mealPreferenceSelected == mealPreferenceList[2],
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: mealPreferenceController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty &&
                          mealPreferenceSelected
                              .contains(mealPreferenceList[2])) {
                        return 'Please Provide Details';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Enter Your answer", mealPreferenceController),
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
            buildLabelTextField("Hunger Pattern",
                fontSize: questionFont, key: hungerKey),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hungerPatternSelected = hungerPatternList[0];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: hungerPatternList[0],
                        activeColor: kPrimaryColor,
                        groupValue: hungerPatternSelected,
                        onChanged: (value) {
                          setState(() {
                            hungerPatternSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          hungerPatternList[0],
                          style: buildTextStyle(
                              color:
                                  hungerPatternSelected == hungerPatternList[0]
                                      ? kTextColor
                                      : gHintTextColor,
                              fontFamily:
                                  hungerPatternSelected == hungerPatternList[0]
                                      ? kFontMedium
                                      : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hungerPatternSelected = hungerPatternList[1];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: hungerPatternList[1],
                        activeColor: kPrimaryColor,
                        groupValue: hungerPatternSelected,
                        onChanged: (value) {
                          setState(() {
                            hungerPatternSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          hungerPatternList[1],
                          style: buildTextStyle(
                              color:
                                  hungerPatternSelected == hungerPatternList[1]
                                      ? kTextColor
                                      : gHintTextColor,
                              fontFamily:
                                  hungerPatternSelected == hungerPatternList[1]
                                      ? kFontMedium
                                      : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hungerPatternSelected = hungerPatternList[2];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: hungerPatternList[2],
                        activeColor: kPrimaryColor,
                        groupValue: hungerPatternSelected,
                        onChanged: (value) {
                          setState(() {
                            hungerPatternSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          hungerPatternList[2],
                          style: buildTextStyle(
                              color:
                                  hungerPatternSelected == hungerPatternList[2]
                                      ? kTextColor
                                      : gHintTextColor,
                              fontFamily:
                                  hungerPatternSelected == hungerPatternList[2]
                                      ? kFontMedium
                                      : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hungerPatternSelected = hungerPatternList[3];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: hungerPatternList[3],
                        activeColor: kPrimaryColor,
                        groupValue: hungerPatternSelected,
                        onChanged: (value) {
                          setState(() {
                            hungerPatternSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          hungerPatternList[3],
                          style: buildTextStyle(
                              color:
                                  hungerPatternSelected == hungerPatternList[3]
                                      ? kTextColor
                                      : gHintTextColor,
                              fontFamily:
                                  hungerPatternSelected == hungerPatternList[3]
                                      ? kFontMedium
                                      : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: hungerPatternSelected == hungerPatternList[3],
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: hungerPatternController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty &&
                          hungerPatternSelected
                              .contains(hungerPatternList[3])) {
                        return 'Please enter Hunger Pattern';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Enter Your answer", hungerPatternController),
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
            buildLabelTextField("Bowel Pattern",
                fontSize: questionFont, key: bowelPatternKey),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      bowelPatternSelected = bowelPatternList[0];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: bowelPatternList[0],
                        activeColor: kPrimaryColor,
                        groupValue: bowelPatternSelected,
                        onChanged: (value) {
                          setState(() {
                            bowelPatternSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          bowelPatternList[0],
                          style: buildTextStyle(
                              color: bowelPatternSelected == bowelPatternList[0]
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily:
                                  bowelPatternSelected == bowelPatternList[0]
                                      ? kFontMedium
                                      : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      bowelPatternSelected = bowelPatternList[1];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: bowelPatternList[1],
                        activeColor: kPrimaryColor,
                        groupValue: bowelPatternSelected,
                        onChanged: (value) {
                          setState(() {
                            bowelPatternSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          bowelPatternList[1],
                          style: buildTextStyle(
                              color: bowelPatternSelected == bowelPatternList[1]
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily:
                                  bowelPatternSelected == bowelPatternList[1]
                                      ? kFontMedium
                                      : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      bowelPatternSelected = bowelPatternList[2];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: bowelPatternList[2],
                        activeColor: kPrimaryColor,
                        groupValue: bowelPatternSelected,
                        onChanged: (value) {
                          setState(() {
                            bowelPatternSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          bowelPatternList[2],
                          style: buildTextStyle(
                              color: bowelPatternSelected == bowelPatternList[2]
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily:
                                  bowelPatternSelected == bowelPatternList[2]
                                      ? kFontMedium
                                      : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      bowelPatternSelected = bowelPatternList[3];
                    });
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: bowelPatternList[3],
                        activeColor: kPrimaryColor,
                        groupValue: bowelPatternSelected,
                        onChanged: (value) {
                          setState(() {
                            bowelPatternSelected = value as String;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          bowelPatternList[3],
                          style: buildTextStyle(
                              color: bowelPatternSelected == bowelPatternList[3]
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily:
                                  bowelPatternSelected == bowelPatternList[3]
                                      ? kFontMedium
                                      : kFontBook),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: bowelPatternSelected == bowelPatternList[3],
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: bowelPatternController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty &&
                          bowelPatternSelected.contains(bowelPatternList[3])) {
                        return 'Please enter bowel pattern';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Enter Your answer", bowelPatternController),
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

  buildLifeStyleCheckBox(CheckBoxSettings lifeStyleCheckBox) {
    return ListTile(
      minLeadingWidth: 0,
      leading: SizedBox(
        width: 20,
        child: Checkbox(
          activeColor: kPrimaryColor,
          value: lifeStyleCheckBox.value,
          onChanged: (v) {
            setState(() {
              lifeStyleCheckBox.value = v;
            });
          },
        ),
      ),
      title: Text(
        lifeStyleCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildWrapingCheckBox(CheckBoxSettings healthCheckBox) {
    return IntrinsicWidth(
      child: CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        controlAffinity: ListTileControlAffinity.leading,
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            healthCheckBox.title.toString(),
            style: buildTextStyle(
                color:
                    healthCheckBox.value == true ? kTextColor : gHintTextColor,
                fontFamily:
                    healthCheckBox.value == true ? kFontMedium : kFontBook),
          ),
        ),
        dense: true,
        activeColor: kPrimaryColor,
        value: healthCheckBox.value,
        onChanged: (v) {
          print("v==> $v  ${healthCheckBox.title}");
          // if(habitOtherSelected){
          //   if(v == true){
          //    setState(() {
          //      habitOtherSelected = false;
          //      selectedHabitCheckBoxList.clear();
          //      selectedHabitCheckBoxList.add(healthCheckBox.title);
          //      healthCheckBox.value = v;
          //    });
          //   }
          // }
          // else
          if (healthCheckBox.title == habitCheckBox.last.title) {
            setState(() {
              // new code for removing other
              habitOtherSelected = false;
              // old
              selectedHabitCheckBoxList.clear();
              habitCheckBox.forEach((element) {
                if (element.title != habitCheckBox.last.title) {
                  element.value = false;
                }
              });
              if (v == true) {
                selectedHabitCheckBoxList.add(healthCheckBox.title!);
                healthCheckBox.value = v;
              } else {
                selectedHabitCheckBoxList.remove(healthCheckBox.title!);
                healthCheckBox.value = v;
              }
            });
          } else {
            print("else");
            if (selectedHabitCheckBoxList.contains(habitCheckBox.last.title)) {
              setState(() {
                selectedHabitCheckBoxList.clear();
                habitCheckBox.last.value = false;
              });
            }
            if (v == true) {
              setState(() {
                selectedHabitCheckBoxList.add(healthCheckBox.title);
                healthCheckBox.value = v;
              });
            } else {
              setState(() {
                selectedHabitCheckBoxList.remove(healthCheckBox.title);
                healthCheckBox.value = v;
              });
            }
            print(selectedHabitCheckBoxList);
          }
        },
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: kPrimaryColor,
              value: healthCheckBox.value,
              onChanged: (v) {
                setState(() {
                  healthCheckBox.value = v;
                });
              },
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            healthCheckBox.title.toString(),
            style: buildTextStyle(),
          ),
        ],
      ),
    );
  }

  bool validEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isPhone(String input) =>
      RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);

  void submitFormDetails() {
    checkFields();
  }

  void checkFields() {
    if (digestionController.text.isEmpty) {
      AppConfig().showSnackbar(
          context, "Please Mention the food which affect in digestion",
          isError: true, bottomPadding: 100);
    } else if (specialDietController.text.isEmpty) {
      AppConfig().showSnackbar(context, "Please Mention the Special Diet",
          isError: true, bottomPadding: 100);
    } else if (foodAllergyController.text.isEmpty) {
      AppConfig().showSnackbar(
          context, "Please Mention the food allergy Details",
          isError: true, bottomPadding: 100);
    } else if (intoleranceController.text.isEmpty) {
      AppConfig().showSnackbar(
          context, "Please Mention the known intolerance Details",
          isError: true, bottomPadding: 100);
    } else if (cravingsController.text.isEmpty) {
      AppConfig().showSnackbar(
          context, "Please Mention any Severe food cravings",
          isError: true, bottomPadding: 100);
    } else if (dislikeFoodController.text.isEmpty) {
      AppConfig().showSnackbar(
          context, "Please Mention the food which You Dislike",
          isError: true, bottomPadding: 100);
    } else if (glassesOfWater.isEmpty) {
      AppConfig().showSnackbar(
          context, "Please Select how many glasses of water do you have a day",
          isError: true, bottomPadding: 100);
    } else if (habitCheckBox.every((element) => element.value == false) &&
        habitOtherSelected == false) {
      AppConfig().showSnackbar(context, "Please Select Habits/Addiction",
          isError: true, bottomPadding: 100);
    } else if (habitOtherSelected == true &&
        habitOtherController.text.isEmpty) {
      AppConfig().showSnackbar(context,
          "Please Mention other Habits/Addiction which not there in list",
          isError: true, bottomPadding: 100);
    } else if (mealPreferenceSelected.isEmpty) {
      AppConfig().showSnackbar(context, "Please Select Meal Preference",
          isError: true, bottomPadding: 100);
    } else if (mealPreferenceSelected.toLowerCase().contains("other") &&
        mealPreferenceController.text.isEmpty) {
      AppConfig().showSnackbar(context, "Please Mention the Meal Preference",
          isError: true, bottomPadding: 100);
    } else if (hungerPatternSelected.isEmpty) {
      AppConfig().showSnackbar(context, "Please Select Hunger Pattern",
          isError: true, bottomPadding: 100);
    } else if (hungerPatternSelected.toLowerCase().contains("other") &&
        hungerPatternController.text.isEmpty) {
      AppConfig().showSnackbar(context, "Please Mention the Hunger Pattern",
          isError: true, bottomPadding: 100);
    } else if (bowelPatternSelected.isEmpty) {
      AppConfig().showSnackbar(context, "Please Select Bowel Pattern",
          isError: true, bottomPadding: 100);
    } else if (bowelPatternSelected.toLowerCase().contains("other") &&
        bowelPatternController.text.isEmpty) {
      AppConfig().showSnackbar(context, "Please Mention the Bowel Pattern",
          isError: true, bottomPadding: 100);
    } else {
      addHabitDetails();
      EvaluationModelFormat2 eval2 = createFormMap();
      print(eval2.toMap());
      Map finalMap = {};
      // finalMap.addAll(widget.evaluationModelFormat1!.toMap().cast());
      finalMap.addAll(eval2.toMap().cast());
      print("finalMap: $finalMap");

      // storeToLocal
      _pref!.setString(AppConfig.eval2, json.encode(eval2.toMap()));

      Map evaForm2Map = {};
      evaForm2Map.addAll(eval2.toMap().cast());

      callApi(evaForm2Map, null);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (ctx) => EvaluationUploadReport(
      //               evaluationModelFormat1: widget.evaluationModelFormat1!,
      //               evaluationModelFormat2: eval2,
      //             )));

      /// old flow
      /// from eval1-> upload report-> eval2
      // callApi(finalMap,
      //     // widget.medicalReportList
      // );
    }
  }

  bool isSubmitPressed = false;

  void callApi(Map form, List<PlatformFile>? medicalReports) async {
    setState(() {
      isSubmitPressed = true;
    });
    final res = await EvaluationFormService(repository: evalRepository)
        .submitEvaluationFormService(form, medicalReports);
    print("eval form response" + res.runtimeType.toString());
    if (res.runtimeType == ReportUploadModel) {
      ReportUploadModel result = res;
      setState(() {
        isSubmitPressed = false;
      });
      _pref!.setString(AppConfig.EVAL_STATUS, "evaluation_done");
      // AppConfig().showSnackbar(context, result.message ?? '');
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => EvaluationUploadReport()));
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (context) =>
      //       const DashboardScreen()
      //   ), (route) {
      //     print("route.currentResult:${route.currentResult}");
      //     print(route.isFirst);
      //   return route.isFirst;
      // }
      // );
    } else {
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        isSubmitPressed = false;
      });
    }
  }

  final EvaluationFormRepository evalRepository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  createFormMap() {
    return EvaluationModelFormat2(
      vegNonVegVegan: customizedMealPlanSelected,
      vegNonVegVeganOther: customizedMealPlanOther.text,
      earlyMorning: morningBeverageController.text,
      breakfast: breakfastController.text,
      midDay: midDayBeverageController.text,
      lunch: lunchController.text,
      evening: eveningBeverageController.text,
      dinner: dinnerController.text,
      postDinner: postDinnerController.text,
      digesion: digestionController.text,
      diet: specialDietController.text,
      foodAllergy: foodAllergyController.text,
      intolerance: intoleranceController.text,
      cravings: cravingsController.text,
      dislikeFood: dislikeFoodController.text,
      glasses_per_day: glassesOfWater,
      habits: selectedHabitCheckBoxList.join(','),
      habits_other: habitOtherSelected ? habitOtherController.text : '',
      mealPreference: mealPreferenceSelected,
      mealPreferenceOther: mealPreferenceController.text,
      hunger: hungerPatternSelected,
      hungerOther: hungerPatternController.text,
      bowelPattern: bowelPatternSelected,
      bowelPatterOther: bowelPatternController.text,
      part: "2",
    );
  }

  void addHabitDetails() {
    selectedHabitCheckBoxList.clear();
    if (habitCheckBox.any((element) => element.value == true) ||
        habitOtherSelected) {
      for (var element in habitCheckBox) {
        if (element.value == true) {
          print(element.title);
          selectedHabitCheckBoxList.add(element.title!);
        }
      }
      if (habitOtherSelected) {
        selectedHabitCheckBoxList.add(otherText);
      }
    }
  }

  showCustomSnack(String msg) {
    AppConfig().showSnackbar(context, msg, isError: true, bottomPadding: 100);
  }
}
