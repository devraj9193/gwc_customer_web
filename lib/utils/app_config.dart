import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../model/ship_track_model/ship_track_activity_model.dart';
import '../widgets/constants.dart';
import 'package:get/get.dart';

class AppConfig{
  static AppConfig? instance;
  factory AppConfig() => instance ??= AppConfig._();
  AppConfig._();

  /// need to change this each time when we send the aab
  static const double androidVersion = 34.0;

  /// passing this when there is a difference in old apk and new apk version
  /// it will open playstore
  static const androidBundleId = "com.fembuddy.gwc_customer";

  static const String androidAppURL = "https://play.google.com/store/apps/details?id=com.fembuddy.gwc_customer";
  static const String iosAppURL = "https://play.google.com/store/apps/details?id=com.fembuddy.gwc_customer";

  static const String updateAppContent = "New Version Available Please Update";

  // final String BASE_URL = "https://gwc.disol.in";

  final String BASE_URL = "https://gutandhealth.com";

  // final String BASE_URL = "https://gutandhealth.in";

  final String shipRocket_AWB_URL = 'https://apiv2.shiprocket.in/v1/external';
  final String UUID = 'uuid';

  final String BEARER_TOKEN = "Bearer";

  // ****** QuickBlox Credentials ****************

  // static const String QB_APP_ID = "98585";
  // static const String QB_AUTH_KEY = "aPtW8zaYg-Qmhf9";
  // static const String QB_AUTH_SECRET = "MDvw-kpzNRGVLt4";
  // static const String QB_ACCOUNT_KEY = "1s1UERbtsu13uQFYVF9Y";
  static const String QB_APP_ID = "99437";
  static const String QB_AUTH_KEY = "zhVfP2jWfvrhe2r";
  static const String QB_AUTH_SECRET = "WhzcEcT3tau5Mfj";
  static const String QB_ACCOUNT_KEY = "dj8Pc_dxe2u4K8x9CzRj";
  static const String QB_DEFAULT_PASSWORD = "GWC@2022";

  static const String GROUP_ID = 'groupId';
  static const String QB_CURRENT_USERID = 'curr_userId';
  static const String GET_QB_SESSION = 'qb_session';
  static const String IS_QB_LOGIN = 'is_qb_login';


  static const String QB_USERNAME = 'qb_username';


  // ************** END **************************


  final String shipRocketBearer = "ShipToken";
  final String shipRocketEmail = "bhogesh@fembuddy.com";
  final String shipRocketPassword = "adithya7224";


  final String trackerVideoUrl = "tracker_meal_video";
  final String receipeVideoUrl = "recipe_meal_video";

  /// to getlocal dashboard data which used in notification screen
  static const String LOCAL_DASHBOARD_DATA = "local_dashboard_data";


  static const String isFirstTime = "isFirstTime";

  static const String isLogin = "login";
  static const String EVAL_STATUS = 'eval_status';
  static const String last_login = "last_login";
  static const String FCM_TOKEN = "fcm_token";
  static const String FCM_WEB_TOKEN = "fcm_web_token";
  static const String SHIPPING_ADDRESS = "ship_address";
  static const String userId = "userId";
  static const String User_Name = "userName";
  static const String USER_ID = "userId";
  static const String User_Profile ="userProfile";
  static const String User_Email ="user_email";
  static const String User_Number = "userNumber";
  static const String User_age = "userAge";
  static const String User_gender = "userGender";
  static const String User_height = "userHeight";
  static const String User_weight = "userWeight";

  ///user ticket
  static const String User_ticket_id = "UserTicketId";
  static const String User_ticket_isReplied = "UserTicketIsReplied";
  /// this is for making direct voice call to success team
  static const String KALEYRA_SUCCESS_ID = "kaleyra_success_id";
  static const String KALEYRA_ACCESS_TOKEN = "kaleyra_access_token";
  static const String KALEYRA_USER_ID = 'kaleyra_uid';

  static const String UV_SUCCESS_ID ="uv_success_id";
  static const String UV_API_ACCESS_TOKEN ="uv_api_access_token";
  static const String SUPPORT_NUMBER = "support_number";

  static const String KALEYRA_CHAT_SUCCESS_ID = 'kaleyra_chat_success_id';

  static const IS_ALL_USER_DATA_AVAILABLE = "is_all_user_data_available";



  static const String countryCode = "COUNTRY_CODE";
  static const String countryName = "COUNTRY_NAME";

  // *** firebase ***
  static const String notification_channelId = 'high_importance_channel';
  static const String notification_channelName = 'pushnotificationappchannel';

  static const String STORE_MEAL_DATA = 'meal_data';

  final String deviceId = "deviceId";
  final String registerOTP = "R_OTP";

  late String bearer = '';

  static String slotErrorText = "Slots Not Available Please select different day";
  static String networkErrorText = "No Internet. Please Check Your Network Connection";
  static String oopsMessage = "OOps ! Something went wrong.";

  static String numberNotFound = "Mobile Number not found";

