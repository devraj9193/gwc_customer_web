/*
This screen will be base class which will holds bottom sheet
 */

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:gwc_customer_web/screens/profile_screens/settings_screen.dart';
import 'package:gwc_customer_web/screens/testimonial_list_screen/testimonial_new_screen.dart';
import 'package:gwc_customer_web/screens/uvdesk/ticket_chat_screens/ticket_chat_screen.dart';
import 'package:sizer/sizer.dart';
import '../model/error_model.dart';
import '../model/evaluation_from_models/evaluation_model_format1.dart';
import '../model/uvdesk_model/new_ticket_details_model.dart';
import '../repository/api_service.dart';
import '../repository/uvdesk_repository/uvdesk_repo.dart';
import '../services/uvdesk_service/uv_desk_service.dart';
import '../utils/app_config.dart';
import '../widgets/constants.dart';
import '../widgets/exit_widget.dart';
import '../widgets/widgets.dart';
import 'appointment_screens/doctor_calender_time_screen.dart';
import 'cook_kit_shipping_screens/tracking_pop_up.dart';
import 'evalution_form/evaluation_upload_report.dart';
import 'feed_screens/feeds_list.dart';
import 'gut_list_screens/new_list_stages_screen.dart';
import 'home_screens/home_screen.dart';
import 'home_screens/level_status.dart';
import 'home_screens/water_intake/water_level_screen.dart';
import 'medical_program_feedback_screen/card_selection.dart';
import 'medical_program_feedback_screen/final_feedback_form.dart';
import 'profile_screens/call_support_method.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

class DashboardScreen extends StatefulWidget {
  final int index;
  const DashboardScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ConvexAppBarState> _appBarKey =
      GlobalKey<ConvexAppBarState>();

  int _bottomNavIndex = 2;

  final int save_prev_index = 2;

