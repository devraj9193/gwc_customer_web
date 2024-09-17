import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/profile_details_screen.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/reports_screens/my_reports_screen.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/yoga_screens/my_yoga_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../appointment_screens/consultation_screens/upload_files.dart';
import '../evalution_form/evaluation_form_screen.dart';
import '../evalution_form/evaluation_get_details.dart';
import '../help_screens/help_screen.dart';
import '../notification_screen.dart';
import '../profile_screens/call_support_method.dart';
import '../profile_screens/faq_screens/faq_screen.dart';
import '../profile_screens/terms_conditions_screen.dart';
import '../uvdesk/ticket_chat_screens/ticket_chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'feedback_screen/feedback_screen.dart';
import 'get_evaluation_screen/get_evaluation_screen.dart';

class NewProfileScreen extends StatefulWidget {
  final bool? showBadge;
  const NewProfileScreen({
    Key? key,
    this.showBadge = false,
  }) : super(key: key);

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  final SharedPreferences _pref = AppConfig().preferences!;
  bool isReplied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gsecondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 2.w,
                right: 1.5.w,
                top: 2.h,
              ),
              child: buildAppBar(() {},
                  isBackEnable: false,
                  showNotificationIcon: true,
                  helpIconColor: gWhiteColor,
                  isProfileScreen: true,
                  notificationOnTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationScreen()));
                  },
                  showHelpIcon: true,
                  helpOnTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HelpScreen()));
                  }),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: 8.h),
                    decoration: const BoxDecoration(
                      color: profileBackGroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.shortestSide > 600
                                      ? 50.w
                                      : double.maxFinite,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 5.w, right: 5.w, bottom: 2.h),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.h, horizontal: 2.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${_pref.getString(AppConfig.User_Name)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  eUser().mainHeadingFont,
                                              color: eUser().mainHeadingColor,
                                              fontSize:
                                                  eUser().mainHeadingFontSize),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          "${_pref.getString(AppConfig.User_Email)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  eUser().userTextFieldHintFont,
                                              color: gHintTextColor,
                                              fontSize: eUser()
                                                  .userTextFieldFontSize),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h),
                                          child: const Divider(),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              buildButtons(
                                                "Evaluation",
                                                Icon(
                                                  Icons.article_outlined,
                                                  color: gBlackColor,
                                                  size: 4.h,
                                                ),
                                                () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const GetEvaluationScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(width: 3.w),
                                              buildButtons(
                                                "My Reports",
                                                Icon(
                                                  Icons.file_copy_outlined,
                                                  color: gBlackColor,
                                                  size: 4.h,
                                                ),
                                                () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MyReportsScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(width: 3.w),
                                              buildButtons(
                                                "Feedback",
                                                Icon(
                                                  Icons.reviews_outlined,
                                                  color: gBlackColor,
                                                  size: 4.h,
                                                ),
                                                () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const FeedbackScreen(),
                                                      // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  profileTile("assets/images/Group 2753.png",
                                      "My Profile", () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfileDetailsScreen(),
                                      ),
                                    );
                                  }),
                                  profileTile(
                                    "assets/images/Group 2753.png",
                                    "My Yoga's",
                                    () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyYogaScreen(),
                                        ),
                                      );
                                    },
                                    showIcon: true,
                                  ),
                                  profileTile(
                                      "assets/images/Group 2747.png", "FAQ",
                                      () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const FaqScreen(),
                                      ),
                                    );
                                  }),
                                  profileTile("assets/images/Group 2748.png",
                                      "Terms & Conditions", () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TermsConditionsScreen(),
                                      ),
                                    );
                                  }),
                                  // profileTile(
                                  //     "assets/images/coins.png", "My Rewards",
                                  //     () {
                                  //   Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const RewardScreen(),
                                  //     ),
                                  //   );
                                  // }),
                                  Visibility(
                                      visible: kDebugMode,
                                      child: profileTile(
                                          "assets/images/Group 2748.png",
                                          "Eval form", () {
                                        // submitEditShits();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                // const EvaluationUploadReport(),
                                                const EvaluationFormScreen(),
                                          ),
                                        );
                                      })),
                                  profileTile(
                                    "assets/images/noun-chat-5153452.png",
                                    "Chat Support",
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => TicketChatScreen(
                                            userName:
                                                "${_pref.getString(AppConfig.User_Name)}",
                                            thumbNail:
                                                "${_pref.getString(AppConfig.User_Profile)}",
                                            ticketId: _pref.getString(
                                                    AppConfig.User_ticket_id) ??
                                                '',
                                            subject: '',
                                            email:
                                                "${_pref.getString(AppConfig.User_Email)}",
                                            ticketStatus: 1,
                                          ),
                                        ),
                                      );
                                    },
                                    showBadge: widget.showBadge,
                                  ),
                                  profileTile(
                                      "assets/images/new_ds/support.png",
                                      "Call Support", () {
                                    showSupportCallSheet(context);
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -3.h,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: gWhiteColor),
                      child: Center(
                        child: CircleAvatar(
                          radius: 8.h,
                          backgroundImage: NetworkImage(
                              "${_pref.getString(AppConfig.User_Profile)}"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// this method is for showing common Circle image for reports
  buildButtons(String title, Widget icon, func) {
    return GestureDetector(
      onTap: func,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: gGreyColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: icon,
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: TextStyle(
              color: gTextColor,
              fontFamily: kFontMedium,
              fontSize: 13.dp,
            ),
          ),
        ],
      ),
    );
  }

  profileTile(String image, String title, func,
      {bool? showBadge = false, bool showIcon = false}) {
    return GestureDetector(
      onTap: func,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              padding: const EdgeInsets.all(5),
              child: showIcon
                  ? Icon(
                      Icons.self_improvement,
                      color: gBlackColor,
                      size: 4.h,
                    )
                  : isReplied
                      ? badges.Badge(
                          badgeAnimation: const badges.BadgeAnimation.rotation(
                            animationDuration: Duration(seconds: 1),
                            colorChangeAnimationDuration: Duration(seconds: 1),
                            loopAnimation: false,
                            curve: Curves.fastOutSlowIn,
                            colorChangeAnimationCurve: Curves.easeInCubic,
                          ),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.circle,
                            badgeColor: gsecondaryColor.withOpacity(0.7),
                            // padding: EdgeInsets.all(5),
                            // borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: gsecondaryColor.withOpacity(0.7),
                                width: 1),
                            // borderGradient: badges.BadgeGradient.linear(
                            //     colors: [Colors.red, Colors.black]),
                            // badgeGradient: badges.BadgeGradient.linear(
                            //   colors: [Colors.blue, Colors.yellow],
                            //   begin: Alignment.topCenter,
                            //   end: Alignment.bottomCenter,
                            // ),
                            elevation: 0,
                          ),
                          badgeContent: const Padding(
                            padding: EdgeInsets.all(0.5),
                            child: Text(
                              '1',
                              style: TextStyle(color: gWhiteColor),
                            ),
                          ),
                          child: Image(
                            image: AssetImage(image),
                            height: 4.5.h,
                          ),
                        )
                      : Image(
                          image: AssetImage(image),
                          height: 4.5.h,
                        ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: kTextColor,
                  fontFamily: kFontBook,
                  fontSize: 14.dp,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: gBlackColor,
              size: 3.h,
            ),
          ],
        ),
      ),
    );
  }

  bool isInAppCallPressed = false;

  /// this will be showing when support call icon pressed
  showSupportCallSheet(BuildContext context) {
    return AppConfig().showSheet(
        context,
        StatefulBuilder(builder: (_, setstate) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Please Select Call Type",
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
              SizedBox(height: 1.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (isInAppCallPressed)
                        ? null
                        : () async {
                            setState(() {
                              openDialPad(
                                  '${_pref.getString(AppConfig.SUPPORT_NUMBER)}');
                            });
                            Navigator.pop(context);
                          },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                          color: gsecondaryColor,
                          border: Border.all(color: kLineColor, width: 0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Call Support",
                        style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gWhiteColor,
                          fontSize: 11.dp,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 5.w),
                  Visibility(
                    visible: false,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (_pref.getString(AppConfig.KALEYRA_SUCCESS_ID) ==
                            null) {
                          AppConfig().showSnackbar(
                              context, "Success Team Not available",
                              isError: true);
                        } else {
                          // // click-to-call
                          // callSupport();

                          if (_pref.getString(AppConfig.KALEYRA_ACCESS_TOKEN) !=
                              null) {
                            final accessToken =
                                _pref.getString(AppConfig.KALEYRA_ACCESS_TOKEN);
                            final uId =
                                _pref.getString(AppConfig.KALEYRA_USER_ID);
                            final successId =
                                _pref.getString(AppConfig.KALEYRA_SUCCESS_ID);
                            // voice- call
                            supportVoiceCall(uId!, successId!, accessToken!);
                          } else {
                            AppConfig().showSnackbar(
                                context, "Something went wrong!!",
                                isError: true);
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: gWhiteColor,
                            border: Border.all(color: kLineColor, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Voice Call",
                          style: TextStyle(
                            fontFamily: kFontMedium,
                            color: gsecondaryColor,
                            fontSize: 11.dp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h)
            ],
          );
        }),
        bottomSheetHeight: 40.h,
        isDismissible: true,
        isSheetCloseNeeded: true,
        sheetCloseOnTap: () {
          Navigator.pop(context);
        });
  }

  void showMessageSheet() {
    return AppConfig().showSheet(
      context,
      chatEmptyMessageWidget(),
      bottomSheetHeight: 45.h,
      isDismissible: true,
    );
  }

  chatEmptyMessageWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Message",
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
            'Success Team member yet to assigned.\nPlease try after sometime',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: gTextColor,
                fontSize: bottomSheetSubHeadingXFontSize,
                fontFamily: bottomSheetSubHeadingMediumFont,
                height: 1.4),
          ),
        ),
        SizedBox(height: 3.h),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 12.w),
              decoration: BoxDecoration(
                  color: gWhiteColor,
                  border: Border.all(color: kLineColor, width: 0.5),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                "GotIt",
                style: TextStyle(
                  fontFamily: kFontMedium,
                  color: gsecondaryColor,
                  fontSize: 11.dp,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h)
      ],
    );
  }

  openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    }
  }
}
