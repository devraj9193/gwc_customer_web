import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/dart_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../../../model/consultation_model/child_slots_model.dart';
import '../../../model/consultation_model/ppc_slots_model.dart';
import '../../../model/error_model.dart';
import '../../../model/shift_slots_model/unique_slots_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/consultation_repository/get_slots_list_repository.dart';
import '../../../services/consultation_service/consultation_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../../dashboard_screen.dart';

class PpcConsultationSlots extends StatefulWidget {
  /// this is used when we r doing Reschedule consultation
  final bool isReschedule;

  final String? nourishStartedDate;
  final String? nourishTotalDays;

  const PpcConsultationSlots({
    this.isReschedule = false,
    this.nourishStartedDate,
    this.nourishTotalDays,
    Key? key,
  }) : super(key: key);

  @override
  State<PpcConsultationSlots> createState() => _PpcConsultationSlotsState();
}

class _PpcConsultationSlotsState extends State<PpcConsultationSlots> {
  DatePickerController dateController = DatePickerController();

  final SharedPreferences _pref = AppConfig().preferences!;

  /// this is for slot selection
  String isSelected = "";
  String selectedTimeSlotFullName = "";

  Map<String, ChildSlotModel>? slotList = {};

  /// we r showing the start date from next day
  DateTime? selectedDate;
  String selectedSlotsDoctorId = "";
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
    print("PPC nourishStartedDate : ${widget.nourishStartedDate}");
    print("PPC nourishTotalDays : ${widget.nourishTotalDays}");

    if (widget.nourishStartedDate != "null") {
      nourishDate =
          DateFormat("dd-MM-yyyy").parse("${widget.nourishStartedDate}");}
    else{
      nourishDate= DateTime.now();
    }
      nourishCalcDate = nourishDate
          .add(Duration(days: int.parse("${widget.nourishTotalDays}")));

    print("PPC nourishTotalDays : $nourishCalcDate");

    DateTime chkShowDate = nourishCalcDate.subtract(const Duration(days: 1));

    print("PPC nourishTotalDays : $chkShowDate");

    if (checkIfSunday(chkShowDate)) {
      showDate = chkShowDate.add(const Duration(days: 1));
    } else {
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
    print("PPC Status : ${checkIfPastDate(showDate)}");

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

  @override
  Widget build(BuildContext context) {
    return mainView();
  }

  mainView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
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
          SizedBox(
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
          ),
          SizedBox(
            height: 6.h,
          ),
          Center(
            child: ButtonWidget(
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
              text: 'BOOK',
              isLoading: showBookingProgress,
              buttonWidth: 20.w,
            ),
          )
        ],
      ),
    );
  }

  buildChooseDay() {
    print("isReschedule chk : $showDate");
    print("isReschedule chk : ${DateTime.now().isAfter(showDate)}");
    return Container(
      // padding: const EdgeInsets.all(5),
      // margin: EdgeInsets.symmetric(vertical: 2.h),
      // decoration: BoxDecoration(
      //   color: kWhiteColor,
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: eUser().buttonBorderColor, width: 1),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       blurRadius: 1,
      //     ),
      //   ],
      // ),
      child: (checkIfPastDate(showDate))
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    child: slotsDate(date));
              }).toList(),
            )
          : slotsDate(showDate),
      // DatePicker(
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

  slotsDate(DateTime date) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: selectedDate == date
              ? [
                  gsecondaryColor.withOpacity(0.3),
                  gsecondaryColor.withOpacity(0.5),
                ]
              : [
                  gGreyColor.withOpacity(0.1),
                  gGreyColor.withOpacity(0.1),
                ],
        ),
        border: Border.all(
            color: gGreyColor.withOpacity(0.3),
            width: selectedDate == date ? 0 : 1),
        // color: selectedDate == date
        //     ? gsecondaryColor
        //     : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
      padding: EdgeInsets.symmetric(
          vertical: 2.h,
          horizontal:
              MediaQuery.of(context).size.shortestSide > 600 ? 2.w : 4.w),
      child: Column(
        children: [
          Text(
            DateFormat("MMM").format(date),
            style: TextStyle(
              fontFamily: kFontMedium,
              color: selectedDate == date ? gWhiteColor : gBlackColor,
              fontSize: 12.dp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            DateFormat("dd").format(date),
            style: TextStyle(
              fontFamily: kFontBold,
              color: selectedDate == date ? gWhiteColor : gBlackColor,
              fontSize: 15.dp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            DateFormat('EEEE').format(date).substring(0, 3),
            style: TextStyle(
              fontFamily: kFontBook,
              color: selectedDate == date ? gWhiteColor : gBlackColor,
              fontSize: 12.dp,
            ),
          ),
        ],
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
                selectedTimeSlotFullName = model.slot;
                selectedSlotsDoctorId = model.userId.toString();
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

  bookAppointment(String date, String slotTime, {String? appointmentId}) async {
    setState(() {
      showBookingProgress = true;
    });
    final res = await ConsultationService(repository: repository)
        .bookAppointmentService(date, slotTime, selectedSlotsDoctorId,
            appointmentId: (widget.isReschedule) ? appointmentId : null,
            isPostprogram: true);
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

  final ConsultationRepository repository = ConsultationRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
