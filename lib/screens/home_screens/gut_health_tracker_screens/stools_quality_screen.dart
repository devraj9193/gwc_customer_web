import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/screens/home_screens/gut_health_tracker_screens/saliva_quality_screen.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../model/error_model.dart';
import '../../../model/success_message_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/home_repo/home_repository.dart';
import '../../../services/home_service/home_service.dart';
import '../../../utils/SharedPreferenceUtil.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class StoolsQualityScreen extends StatefulWidget {
  const StoolsQualityScreen({Key? key}) : super(key: key);

  @override
  State<StoolsQualityScreen> createState() => _StoolsQualityScreenState();
}

class _StoolsQualityScreenState extends State<StoolsQualityScreen> {
  int selectedQue1 = -1;
  int selectedQue2 = -1;
  int selectedQue3 = -1;
  int selectedQue4 = -1;
  int selectedQue5 = -1;
  int selectedQue6 = -1;
  int selectedQue7 = -1;
  int selectedQue8 = -1;

  int healthy = 0, unhealthy = 0;

  int cat1Healthy = 0,
      cat2Healthy = 0,
      cat3Healthy = 0,
      cat4Healthy = 0,
      cat5Healthy = 0,
      cat6Healthy = 0;
  int cat1unHealthy = 0,
      cat2unHealthy = 0,
      cat3unHealthy = 0,
      cat4unHealthy = 0,
      cat5unHealthy = 0,
      cat6unHealthy = 0;

  String cat1ov = '0',
      cat2ov = '0',
      cat3ov = '0',
      cat4ov = '0',
      cat5ov = '0',
      cat6ov = '0';

  List<String> listHealthyValue = [];

