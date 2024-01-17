import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import '../../model/new_user_model/about_program_model/feeds_model/feedsListModel.dart';
import '../../widgets/constants.dart';
import 'package:get/get.dart';
import 'daily_recommendation_details.dart';

class DailyRecommendation extends StatefulWidget {
  final List<FeedsListModel> blogList;
  const DailyRecommendation({Key? key, required this.blogList})
      : super(key: key);

  @override
  State<DailyRecommendation> createState() => _DailyRecommendationState();
}

class _DailyRecommendationState extends State<DailyRecommendation>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String? badgeNotification;

  @override
  void initState() {
    super.initState();
    loadAsset('placeholder.png');
    tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    tabController?.dispose();
  }

  ByteData? placeHolderImage;

  void loadAsset(String name) async {
    var data = await rootBundle.load('assets/images/$name');
    setState(() => placeHolderImage = data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 3.w, top: 1.h),
          child: Text(
            "Your Daily",
            style: TextStyle(
              color: eUser().userTextFieldHintColor,
              fontFamily: eUser().userFieldLabelFont,
              fontSize: eUser().mainHeadingFontSize,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3.w, top: 0.5.h, bottom: 0.5.h),
          child: Text(
            "Recommendation",
            style: TextStyle(
              color: eUser().mainHeadingColor,
              fontFamily: eUser().mainHeadingFont,
              fontSize: eUser().mainHeadingFontSize,
            ),
          ),
        ),
        buildDailyList(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: TabBar(
            controller: tabController,
            labelColor: eUser().userFieldLabelColor,
            unselectedLabelColor: eUser().userTextFieldColor,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            isScrollable: true,
            indicatorColor: gsecondaryColor,
            labelStyle: TextStyle(
              fontFamily: kFontMedium,
              color: gPrimaryColor,
              fontSize: 12.sp,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: kFontBook,
              color: gHintTextColor,
              fontSize: 10.sp,
            ),
            labelPadding:
                EdgeInsets.only(right: 10.w, left: 3.w, top: 1.h, bottom: 1.h),
            indicatorPadding: EdgeInsets.only(right: 8.w),
            tabs: const [
              Text('Top'),
              Text('Popular'),
              Text('Trending'),
              Text('Editor Choice'),
            ],
          ),
        ),
        Container(
          height: 1,
          margin: EdgeInsets.only(left: 7.w, bottom: 1.h, right: 5.w),
          color: kLineColor.withOpacity(0.3),
          width: double.maxFinite,
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              buildTop(),
              buildPopular(),
              buildTrending(),
              buildEditorChoice(),
            ],
          ),
        ),
      ],
    );
    //   SafeArea(
    //   child: Scaffold(
    //     body: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.only(left: 2.w, bottom: 1.h, top: 1.h),
    //           child: buildAppBar(
    //             () {},
    //             badgeNotification: badgeNotification,
    //             showNotificationIcon: true,
    //             isBackEnable: true,
    //             showLogo: true,
    //             showChild: true,
    //             notificationOnTap: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (_) => const NotificationScreen(),
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(left: 3.w),
    //           child: Text(
    //             "Your Daily",
    //             style: TextStyle(
    //               color: eUser().userTextFieldHintColor,
    //               fontFamily: eUser().userFieldLabelFont,
    //               fontSize: eUser().mainHeadingFontSize,
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(left: 3.w, top: 0.5.h, bottom: 0.5.h),
    //           child: Text(
    //             "Recommendation",
    //             style: TextStyle(
    //               color: eUser().mainHeadingColor,
    //               fontFamily: eUser().mainHeadingFont,
    //               fontSize: eUser().mainHeadingFontSize,
    //             ),
    //           ),
    //         ),
    //         buildDailyList(),
    //         TabBar(
    //           controller: tabController,
    //           labelColor: eUser().userFieldLabelColor,
    //           unselectedLabelColor: eUser().userTextFieldColor,
    //           padding: EdgeInsets.symmetric(horizontal: 3.w),
    //           isScrollable: true,
    //           indicatorColor: gsecondaryColor,
    //           labelStyle: TextStyle(
    //             fontFamily: kFontMedium,
    //             color: gPrimaryColor,
    //             fontSize: 12.sp,
    //           ),
    //           unselectedLabelStyle: TextStyle(
    //             fontFamily: kFontBook,
    //             color: gHintTextColor,
    //             fontSize: 10.sp,
    //           ),
    //           labelPadding: EdgeInsets.only(
    //               right: 10.w, left: 3.w, top: 1.h, bottom: 1.h),
    //           indicatorPadding: EdgeInsets.only(right: 8.w),
    //           tabs: const [
    //             Text('Top'),
    //             Text('Popular'),
    //             Text('Trending'),
    //             Text('Editor Choice'),
    //           ],
    //         ),
    //         Container(
    //           height: 1,
    //           margin: EdgeInsets.only(left: 5.w,bottom: 1.h),
    //           color: kLineColor.withOpacity(0.3),
    //           width: double.maxFinite,
    //         ),
    //         Expanded(
    //           child: TabBarView(
    //             controller: tabController,
    //             // physics: const NeverScrollableScrollPhysics(),
    //             children: [
    //               buildTop(),
    //               buildPopular(),
    //               buildTrending(),
    //               buildEditorChoice(),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  buildDailyList() {
    return Container(
      height: 25.h,
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 0.h, left: 5.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.blogList.length,
        itemBuilder: ((context, index) {
          return widget.blogList[index].feed?.isFeed == "4"
              ? GestureDetector(
                  onTap: () {
                    Get.to(
                      () => DailyRecommendationDetails(
                        image: "${widget.blogList[index].feed?.photo}",
                        title: "${widget.blogList[index].feed?.title}",
                        profile: "${widget.blogList[index].feed?.thumbnail}",
                        name: "${widget.blogList[index].feed?.addedBy?.name}",
                        time: "${widget.blogList[index].ago}",
                        description:
                            "${widget.blogList[index].feed?.description}",
                      ),
                    );
                  },
                  child: Container(
                    width: 53.w,
                    margin: EdgeInsets.only(top: 2.h, right: 6.w, bottom: 3.h),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "${widget.blogList[index].feed?.photo}"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: gGreyColor.withOpacity(0.3),
                          offset: const Offset(3, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.only(bottom: 1.h, left: 4.w, right: 2.w),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 3.h, right: 2.w),
                            child: Text(
                              "${widget.blogList[index].feed?.title}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: eUser().threeBounceIndicatorColor,
                                fontFamily: eUser().mainHeadingFont,
                                fontSize: eUser().buttonTextSize,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 1.w),
                              CircleAvatar(
                                radius: 1.3.h,
                                backgroundImage: NetworkImage(
                                  "${widget.blogList[index].feed?.thumbnail}",
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  "${widget.blogList[index].feed?.addedBy?.name}",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: eUser().threeBounceIndicatorColor,
                                    fontFamily: eUser().userFieldLabelFont,
                                    fontSize: eUser().userTextFieldHintFontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        }),
      ),
    );
  }

  buildTop() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.blogList.length,
      itemBuilder: ((context, index) {
        return widget.blogList[index].feed?.isFeed == "3"
            ? Container(
                height: 15.h,
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                      width: 22.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.memoryNetwork(
                          placeholder: placeHolderImage!.buffer.asUint8List(),
                          image: "${widget.blogList[index].feed?.photo}",
                          fit: BoxFit.fill,
                          width: 28.w,
                          // height: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.blogList[index].feed?.title}",
                              style: TextStyle(
                                color: eUser().mainHeadingColor,
                                fontFamily: eUser().mainHeadingFont,
                                fontSize: eUser().mainHeadingFontSize,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 1.5.h,
                                  backgroundImage: NetworkImage(
                                    "${widget.blogList[index].feed?.thumbnail}",
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  "${widget.blogList[index].feed?.addedBy?.name}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: eUser().userTextFieldHintColor,
                                    fontFamily: eUser().userFieldLabelFont,
                                    fontSize: eUser().userTextFieldHintFontSize,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color: gGreyColor.withOpacity(0.5),
                                      size: 2.h,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      "${widget.blogList[index].ago}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: eUser().userTextFieldHintColor,
                                        fontFamily: eUser().userFieldLabelFont,
                                        fontSize:
                                            eUser().userTextFieldHintFontSize,
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
                  ],
                ),
              )
            : const SizedBox();
      }),
    );
  }

  buildPopular() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.blogList.length,
      itemBuilder: ((context, index) {
        return widget.blogList[index].feed?.isFeed == "3"
            ? Container(
                height: 15.h,
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                      width: 22.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.memoryNetwork(
                          placeholder: placeHolderImage!.buffer.asUint8List(),
                          image: "${widget.blogList[index].feed?.photo}",
                          fit: BoxFit.fill,
                          width: 28.w,
                          // height: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.blogList[index].feed?.title}",
                              style: TextStyle(
                                color: eUser().mainHeadingColor,
                                fontFamily: eUser().mainHeadingFont,
                                fontSize: eUser().mainHeadingFontSize,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 1.5.h,
                                  backgroundImage: NetworkImage(
                                    "${widget.blogList[index].feed?.thumbnail}",
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  "${widget.blogList[index].feed?.addedBy?.name}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: eUser().userTextFieldHintColor,
                                    fontFamily: eUser().userFieldLabelFont,
                                    fontSize: eUser().userTextFieldHintFontSize,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color: gGreyColor.withOpacity(0.5),
                                      size: 2.h,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      "${widget.blogList[index].ago}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: eUser().userTextFieldHintColor,
                                        fontFamily: eUser().userFieldLabelFont,
                                        fontSize:
                                            eUser().userTextFieldHintFontSize,
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
                  ],
                ),
              )
            : const SizedBox();
      }),
    );
  }

  buildTrending() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.blogList.length,
      itemBuilder: ((context, index) {
        return widget.blogList[index].feed?.isFeed == "3"
            ? Container(
                height: 15.h,
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                      width: 22.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.memoryNetwork(
                          placeholder: placeHolderImage!.buffer.asUint8List(),
                          image: "${widget.blogList[index].feed?.photo}",
                          fit: BoxFit.fill,
                          width: 28.w,
                          // height: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.blogList[index].feed?.title}",
                              style: TextStyle(
                                color: eUser().mainHeadingColor,
                                fontFamily: eUser().mainHeadingFont,
                                fontSize: eUser().mainHeadingFontSize,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 1.5.h,
                                  backgroundImage: NetworkImage(
                                    "${widget.blogList[index].feed?.thumbnail}",
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  "${widget.blogList[index].feed?.addedBy?.name}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: eUser().userTextFieldHintColor,
                                    fontFamily: eUser().userFieldLabelFont,
                                    fontSize: eUser().userTextFieldHintFontSize,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color: gGreyColor.withOpacity(0.5),
                                      size: 2.h,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      "${widget.blogList[index].ago}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: eUser().userTextFieldHintColor,
                                        fontFamily: eUser().userFieldLabelFont,
                                        fontSize:
                                            eUser().userTextFieldHintFontSize,
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
                  ],
                ),
              )
            : const SizedBox();
      }),
    );
  }

  buildEditorChoice() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.blogList.length,
      itemBuilder: ((context, index) {
        return widget.blogList[index].feed?.isFeed == "3"
            ? Container(
                height: 15.h,
                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                      width: 22.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.memoryNetwork(
                          placeholder: placeHolderImage!.buffer.asUint8List(),
                          image: "${widget.blogList[index].feed?.photo}",
                          fit: BoxFit.fill,
                          width: 28.w,
                          // height: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.blogList[index].feed?.title}",
                              style: TextStyle(
                                color: eUser().mainHeadingColor,
                                fontFamily: eUser().mainHeadingFont,
                                fontSize: eUser().mainHeadingFontSize,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 1.5.h,
                                  backgroundImage: NetworkImage(
                                    "${widget.blogList[index].feed?.thumbnail}",
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  "${widget.blogList[index].feed?.addedBy?.name}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: eUser().userTextFieldHintColor,
                                    fontFamily: eUser().userFieldLabelFont,
                                    fontSize: eUser().userTextFieldHintFontSize,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color: gGreyColor.withOpacity(0.5),
                                      size: 2.h,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      "${widget.blogList[index].ago}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: eUser().userTextFieldHintColor,
                                        fontFamily: eUser().userFieldLabelFont,
                                        fontSize:
                                            eUser().userTextFieldHintFontSize,
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
                  ],
                ),
              )
            : const SizedBox();
      }),
    );
  }
}
