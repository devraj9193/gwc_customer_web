/*
this design not using

design type: level based ui
 */

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/dashboard_model/get_appointment/get_appointment_after_appointed.dart';
import 'package:gwc_customer_web/model/dashboard_model/get_dashboard_data_model.dart';
import 'package:gwc_customer_web/model/dashboard_model/get_program_model.dart';
import 'package:gwc_customer_web/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer_web/model/dashboard_model/shipping_approved/ship_approved_model.dart';
import 'package:gwc_customer_web/model/profile_model/user_profile/user_profile_model.dart';
import 'package:gwc_customer_web/model/ship_track_model/sipping_approve_model.dart';
import 'package:gwc_customer_web/repository/dashboard_repo/gut_repository/dashboard_repository.dart';
import 'package:gwc_customer_web/repository/login_otp_repository.dart';
import 'package:gwc_customer_web/repository/profile_repository/get_user_profile_repo.dart';
import 'package:gwc_customer_web/repository/shipping_repository/ship_track_repo.dart';
import 'package:gwc_customer_web/screens/appointment_screens/consultation_screens/check_user_report_screen.dart';
import 'package:gwc_customer_web/screens/appointment_screens/consultation_screens/consultation_rejected.dart';
import 'package:gwc_customer_web/screens/appointment_screens/consultation_screens/consultation_success.dart';
import 'package:gwc_customer_web/screens/appointment_screens/consultation_screens/medical_report_screen.dart';
import 'package:gwc_customer_web/screens/appointment_screens/doctor_calender_time_screen.dart';
import 'package:gwc_customer_web/screens/appointment_screens/doctor_slots_details_screen.dart';
import 'package:gwc_customer_web/screens/cook_kit_shipping_screens/cook_kit_tracking.dart';
import 'package:gwc_customer_web/screens/evalution_form/evaluation_get_details.dart';
import 'package:gwc_customer_web/screens/gut_list_screens/meal_popup.dart';
import 'package:gwc_customer_web/screens/home_remedies/home_remedies_screen.dart';
import 'package:gwc_customer_web/screens/post_program_screens/new_post_program/pp_levels_demo.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/prepratory_meal_completed_screen.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/prepratory_plan_screen.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/transition_mealplan_screen.dart';
import 'package:gwc_customer_web/screens/program_plans/meal_plan_screen.dart';
import 'package:gwc_customer_web/screens/program_plans/program_start_screen.dart';
import 'package:gwc_customer_web/services/dashboard_service/gut_service/dashboard_data_service.dart';
import 'package:gwc_customer_web/services/login_otp_service.dart';
import 'package:gwc_customer_web/services/profile_screen_service/user_profile_service.dart';
import 'package:gwc_customer_web/services/shipping_service/ship_track_service.dart';
import 'package:gwc_customer_web/widgets/vlc_player/vlc_player_with_controls.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:wakelock_plus/wakelock_plus.dart';
import '../../model/error_model.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/video/normal_video.dart';
import '../../widgets/widgets.dart';
import '../appointment_screens/consultation_screens/upload_files.dart';
import '../help_screens/help_screen.dart';
import '../notification_screen.dart';
import '../prepratory plan/new/preparatory_new_screen.dart';
import '../prepratory plan/schedule_screen.dart';
import '../profile_screens/call_support_method.dart';
import 'package:http/http.dart' as http;
import '../../repository/api_service.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class NewDashboardLevelsScreen extends StatefulWidget {
  const NewDashboardLevelsScreen({Key? key}) : super(key: key);

  @override
  State<NewDashboardLevelsScreen> createState() =>
      _NewDashboardLevelsScreenState();
}

class _NewDashboardLevelsScreenState extends State<NewDashboardLevelsScreen> {
  final _pref = AppConfig().preferences;

  String unlockGreenImage =
      "assets/images/dashboard_stages/noun-unlock-4202358.png";
  String unlockYellowImage =
      "assets/images/dashboard_stages/noun-unlock-4202358 (2).png";
  String lockImage = "assets/images/dashboard_stages/Locked.png";

  late Color unlockGreenColor = newDashboardGreenButtonColor;
  late Color unlockYellowColor = gMainColor;
  late Color lockColor = newDashboardLightGreyButtonColor;

  String unlockGreenCircleImage =
      "assets/images/dashboard_stages/Group 43551.png";
  String unlockYellowCircleImage =
      "assets/images/dashboard_stages/Group 43552.png";
  String lockCircleImage = "assets/images/dashboard_stages/Group 43553.png";

  String greenTrackGutCircle = "assets/images/dashboard_stages/Group 62696.png";
  String yellowTrackGutCircle =
      "assets/images/dashboard_stages/Group 62697.png";
  String greyTrackGutCircle = "assets/images/dashboard_stages/Group 62698.png";

  List<NewStageLevels> levels = [
    NewStageLevels(
        "assets/images/dashboard_stages/Group 43551.png",
        "assets/images/dashboard_stages/noun-evaluation-2234438.png",
        "Disorder Evaluation",
        'assets/images/dashboard_stages/noun-unlock-4202358.png',
        "A Critical information needed by our doctors to understand "
            "your Medical history, Symptoms, Sleep, Diet & Lifestyle for "
            "proper diagnosis! This evaluation by itself indicates the "
            "direction of our diagnosis. So please spend quality time to complete your evaluation",
        newDashboardGreenButtonColor,
        false,
        "View Files",
        newDashboardGreenButtonColor,
        "",
        newDashboardLightGreyButtonColor,
        StageType.evaluation),
    NewStageLevels(
        "assets/images/dashboard_stages/Group 43552.png",
        "assets/images/dashboard_stages/noun-appointment-3843032.png",
        "Medical Consultation",
        'assets/images/dashboard_stages/Locked.png',
        "Basis your Evaluation details, a video consultation is the next "
            "step for our doctors to diagnose the root cause of you Gut Issues. "
            "Post the consult your, MR (medical report) is uploaded & "
            "customized Meal Plan is loaded in your account & your Product Kit is despatched",
        gMainColor,
        true,
        "Schedule",
        newDashboardLightGreyButtonColor,
        "Join Consult",
        newDashboardLightGreyButtonColor,
        StageType.med_consultation),
    NewStageLevels(
        "assets/images/dashboard_stages/Group 43553.png",
        "assets/images/dashboard_stages/Group 43333.png",
        "Begin Gut Preparation",
        'assets/images/dashboard_stages/Locked.png',
        "A Critical information needed by our doctors to understand "
            "your Medical history, Symptoms, Sleep, Diet & Lifestyle for "
            "proper diagnosis! This evaluation by itself indicates the direction of our diagnosis. "
            "So please spend quality time to complete your evolution",
        newDashboardLightGreyButtonColor,
        false,
        "View Plan",
        newDashboardLightGreyButtonColor,
        "",
        newDashboardLightGreyButtonColor,
        StageType.prep_meal,
        showTrackGutIcon: true,
        trackGutIconCircleName:
            "assets/images/dashboard_stages/Group 62698.png",
        trackGutIconName: "assets/images/dashboard_stages/Group 43340.png",
        trackGutIconColor: newDashboardLightGreyButtonColor),
    NewStageLevels(
        "assets/images/dashboard_stages/Group 43553.png",
        "assets/images/dashboard_stages/noun-diet-3479279.png",
        "Gut Reset Program Start",
        'assets/images/dashboard_stages/Locked.png',
        "While you wait for your customised Product Kit arrive to be "
            "used during the Reset phase of the program, You will be give "
            "a preparatory meal protocol based on your food type "
            "This meal protocol immediately start enhancing you digestive "
            "juices and improving your gut motility",
        newDashboardLightGreyButtonColor,
        true,
        "View Plan",
        newDashboardLightGreyButtonColor,
        'Transition',
        newDashboardLightGreyButtonColor,
        StageType.normal_meal,
        showTrackGutIcon: true,
        trackGutIconCircleName:
            "assets/images/dashboard_stages/Group 62698.png",
        trackGutIconName: "assets/images/dashboard_stages/remedy.png",
        trackGutIconColor: newDashboardLightGreyButtonColor),
    NewStageLevels(
      "assets/images/dashboard_stages/Group 43553.png",
      "assets/images/dashboard_stages/noun-online-doctor-4378422.png",
      "Post Program Consultation",
      'assets/images/dashboard_stages/Locked.png',
      "A Critical information needed by our doctors to understand your Medical history, Symptoms, Sleep, Diet & Lifestyle for "
          "proper diagnosis! This evaluation by itself indicates the direction of our diagnosis. "
          "So please spend quality time to complete your evalution",
      newDashboardLightGreyButtonColor,
      true,
      "Schedule",
      newDashboardLightGreyButtonColor,
      "Join Consult",
      newDashboardLightGreyButtonColor,
      StageType.post_consultation,
    ),
  ];

