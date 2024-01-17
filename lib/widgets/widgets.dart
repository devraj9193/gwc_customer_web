import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'constants.dart';
import 'package:im_animations/im_animations.dart';

class CommonDecoration {
  static InputDecoration buildInputDecoration(
      String hintText, TextEditingController controller,
      {Widget? suffixIcon}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            fontFamily: "GothamBook", color: gTextColor, fontSize: 10.dp),
        border: InputBorder.none,
        suffixIcon: suffixIcon
        // controller.text.isEmpty
        //     ? Container(
        //         width: 0,
        //       )
        //     : IconButton(
        //         onPressed: () {
        //           controller.clear();
        //         },
        //         icon: const Icon(
        //           Icons.close,
        //           color: kPrimaryColor,
        //         ),
        //       ),
        );
  }

  static InputDecoration buildTextInputDecoration(
      String hintText, TextEditingController controller,
      {Widget? suffixIcon,
      InputBorder? enabledBorder,
      InputBorder? focusBoder}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          fontFamily: eUser().userTextFieldHintFont,
          fontSize: eUser().userTextFieldHintFontSize,
          color: eUser().userTextFieldHintColor),
      counterText: "",
      border: const UnderlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 1.0, style: BorderStyle.solid),
      ),
      suffixIcon: suffixIcon,
      enabledBorder: enabledBorder,
      focusedBorder: focusBoder,
    );
  }
}

// ignore: duplicate_ignore
class CommonButton {
  static ElevatedButton sendButton(func, String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: gPrimaryColor,
        onSurface: kSecondaryColor,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 25.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "GothamRoundedBold",
          color: Colors.white,
          fontSize: 13.dp,
        ),
      ),
      onPressed: func,
    );
  }

  // ignore: deprecated_member_use
  static ElevatedButton submitButton(func, String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: gPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 20.w),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "GothamRoundedBold",
          color: Colors.white,
          fontSize: 13.dp,
        ),
      ),
      onPressed: func,
    );
  }
}

TextStyle buildTextStyle({Color? color, String? fontFamily}) {
  return TextStyle(
    color: color ?? kTextColor,
    fontSize: 13.dp,
    height: 1.35,
    fontFamily: fontFamily ?? kFontMedium,
  );
}

buildTapCount(String title, int count) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title),
      SizedBox(width: 1.w),
      count == 0
          ? const SizedBox()
          : Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: kNumberCircleRed,
          shape: BoxShape.circle,
        ),
        child: Text(
          count.toString(),
          style: TextStyle(
            fontSize: 7.dp,
            fontFamily: "GothamMedium",
            color: gWhiteColor,
          ),
        ),
      )
    ],
  );
}


// Center buildCircularIndicator() {
//   return Center(
//     child: SpinKitFadingCircle(
//         itemBuilder: (BuildContext context, int index) {
//           return DecoratedBox(
//             decoration: BoxDecoration(
//               color: index.isEven ? gPrimaryColor : gMainColor,
//             ),
//           );
//         }
//     )
//   );
// }

buildCircularIndicator() {
  return Center(
    child: HeartBeat(
        child: Image.asset(
      'assets/images/progress_logo.png',
      width: 75,
      height: 75,
    )),
  );
}

buildThreeBounceIndicator({Color? color}) {
  return Center(
    child: SpinKitThreeBounce(
      color: color ?? gMainColor,
      size: 30,
    ),
  );
}

SnackbarController buildSnackBar(String title, String subTitle) {
  return Get.snackbar(
    title,
    subTitle,
    titleText: Text(
      title,
      style: TextStyle(
        fontFamily: "PoppinsSemiBold",
        color: kWhiteColor,
        fontSize: 13.dp,
      ),
    ),
    messageText: Text(
      subTitle,
      style: TextStyle(
        fontFamily: "PoppinsMedium",
        color: kWhiteColor,
        fontSize: 12.dp,
      ),
    ),
    backgroundColor: kPrimaryColor.withOpacity(0.5),
    snackPosition: SnackPosition.BOTTOM,
    colorText: kWhiteColor,
    margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
    borderRadius: 10,
    duration: const Duration(seconds: 2),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.decelerate,
  );
}

