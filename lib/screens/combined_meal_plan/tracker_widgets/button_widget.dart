import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../widgets/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback func;
  const ButtonWidget({Key? key, required this.func, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: IntrinsicWidth(
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.h, right: 5.w),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: gsecondaryColor,
              // onSurface: eUser().buttonTextColor,
              padding:
              EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: func,
            child: Center(
              child: Text(
               title,
                style: TextStyle(
                  fontSize: 13.dp,
                  color: gWhiteColor,
                  height: 1.35,
                  fontFamily: kFontMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
