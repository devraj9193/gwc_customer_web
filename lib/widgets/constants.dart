import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
const newDashboardGreenButtonColor = Color(0xffA7CB52);
const newDashboardLightGreyButtonColor = Color(0xffB9B4B4);

const gPrimaryColor = Color(0xff4E7215);

// const gsecondaryColor = Color(0xffC10B02);
// const gsecondaryColor = Color(0xffD10034);
const gsecondaryColor = Color(0xffEE1004);

const gMainColor = Color(0xffC7A102);
const gGreyColor = Color(0xff707070);

const gBlackColor = Color(0xff000000);
const gWhiteColor = Color(0xffFFFFFF);
const gHintTextColor = Color(0xff676363);
const kLineColor = Color(0xffB9B4B4);

const tabBarHintColor = Color(0xffBBBBBB);



const gTextColor = gBlackColor;
const gTapColor = Color(0xffF8FAFF);
const gBackgroundColor = Color(0xffFAFAFA);
const gSitBackBgColor = Color(0xffFFE889);


const kPrimaryColor = Color(0xffBB0A36);
const kSecondaryColor = Color(0xffFFF5F5);
const kTextColor = Color(0xff000000);
const kWhiteColor = Color(0xffFFFFFF);

const kDividerColor = Color(0xff000029);


const String kFontMedium = 'GothamMedium';
const String kFontBook = 'GothamBook';
const String kFontBold = 'GothamBold';
const String kFontSensaBrush = 'SensaBrush';



// new dashboard colors
const kNumberCircleRed = Color(0xffEF8484);
const kNumberCirclePurple = Color(0xff9C7ADF);
const kNumberCircleAmber = Color(0xffFFBD59);
const kNumberCircleGreen = Color(0xffA7CB52);

/// kBigCircleBorderYellow = F1F2F2
const kBigCircleBg = Color(0xffF1F2F2);

/// kBigCircleBorderRed : #EE1004
const kBigCircleBorderRed = Color(0xffEE1004);
/// kBigCircleBorderYellow : #FFD859
const kBigCircleBorderYellow = Color(0xffFFD859);
/// kBigCircleBorderGreen :  #4E7215
const kBigCircleBorderGreen = Color(0xff4E7215);

const newDashboardTrackingIcon = "assets/images/new_ds/track.png";
const newDashboardMRIcon = "assets/images/new_ds/mr.png";
const newDashboardLockIcon = "assets/images/new_ds/lock.png";
const newDashboardUnLockIcon = "assets/images/new_ds/unlock.png";
const newDashboardOpenIcon = "assets/images/new_ds/open.png";
const newDashboardGMGIcon = "assets/images/new_ds/gmg.png";
const newDashboardChatIcon = "assets/images/new_ds/chat.png";
const newDashboardAppointmentIcon = "assets/images/new_ds/calender.png";


// const kButtonColor = Color(0xffD10034);
const kButtonColor = gsecondaryColor;


/// tracker ui fonts
double headingFont = 12.sp;
double subHeadingFont = 10.sp;
double questionFont = 10.sp;

double smTextFontSize = 8.5.sp;
double smText9FontSize = 9.sp;





const kBottomSheetHeadYellow = Color(0xffFFE281);
const kBottomSheetHeadGreen = Color(0xffA7C652);
const kBottomSheetHeadCircleColor = Color(0xffFFF9F8);

double bottomSheetHeadingFontSize = 12.sp;
String bottomSheetHeadingFontFamily = kFontBold;

double bottomSheetSubHeadingXLFontSize = 12.sp;
double bottomSheetSubHeadingXFontSize = 11.sp;
double bottomSheetSubHeadingSFontSize = 10.sp;
String bottomSheetSubHeadingBoldFont = kFontBold;
String bottomSheetSubHeadingMediumFont = kFontMedium;
String bottomSheetSubHeadingBookFont = kFontBook;

const bsHeadPinIcon = "assets/images/bs-head-pin.png";
const bsHeadBellIcon = "assets/images/bs-head-bell.png";
const bsHeadBulbIcon = "assets/images/bs-head-bulb.png";
const bsHeadStarsIcon = "assets/images/bs-head-stars.png";

TextStyle mainTextField() {
  return TextStyle(
    fontFamily: kFontMedium,
    color: gTextColor,
    fontSize: subHeadingFont,
  );
}

TextStyle listMainHeading() {
  return TextStyle(
    fontFamily: kFontBold,
    color: gTextColor,
    fontSize: headingFont,
  );
}

TextStyle listSubHeading() {
  return TextStyle(
    fontFamily: kFontMedium,
    color: gTextColor,
    fontSize: subHeadingFont,
  );
}
TextStyle otherText() {
  return TextStyle(
    fontFamily: kFontBook,
    color: gHintTextColor,
    fontSize: smTextFontSize,
  );
}

TextStyle otherText9({Color? fontColor}) {
  return TextStyle(
    fontFamily: kFontBook,
    color: fontColor ?? gTextColor,
    fontSize: smText9FontSize,
  );
}

// existing user
class eUser{
  var kRadioButtonColor = gsecondaryColor;
  var threeBounceIndicatorColor = gWhiteColor;

  var mainHeadingColor = gBlackColor;
  var mainHeadingFont = kFontBold;
  double mainHeadingFontSize = 13.sp;

