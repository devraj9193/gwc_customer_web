import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../model/error_model.dart';
import '../../model/shift_slots_model/shift_slots_model.dart';
import '../../model/success_message_model.dart';
import '../../model/user_slot_for_schedule_model/user_slot_days_schedule_model.dart';
import '../../repository/api_service.dart';
import '../../repository/shift_slots_repo/shift_slots_repo.dart';
import '../../repository/user_slot_for_schedule_repository/schedule_slot_repository.dart';
import '../../services/shift_slots_service/shift_slots_service.dart';
import '../../services/user_slot_for_schedule_service/user_slot_for_schedule_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class FollowUpCallScreen extends StatefulWidget {
  const FollowUpCallScreen({Key? key}) : super(key: key);

  @override
  State<FollowUpCallScreen> createState() => _FollowUpCallScreenState();
}

class _FollowUpCallScreenState extends State<FollowUpCallScreen> {
  Future? getSlotDaysListFuture;

  final _pref = AppConfig().preferences;

  @override
  void initState() {
    super.initState();
    getSlotDates();
  }

  getSlotDates() {
    getSlotDaysListFuture =
        GetUserScheduleSlotsForService(repository: repository)
            .getSlotsDaysForScheduleService();
  }

  getSlotFuture(String date) {
    print(
        "doctor user id : ${_pref?.getString(AppConfig.userDoctorId).toString()}");

    return ShiftSlotsService(repository: repo).getShiftSlotsService(
      date,
      "followup_slots",
      _pref?.getString(AppConfig.userDoctorId).toString() ?? '',
    );

    // return GetUserScheduleSlotsForService(repository: repository)
    //     .getFollowUpSlotsScheduleService(date);
  }

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
                            final res = snapshot.data
                                as GetUserSlotDaysForScheduleModel;
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
                                      res.data?[index].eventId ?? '',
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
      ),
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

  slotListTile(String slotTime, String middleText, String date,
      String callStatus, String eventId,
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
                                if (date.isEmpty) {
                                  AppConfig().showSnackbar(
                                      context, "date getting empty",
                                      isError: true);
                                } else {
                                  showScheduleDialog(date, eventId);
                                }
                              }
                            },
                            child: (isDayCompleted)
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: gPrimaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.done_outlined,
                                            color: gWhiteColor,
                                            size: 8.dp,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
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
                                    "Schedule",
                                    style: TextStyle(
                                      fontFamily: kFontBook,
                                      color: gsecondaryColor,
                                      fontSize: 13.dp,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                          )
                        : GestureDetector(
                            onTap: () {
                              showScheduleDialog(date, eventId,
                                  isReschedule: true);
                            },
                            child: Text(
                              "ReSchedule",
                              style: TextStyle(
                                fontFamily: kFontBook,
                                color: gsecondaryColor,
                                fontSize: 13.dp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            // Text(
                            //     DateFormat.jm()
                            //         .format(DateFormat("HH:mm:ss").parse(slotTime)),
                            //     style: TextStyle(
                            //       fontFamily: kFontBold,
                            //       color: gBlackColor,
                            //       fontSize: 13.dp,
                            //     ),
                            //   ),
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
    DateTime tempDate = DateFormat("dd-MM-yyyy hh:mm:ss").parse("$date $time");

    print("DateTime : $time");

    return '${DateFormat('dd MMM yyyy').format(tempDate).toString()} at ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(time))}';
  }

  String selectedSlot = "";

  showScheduleDialog(String date, String eventId,
      {bool isReschedule = false}) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_ctx) {
          return StatefulBuilder(builder: (_, setState) {
            return showCustomDialog(setState, date, eventId,
                isReschedule: isReschedule);
          });
        }).then((value) {
      selectedSlot = "";
    });
  }

  bool showSubmitProgress = false;
  List<Slot> followupSlots = [];
  List<Slot> shiftSlots = [];
  // List<SlotElement> slots = [];
  var submitProgressState;

  showCustomDialog(Function setState, String date, String eventId,
      {bool isReschedule = false}) {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date1 = inputFormat.parse(date);
    submitProgressState = setState;
    var outputFormat = DateFormat('yyyy-MM-dd');
    var date2 = outputFormat.format(date1);
    print("Selected Date : $date2");
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
            child: FutureBuilder(
              future: getSlotFuture(date2),
              builder: (_, snap) {
                print("snap: $snap");
                if (snap.hasData) {
                  if (snap.data.runtimeType == ErrorModel) {
                    final model = snap.data as ErrorModel;
                    return Center(
                      child: Text(model.message ?? ''),
                    );
                  } else if (snap.data.runtimeType == ShiftSlotsModel) {
                    final model = snap.data as ShiftSlotsModel;
                    followupSlots = model.getAllDoctors.followupSlots[0].slots;

                    print("Follow_up_call Slots : $followupSlots");

                    // for (var e in followupSlots) {
                    //   print("doctor user id : ${e.userId}");
                    //   print(
                    //       "dashboard doctor user id : ${_pref?.getString(AppConfig.userDoctorId)}");
                    //
                    //   if (e.userId.toString() ==
                    //       _pref?.getString(AppConfig.userDoctorId).toString()) {
                    //     shiftSlots.add(e);
                    //     print("shiftSlots : $shiftSlots");
                    //
                    //     if(shiftSlots.isNotEmpty) {
                    //
                    //       print("doctor slots : ${shiftSlots.contains(e.slots)}");
                    //
                    //       for (var ele in shiftSlots) {
                    //         for (var e in ele.slots) {
                    //           slots.add(e);
                    //           print("slotss : ${slots[0].slot}");
                    //         }
                    //       }
                    //     }
                    //   }
                    // }

                    // followUpSlots!.values.forEach((e) {
                    //   if (e.isBooked == "1") {
                    //     blockedSlot = e.slot!;
                    //   }
                    // });
                    return model.getAllDoctors.followupSlots[0].userLeave == 1
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Please Select Slot',
                                        style: TextStyle(
                                            fontFamily: kFontMedium,
                                            fontSize: 15.dp),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      followupSlots.clear();
                                      shiftSlots.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 3.h,
                                      color: gBlackColor,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                ],
                              ),
                              const Divider(),
                              Center(
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(vertical: 2.h),
                                  child: Text(
                                    "No slots Found ! Do not worry, Our Success Team will arrange it On your Behalf ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: kFontMedium,
                                      fontSize: 15.dp,
                                      color: gBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: IntrinsicWidth(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
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
                                          'Back',
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
                                height: 1.h,
                              )
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Please Select Slot',
                                        style: TextStyle(
                                            fontFamily: kFontMedium,
                                            fontSize: 15.dp),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      followupSlots.clear();
                                      shiftSlots.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 3.h,
                                      color: gBlackColor,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                ],
                              ),
                              const Divider(),
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    ...followupSlots.map(
                                      (e) => e.isBooked == 1
                                          ? const SizedBox()
                                          : slotChip(
                                              e.slot,
                                              '',date2,
                                              isSelected:
                                                  selectedSlot.contains(e.slot),
                                              setstate: setState,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Spacer(),
                              (showSubmitProgress)
                                  ? Center(child: buildCircularIndicator())
                                  : Center(
                                      child: IntrinsicWidth(
                                        child: GestureDetector(
                                          onTap: () {
                                            submitFollowupSlots(
                                                date2, selectedSlot, eventId,
                                                isReschedule: isReschedule);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.5.h,
                                                horizontal: 5.w),
                                            decoration: BoxDecoration(
                                              color: eUser().buttonColor,
                                              borderRadius:
                                                  BorderRadius.circular(eUser()
                                                      .buttonBorderRadius),
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
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                  }
                }
                return Center(
                  child: buildCircularIndicator(),
                );
              },
            )),
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

  slotChip(String time, String slotName,String date,
      {bool isSelected = false, Function? setstate}) {

    String slotName = time.substring(0, 5);

    print("slotTime : $slotName");

    print("today Time : ${DateFormat('HH:mm').format(DateTime.now())}");

    int slotTime = int.parse(slotName.split(":").first);

    int todayTime = int.parse(DateFormat('HH').format(DateTime.now()));

    DateTime selectedDate = DateFormat("yyyy-MM-dd").parse(date);

    String selectedTodayDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return   selectedTodayDate == todayDate
        ? slotTime > todayTime
        ? GestureDetector(
      onTap: () {
        setstate!(() {
          selectedSlot = time;
          print("Selected Time : $selectedSlot");
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    )
        : const SizedBox()
        : GestureDetector(
      onTap: () {
        setstate!(() {
          selectedSlot = time;
          print("Selected Time : $selectedSlot");
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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

  submitFollowupSlots(String selectedDate, String slot, String eventId,
      {bool isReschedule = false}) async {
    print(slot);
    String start = slot.split('-').first;
    String end = slot.split('-').last;
    submitProgressState(() {
      showSubmitProgress = true;
    });

    Map m = isReschedule
        ? {
            'date': selectedDate,
            'slot_start_time': start,
            'slot_end_time': end,
            'event_id': eventId
          }
        : {
            'date': selectedDate,
            'slot_start_time': start,
            'slot_end_time': end
          };
    print("Send Data : $m");
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
}
