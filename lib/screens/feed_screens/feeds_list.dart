/*
Feed api:
var getAboutProgramUrl = "${AppConfig().BASE_URL}/api/list/welcome_screen";

in the feed api
if feed?.isFeed == "1" than adding to feed list
else if isFeed == "2" added to podcast list

to differentiate mp4, and other format we r checking format field

 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/screens/feed_screens/video_player.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../model/error_model.dart';
import '../../model/new_user_model/about_program_model/about_program_model.dart';
import '../../model/new_user_model/about_program_model/feeds_model/feedsListModel.dart';
import '../../repository/api_service.dart';
import '../../repository/new_user_repository/about_program_repository.dart';
import '../../services/new_user_service/about_program_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../notification_screen.dart';
import 'feeds_details_screen.dart';

class FeedsList extends StatefulWidget {
  const FeedsList({Key? key}) : super(key: key);

  @override
  State<FeedsList> createState() => _FeedsListState();
}

class _FeedsListState extends State<FeedsList> {
  Future? feedsListFuture;
  double? selectedIndex;
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      setState(() {
        selectedIndex = pageController.page;
      });
    });
    getFuture();
    loadAsset('placeholder.png');
    wake();
  }

  wake() async {
    if (await WakelockPlus.enabled == false) {
      WakelockPlus.enable();
    }
  }

  getFuture() {
    feedsListFuture =
        AboutProgramService(repository: repository).serverAboutProgramService();
  }

  @override
  void dispose() async {
    super.dispose();
    pageController.dispose();
    print('dispose');
    if (await WakelockPlus.enabled == true) {
      WakelockPlus.disable();
    }
    // await _videoPlayerController?.stop();
    // await _videoPlayerController?.stopRendererScanning();
    // await _videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {},
                    isBackEnable: false,
                    showNotificationIcon: true, notificationOnTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationScreen()));
                }),
                // SizedBox(height: 3.h),
                Visibility(
                  visible: false,
                  child: buildStories(),
                ),
                TabBar(
                    labelColor: eUser().userFieldLabelColor,
                    unselectedLabelColor: eUser().userTextFieldColor,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    isScrollable: true,
                    indicatorColor: gsecondaryColor,
                    labelStyle: TextStyle(
                        fontFamily: kFontMedium,
                        color: gPrimaryColor,
                        fontSize: 15.dp),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: kFontBook,
                        color: gHintTextColor,
                        fontSize: 12.dp),
                    labelPadding: EdgeInsets.only(
                        right: 10.w, left: 2.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 0.w),
                    tabs: const [
                      Text('Feed'),
                      Text('PodCast'),
                    ]),
                Expanded(
                  child: TabBarView(children: [
                    buildFeed(context),
                    buildPodCast(),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ByteData? placeHolderImage;

  void loadAsset(String name) async {
    var data = await rootBundle.load('assets/images/$name');
    setState(() => placeHolderImage = data);
  }

  buildFeed(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          children: [
            Container(
              height: 1,
              color: kLineColor.withOpacity(0.3),
              width: double.maxFinite,
            ),
            FutureBuilder(
                future: feedsListFuture,
                builder: (_, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data.runtimeType == ErrorModel) {
                        final model = snapshot.data as ErrorModel;
                        return Center(
                          child: Text(model.message ?? ''),
                        );
                      } else {
                        final model = snapshot.data as AboutProgramModel;
                        List<FeedsListModel> list = model.data?.feedsList ?? [];
                        print("list.length:${list.length}");
                        // list.forEach((element) {
                        //   print(element.feed!.thumbnail);
                        // });
                        if (list.isEmpty) {
                          return const Center(
                            child: Text("NO Feeds"),
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: ((context, index) {
                              final a = list[index].image?[0];
                              final file = a?.split(".").last;
                              String format = file.toString();
                              final String subText =
                                  "${list[index].feed?.description}";
                              return (list[index].feed?.isFeed == "1")
                                  ? format == "mp4"
                                      ? Container(
                                          height: 17.h,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 1.h),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.h, horizontal: 3.w),
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            color: gWhiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: const Offset(2, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                // height: 15.h,
                                                //  width: 30.w,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                    placeholder:
                                                        placeHolderImage!.buffer
                                                            .asUint8List(),
                                                    image:
                                                        "${list[index].feed?.thumbnail}",
                                                    fit: BoxFit.fill,
                                                    width: 28.w,
                                                    // height: 10.h,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 1.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      list[index].feed?.title ??
                                                          "Lorem",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 11.dp,
                                                          height: 1.5,
                                                          fontFamily:
                                                              kFontMedium,
                                                          color: gTextColor),
                                                    ),
                                                    RichText(
                                                      textAlign:
                                                          TextAlign.start,
                                                      textScaleFactor: 0.85,
                                                      maxLines: 4,
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                          text: subText.substring(
                                                                  0,
                                                                  int.parse(
                                                                      "${(subText.length * 0.498).toInt()}")) +
                                                              "...",
                                                          style: TextStyle(
                                                              height: 1.3,
                                                              fontFamily:
                                                                  kFontBook,
                                                              color: eUser()
                                                                  .mainHeadingColor,
                                                              fontSize:
                                                                  bottomSheetSubHeadingSFontSize),
                                                        ),
                                                        WidgetSpan(
                                                          child: InkWell(
                                                              mouseCursor:
                                                                  SystemMouseCursors
                                                                      .click,
                                                              onTap: () {
                                                                showMoreTextSheet(
                                                                    subText);
                                                              },
                                                              child: Text(
                                                                "more",
                                                                style: TextStyle(
                                                                    height: 1.3,
                                                                    fontFamily:
                                                                        kFontBook,
                                                                    color:
                                                                        gsecondaryColor,
                                                                    fontSize:
                                                                        bottomSheetSubHeadingSFontSize),
                                                              )),
                                                        )
                                                      ]),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          list[index].ago ??
                                                              "2 minutes ago",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kFontMedium,
                                                              color: gTextColor,
                                                              fontSize: 8.dp),
                                                        )),
                                                        Visibility(
                                                          visible: true,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder: (ct) =>
                                                                      VideoPlayerMeedu(
                                                                    videoUrl:
                                                                        "${list[index].image}",
                                                                    isFullScreen:
                                                                        true,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .play_circle_outline,
                                                              color:
                                                                  gsecondaryColor,
                                                              size: 4.h,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(width: 1.w),
                                              // Container(
                                              //   color: gTextColor,
                                              //   height: 2.h,
                                              //   width: 0.5.w,
                                              // ),
                                              // SizedBox(width: 1.w),
                                              // Text(
                                              //   "See more",
                                              //   style: TextStyle(
                                              //     fontSize: 9.dp,
                                              //     color: gPrimaryColor,
                                              //     fontFamily: "GothamBook",
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 1.h),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.h, horizontal: 3.w),
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            color: gWhiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: const Offset(2, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        "${list[index].feed?.addedBy?.profile}"),
                                                  ),
                                                  // SizedBox(
                                                  //   height: 5.h,
                                                  //   width: 10.w,
                                                  //   child: ClipRRect(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             8),
                                                  //     child: const Image(
                                                  //       image: AssetImage(
                                                  //           "assets/images/cheerful.png"),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  SizedBox(width: 1.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          list[index]
                                                                  .feed
                                                                  ?.addedBy
                                                                  ?.name ??
                                                              "Mr. Lorem Ipsum",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kFontMedium,
                                                              color:
                                                                  gBlackColor,
                                                              fontSize: 11.dp),
                                                        ),
                                                        SizedBox(height: 0.5.h),
                                                        Text(
                                                          list[index].ago ??
                                                              "2 minutes ago",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kFontMedium,
                                                              color: gTextColor,
                                                              fontSize: 8.dp),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: false,
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.more_vert,
                                                        color: gTextColor,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 1.h),
                                              Text(
                                                list[index].feed?.title ??
                                                    "Lorem",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 11.dp,
                                                    fontFamily: kFontMedium,
                                                    color: gTextColor),
                                              ),
                                              SizedBox(height: 0.5.h),
                                              subText.isEmpty
                                                  ? const SizedBox()
                                                  : RichText(
                                                      textAlign:
                                                          TextAlign.start,
                                                      textScaleFactor: 0.85,
                                                      maxLines: 4,
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                          text: subText.substring(
                                                                  0,
                                                                  int.parse(
                                                                      "${(subText.length * 0.498).toInt()}")) +
                                                              "...",
                                                          style: TextStyle(
                                                              height: 1.3,
                                                              fontFamily:
                                                                  kFontBook,
                                                              color: eUser()
                                                                  .mainHeadingColor,
                                                              fontSize:
                                                                  bottomSheetSubHeadingSFontSize),
                                                        ),
                                                        WidgetSpan(
                                                          child: InkWell(
                                                              mouseCursor:
                                                                  SystemMouseCursors
                                                                      .click,
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder: (ct) =>
                                                                        FeedsDetailsScreen(
                                                                      profile:
                                                                          "${list[index].feed?.addedBy?.profile}",
                                                                      userName:
                                                                          "${list[index].feed?.addedBy?.name}",
                                                                      userAddress:
                                                                          "${list[index].ago}",
                                                                      reelsImage:
                                                                          '${list[index].image}',
                                                                      comments:
                                                                          '${list[index].feed?.title}',
                                                                      description:
                                                                          '${list[index].feed?.description}',
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                "more",
                                                                style: TextStyle(
                                                                    height: 1.3,
                                                                    fontFamily:
                                                                        kFontBook,
                                                                    color:
                                                                        gsecondaryColor,
                                                                    fontSize:
                                                                        bottomSheetSubHeadingSFontSize),
                                                              ),),
                                                        ),
                                                      ],),
                                                    ),
                                              SizedBox(height: 1.h),
                                              buildFeedImageView(
                                                  list[index].image!),
                                              // SizedBox(height: 1.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Visibility(
                                                    visible: false,
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Image(
                                                            image: const AssetImage(
                                                                "assets/images/Union 4.png"),
                                                            height: 2.h,
                                                          ),
                                                        ),
                                                        SizedBox(width: 1.w),
                                                        Text(
                                                          list[index]
                                                              .likes
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kFontMedium,
                                                              color: gTextColor,
                                                              fontSize: 8.dp),
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Image(
                                                            image: const AssetImage(
                                                                "assets/images/noun_chat_1079099.png"),
                                                            height: 2.h,
                                                          ),
                                                        ),
                                                        SizedBox(width: 1.w),
                                                        Text(
                                                          list[index]
                                                                  .comments
                                                                  ?.length
                                                                  .toString() ??
                                                              "132",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kFontMedium,
                                                              color: gTextColor,
                                                              fontSize: 8.dp),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                  : const SizedBox();
                            }),
                          );
                        }
                      }
                    } else {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    child: buildCircularIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  buildFeedImageView(List<dynamic> imageUrl) {
    return imageUrl.length > 1
        ? Column(
            children: [
              SizedBox(
                height: 35.h,
                child: PageView(
                  controller: pageController,
                  children: [
                    ...imageUrl.map((e) {
                      print("feed image : $e");
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image(
                            image: NetworkImage(e),
                          ),
                          // FadeInImage.memoryNetwork(
                          //   placeholder:
                          //       placeHolderImage!.buffer.asUint8List(),
                          //   image: e,
                          //   fit: BoxFit.fill,
                          //   placeholderErrorBuilder: (_, __, ___) {
                          //     return Image.asset(
                          //         "assets/images/placeholder.png");
                          //   },
                          // ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              SmoothPageIndicator(
                controller: pageController,
                count: imageUrl.length,
                axisDirection: Axis.horizontal,
                effect: ExpandingDotsEffect(
                  dotColor: kNumberCircleRed.withOpacity(0.5),
                  activeDotColor: gsecondaryColor,
                  dotHeight: 2.h,
                  dotWidth: 1.w,
                  // jumpScale: 2,
                ),
              ),
            ],
          )
        : ListView.builder(
            itemCount: imageUrl.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final file = imageUrl[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.memoryNetwork(
                    placeholder: placeHolderImage!.buffer.asUint8List(),
                    image: file,
                    fit: BoxFit.fill,
                    placeholderErrorBuilder: (_, __, ___) {
                      return Image.asset("assets/images/placeholder.png");
                    },
                  ),
                ),
              );
            },
          );
  }

  buildPodCast() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          children: [
            Container(
              height: 1,
              color: kLineColor.withOpacity(0.3),
              width: double.maxFinite,
            ),
            FutureBuilder(
                future: feedsListFuture,
                builder: (_, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data.runtimeType == ErrorModel) {
                        final model = snapshot.data as ErrorModel;
                        return Center(child: Text(model.message ?? ''));
                      } else {
                        final model = snapshot.data as AboutProgramModel;
                        List<FeedsListModel> list = model.data?.feedsList ?? [];
                        if (list.isEmpty) {
                          return const Center(child: Text("NO PodCast"));
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: ((context, index) {
                              final a = list[index].image?[0];
                              final file = a?.split(".").last;
                              String format = file.toString();
                              if (format == "mp4") {}
                              final String subText =
                                  "${list[index].feed?.description}";
                              return (list[index].feed?.isFeed == "2")
                                  ? Container(
                                      height: 17.h,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.h, horizontal: 3.w),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            // height: 15.h,
                                            //  width: 30.w,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: FadeInImage.memoryNetwork(
                                                placeholder: placeHolderImage!
                                                    .buffer
                                                    .asUint8List(),
                                                image:
                                                    "${list[index].feed?.thumbnail}",
                                                fit: BoxFit.fill,
                                                width: 28.w,
                                                // height: 10.h,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 1.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  list[index].feed?.title ??
                                                      "Lorem",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      height: 1.5,
                                                      fontFamily: kFontMedium,
                                                      color: gTextColor),
                                                ),
                                                RichText(
                                                  textAlign: TextAlign.start,
                                                  textScaleFactor: 0.85,
                                                  maxLines: 4,
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: subText.substring(
                                                              0,
                                                              int.parse(
                                                                  "${(subText.length * 0.498).toInt()}")) +
                                                          "...",
                                                      style: TextStyle(
                                                          height: 1.3,
                                                          fontFamily: kFontBook,
                                                          color: eUser()
                                                              .mainHeadingColor,
                                                          fontSize:
                                                              bottomSheetSubHeadingSFontSize),
                                                    ),
                                                    WidgetSpan(
                                                      child: InkWell(
                                                          mouseCursor:
                                                              SystemMouseCursors
                                                                  .click,
                                                          onTap: () {
                                                            showMoreTextSheet(
                                                                subText);
                                                          },
                                                          child: Text(
                                                            "more",
                                                            style: TextStyle(
                                                                height: 1.3,
                                                                fontFamily:
                                                                    kFontBook,
                                                                color:
                                                                    gsecondaryColor,
                                                                fontSize:
                                                                    bottomSheetSubHeadingSFontSize),
                                                          )),
                                                    )
                                                  ]),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      list[index].ago ??
                                                          "2 minutes ago",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              kFontMedium,
                                                          color: gTextColor,
                                                          fontSize: 8.sp),
                                                    )),
                                                    Visibility(
                                                      visible: true,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (ct) =>
                                                                  VideoPlayerMeedu(
                                                                videoUrl:
                                                                    "${list[index].image}",
                                                                isFullScreen:
                                                                    true,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .play_circle_outline,
                                                          color:
                                                              gsecondaryColor,
                                                          size: 4.h,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(width: 1.w),
                                          // Container(
                                          //   color: gTextColor,
                                          //   height: 2.h,
                                          //   width: 0.5.w,
                                          // ),
                                          // SizedBox(width: 1.w),
                                          // Text(
                                          //   "See more",
                                          //   style: TextStyle(
                                          //     fontSize: 9.sp,
                                          //     color: gPrimaryColor,
                                          //     fontFamily: "GothamBook",
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox();
                            }),
                          );
                        }
                      }
                    } else {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    child: buildCircularIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  buildStories() {
    return FutureBuilder(
        future: feedsListFuture,
        builder: (_, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.runtimeType == ErrorModel) {
                final model = snapshot.data as ErrorModel;
                return Center(
                  child: Text(model.message ?? ''),
                );
              } else {
                final model = snapshot.data as AboutProgramModel;
                List<FeedsListModel> list = model.data?.feedsList ?? [];
                if (list.isEmpty) {
                  return const Center(
                    child: Text("NO Feeds"),
                  );
                } else {
                  return Stories(
                    circlePadding: 2,
                    borderThickness: 2,
                    displayProgress: true,
                    highLightColor: gMainColor,
                    showThumbnailOnFullPage: true,
                    storyStatusBarColor: gWhiteColor,
                    showStoryName: true,
                    showStoryNameOnFullPage: true,
                    fullPagetitleStyle: TextStyle(
                        fontFamily: kFontMedium,
                        color: gWhiteColor,
                        fontSize: 8.sp),
                    fullpageVisitedColor: gsecondaryColor,
                    fullpageUnisitedColor: gWhiteColor,
                    fullpageThumbnailSize: 40,
                    autoPlayDuration: const Duration(milliseconds: 3000),
                    onPageChanged: () {},
                    storyCircleTextStyle: TextStyle(
                        fontFamily: kFontMedium,
                        color: gBlackColor,
                        fontSize: 8.sp),
                    storyItemList: list
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
                  );
                }
              }
            }
          }
          return Container();
        });
  }

  showMoreTextSheet(String text) {
    return AppConfig().showSheet(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: subHeadingFont,
                      fontFamily: kFontBook,
                      height: 1.4),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(height: 1.h)
          ],
        ),
        bottomSheetHeight: 40.h,
        circleIcon: bsHeadBulbIcon,
        isDismissible: true,
        isSheetCloseNeeded: true, sheetCloseOnTap: () {
      Navigator.pop(context);
    });
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bool get wantKeepAlive => true;
}

extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}
