import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../widgets/constants.dart';

class DailyRecommendationDetails extends StatefulWidget {
  final String image;
  final String title;
  final String profile;
  final String name;
  final String time;
  final String description;
  const DailyRecommendationDetails({
    Key? key,
    required this.image,
    required this.title,
    required this.profile,
    required this.name,
    required this.time, required this.description,
  }) : super(key: key);

  @override
  State<DailyRecommendationDetails> createState() =>
      _DailyRecommendationDetailsState();
}

class _DailyRecommendationDetailsState
    extends State<DailyRecommendationDetails> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.fill),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.h, left: 4.w, right: 2.w,top: 2.h),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: kBigCircleBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: gBlackColor,
                              size: 2.h,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.5.h, right: 0.w),
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().mainHeadingFont,
                            fontSize: eUser().mainHeadingFontSize,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 1.5.h,
                            backgroundImage: NetworkImage(
                              widget.profile,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            widget.name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: eUser().threeBounceIndicatorColor,
                              fontFamily: eUser().userFieldLabelFont,
                              fontSize: eUser().userFieldLabelFontSize,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: gWhiteColor,
                                size: 2.h,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                widget.time,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: eUser().threeBounceIndicatorColor,
                                  fontFamily: eUser().userFieldLabelFont,
                                  fontSize: eUser().userFieldLabelFontSize,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 45.h,
            left: 0,
            right: 0,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 71.h,
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
                decoration: const BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.description,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          height: 1.5,
                          color: eUser().mainHeadingColor,
                          fontFamily: eUser().userFieldLabelFont,
                          fontSize: eUser().userFieldLabelFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
