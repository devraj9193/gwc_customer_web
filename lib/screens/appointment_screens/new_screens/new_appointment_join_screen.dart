import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/button_widget.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:intl/intl.dart';
import '../../../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../../../model/consultation_model/appointment_booking/child_doctor_model.dart';
import '../../../model/dashboard_model/get_appointment/child_appintment_details.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../model/error_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/consultation_repository/get_slots_list_repository.dart';
import '../../../services/consultation_service/consultation_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/widgets.dart';
import '../../medical_program_feedback_screen/medical_feedback_answer.dart';
import '../../new_profile_screens/get_evaluation_screen/get_evaluation_screen.dart';
import 'new_appointment_screen.dart';

class NewAppointmentJoinScreen extends StatefulWidget {
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
  const NewAppointmentJoinScreen({
    Key? key,
    this.data,
    required this.bookingDate,
    required this.bookingTime,
    this.isFromDashboard = false,
    this.dashboardValueMap,
    this.isPostProgram = false,
    this.appointmentUrl,
  }) : super(key: key);

  @override
  State<NewAppointmentJoinScreen> createState() =>
      _NewAppointmentJoinScreenState();
}

class _NewAppointmentJoinScreenState extends State<NewAppointmentJoinScreen>
    with WidgetsBindingObserver {
  final _pref = AppConfig().preferences;

  /// this is used when we come from dashboard
  ChildDoctorModel? childDoctorModel;

  List<String> doctorNames = [];
  String? doctorName;
  String? doctorImage;

  String accessToken = '';
  String kaleyraUID = "";
  bool isJoinPressed = false;

  @override
  void initState() {
    super.initState();
    print("initState");
    WidgetsBinding.instance.addObserver(this);

    if (widget.isFromDashboard) {
      var split = widget.bookingTime.split(':');
      int hour = int.parse(split[0]);
      int minute = int.parse(split[1]);
      print('$hour $minute');
    }
    if (!widget.isPostProgram && !widget.isFromDashboard) {
      widget.data?.team?.teamMember?.forEach((element) {
        if (element.user != null) {
          if (element.user!.roleId == "2") {
            doctorNames.add('Dr. ${element.user!.name}');
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
          childDoctorModel = model.doctor;
          model.teamMember?.forEach((element) {
            print('from app: ${element.toJson()}');
            if (element.user!.roleId == "2") {
              doctorNames.add('Dr. ${element.user!.name}');
              doctorName = 'Dr. ${element.user!.name}';
              doctorImage = element.user?.profile ?? '';
            }
          });
        } else {
          widget.data?.team?.teamMember?.forEach((element) {
            if (element.user!.roleId == "2") {
              doctorNames.add('Dr. ${element.user!.name}');
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
      } else {
        model = ChildAppointmentDetails.fromJson(
            Map.from(widget.dashboardValueMap!));
        childDoctorModel = model.doctor;
        model.teamMember?.forEach((element) {
          print('from app: ${element.toJson()}');
          if (element.user!.roleId == "2") {
            doctorNames.add('Dr. ${element.user!.name}');
            doctorName = 'Dr. ${element.user!.name}';
            doctorImage = element.user?.profile ?? '';
          }
        });
        if (model.teamPatients?.patient?.user?.kaleyraId != null) {
          String kaleUID = model.teamPatients!.patient!.user!.kaleyraId ?? '';
          getAccessToken(kaleUID);
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
    print("split Dashboard :${widget.bookingTime}");
    var split = widget.bookingTime.split(':');
    print("split:$split");
    String hour = split[0];
    String minute = split[1];
    // int second = int.parse(split[2]);
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gsecondaryColor.withOpacity(0.5),
                gsecondaryColor.withOpacity(0.5),
                gsecondaryColor.withOpacity(0.5),
                gWhiteColor,
                gWhiteColor,
                gWhiteColor,
                gWhiteColor,
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.w, top: 1.h, bottom: 3.h),
                child: buildAppBar(() {
                  Navigator.pop(context);
                }),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Image(
                          image: NetworkImage(doctorImage ?? ''),
                          height: 20.h,
                        ),
                      ),
                      // widget.isPostProgram
                      //     ? Container(
                      //         height: 26.h,
                      //         width: double.maxFinite,
                      //         margin: EdgeInsets.symmetric(
                      //             vertical: 1.h, horizontal: 1.w),
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: 1.h, horizontal: 3.w),
                      //         decoration: BoxDecoration(
                      //           image: const DecorationImage(
                      //               image: AssetImage(
                      //                   'assets/images/consultation_completed.png'),
                      //               fit: BoxFit.contain,
                      //               filterQuality: FilterQuality.high),
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //       )
                      //     : Container(
                      //         height: 26.h,
                      //         width: double.maxFinite,
                      //         margin: EdgeInsets.symmetric(
                      //             vertical: 1.h, horizontal: 1.w),
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: 1.h, horizontal: 3.w),
                      //         decoration: BoxDecoration(
                      //           image: const DecorationImage(
                      //               image: AssetImage(
                      //                   'assets/images/appointment_top.png'),
                      //               fit: BoxFit.contain,
                      //               filterQuality: FilterQuality.high),
                      //           color: gsecondaryColor,
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //       ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w,vertical: 3.h),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Your Consultation is booked with\n',
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 15.dp,
                                  fontFamily: kFontBook,
                                  color: gWhiteColor,
                                ),
                              ),
                              TextSpan(
                                text: doctorNames.join(','),
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 16.dp,
                                  fontFamily: kFontMedium,
                                  color: gWhiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      widget.isPostProgram
                          ? buildCenterButtonWidget(
                              'Medical Feedback',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) =>
                                        const MedicalFeedbackAnswer(),
                                  ),
                                );
                              },
                            )
                          : buildCenterButtonWidget(
                              'My Evaluation',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) => const GetEvaluationScreen(),
                                  ),
                                );
                              },
                            ),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Your Appointment @ ',
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 15.dp,
                                  fontFamily: kFontBook,
                                  color: gBlackColor,
                                ),
                              ),
                              TextSpan(
                                text: (widget.isFromDashboard)
                                    ? getTime()
                                    : widget.bookingTime.toString(),
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 16.dp,
                                  fontFamily: kFontMedium,
                                  color: gBlackColor,
                                ),
                              ),
                              TextSpan(
                                text: " on\n",
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 15.dp,
                                  fontFamily: kFontBook,
                                  color: gBlackColor,
                                ),
                              ),
                              TextSpan(
                                text: DateFormat('dd MMM yyyy')
                                    .format(DateTime.parse(
                                        (widget.bookingDate.toString())))
                                    .toString(),
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 16.dp,
                                  fontFamily: kFontMedium,
                                  color: gBlackColor,
                                ),
                              ),
                              TextSpan(
                                text: ", Has Been Confirmed",
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 15.dp,
                                  fontFamily: kFontBook,
                                  color: gBlackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: ButtonWidget(
                          onPressed: () {
                            setState(() {
                              isJoinPressed = true;
                            });
                            print("Zoom Call");
                            launchZoomUrl(
                                "${widget.appointmentUrl?.kaleyraJoinurl}");
                          },
                          text: 'Join',
                          isLoading: false,
                          radius: 10,
                          buttonWidth: 25.w,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap: () {
                          print(childDoctorModel);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NewAppointmentScreen(
                                isPostProgram: widget.isPostProgram,
                                isReschedule: true,
                                prevBookingDate: widget.bookingDate,
                                prevBookingTime: widget.bookingTime,
                                doctorName: doctorName,
                                doctorPic: doctorImage,
                                doctorDetails: (widget.isFromDashboard ||
                                        widget.isPostProgram)
                                    ? childDoctorModel
                                    : widget.data!.doctor,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Reschedule',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                            fontSize: 15.dp,
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
      ),
    );
  }

  buildCenterButtonWidget(String title, func) {
    return Center(
      child: GestureDetector(
        onTap: func,
        child: Container(
          width: MediaQuery.of(context).size.shortestSide > 600 ? 35.w : 55.w,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 20,
                // offset: const Offset(12, 10),
              ),
            ],
          ),
          child: Center(
            child: Row(
              children: [
                Image(
                  image: const AssetImage('assets/images/Group 3776.png'),
                  height: 8.h,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    title,
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
    );
  }

  void launchZoomUrl(String zoomUrl) async {
    print("zoomURL: $zoomUrl");

    print("model: ${widget.appointmentUrl?.zoomJoinUrl}");

    if (await canLaunchUrl(Uri.parse(zoomUrl ?? ''))) {
      await launch(zoomUrl ?? '');
    } else {
      throw "Could not launch $zoomUrl";
    }
  }

  final ConsultationRepository _consultationRepository = ConsultationRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
