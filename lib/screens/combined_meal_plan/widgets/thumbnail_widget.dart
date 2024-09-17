import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';

import '../../../widgets/constants.dart';

class ThumbnailWidget extends StatelessWidget {
  final String? thumbnail;
  final String? mealName;
  final String? type;
  final dynamic func;
  const ThumbnailWidget({
    Key? key,
    this.thumbnail,
    this.mealName,
    this.type,
    this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: func,
        child: Stack(
          children: [
            ImageNetwork(
              image: thumbnail ?? '',
              height: 120,
              width: 150,
              duration: 1500,
              // curve: Curves.,
              onPointer: true,
              debugPrint: false,
              fullScreen: false,
              borderRadius: BorderRadius.circular(15),
              fitAndroidIos: BoxFit.fill,
              fitWeb: BoxFitWeb.fill,
              // borderRadius: BorderRadius.circular(70),
              onLoading: const CircularProgressIndicator(
                color: Colors.indigoAccent,
              ),
              onError: Image(
                image: AssetImage(
                  (type != 'item' && type != 'null')
                      ? 'assets/images/yoga_placeholder.png'
                      : 'assets/images/meal_placeholder.png',
                ),
                fit: BoxFit.fill,
              ),
              onTap: func,
            ),
            Positioned(
              top: 0.5.h,
              right:
                  MediaQuery.of(context).size.shortestSide < 600 ? 3.w : 1.5.w,
              child: mealName == "null" || mealName == ""
                  ? const SizedBox()
                  : Container(
                      height: 6.h,
                      width: MediaQuery.of(context).size.shortestSide < 600
                          ? 9.w
                          : 4.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              // AssetImage("assets/images/Lable Green .png"),
                              AssetImage("assets/images/Lable.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Product",
                          style: TextStyle(
                            fontFamily: eUser().userFieldLabelFont,
                            color: eUser().threeBounceIndicatorColor,
                            fontSize: 8.dp,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
