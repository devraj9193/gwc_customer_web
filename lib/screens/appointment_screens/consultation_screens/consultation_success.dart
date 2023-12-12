/*
we r using this screen in old ui's
 */

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class ConsultationSuccess extends StatelessWidget {
  final bool isPostProgramSuccess;
  const ConsultationSuccess({Key? key, this.isPostProgramSuccess = false}) : super(key: key);

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

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage("assets/images/consultation_completed.png"),
                    height: 40.h,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    !isPostProgramSuccess
                        ? "Congratulations, your consultation has been completed successfully!"
                        : "Post Program Consultation Done.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.5,
                        fontFamily: kFontBold,
                        color: gTextColor,
                        fontSize: 12.sp
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    !isPostProgramSuccess
                        ? "Your medical report is currently being prepared and will be available for online access within the next 24 hours"
                        : "Gut Maintenance Guide and Meal Plans will be Uploaded soon.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.5,
                        fontFamily: kFontBook,
                        color: gTextColor,
                        fontSize: 10.sp
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
}
