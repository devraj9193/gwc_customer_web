import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_config.dart';
import 'constants.dart';
import 'exit_widget.dart';

class WillPopWidget extends StatefulWidget {
  final Widget? child;
  const WillPopWidget({Key? key, this.child}) : super(key: key);

  @override
  _WillPopWidgetState createState() => _WillPopWidgetState();
}

class _WillPopWidgetState extends State<WillPopWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: widget.child!,
      onWillPop: _onWillPop,
    );
  }

  moveToScreen() async {
    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    // ignore: avoid_print
    print('back pressed splash');
    return AppConfig().showSheet(context, ExitWidget(), bottomSheetHeight: 45.h, isDismissible: true,) ??
    // return await showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //               backgroundColor: kPrimaryColor,
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.all(Radius.circular(15.0.sp))),
    //               contentPadding: EdgeInsets.only(top: 1.h),
    //               content: Container(
    //           padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
    //           decoration: BoxDecoration(
    //               color: gWhiteColor, borderRadius: BorderRadius.circular(8)),
    //           width: 50.h,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               Text(
    //                 'Are you sure?',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                     fontFamily: "GothamRoundedBold_21016",
    //                     color: gPrimaryColor,
    //                     fontSize: 13.sp),
    //               ),
    //               Container(
    //                 margin: EdgeInsets.symmetric(vertical: 2.h),
    //                 height: 1,
    //                 color: Colors.grey.withOpacity(0.3),
    //               ),
    //               Text(
    //                 'Do you want to exit an App?',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                     fontFamily: "GothamMedium",
    //                     color: gsecondaryColor,
    //                     fontSize: 11.sp),
    //               ),
    //               SizedBox(height: 3.h),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () => Navigator.of(context).pop(false),
    //                     child: Container(
    //                       padding: EdgeInsets.symmetric(
    //                           vertical: 1.h, horizontal: 5.w),
    //                       decoration: BoxDecoration(
    //                           color: gMainColor,
    //                           borderRadius: BorderRadius.circular(5)),
    //                       child: Text(
    //                         "NO",
    //                         style: TextStyle(
    //                           fontFamily: "GothamRoundedBold_21016",
    //                           color: gPrimaryColor,
    //                           fontSize: 11.sp,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(width: 5.w),
    //                   GestureDetector(
    //                     onTap: () => SystemNavigator.pop(),
    //                     child: Container(
    //                       padding: EdgeInsets.symmetric(
    //                           vertical: 1.h, horizontal: 5.w),
    //                       decoration: BoxDecoration(
    //                           color: gPrimaryColor,
    //                           borderRadius: BorderRadius.circular(5)),
    //                       child: Text(
    //                         "YES",
    //                         style: TextStyle(
    //                           fontFamily: "GothamRoundedBold_21016",
    //                           color: gMainColor,
    //                           fontSize: 11.sp,
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //               SizedBox(height: 1.h)
    //             ],
    //           ),
    //         ),
    //             )) ??
        false;
  }

  exitWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("Hold On!",
            style: TextStyle(
                fontSize: bottomSheetHeadingFontSize,
                fontFamily: bottomSheetHeadingFontFamily,
                height: 1.4
            ),
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
            'Do you want to exit an App?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gTextColor,
              fontSize: bottomSheetSubHeadingXFontSize,
              fontFamily: bottomSheetSubHeadingMediumFont,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => SystemNavigator.pop(),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 1.h, horizontal: 12.w),
                decoration: BoxDecoration(
                    color: gsecondaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "YES",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 1.h, horizontal: 12.w),
                decoration: BoxDecoration(
                    color: gWhiteColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "NO",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gsecondaryColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h)
      ],
    );
  }
}
