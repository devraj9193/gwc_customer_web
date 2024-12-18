// ignore_for_file: deprecated_member_use

/*
roleId 1-> means its doctor
roleId 2-> means its doctor
roleId 3-> means its success

we r using WidgetsBindingObserver to observe the screen lifecycle to monitor for the
kaleyra video call

so when
Api's used->

 */
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:wakelock_plus/wakelock_plus.dart';
import '../../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../../model/consultation_model/appointment_booking/child_doctor_model.dart';
import '../../model/dashboard_model/get_appointment/child_appintment_details.dart';
import '../../model/error_model.dart';
import '../../repository/api_service.dart';
import '../../repository/chat_repository/message_repo.dart';
import '../../repository/consultation_repository/get_slots_list_repository.dart';
import '../../services/chat_service/chat_service.dart';
import '../../services/consultation_service/consultation_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import '../dashboard_screen.dart';
import '../evalution_form/evaluation_get_details.dart';
import '../medical_program_feedback_screen/medical_feedback_answer.dart';
import 'doctor_calender_time_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorSlotsDetailsScreen extends StatefulWidget {
  /// this will be called from consultation date time screen
  final AppointmentBookingModel? data;
  final ChildAppointmentDetails? appointmentUrl;
  final String bookingDate;
  final String bookingTime;

  /// this parameter will be called from dashboard screen
  final bool isFromDashboard;

  /// this parameter will be called from dashboard screen
  final Map? dashboardValueMap;

  /// this is for post program
  /// when this all other parameters will null
  final bool isPostProgram;

  const DoctorSlotsDetailsScreen(
      {Key? key,
        this.data,
        required this.bookingDate,
        required this.bookingTime,
        this.isFromDashboard = false,
        this.dashboardValueMap,
        this.isPostProgram = false, this.appointmentUrl})
      : super(key: key);

  @override
  State<DoctorSlotsDetailsScreen> createState() =>
      _DoctorSlotsDetailsScreenState();
}

