import 'package:gwc_customer_web/screens/evalution_form/web_eval_screens/web_eval_screen.dart';
import 'package:gwc_customer_web/widgets/button_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../repository/api_service.dart';
import '../../repository/login_otp_repository.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/exit_widget.dart';
import '../../widgets/widgets.dart';
import '../gut_list_screens/new_stages_data.dart';
import '../user_registration/existing_user.dart';
import 'evaluation_form_page1.dart';

class EvaluationFormScreen extends StatefulWidget {
  /// isFromSplashScreen is used to handle back button press event
  /// if false than we will do pop else we r showing bottom sheet
  final bool isFromSplashScreen;
  const EvaluationFormScreen({Key? key, this.isFromSplashScreen = false})
      : super(key: key);

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
    setState(() {
      _currentUser = _pref.getString(AppConfig.User_Name) ?? '';
    });
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
                  buildAppBar(
                    (widget.isFromSplashScreen)
                        ? () {}
                        : () {
                            Navigator.pop(context);
                          },
                    actions: [
                      GestureDetector(
                        onTap: () => AppConfig().showSheet(
                          context,
                          logoutWidget(),
                          bottomSheetHeight: 45.h,
                          isDismissible: true,
                        ),
                        child: Icon(
                          Icons.logout_sharp,
                          color: gBlackColor,
                          size: 2.5.h,
                        ),
                      ),
                    ],
                    customAction: true,
                    isBackEnable: false,
                  ),
                  Center(
                    child: Image(
                      image: AssetImage("assets/images/eval.png"),
                      height: 45.h,
                    ),
                  ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  Text(
                    "Gut Wellness Club Evaluation Form",
                    style: TextStyle(
                        fontFamily: kFontBold,
                        color: kTextColor,
                        fontSize: 16.dp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Hello $_currentUser,",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: kFontMedium,
                        // height: 1.4,
                        color: gHintTextColor,
                        fontSize: 14.dp),
                  ),
                  Text(
                    "Congrats on formally starting your Gut Wellness Journey!",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: kFontMedium,
                        // height: 1.4,
                        color: kLineColor,
                        fontSize: 13.dp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Here is an evaluation form that will provide us with information that will play a critical role in evaluating your condition & assist your doctor in creating your program.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: kFontBook,
                        // height: 1.4,
                        color: kTextColor,
                        fontSize: 13.dp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Text(
                      "Do fill this to the best of your knowledge. All your data is confidential & is visible to only your doctors & a few team members who assist them. Time to fill 3-4 Minutes",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: kFontBook,
                          color: kTextColor,
                          // height: 1.4,
                          fontSize: 13.dp),
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
                  //       fontSize: 10.dp),
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
                  //       fontSize: 10.dp),
                  // ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Center(
                    child: ButtonWidget(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>  MediaQuery.of(context).size.shortestSide > 600
                                ? const WebEvalScreen()
                                : const EvaluationFormPage1(),
                          ),
                        );
                      },
                      text: 'NEXT',
                      isLoading: false,
                      buttonWidth: 18.w,
                    ),
                  ),
                  // Center(
                  //   child: IntrinsicWidth(
                  //     child: GestureDetector(
                  //       // onTap: (showLoginProgress) ? null : () {
                  //       onTap: () {
                  //         Navigator.of(context).push(
                  //           MaterialPageRoute(
                  //             builder: (context) => const EvaluationFormPage1(),
                  //             // const PersonalDetailsScreen(showData: true,),
                  //           ),
                  //         );
                  //
                  //         /// local storage details
                  //         // _pref.remove(AppConfig.eval1);
                  //         // if(_pref.getString(AppConfig.eval1) != null && _pref.getString(AppConfig.eval1) != ""){
                  //         //   final jsonEval1 = _pref.getString(AppConfig.eval1);
                  //         //   if(_pref.getString(AppConfig.eval2) != null && _pref.getString(AppConfig.eval2) != ""){
                  //         //
                  //         //     final jsonEval2 = _pref.getString(AppConfig.eval2);
                  //         //
                  //         //     Navigator.push(context, MaterialPageRoute(
                  //         //         builder: (ctx) => EvaluationUploadReport(
                  //         //           evaluationModelFormat1: EvaluationModelFormat1.fromMap(json.decode(jsonEval1!)),
                  //         //           evaluationModelFormat2: EvaluationModelFormat2.fromMap(json.decode(jsonEval2!)),
                  //         //         )
                  //         //     ));
                  //         //   }
                  //         //   else{
                  //         //     Navigator.push(
                  //         //         context,
                  //         //         MaterialPageRoute(
                  //         //             builder: (ctx) => PersonalDetailsScreen2(
                  //         //               evaluationModelFormat1: EvaluationModelFormat1.fromMap(json.decode(jsonEval1!)),
                  //         //             )
                  //         //         ));
                  //         //   }
                  //         // }
                  //         // else{
                  //         //   Navigator.of(context).push(
                  //         //     MaterialPageRoute(
                  //         //       builder: (context) => const PersonalDetailsScreen(),
                  //         //     ),
                  //         //   );
                  //         // }
                  //       },
                  //       child: Container(
                  //         margin: EdgeInsets.symmetric(vertical: 4.h),
                  //         padding: EdgeInsets.symmetric(
                  //             vertical: 1.5.h, horizontal: 5.w),
                  //         decoration: BoxDecoration(
                  //           color: eUser().buttonColor,
                  //           borderRadius: BorderRadius.circular(
                  //               eUser().buttonBorderRadius),
                  //           // border: Border.all(
                  //           //     color: eUser().buttonBorderColor,
                  //           //     width: eUser().buttonBorderWidth
                  //           // ),
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             'NEXT',
                  //             style: TextStyle(
                  //               fontFamily: eUser().buttonTextFont,
                  //               color: eUser().buttonTextColor,
                  //               fontSize: eUser().buttonTextSize,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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

  bool showLogoutProgress = false;

  /// we r showing in stateful builder so this parameter will be used
  /// when we get setstate we will assign to this parameter based on that logout progress is used
  var logoutProgressState;

  logoutWidget() {
    return StatefulBuilder(builder: (_, setstate) {
      logoutProgressState = setstate;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "We will miss you.",
              style: TextStyle(
                  fontSize: bottomSheetHeadingFontSize,
                  fontFamily: bottomSheetHeadingFontFamily,
                  height: 1.4),
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
              'Do you really want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gTextColor,
                fontSize: bottomSheetSubHeadingXFontSize,
                fontFamily: bottomSheetSubHeadingMediumFont,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          (showLogoutProgress)
              ? Center(child: buildCircularIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(
                      onPressed: () => logOut(),
                      text: "Yes",
                      isLoading: false,
                      radius: 5,
                      buttonWidth: 15.w,
                    ),
                    SizedBox(width: 5.w),
                    ButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      text: "No",
                      isLoading: false,
                      radius: 5,
                      buttonWidth: 15.w,
                      color: gWhiteColor,
                      textColor: gsecondaryColor,
                    ),
                    // GestureDetector(
                    //   onTap: () => logOut(),
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //         vertical: 1.h, horizontal: 12.w),
                    //     decoration: BoxDecoration(
                    //         color: gsecondaryColor,
                    //         border: Border.all(color: kLineColor, width: 0.5),
                    //         borderRadius: BorderRadius.circular(5)),
                    //     child: Text(
                    //       "YES",
                    //       style: TextStyle(
                    //         fontFamily: kFontMedium,
                    //         color: gWhiteColor,
                    //         fontSize: 11.dp,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 5.w),
                    // GestureDetector(
                    //   onTap: () => Navigator.pop(context),
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //         vertical: 1.h, horizontal: 12.w),
                    //     decoration: BoxDecoration(
                    //         color: gWhiteColor,
                    //         border: Border.all(color: kLineColor, width: 0.5),
                    //         borderRadius: BorderRadius.circular(5)),
                    //     child: Text(
                    //       "NO",
                    //       style: TextStyle(
                    //         fontFamily: kFontMedium,
                    //         color: gsecondaryColor,
                    //         fontSize: 11.dp,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
          SizedBox(height: 1.h)
        ],
      );
    });
  }

  final LoginOtpRepository repository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void logOut() async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    // final res =
    //     await LoginWithOtpService(repository: repository).logoutService();
    //
    // if (res.runtimeType == LogoutModel) {
      clearAllUserDetails();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ExistingUser(),
      ));
    // } else {
    //   ErrorModel model = res as ErrorModel;
    //   Get.snackbar(
    //     "",
    //     model.message!,
    //     colorText: gWhiteColor,
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: gsecondaryColor.withOpacity(0.55),
    //   );
    // }

    logoutProgressState(() {
      showLogoutProgress = true;
    });
  }

  // clearing some details in local storage
  clearAllUserDetails() {
    _pref.setBool(AppConfig.isLogin, false);
    _pref.remove(AppConfig().BEARER_TOKEN);

    _pref.remove(AppConfig.User_Name);
    _pref.remove(AppConfig.USER_ID);
    _pref.remove(AppConfig.QB_USERNAME);
    _pref.remove(AppConfig.QB_CURRENT_USERID);
    _pref.remove(AppConfig.KALEYRA_USER_ID);
    _pref.remove(AppConfig.User_Name);
    _pref.remove(AppConfig.User_Profile);
    _pref.remove(AppConfig.User_Number);

    updateStageData();
  }

  Future<bool> _onWillPop() async {
    // ignore: avoid_print
    print('back pressed eval');
    return (widget.isFromSplashScreen)
        ? AppConfig().showSheet(context, ExitWidget(), bottomSheetHeight: 45.h)
        : true;
  }

  exitWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Hold On!",
            style: TextStyle(
                fontSize: bottomSheetHeadingFontSize,
                fontFamily: bottomSheetHeadingFontFamily,
                height: 1.4),
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
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 12.w),
                decoration: BoxDecoration(
                    color: gsecondaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "YES",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 11.dp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 12.w),
                decoration: BoxDecoration(
                    color: gWhiteColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "NO",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gsecondaryColor,
                    fontSize: 11.dp,
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

  final String oldText1 =
      "1) Determine If This Program Can Heal You & Therefore Determine If We Can Proceed With Your Case Or Not.";
  final String oldText2 =
      "2) If Accepted What Sort Of Customization is Required To Heal Your Condition(s) Please Fill This To The Best Of Your Knowledge As This is Critical. Time To Fill 10-15Mins";
  final String oldText3 =
      "Your Doctors Might Personally Get In Touch With You If More Information Is Needed.";

  final String newText1 =
      "This Form Will Be Evaluated By Your Senior Doctors To Preliminarily Evaluate Your Condition & Determine What Sort Of Customization Is Required";
  final String newText2 =
      "To Heal Your Condition(s) & To Ship Your Customized Ready To Cook Kit.";
  final String newText3 =
      "Please Fill This To The Best Of Your Knowledge As This Is Critical. Time To Fill 3-4Mins";
}
