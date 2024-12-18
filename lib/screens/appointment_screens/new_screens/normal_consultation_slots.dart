import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/dart_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../../../model/consultation_model/ppc_slots_model.dart';
import '../../../model/error_model.dart';
import '../../../model/shift_slots_model/unique_slots_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/consultation_repository/get_slots_list_repository.dart';
import '../../../repository/shift_slots_repo/shift_slots_repo.dart';
import '../../../services/consultation_service/consultation_service.dart';
import '../../../services/shift_slots_service/shift_slots_service.dart';
import '../../../utils/app_config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/button_widget.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../../dashboard_screen.dart';

class NormalConsultationSlots extends StatefulWidget {
  /// this is used when we r doing Reschedule consultation
  final bool isReschedule;
  const NormalConsultationSlots({
    this.isReschedule = false,
    Key? key,
  }) : super(key: key);

  @override
  State<NormalConsultationSlots> createState() =>
      _NormalConsultationSlotsState();
}

class _NormalConsultationSlotsState extends State<NormalConsultationSlots> {
  /// this is for slot selection
  String isSelected = "";

  /// we r showing the start date from next day
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String slotErrorText = AppConfig.slotErrorText;
  String selectedTimeSlotFullName = "";
  bool isLoading = false;
  String selectedSlotsDoctorId = "";
  bool showBookingProgress = false;
  final SharedPreferences _pref = AppConfig().preferences!;

  @override
  void initState() {
    super.initState();
    getSlotsList(selectedDate);
  }

  List<UniqueSlot> newConsultationSlotList = [];
  List<MatchedPpcSlot>? ppcNewSlotList = [];

  getSlotsList(DateTime selectedDate) async {
    setState(() {
      isLoading = true;
    });
    if (widget.isReschedule) {
      print("appointment_id : ${_pref.getString(AppConfig.appointmentId)}");
    }
    final res = await (() =>
        ShiftSlotsService(repository: repo).getConsultationSlotsService(
          DateFormat('yyyy-MM-dd').format(selectedDate),
        )).withRetries(3);
    print("getSlotList" + res.runtimeType.toString());

    if (res.runtimeType == UniqueSlotsModel) {
      UniqueSlotsModel result = res;
      setState(() {
        for (var e in result.uniqueSlots) {
          if (e.isShow != 0) {
            newConsultationSlotList.add(e);
            print("slotsElement : ${newConsultationSlotList.length}");
          }
        }
        // newConsultationSlotList = result.uniqueSlots!;
        isLoading = false;
        if (newConsultationSlotList.isEmpty) {
          slotErrorText = AppConfig.slotErrorText;
        }
      });
    } else {
      ErrorModel result = res;
      newConsultationSlotList.clear();
      setState(() {
        isLoading = false;
        if (result.message!.toLowerCase().contains("no doctor")) {
          slotErrorText = result.message!;
        } else if (result.message!.toLowerCase().contains("unauthenticated")) {
          slotErrorText = AppConfig.oopsMessage;
        } else {
          slotErrorText = AppConfig.slotErrorText;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return mainView();
  }

  mainView() {
    return Center(
      child: Padding(
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
            buildNewChooseDay(),
            // buildChooseDay(),
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
                  : (newConsultationSlotList.isEmpty)
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
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5.h, bottom: 2.h),
                child: ButtonWidget(
                  onPressed: (isSelected.isEmpty || showBookingProgress)
                      ? () {
                          AppConfig()
                              .showSnackbar(context, 'Please select time');
                        }
                      : () {
                          buildConfirm(
                              DateFormat('yyyy-MM-dd').format(selectedDate),
                              selectedTimeSlotFullName);
                        },
                  text: 'BOOK',
                  isLoading: showBookingProgress,
                  buttonWidth: 20.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildNewChooseDay() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h, top: 1.h),
      child: EasyInfiniteDateTimeLine(
        locale: "en_IN",
        firstDate: DateTime.now().add(
          const Duration(days: 1),
        ),
        focusDate: selectedDate,
        lastDate: DateTime(2100, 12, 31),
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
            isLoading = true;
            isSelected = "";
          });
          newConsultationSlotList.clear();
          ppcNewSlotList?.clear();
          getSlotsList(selectedDate);
        },
        // headerProps: const EasyHeaderProps(
        //   monthPickerType: MonthPickerType.switcher,
        //   dateFormatter: DateFormatter.fullDateDMY(),
        // ),
        dayProps: EasyDayProps(
          dayStructure: DayStructure.dayStrDayNum,
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  gsecondaryColor.withOpacity(0.3),
                  gsecondaryColor.withOpacity(0.5),
                ],
              ),
            ),
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
        .bookAppointmentService(
      date,
      slotTime,
      selectedSlotsDoctorId,
      appointmentId: (widget.isReschedule) ? appointmentId : null,
    );
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
                builder: (context) => const DashboardScreen(index: 2),
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

  final ShiftSlotsRepository repo = ShiftSlotsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
