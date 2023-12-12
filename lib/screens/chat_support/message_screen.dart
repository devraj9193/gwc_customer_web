// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
// import 'package:gwc_customer/screens/program_plans/meal_pdf.dart';
// import 'package:gwc_customer/utils/app_config.dart';
// import 'package:gwc_customer/widgets/open_alert_box.dart';
// import 'package:gwc_customer/widgets/unfocus_widget.dart';
// import 'package:gwc_customer/widgets/widgets.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:mime/mime.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import '../../model/message_model/message_model.dart';
// import '../../services/quick_blox_service/quick_blox_service.dart';
// import '../../widgets/constants.dart';
//
// class MessageScreen extends StatefulWidget {
//   final bool isGroupId;
//   const MessageScreen({Key? key, this.isGroupId = false}) : super(key: key);
//
//   @override
//   State<MessageScreen> createState() => _MessageScreenState();
// }
//
// class _MessageScreenState extends State<MessageScreen>
//     with WidgetsBindingObserver {
//   final formKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   TextEditingController commentController = TextEditingController();
//   ScrollController? _scrollController;
//
//   QuickBloxService? _quickBloxService;
//
//   bool isLoading = false;
//
//   List attachments = [];
//
//   String? _groupId;
//   String? _messageId;
//
//   final _pref = AppConfig().preferences;
//
//   @override
//   void initState() {
//     super.initState();
//     isLoading = true;
//     _quickBloxService = Provider.of<QuickBloxService>(context, listen: false);
//     if (WidgetsBinding.instance != null) {
//       WidgetsBinding.instance.addObserver(this);
//     }
//     if (_pref != null) {
//       if (_pref?.getString(AppConfig.GROUP_ID) != null) {
//         _groupId = _pref!.getString(AppConfig.GROUP_ID);
//         print("userId: ${_pref!.getString(AppConfig.QB_CURRENT_USERID)}");
//
//         //test
//         // joinWithLogin(_groupId!);
//         // _groupId = "63bfe5b907a49d00325819d9";
//         joinChatRoom(_groupId!);
//
//         // joinChatRoom(_pref!.getString(AppConfig.GROUP_ID)!);
//       }
//     }
//     commentController.addListener(() {
//       setState(() {});
//     });
//     _scrollController = ScrollController();
//     // WidgetsBinding.instance?.addPostFrameCallback((_) => {
//     //   _scrollController!.animateTo(
//     //     0.0,
//     //     duration: Duration(milliseconds: 200),
//     //     curve: Curves.easeIn,
//     //   )
//     // });
//     _scrollController?.addListener(_scrollListener);
//   }
//
//   @override
//   void dispose() {
//     if (WidgetsBinding.instance != null) {
//       WidgetsBinding.instance!.removeObserver(this);
//     }
//     commentController.dispose();
//     _scrollController?.removeListener(_scrollListener);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         print("app in resumed");
//         break;
//       case AppLifecycleState.inactive:
//         print("app in inactive");
//         break;
//       case AppLifecycleState.paused:
//         print("app in paused");
//         break;
//       case AppLifecycleState.detached:
//         print("app in detached");
//         break;
//     }
//   }
//
//   void _scrollListener() {
//     double? maxScroll = _scrollController?.position.maxScrollExtent;
//     double? currentScroll = _scrollController?.position.pixels;
//     if (maxScroll == currentScroll && _quickBloxService!.hasMore == true) {
//       _quickBloxService!.loadMessages(_groupId ?? '');
//     }
//   }
//
//   List<Message> messages = [
//     Message(
//         text: "Hi!\nI have some question about my prescription.",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 1, days: 10),
//         ),
//         sendMe: false,
//         image:
//             "assets/images/closeup-content-attractive-indian-business-lady.png"),
//     Message(
//         text: "Hello, Adam!",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 5, days: 10),
//         ),
//         sendMe: true,
//         image: "assets/images/cheerful.png"),
//     Message(
//         text: "Lorem ipsum  Is Simply Dummy Text",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 1, days: 6),
//         ),
//         sendMe: false,
//         image:
//             "assets/images/closeup-content-attractive-indian-business-lady.png"),
//     Message(
//         text: "done.",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 5, days: 6),
//         ),
//         sendMe: true,
//         image: "assets/images/cheerful.png"),
//     Message(
//         text: "Lorem ipsum  Is Simply Dummy Text",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 1, days: 3),
//         ),
//         sendMe: false,
//         image:
//             "assets/images/closeup-content-attractive-indian-business-lady.png"),
//     Message(
//         text: "Okay,",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 5, days: 3),
//         ),
//         sendMe: true,
//         image: "assets/images/cheerful.png"),
//     Message(
//         text: "Lorem ipsum  Is Simply Dummy Text",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 1, days: 2),
//         ),
//         sendMe: false,
//         image:
//             "assets/images/closeup-content-attractive-indian-business-lady.png"),
//     Message(
//         text: "Okay,",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 5, days: 2),
//         ),
//         sendMe: true,
//         image: "assets/images/cheerful.png"),
//     Message(
//         text: "Lorem ipsum  Is Simply Dummy Text",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 1, days: 0),
//         ),
//         sendMe: false,
//         image:
//             "assets/images/closeup-content-attractive-indian-business-lady.png"),
//     Message(
//         text: "Okay,",
//         date: DateTime.now().subtract(
//           const Duration(minutes: 5, days: 0),
//         ),
//         sendMe: true,
//         image: "assets/images/cheerful.png"),
//   ].toList();
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: UnfocusWidget(
//         child: SafeArea(
//           child: Scaffold(
//             key: _scaffoldKey,
//             body: Container(
//               color: gsecondaryColor,
//               child: Stack(
//                 children: [
//                   Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             buildAppBar(() async{
//                               await _quickBloxService!.disconnect().then((value) {
//                               Navigator.pop(context);
//                               });
//                             }),
//                             // Column(
//                             //   mainAxisAlignment: MainAxisAlignment.center,
//                             //   children: [
//                             //     Text(
//                             //       "Ms. Lorem Ipsum Daries",
//                             //       style: TextStyle(
//                             //           fontFamily: "PoppinsRegular",
//                             //           color: gWhiteColor,
//                             //           fontSize: 10.sp),
//                             //     ),
//                             //     SizedBox(height: 0.5.h),
//                             //     Text(
//                             //       "Age : 26 Female",
//                             //       style: TextStyle(
//                             //           fontFamily: "PoppinsLight",
//                             //           color: gWhiteColor,
//                             //           fontSize: 9.sp),
//                             //     ),
//                             //     SizedBox(height: 2.h),
//                             //   ],
//                             // ),
//                             GestureDetector(
//                               onTap: () {
//                                 openAlertBox(
//                                     context: context,
//                                     isContentNeeded: false,
//                                     titleNeeded: true,
//                                     title: "Select Call Type",
//                                     positiveButtonName: "In App Call",
//                                     positiveButton: (){
//                                       callSupport();
//                                       Navigator.pop(context);
//                                     },
//                                     negativeButtonName: "Direct Call",
//                                     negativeButton: (){
//                                       final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
//                                       print(uId);
//
//                                       Navigator.pop(context);
//                                       if(_pref!.getString(AppConfig.KALEYRA_SUCCESS_ID) == null){
//                                         AppConfig().showSnackbar(context, "SuccessTeam Not Assigned", isError: true);
//                                       }
//                                       else if(uId == null){
//                                         AppConfig().showSnackbar(context, "KaleyraId Not Assigned", isError: true);
//                                       }
//                                       else{
//                                         print(_pref!.getString(AppConfig.KALEYRA_USER_ID) == "null");
//                                         if(_pref!.getString(AppConfig.KALEYRA_USER_ID) == "null"){
//                                           AppConfig().showSnackbar(context, "KaleyraId Not Assigned", isError: true);
//                                         }
//                                         else if(_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) != null){
//                                           final accessToken = _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);
//                                           final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
//                                           final successId = _pref!.getString(AppConfig.KALEYRA_SUCCESS_ID);
//                                           // voice- call
//                                           supportVoiceCall(uId!, successId!, accessToken!);
//                                         }
//                                         else{
//                                           AppConfig().showSnackbar(context, "Something went wrong!!", isError: true);
//                                         }
//                                       }
//                                     }
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: gWhiteColor.withOpacity(0.3),
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                                 child: const Icon(
//                                   Icons.local_phone,
//                                   color: gPrimaryColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 3.h),
//                       Expanded(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 2.w, vertical: 1.h),
//                           width: double.maxFinite,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                   blurRadius: 2,
//                                   color: Colors.grey.withOpacity(0.5))
//                             ],
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(20),
//                               topRight: Radius.circular(20),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: RawScrollbar(
//                                     isAlwaysShown: false,
//                                     thickness: 3,
//                                     controller: _scrollController,
//                                     radius: Radius.circular(3),
//                                     thumbColor: gMainColor,
//                                     child: StreamBuilder(
//                                       stream: _quickBloxService!.stream.stream
//                                           .asBroadcastStream(),
//                                       builder: (_, snapshot) {
//                                         print("snap.data: ${snapshot.data}");
//                                         if (snapshot.hasData) {
//                                           return buildMessageList(snapshot.data
//                                               as List<QBMessageWrapper>);
//                                         }
//                                         else if (snapshot.hasError || isError) {
//                                           return Center(
//                                             child:
//                                                 Text((isError) ? errorMsg : snapshot.error.toString()),
//                                           );
//                                         }
//                                         return Center(
//                                           child: CircularProgressIndicator(),
//                                         );
//                                       },
//                                     )),
//                               ),
//                               _buildEnterMessageRow(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // if(isLoading)
//                   // Positioned(
//                   //   child: Center(child: CircularProgressIndicator()),
//                   // )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _onWillPop() async {
//     print('back pressed chat');
//     return await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           backgroundColor: kPrimaryColor,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(15.0.sp))),
//           contentPadding: EdgeInsets.only(top: 1.h),
//           content: Container(
//             padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
//             decoration: BoxDecoration(
//                 color: gWhiteColor, borderRadius: BorderRadius.circular(8)),
//             width: 50.h,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text(
//                   'Are you sure?',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontFamily: "GothamRoundedBold_21016",
//                       color: gPrimaryColor,
//                       fontSize: 13.sp),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: 2.h),
//                   height: 1,
//                   color: Colors.grey.withOpacity(0.3),
//                 ),
//                 Text(
//                   'Do you want to end the chat?',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontFamily: "GothamMedium",
//                       color: gsecondaryColor,
//                       fontSize: 11.sp),
//                 ),
//                 SizedBox(height: 3.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             vertical: 1.h, horizontal: 5.w),
//                         decoration: BoxDecoration(
//                             color: gMainColor,
//                             borderRadius: BorderRadius.circular(5)),
//                         child: Text(
//                           "NO",
//                           style: TextStyle(
//                             fontFamily: "GothamRoundedBold_21016",
//                             color: gPrimaryColor,
//                             fontSize: 11.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 5.w),
//                     GestureDetector(
//                       onTap: () async{
//                         await _quickBloxService!.disconnect().then((value) {
//                           // _quickBloxService!.logout();
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             vertical: 1.h, horizontal: 5.w),
//                         decoration: BoxDecoration(
//                             color: gPrimaryColor,
//                             borderRadius: BorderRadius.circular(5)),
//                         child: Text(
//                           "YES",
//                           style: TextStyle(
//                             fontFamily: "GothamRoundedBold_21016",
//                             color: gMainColor,
//                             fontSize: 11.sp,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 1.h)
//               ],
//             ),
//           ),
//         )) ??
//         false;
//   }
//
//
//   Widget _buildEnterMessageRow() {
//     return SafeArea(
//       child: Column(
//         children: [
//           _buildTypingIndicator(),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   // height: 5.h,
//                   padding: EdgeInsets.symmetric(horizontal: 2.w),
//                   decoration: BoxDecoration(
//                     color: const Color(0xffF8F4F4),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Form(
//                     key: formKey,
//                     child: TextFormField(
//                       // cursorColor: kPrimaryColor,
//                       controller: commentController,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         hintText: "Say Something ...",
//                         alignLabelWithHint: true,
//                         hintStyle: TextStyle(
//                           color: gMainColor,
//                           fontSize: 10.sp,
//                           fontFamily: "GothamBook",
//                         ),
//                         border: InputBorder.none,
//                         suffixIcon: InkWell(
//                           onTap: () {
//                             showAttachmentSheet(context);
//                           },
//                           child: const Icon(
//                             Icons.add,
//                             color: gPrimaryColor,
//                           ),
//                         ),
//                       ),
//                       style: TextStyle(
//                           fontFamily: "GothamMedium",
//                           color: gTextColor,
//                           fontSize: 11.sp),
//                       maxLines: 3,
//                       minLines: 1,
//                       textInputAction: TextInputAction.none,
//                       textAlign: TextAlign.start,
//                       keyboardType: TextInputType.text,
//                     ),
//                   ),
//                 ),
//               ),
//               commentController.text.toString().isNotEmpty
//                   ? SizedBox(
//                       width: 2.w,
//                     )
//                   : SizedBox(width: 0),
//               commentController.text.toString().isEmpty
//                   ? SizedBox(
//                       width: 0,
//                     )
//                   : InkWell(
//                       onTap: () {
//                         final message = Message(
//                             text: commentController.text.toString(),
//                             date: DateTime.now(),
//                             sendMe: true,
//                             image:
//                                 "assets/images/closeup-content-attractive-indian-business-lady.png");
//                         setState(() {
//                           messages.add(message);
//                         });
//                         // need to remove
//                         // _groupId = "63bfe5b907a49d00325819d9";
//                         _quickBloxService!.sendMessage(_groupId!,
//                             message: commentController.text);
//
//                         commentController.clear();
//                       },
//                       child: const Icon(
//                         Icons.send,
//                         color: kPrimaryColor,
//                       ),
//                     ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTypingIndicator() {
//     return StreamBuilder(
//         stream: _quickBloxService!.typingStream.stream.asBroadcastStream(),
//         builder: (_, snapshot) {
//           if (snapshot.hasData) {
//             print("typinf snap: ${snapshot.data}");
//             return Container(
//               // color: Color(0xfff1f1f1),
//               height: 35,
//               child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(width: 16),
//                     Text(
//                         (snapshot.data as List<String>).isEmpty
//                             ? ''
//                             : _makeTypingStatus(snapshot.data as List<String>),
//                         style: TextStyle(
//                             fontSize: 13,
//                             color: Color(0xff6c7a92),
//                             fontStyle: FontStyle.italic))
//                   ]),
//             );
//           }
//           return SizedBox();
//         });
//   }
//
//   String _makeTypingStatus(List<String> usersName) {
//     const int MAX_NAME_SIZE = 20;
//     const int ONE_USER = 1;
//     const int TWO_USERS = 2;
//
//     String result = "";
//     int namesCount = usersName.length;
//
//     switch (namesCount) {
//       case ONE_USER:
//         String firstUser = usersName[0];
//         if (firstUser.length <= MAX_NAME_SIZE) {
//           result = firstUser + " is typing...";
//         } else {
//           result = firstUser.substring(0, MAX_NAME_SIZE - 1) + "… is typing...";
//         }
//         break;
//       case TWO_USERS:
//         String firstUser = usersName[0];
//         String secondUser = usersName[1];
//         if ((firstUser + secondUser).length > MAX_NAME_SIZE) {
//           firstUser = _getModifiedUserName(firstUser);
//           secondUser = _getModifiedUserName(secondUser);
//         }
//         result = firstUser + " and " + secondUser + " are typing...";
//         break;
//       default:
//         String firstUser = usersName[0];
//         String secondUser = usersName[1];
//         String thirdUser = usersName[2];
//
//         if ((firstUser + secondUser + thirdUser).length <= MAX_NAME_SIZE) {
//           result = firstUser +
//               ", " +
//               secondUser +
//               ", " +
//               thirdUser +
//               " are typing...";
//         } else {
//           firstUser = _getModifiedUserName(firstUser);
//           secondUser = _getModifiedUserName(secondUser);
//           result = firstUser +
//               ", " +
//               secondUser +
//               " and " +
//               (namesCount - 2).toString() +
//               " more are typing...";
//           break;
//         }
//     }
//     return result;
//   }
//
//   String _getModifiedUserName(String name) {
//     const int MAX_NAME_SIZE = 10;
//     if (name.length >= MAX_NAME_SIZE) {
//       name = name.substring(0, (MAX_NAME_SIZE) - 1) + "…";
//     }
//     return name;
//   }
//
//   buildMessageList(List<QBMessageWrapper> messageList) {
//     return (messageList.isEmpty)
//         ? Center(
//         child: Text("No Messages")
//     ) :  GroupedListView<QBMessageWrapper, DateTime>(
//       // shrinkWrap: true,
//       elements: messageList,
//       order: GroupedListOrder.DESC,
//       reverse: true,
//       floatingHeader: true,
//       useStickyGroupSeparators: true,
//       keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//       groupBy: (QBMessageWrapper message) =>
//           DateTime(message.date.year, message.date.month, message.date.day),
//       // padding: EdgeInsets.symmetric(horizontal: 0.w),
//       groupHeaderBuilder: (QBMessageWrapper message) =>
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Container(
//               margin: EdgeInsets.only(top: 7, bottom: 7),
//               padding: EdgeInsets.only(left: 16, right: 16, top: 3, bottom: 3),
//               decoration: BoxDecoration(
//                   color: Color(0xffd9e3f7),
//                   borderRadius: BorderRadius.all(Radius.circular(11))),
//               child: Text(_buildHeaderDate(message.qbMessage.dateSent),
//                   style: TextStyle(color: Colors.black54, fontSize: 13)),
//             )
//           ]),
//       itemBuilder: (context, QBMessageWrapper message) => Row(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Container(
//               child: message.isIncoming
//                   ? _generateAvatarFromName(message.senderName)
//                   : null),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(top: 15),
//               child: Column(
//                 crossAxisAlignment: message.isIncoming
//                     ? CrossAxisAlignment.start
//                     : CrossAxisAlignment.end,
//                 children: [
//                   IntrinsicWidth(
//                     child: (message.qbMessage.attachments == null ||
//                         message.qbMessage.attachments!.isEmpty)
//                         ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       // overflow: Overflow.visible,
//                       // clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(
//                               left: 16, right: 16, top: 13, bottom: 13),
//                           constraints: BoxConstraints(maxWidth: 70.w),
//                           margin: message.isIncoming
//                               ? EdgeInsets.only(
//                               top: 1.h, bottom: 1.h, left: 5)
//                               : EdgeInsets.only(
//                               top: 1.h, bottom: 1.h, right: 5),
//                           // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
//                           decoration: BoxDecoration(
//                               color: message.isIncoming
//                                   ? gBackgroundColor
//                                   : gsecondaryColor,
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(18),
//                                   topRight: Radius.circular(18),
//                                   bottomLeft: message.isIncoming
//                                       ? Radius.circular(0)
//                                       : Radius.circular(18),
//                                   bottomRight: message.isIncoming
//                                       ? Radius.circular(18)
//                                       : Radius.circular(0))),
//                           child: Text(
//                             message.qbMessage.body ?? '',
//                             style: TextStyle(
//                                 fontFamily: kFontBook,
//                                 height: 1.5,
//                                 color: message.isIncoming
//                                     ? gsecondaryColor
//                                     : gWhiteColor,
//                                 fontSize: 10.sp),
//                           ),
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: _buildNameTimeHeader(message),
//                         ),
//                       ],
//                     )
//                         : FutureBuilder(
//                         future: _quickBloxService!.getQbAttachmentUrl(
//                             message.qbMessage.attachments!.first!.id!),
//                         builder: (_, imgUrl) {
//                           print('imgUrl.hasError: ${imgUrl.hasError}');
//                           if (imgUrl.hasData) {
//                             QBFile? _file;
//                             print("imgUrl.runtimeType: ${imgUrl.data.runtimeType}");
//                             _file = (imgUrl.data as Map)['file'];
//                             // print('_file!.name: ${_file!.name}');
//                             return Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.stretch,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     if(message.qbMessage.attachments!.first!.type == 'application/pdf'){
//                                       Navigator.push(context, PageRouteBuilder(
//                                         opaque: false, // set to false
//                                         pageBuilder: (_, __, ___) {
//                                           return MealPdf(pdfLink: (imgUrl.data as Map)['url'],);
//                                         },
//                                       ));
//                                     }
//                                     else{
//                                       Navigator.push(context, PageRouteBuilder(
//                                         opaque: false, // set to false
//                                         pageBuilder: (_, __, ___) {
//                                           return showImageFullScreen((imgUrl.data as Map)['url']);
//                                         },
//                                       ));
//                                     }
//                                   },
//                                   child: Container(
//                                     height: message.qbMessage.attachments!
//                                         .first!.type ==
//                                         'application/pdf'
//                                         ? null
//                                         : 200,
//                                     padding: EdgeInsets.only(
//                                         left: 16,
//                                         right: 16,
//                                         top: 13,
//                                         bottom: 13),
//                                     constraints:
//                                     BoxConstraints(maxWidth: 70.w),
//                                     margin: message.isIncoming
//                                         ? EdgeInsets.only(
//                                         top: 1.h,
//                                         bottom: 1.h,
//                                         left: 5)
//                                         : EdgeInsets.only(
//                                         top: 1.h,
//                                         bottom: 1.h,
//                                         right: 5),
//                                     // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
//                                     decoration: (message
//                                         .qbMessage
//                                         .attachments!
//                                         .first!
//                                         .type ==
//                                         'application/pdf')
//                                         ? BoxDecoration(
//                                         color: message.isIncoming
//                                             ? gHintTextColor
//                                             : gsecondaryColor,
//                                         borderRadius: BorderRadius.only(
//                                             topLeft:
//                                             Radius.circular(18),
//                                             topRight:
//                                             Radius.circular(18),
//                                             bottomLeft: message.isIncoming
//                                                 ? Radius.circular(0)
//                                                 : Radius.circular(18),
//                                             bottomRight: message.isIncoming
//                                                 ? Radius.circular(18)
//                                                 : Radius.circular(0)))
//                                         : BoxDecoration(
//                                         image: DecorationImage(
//                                             filterQuality:
//                                             FilterQuality.high,
//                                             fit: BoxFit.fill,
//                                             image: CachedNetworkImageProvider((imgUrl.data as Map)['url'])),
//                                         boxShadow: [BoxShadow(color: gHintTextColor, blurRadius: 0.2)],
//                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomLeft: message.isIncoming ? Radius.circular(0) : Radius.circular(18), bottomRight: message.isIncoming ? Radius.circular(18) : Radius.circular(0))),
//                                     child: (message.qbMessage.attachments!
//                                         .first!.type ==
//                                         'application/pdf')
//                                         ? (_file != null)
//                                         ? Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             _file.name ?? '',
//                                             maxLines: 2,
//                                             style: TextStyle(
//                                                 fontSize: 10.sp,
//                                                 fontFamily:
//                                                 kFontMedium,
//                                                 color: gWhiteColor),
//                                           ),
//                                         ),
//                                         IconButton(
//                                           icon: Icon(Icons.download,
//                                             color: Colors.white,),
//                                           onPressed: () async{
//                                             if(_file != null){
//                                               await _quickBloxService!.downloadFile((imgUrl.data as Map)['url'], _file.name!)
//                                                   .then((value) {
//                                                 File file = value as File;
//
//                                                 AppConfig().showSnackbar(context, "file saved to ${file.path}");
//                                               }).onError((error, stackTrace) {
//                                                 AppConfig().showSnackbar(context, "file download error");
//                                               });
//                                             }
//                                           },
//                                         )
//                                       ],
//                                     )
//                                         : null
//                                         : null,
//                                   ),
//                                 ),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: _buildNameTimeHeader(message),
//                                 )
//                               ],
//                             );
//                           } else {
//                             print("imgUrl.error: ${imgUrl.error}");
//                             return SizedBox.shrink(
//                                 child: Text('Not found'));
//                           }
//                           return SizedBox.shrink();
//                         }),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       controller: _scrollController,
//     );
//   }
//
//   List<Widget> _buildNameTimeHeader(message) {
//     return <Widget>[
//       Padding(padding: EdgeInsets.only(left: 16)),
//       _buildSenderName(message),
//       Padding(padding: EdgeInsets.only(left: 7)),
//       Expanded(child: SizedBox.shrink()),
//       message.isIncoming ? SizedBox.shrink() : _buildMessageStatus(message),
//       Padding(padding: EdgeInsets.only(left: 3)),
//       _buildDateSent(message),
//       Padding(padding: EdgeInsets.only(left: 16))
//     ];
//   }
//
//   Widget _buildMessageStatus(message) {
//     var deliveredIds = message.qbMessage.deliveredIds;
//     var readIds = message.qbMessage.readIds;
//     // if (_dialogType == QBChatDialogTypes.PUBLIC_CHAT) {
//     //   return SizedBox.shrink();
//     // }
//     if (readIds != null && readIds.length > 1) {
//       return Icon(
//         Icons.done_all,
//         color: Colors.blue,
//         size: 14,
//       );
//     } else if (deliveredIds != null && deliveredIds.length > 1) {
//       return Icon(Icons.done_all, color: gHintTextColor, size: 14);
//     } else {
//       return Icon(Icons.done, color: gHintTextColor, size: 14);
//     }
//   }
//
//   Widget _buildSenderName(message) {
//     return Text(message.senderName ?? "Noname",
//         maxLines: 1,
//         style: TextStyle(
//             fontSize: 8.5.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.black54));
//   }
//
//   Widget _buildDateSent(message) {
//     return Text(_buildTime(message.qbMessage.dateSent!),
//         maxLines: 1, style: TextStyle(fontSize: 10.sp, color: Colors.black54));
//   }
//
//   String _buildTime(int timeStamp) {
//     String completedTime = "";
//     DateFormat timeFormat = DateFormat("HH:mm");
//     DateTime messageTime =
//         new DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
//     completedTime = timeFormat.format(messageTime);
//
//     return completedTime;
//   }
//
//   Widget _generateAvatarFromName(String? name) {
//     if (name == null) {
//       name = "Noname";
//     }
//     return Container(
//       width: 20,
//       height: 20,
//       decoration: new BoxDecoration(
//           color: gMainColor.withOpacity(0.18),
//           borderRadius: new BorderRadius.all(Radius.circular(20))),
//       child: Center(
//         child: Text(
//           '${name.substring(0, 1).toUpperCase()}',
//           style: TextStyle(
//               color: gPrimaryColor,
//               fontWeight: FontWeight.bold,
//               fontFamily: kFontMedium),
//         ),
//       ),
//     );
//   }
//
//   showAttachmentSheet(BuildContext context) {
//     return showModalBottomSheet(
//         backgroundColor: Colors.transparent,
//         context: context,
//         enableDrag: false,
//         builder: (ctx) {
//           return Wrap(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//                 margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(20),
//                       topLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20),
//                       bottomLeft: Radius.circular(20)),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
//                       child: Text('Choose File Source'),
//                       decoration: BoxDecoration(
//                           border: Border(
//                         bottom: BorderSide(
//                           color: gHintTextColor,
//                           width: 3.0,
//                         ),
//                       )),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         iconWithText(Icons.insert_drive_file, 'Document', () {
//                           pickFromFile();
//                           Navigator.pop(context);
//                         }),
//                         iconWithText(Icons.camera_enhance_outlined, 'Camera',
//                             () {
//                           getImageFromCamera();
//                           Navigator.pop(context);
//                         }),
//                         iconWithText(Icons.image, 'Gallery', () {
//                           getImageFromCamera(fromCamera: false);
//                           Navigator.pop(context);
//                         }),
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           );
//         });
//   }
//
//   String _buildHeaderDate(int? timeStamp) {
//     String completedDate = "";
//     DateFormat dayFormat = DateFormat("d MMMM");
//     DateFormat lastYearFormat = DateFormat("dd.MM.yy");
//
//     DateTime now = DateTime.now();
//     var today = DateTime(now.year, now.month, now.day);
//     var yesterday = DateTime(now.year, now.month, now.day - 1);
//
//     if (timeStamp == null) {
//       timeStamp = 0;
//     }
//     DateTime messageTime =
//         DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
//     DateTime messageDate =
//         DateTime(messageTime.year, messageTime.month, messageTime.day);
//
//     if (today == messageDate) {
//       completedDate = "Today";
//     } else if (yesterday == messageDate) {
//       completedDate = "Yesterday";
//     } else if (now.year == messageTime.year) {
//       completedDate = dayFormat.format(messageTime);
//     } else {
//       completedDate = lastYearFormat.format(messageTime);
//     }
//
//     return completedDate;
//   }
//
//   iconWithText(IconData assetName, String optionName, VoidCallback onPress) {
//     return GestureDetector(
//       onTap: onPress,
//       child: SizedBox(
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(10),
//               decoration:
//                   BoxDecoration(shape: BoxShape.circle, color: gPrimaryColor),
//               child: Center(
//                 child: Icon(
//                   assetName,
//                   color: gMainColor,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 4,
//             ),
//             Text(
//               optionName,
//               style: TextStyle(
//                 color: gTextColor,
//                 fontSize: 10.sp,
//                 fontFamily: "GothamMedium",
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   showImageFullScreen(String url) {
//     print(url);
//     return PhotoView(
//       imageProvider: CachedNetworkImageProvider(
//         url,
//       ),
//     );
//   }
//
//   // void unsubscribeNewMessage() {
//   //   if (_newMessageSubscription != null) {
//   //     _newMessageSubscription!.cancel();
//   //     _newMessageSubscription = null;
//   //     AppConfig().showSnackbar(
//   //         context, "Unsubscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
//   //   }
//   // }
//   //
//   // void unsubscribeDeliveredMessage() async {
//   //   if (_deliveredMessageSubscription != null) {
//   //     _deliveredMessageSubscription!.cancel();
//   //     _deliveredMessageSubscription = null;
//   //     AppConfig().showSnackbar(context,
//   //         "Unsubscribed: " + QBChatEvents.MESSAGE_DELIVERED);
//   //   }
//   // }
//   //
//   // void unsubscribeReadMessage() async {
//   //   if (_readMessageSubscription != null) {
//   //     _readMessageSubscription!.cancel();
//   //     _readMessageSubscription = null;
//   //     AppConfig().showSnackbar(context,
//   //         "Unsubscribed: " + QBChatEvents.MESSAGE_READ);
//   //   }
//   // }
//   //
//   // void unsubscribeUserTyping() async {
//   //   if (_userTypingSubscription != null) {
//   //     _userTypingSubscription!.cancel();
//   //     _userTypingSubscription = null;
//   //     AppConfig().showSnackbar(context,
//   //         "Unsubscribed: " + QBChatEvents.USER_IS_TYPING);
//   //   }
//   // }
//   //
//   // void unsubscribeUserStopTyping() async {
//   //   if (_userStopTypingSubscription != null) {
//   //     _userStopTypingSubscription!.cancel();
//   //     _userStopTypingSubscription = null;
//   //     AppConfig().showSnackbar(context,
//   //         "Unsubscribed: " + QBChatEvents.USER_STOPPED_TYPING);
//   //   }
//   // }
//   //
//   // void unsubscribeConnected() {
//   //   if (_connectedSubscription != null) {
//   //     _connectedSubscription!.cancel();
//   //     _connectedSubscription = null;
//   //     AppConfig().showSnackbar(context,
//   //         "Unsubscribed: " + QBChatEvents.CONNECTED);
//   //   }
//   // }
//   //
//   // void unsubscribeConnectionClosed() {
//   //   if (_connectionClosedSubscription != null) {
//   //     _connectionClosedSubscription!.cancel();
//   //     _connectionClosedSubscription = null;
//   //     AppConfig().showSnackbar(context,
//   //         "Unsubscribed: " + QBChatEvents.CONNECTION_CLOSED);
//   //   }
//   // }
//   //
//   // void unsubscribeReconnectionFailed() {
//   //   if (_reconnectionFailedSubscription != null) {
//   //     _reconnectionFailedSubscription!.cancel();
//   //     _reconnectionFailedSubscription = null;
//   //     AppConfig().showSnackbar(context,
//   //         "Unsubscribed: " + QBChatEvents.RECONNECTION_FAILED);
//   //   }
//   // }
//   //
//   // void unsubscribeReconnectionSuccess() {
//   //   if (_reconnectionSuccessSubscription != null) {
//   //     _reconnectionSuccessSubscription!.cancel();
//   //     _reconnectionSuccessSubscription = null;
//   //     AppConfig().showSnackbar(context,
//   //         "Unsubscribed: " + QBChatEvents.RECONNECTION_SUCCESSFUL);
//   //   }
//   // }
//
//   bool isError  = false;
//   String errorMsg = '';
//
//   joinChatRoom(String groupId) async {
//     print("groupId: ${groupId}");
//
//     Provider.of<QuickBloxService>(context, listen: false).
//     joinDialog(groupId)
//
//     // joinDialog("63bfe5b907a49d00325819d9")
//         .then((value) async{
//       print("value: $value");
//       // await Firebase.initializeApp();
//       final fcmToken = await FirebaseMessaging.instance.getToken();
//       QuickBloxRepository().initSubscription(fcmToken!);
//
//     }).onError((error, stackTrace) {
//       print('err: ${error}');
//       // if(PlatformException(e)
//       if(error.runtimeType == PlatformException){
//         PlatformException e = error as PlatformException;
//         if(e.message == null){
//           print(e.code);
//           setState((){
//             isError = true;
//             errorMsg = e.code ?? '';
//           });
//         }
//         else{
//           if(e.message!.toLowerCase().contains('need user')){
//             joinWithLogin(groupId);
//           }
//           else{
//             setState((){
//               isError = true;
//               errorMsg = e.message ?? '';
//             });
//             // _qbService.connect(_pref.getInt(AppConfig.QB_CURRENT_USERID)!);
//           }
//         }
//       }
//     });
//
//     // print(res.runtimeType);
//
//     Future.delayed(Duration(seconds: 15)).whenComplete(() {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   joinWithLogin(String groupId) async{
//     String? username = _pref!.getString(AppConfig.QB_USERNAME)!;
//     print(username);
//     final res = await _quickBloxService!.login(username);
//
//     if(res){
//      joinChatRoom(groupId);
//     }
//   }
//
//   joinWithConnect(String groupId) async{
//     int? userId = int.parse(_pref!.getString(AppConfig.QB_CURRENT_USERID)!);
//     _quickBloxService!.connect(userId);
//
//     // if(res){
//     //   joinChatRoom(groupId);
//     // }
//   }
//
//
//   File? _image;
//
//   List<PlatformFile> files = [];
//
//   Future getImageFromCamera({bool fromCamera = true}) async {
//     var image = await ImagePicker.platform.pickImage(
//         source: fromCamera ? ImageSource.camera : ImageSource.gallery,
//         imageQuality: 50);
//
//     setState(() {
//       _image = File(image!.path);
//     });
//     sendQbAttachment(_image!.path);
//     print("captured image: ${_image}");
//   }
//
//   void pickFromFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       withReadStream: true,
//       type: FileType.any,
//       // allowedExtensions: ['pdf', 'jpg', 'png'],
//       allowMultiple: false,
//     );
//     if (result == null) return;
//
//     if (result.files.first.extension!.contains("pdf") ||
//         result.files.first.extension!.contains("png") ||
//         result.files.first.extension!.contains("jpg")) {
//       if (getFileSize(File(result.paths.first!)) <= 10) {
//         print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
//         files.add(result.files.first);
//       } else {
//         AppConfig()
//             .showSnackbar(context, "File size must be < 10Mb", isError: true);
//       }
//     } else {
//       AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
//           isError: true);
//     }
//     print("selected file: ${files.first.identifier}");
//     print(lookupMimeType(files.first.path!));
//     sendQbAttachment(files.first.path!);
//     setState(() {});
//   }
//
//   getFileSize(File file) {
//     var size = file.lengthSync();
//     num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
//     return mb;
//   }
//
//   sendQbAttachment(String url) async {
//     try {
//       QBFile? file;
//       file = await QB.content.upload(url);
//       if (file != null) {
//         int id = file.id!;
//         String contentType = file.contentType!;
//
//         QBAttachment attachment = QBAttachment();
//         attachment.id = id.toString();
//         attachment.contentType = contentType;
//
//         //Required parameter
//         attachment.type = lookupMimeType(url);
//         attachment.contentType = lookupMimeType(url);
//
//         List<QBAttachment> attachmentsList = [];
//         attachmentsList.add(attachment);
//
//         QBMessage message = QBMessage();
//         message.attachments = attachmentsList;
//
//         _quickBloxService!.sendMessage(_groupId!, attachments: attachmentsList);
//
//         // Send a message logic
//       }
//     } catch (e) {}
//   }
// }
//
// class Message {
//   final String text;
//   final DateTime date;
//   final bool sendMe;
//   final String image;
//
//   Message(
//       {required this.text,
//       required this.date,
//       required this.sendMe,
//       required this.image});
// }
