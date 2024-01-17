import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:get/get.dart';
import '../../model/error_model.dart';
import '../../model/new_user_model/register/register_model.dart';
import '../../repository/api_service.dart';
import '../../repository/medical_program_feedback_repo/medical_feedback_repo.dart';
import '../../services/medical_program_feedback_service/medical_feedback_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/unfocus_widget.dart';
import '../../widgets/widgets.dart';
import '../dashboard_screen.dart';
import 'card_selection.dart';
import 'package:http/http.dart' as http;

class FinalFeedbackForm extends StatefulWidget {
  const FinalFeedbackForm({Key? key}) : super(key: key);

  @override
  State<FinalFeedbackForm> createState() => _FinalFeedbackFormState();
}

class _FinalFeedbackFormState extends State<FinalFeedbackForm> {
  MedicalFeedbackService? medicalFeedbackService;

  int? programContinuesdStatus;
  String programStatus = "";
  final formKey2 = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController discontinuedController = TextEditingController();
  String emptyStringMsg = AppConfig().emptyStringMsg;

  @override
  void initState() {
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
              colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.lighten)),
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
            child: buildAppBar(() {
              Navigator.pop(context);
            })),
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
              child: buildFeedbackForm(),
            ),
          ),
        ),
      ],
    );
  }

  buildFeedbackForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          height: 2.5.h,
        ),
        buildLabelTextField('Tell us about your program status ',
            fontSize: questionFont),
        SizedBox(height: 0.5.h),
        programStatusRadioButton(),
        SizedBox(height: 2.h),
        (programStatus ==
                "I have discontinued my program before I finish my transition period.")
            ? buildDisContinuedForm()
            : const SizedBox(),
        SizedBox(height: 5.h),
        (programStatus ==
                "I have discontinued my program before I finish my transition period.")
            ? Center(
                child: GestureDetector(
                  onTap: () {
                    if (discontinuedController.text.isEmpty) {
                      AppConfig().showSnackbar(context, "Please Add Comments",
                          isError: true, bottomPadding: 10);
                    } else {
                      submitProgramFeedbackForm(
                        programContinuesdStatus!,
                        discontinuedController.text.toString(),
                      );
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
              )
            : const SizedBox(),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }

  programStatusRadioButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                programStatus = "I have successfully completed my program.";
                programContinuesdStatus = 1;
                Get.to(
                  () => TCardPage(
                    programContinuesdStatus: programContinuesdStatus!,
                  ),
                );
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value: "I have successfully completed my program.",
                    groupValue: programStatus,
                    onChanged: (value) {
                      setState(() {
                        programStatus = value as String;
                        programContinuesdStatus = 1;
                        Get.to(
                          () => TCardPage(
                            programContinuesdStatus: programContinuesdStatus!,
                          ),
                        );
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "I have successfully completed my program.",
                      programStatus),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                programStatus =
                    "I have discontinued my program before I finish my transition period.";
                programContinuesdStatus = 0;
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
                        "I have discontinued my program before I finish my transition period.",
                    groupValue: programStatus,
                    onChanged: (value) {
                      setState(() {
                        programStatus = value as String;
                        programContinuesdStatus = 0;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: buildButtonText(
                      "I have discontinued my program before I finish my transition period.",
                      programStatus),
                )
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

  buildDisContinuedForm() {
    return Form(
      key: formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelTextField(
              'Please let us know where we went wrong that led you to discontinue your program ',
              fontSize: questionFont),
          SizedBox(height: 1.h),
          buildTextFields(discontinuedController),
        ],
      ),
    );
  }

  buildTextFields(TextEditingController controller) {
    return Container(
      height: 10.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: TextFormField(
        maxLines: null, // Set this
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
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
    );
  }

  final FeedbackRepo repository = FeedbackRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  submitProgramFeedbackForm(
    int programStatus,
    String reasonOfProgramDiscontinue,
  ) async {
    setState(() {
      isLoading = true;
    });
    final res = await medicalFeedbackService?.submitProgramFeedbackService(
      programStatus: programStatus,
      changesAfterProgram: "",
      otherChangesAfterProgram: "",
      didProgramHeal: "",
      stickToPlan: "",
      mealPlanEasyToFollow: "",
      yogaPlanEasyToFollow: "",
      commentsOnMealYogaPlans: "",
      programPositiveHighlights: "",
      programNegativeHighlights: "",
      infusions: "",
      soups: "",
      porridges: "",
      podi: "",
      kheer: "",
      kitItemsImproveSuggestions: "",
      supportFromDoctors: "",
      supportInWhatsappGroup: "",
      homeRemediesDuringProgram: "",
      improvementAndSuggestions: "",
      programImproveHealthAnotherWay: "",
      briefTestimonial: "",
      referProgram: "",
      membership: "",
       faceToFeedback: [],
      reasonOfProgramDiscontinue: reasonOfProgramDiscontinue,
    );

    print("medicalFeedbackForm:$res");
    print("res.runtimeType: ${res.runtimeType}");

    if (res.runtimeType == RegisterResponse) {
      RegisterResponse response = res;

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => const DashboardScreen(),
      //     ),
      //     (route) => false);
    } else {
      String result = (res as ErrorModel).message ?? '';
      // AppConfig().showSnackbar(context, result, isError: true, duration: 4);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(index: 2,),
          ),
          (route) => route.isFirst);
    }
    setState(() {
      isLoading = false;
    });
  }
}
