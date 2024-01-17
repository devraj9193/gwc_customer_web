import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import '../../../widgets/constants.dart';

class TrackingPopUpScreen extends StatefulWidget {
  const TrackingPopUpScreen({Key? key}) : super(key: key);

  @override
  State<TrackingPopUpScreen> createState() => _TrackingPopUpScreenState();
}

class _TrackingPopUpScreenState extends State<TrackingPopUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
      MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.95),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: gWhiteColor,
          appBar: AppBar(
            backgroundColor: gWhiteColor,
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kit Delivered!",
                  style: TextStyle(
                    fontFamily: kFontBold,
                    color: gBlackColor,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Your kit from Gut Wellness Club has been delivered.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gBlackColor,
                    fontSize: 12.sp,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: const Image(
                    image: AssetImage("assets/images/Shipping.gif"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
                  child: Text(
                    "Your program is initiated one day after you start your program in the app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 11.sp,
                      fontFamily: kFontBook,
                      color: gBlackColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
                  child: Text(
                    "Ex. If you start your program now, the next calender day is counted as day 1.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 11.sp,
                      fontFamily: kFontBook,
                      color: gBlackColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
                  child: Text(
                    "Feel free to explore the details of your program prior ☺️",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 11.sp,
                      fontFamily: kFontBook,
                      color: gBlackColor,
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 3.w),
                //   child:  RichText(
                //     textAlign: TextAlign.center,
                //     text: TextSpan(
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: 'Your program is initiated one day after you start your program in the app.',
                //           style: TextStyle(
                //             height: 1.5,
                //             fontSize: 11.sp,
                //             fontFamily: kFontBook,
                //             color: gBlackColor,
                //           ),
                //         ),
                //         TextSpan(
                //           text: "Cook Kit",
                //           style: TextStyle(
                //             height: 1.5,
                //             fontSize: 12.sp,
                //             fontFamily: kFontBold,
                //             color: gBlackColor,
                //           ),
                //         ),
                //         TextSpan(
                //           text: ' will be delivered within',
                //           style: TextStyle(
                //             height: 1.5,
                //             fontSize: 12.sp,
                //             fontFamily: kFontBook,
                //             color: gBlackColor,
                //           ),
                //         ),
                //         TextSpan(
                //           text: " 30 minutes ",
                //           style: TextStyle(
                //             height: 1.5,
                //             fontSize: 12.sp,
                //             fontFamily: kFontBold,
                //             color: gBlackColor,
                //           ),
                //         ),
                //         TextSpan(
                //           text: 'approx..!',
                //           style: TextStyle(
                //             height: 1.5,
                //             fontSize: 12.sp,
                //             fontFamily: kFontBook,
                //             color: gBlackColor,
                //           ),
                //         ),
                //
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 2.h),
                // Center(
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 3.w),
                //     child:  RichText(
                //       textAlign: TextAlign.center,
                //       text: TextSpan(
                //         children: <TextSpan>[
                //           TextSpan(
                //             text: 'Items will be delivered of ',
                //             style: TextStyle(
                //               height: 1.5,
                //               fontSize: 11.sp,
                //               fontFamily: kFontBook,
                //               color: gBlackColor,
                //             ),
                //           ),
                //           TextSpan(
                //             text: "ABC Road.NY.",
                //             style: TextStyle(
                //               height: 1.5,
                //               fontSize: 11.sp,
                //               fontFamily: kFontBold,
                //               color: gBlackColor,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
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
                            'Okay, Got it',
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