buildAppBar(
    VoidCallback func, {
      bool isBackEnable = true,
      bool showNotificationIcon = false,
      VoidCallback? notificationOnTap,
      bool showHelpIcon = false,
      VoidCallback? helpOnTap,
      bool showSupportIcon = false,
      VoidCallback? supportOnTap,
      Color? helpIconColor,
      String? badgeNotification,
      bool showLogo = true,
      bool showChild = false,
      Widget? child,
      /// customAction is true than pass action
      bool customAction = false,
      List<Widget>? actions
    })  {

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Visibility(
            visible: isBackEnable,
            child: SizedBox(
              width: 2.h,
              child: IconButton(
                onPressed: func,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: gMainColor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 1.5.w,
          ),
          Visibility(
            visible: showLogo,
            child: SizedBox(
              height: 6.h,
              child: const Image(
                image: AssetImage("assets/images/Gut welness logo.png"),
              ),
              //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
            ),
          ),
          Visibility(
            visible: showChild,
            child: child ?? const SizedBox(),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: (customAction) ? actions ?? [] : [
          Visibility(
            visible: showNotificationIcon,
            child: GestureDetector(
              child: badgeNotification == "1"
                  ? buildCustomBadge(
                child: Icon(
                  Icons.notifications,
                  color: gHintTextColor,
                ),
                // child: Icon(Icons.notifications,color: gHintTextColor,)
                // SvgPicture.asset(
                //   "assets/images/Notification.svg",
                //   height: 2.5.h,
                //   color: gHintTextColor,
                // ),
              )
                  : Icon(
                Icons.notifications,
                color: gHintTextColor,
              ),
              onTap: notificationOnTap,
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Visibility(
            visible: showHelpIcon,
            child: GestureDetector(
              child: ImageIcon(
                AssetImage("assets/images/new_ds/help.png"),
                color: helpIconColor ?? gHintTextColor,
              ),
              onTap: helpOnTap,
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Visibility(
            visible: showSupportIcon,
            child: GestureDetector(
              child: ImageIcon(
                AssetImage("assets/images/new_ds/support.png"),
                color: gHintTextColor,
              ),
              onTap: supportOnTap,
            ),
          ),
        ],
      )
    ],
  );
}

buildLabelTextField(String name,
    {double? fontSize, double textScleFactor = 0.9, Key? key}) {
  return RichText(
    key: key,
      textScaleFactor: textScleFactor,
      text: TextSpan(
          text: name,
          style: TextStyle(
            fontSize: fontSize ?? 13.dp,
            color: gBlackColor,
            height: 1.35,
            fontFamily: kFontMedium,
          ),
          children: [
            TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 13.dp,
                color: kPrimaryColor,
                fontFamily: "PoppinsSemiBold",
              ),
            )
          ]));
  return Text(
    'Full Name:*',
    style: TextStyle(
      fontSize: 9.dp,
      color: kTextColor,
      fontFamily: "PoppinsSemiBold",
    ),
  );
}

Future<CroppedFile?> cropSelectedImage(String filePath) async {
  return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
            toolbarColor: gBlackColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
  );
}

showDialogWidget(
  BuildContext context,
  String topWidgetText,
  String okButtonText, {
  bool isSingleButton = true,
  bool barrierClose = true,
  required VoidCallback okButtonClick,
  String? belowWidgetText,
  String? cancelButtonText,
  VoidCallback? cancelButtonClick,
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierClose,
      builder: (context) => AlertDialog(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0.dp))),
            contentPadding: EdgeInsets.only(top: 1.h),
            content: Container(
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0.dp), bottomLeft: Radius.circular(15.0.dp)),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              width: 50.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(topWidgetText ?? 'Are you sure?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16.dp,
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Visibility(
                    visible: belowWidgetText != null,
                    child: Padding(
                        padding: EdgeInsets.only(left: 4.w, right: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  2.w, 1.h, 2.w, 1.h),
                              child: Text(belowWidgetText ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 15.dp,
                                  )),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 2.w, bottom: 1.w),
                    child: (!isSingleButton)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: cancelButtonClick,
                                child: Container(
                                    padding: EdgeInsets.all(7.dp),
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Text(cancelButtonText ?? "NO",
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 12.dp,
                                        ))),
                              ),
                              SizedBox(width: 3.w),
                              GestureDetector(
                                onTap: okButtonClick,
                                child: Container(
                                    padding: EdgeInsets.all(7.dp),
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Text(okButtonText,
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 12.dp,
                                        ))),
                              )
                            ],
                          )
                        : GestureDetector(
                            onTap: okButtonClick,
                            child: Container(
                                padding: EdgeInsets.all(7.dp),
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(3)),
                                child: Text(okButtonText,
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 12.dp,
                                    ))),
                          ),
                  ),
                ],
              ),
            ),
          ));
}

// AppBar buildAppBar(String title, VoidCallback fun) {
//   return AppBar(
//     elevation: 0.0,
//     backgroundColor: kContentColor,
//     automaticallyImplyLeading: false,
//     title: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             InkWell(
//               onTap: fun,
//               child: const Icon(
//                 Icons.chevron_left,
//                 color: kSecondaryColor,
//               ),
//             ),
//             SizedBox(width: 1.w),
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: "PoppinsMedium",
//                 fontSize: 13.dp,
//                 color: kPrimaryColor,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           width: 25.w,
//           height: 5.h,
//           child: SvgPicture.asset(
//             'assets/images/ResiLink_Logo_with_Tagline_RGB.svg',
//             fit: BoxFit.fill,
//           ),
//         ),
//       ],
//     ),
//   );
//}

