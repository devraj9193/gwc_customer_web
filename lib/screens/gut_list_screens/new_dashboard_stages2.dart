/*
this design not using

design type: butterfly type design
 */

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/new/dos_donts_program_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gwc_customer_web/model/dashboard_model/get_appointment/get_appointment_after_appointed.dart';
import 'package:gwc_customer_web/model/dashboard_model/get_dashboard_data_model.dart';
import 'package:gwc_customer_web/model/dashboard_model/get_program_model.dart';
import 'package:gwc_customer_web/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer_web/model/dashboard_model/shipping_approved/ship_approved_model.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/local_storage_dashboard_model.dart';
import 'package:gwc_customer_web/model/profile_model/user_profile/user_profile_model.dart';
import 'package:gwc_customer_web/model/ship_track_model/sipping_approve_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/chat_repository/message_repo.dart';
import 'package:gwc_customer_web/repository/dashboard_repo/gut_repository/dashboard_repository.dart';
import 'package:gwc_customer_web/repository/profile_repository/get_user_profile_repo.dart';
import 'package:gwc_customer_web/repository/shipping_repository/ship_track_repo.dart';
import 'package:gwc_customer_web/screens/appointment_screens/consultation_screens/consultation_rejected.dart';
import 'package:gwc_customer_web/screens/appointment_screens/consultation_screens/medical_report_screen.dart';
import 'package:gwc_customer_web/screens/appointment_screens/doctor_calender_time_screen.dart';
import 'package:gwc_customer_web/screens/chat_support/message_screen.dart';
import 'package:gwc_customer_web/screens/cook_kit_shipping_screens/cook_kit_tracking.dart';
import 'package:gwc_customer_web/screens/evalution_form/evaluation_get_details.dart';
import 'package:gwc_customer_web/screens/help_screens/help_screen.dart';
import 'package:gwc_customer_web/screens/home_remedies/home_remedies_screen.dart';
import 'package:gwc_customer_web/screens/medical_program_feedback_screen/final_feedback_form.dart';
import 'package:gwc_customer_web/screens/medical_program_feedback_screen/medical_feedback_form.dart';
import 'package:gwc_customer_web/screens/notification_screen.dart';
import 'package:gwc_customer_web/screens/post_program_screens/new_post_program/pp_levels_demo.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/new/preparatory_new_screen.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/schedule_screen.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/transition_mealplan_screen.dart';
import 'package:gwc_customer_web/screens/profile_screens/call_support_method.dart';
import 'package:gwc_customer_web/screens/program_plans/meal_plan_screen.dart';
import 'package:gwc_customer_web/services/chat_service/chat_service.dart';
import 'package:gwc_customer_web/services/profile_screen_service/user_profile_service.dart';
import 'package:gwc_customer_web/services/shipping_service/ship_track_service.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/open_alert_box.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../model/message_model/get_chat_groupid_model.dart';
import '../../repository/login_otp_repository.dart';
import '../../services/dashboard_service/gut_service/dashboard_data_service.dart';
import '../../services/login_otp_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/video/normal_video.dart';
import '../appointment_screens/consultation_screens/check_user_report_screen.dart';
import '../appointment_screens/consultation_screens/consultation_success.dart';
import '../appointment_screens/consultation_screens/upload_files.dart';
import '../appointment_screens/doctor_slots_details_screen.dart';
import '../post_program_screens/protcol_guide_details.dart';
import '../prepratory plan/new/new_transition_design.dart';
import '../prepratory plan/prepratory_meal_completed_screen.dart';
import '../program_plans/program_start_screen.dart';
import 'package:gwc_customer_web/widgets/vlc_player/vlc_player_with_controls.dart';

enum DirectionAngle { topLeft, topRight, bottomLeft, bottomRight }

class GutList extends StatefulWidget {
  GutList({Key? key}) : super(key: key);

  final GutListState myAppState = GutListState();
  @override
  State<GutList> createState() => GutListState();
}

class GutListState extends State<GutList> with SingleTickerProviderStateMixin {
  final _pref = AppConfig().preferences;

  late GutDataService _gutDataService;

  /// THIS IS FOR ABC DIALOG MEAL PLAN
  bool isMealProgressOpened = false;

  bool isProgressDialogOpened = true;
  BuildContext? _progressContext;

  // vlc
  // VlcPlayerController? _mealPlayerController;
  // final _key = GlobalKey<VlcPlayerWithControlsState>();

  //chewie
  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;

  String? consultationStage,
      shippingStage,
      prepratoryMealStage,
      programOptionStage,
      transStage,
      postProgramStage;

  /// this is used when data=appointment_booked status
  GetAppointmentDetailsModel? _getAppointmentDetailsModel,
      _postConsultationAppointment;

  /// ths is used when data = shipping_approved status
  ShippingApprovedModel? _shippingApprovedModel;

  GetProgramModel? _gutProgramModel;

  GetPrePostMealModel? _prepratoryModel, _transModel;

  /// for other status we use this one(except shipping_approved & appointment_booked)
  GutDataModel? _gutDataModel,
      _gutShipDataModel,
      _gutNormalProgramModel,
      _gutPostProgramModel,
      _prepProgramModel,
      _transMealModel;

  String? evalBtnName,
      consBtn1Name,
      consBtn2Name,
      prepBtn1Name,
      prepBtn2Name,
      mealBtn1Name,
      mealBtn2Name;
  String? postBtn1Name,
      postBtn2Name,
      postBtn3Name,
      gmgBtn1Name,
      gmgBtn3Name,
      gmgBtn2Name,
      mmpBtn1Name;

  Color? evalBtnColor,
      consBtn1Color,
      consBtn2Color,
      prepBtn1Color,
      prepBtn2Color,
      mealBtn1Color,
      mealBtn2Color,
      bg1,
      bg2,
      bg3,
      bg4;
  Color? postBtn1Color,
      postBtn2Color,
      postBtn3Color,
      gmgBtn1Color,
      gmgBtn2Color,
      gmgBtn3Color,
      mmpBtn1Color;

