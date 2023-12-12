// import 'package:advstory/advstory.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../model/new_user_model/about_program_model/feeds_model/feedsListModel.dart';
// import '../../widgets/constants.dart';
//
// class FeedStory extends StatefulWidget {
//   final List<FeedsListModel> feedList;
//   const FeedStory({Key? key, required this.feedList}) : super(key: key);
//
//   @override
//   State<FeedStory> createState() => _FeedStoryState();
// }
//
// class _FeedStoryState extends State<FeedStory> {
//   final AdvStoryController _controller = AdvStoryController();
//   final _key = GlobalKey();
//
//   List<String> storiesUrl = [];
//
//   @override
//   Widget build(BuildContext context) {
//     print("feedddd : ${widget.feedList}");
//     return Column(
//       children: [
//         SizedBox(
//           height: 10.h,
//           child: AdvStory(
//             key: _key,
//             controller: _controller,
//             storyCount: widget.feedList.length,
//             storyBuilder: (index) {
//               var a = "${widget.feedList[index].image}";
//               print(a);
//               var b = a.split(",");
//               storiesUrl = b.toList();
//               print("list : $storiesUrl");
//               return Story(
//                 header: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 2.3.h,
//                       backgroundImage: NetworkImage(
//                         "${widget.feedList[index].feed?.thumbnail}",
//                       ),
//                     ),
//                     SizedBox(width: 2.w),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${widget.feedList[index].feed?.title}",
//                           style: TextStyle(
//                             color: eUser().threeBounceIndicatorColor,
//                             fontFamily: eUser().userFieldLabelFont,
//                             fontSize: eUser().anAccountTextFontSize,
//                           ),
//                         ),
//                         // SizedBox(height: 0.5.h),
//                         Text(
//                           "${widget.feedList[index].ago}",
//                           style: TextStyle(
//                             color: eUser().threeBounceIndicatorColor,
//                             fontFamily: eUser().resendOtpFont,
//                             fontSize: eUser().resendOtpFontSize,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 contentCount: storiesUrl.length,
//                 contentBuilder: (contentIndex) {
//                   final a = storiesUrl[contentIndex];
//                   final file = a.split(".").last;
//                   String format = file.toString();
//                   return SimpleCustomContent(
//                     useStoryHeader: true,
//                     builder: (context) {
//                       return format == "mp4"
//                           ? Container(
//                               color: gBlackColor,
//                               child: Center(
//                                 child: Text(
//                                   "Content $contentIndex",
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : Container(
//                               color: gBlackColor,
//                               child: Center(
//                                 child: Image(
//                                   image: NetworkImage(
//                                     storiesUrl[contentIndex],
//                                   ),
//                                 ),
//                               ),
//                             );
//                     },
//                   );
//                 },
//               );
//             },
//             trayBuilder: (index) => AdvStoryTray(
//               url: "${widget.feedList[index].feed?.thumbnail}",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
