import 'package:flutter/material.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/constants.dart';
import '../appointment_screens/doctor_calender_time_screen.dart';

class PpcPopUpScreen extends StatefulWidget {
  const PpcPopUpScreen({Key? key}) : super(key: key);

  @override
  State<PpcPopUpScreen> createState() => _PpcPopUpScreenState();
}

class _PpcPopUpScreenState extends State<PpcPopUpScreen> {
  @override
  Widget build(BuildContext context) {
    return
      MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.95),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: gWhiteColor,
          appBar: AppBar(
            backgroundColor: gWhiteColor,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 6.h,

              child: const Image(
                image: AssetImage("assets/images/Gut welness logo.png"),
              ),
              //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
            ),
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: gBlackColor,
                  size: 3.h,
                ),
              ),
              SizedBox(width: 5.w),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppointmentDetails(),
                SizedBox(height: 4.h),
                Center(
                  child: GestureDetector(
                    // onTap: (showLoginProgress) ? null : () {
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                            builder: (context) => const DoctorCalenderTimeScreen(
                              isPostProgram: true,
                            )
                          // PostProgramScreen(postProgramStage: postProgramStage,),
                        ),
                      );
                    },
                    child: IntrinsicWidth(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: kNumberCircleRed,
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //     color: eUser().buttonBorderColor,
                          //     width: eUser().buttonBorderWidth
                          // ),
                        ),
                        child: Center(
                          child: Text(
                            'Book Now',
                            style: TextStyle(
                              fontFamily: eUser().buttonTextFont,
                              color: gWhiteColor,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                // Expanded(
                //   child: buildUserDetails(context),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildAppointmentDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 4.h),
          //   child: const Image(
          //     image: AssetImage("assets/images/consultation_completed.png"),
          //   ),
          // ),SizedBox(height: 2.h),
          // Text(
          //   "Book Your Post Program Consultation",
          //   style: TextStyle(
          //     fontFamily: kFontBold,
          //     color: gBlackColor,
          //     fontSize: 15.sp,
          //   ),
          // ),
          // SizedBox(height: 1.h),
          // Text(
          //   "Your next critical step is your review consultation with your doctor.",
          //   textAlign: TextAlign.start,
          //   style: TextStyle(
          //     fontFamily: kFontMedium,
          //     color: gBlackColor,
          //     fontSize: 11.sp,
          //   ),
          // ),
          // SizedBox(height: 1.h),
          // Text(
          //   "Please book your consultation at the earliest below.",
          //   textAlign: TextAlign.start,
          //   style: TextStyle(
          //     fontFamily: kFontMedium,
          //     color: gBlackColor,
          //     fontSize: 11.sp,
          //   ),
          // ),
        ],
      ),
    );
  }

  buildUserDetails(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 45.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: DecorationImage(
                    image:
                        AssetImage("assets/images/consultation_completed.png"),
                    fit: BoxFit.scaleDown),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 0,
            right: 0,
            child: Container(
              height: 66.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    // Text(
                    //   "Consultation History",
                    //   style: TextStyle(
                    //     color: gBlackColor,
                    //     fontFamily: kFontBold,
                    //     fontSize: 13.sp,
                    //   ),
                    // ),
                    // SizedBox(height: 6.h),
                    Text(
                      "About",
                      style: TextStyle(
                        color: gBlackColor,
                        fontFamily: kFontBold,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Center(
                      child: Text(
                        "",
                        style: TextStyle(
                            color: gBlackColor,
                            fontFamily: kFontBook,
                            fontSize: 10.sp,
                            height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "Consultation Date & Time",
                      style: TextStyle(
                          color: gBlackColor,
                          fontFamily: kFontBold,
                          fontSize: 12.sp,
                          height: 1.5),
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/new_ds/history_timer.png",
                          width: 15.sp,
                          height: 15.sp,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "consultationDateAndTime",
                          style: TextStyle(
                              color: gBlackColor,
                              fontFamily: kFontBook,
                              fontSize: 10.sp,
                              height: 1.5),
                        )
                      ],
                    ),
                    Center(
                      child: Text(
                        "Your doctor is analysing your case. Check back in a few hours for an update.",
                        style: TextStyle(
                            color: gBlackColor,
                            fontFamily: kFontBook,
                            fontSize: 10.sp,
                            height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        // onTap: (showLoginProgress) ? null : () {
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: IntrinsicWidth(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: kNumberCircleRed,
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(
                              //     color: eUser().buttonBorderColor,
                              //     width: eUser().buttonBorderWidth
                              // ),
                            ),
                            child: Center(
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  fontFamily: eUser().buttonTextFont,
                                  color: gWhiteColor,
                                  fontSize: eUser().buttonTextSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // center card widget
          Positioned(
            top: 36.h,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: 8.h,
              // padding:
              //     EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: gSitBackBgColor,
                boxShadow: [
                  BoxShadow(
                    color: kLineColor.withOpacity(0.5),
                    offset: const Offset(2, 5),
                    blurRadius: 5,
                  )
                ],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "doctorName",
                    style: TextStyle(
                      color: gBlackColor,
                      fontFamily: kFontBold,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    "designation",
                    style: TextStyle(
                      color: gTextColor,
                      height: 1.3,
                      fontFamily: kFontBook,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget showNameWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(8, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Image(
            image: const AssetImage("assets/images/Group 3776.png"),
            height: 8.h,
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              "My Evaluation",
              style: TextStyle(
                  fontFamily: kFontMedium, color: gTextColor, fontSize: 12.sp),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_sharp,
            color: gMainColor,
            size: 2.h,
          )
        ],
      ),
    );
  }
}
