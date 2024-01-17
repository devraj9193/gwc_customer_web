/*
flutter_share_me package used to share message on whatsapp
 */

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/time_line_widget.dart';
import '../../../widgets/unfocus_widget.dart';


class ReferAndEarnScreen extends StatelessWidget {
  ReferAndEarnScreen({Key? key}) : super(key: key);

  static const rupeeSymbol = '\u{20B9}';

  final _referController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: SafeArea(
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (ctx, value){
                print("value--> $value");
                return [ SliverAppBar(
                  // iconTheme: IconThemeData(
                  //   color: Colors.black,
                  // ),
                  pinned: true,
                  expandedHeight: 175,
                  collapsedHeight: 130,
                  actions: [
                    TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: (){
                          showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: false,
                            enableDrag: false,
                            context: context,
                            backgroundColor: Colors.transparent,
                            // shape: const RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.vertical(
                            //     top: Radius.circular(30),
                            //   ),
                            // ),
                            builder: (BuildContext context) =>
                                AnimatedPadding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  // EdgeInsets. only(bottom: MediaQuery.of(context).viewInsets),
                                  duration: const Duration(milliseconds: 100),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: gWhiteColor,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30),
                                      ),
                                    ),
                                    height: 45.h,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 15.h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(22),
                                                color: kBottomSheetHeadYellow,
                                              ),
                                              child: Center(
                                                child: Image.asset(bsHeadStarsIcon,
                                                  alignment: Alignment.topRight,
                                                  fit: BoxFit.scaleDown,
                                                  width: 30.w,
                                                  height: 10.h,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            Flexible(child:
                                            SingleChildScrollView(
                                              child: StatefulBuilder(
                                                  builder: (_, setstate){
                                                    // bottomsheetSetState = setstate;
                                                    return Column(
                                                      children: [
                                                        Text("Please Enter the Referral Code"),
                                                        TextField(
                                                          controller: _referController,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Center(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              print(_referController.text);
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              padding:
                                                              EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                                                              decoration: BoxDecoration(
                                                                  color: gsecondaryColor,
                                                                  border: Border.all(color: kLineColor, width: 0.5),
                                                                  borderRadius: BorderRadius.circular(5)),
                                                              child: Text(
                                                                "Submit",
                                                                style: TextStyle(
                                                                  fontFamily: kFontMedium,
                                                                  color: gWhiteColor,
                                                                  fontSize: 11.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  }
                                              ),))
                                          ],
                                        ),
                                        Positioned(
                                            top: 8.h,
                                            left: 5,
                                            right: 5,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  // color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(blurRadius: 5, color: gHintTextColor.withOpacity(0.8))
                                                  ],
                                                ),
                                                child: CircleAvatar(
                                                  maxRadius: 40.sp,
                                                  backgroundColor: kBottomSheetHeadCircleColor,
                                                  child: Image.asset(bsHeadBellIcon,
                                                    fit: BoxFit.scaleDown,
                                                    width: 45,
                                                    height: 45,
                                                  ),
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: Text("Apply Code",
                          style: TextStyle(
                              fontFamily: kFontMedium,
                              color: gWhiteColor,
                              fontSize: 12.sp
                          ),
                        )
                    )
                  ],
                  flexibleSpace: Container(
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("GWC Credits",
                                style: TextStyle(
                                    height: 1.5,
                                    fontFamily: kFontBold,
                                    color: gWhiteColor,
                                    fontSize: 14.sp
                                ),
                              ),
                              Text("$rupeeSymbol 0",
                                style: TextStyle(
                                    height: 2,
                                    fontFamily: kFontBold,
                                    color: gWhiteColor,
                                    fontSize: 14.sp
                                ),)
                            ],
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/referearn.png'),
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                )
                ];
              },
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  earnedCreditsText(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3.5.w, vertical: 1.0.h
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("How refer and earn credits",
                            style: TextStyle(
                                fontSize: 12.sp,
                                // fontSize: 12.sp,
                                fontFamily: kFontBold,
                                height: 1.5
                            ),
                          ),),

                      ],
                    ),
                  ),
                  referView(context),
                  Flexible(child: verticalStep(),
                    fit: FlexFit.tight,
                  ),
                ],
              ),
              ),
            ),
          )
      );
  }

  showList(){
    return ListView.builder(
      itemCount: 100,
        itemBuilder: (_, index){
        return SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(index.toString()),
          ),
        );
        }
    );
  }

  earnedCreditsText(){
    return Container(
        height: 6.5.h,
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.grey.withOpacity(0.15),
      child: Row(
        children: [
          stackIcons(),
          SizedBox(
            width: 10,
          ),
          Text("0+ earned 1,000 credits today",
            style: TextStyle(
                fontSize: 10.sp,
              fontFamily: kFontBook,
              color: kLineColor
            ),
          )
        ],
      ),
    );
  }

  referView(BuildContext context){
    print("1.h->${1.h}");
    print("1.w->${1.w}");
    print("12.sp->${12.sp}");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w),
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          // height: 35.h,
          decoration: BoxDecoration(
              border: Border.all(
                  color: kLineColor
              ),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Refer and Get ${rupeeSymbol}150 credits!",
                style: TextStyle(
                  height: 2,
                  fontFamily: kFontBold,
                  fontSize: 12.sp
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("0/3 referrals sent"),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    height: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: 0.7,
                        valueColor: AlwaysStoppedAnimation<Color>(gsecondaryColor),
                        backgroundColor: Color(0xffD6D6D6),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Text("Refer a friend and help the start a healthy and fit life with GWC Premium.",
              style: TextStyle(
                fontSize: 10.sp,
                fontFamily: kFontBook,
                color: gHintTextColor
              ),),
              SizedBox(
                height: 1.h,
              ),
              DottedBorder(
                color: gsecondaryColor,
                radius: Radius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: gsecondaryColor.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ABCDE1Z",
                        style: TextStyle(
                            fontFamily: kFontBook,
                            fontSize: 12.sp
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        Text("COPY",
                          style: TextStyle(
                            fontFamily: kFontBold,
                            fontSize: 12.sp
                          ),
                        ),
                          SizedBox(width: 10,),
                          Text("SHARE",
                            style: TextStyle(
                                fontFamily: kFontBold,
                                fontSize: 12.sp
                            ),
                          )
                      ],)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Center(
                child: IntrinsicWidth(
                  child: GestureDetector(
                    onTap:(){
                      sendOnWhatsApp(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 1.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1.h),
                      width: double.maxFinite,
                      height: 45,
                      decoration: BoxDecoration(
                        color: gsecondaryColor,
                        borderRadius: BorderRadius
                            .circular(eUser()
                            .buttonBorderRadius),
                        // border: Border.all(color: eUser().buttonBorderColor,
                        //     width: eUser().buttonBorderWidth),
                      ),
                      child: Center(
                        child: Text(
                          "Refer On WhatsApp",
                          // 'Proceed to Day $proceedToDay',
                          style: TextStyle(
                            fontFamily:
                            eUser().buttonTextFont,
                            color:
                            eUser().buttonTextColor,
                            fontSize:
                            eUser().buttonTextSize,
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
    );
  }

  sendOnWhatsApp(BuildContext context) async{
    String msg = "I'm enjoying getting fit with GutWellnessClub. Join me using my referral code AMIFN9FX2 and earn  ₹ 150  credits. https://hme.app.link/AJNOoznq4Ab";
    // String url = "https://wa.me/?text=$msg";
    // var encoded = Uri.encodeFull(url);
    // try{
    //   if(Platform.isIOS){
    //     await launchUrl(Uri.parse(url));
    //   }
    //   else{
    //     await launchUrl(Uri.parse(url));
    //   }
    // } on Exception{
    //   print("error");
    // }
    var res = await FlutterShareMe().shareToWhatsApp(
        msg: msg);

    print("res: $res");
    if(res == "false"){
      AppConfig().showSnackbar(context, "WhatsApp Not Available", isError: true);
    }
  }

  List<ImageProvider> _images = [
    NetworkImage('https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80'),
    NetworkImage('https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80'),
    NetworkImage('https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80'),

  ];

  stackIcons(){
    return FlutterImageStack.providers(
      providers: _images,
      showTotalCount: true,
      totalCount: 3,
      itemRadius: 25, // Radius of each images
      itemCount: 3, // Maximum number of images to be shown in stack
      itemBorderWidth: 3, // Border width around the images
    );
  }

  int _activeStep = 2;

  verticalReferStepper(){
    return EasyStepper(
      // lineType: LineType.dotted,
      activeStep: _activeStep,
      direction: Axis.vertical,
      unreachedStepIconColor: Colors.white,
      unreachedStepBorderColor: Colors.black54,
      finishedStepBackgroundColor: Colors.deepPurple,
      unreachedStepBackgroundColor: Colors.deepOrange,
      finishedStepTextColor: Colors.black,
      showTitle: true,
      // lineLength: 40,
      // lineThickness: 2,
      // internalPadding: 60,
      // onStepReached: (index) =>
      //     setState(() => activeStep = index),
      steps: const [
        EasyStep(
          icon: Icon(CupertinoIcons.cart),
          title: 'Cart',
          activeIcon: Icon(CupertinoIcons.cart),
          lineText: 'Cart Line',
        ),
        EasyStep(
          icon: Icon(Icons.file_present),
          activeIcon: Icon(Icons.file_present),
          title: 'Address',
        ),
        EasyStep(
          icon: Icon(Icons.filter_center_focus_sharp),
          activeIcon: Icon(Icons.filter_center_focus_sharp),
          title: 'Checkout',
        ),
        EasyStep(
          icon: Icon(Icons.money),
          activeIcon: Icon(Icons.money),
          title: 'Waiting for payment',
        ),
        EasyStep(
          icon: Icon(Icons.local_shipping_outlined),
          activeIcon: Icon(Icons.local_shipping_outlined),
          title: 'Shipping',
        ),
        EasyStep(
          icon: Icon(Icons.check_circle_outline),
          activeIcon: Icon(Icons.check_circle_outline),
          title: 'Finish',
        ),
      ],
    );
  }

  List<MapTextData> _timeLineData = [
    MapTextData(mainAddress: 'Everytime your friend applies your code they get ${rupeeSymbol}150 credits.'),
    MapTextData(mainAddress: 'You earn ${rupeeSymbol}150 credits for the first 3 referrals.'),
    MapTextData(mainAddress: 'You and your friend can use your credits to purchase GWC Plans.'),
  ];

  verticalStep(){
    return Timeline(
      physics: NeverScrollableScrollPhysics(),
      ///Both data needs to be provided every time. If you don't want to add detail then use single colons('')
      children: _timeLineData,
      // indicators: <Widget>[
      //   ///Add Icons here in ascending order
      //   Icon(Icons.directions_transit),
      //   Icon(Icons.directions_walk),
      //   Icon(Icons.directions_bus),
      //   Icon(Icons.account_balance),
      // ],
      indicators: List.generate(
          _timeLineData.length, (index) {
            if(index+1 <= _activeStep ){
              return Icon(Icons.check_circle);
            }
            return Icon(Icons.circle);
          }
      ),
      itemGap: 0,
    );
  }
}
