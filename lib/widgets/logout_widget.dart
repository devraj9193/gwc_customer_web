import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/gut_list_screens/new_stages_data.dart';
import '../screens/user_registration/existing_user.dart';
import '../utils/app_config.dart';
import 'constants.dart';

class LogoutWidget extends StatefulWidget {
  const LogoutWidget({Key? key}) : super(key: key);

  @override
  State<LogoutWidget> createState() => _LogoutWidgetState();
}

class _LogoutWidgetState extends State<LogoutWidget> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (_, setstate) {
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
          SizedBox(height: 5.h),
          Row(
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
            ],
          ),
          SizedBox(height: 1.h)
        ],
      );
    });
  }

  void logOut() async {
    clearAllUserDetails();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const ExistingUser(),
    ));
  }

  final SharedPreferences _pref = AppConfig().preferences!;

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
}