  bool showConsLockIcon = true,
      showPrepLockIcon = true,
      showMealLockIcon = true;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: tabSize);
    getUserProfile();

    mmpBtn1Color = newDashboardLightGreyButtonColor;
    mmpBtn1Name = "Sign Up";

    if (_pref!.getString(AppConfig().shipRocketBearer) == null ||
        _pref!.getString(AppConfig().shipRocketBearer)!.isEmpty) {
      getShipRocketToken();
    }
    else {
      String token = _pref!.getString(AppConfig().shipRocketBearer)!;
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      print('shiprocketToken : $payload');
      var date = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      if (!DateTime.now().difference(date).isNegative) {
        getShipRocketToken();
      }
    }

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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

  Future getData() async {
    isProgressDialogOpened = true;
    print("isProgressDialogOpened: $isProgressDialogOpened");
    Future.delayed(Duration(seconds: 0)).whenComplete(() {
      if (mounted) {
        _progressContext = context;
        //openProgressDialog(_progressContext!, willPop: true);
      }
    });
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
      GetDashboardDataModel _getDashboardDataModel =
      _getData as GetDashboardDataModel;
      print(
          "_getDashboardDataModel.app_consulation: ${_getDashboardDataModel.app_consulation}");
      // checking for the consultation data if data = appointment_booked
      setState(() {
        if (_getDashboardDataModel.app_consulation != null) {
          _getAppointmentDetailsModel = _getDashboardDataModel.app_consulation;
          consultationStage = _getAppointmentDetailsModel?.data ?? '';
        } else {
          print("consultation else");
          _gutDataModel = _getDashboardDataModel.normal_consultation;
          consultationStage = _gutDataModel?.data ?? '';
          print(consultationStage);
        }
        updateNewStage(consultationStage);

        if (_getDashboardDataModel.prepratory_normal_program != null) {
          _prepProgramModel = _getDashboardDataModel.prepratory_normal_program;
          prepratoryMealStage = _prepProgramModel?.data ?? '';
        } else if (_getDashboardDataModel.prepratory_program != null) {
          _prepratoryModel = _getDashboardDataModel.prepratory_program;
          print("_prepratoryModel: $_prepratoryModel");
          prepratoryMealStage = _prepratoryModel?.data ?? '';
        }
        updateNewStage(prepratoryMealStage);

        if (_getDashboardDataModel.approved_shipping != null) {
          _shippingApprovedModel = _getDashboardDataModel.approved_shipping;
          shippingStage = _shippingApprovedModel?.data ?? '';
        } else {
          _gutShipDataModel = _getDashboardDataModel.normal_shipping;
          shippingStage = _gutShipDataModel?.data ?? '';
          // abc();
        }
        updateNewStage(shippingStage);

        if (_getDashboardDataModel.data_program != null) {
          _gutProgramModel = _getDashboardDataModel.data_program;
          print("programOptionStage if: ${programOptionStage}");
          programOptionStage = _gutProgramModel!.data;
        } else {
          _gutNormalProgramModel = _getDashboardDataModel.normal_program;
          print("programOptionStage else: ${programOptionStage}");
          programOptionStage = _gutNormalProgramModel!.data;
          abc();
        }
        updateNewStage(programOptionStage);

        if (_getDashboardDataModel.transition_meal_program != null) {
          _transMealModel = _getDashboardDataModel.transition_meal_program;
          transStage = _transMealModel?.data;
        } else if (_getDashboardDataModel.trans_program != null) {
          _transModel = _getDashboardDataModel.trans_program;
          transStage = _transModel!.data;
        }
        updateNewStage(transStage);

        // post program will open once transition meal plan is completed
        // this is for other postprogram model
        if (_getDashboardDataModel.normal_postprogram != null) {
          _gutPostProgramModel = _getDashboardDataModel.normal_postprogram;
          postProgramStage = _gutPostProgramModel?.data;
        } else {
          _postConsultationAppointment =
              _getDashboardDataModel.postprogram_consultation;
          _pref!.setString(AppConfig.appointmentId,_postConsultationAppointment?.value?.id.toString() ?? '');
          print(
              "RESCHEDULE : ${_getDashboardDataModel.postprogram_consultation?.data}");
          postProgramStage = _postConsultationAppointment?.data;
        }
        print("init index: $initialIndex");

        updateNewStage(postProgramStage);
      });

      LocalStorageDashboardModel _localStorageDashboardModel =
      LocalStorageDashboardModel(
        consultStage: consultationStage,
        appointmentModel: jsonEncode(_getAppointmentDetailsModel),
        consultStringModel: jsonEncode(_gutDataModel),
        mrReport: (consultationStage == "report_upload")
            ? _gutDataModel?.historyWithMrValue!.mr ?? ''
            : "",
        prepStage: prepratoryMealStage,
        prepMealModel: jsonEncode(_prepratoryModel),
        prepStringModel: jsonEncode(_prepProgramModel),
        shippingStage: shippingStage,
        shippingModel: jsonEncode(_shippingApprovedModel),
        shippingStringModel: jsonEncode(_gutShipDataModel),
        mealProgramStage: programOptionStage,
        mealModel: jsonEncode(_gutProgramModel),
        mealStringModel: jsonEncode(_gutNormalProgramModel),
        transStage: transStage,
        transModel: jsonEncode(_transModel),
        transStringModel: jsonEncode(_transMealModel),
        postProgramStage: postProgramStage,
        postModel: jsonEncode(_postConsultationAppointment),
        postStringModel: jsonEncode(_gutPostProgramModel),
      );
      _pref!.setString(AppConfig.LOCAL_DASHBOARD_DATA,
          jsonEncode(_localStorageDashboardModel));
    }
  }

  getUserProfile() async {
    // print("user id: ${_pref!.getInt(AppConfig.KALEYRA_USER_ID)}");

    final profile = await UserProfileService(repository: userRepository)
        .getUserProfileService();
    if (profile.runtimeType == UserProfileModel) {
      UserProfileModel model1 = profile as UserProfileModel;
      _pref!.setString(
          AppConfig.User_Name, model1.data?.name ?? model1.data?.fname ?? '');
      _pref!.setInt(AppConfig.USER_ID, model1.data?.id ?? -1);
      _pref!.setString(AppConfig.QB_USERNAME, model1.data!.qbUsername ?? '');
      _pref!
          .setString(AppConfig.QB_CURRENT_USERID, model1.data!.qbUserId ?? '');
      _pref!
          .setString(AppConfig.KALEYRA_USER_ID, model1.data!.kaleyraUID ?? '');

      if (_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) == null) {
        await LoginWithOtpService(repository: loginOtpRepository)
            .getAccessToken(model1.data!.kaleyraUID!);
      }
      if (_pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID) == null ||
          _pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID) == "") {
        // _pref!.setString(AppConfig.KALEYRA_CHAT_SUCCESS_ID, model1.associatedSuccessMemberKaleyraId ?? '');
      }
      print(
          "user profile: ${_pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID)}");
    }
  }

  Future<void> reloadUI() async {
    await getData();
    setState(() {});
  }

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final GutDataRepository repository = GutDataRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  final LoginOtpRepository loginOtpRepository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  int tabSize = 2, initialIndex = 0;
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    //        data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
    return DefaultTabController(
      initialIndex: initialIndex,
      length: tabSize,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: (initialIndex == 1) ? gWhiteColor : null,
          body: RefreshIndicator(
            onRefresh: getData,
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 1.w, right: 2.5.w, bottom: 1.w),
                            child: buildAppBar(
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
                            )),
                        Center(
                            child: IntrinsicWidth(
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(18.0)),
                                child: TabBar(
                                  controller: _tabController,
                                  onTap: (value) {
                                    setState(() {
                                      initialIndex = value;
                                    });
                                  },
                                  indicator: BoxDecoration(
                                      color: newDashboardGreenButtonColor,
                                      borderRadius: BorderRadius.circular(18.0)),
                                  labelColor: gWhiteColor,
                                  unselectedLabelColor: gBlackColor,
                                  tabs: const [
                                    Tab(
                                      text: 'Program',
                                    ),
                                    Tab(
                                      text: 'Post Program',
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        Expanded(
                            child: Center(
                                child: (isProgressDialogOpened)
                                    ? Shimmer.fromColors(
                                  baseColor: Colors.grey.withOpacity(0.3),
                                  highlightColor:
                                  Colors.grey.withOpacity(0.7),
                                  child: IgnorePointer(child: view()),
                                )
                                    : tabView()))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isInAppCallPressed = false;
  showSupportCallSheet(BuildContext context) {
    return AppConfig().showSheet(
        context,
        StatefulBuilder(builder: (_, setstate){
          return Column(
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
                    onTap: (isInAppCallPressed) ? null : () async {
                      setstate((){
                        isInAppCallPressed = true;
                      });
                      final res = await callSupport();
                      if (res.runtimeType != ErrorModel) {
                        AppConfig().showSnackbar(context,
                            "Call Initiated. Our success Team will call you soon.");
                      } else {
                        final result = res as ErrorModel;
                        AppConfig().showSnackbar(context,
                            "You can call your Success Team Member once you book your appointment",
                            isError: true, bottomPadding: 50);
                      }
                      setState((){
                        isInAppCallPressed = false;
                      });
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
          );
        }),
        bottomSheetHeight: 40.h,
        isSheetCloseNeeded: true,
        isDismissible: true,
        sheetCloseOnTap: () {
      Navigator.pop(context);
    });
  }

  view() {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          children: [
            Flexible(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      handleTrackerRemedyOnTap();
                    },
                    child: IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        // width: 60.w,
                        // height: 5.h,
                        decoration: BoxDecoration(
                          color: kNumberCircleAmber,
                          borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                          // border: Border.all(color: eUser().buttonBorderColor,
                          //     width: eUser().buttonBorderWidth),
                        ),
                        child: Center(
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/home_remedies.png",
                                  width: 18,
                                  height: 18,
                                  fit: BoxFit.scaleDown,
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  'Home Remedies',
                                  // 'Proceed to Day $proceedToDay',
                                  style: TextStyle(
                                    fontFamily: kFontMedium,
                                    color: gTextColor,
                                    // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
                                    fontSize: subHeadingFont,
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: customCircle(
                              DirectionAngle.topLeft.name, "3",
                              iconName: ((prepratoryMealStage == null ||
                                  prepratoryMealStage!.isEmpty) &&
                                  _prepratoryModel == null)
                                  ? null
                                  : (_prepratoryModel?.value?.isPrepCompleted ==
                                  true)
                                  ? newDashboardOpenIcon
                                  : newDashboardUnLockIcon,
                              showLockIcon: showPrepLockIcon,
                              headingText: "BEGIN GUT\nPREPARATION",
                              subText:
                              "While you wait for your customised Product Kit arrive to be used during the Reset phase of the program, "
                                  "You will be give a preparatory meal protocol based on your food type",
                              bgColor: bg3,
                              // borderColor: ((prepratoryMealStage == null || prepratoryMealStage!.isEmpty) && _prepratoryModel == null) ? null : (_prepratoryModel?.value?.isPrepCompleted == true) ? kBigCircleBorderGreen : kBigCircleBorderYellow,
                              button1Name: prepBtn1Name ?? '',
                              button1Color: prepBtn1Color ??
                                  newDashboardLightGreyButtonColor,
                              button2Color: prepBtn2Color ??
                                  newDashboardLightGreyButtonColor,
                              button2Name: prepBtn2Name,
                              type: StageType.prep_meal,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: customCircle(
                              DirectionAngle.topRight.name, "4",
                              iconName: getProgramTransBorderColor("icon"),
                              showLockIcon: showMealLockIcon,
                              headingText: "GUT RESET\nPROGRAM START",
                              subText:
                              "You are now ready to detoxify and repair your Gut disorder. First few "
                                  "day swill be challenging due to bland diet, but as you start experiencing "
                                  "the benefit, you will enjoy this phase.",
                              bgColor: bg4,
                              // borderColor: getProgramTransBorderColor("color"),
                              button1Name: mealBtn1Name ?? '',
                              button1Color: mealBtn1Color ??
                                  newDashboardLightGreyButtonColor,
                              button2Color: mealBtn2Color ??
                                  newDashboardLightGreyButtonColor,
                              button2Name: mealBtn2Name,
                              type: StageType.normal_meal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: customCircle(
                              DirectionAngle.bottomLeft.name, "2",
                              iconName: (consultationStage == null)
                                  ? null
                                  : consultationStage == "report_upload"
                                  ? newDashboardOpenIcon
                                  : newDashboardUnLockIcon,
                              headingText: "MEDICAL\nCONSULTATION",
                              subText:
                              "Basis your Evaluation details, a video consultation is the next step for our "
                                  "doctors to diagnose the root cause of you Gut Issues.",
                              bgColor: bg2,
                              // borderColor:(consultationStage == null) ? null : consultationStage == "report_upload" ? kBigCircleBorderGreen : kBigCircleBorderYellow,
                              showLockIcon: showConsLockIcon,
                              button1Name: consBtn1Name ?? '',
                              button1Color: consBtn1Color ??
                                  newDashboardLightGreyButtonColor,
                              button2Color: consBtn2Color ??
                                  newDashboardLightGreyButtonColor,
                              button2Name: consBtn2Name,
                              type: StageType.med_consultation,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: customCircle(
                              DirectionAngle.bottomRight.name,
                              "1",
                              iconName: newDashboardOpenIcon,
                              showLockIcon: false,
                              headingText: "DISORDER\nEVALUATION",
                              subText:
                              "A Critical information needed by our doctors to understand your Medical "
                                  "history, Symptoms, Sleep, Diet & Lifestyle for proper diagnosis!",
                              bgColor: bg1,
                              button1Name: evalBtnName ?? '',
                              button1Color: evalBtnColor ??
                                  newDashboardLightGreyButtonColor,
                              type: StageType.evaluation,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NewScheduleScreen()));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/new_ds/follow_up.png"),
                          size: 11.sp,
                          color: gHintTextColor,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          'Follow-up call',
                          style: TextStyle(
                            color: gHintTextColor,
                            fontSize: headingFont,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            // Flexible(
            //     child: Center(
            //       child: InkWell(
            //         onTap: () async {
            //           // getChatGroupId();
            //           final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
            //           final res  = await getAccessToken(uId!);
            //           debugPrint(uId);
            //           // debugPrint(res);
            //
            //           if(res.runtimeType != ErrorModel){
            //             final accessToken = _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);
            //
            //             final chatSuccessId = _pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID);
            //             // chat
            //             openKaleyraChat(uId, chatSuccessId!, accessToken!);
            //           }
            //           else{
            //             final result = res as ErrorModel;
            //             print("get Access Token error: ${result.message}");
            //             AppConfig().showSnackbar(context, result.message ?? '', isError: true, bottomPadding: 70);
            //
            //           }
            //         },
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Image.asset("assets/images/noun-chat-5153452.png",
            //               width: 25,
            //               height: 25,
            //             ),
            //             SizedBox(
            //               width: 5,
            //             ),
            //             Text('Chat Support',
            //               style: TextStyle(
            //                 fontSize: headingFont,
            //                 decoration: TextDecoration.underline,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     )
            // )
          ],
        ),
      ),
    );
  }

  PPView() {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          children: [
            TopPart(),
            PinkPart(),
            LightPurple(),
            PinkPart1(),
            GreenPurple(),

            // Flexible(
            //     child: Center(
            //       child: InkWell(
            //         onTap: () async {
            //           // getChatGroupId();
            //           final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
            //           final res  = await getAccessToken(uId!);
            //           debugPrint(uId);
            //           // debugPrint(res);
            //
            //           if(res.runtimeType != ErrorModel){
            //             final accessToken = _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);
            //
            //             final chatSuccessId = _pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID);
            //             // chat
            //             openKaleyraChat(uId, chatSuccessId!, accessToken!);
            //           }
            //           else{
            //             final result = res as ErrorModel;
            //             print("get Access Token error: ${result.message}");
            //             AppConfig().showSnackbar(context, result.message ?? '', isError: true, bottomPadding: 70);
            //
            //           }
            //         },
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Image.asset("assets/images/noun-chat-5153452.png",
            //               width: 25,
            //               height: 25,
            //             ),
            //             SizedBox(
            //               width: 5,
            //             ),
            //             Text('Chat Support',
            //               style: TextStyle(
            //                 fontSize: headingFont,
            //                 decoration: TextDecoration.underline,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     )
            // )
          ],
        ),
      ),
    );
  }

  Color redArc = Color(0xFFEF8484);
  Color yellowArc = Color(0xFFFFE889);
  Color greenArc = Color(0xFFA7CB52);

  PPContainerTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(
          opacity: 0.5,
          child: Stack(
            children: [
              tile(
                  arcColor: redArc,
                  heading: "MONTHLY MAINTENANCE PLAN [MMP]",
                  subText:
                  "Many of our customers request us to hand hold them for few months even after the program. Many want to be in touch with our doctors and seek help to design their meal and Yoga plan. They feel they need that motivation and support for some more time. Hence we have introduced a monthly plan for such customers. If you are interested,please sign up and our representative will reach out and explain how it works.......",
                  btn1Name: mmpBtn1Name ?? '',
                  btn1Color: mmpBtn1Color,
                  btnStage: PPButtonStage.MMP),
              Positioned(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      newDashboardLockIcon,
                      width: 20,
                      height: 20,
                      color: redArc,
                    ),
                  ))
            ],
          ),
        ),
        tile(
            arcColor: yellowArc,
            heading: "GUT MAINTENANCE GUIDE [GMG]",
            subText:
            "Congratulation on successfully completing the Gut Rhythm Reset Program, Great Job! Now its time to discuss your progress with your consulting doctor and one of the Senior Consultant to evaluate you Gut Condition. If all is well, you will be moved to maintenance. However if some more rectification is needed, They will discuss the next steps ....",
            btnStage: PPButtonStage.GMG,
            btn1Name: gmgBtn1Name ?? 'View GMG',
            btn1Color: gmgBtn1Color,
            btn2Name: gmgBtn2Name ?? "View End Report",
            btn2Color: gmgBtn2Color,
            btn3Name: gmgBtn3Name ?? 'Track & Earn',
            btn3Color: gmgBtn3Color),
        tile(
            arcColor: greenArc,
            heading: "POST PROGRAM CONSULT [PPC]",
            subText:
            "Congratulation on successfully completing the Gut Rhythm Reset Program, Great Job! Now its time to discuss your progress with your consulting doctor and one of the Senior Consultant to evaluate you Gut Condition. If all is well, you will be moved to maintenance. However if some more rectification is needed, They will discuss the next steps ....",
            btn1Name: postBtn1Name ?? 'Feedback',
            btn2Name: postBtn2Name ?? 'Schedule',
            btn3Name: postBtn3Name ?? 'Join',
            btn1Color: postBtn1Color,
            btn2Color: postBtn2Color,
            btn3Color: postBtn3Color,
            btnStage: PPButtonStage.PPC),
      ],
    );
  }

  ///outer 132 inner 130.5
  tile(
      {required Color arcColor,
        required String heading,
        required String subText,
        required String btn1Name,
        required PPButtonStage btnStage,
        String? btn2Name,
        String? btn3Name,
        Color? btn1Color,
        Color? btn2Color,
        Color? btn3Color}) {
    double width = MediaQuery.of(context).size.width;
    print("ratio: $width");
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(1.44, 0.02),
              child: Container(
                width: 96.w,
                height: 18.5.h,
                // height: width < 390 ? 132 : (width >= 390 && width < 500) ? 150 : 190 ,
                decoration: BoxDecoration(
                  color: arcColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1,
                      color: kLineColor,
                      offset: Offset(6, 3),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(1.34, 0.02),
              child: Container(
                width: 92.w,
                // height: width < 390 ? 130.5 : (width >= 390 && width < 500) ? 137.5 : 187.5 ,
                height: 18.2.h,
                padding: width < 390
                    ? EdgeInsets.symmetric(vertical: 0.5.h)
                    : EdgeInsets.only(top: 1.5.h, bottom: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(width < 390 ? 80 : 100),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(width < 390 ? 80 : 100),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        right: 0,
                        top: 10,
                        left: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  heading,
                                  style: TextStyle(
                                    fontFamily: eUser().mainHeadingFont,
                                    color: eUser().mainHeadingColor,
                                    fontSize: 12.sp,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              IntrinsicHeight(
                                child: Text(
                                  subText,
                                  softWrap: true,
                                  maxLines: 5,
                                  style: TextStyle(
                                      height: 1.22,
                                      fontFamily: kFontBook,
                                      color: eUser().mainHeadingColor,
                                      fontSize: 9.sp),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ppBuildButton(btn1Name, 1, btnStage, btn1Color),
                                if (btn2Name != null)
                                  ppBuildButton(
                                      btn2Name, 2, btnStage, btn2Color),
                                if (btn3Name != null)
                                  ppBuildButton(
                                      btn3Name, 3, btnStage, btn3Color),
                              ],
                            ),
                            SizedBox(
                              height: 1.5,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ppBuildButton(
      String btnName, int btnId, PPButtonStage stage, Color? btnColor) {
    return GestureDetector(
      onTap: () {
        switch (stage) {
          case PPButtonStage.MMP:
            break;
          case PPButtonStage.GMG:
            if (btnId == 1) {
              if (postProgramStage == "protocol_guide") {
                // if(_postConsultationAppointment!.value != null){
                //   if(_postConsultationAppointment!.value!.gmgPdfUrl != null){
                //     goToScreen(ProtocolGuideDetails(
                //       pdfLink: _postConsultationAppointment!.value!.gmgPdfUrl!,
                //       heading: "GMG",
                //       headCircleIcon: bsHeadPinIcon,
                //       isSheetCloseNeeded: true,
                //     ));
                //   }
                //   else{
                //     AppConfig().showSnackbar(context, "GMG Url is Empty", isError: true);
                //   }
                // }
              } else {
                // goToScreen(FinalFeedbackForm());

                AppConfig().showSnackbar(context, "Can't access Locked Stage",
                    isError: true);
              }
            }
            else if (btnId == 2) {
              if (postProgramStage == "protocol_guide") {
                // if(_postConsultationAppointment!.value != null){
                //   if(_postConsultationAppointment!.value!.programEndReportUser != null){
                //     goToScreen(ProtocolGuideDetails(
                //       pdfLink: _postConsultationAppointment!.value!.programEndReportUser!,
                //       heading: "User EndReport",
                //       headCircleIcon: bsHeadPinIcon,
                //       isSheetCloseNeeded: true,
                //     ));
                //   }
                //   else{
                //     AppConfig().showSnackbar(context, "User EndReport is Empty", isError: true);
                //   }
                // }
              } else {
                // goToScreen(FinalFeedbackForm());

                AppConfig().showSnackbar(context, "Can't access Locked Stage",
                    isError: true);
              }
            }
            else {
              showPostProgramScreen();
            }
            break;
          case PPButtonStage.PPC:
            if (btnId == 1) {
              if (postProgramStage == "post_program") {
                if (_gutPostProgramModel!.isProgramFeedbackSubmitted == "1") {
                  AppConfig()
                      .showSnackbar(context, "Feedback Already Submitted", isError: true);
                } else {
                  goToScreen(MedicalFeedbackForm());
                }
              }
              else {
                // goToScreen(FinalFeedbackForm());

                AppConfig().showSnackbar(context, "Can't access Locked Stage",
                    isError: true);
              }
            }
            else if (btnId == 2) {
              if (postProgramStage == "post_program") {
                if (_gutPostProgramModel!.isProgramFeedbackSubmitted == "1") {
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
                } else {
                  AppConfig().showSnackbar(
                      context, "Please complete the Feedback",
                      isError: true);
                }
              }
              else if (postProgramStage == "post_appointment_booked") {
                final model = _postConsultationAppointment;
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
                  isPostProgram: true,
                  prevBookingDate: model.value!.date,
                  prevBookingTime: model.value!.appointmentStartTime,
                  doctorDetails: model.value!.doctor,
                  doctorName: doctorName,
                  doctorPic: doctorImage,
                ));
              }
              else if (postProgramStage == "post_appointment_reschedule") {
                final model = _postConsultationAppointment;
                print(model);
                // if(model.value != null){
                //   print(model!.value!.date);
                // }
                List<String> doctorNames = [];
                String? doctorName;
                String? doctorImage;

                model?.value?.teamMember?.forEach((element) {
                  if (element.user != null) {
                    if (element.user!.roleId == "2") {
                      doctorNames.add('Dr. ${element.user!.name}' ?? '');
                      doctorName = 'Dr. ${element.user!.name}';
                      doctorImage = element.user?.profile ?? '';
                    }
                  }
                });

                _pref!.setString(AppConfig.appointmentId,model?.value?.id.toString() ?? '');


                // add this before calling calendertimescreen for reschedule
                // _pref!.setString(AppConfig.appointmentId , '');
                goToScreen(DoctorCalenderTimeScreen(
                  isReschedule: true,
                  isPostProgram: true,
                  prevBookingDate: model?.value!.date,
                  prevBookingTime: model?.value!.appointmentStartTime,
                  doctorDetails: model?.value!.doctor,
                  doctorName: doctorName,
                  doctorPic: doctorImage,
                ));
              }
              else if (postProgramStage == "protocol_guide") {
                // when protocolo guide need to show completed ui
              }
              else {
                AppConfig().showSnackbar(context, "Can't access Locked Stage",
                    isError: true);
              }
            }
            else {
              if (postProgramStage == "post_appointment_booked") {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                      builder: (context) => DoctorSlotsDetailsScreen(
                        bookingDate:
                        _postConsultationAppointment!.value!.date!,
                        bookingTime: _postConsultationAppointment!
                            .value!.slotStartTime!,
                        isPostProgram: true,
                        dashboardValueMap: _postConsultationAppointment!
                            .value!
                            .toJson(),
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
            }
            break;
        }
      },
      child: IntrinsicWidth(
        child: Container(
          height: 3.h,
          margin: EdgeInsets.symmetric(vertical: 0.3.h, horizontal: 8),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: btnColor ?? newDashboardLightGreyButtonColor,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: kLineColor,
                blurRadius: 5,
                offset: const Offset(2, 3),
              )
            ],
          ),
          child: Center(
            child: Row(
              children: [
                Text(
                  btnName,
                  style: TextStyle(
                      fontFamily: kFontMedium,
                      color: gWhiteColor,
                      // fontSize: 6.5.sp,
                      fontSize: 8.sp),
                ),
                // Icon(
                //   Icons.arrow_forward,
                //   color: gMainColor,
                //   size: 10.sp,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final completedBgColor = Color(0xFFEFEEC8);
  final currentBgColor = Color(0xFFFFF8DA);
  final lockedBgColor = Color(0xFFF1F2F2);

  customCircle(String angle, String stageNo,
      {String? iconName,
        String? headingText,
        String? subText,
        Color? bgColor,
        required String button1Name,
        required Color button1Color,
        String? button2Name,
        Color? button2Color,
        required StageType type,
        bool showLockIcon = true}) {
    double totalWidth = MediaQuery.of(context).size.aspectRatio;
    print("totalWidth: $totalWidth");
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IntrinsicHeight(
          child: Container(
            height: 22.h,
            decoration: BoxDecoration(
                color: bgColor ?? lockedBgColor,
                borderRadius: BorderRadius.only(
                  topRight: (angle == DirectionAngle.bottomLeft.name)
                      ? const Radius.circular(0)
                      : Radius.circular(60.sp),
                  topLeft: (angle == DirectionAngle.bottomRight.name)
                      ? const Radius.circular(0)
                      : Radius.circular(60.sp),
                  bottomLeft: (angle == DirectionAngle.topRight.name)
                      ? const Radius.circular(0)
                      : Radius.circular(60.sp),
                  bottomRight: (angle == DirectionAngle.topLeft.name)
                      ? const Radius.circular(0)
                      : Radius.circular(60.sp),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kLineColor,
                    blurRadius: 10,
                    offset: const Offset(2, 3),
                  )
                ]
              // border: Border.all(
              //     color: borderColor ?? gsecondaryColor,
              //     width: 1
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Center(
                  child: Text(
                    headingText ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: 11.sp),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: LayoutBuilder(
                    builder: (_, size) {
                      // Build the textspan
                      var span = TextSpan(
                        text: subText,
                        style: TextStyle(
                          height: 1.35,
                          fontFamily: kFontBook,
                          color: eUser().mainHeadingColor,
                          fontSize: 8.5.sp,

                        ),
                      );

                      TextSpan link = TextSpan(
                        text: "more",
                        style: TextStyle(
                            height: 1.3,
                            fontFamily: kFontBook,
                            color: gsecondaryColor,
                            fontSize:
                            bottomSheetSubHeadingSFontSize),
                        recognizer: TapGestureRecognizer()..onTap = () => showMoreTextSheet(subText!),
                      );

                      const String _kEllipsis = '\u2026';

                      String delimiter = _kEllipsis + '';
                      final textDirection = Directionality.of(context);

                      TextPainter textPainter = TextPainter(
                        text: link,
                        // maxLines: 3,
                        ellipsis: delimiter,
                          textDirection: textDirection
                      );
                      textPainter.layout(minWidth: 0, maxWidth: size.maxWidth);
                      final linkSize = textPainter.size;

                      TextSpan _delimiter = TextSpan(
                        text: delimiter,
                      );


                      // Layout and measure delimiter
                      textPainter.text = _delimiter;
                      textPainter.layout(minWidth: 0, maxWidth: size.maxWidth);
                      final delimiterSize = textPainter.size;

                      // Layout and measure text
                      textPainter.text = span;
                      textPainter.maxLines = 3;
                      textPainter.textAlign = TextAlign.start;
                      textPainter.layout(minWidth: size.minWidth, maxWidth: size.maxWidth);
                      final textSize = textPainter.size;

                      // Get the endIndex of data
                      bool linkLongerThanLine = false;
                      int endIndex;

                      if (linkSize.width < size.maxWidth) {
                        final readMoreSize = linkSize.width + delimiterSize.width;
                        print("inside if ${textSize.width} ${textSize.height} $readMoreSize");

                        final pos = textPainter.getPositionForOffset(Offset(
                          textDirection == TextDirection.rtl
                              ? readMoreSize
                              : textSize.width - readMoreSize,
                          textSize.height,
                        ));
                        print("pos: $pos");
                        endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
                      }
                      else {
                        print("inside else");
                        var pos = textPainter.getPositionForOffset(
                          textSize.bottomLeft(Offset.zero),
                        );
                        endIndex = pos.offset;
                        linkLongerThanLine = true;
                      }

                      print("end: $endIndex");

                      const String _kLineSeparator = '\u2028';

                        return RichText(
                        textAlign: TextAlign.start,
                        textScaleFactor: 0.85,
                        maxLines: 3,
                          // softWrap: true,
                          // overflow: TextOverflow.clip,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: subText!.substring(0, endIndex) +
                              (linkLongerThanLine ? _kLineSeparator : ''),
                            style: TextStyle(
                          height: 1.28,
                          fontFamily: kFontBook,
                          color: eUser().mainHeadingColor,
                          fontSize: 9.5.sp,
                        ),
                            children: <TextSpan>[_delimiter, link]
                        ),
                      );
                      // return RichText(
                      //   textAlign: TextAlign.start,
                      //   textScaleFactor: 0.85,
                      //   maxLines: 3,
                      //   overflow: TextOverflow.ellipsis,
                      //   text: TextSpan(children: [
                      //     TextSpan(
                      //       text: subText!.substring(
                      //           0,
                      //           int.parse(
                      //               "${(subText.length * 0.4789).toInt()}")) +
                      //           "...",
                      //       style: TextStyle(
                      //         height: 1.28,
                      //         fontFamily: kFontBook,
                      //         color: eUser().mainHeadingColor,
                      //         fontSize: 9.5.sp,
                      //       ),
                      //     ),
                      //     WidgetSpan(
                      //       child: InkWell(
                      //           mouseCursor: SystemMouseCursors.click,
                      //           onTap: () {
                      //             showMoreTextSheet(subText);
                      //           },
                      //           child: Text(
                      //             "more",
                      //             style: TextStyle(
                      //                 height: 1.3,
                      //                 fontFamily: kFontBook,
                      //                 color: gsecondaryColor,
                      //                 fontSize:
                      //                 bottomSheetSubHeadingSFontSize),
                      //           )),
                      //     )
                      //   ]),
                      // );
                    },
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildButton(button1Name, button1Color, 1, type),
                    if (button2Name != null)
                      SizedBox(
                        width: 5,
                      ),
                    if (button2Name != null)
                      buildButton(button2Name, button2Color!, 2, type)
                  ],
                )
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(subText ?? '',
                //       // "While you wait for your customised Product Kit arrive to be used during the Reset phase of the program, "
                //       //   "You will be give a preparatory meal protocol based on your food type",
                //         // " While you wait for your  customised Product Kit arrive to be used during the Reset phase of the program,",
                //       style: TextStyle(
                //           fontFamily: kFontBook,
                //           color: eUser().mainHeadingColor,
                //           fontSize: bottomSheetSubHeadingSFontSize
                //       ),
                //       textAlign: TextAlign.justify,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
        Positioned(
            left: (angle == DirectionAngle.bottomRight.name ||
                angle == DirectionAngle.topRight.name)
                ? -20
                : null,
            top: (angle == DirectionAngle.bottomRight.name ||
                angle == DirectionAngle.bottomLeft.name)
                ? -19
                : null,
            right: (angle == DirectionAngle.bottomLeft.name ||
                angle == DirectionAngle.topLeft.name)
                ? -20
                : null,
            bottom: (angle == DirectionAngle.topRight.name ||
                angle == DirectionAngle.topLeft.name)
                ? -19
                : null,
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (angle == DirectionAngle.bottomRight.name)
                    ? kNumberCircleGreen
                    : (angle == DirectionAngle.bottomLeft.name)
                    ? kNumberCircleAmber
                    : (angle == DirectionAngle.topLeft.name)
                    ? kNumberCircleRed
                    : kNumberCirclePurple,
              ),
              child: Center(
                  child: Text(
                    stageNo,
                    style: TextStyle(
                        fontFamily: kFontSensaBrush,
                        fontSize: 13.sp,
                        color: gWhiteColor),
                  )),
            )),
        Positioned(
            left: (angle == DirectionAngle.topLeft.name ||
                angle == DirectionAngle.bottomLeft.name)
                ? 20
                : null,
            // top: (angle == DirectionAngle.bottomRight.name || angle == DirectionAngle.bottomLeft.name) ?  : null,
            right: (angle == DirectionAngle.topRight.name ||
                angle == DirectionAngle.bottomRight.name)
                ? 20
                : null,
            bottom: (angle == DirectionAngle.bottomRight.name ||
                angle == DirectionAngle.bottomLeft.name)
                ? 8
                : null,
            child: Visibility(
              visible: showLockIcon,
              child: Image.asset(
                (angle == DirectionAngle.topLeft.name)
                    ? iconName ?? newDashboardLockIcon
                    : (angle == DirectionAngle.topRight.name)
                    ? iconName ?? newDashboardLockIcon
                    : (angle == DirectionAngle.bottomLeft.name)
                    ? iconName ?? newDashboardLockIcon
                    : iconName ?? newDashboardLockIcon,
                height: 3.h,
              ),
            )),
      ],
    );
  }

  bool isShown = false;

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
        AppConfig().showSnackbar(context, model.message!, isError: true);
      }
      setState(() {
        isPressed = false;
      });
    }
  }

  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    videoPlayerController =
        VideoPlayerController.network(Uri.parse(url).toString());
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16 / 9,
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
        showControls: false);
    if (!await WakelockPlus.enabled) {
      WakelockPlus.enable();
    }
  }
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
    if (_chewieController != null) _chewieController!.dispose();
    if (videoPlayerController != null) videoPlayerController!.dispose();

    // if (_mealPlayerController != null) {
    //   _mealPlayerController!.dispose();
    // }
    if (await WakelockPlus.enabled) {
      WakelockPlus.disable();
    }

    if (videoPlayerController != null) videoPlayerController!.dispose();
    if (_chewieController != null) _chewieController!.dispose();
  }

  mealReadySheet() {
    // addUrlToVideoPlayer(_gutShipDataModel?.value ?? '');
    addUrlToVideoPlayerChewie(_gutShipDataModel?.stringValue ?? '');
    return AppConfig().showSheet(
        context,
        WillPopScope(
            child: Column(
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
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.h, horizontal: 12.w),
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
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.h, horizontal: 12.w),
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
            onWillPop: () async {
              disposePlayer();
              return Future.value(true);
            }),
        bottomSheetHeight: 75.h);
  }

  buildMealVideo() {
    if (_chewieController != null) {
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
                isControlsVisible: false,
                controller: _chewieController!,
              ),
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
    }
    // else if (_mealPlayerController != null) {
    //   return AspectRatio(
    //     aspectRatio: 16 / 9,
    //     child: Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //         border: Border.all(color: gPrimaryColor, width: 1),
    //         // boxShadow: [
    //         //   BoxShadow(
    //         //     color: Colors.grey.withOpacity(0.3),
    //         //     blurRadius: 20,
    //         //     offset: const Offset(2, 10),
    //         //   ),
    //         // ],
    //       ),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(5),
    //         child: Center(
    //           child: VlcPlayerWithControls(
    //             key: _key,
    //             controller: _mealPlayerController!,
    //             showVolume: false,
    //             showVideoProgress: false,
    //             seekButtonIconSize: 10.sp,
    //             playButtonIconSize: 14.sp,
    //             replayButtonSize: 10.sp,
    //           ),
    //           // child: VlcPlayer(
    //           //   controller: _videoPlayerController!,
    //           //   aspectRatio: 16 / 9,
    //           //   virtualDisplay: false,
    //           //   placeholder: Center(child: CircularProgressIndicator()),
    //           // ),
    //         ),
    //       ),
    //       // child: Stack(
    //       //   children: <Widget>[
    //       //     ClipRRect(
    //       //       borderRadius: BorderRadius.circular(5),
    //       //       child: Center(
    //       //         child: VlcPlayer(
    //       //           controller: _videoPlayerController!,
    //       //           aspectRatio: 16 / 9,
    //       //           virtualDisplay: false,
    //       //           placeholder: Center(child: CircularProgressIndicator()),
    //       //         ),
    //       //       ),
    //       //     ),
    //       //     ControlsOverlay(controller: _videoPlayerController,)
    //       //   ],
    //       // ),
    //     ),
    //   );
    // }
    else {
      return SizedBox.shrink();
    }
  }

  final ShipTrackRepository shipTrackRepository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

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

  getProgramTransBorderColor(String type) {
    print("getProgramTransBorderColor");
    if (type == "color") {
      if (transStage != null && transStage!.isNotEmpty) {
        print("if color");
        if (_transModel != null && _transMealModel != null) {
          return kBigCircleBorderYellow;
        } else if (_transModel?.value != null &&
            _transModel?.value?.isTransMealCompleted == true) {
          return kBigCircleBorderGreen;
        }
      } else if (programOptionStage != null && programOptionStage!.isNotEmpty) {
        print("else color");
        if (_gutNormalProgramModel != null || _gutProgramModel != null) {
          return kBigCircleBorderYellow;
        }
      } else {
        return kBigCircleBorderRed;
      }
    } else {
      if (transStage != null && transStage!.isNotEmpty) {
        print("if border");
        if (_transModel != null && _transMealModel != null) {
          return newDashboardUnLockIcon;
        } else if (_transModel?.value != null &&
            _transModel?.value?.isTransMealCompleted == true) {
          return newDashboardOpenIcon;
        }
      } else if (programOptionStage != null && programOptionStage!.isNotEmpty) {
        if (_gutNormalProgramModel != null || _gutProgramModel != null) {
          return newDashboardUnLockIcon;
        }
      } else {
        return newDashboardLockIcon;
      }
    }
  }

  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  buildButton(String title, Color color, int buttonId, StageType stageType) {
    return GestureDetector(
      onTap: () {
        handleButtonOnTapByType(stageType, buttonId);
      },
      child: IntrinsicWidth(
        child: Container(
          height: 3.h,
          margin: EdgeInsets.symmetric(vertical: 0.3.h),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: kLineColor,
                blurRadius: 5,
                offset: const Offset(2, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: kFontMedium,
                  color: gWhiteColor,
                  fontSize: 8.sp,
                ),
              ),
              // Icon(
              //   Icons.arrow_forward,
              //   color: gMainColor,
              //   size: 10.sp,
              // )
            ],
          ),
        ),
      ),
    );
  }

