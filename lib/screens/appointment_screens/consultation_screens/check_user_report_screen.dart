/*
we r showing this screen when dashboard api
consultation stage is check_user_reports
 */

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';

class CheckUserReportsScreen extends StatelessWidget {
  const CheckUserReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 4.w,
          right: 4.w,
          top: 4.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(() {
              Navigator.pop(context);
            }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80.w,
                  height: 40.h,
                  child: Image.asset("assets/images/chk_user_report.png",),
                ),
                Text("Reports Uploaded,\nawaiting your doctor response\nPlease Allow 24 Hours",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: kFontBold,
                      color: gTextColor
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Center(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40.w,
                        height: 5.h,
                        padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: eUser().buttonColor,
                          borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                          // border: Border.all(
                          //     color: eUser().buttonBorderColor,
                          //     width: eUser().buttonBorderWidth
                          // ),
                        ),
                        child: Center(child: Text(
                          'Got It',
                          style: TextStyle(
                            fontFamily: eUser().buttonTextFont,
                            color: eUser().buttonTextColor,
                            fontSize: eUser().buttonTextSize,
                          ),
                        )),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