  bool isSyncing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildStools(),
          const Image(
            image:
                AssetImage("assets/images/gut_health_tracker/Group 76918.png"),
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
                "How do I know if my Stools are \nHealthy?",
                textAlign: TextAlign.start,
                style: TextStyle(
                  height: 1.5,
                  color: eUser().mainHeadingColor,
                  fontFamily: eUser().userFieldLabelFont,
                  fontSize: eUser().buttonTextSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildHeadingText(String title) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: eUser().mainHeadingColor,
        fontFamily: eUser().userFieldLabelFont,
        fontSize: eUser().buttonTextSize,
      ),
    );
  }

  buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: const Divider(
        color: Color(0xffD1D1D1),
        height: 0.5,
        thickness: 0.5,
      ),
    );
  }

  buildPoopQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText('I poop :'),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'This same number of times and at a similar time everyday',
                style: buildTextStyle(
                    color: selectedQue1 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue1 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue1 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue1 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Recently, there has been changes in my bowel movements and it concerns me',
                style: buildTextStyle(
                    color: selectedQue1 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue1 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue1 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue1 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildPassMyPoopQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText('I pass my poop'),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Easily (like: I get the urge to poop and I easily poop when on the toilet seat)",
                style: buildTextStyle(
                    color: selectedQue2 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue2 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue2 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue2 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "With some difficulty / pain / burning sensation (like: I need to put some pressure on my tummy or contract my anus to pass my poop)",
                style: buildTextStyle(
                    color: selectedQue2 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue2 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue2 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue2 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildMyPoopColorQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText("My poop color is:"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Medium to light golden brown",
                style: buildTextStyle(
                    color: selectedQue3 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue3 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue3 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue3 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Green, red or purple in color on days when I eat certain foods like GLVs / Beets / Turnips",
                style: buildTextStyle(
                    color: selectedQue3 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue3 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue3 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue3 = 1;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "White, Pale, Yellow, Green, bright Red, Purple, Grey or Black in color irrespective of the food I eat",
                style: buildTextStyle(
                    color: selectedQue3 == 2 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue3 == 2 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue3 == 2 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue3 = 2;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildMyPoopMassIsQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText('My Poop mass is:'),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Smooth / soft / flows out into long shapes without being splashy (spreading much across anal zone / into commode)",
                style: buildTextStyle(
                    color: selectedQue4 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue4 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue4 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue4 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Hard / lumpy pieces / mushy / watery / pasty / sticky and difficult to clean of",
                style: buildTextStyle(
                    color: selectedQue4 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue4 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue4 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue4 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildMyPoopMassQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText('My poop mass:'),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'Floats on commode water',
                style: buildTextStyle(
                    color: selectedQue5 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue5 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue5 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue5 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Sinks in commode water",
                style: buildTextStyle(
                    color: selectedQue5 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue5 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue5 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue5 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildFartQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText("I Fart:"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Few seconds before / after I poop, with / without smell",
                style: buildTextStyle(
                    color: selectedQue6 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Along when I poop",
                style: buildTextStyle(
                    color: selectedQue6 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 1;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "There is a long gap between my fart and when I poop, with repulsive smell",
                style: buildTextStyle(
                    color: selectedQue6 == 2 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 2 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 2 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 2;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "frequently with repulsive smell, irrespective of the urge to defecate",
                style: buildTextStyle(
                    color: selectedQue6 == 3 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 3 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 3 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 3;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "I Never Fart",
                style: buildTextStyle(
                    color: selectedQue6 == 4 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue6 == 4 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue6 == 4 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue6 = 4;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildMyFartHasQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText("Usually, my fart has:"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                'No smell',
                style: buildTextStyle(
                    color: selectedQue7 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue7 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue7 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue7 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "Repulsive smell",
                style: buildTextStyle(
                    color: selectedQue7 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue7 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue7 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue7 = 1;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  buildAfterIPoopQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText("After I poop"),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "do not have another urge / do not feel like going back to the toilet again",
                style: buildTextStyle(
                    color: selectedQue8 == 0 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue8 == 0 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue8 == 0 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue8 = 0;
                });
              }
            },
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Transform.translate(
              offset: const Offset(-10, 0),
              child: Text(
                "I have another urge / feel like going back to the toilet again",
                style: buildTextStyle(
                    color: selectedQue8 == 1 ? kTextColor : gHintTextColor,
                    fontFamily: selectedQue8 == 1 ? kFontMedium : kFontBook),
              ),
            ),
            dense: true,
            activeColor: kPrimaryColor,
            value: selectedQue8 == 1 ? true : false,
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedQue8 = 1;
                });
              }
            },
          ),
        ],
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
                  padding: EdgeInsets.only(top: 16.h, left: 0.w, right: 0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildPoopQuestion(),
                      buildDivider(),
                      buildPassMyPoopQuestion(),
                      buildDivider(),
                      buildMyPoopColorQuestion(),
                      buildDivider(),
                      buildMyPoopMassIsQuestion(),
                      buildDivider(),
                      buildMyPoopMassQuestion(),
                      buildDivider(),
                      buildFartQuestion(),
                      buildDivider(),
                      buildMyFartHasQuestion(),
                      buildDivider(),
                      buildAfterIPoopQuestion(),
                      // Text(
                      //   "I pass my poop",
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //     color: eUser().mainHeadingColor,
                      //     fontFamily: eUser().userFieldLabelFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      // ...passMyPoopCheckBox
                      //     .map((e) => buildPassMyPoopCheckBox(e))
                      //     .toList(),
                      // const Divider(
                      //   color: kLineColor,
                      //   thickness: 1,
                      // ),
                      // Text(
                      //   "My poop color is:",
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //     color: eUser().mainHeadingColor,
                      //     fontFamily: eUser().userFieldLabelFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      // ...myPoopColorCheckBox
                      //     .map((e) => buildMyPoopColorCheckBox(e))
                      //     .toList(),
                      // const Divider(
                      //   color: kLineColor,
                      //   thickness: 1,
                      // ),
                      // Text(
                      //   "My Poop mass is:",
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //     color: eUser().mainHeadingColor,
                      //     fontFamily: eUser().userFieldLabelFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      // ...myPoopMassIsCheckBox
                      //     .map((e) => buildMyPoopMassIsCheckBox(e))
                      //     .toList(),
                      // const Divider(
                      //   color: kLineColor,
                      //   thickness: 1,
                      // ),
                      // Text(
                      //   "My poop mass:",
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //     color: eUser().mainHeadingColor,
                      //     fontFamily: eUser().userFieldLabelFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      // ...myPoopMassCheckBox
                      //     .map((e) => buildMyPoopMassCheckBox(e))
                      //     .toList(),
                      // const Divider(
                      //   color: kLineColor,
                      //   thickness: 1,
                      // ),
                      // Text(
                      //   "I fart:",
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //     color: eUser().mainHeadingColor,
                      //     fontFamily: eUser().userFieldLabelFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      // ...fartCheckBox.map((e) => buildFartCheckBox(e)).toList(),
                      // const Divider(
                      //   color: kLineColor,
                      //   thickness: 1,
                      // ),
                      // Text(
                      //   "Usually, my fart has:",
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //     color: eUser().mainHeadingColor,
                      //     fontFamily: eUser().userFieldLabelFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      // ...myFartHasCheckBox
                      //     .map((e) => buildMyFartHasCheckBox(e))
                      //     .toList(),
                      // const Divider(
                      //   color: kLineColor,
                      //   thickness: 1,
                      // ),
                      // Text(
                      //   "After I poop",
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //     color: eUser().mainHeadingColor,
                      //     fontFamily: eUser().userFieldLabelFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      // ...afterIPoopCheckBox
                      //     .map((e) => buildAfterIPoopCheckBox(e))
                      //     .toList(),
                    ],
                  ),
                ),
                InkWell(
                  onTap:isSyncing ? null : () {
                    if (validation()) {
                      if (selectedQue1 == 0) {
                        healthy++;

                        cat2Healthy++;
                        cat4Healthy++;
                      } else if (selectedQue1 == 1) {
                        unhealthy++;

                        cat2unHealthy++;
                        cat4unHealthy++;
                      }

                      if (selectedQue2 == 0) {
                        healthy++;

                        cat2Healthy++;
                        cat4Healthy++;
                      } else if (selectedQue2 == 1) {
                        unhealthy++;

                        cat2unHealthy++;
                        cat4unHealthy++;
                      }

                      if (selectedQue3 == 0 || selectedQue3 == 1) {
                        healthy++;

                        cat1Healthy++;
                      } else if (selectedQue3 == 2) {
                        unhealthy++;

                        cat1unHealthy++;
                      }

                      if (selectedQue4 == 0) {
                        healthy++;

                        cat1Healthy++;
                        cat5Healthy++;
                      } else if (selectedQue4 == 1) {
                        unhealthy++;

                        cat1unHealthy++;
                        cat5unHealthy++;
                      }

                      if (selectedQue5 == 0) {
                        healthy++;

                        cat1Healthy++;
                      } else if (selectedQue5 == 1) {
                        unhealthy++;

                        cat1unHealthy++;
                      }

                      if (selectedQue6 == 0) {
                        healthy++;

                        cat1Healthy++;
                        cat2Healthy++;
                        cat3Healthy++;
                        cat5Healthy++;
                      } else if (selectedQue6 == 1 ||
                          selectedQue6 == 2 ||
                          selectedQue6 == 3 ||
                          selectedQue6 == 4) {
                        unhealthy++;

                        cat1unHealthy++;
                        cat2unHealthy++;
                        cat3unHealthy++;
                        cat5unHealthy++;
                      }

                      if (selectedQue7 == 0) {
                        healthy++;

                        cat3Healthy++;
                      } else if (selectedQue7 == 1) {
                        unhealthy++;

                        cat3unHealthy++;
                      }

                      if (selectedQue8 == 0) {
                        healthy++;

                        cat6Healthy++;
                      } else if (selectedQue8 == 1) {
                        unhealthy++;
                      }
                      // if (healthy + unhealthy != 8) {
                      //   AppConfig()
                      //       .showSnackbar(context, 'Select All Questions');
                      //   return;
                      // }

                      if (cat1Healthy > cat1unHealthy) {
                        cat1ov = "1";
                      } else if (cat1unHealthy > cat1Healthy) {
                        cat1ov = "0";
                      }

                      if (cat2Healthy > cat2unHealthy) {
                        cat2ov = "1";
                      } else if (cat2unHealthy > cat2Healthy) {
                        cat2ov = "0";
                      }

                      if (cat3Healthy > cat3unHealthy) {
                        cat3ov = "1";
                      } else if (cat4unHealthy > cat4Healthy) {
                        cat3ov = "0";
                      }

                      if (cat4Healthy > cat4unHealthy) {
                        cat4ov = "1";
                      } else if (cat4unHealthy > cat4Healthy) {
                        cat4ov = "0";
                      }
                      if (cat5Healthy > cat5unHealthy) {
                        cat5ov = "1";
                      } else if (cat5unHealthy > cat5Healthy) {
                        cat5ov = "0";
                      }

                      if (cat6Healthy > cat6unHealthy) {
                        cat6ov = "1";
                      } else if (cat6unHealthy > cat6Healthy) {
                        cat6ov = "0";
                      }

                      listHealthyValue.add(cat1ov);
                      listHealthyValue.add(cat2ov);
                      listHealthyValue.add(cat3ov);
                      listHealthyValue.add(cat4ov);
                      listHealthyValue.add(cat5ov);
                      listHealthyValue.add(cat6ov);

                      print(listHealthyValue.join(","));

                      print('healthy');
                      print(healthy);
                      print('unhealthy');
                      print(unhealthy);
                      print('cat1unHealthy');
                      print(cat1unHealthy);
                      print('cat2unHealthy');
                      print(cat2unHealthy);
                      print('cat3unHealthy');
                      print(cat3unHealthy);
                      print('cat4unHealthy');
                      print(cat4unHealthy);
                      print('cat5unHealthy');
                      print(cat5unHealthy);
                      print('cat6unHealthy');
                      print(cat6unHealthy);

                      print('cat1Healthy');
                      print(cat1Healthy);
                      print('cat2Healthy');
                      print(cat2Healthy);
                      print('cat3Healthy');
                      print(cat3Healthy);
                      print('cat4Healthy');
                      print(cat4Healthy);
                      print('cat5Healthy');
                      print(cat5Healthy);
                      print('cat6Healthy');
                      print(cat6Healthy);

                      String healthy_value = listHealthyValue.join(",");

                      int zeroCount = 0, oneCount = 0;
                      for (int i = 0; i < listHealthyValue.length; i++) {
                        if (listHealthyValue[i] == '0') {
                          zeroCount++;
                        }
                        if (listHealthyValue[i] == '1') {
                          oneCount++;
                        }
                      }

                      SharedPreferenceUtil.putInt(
                          AppConfig.gutHealthTrackerOneCount, oneCount);
                      SharedPreferenceUtil.putInt(
                          AppConfig.gutHealthTrackerZeroCount, zeroCount);
                      print(zeroCount);
                      print(oneCount);
                      var data =
                          'Thank you for taking time to Know your Body!\n\nAs per your choice, the evaluation indicates that your\n'
                          'Gut biome may be functionally dis-balanced. It may also indicate high protein diet.\n'
                          'It needs correction after further analysis. Correction of functional imbalance is usually through a combination of appropriate diet; physical activity and mind practices';

                      showResultStoolsPopUp(data);
                      // callSaveDataAPI(healthy_value);
                    }
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
                          child: (isSyncing) ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                              : Text(
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
                        "assets/images/gut_health_tracker/Group 76919.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool validation() {
    if (selectedQue1 == -1) {
      AppConfig()
          .showSnackbar(context, 'Select I Poop Question', isError: true);
      return false;
    } else if (selectedQue2 == -1) {
      AppConfig().showSnackbar(context, 'Select I Pass My Poop Question',
          isError: true);
      return false;
    } else if (selectedQue3 == -1) {
      AppConfig().showSnackbar(context, 'Select My Poop Color Is Question',
          isError: true);
      return false;
    } else if (selectedQue4 == -1) {
      AppConfig().showSnackbar(context, 'Select My Poop Mass Is Question',
          isError: true);
      return false;
    } else if (selectedQue5 == -1) {
      AppConfig()
          .showSnackbar(context, 'Select My Poop Mass Question', isError: true);
      return false;
    } else if (selectedQue6 == -1) {
      AppConfig()
          .showSnackbar(context, 'Select I Fart Question', isError: true);
      return false;
    } else if (selectedQue7 == -1) {
      AppConfig()
          .showSnackbar(context, 'Select My Fart Has Question', isError: true);
      return false;
    } else if (selectedQue8 == -1) {
      AppConfig()
          .showSnackbar(context, 'Select After I Poop Question', isError: true);
      return false;
    } else {
      return true;
    }
  }

  void callSaveDataAPI(String healthyValue) async {
    setState(() {
      isSyncing = true;
    });

    Map sendDetailsMap = {
      "fem_id": SharedPreferenceUtil.getString(AppConfig.USER_ID),
      "tools_id": '2',
      "tool_categorie_id": '1',
      "healthy": healthy,
      "unhealthy": unhealthy,
      "healthy_value": healthyValue,
      "overall_value": '',
      "overall_healthy": '',
      "overall_unhealthy": '',
    };

    print(sendDetailsMap);
    final res = await HomeService(repository: repository)
        .gutHealthTrackerService(sendDetailsMap);

    if (res.runtimeType == ErrorModel) {
      setState(() {
        isSyncing = false;
      });
      final result = res as ErrorModel;
      print("Submit error: ${res.message}");
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    } else {
      setState(() {
        isSyncing = false;
      });
      final result = res as SuccessMessageModel;
      // AppConfig().showSnackbar(context, result.errorMsg ?? '');
      String data = '';
      if (healthy > unhealthy) {
        // dynamicSeekBarView.setProgress(0);
        data =
            'Thank you for taking time to Know your Body!\n\nAs per your choice, the evaluation indicates that your\n'
            'Body has detoxed well and intestinal motility is healthy';
      } else {
        // dynamicSeekBarView.setProgress(65);
        data =
            'Thank you for taking time to Know your Body!\n\nAs per your choice, the evaluation indicates that your\n'
            'Gut biome may be functionally dis-balanced. It may also indicate high protein diet.\n'
            'It needs correction after further analysis. Correction of functional imbalance is usually through a combination of appropriate diet; physical activity and mind practices';
      }
      showResultStoolsPopUp(data);
      // bool res = await showBsheetNext();
      print(result);
      print("submit success");
    }

    // var dio = Dio();
    //
    // var body;
    // Response response;
    // try {
    //   response = await dio.post(
    //     Constants.kBaseUrl + 'fem_SaveToolsEvaluation_v1',
    //     queryParameters: {
    //       "fem_id": SharedPreferenceUtil.getString(Constants.kfem_id),
    //       "tools_id": '2',
    //       "tool_categorie_id": '1',
    //       "healthy": healthy,
    //       "unhealthy": unhealthy,
    //       "healthy_value": healthy_value,
    //       "overall_value": '',
    //       "overall_healthy": '',
    //       "overall_unhealthy": '',
    //
    //     },
    //     options: Options(headers: {
    //       HttpHeaders.contentTypeHeader: "application/json",
    //     }, contentType: 'application/json; charset=UTF-8'),
    //   );
    //   setState(() {
    //     isSyncing = false;
    //   });
    //   body = json.decode(response.toString());
    //
    //   if (response.statusCode == 200) {
    //     Map loginMap = jsonDecode(response.toString());
    //
    //     body = json.decode(response.toString());
    //     print(response.toString());
    //
    //     if (body['status'] == 'success') {
    //       Constants.toastMessage(body['msg']);
    //
    //       String data = '';
    //       if(healthy>unhealthy){
    //         // dynamicSeekBarView.setProgress(0);
    //         data = 'Thank you for taking time to Know your Body!\n\nAs per your choice, the evaluation indicates that your\n'
    //             'Body has detoxed well and intestinal motility is healthy';
    //
    //       }else{
    //         // dynamicSeekBarView.setProgress(65);
    //         data = 'Thank you for taking time to Know your Body!\n\nAs per your choice, the evaluation indicates that your\n'
    //             'Gut biome may be functionally dis-balanced. It may also indicate high protein diet.\n'
    //             'It needs correction after further analysis. Correction of functional imbalance is usually through a combination of appropriate diet; physical activity and mind practices';
    //       }
    //       showResultStoolsPopUp(data);
    //       /*      bool res = await showBsheetNext();
    //       if (res) {
    //         Navigator.pop(context, true);
    //       }*/
    //     } else {
    //       Constants.toastMessage(body['msg']);
    //     }
    //   } else {
    //     Constants.toastMessage(body['msg']);
    //   }
    // } on DioError catch (error) {
    //   setState(() {
    //     _isSyncing = false;
    //   });
    //   body = json.decode(error.response.toString());
    //   Constants.toastMessage(body['msg']);

    // }
  }

  final HomeRepository repository = HomeRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  showResultStoolsPopUp(String title) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          var splitTitle = title.split('\n\n');
          var firstTitle = splitTitle.first;
          var secondTitle = splitTitle.last;
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
              height: 75.h,
              child: Stack(
                children: [
                  const Image(
                    image: AssetImage(
                        "assets/images/gut_health_tracker/Group 76921.png"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Stack(
                        children: [
                          Container(
                            height: 2.5.h,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
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
                                  "Gut",
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
                              image: const AssetImage(
                                  "assets/images/gut_health_tracker/Group 5426.png"),
                            ),
                          ),
                          Positioned(
                            top: 2.5.h,
                            right: 28.w,
                            child: Image(
                              height: 5.h,
                              image: const AssetImage(
                                  "assets/images/gut_health_tracker/Group 5424.png"),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          firstTitle,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            height: 1.5,
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ...secondTitle.split('\n').map((element) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0.5.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.7.h),
                                child: Icon(
                                  Icons.circle_sharp,
                                  color: gGreyColor,
                                  size: 1.h,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  element.replaceAll("\n", ""),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize:
                                          MealPlanConstants().benifitsFontSize,
                                      fontFamily:
                                          MealPlanConstants().benifitsFont),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SalivaQualityScreen();
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
                                  'Proceed to Saliva',
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
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: 1.h, horizontal: 5.w),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: Icon(
                      //           Icons.circle_sharp,
                      //           color: kNumberCircleRed,
                      //           size: 1.5.h,
                      //         ),
                      //       ),
                      //       SizedBox(width: 1.w),
                      //       Expanded(
                      //         child: Text(
                      //           "Lorem ipsum dolor sit amet, consetetur",
                      //           textAlign: TextAlign.start,
                      //           style: TextStyle(
                      //             height: 1.5,
                      //             color: eUser().mainHeadingColor,
                      //             fontFamily: eUser().userFieldLabelFont,
                      //             fontSize: eUser().buttonTextSize,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: 1.h, horizontal: 5.w),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: Icon(
                      //           Icons.circle_sharp,
                      //           color: kNumberCircleRed,
                      //           size: 1.5.h,
                      //         ),
                      //       ),
                      //       SizedBox(width: 1.w),
                      //       Expanded(
                      //         child: Text(
                      //           "Lorem ipsum dolor sit amet, consetetur",
                      //           textAlign: TextAlign.start,
                      //           style: TextStyle(
                      //             height: 1.5,
                      //             color: eUser().mainHeadingColor,
                      //             fontFamily: eUser().userFieldLabelFont,
                      //             fontSize: eUser().buttonTextSize,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: 1.h, horizontal: 5.w),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: Icon(
                      //           Icons.circle_sharp,
                      //           color: kNumberCircleRed,
                      //           size: 1.5.h,
                      //         ),
                      //       ),
                      //       SizedBox(width: 1.w),
                      //       Expanded(
                      //         child: Text(
                      //           "Lorem ipsum dolor sit amet, consetetur",
                      //           textAlign: TextAlign.start,
                      //           style: TextStyle(
                      //             height: 1.5,
                      //             color: eUser().mainHeadingColor,
                      //             fontFamily: eUser().userFieldLabelFont,
                      //             fontSize: eUser().buttonTextSize,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SizedBox(
                      height: 20.h,
                      child: const Image(
                        image: AssetImage(
                            "assets/images/gut_health_tracker/Group 76920.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).whenComplete(() {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SalivaQualityScreen(),
        ),
      );
    });
  }

// final poopCheckBox = [
//   CheckBoxSettings(
//       title: "The same number of times and at a similar time everyday"),
//   CheckBoxSettings(
//       title:
//           "Recently, there has been changes in my bowel movements and it concerns me "),
// ];
//
// List<String> selectedPoop = [];
//
// final passMyPoopCheckBox = [
//   CheckBoxSettings(
//       title:
//           "Easily (like: I get the urge to poop and I easily poop when on the toilet seat)"),
//   CheckBoxSettings(
//       title:
//           "With some difficulty / pain / burning sensation (like: I need to put some pressure on my tummy or contract my anus to pass my poop)"),
// ];
//
// List<String> selectedPassMyPoop = [];
//
// final myPoopColorCheckBox = [
//   CheckBoxSettings(title: "Medium to light golden brown"),
//   CheckBoxSettings(
//       title:
//           "Green, red or purple in color on days when I eat certain foods like GLVs / Beets / Turnips"),
//   CheckBoxSettings(
//       title:
//           "White, Pale, Yellow, Green, bright Red, Purple, Grey or Black in color irrespective of the food I eat"),
// ];
//
// List<String> selectedMyPoopColor = [];
//
// final myPoopMassIsCheckBox = [
//   CheckBoxSettings(
//       title:
//           "Smooth / soft / flows out into long shapes without being splashy (spreading much across anal zone / into commode)"),
//   CheckBoxSettings(
//       title:
//           "Hard / lumpy pieces / mushy / watery / pasty / sticky and difficult to clean of"),
// ];
//
// List<String> selectedMyPoopMassIs = [];
//
// final myPoopMassCheckBox = [
//   CheckBoxSettings(title: "Floats on commode water"),
//   CheckBoxSettings(title: "Sinks in commode water"),
// ];
//
// List<String> selectedMyPoopMass = [];
//
// final fartCheckBox = [
//   CheckBoxSettings(
//       title: "Few seconds before / after I poop, with / without smell"),
//   CheckBoxSettings(title: "Along when I poop"),
//   CheckBoxSettings(
//       title:
//           "There is a long gap between my fart and when I poop, with repulsive smell"),
//   CheckBoxSettings(
//       title:
//           "frequently with repulsive smell, irrespective of the urge to defecate"),
//   CheckBoxSettings(title: "I Never Fart"),
// ];
//
// List<String> selectedFart = [];
//
// final myFartHasCheckBox = [
//   CheckBoxSettings(title: "No smell"),
//   CheckBoxSettings(title: "Repulsive smell"),
// ];
//
// List<String> selectedMyFart = [];
//
// final afterIPoopCheckBox = [
//   CheckBoxSettings(
//       title:
//           "do not have another urge / do not feel like going back to the toilet again"),
//   CheckBoxSettings(
//       title:
//           "I have another urge / feel like going back to the toilet again"),
// ];
//
// List<String> selectedAfterIPoop = [];

// buildPoopCheckBox(CheckBoxSettings poopCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             poopCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color:
  //                     poopCheckBox.value == true ? kTextColor : gHintTextColor,
  //                 fontFamily:
  //                     poopCheckBox.value == true ? kFontMedium : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: poopCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedPoop.add(poopCheckBox.title!);
  //               poopCheckBox.value = v;
  //               print(selectedPoop);
  //             } else {
  //               selectedPoop.remove(poopCheckBox.title!);
  //               poopCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

  // buildPassMyPoopCheckBox(CheckBoxSettings passMyPoopCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             passMyPoopCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: passMyPoopCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: passMyPoopCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: passMyPoopCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedPassMyPoop.add(passMyPoopCheckBox.title!);
  //               passMyPoopCheckBox.value = v;
  //               print(selectedPoop);
  //             } else {
  //               selectedPassMyPoop.remove(passMyPoopCheckBox.title!);
  //               passMyPoopCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

  // buildMyPoopColorCheckBox(CheckBoxSettings myPoopColorCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             myPoopColorCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: myPoopColorCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: myPoopColorCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: myPoopColorCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedMyPoopColor.add(myPoopColorCheckBox.title!);
  //               myPoopColorCheckBox.value = v;
  //               print(selectedPoop);
  //             } else {
  //               selectedMyPoopColor.remove(myPoopColorCheckBox.title!);
  //               myPoopColorCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

  // buildMyPoopMassIsCheckBox(CheckBoxSettings myPoopMassIsCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             myPoopMassIsCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: myPoopMassIsCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: myPoopMassIsCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: myPoopMassIsCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedMyPoopMassIs.add(myPoopMassIsCheckBox.title!);
  //               myPoopMassIsCheckBox.value = v;
  //               print(selectedPoop);
  //             } else {
  //               selectedMyPoopMassIs.remove(myPoopMassIsCheckBox.title!);
  //               myPoopMassIsCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

  // buildMyPoopMassCheckBox(CheckBoxSettings myPoopMassCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             myPoopMassCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: myPoopMassCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: myPoopMassCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: myPoopMassCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedMyPoopMass.add(myPoopMassCheckBox.title!);
  //               myPoopMassCheckBox.value = v;
  //               print(selectedPoop);
  //             } else {
  //               selectedMyPoopMass.remove(myPoopMassCheckBox.title!);
  //               myPoopMassCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

  // buildFartCheckBox(CheckBoxSettings fartCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             fartCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color:
  //                     fartCheckBox.value == true ? kTextColor : gHintTextColor,
  //                 fontFamily:
  //                     fartCheckBox.value == true ? kFontMedium : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: fartCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedFart.add(fartCheckBox.title!);
  //               fartCheckBox.value = v;
  //               print(selectedPoop);
  //             } else {
  //               selectedFart.remove(fartCheckBox.title!);
  //               fartCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

  // buildMyFartHasCheckBox(CheckBoxSettings myFartHasCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             myFartHasCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: myFartHasCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: myFartHasCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: myFartHasCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedMyFart.add(myFartHasCheckBox.title!);
  //               myFartHasCheckBox.value = v;
  //               print(selectedPoop);
  //             } else {
  //               selectedMyFart.remove(myFartHasCheckBox.title!);
  //               myFartHasCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

  // buildAfterIPoopCheckBox(CheckBoxSettings afterIPoopCheckBox) {
  //   return StatefulBuilder(builder: (_, setstate) {
  //     return IntrinsicWidth(
  //       child: CheckboxListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         title: Transform.translate(
  //           offset: const Offset(-10, 0),
  //           child: Text(
  //             afterIPoopCheckBox.title.toString(),
  //             style: buildTextStyle(
  //                 color: afterIPoopCheckBox.value == true
  //                     ? kTextColor
  //                     : gHintTextColor,
  //                 fontFamily: afterIPoopCheckBox.value == true
  //                     ? kFontMedium
  //                     : kFontBook),
  //           ),
  //         ),
  //         dense: true,
  //         activeColor: kPrimaryColor,
  //         value: afterIPoopCheckBox.value,
  //         onChanged: (v) {
  //           setstate(() {
  //             if (v == true) {
  //               selectedAfterIPoop.add(afterIPoopCheckBox.title!);
  //               afterIPoopCheckBox.value = v;
  //               print(selectedPoop);
  //             } else {
  //               selectedAfterIPoop.remove(afterIPoopCheckBox.title!);
  //               afterIPoopCheckBox.value = v;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }
}
