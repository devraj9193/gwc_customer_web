import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../widgets/constants.dart';

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

ListTile buildButtons(String title,  String image, func,
    {bool isIcon = false,IconData? icons,}) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        color: kTextColor,
        fontFamily: kFontBook,
        fontSize: 14.dp,
      ),
    ),
    leading: isIcon
        ? Icon(
            icons,
            color: gBlackColor,
            size: 4.h,
          )
        : Image(
            image: AssetImage(image),
            height: 4.5.h,
          ),
    onTap: func,
  );
}