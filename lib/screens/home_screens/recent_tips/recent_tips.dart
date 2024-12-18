import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../model/new_user_model/about_program_model/feeds_model/feedsListModel.dart';
import '../../../widgets/constants.dart';

class RecentTips extends StatefulWidget {
  final List<FeedsListModel> recentTipsList;
  const RecentTips({Key? key, required this.recentTipsList}) : super(key: key);

  @override
  State<RecentTips> createState() => _RecentTipsState();
}

class _RecentTipsState extends State<RecentTips> {
  // final carouselController = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "Recent Tips",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: eUser().mainHeadingColor,
                fontFamily: eUser().mainHeadingFont,
                fontSize: eUser().buttonTextSize,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 18.h,
            width: double.maxFinite,
            child: CarouselSlider(
              // carouselController: carouselController,
              options: CarouselOptions(
                  viewportFraction: .6,
                  aspectRatio: 1.2,
                  enlargeCenterPage: true,enableInfiniteScroll: false,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: widget.recentTipsList
                  .map(
                    (e) => Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: kNumberCircleRed.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                            "${e.feed?.photo}",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // child: Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(bottom: 1.h),
                      //     child: Text(
                      //       "${e.feed?.title}",
                      //       style: TextStyle(
                      //         color: eUser().threeBounceIndicatorColor,
                      //         fontFamily: eUser().userFieldLabelFont,
                      //         fontSize: eUser().anAccountTextFontSize,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // SizedBox(height: 2.h),
          // Positioned(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: reviewList.map((url) {
          //       int index = reviewList.indexOf(url);
          //       return Container(
          //         width: 8.0,
          //         height: 8.0,
          //         margin: const EdgeInsets.symmetric(
          //             vertical: 4.0, horizontal: 2.0),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: _current == index
          //               ? gsecondaryColor
          //               : kNumberCircleRed.withOpacity(0.3),
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