  var userFieldLabelColor =  gBlackColor;
  var userFieldLabelFont = kFontMedium;
  double userFieldLabelFontSize = 11.sp;
  /*
  fontFamily: "GothamBook",
  color: gHintTextColor,
  fontSize: 11.sp
   */
  var userTextFieldColor =  gHintTextColor;
  var userTextFieldFont = kFontBook;
  double userTextFieldFontSize = 11.sp;

  var userTextFieldHintColor =  Colors.grey.withOpacity(0.5);
  var userTextFieldHintFont = kFontMedium;
  double userTextFieldHintFontSize = 10.sp;

  var focusedBorderColor = gBlackColor;
  var focusedBorderWidth = 1.5;

  var fieldSuffixIconColor = gPrimaryColor;
  var fieldSuffixIconSize = 22;

  var fieldSuffixTextColor =  gBlackColor.withOpacity(0.5);
  var fieldSuffixTextFont = kFontMedium;
  double fieldSuffixTextFontSize = 8.sp;

  var resendOtpFontSize = 9.sp;
  var resendOtpFont = kFontBook;
  var resendOtpFontColor = gsecondaryColor;

  var buttonColor = kButtonColor;
  var buttonTextColor = gWhiteColor;
  double buttonTextSize = 12.sp;
  var buttonTextFont = kFontBold;
  var buttonBorderColor = kLineColor;
  double buttonBorderWidth = 1;



  var buttonBorderRadius = 30.0;

  var loginDummyTextColor =  Colors.black87;
  var loginDummyTextFont = kFontBook;
  double loginDummyTextFontSize = 9.sp;

  var anAccountTextColor =  gHintTextColor;
  var anAccountTextFont = kFontMedium;
  double anAccountTextFontSize = 10.sp;

  var loginSignupTextColor =  gsecondaryColor;
  var loginSignupTextFont = kFontBold;
  double loginSignupTextFontSize = 10.5.sp;

}

class PPConstants{
  final bgColor = Color(0xffFAFAFA).withOpacity(1);

  var kDayText = gBlackColor;
  double kDayTextFontSize = 13.sp;
  var kDayTextFont = kFontBold;

  var topViewHeadingText = gBlackColor;
  double topViewHeadingFontSize = 12.sp;
  var topViewHeadingFont = kFontMedium;

  var topViewSubText = gBlackColor.withOpacity(0.5);
  double topViewSubFontSize = 9.sp;
  var topViewSubFont = kFontBook;

  var kBottomViewHeadingText = gsecondaryColor;
  double kBottomViewHeadingFontSize = 12.sp;
  var kBottomViewHeadingFont = kFontMedium;

  var kBottomViewSubText = gHintTextColor;
  double kBottomViewSubFontSize = 8.5.sp;
  var kBottomViewSubFont = kFontBook;

  var kBottomViewSuffixText = gBlackColor.withOpacity(0.5);
  double kBottomViewSuffixFontSize = 8.sp;
  var kBottomViewSuffixFont = kFontBook;

  var kBottomSheetHeadingText = gsecondaryColor;
  double kBottomSheetHeadingFontSize = 12.sp;
  var kBottomSheetHeadingFont = kFontMedium;

  /// this is for benefits answer
  var kBottomSheetBenefitsText = gBlackColor;
  /// this is for benefits answer
  double kBottomSheetBenefitsFontSize = 10.sp;
  /// this is for benefits answer
  var kBottomSheetBenefitsFont = kFontMedium;

  var threeBounceIndicatorColor = gWhiteColor;
}


class MealPlanConstants{
  var dayBorderColor = Color(0xFFE2E2E2);
  var dayBorderDisableColor = gHintTextColor;
  var dayTextColor = gBlackColor;
  var dayTextSelectedColor = gWhiteColor;
  var dayBgNormalColor = gWhiteColor;
  var dayBgSelectedColor = newDashboardGreenButtonColor;
  var dayBgPresentdayColor = gsecondaryColor;
  double dayBorderRadius = 8.0;
  double presentDayTextSize = 10.sp;
  double DisableDayTextSize = 10.sp;
  var dayTextFontFamily = kFontMedium;
  var dayUnSelectedTextFontFamily = kFontBook;

  var groupHeaderTextColor = gBlackColor;
  var groupHeaderFont = kFontBook;
  double groupHeaderFontSize = 12.sp;

  var mustHaveTextColor = gsecondaryColor;
  var mustHaveFont = kFontBold;
  double mustHaveFontSize = 8.sp;

  var mealNameTextColor = gBlackColor;
  var mealNameFont = kFontMedium;
  double mealNameFontSize = 12.sp;

  var benifitsFont = kFontBook;
  double benifitsFontSize = 10.sp;

}

buildTimeDate({DateTime? dateTime}) {
  DateTime date = dateTime ?? DateTime.now();
  String amPm = 'AM';
  if (date.hour >= 12) {
    amPm = 'PM';
  }
  String hour = date.hour.toString();
  if (date.hour > 12) {
    hour = (date.hour - 12).toString();
  }

  String minute = date.minute.toString();
  if (date.minute < 10) {
    minute = '0${date.minute}';
  }
  return "$hour : $minute $amPm";
}