//completedBgColor
// currentBgColor
// lockedBgColor
  void updateNewStage(String? stage) {
    print("consultationStage: ==> ${stage}");
    switch (stage) {
      case 'evaluation_done':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        mealBtn1Name = "View Plan";

        bg2 = currentBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Schedule";
        consBtn2Color = newDashboardLightGreyButtonColor;
        consBtn2Name = "Join Cons";

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";

        break;
      case 'pending':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = currentBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Schedule";
        consBtn2Color = newDashboardLightGreyButtonColor;
        consBtn2Name = "Join Cons";

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";

        break;
      case 'consultation_reschedule':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = currentBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "ReSchedule";
        consBtn2Color = newDashboardLightGreyButtonColor;
        consBtn2Name = "Join Cons";
        showConsLockIcon = true;

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";
        break;
      case 'appointment_booked':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = currentBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "ReSchedule";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "Join Cons";
        showConsLockIcon = true;

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";
        break;
      case 'consultation_done':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = currentBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardLightGreyButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = true;

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";
        break;
      case 'consultation_accepted':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = currentBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Accepted";
        consBtn2Color = newDashboardLightGreyButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = true;

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";
        break;
      case 'consultation_waiting':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = currentBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Upload Report";
        consBtn2Color = newDashboardLightGreyButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = true;

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";
        break;
      case 'check_user_reports':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = currentBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Awaiting";
        consBtn2Color = newDashboardLightGreyButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = true;

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";
        break;
      case 'consultation_rejected':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = currentBgColor;
        consBtn1Color = gsecondaryColor;
        consBtn1Name = "Rejected";
        if (_gutDataModel?.rejectedCase != null) {
          if (_gutDataModel!.rejectedCase!.historyWithMrValue!.mr != null &&
              _gutDataModel!.rejectedCase!.historyWithMrValue!.mr!.isNotEmpty) {
            consBtn2Color = newDashboardGreenButtonColor;
          } else {
            consBtn2Color = newDashboardLightGreyButtonColor;
          }
        }
        consBtn2Name = "View MR";
        showConsLockIcon = true;

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";
        break;
      case 'report_upload':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        prepBtn1Name = "View Plan";
        prepBtn2Name = "Track Kit";
        mealBtn1Name = "View Plan";
        break;

      case 'prep_meal_plan_completed':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        // if (_prepratoryModel!.value!.prep_days! !=
        //     _prepratoryModel!.value!.currentDay) {
        //   bg3 = currentBgColor;
        //   prepBtn1Color = newDashboardGreenButtonColor;
        //   prepBtn1Name = "View Plan";
        //   prepBtn2Color = newDashboardLightGreyButtonColor;
        //   prepBtn2Name = "Track Kit";
        //   showPrepLockIcon = true;
        // } else {
        bg3 = currentBgColor;
        prepBtn1Color = newDashboardGreenButtonColor;
        prepBtn1Name = "View Plan";
        prepBtn2Color = newDashboardLightGreyButtonColor;
        prepBtn2Name = "Track Kit";
        showPrepLockIcon = true;
        // }

        mealBtn1Name = "View Plan";
        break;
      case 'shipping_packed':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        // if (_prepratoryModel!.value!.prep_days! !=
        //     _prepratoryModel!.value!.currentDay) {
        //   bg3 = currentBgColor;
        //   prepBtn1Color = newDashboardGreenButtonColor;
        //   prepBtn1Name = "View Plan";
        //   prepBtn2Color = newDashboardGreenButtonColor;
        //   prepBtn2Name = "Track Kit";
        //   showPrepLockIcon = true;
        // } else {
        bg3 = currentBgColor;
        prepBtn1Color = newDashboardGreenButtonColor;
        prepBtn1Name = "View Plan";
        prepBtn2Color = newDashboardGreenButtonColor;
        prepBtn2Name = "Track Kit";
        showPrepLockIcon = true;
        // }

        mealBtn1Name = "View Plan";
        break;
      case 'shipping_paused':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        // if (_prepratoryModel!.value!.prep_days! !=
        //     _prepratoryModel!.value!.currentDay) {
        //   bg3 = currentBgColor;
        //   prepBtn1Color = newDashboardGreenButtonColor;
        //   prepBtn1Name = "View Plan";
        //   prepBtn2Color = newDashboardGreenButtonColor;
        //   prepBtn2Name = "Track Kit";
        //   showPrepLockIcon = true;
        // } else {
        bg3 = currentBgColor;
        prepBtn1Color = newDashboardGreenButtonColor;
        prepBtn1Name = "View Plan";
        prepBtn2Color = newDashboardGreenButtonColor;
        prepBtn2Name = "Track Kit";
        showPrepLockIcon = true;
        // }

        mealBtn1Name = "View Plan";
        break;
      case 'shipping_delivered':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        // if (_prepratoryModel!.value!.prep_days! !=
        //     _prepratoryModel!.value!.currentDay) {
        //   bg3 = currentBgColor;
        //   prepBtn1Color = newDashboardGreenButtonColor;
        //   prepBtn1Name = "View Plan";
        //   prepBtn2Color = newDashboardGreenButtonColor;
        //   prepBtn2Name = "Track Kit";
        //   showPrepLockIcon = true;
        // } else {
        bg3 = currentBgColor;
        prepBtn1Color = newDashboardGreenButtonColor;
        prepBtn1Name = "View Plan";
        prepBtn2Color = newDashboardGreenButtonColor;
        prepBtn2Name = "Track Kit";
        showPrepLockIcon = true;
        // }

        mealBtn1Name = "View Plan";
        break;
      case 'shipping_approved':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        // if (_prepratoryModel!.value!.prep_days! !=
        //     _prepratoryModel!.value!.currentDay) {
        //   bg3 = currentBgColor;
        //   prepBtn1Color = newDashboardGreenButtonColor;
        //   prepBtn1Name = "View Plan";
        //   prepBtn2Color = newDashboardGreenButtonColor;
        //   prepBtn2Name = "Track Kit";
        //   showPrepLockIcon = true;
        // } else {
        bg3 = currentBgColor;
        prepBtn1Color = newDashboardGreenButtonColor;
        prepBtn1Name = "View Plan";
        prepBtn2Color = newDashboardGreenButtonColor;
        prepBtn2Name = "Track Kit";
        showPrepLockIcon = true;
        // }

        mealBtn1Name = "View Plan";
        break;
      case 'start_program':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        bg3 = completedBgColor;
        prepBtn1Color = newDashboardGreenButtonColor;
        prepBtn1Name = "View Plan";
        prepBtn2Color = newDashboardGreenButtonColor;
        prepBtn2Name = "Track Kit";
        showPrepLockIcon = false;

        if (_prepratoryModel!.value!.isPrepCompleted != null &&
            _prepratoryModel!.value!.isPrepCompleted == true) {
          mealBtn1Color = newDashboardGreenButtonColor;
          showMealLockIcon = true;
          bg4 = currentBgColor;
        }
        else {
          mealBtn2Color = newDashboardLightGreyButtonColor;
          showMealLockIcon = false;
          bg4 = lockedBgColor;
        }
        mealBtn1Name = "View Plan";
        mealBtn2Color = newDashboardLightGreyButtonColor;
        mealBtn2Name = "Transition";

        break;
      case 'trans_program':
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        bg3 = completedBgColor;
        prepBtn1Color = newDashboardGreenButtonColor;
        prepBtn1Name = "View Plan";
        prepBtn2Color = newDashboardGreenButtonColor;
        prepBtn2Name = "Track Kit";
        showPrepLockIcon = false;

        print(
            "_prepratoryModel!.value!.isPrepCompleted != null: ${_transModel!.value!.isTransMealCompleted != null}");
        print(
            "_prepratoryModel!.value!.isPrepCompleted! == true: ${_transModel!.value!.isTransMealCompleted == true} ${_transModel!.value!.isTransMealCompleted}");

        if ((_transModel!.value!.isTransMealCompleted != null) &&
            _transModel!.value!.isTransMealCompleted == true) {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = false;
        } else {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = true;
        }
        break;
      case 'post_program':
        changeToggle();
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        if ((_transModel?.value!.isTransMealCompleted != null) &&
            _transModel?.value?.isTransMealCompleted == true) {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = false;
        } else {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = true;
        }

        postBtn1Name = "Feedback";
        if (_gutPostProgramModel!.isProgramFeedbackSubmitted != null) {
          print("PPC");
          print(_gutPostProgramModel!.isProgramFeedbackSubmitted);
          if (_gutPostProgramModel!.isProgramFeedbackSubmitted == "0") {
            postBtn2Color = newDashboardLightGreyButtonColor;
            postBtn1Color = newDashboardGreenButtonColor;
          } else {
            postBtn2Color = newDashboardGreenButtonColor;
            postBtn1Color = newDashboardLightGreyButtonColor;
          }
        }
        postBtn2Name = "Schedule";
        postBtn3Color = newDashboardLightGreyButtonColor;
        postBtn3Name = "Join";
        break;
      case 'post_appointment_booked':
        changeToggle();
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        if ((_transModel?.value!.isTransMealCompleted != null) &&
            _transModel?.value?.isTransMealCompleted == true) {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = false;
        } else {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = true;
        }

        postBtn1Color = newDashboardLightGreyButtonColor;
        postBtn1Name = "Feedback";
        postBtn2Color = newDashboardGreenButtonColor;
        postBtn2Name = "ReSchedule";
        postBtn3Color = newDashboardGreenButtonColor;
        postBtn3Name = "Join";

        break;
      case 'post_appointment_done':
        changeToggle();
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        if ((_transModel?.value!.isTransMealCompleted != null) &&
            _transModel?.value?.isTransMealCompleted == true) {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = false;
        } else {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = true;
        }

        postBtn1Color = newDashboardLightGreyButtonColor;
        postBtn1Name = "Feedback";
        postBtn2Color = newDashboardGreenButtonColor;
        postBtn2Name = "Completed";
        postBtn3Color = newDashboardLightGreyButtonColor;
        postBtn3Name = "Join";

        break;
      case 'post_appointment_reschedule':
        changeToggle();
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        if ((_transModel?.value!.isTransMealCompleted != null) &&
            _transModel?.value?.isTransMealCompleted == true) {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = false;
        } else {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = true;
        }

        postBtn1Color = newDashboardLightGreyButtonColor;
        postBtn1Name = "Feedback";
        postBtn2Color = newDashboardGreenButtonColor;
        postBtn2Name = "Reschedule";
        postBtn3Color = newDashboardLightGreyButtonColor;
        postBtn3Name = "Join";
        break;
      case 'protocol_guide':
        changeToggle();
        bg1 = completedBgColor;
        evalBtnColor = newDashboardGreenButtonColor;
        evalBtnName = "View Files";

        bg2 = completedBgColor;
        consBtn1Color = newDashboardGreenButtonColor;
        consBtn1Name = "Completed";
        consBtn2Color = newDashboardGreenButtonColor;
        consBtn2Name = "View MR";
        showConsLockIcon = false;

        if ((_transModel?.value!.isTransMealCompleted != null) &&
            _transModel?.value?.isTransMealCompleted == true) {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = false;
        } else {
          bg4 = currentBgColor;
          mealBtn1Color = newDashboardGreenButtonColor;
          mealBtn1Name = "View Plan";
          mealBtn2Color = newDashboardGreenButtonColor;
          mealBtn2Name = "Transition";
          showMealLockIcon = true;
        }

        postBtn1Color = newDashboardLightGreyButtonColor;
        postBtn1Name = "Completed";
        postBtn2Color = newDashboardLightGreyButtonColor;
        postBtn2Name = "Completed";
        postBtn3Color = newDashboardLightGreyButtonColor;
        postBtn3Name = "Completed";

        gmgBtn1Color = newDashboardGreenButtonColor;
        gmgBtn1Name = "View GMG";
        gmgBtn2Color = newDashboardGreenButtonColor;
        gmgBtn2Name = "View End Report";
        gmgBtn3Color = newDashboardGreenButtonColor;
        gmgBtn3Name = "Track & Earn";
        // gmgBtn2Color = newDashboardLightGreyButtonColor;
        // gmgBtn2Name = "View PDF";

        break;
    }
  }

  changeToggle() {
    setState(() {
      initialIndex = 1;
    });
    _tabController!.animateTo(initialIndex);
  }

  handleButtonOnTapByType(StageType type, int buttonId) {
    switch (type) {
      case StageType.evaluation:
      // goToScreen(DosDontsProgramScreen(pdfLink: '',));
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

              print(model!.value!.toJson());
              // add this before calling calendertimescreen for reschedule
              // _pref!.setString(AppConfig.appointmentId , '');
              goToScreen(DoctorCalenderTimeScreen(
                isReschedule: true,
                prevBookingDate: model!.value!.date,
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
                reason: _gutDataModel?.rejectedCase?.reason ?? '',
              ));
              break;
            case 'check_user_reports':
            // print(_gutDataModel!.value);
              goToScreen(CheckUserReportsScreen());
              break;
            default:
              goToScreen(const ConsultationSuccess());
          }
        }
        else {
          print(consultationStage);
          switch (consultationStage) {
            case 'check_user_reports':
            // print(_gutDataModel!.value);
              goToScreen(CheckUserReportsScreen());
              break;
            case 'appointment_booked':
              final model = _getAppointmentDetailsModel;
              print("appointment id : ${model?.value?.id.toString()}");
              _pref!.setString(
                  AppConfig.appointmentId, model?.value?.id.toString() ?? '');
              goToScreen(DoctorSlotsDetailsScreen(
                bookingDate: model!.value!.date!,
                bookingTime: model.value!.slotStartTime!,
                dashboardValueMap: model.value!.toJson(),
                isFromDashboard: true,
              ));
              break;
            case 'consultation_rejected':
              goToScreen(MedicalReportScreen(
                pdfLink: _gutDataModel?.rejectedCase?.historyWithMrValue?.mr ?? '',
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
        if (buttonId == 1) {
          showPrepratoryMealScreen();
        } else {
          if (shippingStage != null && shippingStage!.isNotEmpty) {
            if (_shippingApprovedModel != null) {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => CookKitTracking(
                    awb_number:
                    _shippingApprovedModel?.value?.awbCode ?? '',
                    currentStage: shippingStage!,
                  ),
                ),
              )
                  .then((value) => reloadUI());
            } else {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) =>
                      CookKitTracking(currentStage: shippingStage ?? ''),
                ),
              )
                  .then((value) => reloadUI());
            }
          } else {
            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        }
        break;
      case StageType.normal_meal:
        if (buttonId == 1) {
          if (programOptionStage != null &&
              programOptionStage!.isNotEmpty &&
              (_prepratoryModel!.value!.isPrepCompleted != null &&
                  _prepratoryModel!.value!.isPrepCompleted == true)) {
            print("called");
            showProgramScreen();
          } else {
            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        }
        else {
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
              videoLink: _prepratoryModel?.value?.startVideo ?? "",
            ),
          ),
        )
            .then((value) => reloadUI());
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (_prepratoryModel!.value!.isPrepCompleted!)
                ? PrepratoryMealCompletedScreen()
                : PreparatoryPlanScreen(
                dayNumber: _prepratoryModel!.value!.currentDay ?? '',
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
              videoLink: _transModel?.value?.startVideo ?? "",
            ),
          ),
        )
            .then((value) => reloadUI());
      } else {
        print(_transModel!.value!.toJson());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTransitionDesign(
                postProgramStage: postProgramStage,
                totalDays: _transModel!.value!.trans_days ?? '1',
                dayNumber: _transModel?.value?.currentDay ?? '',
                trackerVideoLink: _gutProgramModel!.value!.tracker_video_url),
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
      if (_gutProgramModel!.value!.recipeVideo != null) {
        _pref!.setString(
            AppConfig().receipeVideoUrl, _gutProgramModel!.value!.recipeVideo!);
      }
      if (_gutProgramModel!.value!.tracker_video_url != null) {
        _pref!.setString(AppConfig().trackerVideoUrl,
            _gutProgramModel!.value!.tracker_video_url!);
      }
      if (_gutProgramModel!.value!.startProgram == '0') {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => ProgramPlanScreen(
              from: ProgramMealType.detox.name,
              // videoLink: _gutProgramModel?.value?.startVideoUrl ?? "",
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
                receipeVideoLink: _gutProgramModel!.value!.recipeVideo,
                trackerVideoLink: _gutProgramModel!.value!.tracker_video_url),
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
      if (postProgramStage == "protocol_guide") {
        // goToScreen(PPLevelsScreen());
        goToScreen(PPLevelsDemo());
      } else {
        AppConfig()
            .showSnackbar(context, "Can't access Locked Stage", isError: true);
      }
    }
  }

  handleTrackerRemedyOnTap() {
    goToScreen(HomeRemediesScreen());
  }

  tabView() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TabBarView(
        controller: _tabController,
        children: [
          Align(alignment: Alignment.center, child: view()),
          PPContainerTile()
          // PPView(),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
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
        isSheetCloseNeeded: true, sheetCloseOnTap: () {
      Navigator.pop(context);
    });
  }
}

