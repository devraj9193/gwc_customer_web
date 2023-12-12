import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../widgets/constants.dart';

class ResultPage extends StatelessWidget {
  ResultPage({
    Key? key,
    required this.result,
    required this.bmi,
    required this.comment,
    required this.bmr,
  }) : super(key: key);
  String result, bmi, comment, bmr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: Column(
        children: [
          Text(
            'Your BMI is',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: eUser().mainHeadingColor,
              fontFamily: eUser().mainHeadingFont,
              fontSize: eUser().mainHeadingFontSize,
            ),
          ),
          buildIndicator(),
          SizedBox(height: 1.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Your BMR is: ",
                  style: TextStyle(
                    color: eUser().mainHeadingColor,
                    fontFamily: eUser().userTextFieldFont,
                    fontSize: eUser().userFieldLabelFontSize,
                  ),
                ),
                TextSpan(
                  text: bmr,
                  style: TextStyle(
                    color: eUser().mainHeadingColor,
                    fontFamily: eUser().mainHeadingFont,
                    fontSize: eUser().mainHeadingFontSize,
                  ),
                ),
              ],
            ),
          ),
          // RichText(
          //   textAlign: TextAlign.center,
          //   text: TextSpan(
          //     children: <TextSpan>[
          //       TextSpan(
          //         text: bmi,
          //         style: TextStyle(
          //           color: eUser().mainHeadingColor,
          //           fontFamily: eUser().mainHeadingFont,
          //           fontSize: eUser().mainHeadingFontSize,
          //         ),
          //       ),
          //       TextSpan(
          //         text: " Kg/m\u00b2",
          //         style: TextStyle(
          //           color: eUser().userTextFieldColor,
          //           fontFamily: eUser().userTextFieldFont,
          //           fontSize: eUser().userFieldLabelFontSize,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 0.5.h),
          // Text(
          //   "($result)",
          //   style: TextStyle(
          //     color: eUser().userTextFieldColor,
          //     fontFamily: eUser().userTextFieldHintFont,
          //     fontSize: eUser().userFieldLabelFontSize,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Text(
              "A BMI of 18.5-24.9 indicates that you are at a healthy weight for your height. By maintaining a healthy weight, you lower your risk of developing serious health problems.",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.3,
                color: eUser().userFieldLabelColor,
                fontFamily: eUser().userTextFieldHintFont,
                fontSize: eUser().userFieldLabelFontSize,
              ),
            ),
          ),
          // Text(
          //   comment,
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 18,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }

  buildIndicator() {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: kBigCircleBorderRed.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Container(
        height: 25.h,
        decoration: BoxDecoration(
          color: gWhiteColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: gBlackColor.withOpacity(0.1),
              offset: const Offset(2, 5),
              blurRadius: 10,
            )
          ],
        ),
        child: SfRadialGauge(
          // backgroundColor: gWhiteColor,
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 10.0,
              maximum: 30.0,
              interval: 2,
              tickOffset: 5,
              showLabels: false,
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: 100,
                  rangeOffset: 0,
                  color: kNumberCircleAmber.withOpacity(0.6),
                ),
                // GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
                // GaugeRange(startValue: 100, endValue: 150, color: Colors.red),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: double.parse(bmi),
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "\n\n$bmi",
                            style: TextStyle(
                              color: eUser().mainHeadingColor,
                              fontFamily: eUser().mainHeadingFont,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                          TextSpan(
                            text: " Kg/m\u00b2",
                            style: TextStyle(
                              color: eUser().userTextFieldColor,
                              fontFamily: eUser().userTextFieldFont,
                              fontSize: eUser().userTextFieldHintFontSize,
                            ),
                          ),
                          TextSpan(
                            text: "\n($result)",
                            style: TextStyle(
                              color: eUser().userTextFieldColor,
                              fontFamily: eUser().userTextFieldHintFont,
                              fontSize: eUser().fieldSuffixTextFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.5)
              ],
            )
          ],
        ),
      ),
    );
  }
}
