import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:image_network/image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../utils/app_config.dart';
import '../../model/error_model.dart';
import '../../model/new_user_model/about_program_model/about_program_model.dart';
import '../../model/new_user_model/about_program_model/feeds_model/feedsListModel.dart';
import '../../repository/api_service.dart';
import '../../repository/new_user_repository/about_program_repository.dart';
import '../../services/new_user_service/about_program_service.dart';
import 'package:http/http.dart' as http;

import '../../widgets/widgets.dart';
import '../combined_meal_plan/video_player/yoga_video_screen.dart';
import 'feeds_details_screen.dart';
import 'feeds_list.dart';

class WebFeedScreen extends StatefulWidget {
  const WebFeedScreen({Key? key}) : super(key: key);

  @override
  State<WebFeedScreen> createState() => _WebFeedScreenState();
}

class _WebFeedScreenState extends State<WebFeedScreen> {
  final SharedPreferences pref = AppConfig().preferences!;

  int selectedDetails = 1;
  List<FeedModels> details = [
    FeedModels(
      id: 1,
      title: "Feed",
      isIcon: true,
      icons: Icons.feed,
    ),
    FeedModels(
      id: 2,
      title: "PodCast",
      isIcon: true,
      icons: Icons.podcasts_sharp,
    ),
  ];

  @override
  void initState() {
    super.initState();
    getFeedsList();
    loadAsset('placeholder.png');
  }

  ByteData? placeHolderImage;

  void loadAsset(String name) async {
    var data = await rootBundle.load('assets/images/$name');
    setState(() => placeHolderImage = data);
  }

  bool isLoading = false;
  List<FeedsListModel> feedList = [];
  List<FeedsListModel> podCastList = [];

  getFeedsList() async {
    setState(() {
      isLoading = true;
    });
    final result = await AboutProgramService(repository: repository)
        .serverAboutProgramService();
    print("result: $result");

    if (result.runtimeType == AboutProgramModel) {
      print("Ticket List");
      AboutProgramModel model = result as AboutProgramModel;

      for (var e in model.data!.feedsList!) {
        if (e.feed?.isFeed == "1") {
          feedList.add(e);
        } else if (e.feed?.isFeed == "2") {
          podCastList.add(e);
        }
      }
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
      body: SafeArea(
        child: (isLoading)
            ? Center(
                child: buildCircularIndicator(),
              )
            : MediaQuery.of(context).size.shortestSide > 600
                ? webViewWidget()
                : FeedsList(
                    feedList: feedList,
                    podCastList: podCastList,
                  ),
      ),
    );
  }

