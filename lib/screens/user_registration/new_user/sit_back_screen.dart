/*
this screen we r showing once user has submit enquiry form
once accepted login screen will show
 */

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'about_the_program.dart';

class SitBackScreen extends StatefulWidget {
  const SitBackScreen({Key? key}) : super(key: key);

  @override
  State<SitBackScreen> createState() => _SitBackScreenState();
}

class _SitBackScreenState extends State<SitBackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gSitBackBgColor,
      body: Padding(
        padding: EdgeInsets.only(left: 4.w, top: 4.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {},
              isBackEnable: false
              ),
              // SizedBox(height: 2.h),
              const Image(
                image: AssetImage("assets/images/Mask Group 2172.png"),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Sit back, relax, and let us do the rest.",
                  style: TextStyle(
                      fontFamily: kFontBold,
                      color: gTextColor,
                      fontSize: 14.dp),
                ),
              ),SizedBox(height: 1.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("We're excited to help you achieve your gut health goals. Get ready to feel your best self yet!",
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontMedium,
                      color: gTextColor,
                      fontSize: 12.dp),
                ),
              ),
              SizedBox(height: 1.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "We'll be in touch soon to kick-start your journey towards optimal gut health.",
                  // "Congrats on initiating your journey to a healthy gut. Our team will get in touch via whatsApp within 24hours",
                  // "Congratulations on your initiative towards a healthy gut! Our team will reach out to you soon. . .",
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontBook,
                      color: gTextColor,
                      fontSize: 12.dp),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: TextButton(
                  child: Text("Read more About Program >",
                    style: TextStyle(
                      fontFamily: kFontMedium,
                      fontSize: 10.dp,
                      color: gsecondaryColor
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> AboutTheProgram(isFromSitBackScreen: true,)));
                  },
                )
              ),
              // Center(child: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextButton(
              //     child: Text("Submit New Query",
              //       style: TextStyle(
              //         fontFamily: "GothamBook",
              //         color: gTextColor,
              //         fontSize: 11.5.dp,
              //       ),
              //     ),
              //     onPressed: (){
              //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => ExistingUser()), (route) => route.isFirst);
              //     },
              //   ),
              // ))
            ],
          ),
        ),
      ),
    );
  }
}
