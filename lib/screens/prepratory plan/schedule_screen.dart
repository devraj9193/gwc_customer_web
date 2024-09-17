/*
Follow Up calls:

Api's used:

Get SlotsDates Api which showing in list
var getUserSlotDaysForScheduleUrl = "${AppConfig().BASE_URL}/api/getData/user_slot_days";

Get Slots Api which calling in dialog
var getFollowUpSlotUrl = "${AppConfig().BASE_URL}/api/getData/followup_slots/";

Submit selected slot api
var submitSlotSelectedUrl = "${AppConfig().BASE_URL}/api/submitForm/follow_up_book";

 */

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import '../../model/consultation_model/appointment_slot_model.dart';
import '../../model/consultation_model/child_slots_model.dart';
import '../../model/consultation_model/follow_up_slot_model.dart';
import '../../model/error_model.dart';
import '../../model/shift_slots_model/shift_slots_model.dart';
import '../../model/success_message_model.dart';
import '../../model/user_slot_for_schedule_model/user_slot_days_schedule_model.dart';
import '../../repository/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../repository/shift_slots_repo/shift_slots_repo.dart';
import '../../repository/user_slot_for_schedule_repository/schedule_slot_repository.dart';
import '../../services/shift_slots_service/shift_slots_service.dart';
import '../../services/user_slot_for_schedule_service/user_slot_for_schedule_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class NewScheduleScreen extends StatefulWidget {
  const NewScheduleScreen({Key? key}) : super(key: key);

  @override
  State<NewScheduleScreen> createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {
  Future? getSlotDaysListFuture, slotFuture;
  final _pref = AppConfig().preferences;

  bool isLoading = false;

  List<ChildSlotModel> followUpSlots = [];
  final ScheduleSlotsRepository repository = ScheduleSlotsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  List<Slot> followUpShiftSlots = [];
  final ShiftSlotsRepository repo = ShiftSlotsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSlotDates();
  }

  getSlotDates() {
    getSlotDaysListFuture =
        GetUserScheduleSlotsForService(repository: repository)
            .getSlotsDaysForScheduleService();
  }

  late final ShiftSlotsService shiftSlotsService =
      ShiftSlotsService(repository: repo);

  List<Slot> shiftSlots = [];
  // List<SlotElement> slots = [];

  getSlotFuture(String date) async {
    setState(() {
      isLoading = true;
    });

    print("date : $date");

    DateTime d = DateFormat("dd-MM-yyyy").parse(date);

    print("DateTime : $d");

    String dat = DateFormat('yyyy-MM-dd').format(d);

    print("Selected DateTime : $dat");

    final result = await shiftSlotsService
        .getShiftSlotsService(
      dat,
      "followup_slots",
      _pref?.getString(AppConfig.userDoctorId).toString() ?? '',
    )
        .then((value) {
      print("result: $value");

      if (value.runtimeType == ShiftSlotsModel) {
        setState(() {
          isLoading = false;
        });

        print("Shift Slots List");
        ShiftSlotsModel model = value as ShiftSlotsModel;

        // for (var e in model.getAllDoctors.followupSlots.slots) {
        //   print("doctor user id : ${e}");
        //   print(
        //       "dashboard doctor user id : ${_pref?.getString(AppConfig.userDoctorId)}");
        //
        //   if (e.userId.toString() == _pref?.getString(AppConfig.userDoctorId).toString()) {
        //     shiftSlots.add(e);
        //     print("shiftSlots : $shiftSlots");
        //   }
        // }
        //
        // for (var ele in shiftSlots) {
        //   for (var e in ele.slots) {
        //
        //     slots.add(e);
        //     print("slotss : ${slots[0].slot}");
        //   }
        // }
        // setState(() {
        //   isLoading = false;
        // });
      } else {
        ErrorModel model = value as ErrorModel;
        setState(() {
          isLoading = false;
        });
        print("error: ${model.message}");
      }

      print(value);
    });
  }

  // getSlotFuture(String date) {
  //   return ShiftSlotsService(repository: repo).getShiftSlotsService(date);
  //
  //   // return GetUserScheduleSlotsForService(repository: repository)
  //   //     .getFollowUpSlotsScheduleService(date);
  // }

  String errorMsg = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildAppBar(() {
              Navigator.pop(context);
            }),
            Expanded(
                child: FutureBuilder(
                    future: getSlotDaysListFuture,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.runtimeType == ErrorModel) {
                          final res = snapshot.data as ErrorModel;
                          print(res);
                          return Center(
                            child: Text(res.message.toString() ?? ''),
                          );
                        } else {
                          final res =
                              snapshot.data as GetUserSlotDaysForScheduleModel;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: res.data?.length ?? 0,
                              itemBuilder: (_, index) {
                                return slotListTile(
                                    res.data![index].slot ?? '',
                                    // "Your ${index+1}${getDayOfMonthSuffix(index+1)} Follow Up Call , Please book your timings",
                                    (
                                            // res.data?[index].booked == false ||
                                            //     getIsSlotCompleted(
                                            //             res.data?[index].date ??
                                            //                 '') ==
                                            //         true ||
                                            res.data?[index].slot == null ||
                                                res.data?[index].slot == "")
                                        ? "Book your ${index + 1}${getDayOfMonthSuffix(index + 1)} follow-up call"
                                        : "Slot booked ${getTime("${res.data?[index].date}", "${res.data?[index].slot}")}",
                                    // "Your doctor will give you a call at this time",
                                    res.data?[index].date ?? '',
                                    res.data?[index].callStatus ?? '',
                                    isSlotBooked:
                                        res.data?[index].booked ?? false,
                                    isDayCompleted: getIsSlotCompleted(
                                        res.data?[index].date ?? ''));
                              });
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString() ?? ''),
                        );
                      }
                      return Center(
                        child: buildCircularIndicator(),
                      );
                    }))
          ],
        ),
      ),
    ));
  }

  topBar() {
    return Row(
      children: [Icon(Icons.arrow_back_ios), Text("Your Slot Dates.")],
    );
  }

  final today = DateTime.now();

  getIsSlotCompleted(String date) {
    print(
        "days: ${today.difference(DateFormat('dd-MM-yyyy').parse(date)).inDays}");
    if (today.difference(DateFormat('dd-MM-yyyy').parse(date)).inDays > 0) {
      return true;
    } else {
      return false;
    }
  }

  slotListTile(
      String slotTime, String middleText, String date, String callStatus,
      {bool isSlotBooked = false, bool isDayCompleted = false}) {
    print("slot time : $slotTime");
    // print(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(slotTime)));

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_month),
                        Text(
                          date,
                          style: TextStyle(
                            fontFamily: kFontBold,
                            color: gBlackColor,
                            fontSize: 13.dp,
                          ),
                        ),
                      ],
                    ),
                    slotTime.isEmpty || slotTime == null
                        ? GestureDetector(
                            onTap: () async {
                              if (!isDayCompleted) {
                                if (!isSlotBooked) {
                                  if (date.isEmpty) {
                                    AppConfig().showSnackbar(
                                        context, "date getting empty",
                                        isError: true);
                                  } else {
                                    showScheduleDialog(date);
                                    getSlotFuture(date);
                                  }
                                } else {
                                  AppConfig().showSnackbar(
                                      context, "Slot Booked Already",
                                      isError: true);
                                }
                              }
                            },
                            child: (isDayCompleted)
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: gPrimaryColor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Icon(
                                            Icons.done_outlined,
                                            color: gWhiteColor,
                                            size: 8.dp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        // "Day ${widget.day} Meal Plan",
                                        "Completed",
                                        style: TextStyle(
                                            fontFamily: kFontBook,
                                            color: gTextColor,
                                            fontSize: 13.dp),
                                      )
                                    ],
                                  )
                                : Text(
                                    (isSlotBooked)
                                        ? "Already Booked"
                                        : "Schedule",
                                    style: TextStyle(
                                      fontFamily: kFontBook,
                                      color: gsecondaryColor,
                                      fontSize: 13.dp,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                          )
                        : Text(
                            DateFormat.jm()
                                .format(DateFormat("hh:mm:ss").parse(slotTime)),
                            style: TextStyle(
                              fontFamily: kFontBold,
                              color: gBlackColor,
                              fontSize: 13.dp,
                            ),
                          ),
                  ],
                ),
                // if(slotTime.isNotEmpty)
                //   SizedBox(
                //   height: 10,
                //   ),
                // if(slotTime.isNotEmpty)
                //   Text("Booked Slot: $slotTime",
                //   style: TextStyle(
                //     fontFamily:
                //     kFontMedium,
                //     color: gTextColor,
                //     fontSize: 10.dp,
                //   ),
                // ),
                SizedBox(height: 1.h),
                Text(
                  middleText,
                  style: TextStyle(
                    fontFamily: kFontBook,
                    color: gTextColor,
                    fontSize: 12.dp,
                  ),
                ),
                const SizedBox(height: 5),
                callStatus == "0"
                    ? Text(
                        "Follow up unsuccessful, doctor will reschedule.",
                        style: TextStyle(
                          fontFamily: kFontBold,
                          color: gsecondaryColor,
                          fontSize: 12.dp,
                        ),
                      )
                    : callStatus == "1"
                        ? Row(
                            children: [
                              Text(
                                "Follow up call complete.",
                                style: TextStyle(
                                  fontFamily: kFontBold,
                                  color: gPrimaryColor,
                                  fontSize: 12.dp,
                                ),
                              ),
                              SizedBox(width: 0.w),
                              Icon(
                                Icons.check_circle,
                                color: gPrimaryColor,
                                size: 2.h,
                              )
                            ],
                          )
                        : const SizedBox(),
                const SizedBox(height: 8),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  /// getTime will be used to split the time which is in string format to show in hour:min
  getTime(String date, String time) {
    DateTime tempDate =
        new DateFormat("dd-MM-yyyy hh:mm:ss").parse("$date $time");

    print("DateTime : $tempDate");

    return '${DateFormat('dd MMM yyyy').format(tempDate).toString()} at ${DateFormat.jm().format(DateFormat("hh:mm:ss").parse(time))}';
  }

  List morningSlotList = [
    "08:30AM",
    "09:00AM",
    "09:30AM",
    "10:00AM",
    "10:30AM",
    "11:00AM"
  ];
  String selectedMorningSlot = "";
  List eveningSlotList = [
    "05:30AM",
    "06:00AM",
    "06:30AM",
    "07:00AM",
    "07:30AM",
    "08:00AM"
  ];
  String selectedEveningSlot = "";

  List followUpSlotsList = [];
  String selectedSlot = "";
  String blockedSlot = "";
  String selectedDate = "";

  showScheduleDialog(String date) async {
    return await showDialog(
        context: context,
        builder: (_ctx) {
          return StatefulBuilder(builder: (_, setState) {
            return showCustomDialog(setState, date);
          });
        }).then((value) {
      selectedSlot = "";
    });
  }

  bool showSubmitProgress = false;

  var submitProgressState;

  showCustomDialog(Function setState, String date) {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date1 = inputFormat.parse(date);
    submitProgressState = setState;
    var outputFormat = DateFormat('yyyy-MM-dd');
    var date2 = outputFormat.format(date1);
    print(date2);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      // contentPadding: EdgeInsets.only(top: 10.0, bottom: 8),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          // height: 50.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 6,
              ),
              Text(
                'Please Select Slot',
                style: TextStyle(fontFamily: kFontMedium, fontSize: 15.dp),
              ),
              Divider(),
              isLoading
                  ? buildCircularIndicator()
                  : Center(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: [
                          // ...followUpSlots.map(
                          //   (e) => e.isBooked == 1 ? const SizedBox() : slotChip(
                          //     e.slot,
                          //     '',
                          //     isSelected: selectedSlot.contains(e.slot),
                          //     setstate: setState,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              // Spacer(),
              (showSubmitProgress)
                  ? Center(child: buildCircularIndicator())
                  : Center(
                      child: IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () {
                            submitFollowupSlots(date2, selectedSlot);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: eUser().buttonColor,
                              borderRadius: BorderRadius.circular(
                                  eUser().buttonBorderRadius),
                              // border: Border.all(color: eUser().buttonBorderColor,
                              //     width: eUser().buttonBorderWidth),
                            ),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: kFontBold,
                                  color: gWhiteColor,
                                  fontSize: 13.dp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  slotView(String slotName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(
        slotName,
        style: TextStyle(fontFamily: kFontBold, fontSize: 12.dp),
      ),
    );
  }

  slotChip(String time, String slotName,
      {bool isSelected = false, Function? setstate}) {
    return GestureDetector(
      onTap: () {
        setstate!(() {
          selectedSlot = time;
          // start = selectedSlot.split("-").first;
          // end = selectedSlot.split("-").last;
          //
          // print(start);
          // print(end);
          // if(slotName == "Evening"){
          //   selectedEveningSlot = time;
          // }
          // else{
          //   selectedMorningSlot = time;
          // }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isSelected ? gsecondaryColor : gTapColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timelapse_rounded,
              size: 2.5.h,
              color: (isSelected) ? gWhiteColor : gBlackColor,
            ),
            SizedBox(width: 0.5.w),
            Text(
              time,
              style: TextStyle(
                color: (isSelected) ? gWhiteColor : gBlackColor,
                fontSize: (isSelected) ? 14.dp : 12.dp,
                fontFamily: (isSelected) ? kFontMedium : kFontBook,
              ),
            )
          ],
        ),
      ),
    );
  }

  submitFollowupSlots(String selectedDate, String slot) async {
    print(slot);
    String start = slot.split('-').first;
    String end = slot.split('-').last;
    submitProgressState(() {
      showSubmitProgress = true;
    });
    print(start);

    Map m = {};
    final res = await GetUserScheduleSlotsForService(repository: repository)
        .submitSlotSelectedService(m);
    Navigator.pop(context);
    if (res.runtimeType == ErrorModel) {
      submitProgressState(() {
        showSubmitProgress = false;
      });
      final result = res as ErrorModel;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    } else {
      submitProgressState(() {
        showSubmitProgress = false;
      });
      getSlotDates();
      final result = res as SuccessMessageModel;
      AppConfig().showSnackbar(context, result.errorMsg ?? '');
    }
    setState(() {
      selectedDate = "";
      selectedSlot = "";
    });
    submitProgressState(() {
      showSubmitProgress = true;
    });
  }
}