  webViewWidget() {
    return Row(
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
                  ListView.builder(
                    itemCount: details.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool isSelected = selectedDetails == details[index].id;
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
                                color:
                                    isSelected ? gsecondaryColor : gWhiteColor,
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
                                    color: selectedDetails == details[index].id
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
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            height: double.maxFinite,
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
                ? buildFeedList(feedList)
                : selectedDetails == 2
                    ? buildFeedList(podCastList)
                    : const SizedBox(),
          ),
        ),
      ],
    );
  }

  buildFeedList(List<FeedsListModel> list) {
    print("Length : ${list.length}");

    return list.isEmpty
        ? Align(
            alignment: Alignment.center,
            child: Text(
              'No Data',
              style: TextStyle(
                fontSize: 13.dp,
                fontFamily: kFontMedium,
                color: gBlackColor,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 2.h,
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: ((context, index) {
                  final a = list[index].image?[0];
                  final file = a?.split(".").last;
                  String format = file.toString();
                  print("profile : ${list[index].feed?.addedBy?.profile}");
                  return format == "mp4"
                      ? videoWidget(list[index])
                      : imageWidget(list[index]);
                }),
              ),
            ),
          );
  }

  videoWidget(FeedsListModel lst) {
    final String subText = "${lst.feed?.description}";

    return Column(
      children: [
        Container(
          height: 35.h,
          margin: EdgeInsets.symmetric(vertical: 1.h),
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
                // height: 15.h,
                //  width: 30.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.memoryNetwork(
                    placeholder: placeHolderImage!.buffer.asUint8List(),
                    image: "${lst.feed?.thumbnail}",
                    fit: BoxFit.fill,
                    width: 20.w,
                    // height: 10.h,
                  ),
                ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lst.feed?.title ?? "Lorem",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.dp,
                          height: 1.5,
                          fontFamily: kFontMedium,
                          color: gTextColor),
                    ),
                    RichText(
                      textAlign: TextAlign.start,
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
                              color: eUser().mainHeadingColor,
                              fontSize: bottomSheetSubHeadingSFontSize),
                        ),
                        WidgetSpan(
                          child: InkWell(
                              mouseCursor: SystemMouseCursors.click,
                              onTap: () {
                                showMoreTextSheet(subText);
                              },
                              child: Text(
                                "more",
                                style: TextStyle(
                                    height: 1.3,
                                    fontFamily: kFontBook,
                                    color: gsecondaryColor,
                                    fontSize: bottomSheetSubHeadingSFontSize),
                              )),
                        )
                      ]),
                      textScaler: const TextScaler.linear(0.85),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          lst.ago ?? "2 minutes ago",
                          style: TextStyle(
                              fontFamily: kFontMedium,
                              color: gTextColor,
                              fontSize: 8.dp),
                        )),
                        Visibility(
                          visible: true,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ct) => YogaVideoPlayer(
                                    videoUrl: "${lst.image}",
                                    heading: lst.feed?.title ?? '',
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.play_circle_outline,
                              color: gsecondaryColor,
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
        ),
        const Divider(),
      ],
    );
  }

  imageWidget(FeedsListModel lst) {
    final String subText = "${lst.feed?.description}";

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(10),
            //
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                      ],
                    ),
                    child: ImageNetwork(
                      image: lst.feed?.addedBy?.profile ?? '',
                      height: 40,
                      width: 40,
                      // duration: 1500,
                      curve: Curves.easeIn,
                      onPointer: true,
                      debugPrint: false,
                      fullScreen: false,
                      fitAndroidIos: BoxFit.fill,
                      fitWeb: BoxFitWeb.fill,
                      borderRadius: BorderRadius.circular(70),
                      onError: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      onTap: () {
                        debugPrint("©gabriel_patrick_souza");
                      },
                    ),
                  ),
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //       "${list[index].feed?.addedBy?.profile}"),
                  // ),
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
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lst.feed?.addedBy?.name ?? "Mr. Lorem Ipsum",
                          style: TextStyle(
                              fontFamily: kFontMedium,
                              color: gBlackColor,
                              fontSize: 15.dp),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          lst.ago ?? "2 minutes ago",
                          style: TextStyle(
                              fontFamily: kFontMedium,
                              color: gTextColor,
                              fontSize: 12.dp),
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
                lst.feed?.title ?? "Lorem",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15.dp,
                    fontFamily: kFontMedium,
                    color: gTextColor),
              ),
              SizedBox(height: 0.5.h),
              subText.isEmpty
                  ? const SizedBox()
                  : RichText(
                      textAlign: TextAlign.start,
                      maxLines: 4,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: subText.substring(
                                    0,
                                    int.parse(
                                        "${(subText.length * 0.498).toInt()}")) +
                                "...",
                            style: TextStyle(
                                height: 1.3,
                                fontFamily: kFontBook,
                                color: eUser().mainHeadingColor,
                                fontSize: bottomSheetSubHeadingSFontSize),
                          ),
                          WidgetSpan(
                            child: InkWell(
                              mouseCursor: SystemMouseCursors.click,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ct) => FeedsDetailsScreen(
                                      profile: "${lst.feed?.addedBy?.profile}",
                                      userName: "${lst.feed?.addedBy?.name}",
                                      userAddress: "${lst.ago}",
                                      reelsImage: '${lst.image}',
                                      comments: '${lst.feed?.title}',
                                      description: '${lst.feed?.description}',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "more",
                                style: TextStyle(
                                    height: 1.3,
                                    fontFamily: kFontBook,
                                    color: gsecondaryColor,
                                    fontSize: bottomSheetSubHeadingSFontSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textScaler: TextScaler.linear(0.85),
                    ),
              SizedBox(height: 1.h),
              buildFeedImageView(lst.image!),
              // SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: false,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Image(
                            image:
                                const AssetImage("assets/images/Union 4.png"),
                            height: 2.h,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          lst.likes.toString(),
                          style: TextStyle(
                              fontFamily: kFontMedium,
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
                          lst.comments?.length.toString() ?? "132",
                          style: TextStyle(
                              fontFamily: kFontMedium,
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
        ),
        const Divider(),
      ],
    );
  }

  PageController pageController = PageController();

  buildFeedImageView(List<dynamic> imageUrl) {
    return imageUrl.length > 1
        ? Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.shortestSide < 600
                    ? 60.h
                    : 120.h,
                child: PageView(
                  controller: pageController,
                  children: [
                    ...imageUrl.map((e) {
                      print("feed image : $e");
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(e),
                            fit: BoxFit.contain,
                          ),
                          // ImageNetwork(
                          //   image: "$e",
                          //   height: MediaQuery.of(context).size.shortestSide < 600
                          //       ? 60.h
                          //       : 100.h,
                          //   width: 100.w,
                          //   // duration: 1500,
                          //   curve: Curves.easeIn,
                          //   onPointer: true,
                          //   debugPrint: false,
                          //   fullScreen: false,
                          //   fitAndroidIos: BoxFit.cover,
                          //   fitWeb: BoxFitWeb.fill,
                          //   borderRadius: BorderRadius.circular(10),
                          //   onLoading: const CircularProgressIndicator(
                          //     color: Colors.indigoAccent,
                          //   ),
                          //   onError: Image.asset("assets/images/placeholder.png"),
                          //   onTap: () {
                          //     debugPrint("©gabriel_patrick_souza");
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
                  // dotHeight: 2.h,
                  // dotWidth: 1.w,
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
              print("feed imagee: $file");
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(file),
                  fit: BoxFit.contain,
                ),
                // ImageNetwork(
                //   image: "$file",
                //   height: MediaQuery.of(context).size.shortestSide < 600
                //       ? 60.h
                //       : 100.h,
                //   width: 100.w,
                //   // duration: 1500,
                //   curve: Curves.easeIn,
                //   onPointer: true,
                //   debugPrint: false,
                //   fullScreen: false,
                //   fitAndroidIos: BoxFit.cover,
                //   fitWeb: BoxFitWeb.fill,
                //   borderRadius: BorderRadius.circular(10),
                //   onLoading: const CircularProgressIndicator(
                //     color: Colors.indigoAccent,
                //   ),
                //   onError: Image.asset("assets/images/placeholder.png"),
                //   onTap: () {
                //     debugPrint("©gabriel_patrick_souza");
                //   },
                // ),
              );
            },
          );
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
}

class FeedModels {
  final int id;
  final String title;
  final String? image;
  final IconData? icons;
  final bool isIcon;

  FeedModels({
    required this.id,
    required this.title,
    this.image,
    this.icons,
    this.isIcon = false,
  });
}