  /// this param is used to show FAB
  /// when this false than we r not showing FAB
  bool showFab = true;
  bool isReplied = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getThreadsList();
    setState(() {
      _bottomNavIndex = widget.index;
    });
  }

  late final UvDeskService _uvDeskService =
      UvDeskService(uvDeskRepo: repository);

  NewTicketDetailsModel? threadsListModel;

  getThreadsList() async {
    final result = await _uvDeskService.getTicketDetailsByIdService(
        "${_pref.getString(AppConfig.User_ticket_id)}");
    print("result: $result");

    if (result.runtimeType == NewTicketDetailsModel) {
      print("Threads List");
      NewTicketDetailsModel model = result as NewTicketDetailsModel;
      threadsListModel = model;
      setState(() {
          _pref.setBool("isReplied",model.ticket!.isReplied!);
          // isReplied = model.ticket!.isReplied!;
          print("isReplied api : ${model.ticket!.isReplied!}");
          print("isReplied : ${_pref.getBool("isReplied")!}");
          isReplied = _pref.getBool("isReplied") ?? false;
      });
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    print(result);
  }

  // void _onItemTapped(int index) {
  //   if (index != 3) {
  //     setState(() {
  //       _bottomNavIndex = index;
  //     });
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const ProfileScreen()),
  //     );
  //   }
  //   if (index != 2) {
  //     setState(() {
  //       _bottomNavIndex = index;
  //     });
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const QuriesScreen()),
  //     );
  //   }
  //   if (index != 1) {
  //     setState(() {
  //       _bottomNavIndex = index;
  //     });
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const CustomerStatusScreen()),
  //     );
  //   }
  // }

  pageCaller(int index) {
    switch (index) {
      case 0:
        {
          // return NewTransitionDesign(
          //     postProgramStage: "",
          //     totalDays: '1',
          //     dayNumber: '0',
          // );

           // return const PostGutTypeDiagnosis();
          // return CombinedPrepMealTransScreen(stage: 1,);
          // this one
          // return const TrackerUI(from: '');
          //  return EvaluationUploadReport();
            return const LevelStatus();

          // return const HomeScreens();
        }
      case 1:
        {
          // return RadialSliderExample();
          //  return FinalFeedbackForm();
          return const FeedsList();
        }
      case 2:
        {
          // this one
          return const NewDsPage();
          // butterfly design
          // return GutList();
          // return const NewDashboardLevelsScreen();
        }
      case 3:
        {
          return const TestimonialNewScreen();
          // return const TestimonialListScreen();
        }
      case 4:
        {
          return SettingsScreen(showBadge: isReplied,);
        }
    }
  }

  bool showProgress = false;
  final _pref = AppConfig().preferences!;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pageCaller(_bottomNavIndex),
        floatingActionButton: showFab
            ? isReplied
                ? badges.Badge(
                    badgeAnimation: badges.BadgeAnimation.rotation(
                      animationDuration: Duration(seconds: 1),
                      colorChangeAnimationDuration: Duration(seconds: 1),
                      loopAnimation: false,
                      curve: Curves.fastOutSlowIn,
                      colorChangeAnimationCurve: Curves.easeInCubic,
                    ),
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: gWhiteColor,
                      // padding: EdgeInsets.all(5),
                      // borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                          color: gsecondaryColor.withOpacity(0.7), width: 3),
                      // borderGradient: badges.BadgeGradient.linear(
                      //     colors: [Colors.red, Colors.black]),
                      // badgeGradient: badges.BadgeGradient.linear(
                      //   colors: [Colors.blue, Colors.yellow],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
                      elevation: 0,
                    ),
                    badgeContent: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        '1',
                        style: TextStyle(color: gBlackColor),
                      ),
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketChatScreen(
                              userName:
                                  "${_pref.getString(AppConfig.User_Name)}",
                              thumbNail:
                                  "${_pref.getString(AppConfig.User_Profile)}",
                              ticketId:
                                  "${_pref.getString(AppConfig.User_ticket_id)}",
                              subject: '',
                              email: "${_pref.getString(AppConfig.User_Email)}",
                              ticketStatus: 1 ?? -1,
                            ),
                          ),
                        );
                      },
                      backgroundColor: gsecondaryColor.withOpacity(0.7),
                      child: const ImageIcon(
                        AssetImage("assets/images/noun-chat-5153452.png"),
                      ),
                    ),
                  )
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketChatScreen(
                            userName: "${_pref.getString(AppConfig.User_Name)}",
                            thumbNail:
                                "${_pref.getString(AppConfig.User_Profile)}",
                            ticketId:
                                "${_pref.getString(AppConfig.User_ticket_id)}",
                            subject: '',
                            email: "${_pref.getString(AppConfig.User_Email)}",
                            ticketStatus: 1 ?? -1,
                          ),
                        ),
                      );
                    },
                    backgroundColor: gsecondaryColor.withOpacity(0.7),
                    child: const ImageIcon(
                      AssetImage("assets/images/noun-chat-5153452.png"),
                    ),
                  )
            : null,
        // floatingActionButton: showFab
        //     ? FloatingActionButton(
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (_) => TicketChatScreen(
        //                 userName: "${_pref.getString(AppConfig.User_Name)}",
        //                 thumbNail: "${_pref.getString(AppConfig.User_Profile)}",
        //                 ticketId:
        //                     "${_pref.getString(AppConfig.User_ticket_id)}",
        //                 subject: '',
        //                 email: "${_pref.getString(AppConfig.User_Email)}",
        //                 ticketStatus: 1 ?? -1,
        //               ),
        //             ),
        //           );
        //         },
        //         backgroundColor: gsecondaryColor.withOpacity(0.7),
        //         child: isReplied
        //             ? Stack(
        //                 clipBehavior: Clip.none,
        //                 children: [
        //                   const ImageIcon(
        //                     AssetImage("assets/images/noun-chat-5153452.png"),
        //                   ),
        //                   Positioned(
        //                     top: -5,
        //                     right: -10,
        //                     child: Container(
        //                       padding: EdgeInsets.all(2),
        //                       decoration: BoxDecoration(
        //                         color: Colors.blue,
        //                         borderRadius: BorderRadius.circular(3),
        //                       ),
        //                       child: Text(
        //                         'New',
        //                         style: TextStyle(
        //                             fontFamily: kFontMedium,
        //                             color: gWhiteColor,
        //                             fontSize: 6.sp,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               )
        //             : const ImageIcon(
        //                 AssetImage("assets/images/noun-chat-5153452.png"),
        //               ),
        //       )
        //     : null,
        // floatingActionButton: showFab ? FloatingActionButton(
        //   onPressed: (showProgress) ? null : () async{
        //     setState(() {
        //       showProgress = true;
        //     });
        //     final uId =
        //     _pref.getString(AppConfig.KALEYRA_USER_ID);
        //     final res = await getAccessToken(uId!);
        //
        //     if (res.runtimeType != ErrorModel) {
        //       final accessToken = _pref.getString(
        //           AppConfig.KALEYRA_ACCESS_TOKEN);
        //
        //       final chatSuccessId = _pref.getString(
        //           AppConfig.KALEYRA_CHAT_SUCCESS_ID);
        //       print("chatSuccessId: $chatSuccessId");
        //       print("chatToken: $accessToken");
        //
        //       // when successId is null or empty than hiding FAB
        //       if(chatSuccessId == ""){
        //         setState(() {
        //           showFab = false;
        //         });
        //         print("showFab: $showFab");
        //       }
        //       // chat
        //       openKaleyraChat(
        //           uId, chatSuccessId!, accessToken!);
        //     }
        //     else {
        //       final result = res as ErrorModel;
        //       print(
        //           "get Access Token error: ${result.message}");
        //       AppConfig().showSnackbar(
        //           context, result.message ?? '',
        //           isError: true, bottomPadding: 70);
        //     }
        //     setState(() {
        //       showProgress = false;
        //     });
        //   },
        //   backgroundColor: gsecondaryColor.withOpacity(0.7),
        //   child: showProgress ?
        //   Center(child: SizedBox(
        //     height: 15,
        //     width: 15,
        //     child: CircularProgressIndicator(color: gWhiteColor,),
        //   ),)
        //       : ImageIcon(
        //     AssetImage("assets/images/noun-chat-5153452.png")
        //   ),
        // ) : null,
        bottomNavigationBar: ConvexAppBar(
          key: _appBarKey,
          style: TabStyle.react,
          backgroundColor: Colors.white,
          // curveSize: 500,
          height: 7.h,
          items: [
            TabItem(
              icon: _bottomNavIndex == 0
                  ? Image.asset(
                      "assets/images/Group 3241.png",
                      color: gsecondaryColor,
                    )
                  : Image.asset(
                      "assets/images/Group 3844.png",
                    ),
            ),
            TabItem(
              icon: _bottomNavIndex == 1
                  ? Image.asset(
                      "assets/images/Group 3240.png",
                      color: gsecondaryColor,
                    )
                  : Image.asset(
                      "assets/images/Group 3846.png",
                    ),
            ),
            TabItem(
              icon: _bottomNavIndex == 2
                  ? Image.asset(
                      "assets/images/Group 3331.png",
                      color: gsecondaryColor,
                    )
                  : Image.asset(
                      "assets/images/Group 3848.png",
                    ),
            ),
            TabItem(
              icon: _bottomNavIndex == 3
                  ? Image.asset(
                      "assets/images/Path 14368.png",
                      color: gsecondaryColor,
                    )
                  : Image.asset(
                      "assets/images/Group 3847.png",
                    ),
            ),
            TabItem(
              icon: _bottomNavIndex == 4
                  ? Image.asset(
                      "assets/images/Group 3239.png",
                      color: gsecondaryColor,
                    )
                  : Image.asset(
                      "assets/images/Group 3845.png",
                    ),
            ),
          ],
          initialActiveIndex: _bottomNavIndex,
          onTap: onChangedTab,
        ),
      ),
    );
  }

  void onChangedTab(int index) {
    final chatSuccessId = _pref.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID);
    print("chatSuccessId: $chatSuccessId");
    setState(() {
      _bottomNavIndex = index;
      if (_bottomNavIndex == 4 || chatSuccessId == "") {
        showFab = false;
      } else {
        showFab = true;
      }
    });
  }

  /// on back button press if we r in other index except 2
  /// than we r moving to 2nd index
  Future<bool> _onWillPop() {
    print('back pressed');
    print("_bottomNavIndex: $_bottomNavIndex");
    setState(() {
      if (_bottomNavIndex != 2) {
        if (_bottomNavIndex > save_prev_index ||
            _bottomNavIndex < save_prev_index) {
          _bottomNavIndex = save_prev_index;
          _appBarKey.currentState!.animateTo(_bottomNavIndex);
          setState(() {});
        } else {
          _bottomNavIndex = 2;
          _appBarKey.currentState!.animateTo(_bottomNavIndex);
          setState(() {});
        }
      } else {
        AppConfig().showSheet(
          context,
          const ExitWidget(),
          bottomSheetHeight: 45.h,
          isDismissible: true,
        );
      }
    });
    return Future.value(false);
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
