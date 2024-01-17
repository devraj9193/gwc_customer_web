import 'package:circular_progress_bar_with_lines/circular_progress_bar_with_lines.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CommonWidgets extends StatefulWidget {
  final String points;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String comments;
  const CommonWidgets(
      {Key? key,
      required this.points,
      required this.value1,
      required this.value2,
      required this.value3,
      required this.value4,
      required this.comments})
      : super(key: key);

  @override
  State<CommonWidgets> createState() => _CommonWidgetsState();
}

class _CommonWidgetsState extends State<CommonWidgets> {
  final double _percent = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reward Points",
          style: TextStyle(
              fontFamily: "GothamBold", color: gMainColor, fontSize: 10.sp),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: 5.w, left: 2.w, top: 2.h, bottom: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressBarWithLines(
                radius: 60,
                linesLength: 6,
                linesWidth: 3,
                linesColor: (widget.points == '1') ? gPrimaryColor : gHintTextColor,
                percent: _percent,
                centerWidgetBuilder: (context) => Text(
                  '${widget.points}Pts',
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    color: gMainColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "${widget.value1} ",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "GothamBook",
                              color: Colors.lightBlue,
                            ),
                          ),
                          TextSpan(
                            text: "Lorem Ipsum",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "GothamBook",
                              color: gTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "${widget.value2} ",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "GothamBook",
                              color: Colors.lightBlue,
                            ),
                          ),
                          TextSpan(
                            text: "Lorem Ipsum",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "GothamBook",
                              color: gTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "${widget.value3} ",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "GothamBook",
                              color: Colors.lightBlue,
                            ),
                          ),
                          TextSpan(
                            text: "Lorem Ipsum",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "GothamBook",
                              color: gTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "${widget.value4} ",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "GothamBook",
                              color: Colors.lightBlue,
                            ),
                          ),
                          TextSpan(
                            text: "Lorem Ipsum",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "GothamBook",
                              color: gTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Text(
          widget.comments,
          style: TextStyle(
            fontSize: 9.sp,
            height: 1.5,
            fontFamily: "GothamBook",
            color: gTextColor,
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
