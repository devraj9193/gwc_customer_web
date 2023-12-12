import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gwc_customer_web/screens/dashboard_screen.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HelpScreen extends StatefulWidget {
  bool isFromLogin;
  HelpScreen({this.isFromLogin = false});
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool end = false;

  List<Map<String, String>> helpdata = [
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 1; i<=17; i++){
      helpdata.add({
        "image": "assets/images/help_screens/$i.png"
      });
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.bottom]);
    // setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    animatePageview();
  }

  animatePageview()
  {
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage == helpdata.length -1) {
        end = true;
      } else if (_currentPage == 0) {
        end = false;
      }

      if (end == false) {
        _currentPage++;
      }

      if(_pageController.hasClients)
      {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 1000),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: <Widget>[
              PageView.builder(

                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: helpdata.length,
                itemBuilder: (context, index) =>
                    Image.asset(
                      helpdata[index]['image'].toString(),
                      fit: BoxFit.fill,
                    ),
              ),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   child: PageView.builder(
              //
              //     controller: _pageController,
              //     onPageChanged: (value) {
              //       setState(() {
              //         _currentPage = value;
              //       });
              //     },
              //     itemCount: helpdata.length,
              //     itemBuilder: (context, index) => HelpContent(
              //       image: helpdata[index]["image"],
              //     ),
              //   ),
              // ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    (!widget.isFromLogin) ?
                    Navigator.pop(context) :   Navigator.pushReplacement(
                        context, MaterialPageRoute(
                        builder: (ctx) => DashboardScreen(index: 2,))
                    );
                    },
                  child: Container(
                      height: 10.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                      alignment: Alignment.centerRight,
                      child: Text('Skip',
                        style: TextStyle(
                            color: gWhiteColor,
                            fontSize: PPConstants().topViewHeadingFontSize,
                            fontFamily: kFontBold
                        ),
                      )
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 5,
                right: 5,
                child: Container(
                  height: 15.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            helpdata.length,
                                (index) => buildDot(index: index),
                          ),
                        ),
                        Spacer(),
                        Visibility(
                          visible: (_currentPage == helpdata.length-1) ? true : false,
                          child: GestureDetector(
                            onTap: (){
                              (!widget.isFromLogin) ?
                              Navigator.pop(context) :   Navigator.pushReplacement(
                                  context, MaterialPageRoute(
                                  builder: (ctx) => DashboardScreen(index: 2,))
                              );
                            },
                            child: Container(
                              width: 40.w,
                              height: 4.5.h,
                              // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: eUser().buttonColor,
                                borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                                // border: Border.all(color: eUser().buttonBorderColor,
                                //     width: eUser().buttonBorderWidth),
                              ),
                              child: Center(
                                child: Text('Done',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontFamily: kFontBold
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //       child: Scaffold(
  //         body: SizedBox(
  //           width: double.infinity,
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 flex: 4,
  //                 child: PageView.builder(
  //                     onPageChanged: (value) {
  //                       setState(() {
  //                         currentPage = value;
  //                       });
  //                     },
  //                     itemCount: helpdata.length,
  //                     itemBuilder: (context, index) =>
  //                         HelpContent(
  //                           text: '1bc',
  //                             image: 'assets/images/Splash_bg.png'
  //                         )
  //                 ),
  //               ),
  //               // Expanded(
  //               //   flex: 2,
  //               //   child: Padding(
  //               //     padding: EdgeInsets.symmetric(
  //               //         horizontal: 10.w
  //               //     ),
  //               //     child: Column(
  //               //       children: [
  //               //         Row(
  //               //           mainAxisAlignment: MainAxisAlignment.center,
  //               //           children: List.generate(
  //               //             3,
  //               //                 (index) => buildDot(index: index),
  //               //           ),
  //               //         ),
  //               //         ElevatedButton(
  //               //           onPressed: (){
  //               //             Navigator.pushReplacement(
  //               //                 context, MaterialPageRoute(
  //               //                 builder: (ctx) => HomeScreen())
  //               //             );
  //               //           },
  //               //           child: Text('Done',
  //               //             style: TextStyle(
  //               //                 color: Colors.white,
  //               //                 fontSize: 20.sp,
  //               //                 fontFamily: Constants.w200
  //               //             ),
  //               //           ),
  //               //           style: ElevatedButton.styleFrom(
  //               //             elevation: 10,
  //               //             primary: MainTheme.button,
  //               //             minimumSize: Size(5.w, 6.h),
  //               //             padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
  //               //             shape: RoundedRectangleBorder(
  //               //                 borderRadius: BorderRadius.circular(30.sp)
  //               //             ),
  //               //
  //               //           ),
  //               //         ),
  //               //
  //               //         Spacer()
  //               //       ],
  //               //     ),
  //               //   ),
  //               // )
  //             ],
  //           ),
  //         ),
  //       )
  //   );
  // }

  AnimatedContainer buildDot({int? index}){
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 3.w),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
          color: _currentPage == index ? gsecondaryColor : gTapColor,
          borderRadius: BorderRadius.circular(3)
      ),
    );
  }

}