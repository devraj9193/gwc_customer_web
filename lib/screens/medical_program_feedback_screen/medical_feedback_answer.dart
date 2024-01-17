/*
this screen we r using when postprogram consultation booked

when we go for join screen than we r calling this screen
 */

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;

import '../../repository/api_service.dart';
import '../../repository/medical_program_feedback_repo/medical_feedback_repo.dart';
import '../../services/medical_program_feedback_service/medical_feedback_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/unfocus_widget.dart';
import '../../widgets/widgets.dart';

class MedicalFeedbackAnswer extends StatefulWidget {
  const MedicalFeedbackAnswer({Key? key}) : super(key: key);

  @override
  State<MedicalFeedbackAnswer> createState() => _MedicalFeedbackAnswerState();
}

class _MedicalFeedbackAnswerState extends State<MedicalFeedbackAnswer> {
  Future? _getMedicalFeedbackDataFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMedicalFeedbackDataFuture =
        MedicalFeedbackService(feedbackRepo: repository)
            .getMedicalFeedbackService();
  }

  @override
  Widget build(BuildContext context) {
    return
        //   Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 3.w),
        //   child: buildMedicalFeedbackForm(),
        // );
        UnfocusWidget(
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
            child: buildMedicalFeedbackForm(),
          ),
        ),
      ],
    );
  }

  buildMedicalFeedbackForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: FutureBuilder(
          future: _getMedicalFeedbackDataFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Image(
                  image: const AssetImage("assets/images/Group 5294.png"),
                  height: 25.h,
                ),
              );
            }
            else if (snapshot.hasData) {
              if(snapshot.data is ErrorModel){
                print((snapshot.data as ErrorModel).message);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Center(
                    child: Text((snapshot.data as ErrorModel).message ?? '',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: kFontMedium,
                        color: gsecondaryColor.withOpacity(0.2)
                      ),
                    ),
                  ),
                );
              }
              else{
                var data = snapshot.data.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Medical Feedback form ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: kFontMedium,
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
                    Text(
                      "I hope your detoxification process went well. Please update us on your health's development.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gHintTextColor,
                          fontSize: subHeadingFont),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    buildLabelTextField(
                        'What were the RESOLVED digestive health issues after the program? Please list them below along with the % of improvement. '),
                    SizedBox(height: 1.h),
                    buildContainer(data.resolvedDigestiveIssue ?? ""),
                    SizedBox(height: 2.h),
                    buildLabelTextField(
                        'What were the UNRESOLVED digestive health issues after the program? Please list them below '),
                    SizedBox(height: 1.h),
                    buildContainer(data.unresolvedDigestiveIssue ?? ""),
                    SizedBox(height: 2.h),
                    buildLabelTextField(
                        'Tell us (the current status) about your after meal preferences '),
                    buildRadioContainer(data.mealPreferences ?? ""),
                    buildLabelTextField(
                        'Tell us (the current status) about your hunger pattern '),
                    buildRadioContainer(data.hungerPattern ?? ""),
                    buildLabelTextField(
                        'Tell us (the current status) about your bowel pattern '),
                    buildRadioContainer(data.bowelPattern ?? ""),
                    buildLabelTextField(
                        'Have your food cravings and lifestyle habits changed for the better? '),
                    buildRadioContainer(data.lifestyleHabits ?? ""),
                  ],
                );
              }
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: buildCircularIndicator(),
            );
          }),
    );
  }

  buildContainer(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          margin: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.w),
          // width: double.maxFinite,
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: gGreyColor.withOpacity(0.5),
          //     width: 1,
          //   ),
          //   borderRadius: BorderRadius.circular(8),
          //   color: gWhiteColor,
          // ),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: kFontBook, color: gBlackColor, fontSize: 9.sp),
          ),
        ),
        Container(
          height: 1,
          margin: EdgeInsets.only(bottom: 1.h),
          color: kLineColor,
        ),
      ],
    );
  }

  buildRadioContainer(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.radio_button_checked,
            color: gsecondaryColor,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: buildTextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  final FeedbackRepo repository = FeedbackRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
