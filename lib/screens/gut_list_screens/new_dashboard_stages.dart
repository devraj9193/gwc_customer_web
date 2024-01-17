/*
this design not using

design type: butterfly type design
 */

import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
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
import 'package:gwc_customer_web/screens/notification_screen.dart';
import 'package:gwc_customer_web/screens/post_program_screens/new_post_program/pp_levels_demo.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/new/preparatory_new_screen.dart';
import 'package:gwc_customer_web/screens/prepratory%20plan/prepratory_plan_screen.dart';
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
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
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
import '../prepratory plan/prepratory_meal_completed_screen.dart';
import '../program_plans/program_start_screen.dart';

enum DirectionAngle{
  topLeft, topRight, bottomLeft, bottomRight
}
class GutList extends StatefulWidget {
  GutList({Key? key}) : super(key: key);

  final GutListState myAppState=  GutListState();
  @override
  State<GutList> createState() => GutListState();
}

class GutListState extends State<GutList> {
  final _pref = AppConfig().preferences;

  late GutDataService _gutDataService;

  /// THIS IS FOR ABC DIALOG MEAL PLAN
  bool isMealProgressOpened = false;

  bool isProgressDialogOpened = true;
  BuildContext? _progressContext;

  String? consultationStage, shippingStage, prepratoryMealStage ,programOptionStage,transStage, postProgramStage;

  /// this is used when data=appointment_booked status
  GetAppointmentDetailsModel? _getAppointmentDetailsModel, _postConsultationAppointment;

  /// ths is used when data = shipping_approved status
  ShippingApprovedModel? _shippingApprovedModel;

  GetProgramModel? _gutProgramModel;

  GetPrePostMealModel? _prepratoryModel, _transModel;

  /// for other status we use this one(except shipping_approved & appointment_booked)
  GutDataModel? _gutDataModel, _gutShipDataModel, _gutNormalProgramModel, _gutPostProgramModel, _prepProgramModel, _transMealModel;



  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserProfile();

    if(_pref!.getString(AppConfig().shipRocketBearer) == null || _pref!.getString(AppConfig().shipRocketBearer)!.isEmpty){
      getShipRocketToken();
    }
    else{
      String token = _pref!.getString(AppConfig().shipRocketBearer)!;
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      print('shiprocketToken : $payload');
      var date = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      if(!DateTime.now().difference(date).isNegative){
        getShipRocketToken();
      }
    }



