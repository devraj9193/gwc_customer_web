/*

this screen will call when dashboard stage is post_program

this screen will be accessed till postprogram.isProgramFeedbackSubmitted becomes 1
APi used for submit medical feedback

var submitMedicalFeedbackFormUrl = "${AppConfig().BASE_URL}/api/submitForm/medical_feedback";

once medical feedback submitetd we r showing card screen instead of finafeedbackscreen


 */

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/error_model.dart';
import '../../model/new_user_model/register/register_model.dart';
import '../../repository/api_service.dart';
import '../../repository/medical_program_feedback_repo/medical_feedback_repo.dart';
import '../../services/medical_program_feedback_service/medical_feedback_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/unfocus_widget.dart';
import '../../widgets/widgets.dart';
import 'card_selection.dart';

class MedicalFeedbackForm extends StatefulWidget {
  const MedicalFeedbackForm({Key? key}) : super(key: key);

  @override
  State<MedicalFeedbackForm> createState() => _MedicalFeedbackFormState();
}

class _MedicalFeedbackFormState extends State<MedicalFeedbackForm> {
  final formKey = GlobalKey<FormState>();

  TextEditingController resolvedController = TextEditingController();
  TextEditingController unResolvedController = TextEditingController();

  String mealPreferences = "";
  String hungerPattern = "";
  String bowelPattern = "";
  String lifestyleHabits = "";

  String emptyStringMsg = AppConfig().emptyStringMsg;

   MedicalFeedbackService? medicalFeedbackService;

