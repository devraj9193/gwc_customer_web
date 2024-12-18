import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/constants.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({Key? key}) : super(key: key);

  @override
  _BottomSheetWidget createState() => _BottomSheetWidget();
}

class _BottomSheetWidget extends State<BottomSheetWidget> {
  bool _showSecond = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: AnimatedCrossFade(
        firstChild: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height - 200,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Are You Sure!",
                  style: TextStyle(
                      fontSize: bottomSheetHeadingFontSize,
                      fontFamily: bottomSheetHeadingFontFamily,
                      height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: kLineColor,
                  thickness: 1.2,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                    onPressed: () => setState(() => _showSecond = true),
                    text: "Yes",
                    isLoading: false,
                    radius: 5,
                    buttonWidth: 15.w,
                  ),
                  SizedBox(width: 5.w),
                  ButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    text: "No",
                    isLoading: false,
                    radius: 5,
                    buttonWidth: 15.w,
                    color: gWhiteColor,
                    textColor: gsecondaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        secondChild: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height / 3,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "We will miss you.",
                  style: TextStyle(
                      fontSize: bottomSheetHeadingFontSize,
                      fontFamily: bottomSheetHeadingFontFamily,
                      height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: kLineColor,
                  thickness: 1.2,
                ),
              ),
              Center(
                child: Text(
                  'Do you really want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gTextColor,
                    fontSize: bottomSheetSubHeadingXFontSize,
                    fontFamily: bottomSheetSubHeadingMediumFont,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Center(
                child: ButtonWidget(
                  onPressed: () => setState(() => _showSecond = false),
                  text: "Logout",
                  isLoading: false,
                  radius: 5,
                  buttonWidth: 15.w,
                ),
              ),
              SizedBox(height: 1.h)
            ],
          )
        ),
        crossFadeState: _showSecond
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 400),
      ),
      duration: const Duration(milliseconds: 400),
    );
  }
}