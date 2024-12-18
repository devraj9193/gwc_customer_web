import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/appointment_screens/new_screens/ppc_consultation_slots.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:intl/intl.dart';
import '../../../model/consultation_model/appointment_booking/child_doctor_model.dart';
import 'new_designs_widgets/reschedule_widget.dart';
import 'new_designs_widgets/slider_widget.dart';
import 'normal_consultation_slots.dart';

class NewAppointmentScreen extends StatefulWidget {
  /// this is used when we r doing Reschedule consultation
  final bool isReschedule;

  /// need to pass prevBookingDate, prevBookingTime whenever we r doing reschedule
  final String? prevBookingDate;
  final String? prevBookingTime;

  /// doctor pic, doctor details, doctor name will be used to show those details in top of the screen
  final String? doctorPic;
  final ChildDoctorModel? doctorDetails;
  final String? doctorName;

  /// this is for post program
  /// when this all other parameters will null
  final bool isPostProgram;

  final String? nourishStartedDate;
  final String? nourishTotalDays;

  const NewAppointmentScreen({
    Key? key,
    this.isReschedule = false,
    this.prevBookingDate,
    this.prevBookingTime,
    this.doctorPic,
    this.doctorDetails,
    this.doctorName,
    this.isPostProgram = false,
    this.nourishStartedDate,
    this.nourishTotalDays,
  }) : super(key: key);

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gsecondaryColor.withOpacity(0.5),
              gWhiteColor,
              gWhiteColor,
            ],
          ),
        ),
        child: MediaQuery.of(context).size.shortestSide > 600
            ? buildWebView()
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3.w, top: 1.h),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: gWhiteColor, shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: gBlackColor,
                              size: 2.h,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat("MMM dd, yyyy").format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 15.dp,
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.shortestSide > 600
                          ? 45.w
                          : double.maxFinite,
                      child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              expandedHeight: 40.h,
                              elevation: 0,
                              automaticallyImplyLeading: false,
                              surfaceTintColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              floating: false,
                              pinned: true,
                              flexibleSpace: FlexibleSpaceBar(
                                background: Center(
                                  child: Column(
                                    children: [
                                      widget.isReschedule
                                          ? RescheduleWidget(
                                              prevBookingTime:
                                                  widget.prevBookingTime,
                                              prevBookingDate:
                                                  widget.prevBookingDate,
                                              doctorDetails:
                                                  widget.doctorDetails,
                                              doctorName: widget.doctorName,
                                              doctorPic: widget.doctorPic,
                                            )
                                          : const SliderWidget(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              Visibility(
                                visible: widget.isReschedule,
                                child: SizedBox(height: 1.5.h),
                              ),
                              Visibility(
                                visible: widget.isReschedule,
                                child: Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              'Your Previous Appointment was Booked ',
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 15.dp,
                                            fontFamily: kFontBook,
                                            color: gBlackColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: (widget.prevBookingDate != null)
                                              ? '@ ${getTime()}  ${DateFormat('dd MMM yyyy').format(DateTime.parse((widget.prevBookingDate.toString()))).toString()}'
                                              : '',
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 13.dp,
                                            fontFamily: kFontMedium,
                                            color: gsecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              widget.isPostProgram
                                  ? PpcConsultationSlots(
                                      isReschedule: widget.isReschedule,
                                      nourishStartedDate:
                                          widget.nourishStartedDate,
                                      nourishTotalDays: widget.nourishTotalDays,
                                    )
                                  : NormalConsultationSlots(
                                      isReschedule: widget.isReschedule,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  getTime() {
    print("isReschedule" + widget.isReschedule.toString());
    if (widget.prevBookingTime != null) {
      var split = widget.prevBookingTime?.split(':');
      print("split:$split");
      String hour = split![0];
      String minute = split[1];
      return '$hour:$minute';
    }
  }

  buildWebView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.5.w),
            padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 2.h),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: gWhiteColor, shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: gBlackColor,
                          size: 2.h,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      DateFormat("MMM dd, yyyy").format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 15.dp,
                        fontFamily: kFontMedium,
                        color: gBlackColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                const SliderWidget(
                  isWeb: true,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 1.5.h),
                  widget.isReschedule
                      ? RescheduleWidget(
                          prevBookingTime: widget.prevBookingTime,
                          prevBookingDate: widget.prevBookingDate,
                          doctorDetails: widget.doctorDetails,
                          doctorName: widget.doctorName,
                          doctorPic: widget.doctorPic,
                        )
                      : const SizedBox(),
                  Visibility(
                    visible: widget.isReschedule,
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Your Previous Appointment was Booked ',
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 15.dp,
                                fontFamily: kFontBook,
                                color: gBlackColor,
                              ),
                            ),
                            TextSpan(
                              text: (widget.prevBookingDate != null)
                                  ? '@ ${getTime()}  ${DateFormat('dd MMM yyyy').format(DateTime.parse((widget.prevBookingDate.toString()))).toString()}'
                                  : '',
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 13.dp,
                                fontFamily: kFontMedium,
                                color: gsecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.isPostProgram
                      ? PpcConsultationSlots(
                          isReschedule: widget.isReschedule,
                          nourishStartedDate: widget.nourishStartedDate,
                          nourishTotalDays: widget.nourishTotalDays,
                        )
                      : NormalConsultationSlots(
                          isReschedule: widget.isReschedule,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