class _DoctorSlotsDetailsScreenState extends State<DoctorSlotsDetailsScreen>
    with WidgetsBindingObserver {
  Timer? timer;

  final _pref = AppConfig().preferences;

  bool isJoinPressed = false;

  List<String> doctorNames = [];

  String accessToken = '';
  String kaleyraUID = "";

  /// this is used when we come from dashboard
  ChildDoctorModel? _childDoctorModel;
  String? doctorName;
  String? doctorImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initstate");
    // need to call this to get observe screen lifecycle
    WidgetsBinding.instance.addObserver(this);

    if (widget.isFromDashboard) {
      var splited = widget.bookingTime.split(':');
      int hour = int.parse(splited[0]);
      int minute = int.parse(splited[1]);
      int second = int.parse(splited[2]);
      print('$hour $minute');
    }
    if (!widget.isPostProgram && !widget.isFromDashboard) {
      widget.data?.team?.teamMember?.forEach((element) {
        if (element.user != null) {
          // roleId 2-> means its doctor
          if (element.user!.roleId == "2") {
            doctorNames.add('Dr. ${element.user!.name}' ?? '');
            doctorName = 'Dr. ${element.user!.name}';
            doctorImage = element.user?.profile ?? '';
          }
        }
      });
      if (widget.data?.kaleyraSuccessId != null) {}
      if (widget.data?.kaleyraUserId != null) {
        kaleyraUID = widget.data?.kaleyraUserId ?? '';
        getAccessToken(kaleyraUID);
      } else if (_pref!.getString(AppConfig.KALEYRA_USER_ID) != null) {
        kaleyraUID = _pref?.getString(AppConfig.KALEYRA_USER_ID) ?? '';
        getAccessToken(kaleyraUID);
      }
    }
    ChildAppointmentDetails? model;
    /*
    this is used to show the doctor name, experience, image
     */
    if (widget.isFromDashboard || widget.isPostProgram) {
      if (widget.isPostProgram) {
        if (widget.data?.team?.teamMember == null) {
          model = ChildAppointmentDetails.fromJson(
              Map.from(widget.dashboardValueMap!));
          _childDoctorModel = model.doctor;
          // print("moddd: ${model.teamPatients!.team!.toJson()}");
          model.teamMember?.forEach((element) {
            print('from appoi: ${element.toJson()}');
            if (element.user!.roleId == "2") {
              doctorNames.add('Dr. ${element.user!.name}' ?? '');
              doctorName = 'Dr. ${element.user!.name}';
              doctorImage = element.user?.profile ?? '';
            }
          });
        } else {
          widget.data?.team?.teamMember?.forEach((element) {
            if (element.user!.roleId == "2") {
              doctorNames.add('Dr. ${element.user!.name}' ?? '');
              doctorName = 'Dr. ${element.user!.name}';
              doctorImage = element.user?.profile ?? '';
            }
          });
        }
        if (widget.data?.kaleyraSuccessId != null) {}
        if (widget.data?.kaleyraUserId != null) {
          kaleyraUID = widget.data?.kaleyraUserId ?? '';
          getAccessToken(kaleyraUID);
        } else if (_pref!.getString(AppConfig.KALEYRA_USER_ID) != null) {
          kaleyraUID = _pref?.getString(AppConfig.KALEYRA_USER_ID) ?? '';
          getAccessToken(kaleyraUID);
        }
      }
      else {
        model = ChildAppointmentDetails.fromJson(
            Map.from(widget.dashboardValueMap!));
        _childDoctorModel = model.doctor;
        // print("moddd: ${model.teamPatients!.team!.toJson()}");
        model.teamMember?.forEach((element) {
          print('from appoi: ${element.toJson()}');
          if (element.user!.roleId == "2") {
            doctorNames.add('Dr. ${element.user!.name}' ?? '');
            doctorName = 'Dr. ${element.user!.name}';
            doctorImage = element.user?.profile ?? '';
          }
        });
        if (model.teamPatients?.patient?.user?.kaleyraId != null) {
          String kaleyraUID =
              model.teamPatients!.patient!.user!.kaleyraId ?? '';
          getAccessToken(kaleyraUID);
        }
      }
    }
    print("doctorName: $doctorName");
  }

  /// getAccessToken is used for to get from kaleyra
  Future getAccessToken(String kaleyraId) async {
    print("getAccessToken: $kaleyraId");
    final res = await ConsultationService(repository: _consultationRepository)
        .getAccessToken(kaleyraId);

    print(res);
    if (res.runtimeType == ErrorModel) {
      final model = res as ErrorModel;
      print("getAccessToken error: $kaleyraId ${model.message}");
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    } else {
      print("getAccessToken success: $kaleyraId");
      accessToken = res;
    }
  }

  getTime() {
    var splited = widget.bookingTime.split(':');
    print("splited:$splited");
    String hour = splited[0];
    String minute = splited[1];
    int second = int.parse(splited[2]);
    return '$hour:$minute';
  }


  @override
  void dispose() {
    // here we need to dispose the observer else app will gets lag
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar(() {
                    WakelockPlus.disable();
                    Navigator.pop(context);
                  }),
                  widget.isPostProgram
                      ?  Container(
                    height: 26.h,
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 1.w),
                    padding: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/consultation_completed.png'),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high),
                      // color: gsecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )
                      : Container(
                    height: 26.h,
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 1.w),
                    padding: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/appointment_top.png'),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high),
                      color: gsecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(
                    height: 2.h
                  ),
                  Center(
                    child: Text(
                      "Your Consultation is booked with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gTextColor,
                          fontSize: 15.dp),
                    ),
                  ),
                  SizedBox(
                    height: 1.h
                  ),
                  Center(
                    child: Text(
                      doctorNames.join(','),
                      // "Dr.Anita H,Dr.Anita J",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gTextColor,
                          fontSize: 14.dp),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Center(
                  //   child: InkWell(
                  //     onTap: () {
                  //       getChatGroupId();
                  //       // Navigator.of(context).push(
                  //       //   MaterialPageRoute(
                  //       //       builder: (context) =>
                  //       //           const DoctorCalenderTimeScreen()),
                  //       // );
                  //     },
                  //     child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Image(
                  //           image: const AssetImage(
                  //               "assets/images/noun-chat-5153452.png"),
                  //           height: 2.h,
                  //         ),
                  //         SizedBox(width: 2.w),
                  //         Text(
                  //           'Chat Support',
                  //           style: TextStyle(
                  //             decoration: TextDecoration.underline,
                  //             fontFamily: kFontMedium,
                  //             color: gTextColor,
                  //             fontSize: 10.sp,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          top: 8.h,
                          child: Container(
                            color: gsecondaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 3.h),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 13.w),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Your Appointment @ ',
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 15.sp,
                                            fontFamily: kFontBook,
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: (widget.isFromDashboard)
                                              ? getTime()
                                              : widget.bookingTime.toString(),
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 16.sp,
                                            fontFamily: kFontMedium,
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " on\n",
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 15.sp,
                                            fontFamily: kFontBook,
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: DateFormat('dd MMM yyyy')
                                              .format(DateTime.parse((widget
                                              .bookingDate
                                              .toString())))
                                              .toString(),
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 16.sp,
                                            fontFamily: kFontMedium,
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ", Has Been Confirmed",
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 15.sp,
                                            fontFamily: kFontBook,
                                            color: gWhiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // zoom join
                                Visibility(
                                  visible: true,
                                  child: Center(
                                    child: IntrinsicWidth(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isJoinPressed = true;
                                          });
                                          // ChildAppointmentDetails? model;
                                          // if (widget.isFromDashboard) {
                                          //   model =
                                          //       ChildAppointmentDetails.fromJson(
                                          //           Map.from(
                                          //               widget.dashboardValueMap!));
                                          // }
                                          print("Zoom Call");
                                          launchZoomUrl("${widget.appointmentUrl?.kaleyraJoinurl}");
                                        },
                                        child: Container(

                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.5.h, horizontal: 5.w),
                                          decoration: BoxDecoration(
                                            color: gWhiteColor,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                                color: gMainColor, width: 1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Join',
                                              style: TextStyle(
                                                fontFamily: kFontMedium,
                                                color: gMainColor,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // kaleyra join
                                // GestureDetector(
                                //   onTap: () {
                                //     var curTime = DateTime.now();
                                //     print(DateTime.now());
                                //     print(widget.bookingDate +
                                //         widget.bookingTime);
                                //     var res = DateFormat("yyyy-MM-dd HH:mm:ss")
                                //         .parse(
                                //         "${widget.bookingDate} ${widget.bookingTime}:00");
                                //
                                //     print(curTime.difference(res));
                                //     print(res.difference(curTime));
                                //     print(res.difference(curTime).inMinutes);
                                //
                                //     // if(kDebugMode){
                                //     //   ChildAppointmentDetails? model;
                                //     //   String? kaleyraurl;
                                //     //
                                //     //   if(widget.isFromDashboard || widget.isPostProgram){
                                //     //     if(widget.isPostProgram){
                                //     //       if(widget.dashboardValueMap != null){
                                //     //         model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
                                //     //         kaleyraurl = model.kaleyraJoinurl;
                                //     //       }
                                //     //       else{
                                //     //         kaleyraurl = widget.data?.kaleyraJoinurl;
                                //     //       }
                                //     //     }
                                //     //     else{
                                //     //       model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
                                //     //       kaleyraurl = model.kaleyraJoinurl;
                                //     //     }
                                //     //   }
                                //     //   else{
                                //     //     kaleyraurl = widget.data?.kaleyraJoinurl;
                                //     //   }
                                //     //   // String zoomUrl = model.;
                                //     //
                                //     //   //(widget.isFromDashboard || widget.isPostProgram) ? model?.kaleyraJoinurl : widget.data?.kaleyraJoinurl
                                //     //   print(_pref!.getString(AppConfig.KALEYRA_USER_ID));
                                //     //   kaleyraUID = _pref!.getString(AppConfig.KALEYRA_USER_ID) ?? '';
                                //     //   print("kaleyraurl:=>$kaleyraurl");
                                //     //   print('token: $accessToken');
                                //     //   print("kaleyraID: $kaleyraUID");
                                //     //   // send kaleyra id to native
                                //     //   if(kaleyraUID.isNotEmpty || kaleyraurl != null || accessToken.isNotEmpty){
                                //     //     Provider.of<ConsultationService>(context, listen: false).joinWithKaleyra(kaleyraUID, kaleyraurl!, accessToken);
                                //     //   }
                                //     //   else{
                                //     //     AppConfig().showSnackbar(context, "Uid/accessToken/join url not found");
                                //     //   }
                                //     // }
                                //     // else{
                                //     if (res.difference(curTime).inMinutes > 5 ||
                                //         res.difference(curTime).inMinutes <
                                //             -10) {
                                //       showJoinPopup();
                                //     } else {
                                //       ChildAppointmentDetails? model;
                                //       String? kaleyraurl;
                                //
                                //       if (widget.isFromDashboard ||
                                //           widget.isPostProgram) {
                                //         if (widget.isPostProgram) {
                                //           if (widget.dashboardValueMap !=
                                //               null) {
                                //             model = ChildAppointmentDetails
                                //                 .fromJson(Map.from(
                                //                 widget.dashboardValueMap!));
                                //             kaleyraurl = model.kaleyraJoinurl;
                                //           } else {
                                //             kaleyraurl =
                                //                 widget.data?.kaleyraJoinurl;
                                //           }
                                //         } else {
                                //           model = ChildAppointmentDetails
                                //               .fromJson(Map.from(
                                //               widget.dashboardValueMap!));
                                //           kaleyraurl = model.kaleyraJoinurl;
                                //         }
                                //       }
                                //       else {
                                //         kaleyraurl =
                                //             widget.data?.kaleyraJoinurl;
                                //       }
                                //       // String zoomUrl = model.;
                                //
                                //       //(widget.isFromDashboard || widget.isPostProgram) ? model?.kaleyraJoinurl : widget.data?.kaleyraJoinurl
                                //       print(_pref!.getString(
                                //           AppConfig.KALEYRA_USER_ID));
                                //       kaleyraUID = _pref!.getString(
                                //           AppConfig.KALEYRA_USER_ID) ??
                                //           '';
                                //       print("kaleyraurl:=>$kaleyraurl");
                                //       print('token: $accessToken');
                                //       print("kaleyraID: $kaleyraUID");
                                //       // send kaleyra id to native
                                //       if (kaleyraUID.isNotEmpty ||
                                //           kaleyraurl != null ||
                                //           accessToken.isNotEmpty) {
                                //
                                //         if(Platform.isIOS){
                                //           WakelockPlus.enable();
                                //           launchInBrowser(kaleyraurl);
                                //         }
                                //         else if(Platform.isAndroid){
                                //           WakelockPlus.enable();
                                //           Provider.of<ConsultationService>(
                                //               context,
                                //               listen: false)
                                //               .joinWithKaleyra(kaleyraUID,
                                //               kaleyraurl!, accessToken);
                                //         }
                                //
                                //       } else {
                                //         AppConfig().showSnackbar(context,
                                //             "Uid/accessToken/join url not found");
                                //       }
                                //     }
                                //     // }
                                //   },
                                //   child: Container(
                                //     width: 60.w,
                                //     height: 5.h,
                                //     padding: EdgeInsets.symmetric(
                                //         vertical: 1.h, horizontal: 10.w),
                                //     decoration: BoxDecoration(
                                //       color: gWhiteColor,
                                //       borderRadius: BorderRadius.circular(10),
                                //       border: Border.all(
                                //           color: gMainColor, width: 1),
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         'Join',
                                //         style: TextStyle(
                                //           fontFamily: kFontMedium,
                                //           color: gMainColor,
                                //           fontSize: 12.sp,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 4.h
                                ),
                                Visibility(
                                  // visible: !widget.isPostProgram,
                                  visible: true,
                                  child: GestureDetector(
                                    onTap: () {
                                      print(_childDoctorModel);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorCalenderTimeScreen(
                                                  isPostProgram:
                                                  widget.isPostProgram,
                                                  isReschedule: true,
                                                  prevBookingDate:
                                                  widget.bookingDate,
                                                  prevBookingTime:
                                                  widget.bookingTime,
                                                  doctorName: doctorName,
                                                  doctorPic: doctorImage,
                                                  doctorDetails: (widget
                                                      .isFromDashboard ||
                                                      widget.isPostProgram)
                                                      ? _childDoctorModel
                                                      : widget.data!.doctor,
                                                )),
                                      );
                                    },
                                    child: Text(
                                      'Reschedule',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontFamily: kFontMedium,
                                        color: gWhiteColor,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10.w,
                          right: 10.w,
                          child: widget.isPostProgram
                              ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) =>
                                      const MedicalFeedbackAnswer()));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: gWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(8, 10),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image(
                                    image: const AssetImage(
                                        "assets/images/Group 3776.png"),
                                    height: 10.h,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      "Medical Feedback",
                                      style: TextStyle(
                                          fontFamily: kFontMedium,
                                          color: gTextColor,
                                          fontSize: 15.sp),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: gMainColor,
                                    size: 3.h,
                                  )
                                ],
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              getEvaluationReport();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: gWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(8, 10),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image(
                                    image: const AssetImage(
                                        "assets/images/Group 3776.png"),
                                    height: 8.h,
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(
                                    child: Text(
                                      "My Evaluation",
                                      style: TextStyle(
                                          fontFamily: kFontMedium,
                                          color: gTextColor,
                                          fontSize: 15.dp),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: gMainColor,
                                    size: 3.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// this used for kaleyra video
  /// when call ends w r going back
  /// we r using ConsultationService to monitor the call events
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState");
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        if (Provider.of<ConsultationService>(context, listen: false)
            .callEvent == "onCallEnded") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardScreen(index: 2,),
              ),
                  (route) => route.isFirst);
        }
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  /// this popup we r showing when user will click on join before scheduled time
  showJoinPopup() {
    return AppConfig().showSheet(
      context,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You're early to the appointment! \nPlease join 5 minutes before the scheduled time for a successful admission.",
              style: TextStyle(
                  fontFamily: kFontMedium,
                  fontSize: 10.5.sp,
                  height: 1.3,
                  color: gTextColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 1.h,
            ),
            MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.75),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pop(context);
                },
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding:
                  EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: eUser().buttonColor,
                    borderRadius:
                    BorderRadius.circular(eUser().buttonBorderRadius),
                    // border: Border.all(
                    //     color: eUser().buttonBorderColor,
                    //     width: eUser().buttonBorderWidth
                    // ),
                  ),
                  child: Center(
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                        fontFamily: eUser().buttonTextFont,
                        color: eUser().buttonTextColor,
                        fontSize: eUser().buttonTextSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheetHeight: 45.h,
      isDismissible: true,
    );
  }

  void getEvaluationReport() {
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => EvaluationGetDetails()));
  }

  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final ConsultationRepository _consultationRepository = ConsultationRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );


  // we r not using zoom
  void launchZoomUrl(String zoomUrl) async {
    // if (kDebugMode) {
    //   print(widget.data?.patientName);
    //   print(widget.isPostProgram);
    // }
    // ChildAppointmentDetails? model;
    // if (widget.isFromDashboard || widget.isPostProgram) {
    //   if (widget.dashboardValueMap != null)
    //     model = ChildAppointmentDetails.fromJson(
    //         Map.from(widget.dashboardValueMap!));
    // }
    // String zoomUrl = model.;

    // String? zoomUrl = (widget.isFromDashboard || widget.isPostProgram)
    //     ? model?.zoomJoinUrl
    //     : widget.data?.zoomJoinUrl;

    print("zoomURL: ${zoomUrl}");

    print("model: ${widget.appointmentUrl?.zoomJoinUrl}");

    if (await canLaunchUrl(Uri.parse(zoomUrl ?? '')))
      await launch(zoomUrl ?? '');
    else
      // can't launch url, there is some error
      throw "Could not launch ${zoomUrl}";
  }

  /// THIS IS FOR IOS MOBILE
  Future launchInBrowser(String? kaleyraurl) async{
    if (await canLaunchUrl(Uri.parse(kaleyraurl ?? ''))) {
      await launch(kaleyraurl ?? '');
    } else
      // can't launch url, there is some error
      throw "Could not launch ${kaleyraurl}";
  }


}
