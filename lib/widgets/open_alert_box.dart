import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'constants.dart';

openAlertBox({
  required BuildContext context,
  bool titleNeeded = false,
  String? title,
  String? content,
  bool isSingleButton = false,
  bool isContentNeeded = true,
  String? negativeButtonName,
  required String positiveButtonName,
  VoidCallback? negativeButton,
  required VoidCallback positiveButton,
  bool barrierDismissible = true
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
         // backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.dp))),
          contentPadding: EdgeInsets.only(top: 1.h),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
                color: gWhiteColor, borderRadius: BorderRadius.circular(8)),
            width: 50.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(
                  visible: titleNeeded,
                  child: Text(
                    title ?? 'Are you sure?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: kFontBold,
                        color: gsecondaryColor,
                        fontSize: 11.dp),
                  ),
                ),
                Visibility(
                  visible: titleNeeded,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    height: 1,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                Visibility(
                  visible: isContentNeeded,
                  child: Text(
                    content ?? 'Do you want to exit an App?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gBlackColor,
                        fontSize: 11.dp),
                  ),
                ),
                Visibility(
                    visible: isContentNeeded,
                    child: SizedBox(height: 3.h)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isSingleButton,
                      child: GestureDetector(
                        onTap: negativeButton ?? () => Navigator.of(context).pop(false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 5.w),
                          decoration: BoxDecoration(
                              color: gHintTextColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            negativeButtonName ?? "NO",
                            style: TextStyle(
                              fontFamily: kFontMedium,
                              color: gWhiteColor,
                              fontSize: 11.dp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: !isSingleButton,
                        child: SizedBox(width: 5.w)),
                    GestureDetector(
                      onTap: positiveButton ?? () => SystemNavigator.pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: gsecondaryColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          positiveButtonName ?? "YES",
                          style: TextStyle(
                            fontFamily: kFontMedium,
                            color: gWhiteColor,
                            fontSize: 11.dp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 1.h)
              ],
            ),
          ),
        ),
      ));
}

openProgressDialog(BuildContext context, {bool willPop = false}){
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  AlertDialog alert = AlertDialog(

    backgroundColor: Colors.transparent,
    elevation: 0,
    contentPadding: EdgeInsets.zero,
    insetPadding: EdgeInsets.symmetric(horizontal: 100),
    content: buildCircularIndicator(),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: gHintTextColor.withOpacity(0.1),
    builder: (BuildContext context) {
      return WillPopScope(child: alert,
        onWillPop: () async => willPop,
      );
    },
  );
}