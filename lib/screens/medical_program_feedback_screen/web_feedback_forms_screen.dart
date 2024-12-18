import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/medical_program_feedback_screen/post_gut_type_diagnosis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../feed_screens/web_feed_screen.dart';
import 'card_selection.dart';
import 'medical_feedback_form.dart';

class WebFeedbackFormsScreen extends StatefulWidget {
  final int currentForm;
  const WebFeedbackFormsScreen({Key? key, required this.currentForm})
      : super(key: key);

  @override
  State<WebFeedbackFormsScreen> createState() => _WebFeedbackFormsScreenState();
}

class _WebFeedbackFormsScreenState extends State<WebFeedbackFormsScreen> {
  final SharedPreferences pref = AppConfig().preferences!;

  int? selectedDetails;

  List<FeedModels> details = [
    FeedModels(
      id: 1,
      title: "Medical Feedback",
    ),
    FeedModels(
      id: 2,
      title: "Program Feedback",
    ),
    FeedModels(
      id: 3,
      title: "Gut Type Diagnosis",
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedDetails = widget.currentForm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 1.w),
                        child: buildAppBar(
                          () {
                            Navigator.pop(context);
                          },
                          showLogo: false,
                          showChild: true,
                          child: Text(
                            "Program Analysis",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: kFontBold,
                              color: gBlackColor,
                              fontSize: 16.dp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      ListView.builder(
                        itemCount: details.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isSelected =
                              selectedDetails == details[index].id;
                          return GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   selectedDetails = details[index].id;
                              // });
                            },
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.w, vertical: 1.5.h),
                                margin: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 0.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? gsecondaryColor
                                      : gWhiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  details[index].title,
                                  style: TextStyle(
                                    color: selectedDetails == details[index].id
                                        ? gWhiteColor
                                        : kTextColor,
                                    fontFamily:
                                        selectedDetails == details[index].id
                                            ? kFontMedium
                                            : kFontBook,
                                    fontSize: 14.dp,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                height: double.maxFinite,
                margin: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 2.w),
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: selectedDetails == 1
                    ? const MedicalFeedbackForm(
                        isFromWeb: true,
                      )
                    : selectedDetails == 2
                        ? const TCardPage(
                            programContinuesdStatus: 1,
                            isFromWeb: true,
                          )
                        : selectedDetails == 3
                            ? const PostGutTypeDiagnosis(
                                isFromWeb: true,
                              )
                            : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
