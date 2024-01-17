import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:stories_for_flutter/stories_for_flutter.dart';
import '../../../model/new_user_model/about_program_model/feeds_model/feedsListModel.dart';
import '../../../widgets/constants.dart';

class HomeStory extends StatefulWidget {
  final List<FeedsListModel> storyList;
  const HomeStory({Key? key, required this.storyList}) : super(key: key);

  @override
  State<HomeStory> createState() => _HomeStoryState();
}

class _HomeStoryState extends State<HomeStory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          Text(
            "How your feels today !!",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: eUser().mainHeadingColor,
              fontFamily: eUser().userFieldLabelFont,
              fontSize: eUser().userFieldLabelFontSize,
            ),
          ),
          SizedBox(height: 1.h),
          Stories(
            circlePadding: 2,
            borderThickness: 2,
            displayProgress: true,
            highLightColor: gMainColor,
            showThumbnailOnFullPage: true,
            storyStatusBarColor: gWhiteColor,
            showStoryName: true,
            showStoryNameOnFullPage: true,
            fullPagetitleStyle: TextStyle(
                fontFamily: kFontMedium, color: gWhiteColor, fontSize: 8.sp),
            fullpageVisitedColor: gsecondaryColor,
            fullpageUnisitedColor: gWhiteColor,
            fullpageThumbnailSize: 40,
            autoPlayDuration: const Duration(milliseconds: 3000),
            onPageChanged: () {},
            storyCircleTextStyle: TextStyle(
                fontFamily: kFontMedium, color: gBlackColor, fontSize: 8.sp),
            storyItemList: widget.storyList
                .map(
                  (e) => StoryItem(
                      name: "${e.feed?.title}",
                      thumbnail: NetworkImage(
                        "${e.feed?.thumbnail}",
                      ),
                      stories: [
                        Scaffold(
                          body: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "${e.image}",
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Scaffold(
                        //   body: Container(
                        //     decoration: const BoxDecoration(
                        //       image: DecorationImage(
                        //         fit: BoxFit.cover,
                        //         image: AssetImage(
                        //           "assets/images/placeholder.png",
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ]),
                )
                .toList(),
          ),
          // Stories(
          //   circlePadding: 2,
          //   borderThickness: 1,
          //   displayProgress: true,
          //   highLightColor: gMainColor,
          //   spaceBetweenStories: 3.w,
          //   showThumbnailOnFullPage: true,
          //   storyStatusBarColor: gWhiteColor,
          //   showStoryName: true,
          //   showStoryNameOnFullPage: true,
          //   fullPagetitleStyle: TextStyle(
          //       fontFamily: "GothamMedium", color: gWhiteColor, fontSize: 8.sp),
          //   fullpageVisitedColor: gsecondaryColor,
          //   fullpageUnisitedColor: gWhiteColor,
          //   fullpageThumbnailSize: 40,
          //   autoPlayDuration: const Duration(milliseconds: 3000),
          //   onPageChanged: () {},
          //   storyCircleTextStyle: TextStyle(
          //       fontFamily: "GothamMedium", color: gBlackColor, fontSize: 8.sp),
          //   storyItemList: [
          //     StoryItem(
          //         name: "Smoothie",
          //         thumbnail: const AssetImage(
          //           "assets/images/gmg/midDay.png",
          //         ),
          //         stories: [
          //           Scaffold(
          //             body: Container(
          //               decoration: const BoxDecoration(
          //                 image: DecorationImage(
          //                   fit: BoxFit.cover,
          //                   image: AssetImage(
          //                     "assets/images/gmg/midDay.png",
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Scaffold(
          //             body: Container(
          //               decoration: const BoxDecoration(
          //                 image: DecorationImage(
          //                   fit: BoxFit.cover,
          //                   image: AssetImage(
          //                     "assets/images/placeholder.png",
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ]),
          //     StoryItem(
          //       name: "Recipes",
          //       thumbnail: const AssetImage(
          //         "assets/images/mini-idli-is.jpg",
          //       ),
          //       stories: [
          //         Scaffold(
          //           body: Container(
          //             decoration: const BoxDecoration(
          //               image: DecorationImage(
          //                 fit: BoxFit.cover,
          //                 image: AssetImage(
          //                   "assets/images/mini-idli-is.jpg",
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Scaffold(
          //           backgroundColor: gHintTextColor,
          //           body: Center(
          //             child: Text(
          //               "Gut Wellness Club",
          //               style: TextStyle(
          //                   color: gWhiteColor,
          //                   fontSize: 15.sp,
          //                   fontFamily: "GothamBold"),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     StoryItem(
          //         name: "Herbs",
          //         thumbnail: const AssetImage(
          //           "assets/images/pizza.png",
          //         ),
          //         stories: [
          //           Scaffold(
          //             body: Container(
          //               decoration: const BoxDecoration(
          //                 image: DecorationImage(
          //                   fit: BoxFit.cover,
          //                   image: AssetImage(
          //                     "assets/images/pizza.png",
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Scaffold(
          //             body: Container(
          //               decoration: const BoxDecoration(
          //                 image: DecorationImage(
          //                   fit: BoxFit.cover,
          //                   image: AssetImage(
          //                     "assets/images/placeholder.png",
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ]),
          //     StoryItem(
          //       name: "Spices",
          //       thumbnail: const AssetImage(
          //         "assets/images/Mask Group 2171.png",
          //       ),
          //       stories: [
          //         Scaffold(
          //           body: Container(
          //             decoration: const BoxDecoration(
          //               image: DecorationImage(
          //                 fit: BoxFit.cover,
          //                 image: AssetImage(
          //                   "assets/images/Mask Group 2171.png",
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Scaffold(
          //           backgroundColor: gHintTextColor,
          //           body: Center(
          //             child: Text(
          //               "Gut Wellness Club",
          //               style: TextStyle(
          //                   color: gWhiteColor,
          //                   fontSize: 15.sp,
          //                   fontFamily: "GothamBold"),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