// --- New Changes Widgets --- //

buildNewAppBar(VoidCallback func,
    {bool isBackEnable = true,
    bool showNotificationIcon = false,
    VoidCallback? notificationOnTap,
    bool showHelpIcon = false,
    VoidCallback? helpOnTap,
    bool showSupportIcon = false,
    VoidCallback? supportOnTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Visibility(
            visible: isBackEnable,
            child: GestureDetector(
              onTap: func,
              child: Container(
                padding:  EdgeInsets.only(top: 0.8.h,bottom: 0.8.h,left: 1.w,right: 1.5.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: gMainColor, width: 2),
                ),
                child: Image(
                  height: 1.5.h,
                  image:const
                      AssetImage("assets/images/Icon ionic-ios-arrow-back.png"),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 6.h,
            child: const Image(
              image: AssetImage("assets/images/Gut welness logo.png"),
            ),
            //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: showNotificationIcon,
            child: GestureDetector(
              child: ImageIcon(
                AssetImage("assets/images/new_ds/notification.png"),
                color: gHintTextColor,
              ),
              onTap: notificationOnTap,
            ),
          ),
          SizedBox(
            width: 3.25.w,
          ),
          Visibility(
            visible: showHelpIcon,
            child: GestureDetector(
              child: ImageIcon(
                AssetImage("assets/images/new_ds/help.png"),
                color: gHintTextColor,
              ),
              onTap: helpOnTap,
            ),
          ),
          SizedBox(
            width: 3.25.w,
          ),
          Visibility(
            visible: showSupportIcon,
            child: GestureDetector(
              child: ImageIcon(
                AssetImage("assets/images/new_ds/support.png"),
                color: gHintTextColor,
              ),
              onTap: supportOnTap,
            ),
          ),
        ],
      )
    ],
  );
}

MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
  // ignore: prefer_function_declarations_over_variables
  final getColor = (Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return colorPressed;
    } else {
      return color;
    }
  };
  return MaterialStateProperty.resolveWith(getColor);
}



Future<File> getCachedPdfViewer(String url) async{
  File? _tempFile;
  final Directory tempPath = await getApplicationDocumentsDirectory();
  final File tempFile = File(tempPath.path + '/${url.split('/').last}');
  final bool checkFileExist = await tempFile.exists();
  if (checkFileExist) {
    _tempFile = tempFile;
  }
  return Future.value(_tempFile);
}

writePdfFile(PdfDocumentLoadedDetails details, String url) async{
  print("writePdfFile");
  final Directory tempPath1 = await getTemporaryDirectory();

  print(tempPath1);

  final Directory tempPath = await getApplicationDocumentsDirectory();
  final _temp = await File(tempPath.path + '/${url.split('/').last}')
      .writeAsBytes(await details.document.save());

  print(_temp.exists());
}


String getDayOfMonthSuffix(int dayNum) {
  if(!(dayNum >= 1 && dayNum <= 31)) {
    throw Exception('Invalid day of month');
  }

  if(dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }

  switch(dayNum % 10) {
    case 1: return 'st';
    case 2: return 'nd';
    case 3: return 'rd';
    default: return 'th';
  }
}

buildCustomBadge({required Widget child}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      child,
      const Positioned(
        top: 2,
        right: 2,
        child: CircleAvatar(
          radius: 4,
          backgroundColor: Colors.blue,
        ),
      ),
    ],
  );
}

Widget landscapeView(ChewieController controller) {
  return OrientationBuilder(
      builder: (_, orientation){
        if(orientation == Orientation.portrait){
          return VideoWidget(controller);
        }
        else{
          return VideoWidget(controller);
        }
      }
  );
}

VideoWidget(ChewieController controller) {
  return LayoutBuilder(
    builder: (_, constraints) {
      print("_chewieController: $controller");
      return Container(
        color: Colors.black,
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Center(
          child: AspectRatio(
            aspectRatio: constraints.maxWidth / constraints.maxHeight,
            child: (controller == null)
                ? Center(
              child: buildCircularIndicator(),
            )
                : Chewie(
              controller: controller!,
            ),
            // child: VlcPlayerWithControls(
            //   key: _key,
            //   controller: _controller!,
            //   virtualDisplay: true,
            //   showVolume: false,
            //   showVideoProgress: true,
            //   seekButtonIconSize: 10.dp,
            //   playButtonIconSize: 14.dp,
            //   replayButtonSize: 14.dp,
            //   showFullscreenBtn: true,
            // )
          ),
        ),
      );
    },
  );
}
