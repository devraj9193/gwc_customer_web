import 'package:flutter/material.dart';
import 'package:gwc_customer_web/screens/home_screens/gut_health_tracker_screens/stools_quality_screen.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class ParametersOfTracker extends StatefulWidget {
  const ParametersOfTracker({Key? key}) : super(key: key);

  @override
  State<ParametersOfTracker> createState() => _ParametersOfTrackerState();
}

class _ParametersOfTrackerState extends State<ParametersOfTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 25.h,
            child: const Image(
              image: AssetImage(
                  "assets/images/gut_health_tracker/Group 76912.png"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: 1.h, top: 1.h),
            child: buildAppBar(
              () {
                Navigator.pop(context);
              },
              showNotificationIcon: false,
              isBackEnable: true,
              showLogo: false,
              showChild: true,
              child: Text(
                "Gut Health Tracker",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: eUser().threeBounceIndicatorColor,
                  fontFamily: eUser().mainHeadingFont,
                  fontSize: eUser().mainHeadingFontSize,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.h, left: 10.w),
                child: Text(
                  "Parameters of your Gut Health Tracker",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: eUser().mainHeadingColor,
                    fontFamily: eUser().userFieldLabelFont,
                    fontSize: eUser().buttonTextSize,
                  ),
                ),
              ),
              Expanded(
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 30,
                    crossAxisCount: 2,
                    mainAxisExtent: 20.h,
                    // childAspectRatio: MediaQuery.of(context).size.width /
                    //     (MediaQuery.of(context).size.height / 1.4),
                  ),
                  children: [
                    Column(
                      children: [
                        const Image(
                          image: AssetImage(
                              "assets/images/gut_health_tracker/Group 76917.png"),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Stools Quality",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().userTextFieldHintFontSize,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Image(
                          image: AssetImage(
                              "assets/images/gut_health_tracker/Group 76914.png"),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Hunger Quality",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().userTextFieldHintFontSize,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Image(
                          image: AssetImage(
                              "assets/images/gut_health_tracker/Group 76915.png"),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Saliva Quality",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().userTextFieldHintFontSize,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Image(
                          image: AssetImage(
                              "assets/images/gut_health_tracker/Group 76913.png"),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Sweat Quality",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().userTextFieldHintFontSize,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Image(
                          image: AssetImage(
                              "assets/images/gut_health_tracker/Group 76916.png"),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Urine Quality",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().userTextFieldHintFontSize,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const StoolsQualityScreen();
                            },
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 6.h,top: 0.h),
                        decoration: BoxDecoration(
                          color: kNumberCircleRed,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: gGreyColor.withOpacity(0.5),
                              offset: const Offset(2, 5),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: gWhiteColor, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: kNumberCircleRed,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Start Now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: eUser().threeBounceIndicatorColor,
                                fontFamily: eUser().userFieldLabelFont,
                                fontSize: eUser().userTextFieldFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(bottom: 0,right: 0,
            child: SizedBox(
              height: 20.h,
              child: const Image(
                image: AssetImage(
                    "assets/images/gut_health_tracker/Path 251416.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
