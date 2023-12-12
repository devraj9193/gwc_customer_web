import 'package:flutter/material.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:sizer/sizer.dart';

class MealPopup extends StatelessWidget {
  final VoidCallback yesButton;
  final VoidCallback noButton;
  const MealPopup({Key? key, required this.yesButton, required this.noButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.74,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(38),
                  child: Image.asset('assets/images/meal_popup.png',
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Text('Your Meal Plan is Ready.\nThis usually takes 3 - 5 days for delivery.\nAre you ready to receive the shipment?',
                textAlign: TextAlign.center,
                style: TextStyle(
                   height: 1.2,
                  fontFamily: kFontBold,
                  color: gBlackColor,
                  fontSize: 13.sp,
                ),),
                SizedBox(height: 5.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('No', noButton),
                    buildButton('Yes', yesButton, isFilledColor: true)
                  ],
                ),
                SizedBox(height: 5.h,),
              ],
            ),
          ),
    );

  }

  buildButton(String name, VoidCallback onTap, {bool isFilledColor = false}){
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isFilledColor ? gPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: gMainColor, width: 1),
        ),
        child: Text(
          name,
          style: TextStyle(
            fontFamily: "GothamMedium",
            color: isFilledColor ? gMainColor : gPrimaryColor,
            fontSize: 11.5.sp,
          ),
        ),
      ),
    );
    return ElevatedButton(
        onPressed: onTap,
        child: Text(name,
          style: TextStyle(
            fontFamily: "GothamRoundedBold_21016",
            color: isFilledColor ? gMainColor : gPrimaryColor,
            fontSize: 10.sp,
          ),
        ),
      style: ElevatedButton.styleFrom(
          side: BorderSide(width: 1.0,
            color: gMainColor,),
        primary: isFilledColor ? gPrimaryColor : gWhiteColor
      ),
    );
  }
}
