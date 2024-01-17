import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../../evalution_form/check_box_settings.dart';
import 'gut_health_tracker.dart';

class UrineQualityScreen extends StatefulWidget {
  const UrineQualityScreen({Key? key}) : super(key: key);

  @override
  State<UrineQualityScreen> createState() => _UrineQualityScreenState();
}

class _UrineQualityScreenState extends State<UrineQualityScreen> {

  int selectedQue1 = -1;
  int selectedQue2 = -1;
  int selectedQue3 = -1;
  int selectedQue4 = -1;
  int selectedQue5 = -1;

  int healthy = 0 , unhealthy = 0 ;
  String overall = '0',total = '0';

  bool isSyncing = false;

  final peeCheckBox = [
    CheckBoxSettings(
        title: "The same number of times and at a similar time everyday (H)"),
    CheckBoxSettings(
        title:
            "Recently, there has been changes in the number of times I pee and it concerns me"),
  ];

  List<String> selectedPee = [];

  final iPeeCheckBox = [
    CheckBoxSettings(title: "Easily"),
    CheckBoxSettings(
        title:
            "With some difficulty / Pain / burning sensation / Urgency etc.,"),
  ];

  List<String> selectedIPee = [];

  final myPeeColorCheckBox = [
    CheckBoxSettings(title: "Clear"),
    CheckBoxSettings(title: "Yellowish to amber"),
    CheckBoxSettings(title: "Red / Pink"),
    CheckBoxSettings(title: "Orange"),
    CheckBoxSettings(title: "Blue / Green"),
    CheckBoxSettings(title: "Dark Brown"),
    CheckBoxSettings(title: "Cloudy"),
    CheckBoxSettings(title: "Black"),
  ];

  List<String> selectedMyPeeColor = [];

  final myPeeCheckBox = [
    CheckBoxSettings(title: "Has mild smell"),
    CheckBoxSettings(
        title: "Strong odour / sweet or fruity odour / offensive odour etc.,"),
  ];

  List<String> selectedMyPee = [];

  final afterPeeCheckBox = [
    CheckBoxSettings(
        title:
            "I do not have another urge / do not feel like going back to the toilet again"),
    CheckBoxSettings(
        title:
            "I have another urge / feel like going back to the toilet again"),
  ];