  String? deviceId, fcmToken;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicalFeedbackService = MedicalFeedbackService(feedbackRepo: repository);

  }

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/eval_bg.png"),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.lighten),
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: showUI(context),
          ),
        ),
      ),
    );
  }

  showUI(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
              ],
            )),
        SizedBox(
          height: 3.h,
        ),
        Expanded(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.grey.withOpacity(0.5))
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: buildMedicalFeedbackForm(),
            ),
          ),
        ),
      ],
    );
  }

  buildMedicalFeedbackForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Medical Feedback form ",
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
            "I hope your detoxification process went well. Please update us on your health's development.",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: kFontMedium,
                color: gHintTextColor,
                height: 1.3,
                fontSize: subHeadingFont),
          ),
          SizedBox(
            height: 2.5.h,
          ),
          buildLabelTextField(
              'What were the RESOLVED digestive health issues after the program? Please list them below along with the % of improvement. ',
              fontSize: questionFont),
          SizedBox(height: 1.h),
          Container(
            height: 15.h,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
            child: TextFormField(
              maxLines: null, // Set this
              textCapitalization: TextCapitalization.sentences,
              controller: resolvedController,
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
              'What were the UNRESOLVED digestive health issues after the program? Please list them below ',
              fontSize: questionFont),
          SizedBox(height: 1.h),
          Container(
            height: 15.h,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
            child: TextFormField(
              maxLines: null, // Set this
              textCapitalization: TextCapitalization.sentences,
              controller: unResolvedController,
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
              textInputAction: TextInputAction.none,
              textAlign: TextAlign.start,

              keyboardType: TextInputType.multiline,
            ),
          ),
          SizedBox(height: 2.h),
          buildLabelTextField(
              'Tell us (the current status) about your after meal preferences ',
              fontSize: questionFont),
          SizedBox(height: 0.5.h),
          mealPreferencesRadioButton(),
          SizedBox(height: 2.h),
          buildLabelTextField(
              'Tell us (the current status) about your hunger pattern ',
              fontSize: questionFont),
          SizedBox(height: 0.5.h),
          hungerPatternRadioButton(),
          SizedBox(height: 2.h),
          buildLabelTextField(
              'Tell us (the current status) about your bowel pattern ',
              fontSize: questionFont),
          SizedBox(height: 0.5.h),
          bowelPatternRadioButton(),
          SizedBox(height: 2.h),
          buildLabelTextField(
              'Have your food cravings and lifestyle habits changed for the better? ',
              fontSize: questionFont),
          SizedBox(height: 0.5.h),
          lifeHabitsRadioButton(),
          SizedBox(height: 5.h),
          Center(
            child: GestureDetector(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  if (mealPreferences.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Meal Preference",
                        isError: true, bottomPadding: 10);
                  } else if (hungerPattern.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Hunger Pattern",
                        isError: true, bottomPadding: 10);
                  } else if (bowelPattern.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Bowel Pattern",
                        isError: true, bottomPadding: 10);
                  } else if (lifestyleHabits.isEmpty) {
                    AppConfig().showSnackbar(context, "Please Select Life Style",
                        isError: true, bottomPadding: 10);
                  } else {
                    submitMedicalFeedbackForm(
                      resolvedController.text.toString(),
                      unResolvedController.text.toString(),
                      mealPreferences.toString(),
                      hungerPattern.toString(),
                      bowelPattern.toString(),
                      lifestyleHabits.toString(),
                    );
                  }
                } else {
                  AppConfig().showSnackbar(context, "Please Enter Your Answer",
                      isError: true, bottomPadding: 10);
                }
              },
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: eUser().buttonColor,
                  borderRadius:
                      BorderRadius.circular(eUser().buttonBorderRadius),
                  // border: Border.all(
                  //     color: eUser().buttonBorderColor,
                  //     width: eUser().buttonBorderWidth
                  // ),
                ),
                child: (isLoading) ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
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
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }

  mealPreferencesRadioButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                mealPreferences =
                    "To eat something sweet with in 2 hrs of having food.";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value:
                        "To eat something sweet with in 2 hrs of having food.",
                    groupValue: mealPreferences,
                    onChanged: (value) {
                      setState(() {
                        mealPreferences = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "To eat something sweet with in 2 hrs of having food.",
                      mealPreferences),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                mealPreferences =
                    "To have something bitter or astringent with in an hour of having food";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value:
                        "To have something bitter or astringent with in an hour of having food",
                    groupValue: mealPreferences,
                    onChanged: (value) {
                      setState(() {
                        mealPreferences = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                    child: buildButtonText(
                        "To have something bitter or astringent with in an hour of having food",
                        mealPreferences))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                mealPreferences =
                    "To have some hot drink with an hour of having food.";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  // height: 10,
                  child: Radio(
                    value:
                        "To have some hot drink with an hour of having food.",
                    groupValue: mealPreferences,
                    onChanged: (value) {
                      setState(() {
                        mealPreferences = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "To have some hot drink with an hour of having food.",
                      mealPreferences),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  hungerPatternRadioButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                hungerPattern =
                    "Intense, however tend to eat small or large portions which differs. Also tend to eat frequently like every 2hrs than eat large meals.";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value:
                        "Intense, however tend to eat small or large portions which differs. Also tend to eat frequently like every 2hrs than eat large meals.",
                    groupValue: hungerPattern,
                    onChanged: (value) {
                      setState(() {
                        hungerPattern = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "Intense, however tend to eat small or large portions which differs. Also tend to eat frequently like every 2hrs than eat large meals.",
                      hungerPattern),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                hungerPattern =
                    "Intense and prefer to eat large meals when i eat. The gaps between meals may be long or short";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value:
                        "Intense and prefer to eat large meals when i eat. The gaps between meals may be long or short",
                    groupValue: hungerPattern,
                    onChanged: (value) {
                      setState(() {
                        hungerPattern = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "Intense and prefer to eat large meals when i eat. The gaps between meals may be long or short",
                      hungerPattern),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                hungerPattern =
                    "Not so intense. Tend to eat small portions when hungry. I am fine with long, unpredictable gaps between my meals.";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  // height: 10,
                  child: Radio(
                    value:
                        "Not so intense. Tend to eat small portions when hungry. I am fine with long, unpredictable gaps between my meals.",
                    groupValue: hungerPattern,
                    onChanged: (value) {
                      setState(() {
                        hungerPattern = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "Not so intense. Tend to eat small portions when hungry. I am fine with long, unpredictable gaps between my meals.",
                      hungerPattern),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bowelPatternRadioButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                bowelPattern =
                    "I either have lax with watery stools or am constipated with dry stools";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value:
                        "I either have lax with watery stools or am constipated with dry stools",
                    groupValue: bowelPattern,
                    onChanged: (value) {
                      setState(() {
                        bowelPattern = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "I either have lax with watery stools or am constipated with dry stools",
                      bowelPattern),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                bowelPattern = "I have lax with well formed or watery stools";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value: "I have lax with well formed or watery stools",
                    groupValue: bowelPattern,
                    onChanged: (value) {
                      setState(() {
                        bowelPattern = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "I have lax with well formed or watery stools",
                      bowelPattern),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                bowelPattern =
                    "I am usually constipated with either well formed stools or hard stools";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  // height: 10,
                  child: Radio(
                    value:
                        "I am usually constipated with either well formed stools or hard stools",
                    groupValue: bowelPattern,
                    onChanged: (value) {
                      setState(() {
                        bowelPattern = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "I am usually constipated with either well formed stools or hard stools",
                      bowelPattern),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  lifeHabitsRadioButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                lifestyleHabits = "Yes";
              });
            },
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value: "Yes",
                    groupValue: lifestyleHabits,
                    onChanged: (value) {
                      setState(() {
                        lifestyleHabits = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                buildButtonText("Yes", lifestyleHabits),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              setState(() {
                lifestyleHabits = "No";
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  // height: 10,
                  child: Radio(
                    value: "No",
                    groupValue: lifestyleHabits,
                    onChanged: (value) {
                      setState(() {
                        lifestyleHabits = value as String;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                buildButtonText("No", lifestyleHabits)
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildButtonText(String title, String value) {
    return Text(
      title,
      style: TextStyle(
        color: (value == title) ? kTextColor : gHintTextColor,
        height: 1.3,
        fontFamily: (value == title) ? kFontMedium : kFontBook,
      ),
    );
  }

  final FeedbackRepo repository = FeedbackRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void submitMedicalFeedbackForm(
    String resolvedDigestiveIssue,
    String unresolvedDigestiveIssue,
    String mealPreferences,
    String hungerPattern,
    String bowelPattern,
    String lifestyleHabits,
  ) async {
    setState(() {
      isLoading = true;
    });
    final res = await medicalFeedbackService?.submitMedicalFeedbackService(
      resolvedDigestiveIssue: resolvedDigestiveIssue,
      unresolvedDigestiveIssue: unresolvedDigestiveIssue,
      mealPreferences: mealPreferences,
      hungerPattern: hungerPattern,
      bowelPattern: bowelPattern,
      lifestyleHabits: lifestyleHabits,
    );

    print("medicalFeedbackForm:$res");
    print("res.runtimeType: ${res.runtimeType}");

    if (res.runtimeType == RegisterResponse) {
      RegisterResponse response = res;

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (context) => const TCardPage(
      //           programContinuesdStatus: 1,
      //         )
      //     ),
      //         (route) => route.isFirst
      // );
    } else {
      String result = (res as ErrorModel).message ?? '';
      AppConfig().showSnackbar(context, result, isError: true, duration: 4);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const TCardPage(
                programContinuesdStatus: 1,
              )
          ),
              (route) => route.isFirst
      );

    }
    setState(() {
      isLoading = false;
    });
  }
}
