import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/web_screens/web_faq_screen.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/web_screens/web_feedback_screen.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/web_screens/web_get_eval.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/web_screens/web_my_reports.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/web_screens/web_my_yoga.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/web_screens/web_profile_details_screen.dart';
import 'package:gwc_customer_web/screens/new_profile_screens/web_screens/web_terms.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/app_config.dart';


class ProfileWebScreen extends StatefulWidget {
  const ProfileWebScreen({Key? key}) : super(key: key);

  @override
  State<ProfileWebScreen> createState() => _ProfileWebScreenState();
}

class _ProfileWebScreenState extends State<ProfileWebScreen> {
  final SharedPreferences pref = AppConfig().preferences!;

  int selectedDetails = 1;
  List<UserModels> details = [
    UserModels(
      id: 1,
      title: "My Profile",
      image: "assets/images/Group 2753.png",
    ),
    UserModels(
      id: 2,
      title: "Evaluation",
      isIcon: true,
      icons: Icons.article_outlined,
    ),
    UserModels(
      id: 3,
      title: "My Reports",
      isIcon: true,
      icons: Icons.file_copy_outlined,
    ),
    UserModels(
      id: 4,
      title: "Feedback",
      isIcon: true,
      icons: Icons.reviews_outlined,
    ),
    UserModels(
      id: 5,
      title: "My Yoga's",
      isIcon: true,
      icons: Icons.self_improvement,
    ),
    UserModels(
      id: 6,
      title: "FAQ",
      image: "assets/images/Group 2747.png",
    ),
    UserModels(
      id: 7,
      title: "Terms & Conditions",
      image: "assets/images/Group 2748.png",
    ),
    // UserModels(
    //   id: 8,
    //   title: "Chat Support",
    //   image: "assets/images/noun-chat-5153452.png",
    // ),
    // UserModels(
    //   id: 9,
    //   title: "Call Support",
    //   image: "assets/images/new_ds/support.png",
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0.h, bottom: 2.h),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: gWhiteColor,
                          border: Border.all(
                            color: gsecondaryColor,
                          ),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 8.h,
                            backgroundImage: NetworkImage(
                              "${pref.getString(AppConfig.User_Profile)}",
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemCount: details.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isSelected =
                              selectedDetails == details[index].id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDetails = details[index].id;
                              });
                            },
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.w, vertical: 1.5.h),
                                margin: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 2.w),
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? gsecondaryColor
                                        : gWhiteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    details[index].isIcon
                                        ? Icon(
                                            details[index].icons,
                                            color: isSelected
                                                ? gWhiteColor
                                                : gBlackColor,
                                            size: 4.h,
                                          )
                                        : Image(
                                            image: AssetImage(
                                              details[index].image.toString(),
                                            ),
                                            color: isSelected
                                                ? gWhiteColor
                                                : gBlackColor,
                                            height: 4.5.h,
                                          ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      details[index].title,
                                      style: TextStyle(
                                        color:
                                            selectedDetails == details[index].id
                                                ? gWhiteColor
                                                : kTextColor,
                                        fontFamily:
                                            selectedDetails == details[index].id
                                                ? kFontMedium
                                                : kFontBook,
                                        fontSize: 14.dp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // buildButtons(
                      //   "Profile",
                      //   "assets/images/Group 2753.png",
                      //   () {},
                      // ),
                      // buildButtons(
                      //   "Evaluation",
                      //   "",
                      //   () {},
                      //   isIcon: true,
                      //   icons: Icons.article_outlined,
                      // ),
                      // buildButtons(
                      //   "My Reports",
                      //   "",
                      //   () {},
                      //   isIcon: true,
                      //   icons: Icons.file_copy_outlined,
                      // ),
                      // buildButtons(
                      //   "Feedback",
                      //   "",
                      //   () {},
                      //   isIcon: true,
                      //   icons: Icons.reviews_outlined,
                      // ),
                      // buildButtons(
                      //   "My Yoga's",
                      //   "",
                      //   () {},
                      //   isIcon: true,
                      //   icons: Icons.self_improvement,
                      // ),
                      // buildButtons(
                      //   "FAQ",
                      //   "assets/images/Group 2747.png",
                      //   () {},
                      // ),
                      // buildButtons(
                      //   "Terms & Conditions",
                      //   "assets/images/Group 2748.png",
                      //   () {},
                      // ),
                      // buildButtons(
                      //   "Chat Support",
                      //   "assets/images/noun-chat-5153452.png",
                      //   () {},
                      // ),
                      // buildButtons(
                      //   "Call Support",
                      //   "assets/images/new_ds/support.png",
                      //   () {},
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 2.w),
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: selectedDetails == 1
                    ? const WebProfileDetailsScreen()
                    : selectedDetails == 2
                        ? const WebGetEval()
                        : selectedDetails == 3
                            ? const WebMyReports()
                            : selectedDetails == 4
                                ? const WebFeedbackScreen()
                                : selectedDetails == 5
                                    ? const WebMyYoga()
                                    : selectedDetails == 6
                                        ? const WebFaqScreen()
                                        : selectedDetails == 7
                                            ? const WebTerms()
                                            : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserModels {
  final int id;
  final String title;
  final String? image;
  final IconData? icons;
  final bool isIcon;

  UserModels({
    required this.id,
    required this.title,
    this.image,
    this.icons,
    this.isIcon = false,
  });
}
