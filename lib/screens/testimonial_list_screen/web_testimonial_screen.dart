import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../../model/new_user_model/about_program_model/feedback_list_model.dart';
import '../../repository/api_service.dart';
import '../../repository/new_user_repository/about_program_repository.dart';
import '../../widgets/constants.dart';
import 'package:intl/intl.dart';

class WebTestimonialScreen extends StatefulWidget {
  final List<FeedbackList> feedbackList;
  const WebTestimonialScreen({Key? key, required this.feedbackList})
      : super(key: key);

  @override
  State<WebTestimonialScreen> createState() => _WebTestimonialScreenState();
}

class _WebTestimonialScreenState extends State<WebTestimonialScreen> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 4.h, left: 1.w, right: 1.w, bottom: 1.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        crossAxisCount: 3,
        mainAxisExtent: 35.h,
      ),
      itemCount: widget.feedbackList.length,
      itemBuilder: (context, index) {
        return webView(
          userProfile: widget.feedbackList[index].addedBy?.profile ?? '',
          feedbackTime: DateFormat('dd MMM yyyy , hh:mm a').format(
              DateTime.parse(
                      widget.feedbackList[index].addedBy?.createdAt ?? '')
                  .toLocal()),
          feedbackUser: widget.feedbackList[index].addedBy?.name ?? '',
          feedback: widget.feedbackList[index].feedback,
          imagePath: (widget.feedbackList[index].file == null)
              ? null
              : widget.feedbackList[index].file?.first,
          rating: widget.feedbackList[index].rating,
        );
      },
    );
    // ListView.builder(
    //     itemCount: widget.feedbackList.length,
    //     itemBuilder: (_, index) {
    //       print(
    //           "feedbackList[index].file: ${widget.feedbackList[index].file.runtimeType}");
    //       return showCardViews(
    //         userProfile: widget.feedbackList[index].addedBy?.profile ?? '',
    //         feedbackTime: DateFormat('dd MMM yyyy , hh:mm a').format(
    //             DateTime.parse(
    //                     widget.feedbackList[index].addedBy?.createdAt ?? '')
    //                 .toLocal()),
    //         feedbackUser: widget.feedbackList[index].addedBy?.name ?? '',
    //         feedback: widget.feedbackList[index].feedback,
    //         imagePath: (widget.feedbackList[index].file == null)
    //             ? null
    //             : widget.feedbackList[index].file?.first,
    //         rating: widget.feedbackList[index].rating,
    //       );
    //     });
  }

  webView({
    String? userProfile,
    String? feedbackUser,
    String? feedbackTime,
    String? feedback,
    String? imagePath,
    String? rating,
  }) {
    return Container(
      height: 35.h,
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 0.w),
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.h),
      decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: gHintTextColor.withOpacity(0.35),
                // spreadRadius: 0.3,
                blurRadius: 5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 7.h,
                width: 6.w,
                decoration: BoxDecoration(
                  color: gsecondaryColor,
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/meal_placeholder.png"),
                      fit: BoxFit.fill),
                ),
                // child: Image(
                //   image: AssetImage("assets/images/meal_placeholder.png"),
                //   // CachedNetworkImageProvider(userProfile ?? ''),
                //   fit: BoxFit.fill,
                // ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedbackUser ?? '',
                      style: TextStyle(
                          fontSize: 15.dp, fontFamily: kFontBold, height: 1.5),
                    ),
                    Text(
                      feedbackTime ?? '',
                      style: TextStyle(
                          fontSize: 12.5.dp,
                          fontFamily: kFontBook,
                          height: 1.5),
                    ),
                    buildRating(
                      double.parse(
                        rating.toString(),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: Text(
              feedback ??
                  "Lorem Ipsum is simply dummy text of the print and typesetting industry",
              style: TextStyle(
                  fontSize: 13.dp, fontFamily: kFontMedium, height: 1.5),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.format_quote_rounded,
                  color: gGreyColor.withOpacity(0.5),
                  size: 7.h,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showImage(imagePath ?? '');
                },
                child: SizedBox(
                  height: 12.h,
                  child: Lottie.asset(
                      'assets/lottie/Animation - 1701175879899.json'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showCardViews({
    String? userProfile,
    String? feedbackUser,
    String? feedbackTime,
    String? feedback,
    String? imagePath,
    String? rating,
  }) {
    final a = imagePath;
    print("testimonial url : $a");
    final file = a?.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      // if (a != null) addUrlToVideoPlayerChewie(a);
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: gHintTextColor.withOpacity(0.35),
                // spreadRadius: 0.3,
                blurRadius: 5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10.h,
                width: 8.w,
                decoration: BoxDecoration(
                  color: gsecondaryColor,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: AssetImage("assets/images/meal_placeholder.png"),
                      fit: BoxFit.fill),
                ),
                // child: Image(
                //   image: AssetImage("assets/images/meal_placeholder.png"),
                //   // CachedNetworkImageProvider(userProfile ?? ''),
                //   fit: BoxFit.fill,
                // ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedbackUser ?? '',
                      style: TextStyle(
                          fontSize: 15.dp, fontFamily: kFontBold, height: 1.5),
                    ),
                    Text(
                      feedbackTime ?? '',
                      style: TextStyle(
                          fontSize: 12.5.dp,
                          fontFamily: kFontBook,
                          height: 1.5),
                    ),
                    buildRating(
                      double.parse(
                        rating.toString(),
                      ),
                    ),
                    // Text(
                    //   rating ?? '',
                    //   style: TextStyle(
                    //       fontSize: 9.5.sp, fontFamily: kFontBook, height: 1.5),
                    // ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showImage(imagePath ?? '');
                  // addTrackerUrlToVideoPlayer(widget.trackerVideoLink ?? '');
                },
                child: SizedBox(
                  height: 12.h,
                  child: Lottie.asset(
                      'assets/lottie/Animation - 1701175879899.json'),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.5.h),
            child: Text(
              feedback ??
                  "Lorem Ipsum is simply dummy text of the print and typesetting industry",
              style: TextStyle(
                  fontSize: 13.dp, fontFamily: kFontMedium, height: 1.5),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.format_quote_rounded,
              color: gGreyColor.withOpacity(0.5),
              size: 7.h,
            ),
          ),
          // SizedBox(
          //   height: 1.h,
          // ),
          // if (format == "mp4") buildTestimonial(),
          // Visibility(
          //   visible: imagePath != null && format != "mp4",
          //   child: Center(
          //     child: Container(
          //       width: 70.w,
          //       height: 30.h,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(14),
          //           image: DecorationImage(
          //               image: CachedNetworkImageProvider(
          //             imagePath ?? '',
          //             errorListener: (message) {
          //               Image.asset('assets/images/placeholder.png');
          //             },
          //             // placeholder: (_, __){
          //             //   return Image.asset('assets/images/top-view-indian-food-assortment.png');
          //             // },
          //           ))),
          //       // child: Card(
          //       //   child: CachedNetworkImage(
          //       //     imageUrl: imagePath ?? '',
          //       //     placeholder: (_, __){
          //       //       return Image.asset('assets/images/top-view-indian-food-assortment.png');
          //       //     },
          //       //   ),
          //       // ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildRating(double rating) {
    return SmoothStarRating(
      color: kBottomSheetHeadYellow,
      borderColor: gWhiteColor,
      rating: rating,
      size: 15,
      filledIconData: Icons.star_sharp,
      halfFilledIconData: Icons.star_half_sharp,
      defaultIconData: Icons.star_outline_sharp,
      starCount: 5,
      allowHalfRating: false,
      spacing: 1.0,
    );
  }

  Future showImage(String attachmentUrl) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent.withOpacity(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0.dp),
          ),
        ),
        contentPadding: EdgeInsets.only(top: 1.h),
        // content: buildTestimonial(),
      ),
    );
  }

  noData() {
    return const Center(
      child: Image(
        image: AssetImage("assets/images/no_data_found.png"),
        fit: BoxFit.scaleDown,
      ),
    );
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
