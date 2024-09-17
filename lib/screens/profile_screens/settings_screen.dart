/*
Api's used

logout:
var logOutUrl = "${AppConfig().BASE_URL}/api/logout";

 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gwc_customer_web/screens/profile_screens/reward/reward_screen.dart';
import 'package:gwc_customer_web/screens/profile_screens/terms_conditions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../model/error_model.dart';
import '../../model/profile_model/logout_model.dart';
import '../../model/uvdesk_model/new_ticket_details_model.dart';
import '../../repository/api_service.dart';
import '../../repository/login_otp_repository.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';
import '../../services/login_otp_service.dart';
import '../../services/uvdesk_service/uv_desk_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../cook_kit_shipping_screens/tracking_pop_up.dart';
import '../evalution_form/evaluation_form_screen.dart';
import '../evalution_form/evaluation_upload_report.dart';
import '../gut_list_screens/new_stages_data.dart';
import '../help_screens/help_screen.dart';
import '../medical_program_feedback_screen/post_gut_type_diagnosis.dart';
import '../notification_screen.dart';
import '../user_registration/existing_user.dart';
import '../uvdesk/create_ticket.dart';
import '../uvdesk/ticket_details_screen.dart';
import '../uvdesk/ticket_list.dart';
import 'call_support_method.dart';
import 'faq_screens/faq_screen.dart';
import 'my_profile_details.dart';
import 'package:badges/badges.dart' as badges;

import 'my_yoga_screens/my_yoga_screens.dart';

class SettingsScreen extends StatefulWidget {
  final bool? showBadge;
  const SettingsScreen({Key? key, this.showBadge = false}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SharedPreferences _pref = AppConfig().preferences!;

  bool isReplied = false;

  ///ticket isReplied save
  late final UvDeskService _uvDeskService =
      UvDeskService(uvDeskRepo: ticketRepository);

  NewTicketDetailsModel? threadsListModel;

  getThreadsList() async {
    final result = await _uvDeskService.getTicketDetailsByIdService(
        _pref.getString(AppConfig.User_ticket_id) ?? '');
    print("result: $result");

    if (result.runtimeType == NewTicketDetailsModel) {
      print("Threads List");
      NewTicketDetailsModel model = result as NewTicketDetailsModel;
      threadsListModel = model;
      setState(() {
        _pref.setBool("isReplied", model.response.ticket!.isReplied!);
        // isReplied = model.ticket!.isReplied!;

        print("isReplied : ${_pref.getBool("isReplied")!}");

        isReplied = _pref.getBool("isReplied") ?? false;
      });
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    print(result);
  }

  final UvDeskRepo ticketRepository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: gBackgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildAppBar(() => null,
                  isBackEnable: false,
                  showNotificationIcon: true,
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
              SizedBox(
                height: 4.h,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.5,
                    color: gsecondaryColor,
                  ),
                ),
                child: CircleAvatar(
                  radius: 7.h,
                  backgroundImage: NetworkImage(
                      "${_pref.getString(AppConfig.User_Profile)}"),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "${_pref.getString(AppConfig.User_Name)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: eUser().mainHeadingFont,
                    color: eUser().mainHeadingColor,
                    fontSize: eUser().mainHeadingFontSize),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "${_pref.getString(AppConfig.User_Number)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: eUser().userTextFieldHintFont,
                    color: gHintTextColor,
                    fontSize: eUser().userTextFieldFontSize),
              ),
              // Container(
              //   height: 10.h,
              //   width: double.maxFinite,
              //   child: Image(
              //     image: AssetImage("assets/images/profile_curve.png"),
              //     fit: BoxFit.fill,
              //   ),
              // ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 5.h),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: const BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: kLineColor,
                        offset: Offset(2, 3),
                        blurRadius: 5,
                      )
                    ],
                    // border: Border.all(
                    //   width: 1,
                    //   color: kLineColor,
                    // ),
                  ),
                  child: Center(
                    child: SizedBox(width: MediaQuery.of(context).size.shortestSide > 600 ? 40.w : double.maxFinite,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  profileTile(
                                      "assets/images/Group 2753.png", "My Profile",
                                      () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MyProfileDetails(),
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
                                              const MyYogaScreens(),
                                        ),
                                      );
                                    },
                                    showIcon: true,
                                  ),
                                  profileTile("assets/images/Group 2747.png", "FAQ",
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
                                  // Container(
                                  //   height: 1,
                                  //   color: Colors.grey,
                                  // ),
                                  // profileTile(
                                  //     "assets/images/Group 2748.png", "My Report", () {
                                  //   Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //       builder: (context) => UploadFiles(isFromSettings: false,),
                                  //     ),
                                  //   );
                                  // }),
                                  // Container(
                                  //   height: 1,
                                  //   color: Colors.grey,
                                  // ),
                                  // profileTile(
                                  //     "assets/images/Group 2748.png", "My Evaluation Report", () {
                                  //   Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //       builder: (context) => const PersonalDetailsScreen(showData: true,),
                                  //     ),
                                  //   );
                                  // }),
                                  // Visibility(
                                  //   // visible: kDebugMode,
                                  //   child: Container(
                                  //     height: 1,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //     visible: kDebugMode,
                                  //     child: profileTile(
                                  //         "assets/images/Group 2748.png", "Eval form",
                                  //         () {
                                  //       Navigator.of(context).push(
                                  //         MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               const EvaluationFormScreen(),
                                  //         ),
                                  //       );
                                  //     })),

                                  profileTile(
                                      "assets/images/coins.png", "My Rewards", () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const RewardScreen(),
                                      ),
                                    );
                                  }),
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

                                  // profileTile("assets/images/noun-chat-5153452.png",
                                  //     "Chat Support", () async {
                                  //       final chatSuccessId = _pref.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID);
                                  //   if(chatSuccessId == null || chatSuccessId == ""){
                                  //     showMessageSheet();
                                  //   }
                                  //   else{
                                  //     print(_pref!.getString(AppConfig.KALEYRA_USER_ID));
                                  //     final uId =
                                  //     _pref!.getString(AppConfig.KALEYRA_USER_ID);
                                  //     final res = await getAccessToken(uId!);
                                  //
                                  //     if (res.runtimeType != ErrorModel) {
                                  //       final accessToken = _pref.getString(
                                  //           AppConfig.KALEYRA_ACCESS_TOKEN);
                                  //
                                  //
                                  //       // chat
                                  //       openKaleyraChat(
                                  //           uId, chatSuccessId!, accessToken!);
                                  //     }
                                  //     else {
                                  //       final result = res as ErrorModel;
                                  //       print(
                                  //           "get Access Token error: ${result.message}");
                                  //       AppConfig().showSnackbar(
                                  //           context, result.message ?? '',
                                  //           isError: true, bottomPadding: 70);
                                  //     }
                                  //     // getChatGroupId();
                                  //   }
                                  //     }),
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
                                            ticketStatus: 1 ?? -1,
                                          ),
                                        ),
                                      );
                                    },
                                    showBadge: widget.showBadge,
                                  ),
                                  // profileTile(
                                  //     "assets/images/support.png", "Raise a Ticket",
                                  //     () {
                                  //   Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const TicketListScreen(),
                                  //     ),
                                  //   );
                                  // }),
                                  profileTile("assets/images/new_ds/support.png",
                                      "Call Support", () {
                                    showSupportCallSheet(context);
                                  }),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: IntrinsicWidth(
                              child: GestureDetector(
                                onTap: () => AppConfig().showSheet(
                                  context,
                                  logoutWidget(),
                                  bottomSheetHeight: 45.h,
                                  isDismissible: true,
                                ),
                                child: Container(
                                  // margin: EdgeInsets.symmetric(horizontal: 30.w),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    color: gWhiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: kLineColor,
                                        offset: Offset(2, 3),
                                        blurRadius: 5,
                                      )
                                    ],
                                    // border: Border.all(
                                    //   width: 1,
                                    //   color: kLineColor,
                                    // ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: const AssetImage(
                                          "assets/images/Group 2744.png",
                                        ),
                                        height: 4.h,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                          color: kTextColor,
                                          fontFamily: kFontBook,
                                          fontSize: 13.dp,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _prefs = AppConfig().preferences;

  void submitEditShits() async {
    print("--- submit Edit Shifts ---");

    String path = "https://gutandhealth.com/api/postCETData/editShift";

    Map<String, String> m = {
      "id": "12",
      "shift_start_time": "09:30",
      "shift_end_time": "19:30",
      "break_start_time": "13:30",
      "break_end_time": "14:30",
    };

    print("Edit Shift data : $m");

    print(
        "Edit Shift data Token : ${_prefs!.getString(AppConfig().BEARER_TOKEN)}");

    print("Edit Shift path : $path");

    // try {
    final response = await http
        .post(Uri.parse(path),
            headers: {
              "Authorization":
                  "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiY2NkYzVkMjAwZDk4Y2NmY2I1ZTMyMDA5OTk4OTlmMWRiOTI4NjM3M2FiNTY3YjA1YzZhZDBmYTk5ODUyODFhZDFiNTc4MWFlYTEzZGVkMDIiLCJpYXQiOjE3MTQ2MjM4MTUuMDU5Nzk4OTU1OTE3MzU4Mzk4NDM3NSwibmJmIjoxNzE0NjIzODE1LjA1OTgwMzAwOTAzMzIwMzEyNSwiZXhwIjoxNzQ2MTU5ODE1LjA1MTQ5NTA3NTIyNTgzMDA3ODEyNSwic3ViIjoiNTI3Iiwic2NvcGVzIjpbXX0.xKgBtrbudcAmzte-GkXK-5K0WZMUIEj9zcM9ni7fHgfQLiAXe0rY2aKjv9soga2g-nPTTpAuvwkbq2i8Q79LjljayzEIwJonICZXuTmMxvsXZbnb0UPFGXgink92RpbDfXcvhhv1RxM1Vvjsb_TfUTyBIasxPkmv-1YKqsMJO5aYHQoDek__sLLhjqDxip6FA-A6-a6KzZEzX8wKRr1rU2nA5JLJGMupL4YWs7JFWiFsxXeLt8JxSQ2Mhi_u4ao43oWFfbSZYrcA6Y7MjoHk8OPKg617omDYitxm5Bc2jL3_hfkoejoOM6WRMms-Xi_83oS7NLdl22nMfDhMp7FNraU4YSP3vAfB95mjTt8bRofKk2kdOZFGbfv418NLdSZfxZLO7jqBYpi0zOCjWCENR7OVxVcaouUi7d83PhAlzcEOR4jOi94DxMJAVHscAqFHJxAmvb192M8rOoecMltUwVGqxAnAkXxmT6xKj8-3Jqx5PLFXS3Pax6V5Z6aAPQDChBae5oEFNRjhxv7cLQPGwp_aLMxoLZhpUKALvvJec74_HPsaNB235-e1ywVNlzS_pBg42v0c6P31OsP8ctVPAKAe-MER94sh54YHmpYonOwr2jBSafik8vesmCf7GJXVZjgLgvTLHdTcvxio7WeKs_HU3k8ehpiDuWYHMIFf6Zg",
              "Access-Control-Allow-Origin": "*",
            },
            body: m)
        .timeout(const Duration(seconds: 45));

    print('submitEditShits Response header: $path');
    print('submitEditShits Response status: ${response.statusCode}');
    print('submitEditShits Response body: ${response.body}');
    final res = jsonDecode(response.body);

    if (response.statusCode == 200) {
      AppConfig().showSnackbar(context, res['message'] ?? '', isError: false);
    } else {
      AppConfig().showSnackbar(context, "Failed" ?? '', isError: true);
    }
    // } catch (e) {
    //   AppConfig().showSnackbar(context, "$e" ?? '', isError: true);
    // }

    // setState(() {
    //   isLoading = true;
    // });
    // try {
    //   shiftsDataController
    //       ?.submitEditShifts(
    //     widget.shiftId.toString(),
    //     shiftStartTimeController.text.toString(),
    //     shiftEndTimeController.text.toString(),
    //     breakStartTimeController.text.toString(),
    //     breakEndTimeController.text.toString(),
    //   )
    //       .then((value) {
    //     if (shiftsDataController?.shiftsDataResponse.status ==
    //         Status.COMPLETED) {
    //       print(
    //           "login response : ${shiftsDataController?.shiftsDataResponse
    //               .data}");
    //
    //       NormalModel model = shiftsDataController?.shiftsDataResponse.data;
    //
    //       AppConfig().showSnackbar(context,
    //           "${shiftsDataController?.shiftsDataResponse.message}" ?? '',
    //           isError: false);
    //
    //       Navigator.of(context).push(
    //         MaterialPageRoute(builder: (context) => const DoctorShiftScreen()),
    //       );
    //     } else if (shiftsDataController?.shiftsDataResponse.status ==
    //         Status.ERROR) {
    //       print(
    //           "login error : ${shiftsDataController?.shiftsDataResponse
    //               .status}");
    //       AppConfig().showSnackbar(
    //           context, shiftsDataController?.shiftsDataResponse.message ?? '',
    //           isError: true);
    //     }
    //     print("after");
    //   });
    // }
    // catch (e) {
    //   AppConfig().showSnackbar(context, "$e" ?? '', isError: true);
    // }
    // setState(() {
    //   isLoading = false;
    // });
  }

  profileTile(String image, String title, func,
      {bool? showBadge = false, bool showIcon = false}) {
    return InkWell(
      onTap: func,
      child: Row(
        children: [
          Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  padding: const EdgeInsets.all(5),
                  // decoration: BoxDecoration(
                  //   // color: gBlackColor.withOpacity(0.05),
                  //   borderRadius: BorderRadius.circular(5),
                  // ),
                  child: showIcon
                      ? Icon(
                    Icons.self_improvement,
                    color: gBlackColor,
                    size: 4.h,
                  )
                      :  isReplied
                      ? badges.Badge(
                          badgeAnimation: badges.BadgeAnimation.rotation(
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
          GestureDetector(
            onTap: func,
            child: Icon(
              Icons.arrow_forward_ios,
              color: gBlackColor,
              size: 2.5.h,
            ),
          ),
        ],
      ),
    );
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
    final res =
        await LoginWithOtpService(repository: repository).logoutService();

    if (res.runtimeType == LogoutModel) {
      clearAllUserDetails();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ExistingUser(),
      ));
    } else {
      ErrorModel model = res as ErrorModel;
      Get.snackbar(
        "",
        model.message!,
        colorText: gWhiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gsecondaryColor.withOpacity(0.55),
      );
    }

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
                    IntrinsicWidth(
                      child: GestureDetector(
                        onTap: () => logOut(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 5.w),
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
                    ),
                    SizedBox(width: 5.w),
                    IntrinsicWidth(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 5.w),
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
                    ),
                  ],
                ),
          SizedBox(height: 1.h)
        ],
      );
    });
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

  void showMessageSheet() {
    return AppConfig().showSheet(
      context,
      chatEmptyMessageWidget(),
      bottomSheetHeight: 45.h,
      isDismissible: true,
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
                            // setstate(() {
                            //   isInAppCallPressed = true;
                            // });
                            // final res = await callSupport();
                            // if (res.runtimeType != ErrorModel) {
                            //   AppConfig().showSnackbar(context,
                            //       "Call Initiated. Our success Team will call you soon.");
                            // } else {
                            //   final result = res as ErrorModel;
                            //   AppConfig().showSnackbar(context,
                            //       "You can call your Success Team Member once you book your appointment",
                            //       isError: true, bottomPadding: 50);
                            // }
                            // setState(() {
                            //   isInAppCallPressed = false;
                            // });
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
                        if (_pref!.getString(AppConfig.KALEYRA_SUCCESS_ID) ==
                            null) {
                          AppConfig().showSnackbar(
                              context, "Success Team Not available",
                              isError: true);
                        } else {
                          // // click-to-call
                          // callSupport();

                          if (_pref!
                                  .getString(AppConfig.KALEYRA_ACCESS_TOKEN) !=
                              null) {
                            final accessToken = _pref!
                                .getString(AppConfig.KALEYRA_ACCESS_TOKEN);
                            final uId =
                                _pref!.getString(AppConfig.KALEYRA_USER_ID);
                            final successId =
                                _pref!.getString(AppConfig.KALEYRA_SUCCESS_ID);
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

  openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    }
  }
}