  /// THIS IS FOR ABC DIALOG MEAL PLAN
  bool isMealProgressOpened = false;

  /// THIS IS FOR ABC DIALOG MEAL PLAN
  bool isShown = false;

  bool isProgressDialogOpened = true;

  String? consultationStage,
      shippingStage,
      programOptionStage,
      postProgramStage,
      transStage,
      prepratoryMealStage;

  /// this is used when data=appointment_booked status
  GetAppointmentDetailsModel? _getAppointmentDetailsModel,
      _postConsultationAppointment;

  /// ths is used when data = shipping_approved status
  ShippingApprovedModel? _shippingApprovedModel;

  GetProgramModel? _getProgramModel;

  GetPrePostMealModel? _prepratoryModel, _transModel;

  /// for other status we use this one(except shipping_approved & appointment_booked)
  GutDataModel? _gutDataModel,
      _gutShipDataModel,
      _gutProgramModel,
      _gutPostProgramModel,
      _prepProgramModel,
      _transMealModel;

  late GutDataService _gutDataService;

  VideoPlayerController? videoPlayerController1, videoPlayerController2;
  ChewieController ? _mealPlayerController, _aboutHomeStageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isConsultationCompleted = _pref?.getBool(AppConfig.consultationComplete) ?? false;

    getUserProfile();

    if (_pref!.getString(AppConfig().shipRocketBearer) == null ||
        _pref!.getString(AppConfig().shipRocketBearer)!.isEmpty) {
      getShipRocketToken();
    } else {
      String token = _pref!.getString(AppConfig().shipRocketBearer)!;
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      print('shiprocketToken : $payload');
      var date = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      if (!DateTime.now().difference(date).isNegative) {
        getShipRocketToken();
      }
    }

