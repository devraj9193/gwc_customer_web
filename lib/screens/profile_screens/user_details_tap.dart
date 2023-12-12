/*
in this ui we r showing profile, my reports, evaluation and feed back in
same screen using tabbar

Now this screen was not using
 */

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/screens/evalution_form/evaluation_get_details.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../appointment_screens/consultation_screens/upload_files.dart';
import '../evalution_form/evaluation_form_screen.dart';
import '../evalution_form/personal_details_screen.dart';
import 'feedback_rating_screen.dart';
import 'my_profile_details.dart';

class UserDetailsTap extends StatefulWidget {
  const UserDetailsTap({Key? key}) : super(key: key);

  @override
  State<UserDetailsTap> createState() => _UserDetailsTapState();
}

class _UserDetailsTapState extends State<UserDetailsTap> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                //  SizedBox(height: 1.h),

                TabBar(
                    // padding: EdgeInsets.symmetric(horizontal: 3.w),
                    labelColor: gBlackColor,
                    unselectedLabelColor: gHintTextColor,
                    isScrollable: true,
                    indicatorColor: gsecondaryColor,
                    labelPadding:
                        EdgeInsets.only(right: 6.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 5.w),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: "GothamBook",
                        color: gHintTextColor,
                        fontSize: 9.sp),
                    labelStyle: TextStyle(
                        fontFamily: "GothamMedium",
                        color: gBlackColor,
                        fontSize: 11.sp),
                    tabs: const [
                      Text('My Profile'),
                      Text("My Evaluation"),
                      Text('My Reports'),
                      Text('FeedBack'),
                    ]),
                Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const MyProfileDetails(),
                        const EvaluationGetDetails(isFromProfile: true,),
                        UploadFiles(
                          isFromSettings: true,
                        ),
                        const FeedbackRatingScreen(),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
