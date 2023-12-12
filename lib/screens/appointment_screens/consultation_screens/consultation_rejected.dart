/*
In the new dashboard screen design we r not showing this screen.

if we need to show image with error text we can reuse this ui
 */

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class ConsultationRejected extends StatelessWidget {
  final String reason;
  const ConsultationRejected({Key? key, required this.reason}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 1.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),

              Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image(
                          image: const AssetImage(
                              "assets/images/rejected.png"),
                          height: 13.h,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Flexible(
                        child: Text(
                          "Your consultation has been rejected\nOur success Team will get back to you soon ",
                              // "Your Medical Report is getting ready and will be uploaded within 24 hours",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.5,
                              fontFamily: kFontBold,
                              color: gTextColor,
                              fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        this.reason ?? "hkkbft",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.5,
                            fontFamily: kFontMedium,
                            color: gTextColor,
                            fontSize: 10.sp),
                      ),
                      SizedBox(height: 2.h),

                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