    getData();
  }

  void getShipRocketToken() async {
    print("getShipRocketToken called");
    ShipTrackService _shipTrackService =
        ShipTrackService(repository: shipTrackRepository);
    final getToken = await _shipTrackService.getShipRocketTokenService(
        AppConfig().shipRocketEmail, AppConfig().shipRocketPassword);
    print(getToken);
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("width: ${MediaQuery.of(context).size.width}");
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
        child: SafeArea(
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: getData,
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildAppBar(
                            () {
                              Navigator.pop(context);
                            },
                            isBackEnable: false,
                            showNotificationIcon: true,
                            notificationOnTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const NotificationScreen()));
                            },
                            showHelpIcon: true,
                            helpOnTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HelpScreen()));
                            },
                            showSupportIcon: true,
                            supportOnTap: () {
                              showSupportCallSheet(context);
                              // openAlertBox(
                              //     context: context,
                              //     isContentNeeded: false,
                              //     titleNeeded: true,
                              //     title: "Select Call Type",
                              //     positiveButtonName: "In App Call",
                              //     positiveButton: (){
                              //       callSupport();
                              //       Navigator.pop(context);
                              //     },
                              //     negativeButtonName: "Voice Call",
                              //     negativeButton: (){
                              //       Navigator.pop(context);
                              //       if(_pref!.getString(AppConfig.KALEYRA_SUCCESS_ID) == null){
                              //         AppConfig().showSnackbar(context, "Success Team Not available", isError: true);
                              //       }
                              //       else{
                              //         // // click-to-call
                              //         // callSupport();
                              //
                              //         if(_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) != null){
                              //           final accessToken = _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);
                              //           final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
                              //           final successId = _pref!.getString(AppConfig.KALEYRA_SUCCESS_ID);
                              //           // voice- call
                              //           supportVoiceCall(uId!, successId!, accessToken!);
                              //         }
                              //         else{
                              //           AppConfig().showSnackbar(context, "Something went wrong!!", isError: true);
                              //         }
                              //       }
                              //     }
                              // );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const NewScheduleScreen()));
                                },
                                child: Row(
                                  children: [
                                    ImageIcon(
                                      const AssetImage(
                                          "assets/images/new_ds/follow_up.png"),
                                      size: 11.sp,
                                      color: newDashboardLightGreyButtonColor,
                                    ),
                                    SizedBox(width: 0.5.w),
                                    Text(
                                      'Follow-up call',
                                      style: TextStyle(
                                        color: newDashboardLightGreyButtonColor,
                                        fontSize: headingFont,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Expanded(
                            child: Center(
                              child: (isProgressDialogOpened)
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey.withOpacity(0.3),
                                      highlightColor:
                                          Colors.grey.withOpacity(0.7),
                                      child: view(),
                                    )
                                  : view(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  showSupportCallSheet(BuildContext context) {
    return AppConfig().showSheet(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Please Select Call Type",
                style: TextStyle(
                    fontSize: bottomSheetHeadingFontSize,
                    fontFamily: bottomSheetHeadingFontFamily,
                    height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: kLineColor,
                thickness: 1.2,
              ),
            ),
            SizedBox(height: 1.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final res = await callSupport();
                    if (res.runtimeType != ErrorModel) {
                      AppConfig().showSnackbar(context,
                          "Call Initiated. Our success Team will call you soon.");
                    } else {
                      // final result = res as ErrorModel;
                      AppConfig().showSnackbar(context,
                          "You can call your Success Team Member once you book your appointment",
                          isError: true, bottomPadding: 50);
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: gsecondaryColor,
                        border: Border.all(color: kLineColor, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "In App Call",
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gWhiteColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Visibility(
                  visible: false,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (_pref!.getString(AppConfig.KALEYRA_SUCCESS_ID) ==
                          null) {
                        AppConfig().showSnackbar(
                            context, "Success Team Not available",
                            isError: true);
                      } else {
                        // // click-to-call
                        // callSupport();

                        if (_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) !=
                            null) {
                          final accessToken =
                              _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);
                          final uId =
                              _pref!.getString(AppConfig.KALEYRA_USER_ID);
                          final successId =
                              _pref!.getString(AppConfig.KALEYRA_SUCCESS_ID);
                          // voice- call
                          supportVoiceCall(uId!, successId!, accessToken!);
                        } else {
                          AppConfig().showSnackbar(
                              context, "Something went wrong!!",
                              isError: true);
                        }
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                          color: gWhiteColor,
                          border: Border.all(color: kLineColor, width: 0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Voice Call",
                        style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gsecondaryColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h)
          ],
        ),
        bottomSheetHeight: 40.h,
        isSheetCloseNeeded: true, sheetCloseOnTap: () {
      Navigator.pop(context);
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
        isSheetCloseNeeded: true, sheetCloseOnTap: () {
      Navigator.pop(context);
    });
  }

  view() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Flexible(
          //   flex: 1,
          //   child: SizedBox(
          //     height: 2.h
          //   ),
          //   // child:
          //   // Row(
          //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   //   children: [
          //   //     GestureDetector(
          //   //       onTap: () {},
          //   //       child: Column(
          //   //         children: [
          //   //           Stack(
          //   //             children: [
          //   //               Image(
          //   //                 height: 8.h,
          //   //                 image: const AssetImage(
          //   //                     "assets/images/dashboard_stages/Group 43608.png"),
          //   //               ),
          //   //               Positioned(
          //   //                 top: 1.5.h,
          //   //                 left: 3.w,
          //   //                 child: Image(
          //   //                   height: 3.5.w,
          //   //                   image: const AssetImage(
          //   //                       "assets/images/dashboard_stages/Group 43340.png"),
          //   //                 ),
          //   //               ),
          //   //             ],
          //   //           ),
          //   //           SizedBox(height: 1.h),
          //   //           Text(
          //   //             'Track Shipment',
          //   //             style: TextStyle(
          //   //               color: gBlackColor,
          //   //               fontSize: headingFont,
          //   //             ),
          //   //           )
          //   //         ],
          //   //       ),
          //   //     ),
          //   //     GestureDetector(
          //   //       onTap: () {},
          //   //       child: Column(
          //   //         children: [
          //   //           Stack(
          //   //             children: [
          //   //               Image(
          //   //                 height: 8.h,
          //   //                 image: const AssetImage(
          //   //                     "assets/images/dashboard_stages/Group 43609.png"),
          //   //               ),
          //   //               Positioned(
          //   //                 // top: 1.5.h,
          //   //                 // left: 3.w,
          //   //                 child: Image(
          //   //                   height: 4.5.w,
          //   //                   image: const AssetImage(
          //   //                       "assets/images/dashboard_stages/noun-intestine-2647136.png"),
          //   //                 ),
          //   //               ),
          //   //             ],
          //   //           ),
          //   //           SizedBox(height: 1.h),
          //   //           Text(
          //   //             'Track Gut Parameter',
          //   //             style: TextStyle(
          //   //               color: gBlackColor,
          //   //               fontSize: headingFont,
          //   //             ),
          //   //           )
          //   //         ],
          //   //       ),
          //   //     ),
          //   //   ],
          //   // ),
          // ),
          Flexible(
            child: Stack(
              children: [
                ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    reverse: true,
                    itemCount: levels.length,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          buildNewStages(
                            levels[index].title,
                            levels[index].subText,
                            levels[index].circleInsideimage,
                            levels[index].stageCircleImage,
                            levels[index].lockImage,
                            levels[index].stageColor,
                            "0${index + 1}",
                            levels[index].rescheduleButton,
                            levels[index].buttonTitle,
                            levels[index].button1Color,
                            levels[index].button2Title,
                            levels[index].button2Color,
                            levels[index].type,
                            showTrackGutIcon: levels[index].showTrackGutIcon,
                            trackGutIconName: levels[index].trackGutIconName,
                            trackGutIconCircleName:
                                levels[index].trackGutIconCircleName,
                            trackGutIconColor: levels[index].trackGutIconColor,
                            circleInsideStageImageColor:
                                levels[index].circleInsideImageColor,
                          ),
                        ],
                      );
                    }),
                Positioned(
                    top: 0.h,
                    left: 2.5.w,
                    child: Image(
                      height: 4.h,
                      image: const AssetImage(
                          "assets/images/dashboard_stages/noun-flag-120233.png"),
                    )),
                Positioned(
                  bottom: 0.h,
                  left: 0.2.w,
                  child: Image(
                    height: 2.5.h,
                    color: newDashboardGreenButtonColor,
                    image: const AssetImage(
                        "assets/images/dashboard_stages/noun-start-426402.png"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isSendApproveStatus = false;
  bool isPressed = false;
  sendApproveStatus(String status, {bool fromNull = false}) async {
    if (!isSendApproveStatus) {
      setState(() {
        isSendApproveStatus = true;
        isPressed = true;
      });
      print("isPressed: $isPressed");
      final res = await ShipTrackService(repository: shipTrackRepository)
          .sendShippingApproveStatusService(status);

      if (res.runtimeType == ShippingApproveModel) {
        ShippingApproveModel model = res as ShippingApproveModel;
        print('success: ${model.message}');
        // AppConfig().showSnackbar(context, model.message!);
        getData();
      } else {
        ErrorModel model = res as ErrorModel;
        print('error: ${model.message}');
        AppConfig().showSnackbar(context, model.message!);
      }
      setState(() {
        isPressed = false;
      });
    }
  }

  final GutDataRepository repository = GutDataRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final ShipTrackRepository shipTrackRepository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  abc() {
    Future.delayed(Duration(seconds: 0)).whenComplete(() {
      if (shippingStage == 'meal_plan_completed') {
        if (!isShown) {
          setState(() {
            isShown = true;
          });
        }
        mealReadySheet();
      }
    });
  }

  addUrlToVideoWhenAboutClickChewie(String url) async {
    print("url" + url);
    videoPlayerController2 = VideoPlayerController.network(Uri.parse(url).toString());
    _aboutHomeStageController = ChewieController(
        videoPlayerController: videoPlayerController2!,
        aspectRatio: 16/9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        // customControls: Center(
        //   child: FittedBox(
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepBackward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.replay_10),
        //         ),
        //         IconButton(
        //           onPressed: (){
        //             if(videoPlayerController!.value.isPlaying){
        //               videoPlayerController!.pause();
        //             }
        //             else{
        //               videoPlayerController!.play();
        //             }
        //             setState(() {
        //
        //             });
        //           },
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: (videoPlayerController!.value.isPlaying) ? Icon(Icons.pause)  : Icon(Icons.play_arrow),
        //         ),
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepForward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.forward_10),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        hideControlsTimer: Duration(seconds: 3),
        showControls: false

    );
    if (!await WakelockPlus.enabled) {
      WakelockPlus.enable();
    }
  }


  // VlcPlayerController? _aboutHomeStageController;
  // final _aboutHomeStageKey = GlobalKey<VlcPlayerWithControlsState>();
  // addUrlToVideoWhenAboutClick(String url) async {
  //   print("url" + url);
  //   _aboutHomeStageController = VlcPlayerController.network(
  //     Uri.parse(url).toString(),
  //     // url,
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.auto,
  //     autoPlay: true,
  //     options: VlcPlayerOptions(
  //       advanced: VlcAdvancedOptions([
  //         VlcAdvancedOptions.networkCaching(2000),
  //       ]),
  //       subtitle: VlcSubtitleOptions([
  //         VlcSubtitleOptions.boldStyle(true),
  //         VlcSubtitleOptions.fontSize(30),
  //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
  //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
  //         // works only on externally added subtitles
  //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
  //       ]),
  //       http: VlcHttpOptions([
  //         VlcHttpOptions.httpReconnect(true),
  //       ]),
  //       rtp: VlcRtpOptions([
  //         VlcRtpOptions.rtpOverRtsp(true),
  //       ]),
  //     ),
  //   );
  //   if (!await Wakelock.enabled) {
  //     Wakelock.enable();
  //   }
  // }

  whenAboutClickSheet() {
    return AppConfig().showSheet(
        context,
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: whenAboutClickVideo(),
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
        bottomSheetHeight: 65.h,
        isDismissible: true,
        sheetCloseOnTap: () {
      Navigator.pop(context);
      disposePlayer();
    }, isSheetCloseNeeded: true);
  }

  whenAboutClickVideo() {
    if (_aboutHomeStageController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: gPrimaryColor, width: 1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     blurRadius: 20,
            //     offset: const Offset(2, 10),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Center(
                child: OverlayVideo(
                  controller: _aboutHomeStageController!,
                )
              // child: VlcPlayerWithControls(
              //   key: _aboutHomeStageKey,
              //   controller: _aboutHomeStageController!,
              //   showVolume: false,
              //   showVideoProgress: false,
              //   seekButtonIconSize: 10.sp,
              //   playButtonIconSize: 14.sp,
              //   replayButtonSize: 10.sp,
              // ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    videoPlayerController1 = VideoPlayerController.network(Uri.parse(url).toString());
    _mealPlayerController = ChewieController(
        videoPlayerController: videoPlayerController1!,
        aspectRatio: 16/9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        // customControls: Center(
        //   child: FittedBox(
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepBackward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.replay_10),
        //         ),
        //         IconButton(
        //           onPressed: (){
        //             if(videoPlayerController!.value.isPlaying){
        //               videoPlayerController!.pause();
        //             }
        //             else{
        //               videoPlayerController!.play();
        //             }
        //             setState(() {
        //
        //             });
        //           },
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: (videoPlayerController!.value.isPlaying) ? Icon(Icons.pause)  : Icon(Icons.play_arrow),
        //         ),
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepForward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.forward_10),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        hideControlsTimer: Duration(seconds: 3),
        showControls: false

    );
    if (!await WakelockPlus.enabled) {
      WakelockPlus.enable();
    }
  }


  // VlcPlayerController? _mealPlayerController;
  // final _key = GlobalKey<VlcPlayerWithControlsState>();
  // addUrlToVideoPlayer(String url) async {
  //   print("url" + url);
  //   _mealPlayerController = VlcPlayerController.network(
  //     url,
  //     // url,
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.auto,
  //     autoPlay: true,
  //     options: VlcPlayerOptions(
  //       advanced: VlcAdvancedOptions([
  //         VlcAdvancedOptions.networkCaching(2000),
  //       ]),
  //       subtitle: VlcSubtitleOptions([
  //         VlcSubtitleOptions.boldStyle(true),
  //         VlcSubtitleOptions.fontSize(30),
  //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
  //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
  //         // works only on externally added subtitles
  //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
  //       ]),
  //       http: VlcHttpOptions([
  //         VlcHttpOptions.httpReconnect(true),
  //       ]),
  //       rtp: VlcRtpOptions([
  //         VlcRtpOptions.rtpOverRtsp(true),
  //       ]),
  //     ),
  //   );
  //   if (!await Wakelock.enabled) {
  //     Wakelock.enable();
  //   }
  // }

  disposePlayer() async {
    if(_mealPlayerController != null) _mealPlayerController!.dispose();
    if(videoPlayerController1 != null) videoPlayerController1!.dispose();

    // if (_mealPlayerController != null) {
    //   _mealPlayerController!.dispose();
    // }
    // if (_aboutHomeStageController != null) {
    //   _aboutHomeStageController!.dispose();
    // }
    if (await WakelockPlus.enabled) {
      WakelockPlus.disable();
    }
  }

  mealReadySheet() {
    addUrlToVideoPlayerChewie(_gutShipDataModel?.stringValue ?? '');
    return AppConfig().showSheet(
        context,
        Column(
          children: [
            Text(
              'Hooray!\nYour food prescription is ready',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.4,
                  fontSize: bottomSheetSubHeadingXLFontSize,
                  fontFamily: bottomSheetSubHeadingBoldFont,
                  color: gTextColor),
            ),
            // need ot show Video
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: buildMealVideo(),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8),
            //   child: Image.asset('assets/images/meal_popup.png',
            //     fit: BoxFit.scaleDown,
            //     width: 60.w,
            //     filterQuality: FilterQuality.high,
            //   ),
            // ),
            Text(
              "You've Unlocked The Next Step!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.2,
                  fontSize: bottomSheetSubHeadingXLFontSize,
                  fontFamily: bottomSheetSubHeadingMediumFont,
                  color: gTextColor),
            ),
            Text(
              "The Product Kit Is Ready. Shall We Ship It For You?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.2,
                  fontSize: bottomSheetSubHeadingXLFontSize,
                  fontFamily: bottomSheetSubHeadingBookFont,
                  color: gTextColor),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (isPressed)
                      ? () {}
                      : () {
                          Navigator.pop(context);
                          sendApproveStatus('yes');
                          setState(() {
                            isShown = false;
                          });
                          disposePlayer();
                          if (isMealProgressOpened) {
                            Navigator.pop(context);
                          }
                        },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                        color: gsecondaryColor,
                        border: Border.all(color: kLineColor, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "YES",
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gWhiteColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: (isPressed)
                      ? () {}
                      : () {
                          Navigator.pop(context);
                          sendApproveStatus('no');
                          setState(() {
                            isShown = false;
                          });
                          disposePlayer();
                          if (isMealProgressOpened) {
                            Navigator.pop(context);
                          }
                        },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                        color: gWhiteColor,
                        border: Border.all(color: kLineColor, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "NO",
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gsecondaryColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
        isDismissible: true,
        bottomSheetHeight: 75.h);
  }

  buildMealVideo() {
    if (_mealPlayerController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: gPrimaryColor, width: 1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     blurRadius: 20,
            //     offset: const Offset(2, 10),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Center(
              child: OverlayVideo(
                controller: _mealPlayerController!,
              )
              // child: VlcPlayerWithControls(
              //   key: _key,
              //   controller: _mealPlayerController!,
              //   showVolume: false,
              //   showVideoProgress: false,
              //   seekButtonIconSize: 10.sp,
              //   playButtonIconSize: 14.sp,
              //   replayButtonSize: 10.sp,
              // ),
            ),
          ),
          // child: Stack(
          //   children: <Widget>[
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(5),
          //       child: Center(
          //         child: VlcPlayer(
          //           controller: _videoPlayerController!,
          //           aspectRatio: 16 / 9,
          //           virtualDisplay: false,
          //           placeholder: Center(child: CircularProgressIndicator()),
          //         ),
          //       ),
          //     ),
          //     ControlsOverlay(controller: _videoPlayerController,)
          //   ],
          // ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  getUserProfile() async {
    // print("user id: ${_pref!.getInt(AppConfig.KALEYRA_USER_ID)}");

    if (_pref!.getString(AppConfig.User_Name) != null ||
        _pref!.getString(AppConfig.User_Name)!.isNotEmpty) {
      final profile = await UserProfileService(repository: userRepository)
          .getUserProfileService();
      if (profile.runtimeType == UserProfileModel) {
        UserProfileModel model1 = profile as UserProfileModel;
        _pref!.setString(
            AppConfig.User_Name, model1.data?.name ?? model1.data?.fname ?? '');
        _pref!.setInt(AppConfig.USER_ID, model1.data?.id ?? -1);
        _pref!.setString(AppConfig.QB_USERNAME, model1.data!.qbUsername ?? '');
        _pref!.setString(
            AppConfig.QB_CURRENT_USERID, model1.data!.qbUserId ?? '');
        _pref!.setString(AppConfig.KALEYRA_USER_ID, model1.data!.kaleyraUID!);

        if (_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) == null) {
          await LoginWithOtpService(repository: loginOtpRepository)
              .getAccessToken(model1.data!.kaleyraUID!);
        }
        print("user profile: ${_pref!.getString(AppConfig.QB_CURRENT_USERID)}");
      }
    }
    // if(_pref!.getInt(AppConfig.QB_CURRENT_USERID) != null && !await _qbService!.getSession() || _pref!.getBool(AppConfig.IS_QB_LOGIN) == null){
    //   String _uName = _pref!.getString(AppConfig.QB_USERNAME)!;
    //   _qbService!.login(_uName);
    // }
  }

  final LoginOtpRepository loginOtpRepository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  Future<void> reloadUI() async {
    await getData();
    setState(() {});
  }

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  GetDashboardDataModel? _getDashboardDataModel;
  Future getData() async {
    isProgressDialogOpened = true;
    print("isProgressDialogOpened: $isProgressDialogOpened");

    _gutDataService = GutDataService(repository: repository);
    print("isProgressDialogOpened: $isProgressDialogOpened");

    final _getData = await _gutDataService.getGutDataService();
    print("_getData: $_getData");
    if (_getData.runtimeType == ErrorModel) {
      ErrorModel model = _getData;
      print(model.message);
      isProgressDialogOpened = false;
      Future.delayed(Duration(seconds: 0)).whenComplete(
          () => AppConfig().showSnackbar(context, model.message ?? '',
              isError: true,
              duration: 50000,
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  getData();
                },
              )));
    } else {
      isProgressDialogOpened = false;
      print("isProgressDialogOpened: $isProgressDialogOpened");
      _getDashboardDataModel = _getData as GetDashboardDataModel;
      print(
          "_getDashboardDataModel.app_consulation: ${_getDashboardDataModel!.app_consulation}");

      // checking for the consultation data if data = appointment_booked
      setState(() {
        if (_getDashboardDataModel!.app_consulation != null) {
          _getAppointmentDetailsModel = _getDashboardDataModel!.app_consulation;
          consultationStage = _getAppointmentDetailsModel?.data ?? '';
        } else {
          _gutDataModel = _getDashboardDataModel!.normal_consultation;
          consultationStage = _gutDataModel?.data ?? '';
        }
        updateNewStage(consultationStage);
        if (_getDashboardDataModel!.prepratory_normal_program != null) {
          _prepProgramModel = _getDashboardDataModel!.prepratory_normal_program;
          prepratoryMealStage = _prepProgramModel?.data ?? '';
        } else if (_getDashboardDataModel!.prepratory_program != null) {
          _prepratoryModel = _getDashboardDataModel!.prepratory_program;
          prepratoryMealStage = _prepratoryModel?.data ?? '';
        }
        updateNewStage(prepratoryMealStage);
        if (_getDashboardDataModel!.transition_meal_program != null) {
          _transMealModel = _getDashboardDataModel!.transition_meal_program;
        } else if (_getDashboardDataModel!.trans_program != null) {
          _transModel = _getDashboardDataModel!.trans_program;
        }
        if (_getDashboardDataModel!.approved_shipping != null) {
          _shippingApprovedModel = _getDashboardDataModel!.approved_shipping;
          shippingStage = _shippingApprovedModel?.data ?? '';
          prepratoryMealStage = _prepratoryModel?.data ?? '';

          updateNewStage(shippingStage);
        } else {
          _gutShipDataModel = _getDashboardDataModel!.normal_shipping;
          shippingStage = _gutShipDataModel?.data ?? '';
          updateNewStage(shippingStage);
          // abc();
        }
        if (shippingStage != null && shippingStage == "shipping_delivered") {}
        if (_getDashboardDataModel!.data_program != null) {
          _getProgramModel = _getDashboardDataModel!.data_program;
          programOptionStage = _getProgramModel?.data ?? '';
          updateNewStage(programOptionStage);
        } else {
          _gutProgramModel = _getDashboardDataModel!.normal_program;
          programOptionStage = _getProgramModel?.data ?? '';
          updateNewStage(programOptionStage);
          abc();
        }

        if (_getDashboardDataModel!.data_program != null) {
          _transModel = _getDashboardDataModel!.trans_program;
          transStage = _transModel?.data ?? '';
          updateNewStage(transStage);
        } else {
          _transMealModel = _getDashboardDataModel!.transition_meal_program;
          transStage = _transMealModel?.data ?? '';
          updateNewStage(transStage);
        }
        // post program will open once transition meal plan is completed
        // this is for other postprogram model
        if (_getDashboardDataModel!.normal_postprogram != null) {
          _gutPostProgramModel = _getDashboardDataModel!.normal_postprogram;
          postProgramStage = _gutPostProgramModel?.data ?? '';
          updateNewStage(postProgramStage);
        } else {
          _postConsultationAppointment =
              _getDashboardDataModel!.postprogram_consultation;
          print(
              "RESCHEDULE : ${_getDashboardDataModel!.postprogram_consultation?.data}");
          postProgramStage = _postConsultationAppointment?.data ?? '';
          updateNewStage(postProgramStage);
        }
        print("postProgramStage: ${postProgramStage}");
        if (postProgramStage != null && postProgramStage!.isNotEmpty) {
          updateNewStage(postProgramStage);
        }
      });
    }
  }

  goToScreen(screenName) {
    print(screenName);
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => screenName,
        // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
      ),
    )
        .then((value) {
      print(value);
      setState(() {
        getData();
      });
    });
  }

  handleButtonOnTapByType(StageType type, int buttonId) {
    switch (type) {
      case StageType.evaluation:
        goToScreen(EvaluationGetDetails());
        break;
      case StageType.med_consultation:
        print("Medical consultation ${buttonId}");
        if (buttonId == 1) {
          switch (consultationStage) {
            case 'evaluation_done':
              goToScreen(DoctorCalenderTimeScreen());
              break;
            case 'pending':
              goToScreen(DoctorCalenderTimeScreen());
              break;
            case 'appointment_booked':
              final model = _getAppointmentDetailsModel;
              print(model!.value!.date);
              List<String> doctorNames = [];
              String? doctorName;
              String? doctorImage;

              model.value?.teamMember?.forEach((element) {
                if (element.user != null) {
                  if (element.user!.roleId == "2") {
                    doctorNames.add('Dr. ${element.user!.name}' ?? '');
                    doctorName = 'Dr. ${element.user!.name}';
                    doctorImage = element.user?.profile ?? '';
                  }
                }
              });

              // add this before calling calendertimescreen for reschedule
              // _pref!.setString(AppConfig.appointmentId , '');
              goToScreen(DoctorCalenderTimeScreen(
                isReschedule: true,
                prevBookingDate: model.value!.date,
                prevBookingTime: model.value!.appointmentStartTime,
                doctorDetails: model.value!.doctor,
                doctorName: doctorName,
                doctorPic: doctorImage,
              ));
              break;
            case 'consultation_reschedule':
              final model = _getAppointmentDetailsModel;

              // add this before calling calendertimescreen for reschedule
              // _pref!.setString(AppConfig.appointmentId , '');
              goToScreen(DoctorCalenderTimeScreen(
                isReschedule: true,
                prevBookingDate: model!.value!.appointmentDate,
                prevBookingTime: model.value!.appointmentStartTime,
              ));
              break;
            case 'consultation_done':
              goToScreen(const ConsultationSuccess());
              break;
            case 'consultation_accepted':
              goToScreen(const ConsultationSuccess());
              break;
            case 'consultation_waiting':
              goToScreen(UploadFiles());
              break;
            case 'consultation_rejected':
              goToScreen(ConsultationRejected(
                reason: _gutDataModel?.stringValue ?? '',
              ));
              break;
            case 'check_user_reports':
              // print(_gutDataModel!.value);
              goToScreen(CheckUserReportsScreen());
              break;
            default:
              goToScreen(const ConsultationSuccess());
          }
        } else {
          print(consultationStage);
          switch (consultationStage) {
            case 'check_user_reports':
              // print(_gutDataModel!.value);
              goToScreen(CheckUserReportsScreen());
              break;
            case 'appointment_booked':
              final model = _getAppointmentDetailsModel;
              _pref!.setString(
                  AppConfig.appointmentId, model?.value?.id.toString() ?? '');
              goToScreen(DoctorSlotsDetailsScreen(
                bookingDate: model!.value!.date!,
                bookingTime: model.value!.slotStartTime!,
                dashboardValueMap: model.value!.toJson(),
                isFromDashboard: true,
              ));
              break;
            case 'report_upload':
              print(_gutDataModel!.toJson());
              // goToScreen(ConsultationRejected(reason: '',));

              // goToScreen(ConsultationSuccess());

              // goToScreen(DoctorSlotsDetailsScreen(bookingDate: "2023-02-21", bookingTime: "11:34:00", dashboardValueMap: {},isFromDashboard: true,));

              // goToScreen(DoctorCalenderTimeScreen(isReschedule: true,prevBookingTime: '23-09-2022', prevBookingDate: '10AM',));
              goToScreen(MedicalReportScreen(
                pdfLink: _gutDataModel!.historyWithMrValue!.mr!,
              ));
              break;
            default:
              AppConfig().showSnackbar(context, "Can't access Locked Stage",
                  isError: true);
          }
        }
        break;
      case StageType.prep_meal:
        showPrepratoryMealScreen();
        break;
      case StageType.normal_meal:
        if (buttonId == 1) {
          if (programOptionStage != null && programOptionStage!.isNotEmpty) {
            print("called");
            showProgramScreen();
          } else {
            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        } else {
          if (transStage != null && transStage!.isNotEmpty) {
            // showProgramScreen();
            showTransitionMealScreen();
          } else {
            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        }
        // if(transStage != null && transStage!.isNotEmpty){
        //   // showProgramScreen();
        //   showTransitionMealScreen();
        // }
        // else if(programOptionStage != null && programOptionStage!.isNotEmpty){
        //   print("called");
        //   showProgramScreen();
        // }
        // else{
        //   AppConfig().showSnackbar(context, "Can't access Locked Stage", isError: true);
        // }
        break;
      case StageType.post_consultation:
        if (buttonId == 1) {
          if (postProgramStage == "post_program") {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                      builder: (context) => DoctorCalenderTimeScreen(
                            isPostProgram: true,
                          )
                      // PostProgramScreen(postProgramStage: postProgramStage,),
                      ),
                )
                .then((value) => reloadUI());
          } else if (postProgramStage == "post_appointment_booked") {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                      builder: (context) => DoctorSlotsDetailsScreen(
                            bookingDate:
                                _postConsultationAppointment!.value!.date!,
                            bookingTime: _postConsultationAppointment!
                                .value!.slotStartTime!,
                            isPostProgram: true,
                            dashboardValueMap:
                                _postConsultationAppointment!.value!.toJson(),
                          )
                      // PostProgramScreen(postProgramStage: postProgramStage,
                      //   consultationData: _postConsultationAppointment,),
                      ),
                )
                .then((value) => reloadUI());
          } else {
            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        } else {
          showPostProgramScreen();
        }
        break;
    }
  }

  void showConsultationScreenFromStages(status) {
    print(status);
    switch (status) {
      case 'evaluation_done':
        goToScreen(DoctorCalenderTimeScreen());
        break;
      case 'pending':
        goToScreen(DoctorCalenderTimeScreen());
        break;
      case 'consultation_reschedule':
        final model = _getAppointmentDetailsModel;

        // add this before calling calendertimescreen for reschedule
        // _pref!.setString(AppConfig.appointmentId , '');
        goToScreen(DoctorCalenderTimeScreen(
          isReschedule: true,
          prevBookingDate: model!.value!.appointmentDate,
          prevBookingTime: model.value!.appointmentStartTime,
        ));
        break;
      case 'appointment_booked':
        final model = _getAppointmentDetailsModel;
        _pref!.setString(
            AppConfig.appointmentId, model?.value?.id.toString() ?? '');
        goToScreen(DoctorSlotsDetailsScreen(
          bookingDate: model!.value!.date!,
          bookingTime: model.value!.slotStartTime!,
          dashboardValueMap: model.value!.toJson(),
          isFromDashboard: true,
        ));
        break;
      case 'consultation_done':
        goToScreen(const ConsultationSuccess());
        break;
      case 'consultation_accepted':
        goToScreen(const ConsultationSuccess());
        break;
      case 'consultation_waiting':
        goToScreen(UploadFiles());
        break;
      case 'check_user_reports':
        // print(_gutDataModel!.value);
        goToScreen(CheckUserReportsScreen());
        break;
      case 'consultation_rejected':
        goToScreen(ConsultationRejected(
          reason: _gutDataModel?.stringValue ?? '',
        ));
        break;
      case 'report_upload':
        print(_gutDataModel!.toJson());
        print(_gutDataModel!.historyWithMrValue!.mr);
        goToScreen(ConsultationRejected(
          reason: '',
        ));

        // goToScreen(ConsultationSuccess());

        // goToScreen(DoctorSlotsDetailsScreen(bookingDate: "2023-02-21", bookingTime: "11:34:00", dashboardValueMap: {},isFromDashboard: true,));

        // goToScreen(DoctorCalenderTimeScreen(isReschedule: true,prevBookingTime: '23-09-2022', prevBookingDate: '10AM',));
        // goToScreen(MedicalReportScreen(pdfLink: _gutDataModel!.value!,));
        break;
    }
  }

  /// buttonid is required to identify which button pressed
  buildButton(String title, Color color, StageType type, int buttonId) {
    return GestureDetector(
      onTap: () {
        handleButtonOnTapByType(type, buttonId);
      },
      child: Container(
        height: 3.5.h,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: kFontMedium,
              color: gWhiteColor,
              fontSize: eUser().anAccountTextFontSize,
            ),
          ),
        ),
      ),
    );
  }

  buildNewStages(
      String headingText,
      String subText,
      String image,
      String stageImage,
      String lockImage,
      Color stageColor,
      String levels,
      bool rescheduleButton,
      String buttonTitle,
      Color button1Color,
      String button2Title,
      Color button2Color,
      StageType type,
      {bool? showTrackGutIcon,
      String? trackGutIconName,
      String? trackGutIconCircleName,
      Color? circleInsideStageImageColor,
      Color? trackGutIconColor}) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          Positioned(
            left: 2.5.w,
            child: Container(
              height: 50.h,
              width: 2,
              color: stageColor,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: stageColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(2),
                  decoration:
                      BoxDecoration(color: stageColor, shape: BoxShape.circle),
                  child: Text(
                    levels,
                    style: TextStyle(
                        color: gWhiteColor,
                        fontSize: 7.sp,
                        fontFamily: kFontMedium),
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(-0.5.w, 0.7.w, 0),
                child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Image(
                        height: 6.h,
                        image: AssetImage(stageImage),
                      ),
                      Positioned(
                        // top: 5,
                        // bottom: 5,
                        left: 10,
                        right: -10,
                        child: Image(
                          height: 5.w,
                          width: 5.w,
                          image: AssetImage(image),
                          color: circleInsideStageImageColor,
                        ),
                      ),
                      Positioned(
                        left: 3,
                        child: Image(
                          height: 5.w,
                          image: AssetImage(lockImage),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Visibility(
                          visible: showTrackGutIcon ?? false,
                          child: Transform(
                            transform:
                                Matrix4.translationValues(-3.6.w, 6.6.w, 0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                InkWell(
                                  onTap: () => handleTrackerRemedyOnTap(type),
                                  child: Image(
                                    height: 7.h,
                                    image: AssetImage(
                                        trackGutIconCircleName ?? ''),
                                  ),
                                ),
                                Positioned(
                                  bottom: 9,
                                  right: 3,
                                  left: 1,
                                  child: Image(
                                    height: 1.8.h,
                                    image: AssetImage(trackGutIconName ?? ''),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
              SizedBox(width: 0.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headingText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: eUser().mainHeadingFont,
                            color: eUser().mainHeadingColor,
                            fontSize: eUser().mainHeadingFontSize,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        GestureDetector(
                          child: Icon(
                            Icons.help_outline_rounded,
                            color: gMainColor,
                            size: 11.5.sp,
                          ),
                          onTap: () {
                            switch (type) {
                              case StageType.evaluation:
                                final link =
                                    _getDashboardDataModel!.evaluationVideo;
                                print(link);
                                if (link != null && link.isNotEmpty) {
                                  addUrlToVideoWhenAboutClickChewie(link);
                                  whenAboutClickSheet();
                                } else {
                                  AppConfig().showSnackbar(
                                      context, "Link Not Available",
                                      isError: true);
                                }
                                break;
                              case StageType.med_consultation:
                                final link =
                                    _getDashboardDataModel!.consultationVideo;
                                if (link != null && link.isNotEmpty) {
                                  addUrlToVideoWhenAboutClickChewie(link);
                                  whenAboutClickSheet();
                                } else {
                                  AppConfig().showSnackbar(
                                      context, "Link Not Available",
                                      isError: true);
                                }
                                break;
                              case StageType.prep_meal:
                                final link = _getDashboardDataModel!.prepVideo;
                                print("prepVideo: $link");
                                print(link == null);
                                print(link!.isEmpty);
                                if (link != null && link.isNotEmpty) {
                                  addUrlToVideoWhenAboutClickChewie(link);
                                  whenAboutClickSheet();
                                } else {
                                  AppConfig().showSnackbar(
                                      context, "Link Not Available",
                                      isError: true);
                                }
                                break;
                              case StageType.normal_meal:
                                final link =
                                    _getDashboardDataModel!.programVideo;
                                print("programVideo: $link");
                                if (link != null && link.isNotEmpty) {
                                  addUrlToVideoWhenAboutClickChewie(link);
                                  whenAboutClickSheet();
                                } else {
                                  AppConfig().showSnackbar(
                                      context, "Link Not Available",
                                      isError: true);
                                }
                                break;
                              case StageType.post_consultation:
                                final link = _getDashboardDataModel!.gmgVideo;
                                print("gmgVideo: $link");
                                print(link == null);
                                print(link!.isEmpty);
                                if (link != null && link.isNotEmpty) {
                                  addUrlToVideoWhenAboutClickChewie(link);
                                  whenAboutClickSheet();
                                } else {
                                  AppConfig().showSnackbar(
                                      context, "Link Not Available",
                                      isError: true);
                                }
                                break;
                            }
                          },
                        ),
                      ],
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      textScaleFactor: 0.85,
                      maxLines: 2,
                      text: TextSpan(children: [
                        TextSpan(
                          text: subText.substring(
                                  0,
                                  int.parse(
                                      "${(subText.length * 0.298).toInt()}")) +
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
                    ),
                    // Text(
                    //   subText,
                    //   //  "While you wait for your customised Product Kit arrive to be used during the Reset phase of the program,You will be give a preparatory meal protocol based on your food type,While you wait for your  customised Product Kit arrive to be used during the Reset phase of the program,",
                    //   style: TextStyle(
                    //       height: 1.3,
                    //       fontFamily: kFontBook,
                    //       color: eUser().mainHeadingColor,
                    //       fontSize: bottomSheetSubHeadingSFontSize),
                    //   textAlign: TextAlign.justify,
                    //   maxLines: 2,
                    // ),
                    Row(
                      children: [
                        buildButton(buttonTitle, button1Color, type, 1),
                        SizedBox(width: 3.w),
                        (rescheduleButton)
                            ? buildButton(button2Title, button2Color, type, 2)
                            : const SizedBox(),
                        SizedBox(width: 3.w),
                      ],
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateNewStage(String? stage) {
    print("consultationStage: ==> ${stage}");
    switch (stage) {
      case 'evaluation_done':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].button1Color = newDashboardGreenButtonColor;
        break;
      case 'pending':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].button1Color = newDashboardGreenButtonColor;
        break;
      case 'consultation_reschedule':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].buttonTitle = "Reschedule";
        levels[1].button1Color = newDashboardGreenButtonColor;
        break;
      case 'appointment_booked':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].buttonTitle = "Reschedule";
        levels[1].button1Color = newDashboardGreenButtonColor;
        levels[1].button2Color = newDashboardGreenButtonColor;
        levels[1].lockImage = unlockYellowImage;
        break;
      case 'consultation_done':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].buttonTitle = "Reschedule";
        levels[1].button1Color = newDashboardGreenButtonColor;
        break;
      case 'consultation_accepted':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].buttonTitle = "Accepted";
        levels[1].button1Color = newDashboardGreenButtonColor;
        break;
      case 'consultation_waiting':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].buttonTitle = "Upload Report";
        levels[1].button1Color = newDashboardGreenButtonColor;
        break;
      case 'check_user_reports':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].button1Color = newDashboardGreenButtonColor;
        levels[1].buttonTitle = "Awaiting";
        break;
      case 'consultation_rejected':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].buttonTitle = "Rejected";
        levels[1].button1Color = gsecondaryColor;
        break;
      case 'report_upload':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockYellowColor;
        levels[1].button2Title = "View MR";
        levels[1].button2Color = newDashboardGreenButtonColor;
        levels[1].buttonTitle = "Completed";
        levels[1].button1Color = gsecondaryColor;

        break;
      case 'prep_meal_plan_completed':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockGreenColor;
        levels[1].circleInsideImageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;

        if (_prepratoryModel!.value!.prep_days! !=
            _prepratoryModel!.value!.currentDay) {
          levels[2].lockImage = unlockYellowImage;
          levels[2].stageColor = unlockYellowColor;
          levels[2].stageCircleImage = unlockYellowCircleImage;
          levels[2].trackGutIconCircleName = yellowTrackGutCircle;
          levels[2].circleInsideImageColor = unlockYellowColor;
          levels[2].button1Color = gMainColor;
        } else {
          levels[2].stageColor = unlockGreenColor;
          levels[2].lockImage = unlockGreenImage;
          levels[2].stageCircleImage = unlockGreenCircleImage;
          levels[2].trackGutIconCircleName = greenTrackGutCircle;
          levels[2].circleInsideImageColor = unlockGreenColor;
          levels[2].button1Color = newDashboardGreenButtonColor;
        }
        break;
      case 'shipping_packed':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        if (_prepratoryModel!.value!.prep_days! !=
            _prepratoryModel!.value!.currentDay) {
          levels[2].lockImage = unlockYellowImage;
          levels[2].stageColor = unlockYellowColor;
          levels[2].stageCircleImage = unlockYellowCircleImage;
          levels[2].trackGutIconCircleName = yellowTrackGutCircle;
          levels[2].circleInsideImageColor = unlockYellowColor;
          levels[2].button1Color = gMainColor;
        } else {
          levels[2].stageColor = unlockGreenColor;
          levels[2].lockImage = unlockGreenImage;
          levels[2].stageCircleImage = unlockGreenCircleImage;
          levels[2].trackGutIconCircleName = greenTrackGutCircle;
          levels[2].circleInsideImageColor = unlockGreenColor;
          levels[2].button1Color = newDashboardGreenButtonColor;
        }
        break;
      case 'shipping_paused':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        if (_prepratoryModel!.value!.prep_days! !=
            _prepratoryModel!.value!.currentDay) {
          levels[2].lockImage = unlockYellowImage;
          levels[2].stageColor = unlockYellowColor;
          levels[2].stageCircleImage = unlockYellowCircleImage;
          levels[2].trackGutIconCircleName = yellowTrackGutCircle;
          levels[2].circleInsideImageColor = unlockYellowColor;
          levels[2].button1Color = gMainColor;
        } else {
          levels[2].stageColor = unlockGreenColor;
          levels[2].lockImage = unlockGreenImage;
          levels[2].stageCircleImage = unlockGreenCircleImage;
          levels[2].trackGutIconCircleName = greenTrackGutCircle;
          levels[2].circleInsideImageColor = unlockGreenColor;
          levels[2].button1Color = newDashboardGreenButtonColor;
        }
        break;
      case 'shipping_delivered':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        if (_prepratoryModel!.value!.prep_days! !=
            _prepratoryModel!.value!.currentDay) {
          levels[2].lockImage = unlockYellowImage;
          levels[2].stageColor = unlockYellowColor;
          levels[2].stageCircleImage = unlockYellowCircleImage;
          levels[2].trackGutIconCircleName = yellowTrackGutCircle;
          levels[2].circleInsideImageColor = unlockYellowColor;
          levels[2].button1Color = gMainColor;
        } else {
          levels[2].stageColor = unlockGreenColor;
          levels[2].lockImage = unlockGreenImage;
          levels[2].stageCircleImage = unlockGreenCircleImage;
          levels[2].trackGutIconCircleName = greenTrackGutCircle;
          levels[2].circleInsideImageColor = unlockGreenColor;
          levels[2].button1Color = newDashboardGreenButtonColor;
        }
        break;
      case 'shipping_approved':
        levels[0].stageColor = unlockGreenColor;
        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        if (_prepratoryModel!.value!.prep_days! !=
            _prepratoryModel!.value!.currentDay) {
          levels[2].lockImage = unlockYellowImage;
          levels[2].stageColor = unlockYellowColor;
          levels[2].stageCircleImage = unlockYellowCircleImage;
          levels[2].trackGutIconCircleName = yellowTrackGutCircle;
          levels[2].circleInsideImageColor = unlockYellowColor;
          levels[2].button1Color = gMainColor;
        } else {
          levels[2].stageColor = unlockGreenColor;
          levels[2].lockImage = unlockGreenImage;
          levels[2].stageCircleImage = unlockGreenCircleImage;
          levels[2].trackGutIconCircleName = greenTrackGutCircle;
          levels[2].circleInsideImageColor = unlockGreenColor;
          levels[2].button1Color = newDashboardGreenButtonColor;
        }
        break;
      case 'start_program':
        levels[0].stageColor = unlockGreenColor;

        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        levels[2].stageColor = unlockGreenColor;
        levels[2].lockImage = unlockGreenImage;
        levels[2].stageCircleImage = unlockGreenCircleImage;
        levels[2].trackGutIconCircleName = greenTrackGutCircle;
        levels[2].circleInsideImageColor = unlockGreenColor;
        levels[2].button1Color = newDashboardGreenButtonColor;

        levels[3].stageColor = unlockYellowColor;
        levels[3].lockImage = unlockYellowImage;
        levels[3].stageCircleImage = unlockYellowCircleImage;
        levels[3].trackGutIconCircleName = yellowTrackGutCircle;
        levels[3].circleInsideImageColor = unlockYellowColor;
        levels[3].button1Color = newDashboardGreenButtonColor;

        break;
      case 'trans_program':
        levels[0].stageColor = unlockGreenColor;

        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        levels[2].stageColor = unlockGreenColor;
        levels[2].lockImage = unlockGreenImage;
        levels[2].stageCircleImage = unlockGreenCircleImage;
        levels[2].trackGutIconCircleName = greenTrackGutCircle;
        levels[2].circleInsideImageColor = unlockGreenColor;
        levels[2].button1Color = newDashboardGreenButtonColor;

        print(
            "_prepratoryModel!.value!.isPrepCompleted != null: ${_transModel!.value!.isTransMealCompleted != null}");
        print(
            "_prepratoryModel!.value!.isPrepCompleted! == true: ${_transModel!.value!.isTransMealCompleted == true} ${_transModel!.value!.isTransMealCompleted}");

        if ((_transModel!.value!.isTransMealCompleted != null) &&
            _transModel!.value!.isTransMealCompleted == true) {
          levels[3].stageColor = unlockGreenColor;
          levels[3].lockImage = unlockGreenImage;
          levels[3].stageCircleImage = unlockGreenCircleImage;
          levels[3].button2Color = newDashboardGreenButtonColor;
          levels[3].trackGutIconCircleName = greenTrackGutCircle;
          levels[3].circleInsideImageColor = unlockGreenColor;
        } else {
          levels[3].stageColor = unlockYellowColor;
          levels[3].lockImage = unlockYellowImage;
          levels[3].stageCircleImage = unlockYellowCircleImage;
          levels[3].button2Color = newDashboardGreenButtonColor;

          levels[3].trackGutIconCircleName = yellowTrackGutCircle;
          levels[3].circleInsideImageColor = unlockYellowColor;
        }
        levels[3].button1Color = newDashboardGreenButtonColor;

        break;
      case 'post_program':
        levels[0].stageColor = unlockGreenColor;

        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        levels[2].stageColor = unlockGreenColor;
        levels[2].lockImage = unlockGreenImage;
        levels[2].stageCircleImage = unlockGreenCircleImage;
        levels[2].trackGutIconCircleName = greenTrackGutCircle;
        levels[2].circleInsideImageColor = unlockGreenColor;
        levels[2].button1Color = newDashboardGreenButtonColor;

        if ((_transModel?.value!.isTransMealCompleted != null) &&
            _transModel?.value?.isTransMealCompleted == true) {
          levels[3].stageColor = unlockGreenColor;
          levels[3].lockImage = unlockGreenImage;
          levels[3].stageCircleImage = unlockGreenCircleImage;
          levels[3].trackGutIconCircleName = greenTrackGutCircle;
          levels[3].circleInsideImageColor = unlockGreenColor;
        } else {
          levels[3].stageColor = unlockYellowColor;
          levels[3].lockImage = unlockYellowImage;
        }
        levels[3].button1Color = newDashboardGreenButtonColor;
        levels[4].stageColor = unlockYellowColor;
        levels[4].lockImage = unlockYellowImage;
        levels[4].stageCircleImage = unlockYellowCircleImage;
        levels[4].circleInsideImageColor = unlockYellowColor;
        levels[4].trackGutIconCircleName = yellowTrackGutCircle;
        levels[4].circleInsideImageColor = unlockYellowColor;
        levels[4].button1Color = newDashboardGreenButtonColor;

        break;
      case 'post_appointment_booked':
        levels[0].stageColor = unlockGreenColor;
        levels[0].stageCircleImage = unlockGreenCircleImage;

        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        levels[2].stageColor = unlockGreenColor;
        levels[2].lockImage = unlockGreenImage;
        levels[2].stageCircleImage = unlockGreenCircleImage;
        levels[2].trackGutIconCircleName = greenTrackGutCircle;
        levels[2].circleInsideImageColor = unlockGreenColor;
        levels[2].button1Color = newDashboardGreenButtonColor;

        if ((_transModel?.value!.isTransMealCompleted != null) &&
            _transModel?.value?.isTransMealCompleted == true) {
          levels[3].stageColor = unlockGreenColor;
          levels[3].lockImage = unlockGreenImage;
          levels[3].stageCircleImage = unlockGreenCircleImage;
          levels[3].trackGutIconCircleName = greenTrackGutCircle;
          levels[3].circleInsideImageColor = unlockGreenColor;
        } else {
          levels[3].stageColor = unlockYellowColor;
          levels[3].lockImage = unlockYellowImage;
        }
        levels[3].button1Color = newDashboardGreenButtonColor;

        levels[4].stageColor = unlockYellowColor;
        levels[4].lockImage = unlockYellowImage;
        levels[4].buttonTitle = "Reschedule";
        levels[4].stageCircleImage = unlockYellowCircleImage;
        levels[4].circleInsideImageColor = unlockYellowColor;
        levels[4].trackGutIconCircleName = yellowTrackGutCircle;
        levels[4].circleInsideImageColor = unlockYellowColor;
        levels[4].button1Color = newDashboardGreenButtonColor;
        levels[4].button2Color = newDashboardGreenButtonColor;

        break;
      case 'protocol_guide':
        levels[0].stageColor = unlockGreenColor;
        levels[0].stageCircleImage = unlockGreenCircleImage;

        levels[1].stageColor = unlockGreenColor;
        levels[1].lockImage = unlockGreenImage;
        levels[1].stageCircleImage = unlockGreenCircleImage;
        levels[1].circleInsideImageColor = unlockGreenColor;

        levels[2].stageColor = unlockGreenColor;
        levels[2].lockImage = unlockGreenImage;
        levels[2].stageCircleImage = unlockGreenCircleImage;
        levels[2].trackGutIconCircleName = greenTrackGutCircle;
        levels[2].circleInsideImageColor = unlockGreenColor;
        levels[2].button1Color = newDashboardGreenButtonColor;

        if ((_transModel?.value!.isTransMealCompleted != null) &&
            _transModel?.value?.isTransMealCompleted == true) {
          levels[3].stageColor = unlockGreenColor;
          levels[3].lockImage = unlockGreenImage;
          levels[3].stageCircleImage = unlockGreenCircleImage;
          levels[3].trackGutIconCircleName = greenTrackGutCircle;
          levels[3].circleInsideImageColor = unlockGreenColor;
        } else {
          levels[3].stageColor = unlockYellowColor;
          levels[3].lockImage = unlockYellowImage;
        }
        levels[3].button1Color = newDashboardGreenButtonColor;
        levels[4].stageColor = unlockYellowColor;
        levels[4].lockImage = unlockYellowImage;
        levels[4].stageCircleImage = unlockYellowCircleImage;
        levels[4].circleInsideImageColor = unlockYellowColor;
        levels[4].button2Title = "GMG";
        levels[4].trackGutIconCircleName = yellowTrackGutCircle;
        levels[4].circleInsideImageColor = unlockYellowColor;
        levels[4].button1Color = newDashboardGreenButtonColor;
        levels[4].button2Color = newDashboardGreenButtonColor;

        break;
    }
  }

  showPrepratoryMealScreen() {
    if (_prepratoryModel != null) {
      print("BOOL : ${_prepratoryModel!.value!.isPrepratoryStarted}");

      // slide to program  if not started
      if (_prepratoryModel!.value!.isPrepratoryStarted == false) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ProgramPlanScreen(
                  from: ProgramMealType.prepratory.name,
                ),
              ),
            )
            .then((value) => reloadUI());
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (_prepratoryModel!.value!.isPrepCompleted!)
                ? PrepratoryMealCompletedScreen()
                : PreparatoryPlanScreen(
                    dayNumber: _prepratoryModel!.value!.currentDay!,
                    totalDays: _prepratoryModel!.value!.prep_days ?? ''),
            // ProgramPlanScreen(from: ProgramMealType.prepratory.name,)
          ),
        ).then((value) => reloadUI());
      }
    }
  }

  showTransitionMealScreen() {
    if (_transModel != null) {
      if (_transModel!.value!.isTransMealStarted == false) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ProgramPlanScreen(
                  from: ProgramMealType.transition.name,
                ),
              ),
            )
            .then((value) => reloadUI());
      } else {
        print(_transModel!.value!.toJson());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransitionMealPlanScreen(
                postProgramStage: postProgramStage,
                totalDays: _transModel!.value!.trans_days ?? '',
                dayNumber: _transModel?.value?.currentDay ?? '',
                trackerVideoLink: _getProgramModel!.value!.tracker_video_url),
          ),
        ).then((value) => reloadUI());
      }
    }
  }

  /// when user click on meal plan if still prep not completed than
  /// in meal slide to start need to show prep form submit
  /// if already submitted than normal ui
  showProgramScreen() {
    print("func called");
    if (shippingStage == "shipping_delivered" && programOptionStage != null) {
      // to slide to start the program
      if (_getProgramModel!.value!.recipeVideo != null)
        _pref!.setString(
            AppConfig().receipeVideoUrl, _getProgramModel!.value!.recipeVideo!);
      if (_getProgramModel!.value!.tracker_video_url != null)
        _pref!.setString(AppConfig().trackerVideoUrl,
            _getProgramModel!.value!.tracker_video_url!);
      if (_getProgramModel!.value!.startProgram == '0') {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ProgramPlanScreen(
                  from: ProgramMealType.detox.name,
                  isPrepCompleted: _prepratoryModel!.value!.isPrepCompleted,
                ),
              ),
            )
            .then((value) => reloadUI());
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealPlanScreen(
                transStage: transStage,
                receipeVideoLink: _getProgramModel!.value!.recipeVideo,
                trackerVideoLink: _getProgramModel!.value!.tracker_video_url),
          ),
        ).then((value) => reloadUI());
      }
    } else {
      AppConfig()
          .showSnackbar(context, "program stage not getting", isError: true);
    }
  }

  showPostProgramScreen() {
    if (postProgramStage != null) {
      print(postProgramStage == "protocol_guide");
      if (postProgramStage == "post_program") {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                  builder: (context) => DoctorCalenderTimeScreen(
                        isPostProgram: true,
                      )
                  // PostProgramScreen(postProgramStage: postProgramStage,),
                  ),
            )
            .then((value) => reloadUI());
      } else if (postProgramStage == "post_appointment_booked") {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                  builder: (context) => DoctorSlotsDetailsScreen(
                        bookingDate: _postConsultationAppointment!.value!.date!,
                        bookingTime:
                            _postConsultationAppointment!.value!.slotStartTime!,
                        isPostProgram: true,
                        dashboardValueMap:
                            _postConsultationAppointment!.value!.toJson(),
                      )
                  // PostProgramScreen(postProgramStage: postProgramStage,
                  //   consultationData: _postConsultationAppointment,),
                  ),
            )
            .then((value) => reloadUI());
      } else if (postProgramStage == "post_appointment_done") {
        goToScreen(const ConsultationSuccess(
          isPostProgramSuccess: true,
        ));
      } else if (postProgramStage == "protocol_guide") {
        // goToScreen(PPLevelsScreen());
        goToScreen(PPLevelsDemo());
      } else {
        AppConfig()
            .showSnackbar(context, "Can't access Locked Stage", isError: true);
      }
    }
  }

  handleTrackerRemedyOnTap(StageType type) {
    switch (type) {
      case StageType.prep_meal:
        print("tracker clicked");
        if (shippingStage != null && shippingStage!.isNotEmpty) {
          if (_shippingApprovedModel != null) {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => CookKitTracking(
                      awb_number: _shippingApprovedModel?.value?.awbCode ?? '',
                      currentStage: shippingStage!, isForeign: '',
                    ),
                  ),
                )
                .then((value) => reloadUI());
          } else {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CookKitTracking(currentStage: shippingStage ?? '', isForeign: '',),
                  ),
                )
                .then((value) => reloadUI());
          }
        } else {
          AppConfig().showSnackbar(context, "Can't access Locked Stage",
              isError: true);
        }
        break;
      case StageType.normal_meal:
        goToScreen(HomeRemediesScreen());
        // need to show Remedies UI
        break;
      case StageType.evaluation:
        // TODO: Handle this case.
        break;
      case StageType.normal_meal:
        // TODO: Handle this case.
        break;
      case StageType.post_consultation:
        // TODO: Handle this case.
        break;
      case StageType.med_consultation:
        // TODO: Handle this case.
        break;
    }
  }
}

class NewStageLevels {
  String stageCircleImage;
  String circleInsideimage;
  Color? circleInsideImageColor;
  String title;
  String lockImage;
  String subText;
  Color stageColor;
  bool rescheduleButton;
  String buttonTitle;
  Color button1Color;
  String button2Title;
  Color button2Color;
  StageType type;
  bool showTrackGutIcon;
  String? trackGutIconName;
  String? trackGutIconCircleName;
  Color? trackGutIconColor;

  NewStageLevels(
    this.stageCircleImage,
    this.circleInsideimage,
    this.title,
    this.lockImage,
    this.subText,
    this.stageColor,
    this.rescheduleButton,
    this.buttonTitle,
    this.button1Color,
    this.button2Title,
    this.button2Color,
    this.type, {
    this.showTrackGutIcon = false,
    this.trackGutIconName,
    this.trackGutIconCircleName,
    this.circleInsideImageColor,
    this.trackGutIconColor,
  });
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * .03, size.height);
    path.quadraticBezierTo(
        size.width * .2, size.height * .05, size.width * .03, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}

enum StageType {
  evaluation,
  med_consultation,
  prep_meal,
  normal_meal,
  post_consultation
}
