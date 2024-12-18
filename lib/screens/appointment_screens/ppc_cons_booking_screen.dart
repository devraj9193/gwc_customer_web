/*
Api used: -
to get slots
var getAppointmentSlotsListUrl = "${AppConfig().BASE_URL}/api/getData/slots/";

submit selected slots
var bookAppointmentUrl = "${AppConfig().BASE_URL}/api/getData/book";
 we need to pass ->
 date, slotTime,
 if reschedule we need to pass appointmentId,
 if isPostprogram  we need to pass isPostProgram which we get from constructor


 */

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_customer_web/screens/dashboard_screen.dart';
import 'package:gwc_customer_web/widgets/dart_extensions.dart';
import 'package:image_network/image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../../model/consultation_model/appointment_booking/child_doctor_model.dart';
import '../../model/consultation_model/appointment_slot_model.dart';
import '../../model/consultation_model/child_slots_model.dart';
import '../../model/consultation_model/ppc_slots_model.dart';
import '../../model/error_model.dart';
import '../../model/shift_slots_model/unique_slots_model.dart';
import '../../repository/api_service.dart';
import '../../repository/consultation_repository/get_slots_list_repository.dart';
import '../../repository/shift_slots_repo/shift_slots_repo.dart';
import '../../repository/user_slot_for_schedule_repository/schedule_slot_repository.dart';
import '../../services/consultation_service/consultation_service.dart';
import '../../services/user_slot_for_schedule_service/user_slot_for_schedule_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;

class PpcConsBookingScreen extends StatefulWidget {
  final String? nourishStartedDate;
  final String? nourishTotalDays;

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

  const PpcConsBookingScreen({
    Key? key,
    this.nourishStartedDate,
    this.nourishTotalDays,
    this.isReschedule = false,
    this.prevBookingDate,
    this.prevBookingTime,
    this.doctorDetails,
    this.doctorPic,
    this.doctorName,
    this.isPostProgram = false,
  }) : super(key: key);

  @override
  State<PpcConsBookingScreen> createState() => _PpcConsBookingScreenState();
}

class _PpcConsBookingScreenState extends State<PpcConsBookingScreen> {
  DatePickerController dateController = DatePickerController();
  final pageController = PageController();
  double rating = 5.0;

  final SharedPreferences _pref = AppConfig().preferences!;

  /// this is for slot selection
  String isSelected = "";
  String selectedTimeSlotFullName = "";

  Map<String, ChildSlotModel>? slotList = {};

  /// we r showing the start date from next day
  DateTime? selectedDate;

  DateTime showDate = DateTime.now();
  DateTime nourishDate = DateTime.now();
  DateTime nourishCalcDate = DateTime.now();

  bool isLoading = false;
  bool showBookingProgress = false;
  String slotErrorText = AppConfig.slotErrorText;

