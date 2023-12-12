import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/exit_widget.dart';
import '../../widgets/widgets.dart';
import 'personal_details_screen.dart';


class EvaluationFormScreen extends StatefulWidget {
  /// isFromSplashScreen is used to handle back button press event
  /// if false than we will do pop else we r showing bottom sheet
  final bool isFromSplashScreen;
  const EvaluationFormScreen({Key? key, this.isFromSplashScreen = false}) : super(key: key);

  @override
  State<EvaluationFormScreen> createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends State<EvaluationFormScreen> {

  final SharedPreferences _pref = AppConfig().preferences!;
  String? _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("_currentUser: ${_pref.getString(AppConfig.User_Name)}");
    _currentUser = _pref.getString(AppConfig.User_Name) ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h, bottom: 5.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar((widget.isFromSplashScreen) ? (){} : () {
                    Navigator.pop(context);
                  },
                      isBackEnable: false),
                  const Center(
                    child: Image(
                      image: AssetImage("assets/images/eval.png"),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Gut Wellness Club Evaluation Form",
                    style: TextStyle(
                        fontFamily: kFontBold,
                        color: kTextColor,
                        fontSize: 12.sp),
                  ),
                  SizedBox(
                      height: 2.h
                  ),
                  Text(
                    "Hello $_currentUser,",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: kFontMedium,
                        height: 1.4,
                        color: gHintTextColor,
                        fontSize: 12.sp),
                  ),
                  Text(
                    "Congrats on formally starting your Gut Wellness Journey!",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: kFontMedium,
                        height: 1.4,
                        color: kLineColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                      height: 2.h
                  ),
                  Text(
                    "Here is an evaluation form that will provide us with information that will play a critical role in evaluating your condition & assist your doctor in creating your program.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: kFontBook,
                        height: 1.4,
                        color: kTextColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Text(
                      "Do fill this to the best of your knowledge.\nAll your data is confidential & is visible to only your doctors & a few team members who assist them.\nTime to fill 3-4 Minutes",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: kTextColor,
                          height: 1.4,
                          fontSize: 10.sp
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // Text(
                  //   newText3,
                  //   textAlign: TextAlign.justify,
                  //   style: TextStyle(
                  //       fontFamily: kFontBook,
                  //       color: kTextColor,
                  //       fontSize: 10.sp),
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // Text(
                  //   "This Form Will Be Confidential & Only Visible To Your Doctors.",
                  //   textAlign: TextAlign.justify,
                  //   style: TextStyle(
                  //       fontFamily: kFontBook,
                  //       color: kTextColor,
                  //       fontSize: 10.sp),
                  // ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Center(
                    child: GestureDetector(
                      // onTap: (showLoginProgress) ? null : () {
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PersonalDetailsScreen(),
                          ),
                        );
                        /// local storage details
                        // _pref.remove(AppConfig.eval1);
                        // if(_pref.getString(AppConfig.eval1) != null && _pref.getString(AppConfig.eval1) != ""){
                        //   final jsonEval1 = _pref.getString(AppConfig.eval1);
                        //   if(_pref.getString(AppConfig.eval2) != null && _pref.getString(AppConfig.eval2) != ""){
                        //
                        //     final jsonEval2 = _pref.getString(AppConfig.eval2);
                        //
                        //     Navigator.push(context, MaterialPageRoute(
                        //         builder: (ctx) => EvaluationUploadReport(
                        //           evaluationModelFormat1: EvaluationModelFormat1.fromMap(json.decode(jsonEval1!)),
                        //           evaluationModelFormat2: EvaluationModelFormat2.fromMap(json.decode(jsonEval2!)),
                        //         )
                        //     ));
                        //   }
                        //   else{
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (ctx) => PersonalDetailsScreen2(
                        //               evaluationModelFormat1: EvaluationModelFormat1.fromMap(json.decode(jsonEval1!)),
                        //             )
                        //         ));
                        //   }
                        // }
                        // else{
                        //   Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (context) => const PersonalDetailsScreen(),
                        //     ),
                        //   );
                        // }
                      },
                      child: Container(
                        width: 40.w,
                        height: 5.h,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: eUser().buttonColor,
                          borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                          // border: Border.all(
                          //     color: eUser().buttonBorderColor,
                          //     width: eUser().buttonBorderWidth
                          // ),
                        ),
                        child: Center(
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                              fontFamily: eUser().buttonTextFont,
                              color: eUser().buttonTextColor,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: CommonButton.submitButton(() {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) => const PersonalDetailsScreen(),
                  //       ),
                  //     );
                  //   }, "NEXT"),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> _onWillPop() async {
    // ignore: avoid_print
    print('back pressed eval');
    return (widget.isFromSplashScreen) ? AppConfig().showSheet(context, ExitWidget(), bottomSheetHeight: 45.h) : true;
  }

  exitWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("Hold On!",
            style: TextStyle(
                fontSize: bottomSheetHeadingFontSize,
                fontFamily: bottomSheetHeadingFontFamily,
                height: 1.4
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            color: kLineColor,
            thickness: 1.2,
          ),
        ),
        Center(
          child: Text(
            'Do you want to exit an App?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gTextColor,
              fontSize: bottomSheetSubHeadingXFontSize,
              fontFamily: bottomSheetSubHeadingMediumFont,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => SystemNavigator.pop(),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 1.h, horizontal: 12.w),
                decoration: BoxDecoration(
                    color: gsecondaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "YES",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 1.h, horizontal: 12.w),
                decoration: BoxDecoration(
                    color: gWhiteColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "NO",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gsecondaryColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h)
      ],
    );
  }



  final String oldText1 = "1) Determine If This Program Can Heal You & Therefore Determine If We Can Proceed With Your Case Or Not.";
  final String oldText2 = "2) If Accepted What Sort Of Customization is Required To Heal Your Condition(s) Please Fill This To The Best Of Your Knowledge As This is Critical. Time To Fill 10-15Mins";
  final String oldText3 = "Your Doctors Might Personally Get In Touch With You If More Information Is Needed.";

  final String newText1 = "This Form Will Be Evaluated By Your Senior Doctors To Preliminarily Evaluate Your Condition & Determine What Sort Of Customization Is Required";
  final String newText2 = "To Heal Your Condition(s) & To Ship Your Customized Ready To Cook Kit.";
  final String newText3 = "Please Fill This To The Best Of Your Knowledge As This Is Critical. Time To Fill 3-4Mins";

}