enum StageType {
  evaluation,
  med_consultation,
  prep_meal,
  normal_meal,
  post_consultation
}

class TopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      color: kNumberCirclePurple,
      child: Material(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.0),
        ),
        color: gWhiteColor,
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[],
            )
          ],
        ),
      ),
    );
  }
}

class PinkPart extends StatelessWidget {
  final completedBgColor = Color(0xFFEFEEC8);
  final currentBgColor = Color(0xFFFFF8DA);
  final lockedBgColor = Color(0xFFF1F2F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      width: MediaQuery.of(context).size.width,
      color: kNumberCircleAmber,
      child: Material(
        color: kNumberCirclePurple,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    "TODAY 5:30 PM",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "MONTHLY MAINTENANCE PLAN [MMP]",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 15.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3.0, color: Colors.white)),
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundImage:
                                  ExactAssetImage('assets/p3.jpg'),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 3.0, color: Colors.white)),
                              child: CircleAvatar(
                                radius: 14.0,
                                backgroundImage:
                                ExactAssetImage('assets/p2.jpg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "join Marie, John & 10 others",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LightPurple extends StatelessWidget {
  final currentBgColor = Color(0xFFFFF8DA);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      width: MediaQuery.of(context).size.width,
      color: kNumberCircleRed,
      child: Material(
        color: kNumberCircleAmber,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    "TODAY 5:30 PM",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "GUT MAINTENANCE GUIDE [GMG]",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 15.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3.0, color: Colors.white)),
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundImage:
                                  ExactAssetImage('assets/p3.jpeg'),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 3.0, color: Colors.white)),
                              child: CircleAvatar(
                                radius: 14.0,
                                backgroundImage:
                                ExactAssetImage('assets/p2.jpg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "join Ryan, Bob & 12 others",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PinkPart1 extends StatelessWidget {
  final completedBgColor = Color(0xFFEFEEC8);
  final currentBgColor = Color(0xFFFFF8DA);
  final lockedBgColor = Color(0xFFF1F2F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      child: Material(
        color: kNumberCircleRed,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    "TODAY 5:30 PM",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "POST PROGRAM CONSULT [PPC]",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 15.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3.0, color: Colors.white)),
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundImage:
                                  ExactAssetImage('assets/p3.jpg'),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 3.0, color: Colors.white)),
                              child: CircleAvatar(
                                radius: 14.0,
                                backgroundImage:
                                ExactAssetImage('assets/p2.jpg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "join Marie, John & 10 others",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GreenPurple extends StatelessWidget {
  final currentBgColor = Color(0xFFFFF8DA);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Material(
        color: Colors.grey,
        //  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  // Text(
                  //   "MONTHLY MAINTENANCE PLAN [MMP]",
                  //   style: TextStyle(
                  //       fontSize: 12.sp,
                  //       color: Colors.white,
                  //       fontFamily: kFontBold),
                  // ),
                  SizedBox(height: 10.0),
                  // Text(
                  //   "Many of our customers request us to hand hold them for few months "
                  //       "even after the program. Many want to be in touch with our doctors and seek help to "
                  //       "design their meal and Yoga plan.",
                  //   style: TextStyle(
                  //       fontSize: 10.sp,
                  //       color: Colors.white70,
                  //       fontFamily: kFontBook),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     buildButton(),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     buildButton()
                  //   ],
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildButton() {
    return GestureDetector(
      onTap: () {},
      child: IntrinsicWidth(
        child: Container(
          height: 3.h,
          margin: EdgeInsets.symmetric(vertical: 0.3.h),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: kLineColor,
                blurRadius: 5,
                offset: const Offset(2, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Text(
                "View",
                style: TextStyle(
                  fontFamily: kFontMedium,
                  color: gTextColor,
                  fontSize: 6.5.sp,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: gMainColor,
                size: 10.sp,
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum PPButtonStage { MMP, GMG, PPC }