  final List<DateTime> specificDates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
  ];

  @override
  void initState() {
    super.initState();
    print("PPSlot : ${widget.isPostProgram}");
    print("PPC nourishStartedDate : ${widget.nourishStartedDate}");
    print("PPC nourishTotalDays : ${widget.nourishTotalDays}");

    nourishDate =
        DateFormat("dd-MM-yyyy").parse("${widget.nourishStartedDate}");
    nourishCalcDate = nourishDate
        .add(Duration(days: int.parse("${widget.nourishTotalDays}")));
    DateTime chkShowDate = nourishCalcDate.subtract(const Duration(days: 1));

    if(checkIfSunday(chkShowDate)){
      showDate = chkShowDate.add(Duration(days: 1));
    }else {
      showDate = chkShowDate;
    }

    print("PPC Show Date : $showDate");

    selectedDate = specificDates[0];

    print("checkIfSunday : ${checkIfSunday(showDate)}");
    print("checkIfPastDate : ${checkIfPastDate(showDate)}");
    getSlotsList(selectedDate!);
  }

  List<UniqueSlot> newConsultationSlotList = [];
  List<MatchedPpcSlot>? ppcNewSlotList = [];

  bool checkIfSunday(DateTime date) {
    if (date.weekday == DateTime.sunday) {
      print('It\'s a Sunday!');
      return true;
    } else {
      print('It\'s not a Sunday.');
      return false;
    }
  }

  bool checkIfPastDate(DateTime selectedDate) {
    DateTime today = DateTime.now();
    if (selectedDate.isBefore(today)) {
      print('The selected date is in the past.');
      return true;
    } else {
      print('The selected date is not in the past.');
      return false;
    }
  }

  getSlotsList(DateTime selectDate) async {
      if (checkIfPastDate(showDate)) {
        print("PPC Date : $selectedDate");

        setState(() {
          isLoading = true;
        });

        final res = await (() => ConsultationService(repository: repository)
                .getPpcAppointmentSlotListService(
              DateFormat('yyyy-MM-dd').format(selectDate),
              _pref.getString(AppConfig.userDoctorId).toString() ?? '',
            )).withRetries(3);

        print("getPPSlotList" + res.runtimeType.toString());

        if (res.runtimeType == PpcSlotsModel) {
          PpcSlotsModel result = res;
          setState(() {
            ppcNewSlotList = result.matchedPpcSlots;
            isLoading = false;
            if (ppcNewSlotList!.isEmpty) {
              slotErrorText = AppConfig.slotErrorText;
            }
          });
        } else {
          ErrorModel result = res;
          ppcNewSlotList!.clear();
          // AppConfig().showSnackbar(context, result.message ?? '', isError: true);
          setState(() {
            isLoading = false;
            if (result.message!.toLowerCase().contains("no doctor")) {
              slotErrorText = result.message!;
            } else if (result.message!
                .toLowerCase()
                .contains("unauthenticated")) {
              slotErrorText = AppConfig.oopsMessage;
            } else {
              slotErrorText = AppConfig.slotErrorText;
            }
          });
        }
      } else {
        print("PPC Date : $showDate");

        setState(() {
          isLoading = true;
        });

        selectedDate = showDate;

        print("getPPShowSlotList" + selectedDate.toString());

        final res = await (() => ConsultationService(repository: repository)
                .getPpcAppointmentSlotListService(
              DateFormat('yyyy-MM-dd').format(selectedDate!),
              _pref.getString(AppConfig.userDoctorId).toString() ?? '',
            )).withRetries(3);

        print("getPPSlotList" + res.runtimeType.toString());

        if (res.runtimeType == PpcSlotsModel) {
          PpcSlotsModel result = res;
          setState(() {
            ppcNewSlotList = result.matchedPpcSlots;
            isLoading = false;
            if (ppcNewSlotList!.isEmpty) {
              slotErrorText = AppConfig.slotErrorText;
            }
          });
        } else {
          ErrorModel result = res;
          ppcNewSlotList!.clear();
          // AppConfig().showSnackbar(context, result.message ?? '', isError: true);
          setState(() {
            isLoading = false;
            if (result.message!.toLowerCase().contains("no doctor")) {
              slotErrorText = result.message!;
            } else if (result.message!
                .toLowerCase()
                .contains("unauthenticated")) {
              slotErrorText = AppConfig.oopsMessage;
            } else {
              slotErrorText = AppConfig.slotErrorText;
            }
          });
        }
      }

  }

  /// getTime will be used to split the time which is in string format to show in hour:min
  getTime() {
    print("isReschedule" + widget.isReschedule.toString());
    if (widget.prevBookingTime != null) {
      var splited = widget.prevBookingTime?.split(':');
      print("splited:$splited");
      String hour = splited![0];
      String minute = splited[1];
      return '$hour:$minute';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 1.8.w, right: 1.w, top: 1.h),
                  child: buildAppBar(() {
                    Navigator.pop(context);
                  })),
              Padding(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w),
                  child: _mainView())
            ],
          ),
        ),
      ),
    );
  }

  _mainView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        (!widget.isReschedule) ? buildDoctor() : buildDoctorExpList(),
        SizedBox(height: 1.h),
        SizedBox(
          height: 2.h,
        ),
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
        Visibility(
          visible: widget.isReschedule,
          child: SizedBox(
            height: 3.h,
          ),
        ),
        Text(
          "Choose Your Preferred Day",
          style: TextStyle(
              fontFamily: kFontBold,
              color: eUser().mainHeadingColor,
              fontSize: 15.dp),
        ),
        buildChooseDay(),
        SizedBox(
          height: 1.h,
        ),
        Text(
          "Choose Your Preferred Time",
          style: TextStyle(
              fontFamily: kFontBold,
              color: eUser().mainHeadingColor,
              fontSize: 15.dp),
        ),
        SizedBox(height: 2.h),
        widget.isPostProgram
            ? SizedBox(
                width: double.infinity,
                child: (isLoading)
                    ? Center(
                        child: buildCircularIndicator(),
                      )
                    : (ppcNewSlotList!.isEmpty)
                        ? Center(
                            child: Text(
                              slotErrorText,
                              style: TextStyle(
                                  fontFamily: kFontBold,
                                  color: gHintTextColor,
                                  fontSize: 13.dp),
                            ),
                          )
                        : Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 20,
                            spacing: 20,
                            children: [
                              // ...list.map((e) => buildChooseTime(e)).toList(),
                              ...ppcNewSlotList!
                                  .map((e) => buildPpcNewChooseTime(e))
                                  .toList()
                            ],
                          ),
              )
            : SizedBox(
                width: double.infinity,
                child: (isLoading)
                    ? Center(
                        child: buildCircularIndicator(),
                      )
                    : (newConsultationSlotList!.isEmpty)
                        ? Center(
                            child: Text(
                              slotErrorText,
                              style: TextStyle(
                                  fontFamily: kFontBold,
                                  color: gHintTextColor,
                                  fontSize: 13.dp),
                            ),
                          )
                        : Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 20,
                            spacing: 20,
                            children: [
                              // ...list.map((e) => buildChooseTime(e)).toList(),
                              ...newConsultationSlotList
                                  .map((e) => buildNewConsultationChooseTime(e))
                                  .toList()
                            ],
                          ),
              ),
        SizedBox(
          height: 6.h,
        ),
        Center(
          child:  ButtonWidget(
            onPressed: (isSelected.isEmpty || showBookingProgress)
                ? () {
              AppConfig().showSnackbar(context, 'Please select time');
            }
                : () {
              print("selectedDate : $selectedDate");
              buildConfirm(
                  DateFormat('yyyy-MM-dd').format(selectedDate!),
                  selectedTimeSlotFullName);
            },
            text: 'Next',
            isLoading: showBookingProgress,
            buttonWidth: 20.w,
          ),
          // IntrinsicWidth(
          //   child: GestureDetector(
          //     onTap: (isSelected.isEmpty || showBookingProgress)
          //         ? () {
          //             AppConfig().showSnackbar(context, 'Please select time');
          //           }
          //         : () {
          //             print("selectedDate : $selectedDate");
          //             buildConfirm(
          //                 DateFormat('yyyy-MM-dd').format(selectedDate!),
          //                 selectedTimeSlotFullName);
          //           },
          //     child: Container(
          //       padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
          //       decoration: BoxDecoration(
          //         color: eUser().buttonColor,
          //         borderRadius:
          //             BorderRadius.circular(eUser().buttonBorderRadius),
          //         // border: Border.all(
          //         //     color: eUser().buttonBorderColor,
          //         //     width: eUser().buttonBorderWidth
          //         // ),
          //       ),
          //       child: (showBookingProgress)
          //           ? buildThreeBounceIndicator(
          //               color: eUser().threeBounceIndicatorColor)
          //           : Center(
          //               child: Text(
          //                 'Next',
          //                 style: TextStyle(
          //                   fontFamily: eUser().buttonTextFont,
          //                   color: eUser().buttonTextColor,
          //                   fontSize: eUser().buttonTextSize,
          //                 ),
          //               ),
          //             ),
          //     ),
          //   ),
          // ),
        )
      ],
    );
  }

  buildDoctor() {
    return Column(
      children: [
        SizedBox(
          height: 35.h,
          child: PageView(
            controller: pageController,
            children: [
              buildFeedbackList("assets/images/cons1.jpg"),
              buildFeedbackList("assets/images/cons2.jpg"),
              buildFeedbackList("assets/images/cons3.jpg"),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SmoothPageIndicator(
          controller: pageController,
          count: 3,
          axisDirection: Axis.horizontal,
          effect: JumpingDotEffect(
            dotColor: Colors.amberAccent,
            activeDotColor: gsecondaryColor,
            // dotHeight: 0.8.h,
            // dotWidth: 1.7.w,
            jumpScale: 2,
          ),
        ),
      ],
    );
  }

  buildDoctorExpList() {
    return Center(
      child: IntrinsicWidth(
        child: buildDoctorList(),
      ),
    );
  }

  buildFeedbackList(String assetName) {
    return Center(
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
          decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: gsecondaryColor, width: 2)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
                image: AssetImage(assetName),
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high),
          ),
        ),
      ),
    );
    Container(
      // width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(assetName),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high),
        color: gsecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget buildRating() {
    return SmoothStarRating(
      color: Colors.white,
      borderColor: Colors.white,
      rating: rating,
      size: 1.5.h,
      filledIconData: Icons.star_sharp,
      halfFilledIconData: Icons.star_half_sharp,
      defaultIconData: Icons.star_outline_sharp,
      starCount: 5,
      allowHalfRating: true,
      spacing: 2.0,
    );
  }

  buildDoctorList() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: gsecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ImageNetwork(
            image: widget.doctorPic ?? '',
            height: 140,
            width: 140,
            duration: 1500,
            curve: Curves.easeIn,
            onPointer: true,
            debugPrint: false,
            fullScreen: false,
            fitAndroidIos: BoxFit.cover,
            fitWeb: BoxFitWeb.cover,
            borderRadius: BorderRadius.circular(70),
            onLoading: const CircularProgressIndicator(
              color: Colors.indigoAccent,
            ),
            onError: const Icon(
              Icons.error,
              color: Colors.red,
            ),
            onTap: () {
              debugPrint("©gabriel_patrick_souza");
            },
          ),
          // Container(
          //   width: 16.h,
          //   height: 16.h,
          //   decoration: BoxDecoration(
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.3),
          //           blurRadius: 20,
          //           offset: const Offset(2, 10),
          //         ),
          //       ],
          //       borderRadius: BorderRadius.circular(6),
          //       image: DecorationImage(
          //           image: NetworkImage(widget.doctorPic ?? '')
          //           // image: AssetImage("assets/images/doctor_placeholder.png")
          //           )),
          // ),
          SizedBox(width: 1.5.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doctorName ?? '',
                style: TextStyle(
                    fontFamily: kFontBold, color: gWhiteColor, fontSize: 15.dp),
              ),
              SizedBox(height: 1.5.h),
              // Text(
              //   "${widget.doctorDetails?.experience ?? ''}Yr Experience" ?? '',
              //   style: TextStyle(
              //       fontFamily: kFontMedium,
              //       color: gWhiteColor,
              //       fontSize: 14.dp),
              // ),
              // SizedBox(height: 1.5.h),
              Text(
                widget.doctorDetails?.specialization?.name ?? '',
                style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 12.dp),
              ),
              SizedBox(height: 1.5.h),
              //buildRating(),
            ],
          ),
        ],
      ),
    );
  }

  buildDoctorDetails(String title, String subTitle, String image) {
    return Container(
      width: 25.w,
      height: 12.h,
      padding: EdgeInsets.only(top: 2.h, left: 3.w, right: 3.w),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gPrimaryColor.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(image),
          SizedBox(height: 1.5.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: kFontBook,
              color: gPrimaryColor,
              fontSize: 9.dp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            subTitle,
            style: TextStyle(
              fontFamily: kFontMedium,
              color: gPrimaryColor,
              fontSize: 9.dp,
            ),
          ),
        ],
      ),
    );
  }

  buildChooseDay() {
    print("isReschedule chk : $showDate");
    print("isReschedule chk : ${DateTime.now().isAfter(showDate)}");
    return Container(
      padding: const EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: eUser().buttonBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
          ),
        ],
      ),
      child: (checkIfPastDate(showDate))
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: specificDates.map((date) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                          isLoading = true;
                          isSelected = "";
                        });
                        print("selectedDate : $selectedDate == $date");
                        newConsultationSlotList.clear();
                        ppcNewSlotList?.clear();
                        getSlotsList(selectedDate!);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedDate == date
                              ? gsecondaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 4.w),
                        child: Column(
                          children: [
                            Text(
                              DateFormat("MMM").format(date),
                              style: TextStyle(
                                fontFamily: kFontMedium,
                                color: selectedDate == date
                                    ? gWhiteColor
                                    : gBlackColor,
                                fontSize: 12.dp,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              DateFormat("dd").format(date),
                              style: TextStyle(
                                fontFamily: kFontBold,
                                color: selectedDate == date
                                    ? gWhiteColor
                                    : gBlackColor,
                                fontSize: 15.dp,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              DateFormat('EEEE').format(date).substring(0, 3),
                              style: TextStyle(
                                fontFamily: kFontBook,
                                color: selectedDate == date
                                    ? gWhiteColor
                                    : gBlackColor,
                                fontSize: 12.dp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              : DatePicker(
                  showDate,
                  controller: dateController,
                  daysCount: 1,
                  // height: 10.h,
                  // width: 14.w,
                  monthTextStyle: TextStyle(fontSize: 13.dp),
                  dateTextStyle: TextStyle(
                      fontFamily: kFontBold,
                      fontSize: 13.dp,
                      color: eUser().mainHeadingColor),
                  dayTextStyle: TextStyle(
                      fontFamily: kFontBook,
                      fontSize: 8.dp,
                      color: eUser().mainHeadingColor),
                  initialSelectedDate: showDate,
                  selectionColor: gsecondaryColor,
                  selectedTextColor: gWhiteColor,
                  onDateChange: (date) {
                    setState(() {
                      selectedDate = date;
                      isLoading = true;
                      isSelected = "";
                    });
                    newConsultationSlotList.clear();
                    ppcNewSlotList?.clear();
                    getSlotsList(selectedDate!);
                  },
                )
          // Row(
          //         children: specificDates.map((date) {
          //           return Container(
          //             width: 13.w,
          //             height: 12.h,
          //             decoration: BoxDecoration(
          //               color: selectedDate == date ? gsecondaryColor : gWhiteColor,
          //               borderRadius: BorderRadius.circular(5),
          //             ),
          //             child: DatePicker(
          //               date,
          //               controller: dateController,
          //               daysCount: 1,
          //               // height: 10.h,
          //               // width: 14.w,
          //               monthTextStyle: TextStyle(fontSize: 13.dp),
          //               dateTextStyle: TextStyle(
          //                   fontFamily: kFontBold,
          //                   fontSize: 13.dp,
          //                   color: eUser().mainHeadingColor),
          //               dayTextStyle: TextStyle(
          //                   fontFamily: kFontBook,
          //                   fontSize: 8.dp,
          //                   color: eUser().mainHeadingColor),
          //               initialSelectedDate: selectedDate == date ? date : null,
          //               selectionColor: Colors.transparent,  // Transparent to handle our custom colors
          //               selectedTextColor: selectedDate == date ? gWhiteColor : gBlackColor,
          //               onDateChange: (date) {
          //                 setState(() {
          //                   selectedDate = date;
          //                   isLoading = true;
          //                   isSelected = "";
          //                 });
          //                 newConsultationSlotList.clear();
          //                 ppcNewSlotList?.clear();
          //                 getSlotsList(selectedDate!);
          //               },
          //             ),
          //           );
          //         }).toList(),
          //       )
      //     : (DateTime.now().isAfter(showDate))
      //     ? Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: specificDates.map((date) {
      //     return GestureDetector(
      //       onTap: () {
      //         setState(() {
      //           selectedDate = date;
      //           isLoading = true;
      //           isSelected = "";
      //         });
      //         print("selectedDate : $selectedDate == $date");
      //         newConsultationSlotList.clear();
      //         ppcNewSlotList?.clear();
      //         getSlotsList(selectedDate!);
      //       },
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: selectedDate == date
      //               ? gsecondaryColor
      //               : Colors.grey[300],
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //         margin: const EdgeInsets.symmetric(horizontal: 10),
      //         padding: EdgeInsets.symmetric(
      //             vertical: 1.h, horizontal: 4.w),
      //         child: Column(
      //           children: [
      //             Text(
      //               DateFormat("MMM").format(date),
      //               style: TextStyle(
      //                 fontFamily: kFontMedium,
      //                 color: selectedDate == date
      //                     ? gWhiteColor
      //                     : gBlackColor,
      //                 fontSize: 12.dp,
      //               ),
      //             ),
      //             SizedBox(height: 0.5.h),
      //             Text(
      //               DateFormat("dd").format(date),
      //               style: TextStyle(
      //                 fontFamily: kFontBold,
      //                 color: selectedDate == date
      //                     ? gWhiteColor
      //                     : gBlackColor,
      //                 fontSize: 15.dp,
      //               ),
      //             ),
      //             SizedBox(height: 0.5.h),
      //             Text(
      //               DateFormat('EEEE').format(date).substring(0, 3),
      //               style: TextStyle(
      //                 fontFamily: kFontBook,
      //                 color: selectedDate == date
      //                     ? gWhiteColor
      //                     : gBlackColor,
      //                 fontSize: 12.dp,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   }).toList(),
      // )
      //     : DatePicker(
      //         showDate,
      //         controller: dateController,
      //         daysCount: 1,
      //         // height: 10.h,
      //         // width: 14.w,
      //         monthTextStyle: TextStyle(fontSize: 13.dp),
      //         dateTextStyle: TextStyle(
      //             fontFamily: kFontBold,
      //             fontSize: 13.dp,
      //             color: eUser().mainHeadingColor),
      //         dayTextStyle: TextStyle(
      //             fontFamily: kFontBook,
      //             fontSize: 8.dp,
      //             color: eUser().mainHeadingColor),
      //         initialSelectedDate: showDate,
      //         selectionColor: gsecondaryColor,
      //         selectedTextColor: gWhiteColor,
      //         onDateChange: (date) {
      //           setState(() {
      //             selectedDate = date;
      //             isLoading = true;
      //             isSelected = "";
      //           });
      //           newConsultationSlotList.clear();
      //           ppcNewSlotList?.clear();
      //           getSlotsList(selectedDate!);
      //         },
      //       ),
    );
  }

  String selectedSlotsDoctorId = "";

  Widget buildChooseTime(ChildSlotModel model) {
    String slotName = model.slot!.substring(0, 5);

    print("slotTime : $slotName");

    int slotTime = int.parse(slotName.split(":").first);

    int todayTime = int.parse(DateFormat('HH').format(DateTime.now()));

    String selectedTodayDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    print("today Time : $selectedTodayDate == $todayDate");

    return selectedTodayDate == todayDate
        ? slotTime > todayTime
            ? GestureDetector(
                onTap: model.isBooked == '1'
                    ? null
                    : () {
                        setState(() {
                          isSelected = slotName;
                          selectedTimeSlotFullName = model.slot ?? '';
                        });
                      },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: eUser().buttonBorderColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    color: (model.isBooked == '0' && isSelected != slotName)
                        ? gWhiteColor
                        : model.isBooked == '1'
                            ? gsecondaryColor
                            : gPrimaryColor,
                    boxShadow: (model.isBooked == '0' && isSelected != slotName)
                        ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 1,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(2, 10),
                            ),
                          ],
                  ),
                  child: Text(
                    slotName,
                    style: TextStyle(
                      fontSize: 13.dp,
                      fontFamily: kFontBook,
                      color: (model.isBooked != '0' || isSelected == slotName)
                          ? gWhiteColor
                          : gTextColor,
                    ),
                  ),
                ),
              )
            : const SizedBox()
        : GestureDetector(
            onTap: model.isBooked == '1'
                ? null
                : () {
                    setState(() {
                      isSelected = slotName;
                      selectedTimeSlotFullName = model.slot ?? '';
                    });
                  },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                border: Border.all(color: eUser().buttonBorderColor, width: 1),
                borderRadius: BorderRadius.circular(8),
                color: (model.isBooked == '0' && isSelected != slotName)
                    ? gWhiteColor
                    : model.isBooked == '1'
                        ? gsecondaryColor
                        : gPrimaryColor,
                boxShadow: (model.isBooked == '0' && isSelected != slotName)
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 1,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(2, 10),
                        ),
                      ],
              ),
              child: Text(
                slotName,
                style: TextStyle(
                  fontSize: 13.dp,
                  fontFamily: kFontBook,
                  color: (model.isBooked != '0' || isSelected == slotName)
                      ? gWhiteColor
                      : gTextColor,
                ),
              ),
            ),
          );
  }

  Widget buildNewConsultationChooseTime(UniqueSlot model) {
    String slotName = model.slot.substring(0, 5);
    return GestureDetector(
      onTap: model.isBooked == 1
          ? null
          : () {
              setState(() {
                isSelected = slotName;
                selectedTimeSlotFullName = model.slot ?? '';
                selectedSlotsDoctorId = model.userId.toString() ?? '';
              });
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          border: Border.all(color: eUser().buttonBorderColor, width: 1),
          borderRadius: BorderRadius.circular(8),
          color: (model.isBooked == 0 && isSelected != slotName)
              ? gWhiteColor
              : model.isBooked == 1
                  ? gsecondaryColor
                  : gPrimaryColor,
          boxShadow: (model.isBooked == 0 && isSelected != slotName)
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(2, 10),
                  ),
                ],
        ),
        child: Text(
          slotName,
          style: TextStyle(
            fontSize: 13.dp,
            fontFamily: kFontBook,
            color: (model.isBooked != 0 || isSelected == slotName)
                ? gWhiteColor
                : gTextColor,
          ),
        ),
      ),
    );
  }

  Widget buildPpcNewChooseTime(MatchedPpcSlot model) {
    String slotName = model.slot.substring(0, 5);
    return GestureDetector(
      onTap: model.isBooked == 1
          ? null
          : () {
              setState(() {
                isSelected = slotName;
                selectedTimeSlotFullName = model.slot ?? '';
                selectedSlotsDoctorId = model.userId.toString() ?? '';
              });
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          border: Border.all(color: eUser().buttonBorderColor, width: 1),
          borderRadius: BorderRadius.circular(8),
          color: (model.isBooked == 0 && isSelected != slotName)
              ? gWhiteColor
              : model.isBooked == 1
                  ? gsecondaryColor
                  : gPrimaryColor,
          boxShadow: (model.isBooked == 0 && isSelected != slotName)
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(2, 10),
                  ),
                ],
        ),
        child: Text(
          slotName,
          style: TextStyle(
            fontSize: 13.dp,
            fontFamily: kFontBook,
            color: (model.isBooked != 0 || isSelected == slotName)
                ? gWhiteColor
                : gTextColor,
          ),
        ),
      ),
    );
  }

  void buildConfirm(String slotDate, String slotTime) {
    String? appointmentId;
    if (widget.isReschedule) {
      appointmentId = _pref.getString(AppConfig.appointmentId);
    }
    bookAppointment(slotDate, slotTime, appointmentId: appointmentId);
  }

  final ConsultationRepository repository = ConsultationRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final ShiftSlotsRepository repo = ShiftSlotsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final ScheduleSlotsRepository ppRepository = ScheduleSlotsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bookAppointment(String date, String slotTime, {String? appointmentId}) async {
    setState(() {
      showBookingProgress = true;
    });
    print(widget.isPostProgram);
    final res = await ConsultationService(repository: repository)
        .bookAppointmentService(date, slotTime, selectedSlotsDoctorId,
            appointmentId: (widget.isReschedule) ? appointmentId : null,
            isPostprogram: widget.isPostProgram);
    print("bookAppointment : " + res.runtimeType.toString());
    if (res.runtimeType == AppointmentBookingModel) {
      if (widget.isReschedule) {
        _pref.remove(AppConfig.appointmentId);
      }
      AppointmentBookingModel result = res;
      print("result.zoomJoinUrl: ${result.zoomJoinUrl}");
      print(result.toJson());
      setState(() {
        showBookingProgress = false;
      });
      _pref.setString(AppConfig.appointmentId, result.appointmentId ?? '');
      _pref.setString(
          AppConfig.KALEYRA_SUCCESS_ID, result.kaleyraSuccessId ?? '');

      print("Appointment Id : ${_pref.getString(AppConfig.appointmentId)}");

      // _pref.setString(AppConfig.doctorId, result.doctorId ?? '');

      AppConfig().showSnackbar(context, result.data ?? '', isError: false);
      Navigator.of(context)
          .pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => DashboardScreen(index: 2),
                //     DoctorSlotsDetailsScreen(
                //   bookingDate: date,
                //   bookingTime: isSelected,
                //   data: result,
                //   isPostProgram: widget.isPostProgram,
                // ),
              ),
              (route) => route.isFirst)
          .then((value) {
        setState(() {});
      });
    } else {
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        showBookingProgress = false;
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }
}

/*
  buildDoctorExpList() {
    return Column(
      children: [
        SizedBox(
          height: 18.h,
          child: PageView(
            controller: pageController,
            children: [
              buildDoctorList(),
              buildDoctorList(),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: 2,
          axisDirection: Axis.horizontal,
          effect: JumpingDotEffect(
            dotColor: Colors.amberAccent,
            activeDotColor: gsecondaryColor,
            dotHeight: 0.8.h,
            dotWidth: 1.7.w,
            jumpScale: 2,
          ),
        ),
      ],
    );
  }

 */