  static const String isSmallMode = "isShrunk";

  String emptyStringMsg = 'Please mention atleast 2 characters';

  final String program_days = "no_of_days";

  static String appointmentId = "appoint_id";

  static String userDoctorId = "user_doctor_id";

  static String isPrepTrackerCompleted = "isPrepTrackerSubmitted";

  static String eval1 = "eval1";
  static String eval2 = "eval2";

  static String gutHealthTrackerZeroCount = 'gutHealthTrackerZeroCount';
  static String gutHealthTrackerOneCount = 'gutHealthTrackerOneCount';
  
  //---Razorpay secret keys -----------------

  static const KEY_ID = "rzp_test_mGdJGjZKpJswFa";
  static const SECRET_KEY = "A9AgMVJOVRe1199AiprO0n7u";

  // ------------------END ------------

  SharedPreferences? preferences;
  Future<String?> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }

  showSnackbar(BuildContext context, String message,{int? duration, bool? isError, SnackBarAction? action, double? bottomPadding}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:(isError == null || isError == false) ? gPrimaryColor : gsecondaryColor.withOpacity(0.55),
        content: Text(message),
        margin: (bottomPadding != null) ? EdgeInsets.only(bottom: bottomPadding) : null,
        duration: Duration(seconds: duration ?? 3),
        action: action,
      ),
    );
  }

  fixedSnackbar(BuildContext context, String message,String btnName, onPress, {Duration? duration, bool? isError}){
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor:(isError == null || isError == false) ? gPrimaryColor : Colors.redAccent,
        content: Text(message),
        actions: [
          TextButton(
              onPressed: onPress,
              child: Text(btnName)
          )
        ],
      ),
    );
  }

  showSheet(BuildContext context, Widget widget,
      {bool sheetForLogin = false,double? bottomSheetHeight,
        String? circleIcon, Color? topColor, bool isSheetCloseNeeded = false,
        VoidCallback? sheetCloseOnTap, bool isDismissible = false}){
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: isDismissible,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return (sheetForLogin)
              ? AnimatedPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 100),
            child: commonBottomSheetView(context, widget,
              bottomSheetHeight: bottomSheetHeight, circleIcon: circleIcon, topColor: topColor, sheetForLogin: true),
          )
              : commonBottomSheetView(context, widget,
            bottomSheetHeight: bottomSheetHeight, circleIcon: circleIcon, topColor: topColor, isSheetCloseNeeded: isSheetCloseNeeded,sheetCloseOnTap: sheetCloseOnTap
          );
        }
    );
  }

  commonBottomSheetView(BuildContext context, Widget widget,
      {bool sheetForLogin = false,double? bottomSheetHeight,
        String? circleIcon, Color? topColor,
        bool isSheetCloseNeeded = false, VoidCallback? sheetCloseOnTap}){
    return Container(
      decoration: const BoxDecoration(
        color: gBackgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22)
        ),
      ),
      padding: (sheetForLogin) ? null : EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: bottomSheetHeight ?? 50.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Container(
                height: 15.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: topColor ?? kBottomSheetHeadYellow,
                ),
                child: Center(
                  child: Image.asset(bsHeadStarsIcon,
                    alignment: Alignment.topRight,
                    fit: BoxFit.scaleDown,
                    width: 30.w,
                    height: 10.h,
                  ),
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: widget,
                ),
              )

            ],
          ),
          Positioned(
              top: 8.h,
              left: 5,
              right: 5,
              child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: gHintTextColor.withOpacity(0.8))
                    ],
                  ),
                  child: CircleAvatar(
                    maxRadius: 30.dp,
                    backgroundColor: kBottomSheetHeadCircleColor,
                    child: Image.asset(circleIcon ?? bsHeadBellIcon,
                      fit: BoxFit.scaleDown,
                      width: 45,
                      height: 45,
                    ),
                  )
              )
          ),
          Visibility(
            visible: isSheetCloseNeeded,
            child: Positioned(
              top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: sheetCloseOnTap ?? (){},
                    child: Icon(Icons.cancel_outlined, color: gsecondaryColor,size: 28,))),
          )
        ],
      ),
    );
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    print("hexString:  $hexString");
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    print("buffer.toString(): ${buffer.toString()} ");
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // List<ShipmentTrackActivities> trackingList = [
  //   ...trackJson.map((e) => ShipmentTrackActivities.fromJson(e))
  // ];

  /// dummy token
  String shipRocketToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjI5NTcyMzEsImlzcyI6Imh0dHBzOi8vYXBpdjIuc2hpcHJvY2tldC5pbi92MS9leHRlcm5hbC9hdXRoL2xvZ2luIiwiaWF0IjoxNjYzODQ2ODM2LCJleHAiOjE2NjQ3MTA4MzYsIm5iZiI6MTY2Mzg0NjgzNiwianRpIjoidVJHclM0dk83cm9IbllhNiJ9.meifEzRi4u4sAVceDvY-Pyy71TO0K3kYGxnrwtiAQNE';
}
