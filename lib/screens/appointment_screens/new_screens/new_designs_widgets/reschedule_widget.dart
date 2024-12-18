import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import '../../../../model/consultation_model/appointment_booking/child_doctor_model.dart';
import '../../../../widgets/constants.dart';

class RescheduleWidget extends StatefulWidget {
  /// need to pass prevBookingDate, prevBookingTime whenever we r doing reschedule
  final String? prevBookingDate;
  final String? prevBookingTime;

  /// doctor pic, doctor details, doctor name will be used to show those details in top of the screen
  final String? doctorPic;
  final ChildDoctorModel? doctorDetails;
  final String? doctorName;

  const RescheduleWidget({
    Key? key,
    this.prevBookingDate,
    this.prevBookingTime,
    this.doctorPic,
    this.doctorDetails,
    this.doctorName,
  }) : super(key: key);

  @override
  State<RescheduleWidget> createState() => _RescheduleWidgetState();
}

class _RescheduleWidgetState extends State<RescheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildDoctorDetails(),
      ],
    );
  }

  buildDoctorDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.shortestSide > 600
                ? 15.w : 35.w,
            padding: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  gWhiteColor,
                  gsecondaryColor.withOpacity(0.5),
                ],
              ),
            ),
            child: Image(
              image: NetworkImage(
                widget.doctorPic ?? '',
              ),
              height: 22.h,
              fit: BoxFit.contain,
            ),
            // ImageNetwork(
            //   image: widget.doctorPic ?? '',
            //   height: 140,
            //   width: 140,
            //   duration: 1500,
            //   curve: Curves.easeIn,
            //   onPointer: true,
            //   debugPrint: false,
            //   fullScreen: false,
            //   fitAndroidIos: BoxFit.cover,
            //   fitWeb: BoxFitWeb.cover,
            //   borderRadius: BorderRadius.circular(70),
            //   onLoading: const CircularProgressIndicator(
            //     color: Colors.indigoAccent,
            //   ),
            //   onError: const Icon(
            //     Icons.error,
            //     color: Colors.red,
            //   ),
            //   onTap: () {
            //     debugPrint("©gabriel_patrick_souza");
            //   },
            // ),
          ),
          Container(
            width: MediaQuery.of(context).size.shortestSide > 600
                ? 25.w : 55.w,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  widget.doctorName ?? '',
                  style: TextStyle(
                    fontFamily: kFontBold,
                    color: gBlackColor,
                    fontSize: 15.dp,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  widget.doctorDetails?.specialization?.name ?? '',
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gBlackColor,
                    fontSize: 12.dp,
                  ),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// getTime will be used to split the time which is in string format to show in hour:min
  getTime() {
    if (widget.prevBookingTime != null) {
      var split = widget.prevBookingTime?.split(':');
      print("split:$split");
      String hour = split![0];
      String minute = split[1];
      return '$hour:$minute';
    }
  }
}
