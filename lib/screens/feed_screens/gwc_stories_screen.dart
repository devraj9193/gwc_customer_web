import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';

import '../../widgets/constants.dart';

class GWCStoriesScreen extends StatefulWidget {
  const GWCStoriesScreen({Key? key}) : super(key: key);

  @override
  State<GWCStoriesScreen> createState() => _GWCStoriesScreenState();
}

class _GWCStoriesScreenState extends State<GWCStoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              fontFamily: "GothamMedium", color: gWhiteColor, fontSize: 8.sp),
          fullpageVisitedColor: gsecondaryColor,
          fullpageUnisitedColor: gWhiteColor,
          fullpageThumbnailSize: 40,
          autoPlayDuration:const Duration(milliseconds: 3000),
          onPageChanged: () {},
          storyCircleTextStyle: TextStyle(
              fontFamily: "GothamMedium", color: gPrimaryColor, fontSize: 8.sp),
          storyItemList: [
            StoryItem(
                name: "GWC",
                thumbnail: const AssetImage(
                  "assets/images/closeup-content-attractive-indian-business-lady.png",
                ),
                stories: [
                  Scaffold(
                    body: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:   AssetImage(
                            "assets/images/closeup-content-attractive-indian-business-lady.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Scaffold(
                    body: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:   AssetImage(
                            "assets/images/placeholder.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
            StoryItem(
              name: "Fembuddy",
              thumbnail: const AssetImage(
                "assets/images/progress_logo.png",
              ),
              stories: [
                Scaffold(
                  body: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:   AssetImage(
                          "assets/images/placeholder.png",
                        ),
                      ),
                    ),
                  ),
                ),
                 Scaffold(
                  backgroundColor: gHintTextColor,
                  body: Center(
                    child: Text(
                      "Gut Wellness Club",
                      style: TextStyle(
                        color: gWhiteColor,
                        fontSize: 15.sp,
                        fontFamily: "GothamBold"
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