    getData();

  }
  void getShipRocketToken() async{
    print("getShipRocketToken called");
    ShipTrackService _shipTrackService = ShipTrackService(repository: shipTrackRepository);
    final getToken = await _shipTrackService.getShipRocketTokenService(AppConfig().shipRocketEmail, AppConfig().shipRocketPassword);
    print(getToken);
  }

  getData() async{
    isProgressDialogOpened = true;
    print("isProgressDialogOpened: $isProgressDialogOpened");
    Future.delayed(Duration(seconds: 0)).whenComplete(() {
      if(mounted) {
        _progressContext = context;
        //openProgressDialog(_progressContext!, willPop: true);
      }
    });
    _gutDataService = GutDataService(repository: repository);
    print("isProgressDialogOpened: $isProgressDialogOpened");

    final _getData = await _gutDataService.getGutDataService();
    print("_getData: $_getData");
    if(_getData.runtimeType == ErrorModel){
      ErrorModel model = _getData;
      print(model.message);
      isProgressDialogOpened = false;
      Future.delayed(Duration(seconds: 0)).whenComplete(() =>
          AppConfig().showSnackbar(context, model.message ?? '', isError: true,
              duration: 50000,
              action: SnackBarAction(
                label: 'Retry',
                onPressed: (){
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  getData();
                },
              )
          )
      );
    }
    else{
      isProgressDialogOpened = false;
      print("isProgressDialogOpened: $isProgressDialogOpened");
      GetDashboardDataModel _getDashboardDataModel = _getData as GetDashboardDataModel;
      print("_getDashboardDataModel.app_consulation: ${_getDashboardDataModel.app_consulation}");
      // checking for the consultation data if data = appointment_booked
      setState(() {
        if(_getDashboardDataModel.app_consulation != null){
          _getAppointmentDetailsModel = _getDashboardDataModel.app_consulation;
          consultationStage = _getAppointmentDetailsModel?.data ?? '';
        }
        else{
          print("consultation else");
          _gutDataModel = _getDashboardDataModel.normal_consultation;
          consultationStage = _gutDataModel?.data ?? '';
          print(consultationStage);
        }

        if(_getDashboardDataModel.prepratory_normal_program != null){
          _prepProgramModel = _getDashboardDataModel.prepratory_normal_program;
          prepratoryMealStage = _prepProgramModel?.data ?? '';
        }
        else if(_getDashboardDataModel.prepratory_program != null){
          _prepratoryModel = _getDashboardDataModel.prepratory_program;
          print("_prepratoryModel: $_prepratoryModel");
          prepratoryMealStage = _prepratoryModel?.data ?? '';
        }

        if(_getDashboardDataModel.approved_shipping != null){
          _shippingApprovedModel = _getDashboardDataModel.approved_shipping;
          shippingStage = _shippingApprovedModel?.data ?? '';
        }
        else{
          _gutShipDataModel = _getDashboardDataModel.normal_shipping;
          shippingStage = _gutShipDataModel?.data ?? '';
          // abc();
        }
        if(_getDashboardDataModel.data_program != null){
          _gutProgramModel = _getDashboardDataModel.data_program;
          print("programOptionStage if: ${programOptionStage}");
          programOptionStage = _gutProgramModel!.data;
        }
        else{
          _gutNormalProgramModel = _getDashboardDataModel.normal_program;
          print("programOptionStage else: ${programOptionStage}");
          programOptionStage = _gutNormalProgramModel!.data;
          abc();
        }

        if(_getDashboardDataModel.transition_meal_program != null){
          _transMealModel = _getDashboardDataModel.transition_meal_program;
          transStage = _transMealModel?.data;
        }
        else if(_getDashboardDataModel.trans_program != null){
          _transModel = _getDashboardDataModel.trans_program;
          transStage = _transModel!.data;
        }

        // post program will open once transition meal plan is completed
        // this is for other postprogram model
        if(_getDashboardDataModel.normal_postprogram != null){
          _gutPostProgramModel = _getDashboardDataModel.normal_postprogram;
          postProgramStage = _gutPostProgramModel?.data;
        }
        else{
          _postConsultationAppointment = _getDashboardDataModel.postprogram_consultation;
          _pref!.setString(AppConfig.appointmentId,_postConsultationAppointment?.value?.id.toString() ?? '');
          print("RESCHEDULE : ${_getDashboardDataModel.postprogram_consultation?.data}");
          postProgramStage = _postConsultationAppointment?.data;
        }
      });

      LocalStorageDashboardModel _localStorageDashboardModel = LocalStorageDashboardModel(
        consultStage: consultationStage,
        appointmentModel: jsonEncode(_getAppointmentDetailsModel),
        consultStringModel: jsonEncode(_gutDataModel),
        mrReport: (consultationStage == "report_upload") ? _gutDataModel!.historyWithMrValue!.mr :"",
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
      _pref!.setString(AppConfig.LOCAL_DASHBOARD_DATA, jsonEncode(_localStorageDashboardModel));
    }
  }

  getUserProfile() async{
    // print("user id: ${_pref!.getInt(AppConfig.KALEYRA_USER_ID)}");

    if(_pref!.getString(AppConfig.User_Name) != null
        || _pref!.getString(AppConfig.User_Name)!.isNotEmpty
        ||_pref!.getString(AppConfig.KALEYRA_USER_ID) != null
        ||_pref!.getString(AppConfig.KALEYRA_USER_ID)!.isNotEmpty)
    {
      final profile = await UserProfileService(repository: userRepository).getUserProfileService();
      if(profile.runtimeType == UserProfileModel){
        UserProfileModel model1 = profile as UserProfileModel;
        _pref!.setString(AppConfig.User_Name, model1.data?.name ?? model1.data?.fname ?? '');
        _pref!.setInt(AppConfig.USER_ID, model1.data?.id ?? -1);
        _pref!.setString(AppConfig.QB_USERNAME, model1.data!.qbUsername ?? '');
        _pref!.setString(AppConfig.QB_CURRENT_USERID, model1.data!.qbUserId ?? '');
        _pref!.setString(AppConfig.KALEYRA_USER_ID, model1.data!.kaleyraUID ?? '');

        if(_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) == null){
          await LoginWithOtpService(repository: loginOtpRepository).getAccessToken(model1.data!.kaleyraUID!);
        }
        print("user profile: ${_pref!.getString(AppConfig.QB_CURRENT_USERID)}");

      }
    }
    // if(_pref!.getInt(AppConfig.QB_CURRENT_USERID) != null && !await _qbService!.getSession() || _pref!.getBool(AppConfig.IS_QB_LOGIN) == null){
    //   String _uName = _pref!.getString(AppConfig.QB_USERNAME)!;
    //   _qbService!.login(_uName);
    // }
  }

  Future<void> reloadUI() async{
    await getData();
    setState(() { });
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


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
        child: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar(
                          () {
                        Navigator.pop(context);
                      },
                      isBackEnable: false,
                      showNotificationIcon: true,
                      notificationOnTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                      },
                      showHelpIcon: true,
                      helpOnTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => HelpScreen()));
                      },
                    showSupportIcon: true,
                    supportOnTap: (){
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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=> const NewScheduleScreen()));
                        },
                        child: Row(children: [
                          ImageIcon(AssetImage("assets/images/new_ds/follow_up.png"),
                            size: 11.sp,
                            color: gHintTextColor,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text('Follow-up call',
                            style: TextStyle(
                              color: gHintTextColor,
                              fontSize: headingFont,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],),
                      )
                    ],
                  ),
                  Expanded(child: Center(
                    child: (isProgressDialogOpened) ?
                    Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.3),
                      highlightColor: Colors.grey.withOpacity(0.7),
                      child: view(),
                    ) : view(),
                  ))
                ],
              ),
            ),
          ),
        )
    );
  }

  showSupportCallSheet(BuildContext context){
    return AppConfig().showSheet(context,
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("Please Select Call Type",
            style: TextStyle(
                fontSize: bottomSheetHeadingFontSize,
                fontFamily: bottomSheetHeadingFontFamily,
                height: 1.4
            ),
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
              onTap: () async{
                final res = await callSupport();
                if(res.runtimeType != ErrorModel){
                  AppConfig().showSnackbar(context, "Call Initiated. Our success Team will call you soon.");
                } else {
                  final result = res as ErrorModel;
                AppConfig().showSnackbar(context, "You can call your Success Team Member once you book your appointment", isError: true, bottomPadding: 50);
                }
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 1.h, horizontal: 5.w
                ),
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
                onTap: (){
                  Navigator.pop(context);
                  if(_pref!.getString(AppConfig.KALEYRA_SUCCESS_ID) == null){
                    AppConfig().showSnackbar(context, "Success Team Not available", isError: true);
                  }
                  else{
                    // // click-to-call
                    // callSupport();

                    if(_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) != null){
                      final accessToken = _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);
                      final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
                      final successId = _pref!.getString(AppConfig.KALEYRA_SUCCESS_ID);
                      // voice- call
                      supportVoiceCall(uId!, successId!, accessToken!);
                    }
                    else{
                      AppConfig().showSnackbar(context, "Something went wrong!!", isError: true);
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 1.h, horizontal: 5.w),
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
    ), bottomSheetHeight: 40.h,
      isSheetCloseNeeded: true,
        isDismissible: true,
      sheetCloseOnTap: (){
      Navigator.pop(context);
      }
    );
  }

  view(){
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          children: [
            Flexible(
                child: Center(
                  child: GestureDetector(
                    onTap: (){
                      if(shippingStage != null && shippingStage!.isNotEmpty){
                        if(_shippingApprovedModel != null){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CookKitTracking(awb_number: _shippingApprovedModel?.value?.awbCode ?? '',currentStage: shippingStage!,),
                            ),
                          ).then((value) => reloadUI());
                        }
                        else{
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CookKitTracking(currentStage: shippingStage ?? ''),
                            ),
                          ).then((value) => reloadUI());
                        }
                      }
                      else{
                        AppConfig().showSnackbar(context, "Can't access Locked Stage", isError: true);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(newDashboardTrackingIcon,
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Tracker &\nShopping',
                          style: TextStyle(
                            fontSize: headingFont,
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ),
            IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child: customCircle(DirectionAngle.topLeft.name, "03",
                              iconName: ((prepratoryMealStage == null || prepratoryMealStage!.isEmpty) && _prepratoryModel == null) ? null : (_prepratoryModel?.value?.isPrepCompleted == true) ? newDashboardOpenIcon : newDashboardUnLockIcon,
                            headingText: "BEGIN GUT\nPREPARATION",subText: "While you wait for your customised Product Kit arrive to be used during the Reset phase of the program, "
                                  "You will be give a preparatory meal protocol based on your food type",
                              borderColor: ((prepratoryMealStage == null || prepratoryMealStage!.isEmpty) && _prepratoryModel == null) ? null : (_prepratoryModel?.value?.isPrepCompleted == true) ? kBigCircleBorderGreen : kBigCircleBorderYellow,
                              onTap: (){
                            print("$prepratoryMealStage ");
                            print(((prepratoryMealStage == null || prepratoryMealStage!.isEmpty) && _prepratoryModel == null));
                                showPrepratoryMealScreen();
                              }
                          ),),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(child: customCircle(DirectionAngle.topRight.name, "04",
                              iconName: getProgramTransBorderColor("icon"),
                            headingText: "GUT RESET\nPROGRAM START",
                            subText: "You are now ready to detoxify and repair your Gut disorder. First few "
                                "day swill be challenging due to bland diet, but as you start experiencing "
                                "the benefit, you will enjoy this phase.",
                              borderColor: getProgramTransBorderColor("color"),
                              onTap: (){
                            print(programOptionStage);
                            print(transStage);
                            if(transStage != null && transStage!.isNotEmpty){
                              // showProgramScreen();
                              showTransitionMealScreen();
                            }
                            else if(programOptionStage != null && programOptionStage!.isNotEmpty){
                              print("called");
                              showProgramScreen();
                            }
                            else{
                              AppConfig().showSnackbar(context, "Can't access Locked Stage", isError: true);
                            }
                              }
                          ),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            if(consultationStage == "report_upload" || consultationStage =="consultation_rejected"){
                              if(consultationStage == "consultation_rejected"){
                                print(_gutDataModel!.rejectedCase!.historyWithMrValue!.mr!);
                                goToScreen(MedicalReportScreen(pdfLink: _gutDataModel!.rejectedCase!.historyWithMrValue!.mr!,));
                              }
                              else{
                                goToScreen(MedicalReportScreen(pdfLink: _gutDataModel!.historyWithMrValue!.mr!,));
                              }
                            }
                            else{
                              AppConfig().showSnackbar(context, "Can't access Locked Stage", isError: true);
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(newDashboardMRIcon,
                                height: 15,
                              ),
                              SizedBox(width: 5,),
                              Text("Medical Report",
                                style: TextStyle(
                                  fontSize: headingFont,
                                    fontFamily: (consultationStage == "report_upload" || consultationStage =="consultation_rejected") ? kFontMedium : kFontBook,
                                  color: (consultationStage == "report_upload" || consultationStage =="consultation_rejected") ? gsecondaryColor : gTextColor
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            print(postProgramStage == null || postProgramStage!.isEmpty);
                            print(postProgramStage!.isNotEmpty);
                            print(postProgramStage != null && (postProgramStage!.isNotEmpty && programOptionStage != ""));
                            if(postProgramStage != null && (postProgramStage!.isNotEmpty && programOptionStage != "")){
                              showPostProgramScreen();
                            }
                            else{
                              print("postProgramStage != null: ${postProgramStage != null}");
                              print("postProgramStage!.isNotEmpty: ${postProgramStage!.isNotEmpty}");
                              print("programOptionStage != "": ${programOptionStage != ""}");
                            }
                          },
                          child: Row(
                            children: [
                              Text("GMG",
                                style: TextStyle(
                                  fontSize: headingFont,
                                    fontFamily: (postProgramStage == null || postProgramStage!.isEmpty) ? kFontBook :  kFontMedium,
                                    color: (postProgramStage == null || postProgramStage!.isEmpty) ? gTextColor :  gsecondaryColor
                                ),
                              ),
                              SizedBox(width: 5,),
                              Image.asset(newDashboardGMGIcon,
                                scale: 1.2,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child: customCircle(DirectionAngle.bottomLeft.name, "02",
                              iconName: (consultationStage == null) ? null : consultationStage == "report_upload" ? newDashboardOpenIcon : newDashboardUnLockIcon,
                            headingText: "MEDICAL\nCONSULTAION",
                            subText: "Basis your Evaluation details, a video consultation is the next step for our "
                                "doctors to diagnose the root cause of you Gut Issues.",
                            borderColor:(consultationStage == null) ? null : consultationStage == "report_upload" ? kBigCircleBorderGreen : kBigCircleBorderYellow,
                            onTap: (){
                              showConsultationScreenFromStages(consultationStage);
                            }
                          ),),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(child: customCircle(DirectionAngle.bottomRight.name, "01",
                              iconName: newDashboardOpenIcon,
                            headingText: "DISORDER\nEVALUATION",
                            subText:"A Critical information needed by our doctors to understand your Medical "
                                "history, Symptoms, Sleep, Diet & Lifestyle for proper diagnosis!",
                            borderColor: kBigCircleBorderGreen,
                              onTap: () {
                              goToScreen(EvaluationGetDetails());
                            }
                          ),),
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
                    onTap: () async {
                      // getChatGroupId();
                      final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
                      final res  = await getAccessToken(uId!);
                      debugPrint(uId);
                      // debugPrint(res);

                      if(res.runtimeType != ErrorModel){
                        final accessToken = _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);

                        final chatSuccessId = _pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID);
                        // chat
                        openKaleyraChat(uId, chatSuccessId!, accessToken!);
                      }
                      else{
                        final result = res as ErrorModel;
                        print("get Access Token error: ${result.message}");
                        AppConfig().showSnackbar(context, result.message ?? '', isError: true, bottomPadding: 70);

                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/images/noun-chat-5153452.png",
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Chat Support',
                          style: TextStyle(
                            fontSize: headingFont,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  expandedView(){
    return IntrinsicHeight(
      child: Column(
        children: [
          Flexible(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(newDashboardTrackingIcon,
                      width: 25,
                      height: 25,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Tracker &\nShopping',
                      style: TextStyle(
                        fontSize: headingFont,
                      ),
                    )
                  ],
                ),
              )
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: customCircle(DirectionAngle.topLeft.name, "03", iconName: newDashboardLockIcon),),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(child: customCircle(DirectionAngle.topRight.name, "04", iconName: newDashboardLockIcon),),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(newDashboardMRIcon,
                            height: 15,
                          ),
                          SizedBox(width: 5,),
                          Text("Medical Report",
                            style: TextStyle(
                                fontSize: headingFont,
                                fontFamily: kFontBook,
                                color: gTextColor
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text("GMG",
                            style: TextStyle(
                                fontSize: headingFont,
                                fontFamily: kFontBook,
                                color: gTextColor
                            ),
                          ),
                          SizedBox(width: 5,),
                          Image.asset(newDashboardGMGIcon,
                            height: 25,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: customCircle(DirectionAngle.bottomLeft.name, "02", iconName:  newDashboardLockIcon),),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(child: customCircle(DirectionAngle.bottomRight.name, "01", iconName: newDashboardLockIcon),),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Flexible(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/noun-chat-5153452.png",
                      width: 25,
                      height: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Chat Support',
                      style: TextStyle(
                        fontSize: headingFont,
                        decoration: TextDecoration.underline,
                      ),
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }


  customCircle(String angle, String stageNo, {String? iconName,String? headingText, String? subText, Color? borderColor, VoidCallback? onTap}){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Container(
              height: 195,
              decoration: BoxDecoration(
                color: kBigCircleBg,
                borderRadius:BorderRadius.only(
                  topRight: (angle == DirectionAngle.bottomLeft.name) ? const Radius.circular(0) : const Radius.circular(80),
                  topLeft: (angle == DirectionAngle.bottomRight.name) ? const Radius.circular(0) : const Radius.circular(80),
                  bottomLeft: (angle == DirectionAngle.topRight.name) ? const Radius.circular(0) : const Radius.circular(80),
                  bottomRight: (angle == DirectionAngle.topLeft.name) ? const Radius.circular(0) : const Radius.circular(80),
                ),
                border: Border.all(
                    color: borderColor ?? gsecondaryColor,
                    width: 1
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Center(
                    child: Text(headingText ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: eUser().mainHeadingFont,
                          color: eUser().mainHeadingColor,
                          fontSize: eUser().mainHeadingFontSize
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(subText ?? '',
                        // "While you wait for your customised Product Kit arrive to be used during the Reset phase of the program, "
                        //   "You will be give a preparatory meal protocol based on your food type",
                          // " While you wait for your  customised Product Kit arrive to be used during the Reset phase of the program,",
                        style: TextStyle(
                            fontFamily: kFontBook,
                            color: eUser().mainHeadingColor,
                            fontSize: bottomSheetSubHeadingSFontSize
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: (angle == DirectionAngle.bottomRight.name || angle == DirectionAngle.topRight.name ) ? -8 : null,
            top: (angle == DirectionAngle.bottomRight.name || angle == DirectionAngle.bottomLeft.name) ? -16 : null,
            right: (angle == DirectionAngle.bottomLeft.name || angle == DirectionAngle.topLeft.name) ? -8 : null,
            bottom: (angle == DirectionAngle.topRight.name || angle == DirectionAngle.topLeft.name) ? -16 : null,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.75),
              child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (angle == DirectionAngle.bottomRight.name) ? kNumberCircleGreen :
                  (angle == DirectionAngle.bottomLeft.name) ? kNumberCircleAmber :
                  (angle == DirectionAngle.topLeft.name) ? kNumberCircleRed :
                  kNumberCirclePurple,
                ),
                child: Center(child: Text(stageNo,
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    fontSize: headingFont,
                    color: Colors.white
                  ),
                )),
              ),
            )
        ),
        Positioned(
            left: (angle == DirectionAngle.topLeft.name || angle == DirectionAngle.bottomLeft.name) ? 10 : null,
            // top: (angle == DirectionAngle.bottomRight.name || angle == DirectionAngle.bottomLeft.name) ?  : null,
            right: (angle == DirectionAngle.topRight.name || angle == DirectionAngle.bottomRight.name) ? 10 : null,
            bottom: (angle == DirectionAngle.bottomRight.name || angle == DirectionAngle.bottomLeft.name) ? 6 : null,
            child: Image.asset(
                (angle == DirectionAngle.topLeft.name) ? iconName ?? newDashboardLockIcon
                    : (angle == DirectionAngle.topRight.name) ? iconName ?? newDashboardLockIcon :
                (angle == DirectionAngle.bottomLeft.name) ? iconName ?? newDashboardLockIcon : iconName ?? newDashboardLockIcon,
              width: 30,
              height: 30,
            )
        ),
      ],
    );
  }

  bool isShown = false;

  abc(){
    Future.delayed(Duration(seconds: 0)).whenComplete(() {
      if(shippingStage == 'meal_plan_completed'){
        if(!isShown){
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
  sendApproveStatus(String status, {bool fromNull = false}) async{
    if(!isSendApproveStatus){
      setState(() {
        isSendApproveStatus = true;
        isPressed = true;
      });
      print("isPressed: $isPressed");
      final res = await ShipTrackService(repository: shipTrackRepository).sendShippingApproveStatusService(status);

      if(res.runtimeType == ShippingApproveModel){
        ShippingApproveModel model = res as ShippingApproveModel;
        print('success: ${model.message}');
        // AppConfig().showSnackbar(context, model.message!);
        getData();
      }
      else{
        ErrorModel model = res as ErrorModel;
        print('error: ${model.message}');
        AppConfig().showSnackbar(context, model.message!);
      }
      setState(() {
        isPressed = false;
      });
    }
  }
  VideoPlayerController? videoPlayerController;
  ChewieController ? _chewieController;

  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    videoPlayerController = VideoPlayerController.network(Uri.parse(url).toString());
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
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
  //
  // addUrlToVideoPlayer(String url) async{
  //   print("url"+ url);
  //   _mealPlayerController = VlcPlayerController.network(url,
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
  //   if( !await Wakelock.enabled){
  //     Wakelock.enable();
  //   }
  // }

  disposePlayer() async{
    if(_chewieController != null) _chewieController!.dispose();
    if(videoPlayerController != null) videoPlayerController!.dispose();

    // if(_mealPlayerController != null){
    //   _mealPlayerController!.dispose();
    // }
    if(await WakelockPlus.enabled){
      WakelockPlus.disable();
    }
  }

  mealReadySheet(){
    addUrlToVideoPlayerChewie(_gutShipDataModel?.stringValue ?? '');
    return AppConfig().showSheet(context,
        Column(
      children: [
        Text('Hooray!\nYour food prescription is ready',
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.4,
              fontSize: bottomSheetSubHeadingXLFontSize,
              fontFamily: bottomSheetSubHeadingBoldFont,
              color: gTextColor
          ),),
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
        Text("You've Unlocked The Next Step!",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.2,
              fontSize: bottomSheetSubHeadingXLFontSize,
              fontFamily: bottomSheetSubHeadingMediumFont,
              color: gTextColor
          ),),
        Text("The Product Kit Is Ready. Shall We Ship It For You?",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.2,
              fontSize: bottomSheetSubHeadingXLFontSize,
              fontFamily: bottomSheetSubHeadingBookFont,
              color: gTextColor
          ),),
        SizedBox(height: 5.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (isPressed) ? (){} : () {
                Navigator.pop(context);
                sendApproveStatus('yes');
                setState(() {
                  isShown = false;
                });
                disposePlayer();
                if(isMealProgressOpened){
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
              onTap: (isPressed) ? (){} : () {
                Navigator.pop(context);
                sendApproveStatus('no');
                setState(() {
                  isShown = false;
                });
                disposePlayer();
                if(isMealProgressOpened){
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
        SizedBox(height: 5.h,),
      ],
    ), bottomSheetHeight: 75.h, isDismissible: true,);
  }

  buildMealVideo() {
    if(_chewieController != null){
      return AspectRatio(
        aspectRatio: 16/9,
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
                controller: _chewieController!,
              ),
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
    }
    else {
      return SizedBox.shrink();
    }
  }


  final ShipTrackRepository shipTrackRepository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void showConsultationScreenFromStages(status) {
    print(status);
    switch(status) {
      case 'evaluation_done'  :
        goToScreen(DoctorCalenderTimeScreen());
        break;
      case 'pending' :
        goToScreen(DoctorCalenderTimeScreen());
        break;
      case 'consultation_reschedule' :
        final model = _getAppointmentDetailsModel;
        String? _doctorName;
        model!.value!.teamMember!.forEach((element) {
          if(element.user!.roleId == "2"){
            _doctorName = 'Dr. ${element.user!.name}' ?? '';
          }
        });

        // add this before calling calendertimescreen for reschedule
        // _pref!.setString(AppConfig.appointmentId , '');
        goToScreen(DoctorCalenderTimeScreen(
          isReschedule: true,
          prevBookingDate: model!.value!.appointmentDate,
          prevBookingTime: model.value!.appointmentStartTime,
          doctorDetails: model.value!.doctor,
          doctorName: _doctorName

        ));
        break;
      case 'appointment_booked':
        final model = _getAppointmentDetailsModel;
        _pref!.setString(AppConfig.appointmentId, model?.value?.id.toString() ?? '');
        goToScreen(DoctorSlotsDetailsScreen(bookingDate: model!.value!.date!,
          bookingTime: model.value!.slotStartTime!,
          dashboardValueMap: model.value!.toJson(),isFromDashboard: true,));

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
        print(_gutDataModel?.rejectedCase?.reason);
        goToScreen(ConsultationRejected(reason: _gutDataModel?.rejectedCase?.reason ?? '',));
        break;
      case 'report_upload':
        // need to show consultation completed screen, "You can now View Your Medical Report !!"
        print(_gutDataModel!.toJson());
        // goToScreen(ConsultationRejected(reason: '',));

        goToScreen(ConsultationSuccess());

        // goToScreen(DoctorSlotsDetailsScreen(bookingDate: "2023-02-21", bookingTime: "11:34:00", dashboardValueMap: {},isFromDashboard: true,));

        // goToScreen(DoctorCalenderTimeScreen(isReschedule: true,prevBookingTime: '23-09-2022', prevBookingDate: '10AM',));
        // goToScreen(MedicalReportScreen(pdfLink: _gutDataModel!.value!,));
        break;

    }
  }

  showPrepratoryMealScreen(){
    if(_prepratoryModel != null){
      print("BOOL : ${_prepratoryModel!.value!.isPrepratoryStarted}");

      // slide to program  if not started
      if(_prepratoryModel!.value!.isPrepratoryStarted == false){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProgramPlanScreen(from: ProgramMealType.prepratory.name,),
          ),
        ).then((value) => reloadUI());
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            (_prepratoryModel!.value!.isPrepCompleted!) ?
            PrepratoryMealCompletedScreen()
                : PreparatoryPlanScreen(dayNumber: _prepratoryModel!.value!.currentDay!, totalDays: _prepratoryModel!.value!.prep_days ?? ''),
            // ProgramPlanScreen(from: ProgramMealType.prepratory.name,)
          ),
        ).then((value) => reloadUI());
      }
    }
  }

  showTransitionMealScreen(){
    if(_transModel != null){
      if(_transModel!.value!.isTransMealStarted == false){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProgramPlanScreen(from: ProgramMealType.transition.name,),
          ),
        ).then((value) => reloadUI());
      }
      else{
        print(_transModel!.value!.toJson());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransitionMealPlanScreen(
                postProgramStage: postProgramStage,
              totalDays: _transModel!.value!.trans_days ?? '',
              dayNumber: _transModel?.value?.currentDay ??'',
                trackerVideoLink: _gutProgramModel!.value!.tracker_video_url
            ),
          ),
        ).then((value) => reloadUI());
      }
    }
  }

  /// when user click on meal plan if still prep not completed than
  /// in meal slide to start need to show prep form submit
  /// if already submitted than normal ui
  showProgramScreen(){
    print("func called");
    if(shippingStage == "shipping_delivered" && programOptionStage != null){
      // to slide to start the program
      _pref!.setString(AppConfig().receipeVideoUrl, _gutProgramModel!.value!.recipeVideo!);
      _pref!.setString(AppConfig().trackerVideoUrl, _gutProgramModel!.value!.tracker_video_url!);
      if(_gutProgramModel!.value!.startProgram == '0'){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProgramPlanScreen(from: ProgramMealType.detox.name, isPrepCompleted: _prepratoryModel!.value!.isPrepCompleted,),
          ),
        ).then((value) => reloadUI());
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealPlanScreen(transStage: transStage
              ,receipeVideoLink: _gutProgramModel!.value!.recipeVideo,
                trackerVideoLink: _gutProgramModel!.value!.tracker_video_url
            ),
          ),
        ).then((value) => reloadUI());
      }
    }
    else{
      AppConfig().showSnackbar(context, "program stage not getting", isError:  true);
    }
  }


  showPostProgramScreen(){
    if(postProgramStage != null){
      print(postProgramStage == "protocol_guide");
      if(postProgramStage == "post_program"){
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  DoctorCalenderTimeScreen(isPostProgram: true,)
            // PostProgramScreen(postProgramStage: postProgramStage,),
          ),
        ).then((value) => reloadUI());
      }
      else if(postProgramStage == "post_appointment_booked"){
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  DoctorSlotsDetailsScreen(
                    bookingDate: _postConsultationAppointment!.value!.date!,
                    bookingTime: _postConsultationAppointment!.value!.slotStartTime!,
                    isPostProgram: true,
                    dashboardValueMap: _postConsultationAppointment!.value!.toJson() ,)
            // PostProgramScreen(postProgramStage: postProgramStage,
            //   consultationData: _postConsultationAppointment,),
          ),
        ).then((value) => reloadUI());
      }
      else if(postProgramStage == "post_appointment_done"){
        goToScreen(const ConsultationSuccess(isPostProgramSuccess: true,));
      }
      else if(postProgramStage == "protocol_guide"){
        // goToScreen(PPLevelsScreen());
        goToScreen(PPLevelsDemo());
      }
    }
  }

  goToScreen(screenName){
    print(screenName);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screenName,
        // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
      ),
    ).then((value) {
      print(value);
      setState(() {
        getData();
      });
    });
  }

  getProgramTransBorderColor(String type) {
    print("getProgramTransBorderColor");
    if(type == "color"){
      if(transStage != null && transStage!.isNotEmpty){
        print("if color");
        if(_transModel != null && _transMealModel != null){
          return kBigCircleBorderYellow;
        }
        else if(_transModel?.value != null && _transModel?.value?.isTransMealCompleted == true){
          return kBigCircleBorderGreen;
        }
      }
      else if(programOptionStage != null && programOptionStage!.isNotEmpty){
        print("else color");
        if(_gutNormalProgramModel != null || _gutProgramModel != null){
          return kBigCircleBorderYellow;
        }
      }
      else{
        return kBigCircleBorderRed;
      }
    }
    else{
      if(transStage != null && transStage!.isNotEmpty){
        print("if border");
        if(_transModel != null && _transMealModel != null){
          return newDashboardUnLockIcon;
        }
        else if(_transModel?.value != null && _transModel?.value?.isTransMealCompleted == true){
          return newDashboardOpenIcon;
        }
      }
      else if(programOptionStage != null && programOptionStage!.isNotEmpty){
        if(_gutNormalProgramModel != null || _gutProgramModel != null){
          return newDashboardUnLockIcon;
        }
      }
      else{
        return newDashboardLockIcon;
      }
    }

  }

  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );




}