  List<String> selectedAfterPee = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            buildStools(),
            Positioned(
              top: 0,
              right: 0,
              child: Image(
                height: 15.h,
                image: const AssetImage(
                    "assets/images/gut_health_tracker/Group 76927.png"),
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
                showLogo: true,
                showChild: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildStools() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12.h, left: 5.w, right: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "I pee:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: eUser().mainHeadingColor,
                          fontFamily: eUser().userFieldLabelFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      ...peeCheckBox.map((e) => buildPeeCheckBox(e)).toList(),
                      const Divider(
                        color: kLineColor,
                        thickness: 1,
                      ),
                      Text(
                        "I pee:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: eUser().mainHeadingColor,
                          fontFamily: eUser().userFieldLabelFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      ...iPeeCheckBox.map((e) => buildIPeeCheckBox(e)).toList(),
                      const Divider(
                        color: kLineColor,
                        thickness: 1,
                      ),
                      Text(
                        "My pee color is:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: eUser().mainHeadingColor,
                          fontFamily: eUser().userFieldLabelFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      ...myPeeColorCheckBox
                          .map((e) => buildMyPeeColorCheckBox(e))
                          .toList(),
                      const Divider(
                        color: kLineColor,
                        thickness: 1,
                      ),
                      Text(
                        "My pee :",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: eUser().mainHeadingColor,
                          fontFamily: eUser().userFieldLabelFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      ...myPeeCheckBox
                          .map((e) => buildMyPeeCheckBox(e))
                          .toList(),
                      const Divider(
                        color: kLineColor,
                        thickness: 1,
                      ),
                      Text(
                        "After I pee :",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: eUser().mainHeadingColor,
                          fontFamily: eUser().userFieldLabelFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      ...afterPeeCheckBox
                          .map((e) => buildAfterPeeCheckBox(e))
                          .toList(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showResultUrinePopUp();
                  },
                  child: Center(
                    child: IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 10.w),
                        margin: EdgeInsets.only(top: 5.h),
                        decoration: BoxDecoration(
                          color: kNumberCircleRed,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: gGreyColor.withOpacity(0.5),
                              offset: const Offset(4, 5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: eUser().threeBounceIndicatorColor,
                              fontFamily: eUser().userFieldLabelFont,
                              fontSize: eUser().mainHeadingFontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage(
                        "assets/images/gut_health_tracker/Mask Group 4.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildPeeCheckBox(CheckBoxSettings peeCheckBox) {
    return StatefulBuilder(builder: (_, setstate) {
      return IntrinsicWidth(
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
          title: Transform.translate(
            offset: const Offset(-10, 0),
            child: Text(
              peeCheckBox.title.toString(),
              style: buildTextStyle(
                  color:
                      peeCheckBox.value == true ? kTextColor : gHintTextColor,
                  fontFamily:
                      peeCheckBox.value == true ? kFontMedium : kFontBook),
            ),
          ),
          dense: true,
          activeColor: kPrimaryColor,
          value: peeCheckBox.value,
          onChanged: (v) {
            setstate(() {
              if (v == true) {
                selectedPee.add(peeCheckBox.title!);
                peeCheckBox.value = v;
                print(selectedPee);
              } else {
                selectedPee.remove(peeCheckBox.title!);
                peeCheckBox.value = v;
              }
            });
          },
        ),
      );
    });
  }

  buildIPeeCheckBox(CheckBoxSettings iPeeCheckBox) {
    return StatefulBuilder(builder: (_, setstate) {
      return IntrinsicWidth(
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
          title: Transform.translate(
            offset: const Offset(-10, 0),
            child: Text(
              iPeeCheckBox.title.toString(),
              style: buildTextStyle(
                  color:
                      iPeeCheckBox.value == true ? kTextColor : gHintTextColor,
                  fontFamily:
                      iPeeCheckBox.value == true ? kFontMedium : kFontBook),
            ),
          ),
          dense: true,
          activeColor: kPrimaryColor,
          value: iPeeCheckBox.value,
          onChanged: (v) {
            setstate(() {
              if (v == true) {
                selectedIPee.add(iPeeCheckBox.title!);
                iPeeCheckBox.value = v;
                print(selectedIPee);
              } else {
                selectedIPee.remove(iPeeCheckBox.title!);
                iPeeCheckBox.value = v;
              }
            });
          },
        ),
      );
    });
  }

  buildMyPeeColorCheckBox(CheckBoxSettings myPeeColorCheckBox) {
    return StatefulBuilder(builder: (_, setstate) {
      return IntrinsicWidth(
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
          title: Transform.translate(
            offset: const Offset(-10, 0),
            child: Text(
              myPeeColorCheckBox.title.toString(),
              style: buildTextStyle(
                  color: myPeeColorCheckBox.value == true
                      ? kTextColor
                      : gHintTextColor,
                  fontFamily: myPeeColorCheckBox.value == true
                      ? kFontMedium
                      : kFontBook),
            ),
          ),
          dense: true,
          activeColor: kPrimaryColor,
          value: myPeeColorCheckBox.value,
          onChanged: (v) {
            setstate(() {
              if (v == true) {
                selectedMyPeeColor.add(myPeeColorCheckBox.title!);
                myPeeColorCheckBox.value = v;
                print(selectedMyPeeColor);
              } else {
                selectedMyPeeColor.remove(myPeeColorCheckBox.title!);
                myPeeColorCheckBox.value = v;
              }
            });
          },
        ),
      );
    });
  }

  buildMyPeeCheckBox(CheckBoxSettings myPeeCheckBox) {
    return StatefulBuilder(builder: (_, setstate) {
      return IntrinsicWidth(
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
          title: Transform.translate(
            offset: const Offset(-10, 0),
            child: Text(
              myPeeCheckBox.title.toString(),
              style: buildTextStyle(
                  color:
                      myPeeCheckBox.value == true ? kTextColor : gHintTextColor,
                  fontFamily:
                      myPeeCheckBox.value == true ? kFontMedium : kFontBook),
            ),
          ),
          dense: true,
          activeColor: kPrimaryColor,
          value: myPeeCheckBox.value,
          onChanged: (v) {
            setstate(() {
              if (v == true) {
                selectedMyPee.add(myPeeCheckBox.title!);
                myPeeCheckBox.value = v;
                print(selectedMyPee);
              } else {
                selectedMyPee.remove(myPeeCheckBox.title!);
                myPeeCheckBox.value = v;
              }
            });
          },
        ),
      );
    });
  }

  buildAfterPeeCheckBox(CheckBoxSettings afterPeeCheckBox) {
    return StatefulBuilder(builder: (_, setstate) {
      return IntrinsicWidth(
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
          title: Transform.translate(
            offset: const Offset(-10, 0),
            child: Text(
              afterPeeCheckBox.title.toString(),
              style: buildTextStyle(
                  color: afterPeeCheckBox.value == true
                      ? kTextColor
                      : gHintTextColor,
                  fontFamily:
                      afterPeeCheckBox.value == true ? kFontMedium : kFontBook),
            ),
          ),
          dense: true,
          activeColor: kPrimaryColor,
          value: afterPeeCheckBox.value,
          onChanged: (v) {
            setstate(() {
              if (v == true) {
                selectedAfterPee.add(afterPeeCheckBox.title!);
                afterPeeCheckBox.value = v;
                print(selectedAfterPee);
              } else {
                selectedAfterPee.remove(afterPeeCheckBox.title!);
                afterPeeCheckBox.value = v;
              }
            });
          },
        ),
      );
    });
  }

  showResultUrinePopUp() {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return AnimatedPadding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 100),
            child: Container(
              decoration: const BoxDecoration(
                color: gBackgroundColor,
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: 80.h,
              child: Stack(
                children: [
                  const Image(
                    image: AssetImage(
                        "assets/images/gut_health_tracker/Mask Group 3.png"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      Stack(
                        children: [
                          Container(
                            height: 2.5.h,
                            margin:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 4.h),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  gsecondaryColor,
                                  gsecondaryColor,
                                  gBackgroundColor,
                                  gBackgroundColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: gGreyColor.withOpacity(0.5),
                                  offset: const Offset(4, 5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: Text(
                                  "Urine",
                                  style: TextStyle(
                                    fontFamily: kFontBook,
                                    color: gHintTextColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            left: 28.w,
                            child: Image(
                              height: 5.h,
                              image:const AssetImage(
                                  "assets/images/gut_health_tracker/Group 6207.png"),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            right: 28.w,
                            child: Image(
                              height: 5.h,
                              image:const AssetImage(
                                  "assets/images/gut_health_tracker/Group 6208.png"),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            height: 1.5,
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Icon(
                                Icons.circle_sharp,
                                color: kNumberCircleRed,
                                size: 1.5.h,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                "Lorem ipsum dolor sit amet, consetetur",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  height: 1.5,
                                  color: eUser().mainHeadingColor,
                                  fontFamily: eUser().userFieldLabelFont,
                                  fontSize: eUser().buttonTextSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Icon(
                                Icons.circle_sharp,
                                color: kNumberCircleRed,
                                size: 1.5.h,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                "Lorem ipsum dolor sit amet, consetetur",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  height: 1.5,
                                  color: eUser().mainHeadingColor,
                                  fontFamily: eUser().userFieldLabelFont,
                                  fontSize: eUser().buttonTextSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Icon(
                                Icons.circle_sharp,
                                color: kNumberCircleRed,
                                size: 1.5.h,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                "Lorem ipsum dolor sit amet, consetetur",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  height: 1.5,
                                  color: eUser().mainHeadingColor,
                                  fontFamily: eUser().userFieldLabelFont,
                                  fontSize: eUser().buttonTextSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const GutHealthTracker();
                              },
                            ),
                          );
                        },
                        child: Center(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 10.w),
                              margin: EdgeInsets.only(top: 5.h),
                              decoration: BoxDecoration(
                                color: kNumberCircleRed,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: gGreyColor.withOpacity(0.5),
                                    offset: const Offset(4, 5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Got It',
                                  style: TextStyle(
                                    color: eUser().threeBounceIndicatorColor,
                                    fontFamily: eUser().userFieldLabelFont,
                                    fontSize: eUser().mainHeadingFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                   Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image(
                      height: 15.h,
                      image:const AssetImage(
                          "assets/images/gut_health_tracker/Mask Group 5.png"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
