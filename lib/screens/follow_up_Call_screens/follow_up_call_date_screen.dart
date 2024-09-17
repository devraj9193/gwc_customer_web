import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import '../../model/error_model.dart';
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
import '../../model/shift_slots_model/shift_slots_model.dart';

class FollowUpCallDateScreen extends StatefulWidget {
  const FollowUpCallDateScreen({Key? key}) : super(key: key);

  @override
  State<FollowUpCallDateScreen> createState() => _FollowUpCallDateScreenState();
}

class _FollowUpCallDateScreenState extends State<FollowUpCallDateScreen> {
  Future? getSlotDaysListFuture;

  final _pref = AppConfig().preferences;
  int? expandedIndex;

  bool isReschedule = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: gWhiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: buildAppBar(() {
                Navigator.pop(context);
              }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                "Follow Up call",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kFontBold,
                  color: gBlackColor,
                  fontSize: 16.dp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, bottom: 1.h),
              child: Text(
                "Follow Up Calls will be of 15 mins",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kFontBook,
                  color: gBlackColor,
                  fontSize: 12.dp,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getSlotDaysListFuture,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.runtimeType == ErrorModel) {
                        final res = snapshot.data as ErrorModel;
                        print(res);
                        return Center(
                          child: Text(res.message.toString()),
                        );
                      } else {
                        final res =
                            snapshot.data as GetUserSlotDaysForScheduleModel;
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: res.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return buildScheduleList(
                                res.data![index],
                                index,
                              );
                            });
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return Center(
                      child: buildCircularIndicator(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  buildScheduleList(ChildUserSlotDaysForScheduleModel details, int index) {
    DateTime scheduledDate = DateFormat("dd-MM-yyyy").parse("${details.date}");

    bool chkAvailableDate = getIsSlotCompleted(scheduledDate);

    print("Chk Date : $scheduledDate");
    print("Chk Available Dates : $chkAvailableDate");

    String middleText = !chkAvailableDate
        ? (details.slot == null || details.slot == "")
            ? "Book your ${index + 1}${getDayOfMonthSuffix(index + 1)} follow-up call"
            : "Slot booked ${getTime("${details.date}", "${details.slot}")}"
        : "";

    bool isDayCompleted = details.callStatus == "1";

    print("Chk Call Status : $isDayCompleted");

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      margin: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: const Color(0xffEFEFEF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              badges.Badge(
                position: badges.BadgePosition.topEnd(
                  top: -5,
                  end: 2,
                ),
                badgeAnimation: const badges.BadgeAnimation.fade(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                badgeStyle: badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: gsecondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                badgeContent: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: gWhiteColor),
                  ),
                ),
                child: Image(
                  image: const AssetImage(
                      "assets/images/dashboard_stages/Mask Group 43506.png"),
                  height: 8.h,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    Text(
                      DateFormat("dd MMM yyyy").format(
                        DateFormat("dd-MM-yyyy").parse(details.date ?? ''),
                      ),
                      style: TextStyle(
                        fontFamily: kFontBold,
                        color: gBlackColor,
                        fontSize: 15.dp,
                        height: 1.5,
                      ),
                    ),
                    middleText.isEmpty
                        ? const SizedBox()
                        : Text(
                            middleText,
                            style: TextStyle(
                              fontFamily: kFontBook,
                              color: gTextColor,
                              fontSize: 14.dp,
                              height: 1.5,
                            ),
                          ),
                    !chkAvailableDate
                        ? const SizedBox()
                        : (isDayCompleted)
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
                                "Follow up unsuccessful, doctor will reschedule.",
                                style: TextStyle(
                                  fontFamily: kFontMedium,
                                  color: gsecondaryColor,
                                  fontSize: 14.dp,
                                  height: 1.5,
                                ),
                              ),
                  ],
                ),
              ),
              !chkAvailableDate
                  ? details.slot!.isEmpty || details.slot == null
                      ? buildButtons("Schedule", () {
                          setState(() {
                            isReschedule = false;
                            if (expandedIndex == index) {
                              expandedIndex = null;
                            } else {
                              expandedIndex = index;
                            }
                          });
                          // showScheduleDialog(
                          //     details.date ?? '', details.eventId ?? '');
                        })
                      : buildButtons("ReSchedule", () {
                          setState(() {
                            isReschedule = true;
                            if (expandedIndex == index) {
                              expandedIndex = null;
                            } else {
                              expandedIndex = index;
                            }
                          });
                          // showScheduleDialog(
                          //     details.date ?? '', details.eventId ?? '',
                          //     isReschedule: true);
                        })
                  : const SizedBox(),
            ],
          ),
          if (expandedIndex == index)
            Column(
              children: [
                SizedBox(height: 2.h),
                const Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 1.5.h, bottom: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Please Select Slot',
                            style: TextStyle(
                                fontFamily: kFontMedium, fontSize: 15.dp),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedIndex = null;
                            selectedSlot = "";
                            expandedIndex = null;
                          });
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
                ),
                showSlotDetails(details.date ?? '', details.eventId ?? '',
                    isReschedule: isReschedule),
              ],
            ),
        ],
      ),
    );
  }

  final today = DateTime.now();

  getIsSlotCompleted(DateTime date) {
    print("Diff days: ${today.difference(date).inDays}");
    if (today.difference(date).inDays > 0) {
      return true;
    } else {
      return false;
    }
  }

  buildButtons(String title, func) {
    return GestureDetector(
      onTap: func,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: gsecondaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: kFontMedium,
            color: gWhiteColor,
            fontSize: 12.dp,
          ),
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

  showSlotDetails(String date, String eventId, {bool isReschedule = false}) {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date1 = inputFormat.parse(date);
    var outputFormat = DateFormat('yyyy-MM-dd');
    var date2 = outputFormat.format(date1);
    print("Selected Date : $date2");
    return Container(
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

                return model.getAllDoctors.followupSlots[0].userLeave == 1
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
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
                          SizedBox(height: 1.h),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                          '',
                                          date2,
                                          isSelected:
                                              selectedSlot.contains(e.slot),
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
        ));
  }

  bool showSubmitProgress = false;
  List<Slot> followupSlots = [];
  List<Slot> shiftSlots = [];

  slotChip(
    String time,
    String slotName,
    String date, {
    bool isSelected = false,
  }) {
    String slotName = time.substring(0, 5);

    var tme =
        DateFormat('hh:mm aa').format(DateFormat("hh:mm").parse(slotName));

    print("slotTime : $slotName");

    print("today Time : ${DateFormat('HH:mm').format(DateTime.now())}");

    int slotTime = int.parse(slotName.split(":").first);

    int todayTime = int.parse(DateFormat('HH').format(DateTime.now()));

    DateTime selectedDate = DateFormat("yyyy-MM-dd").parse(date);

    String selectedTodayDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return selectedTodayDate == todayDate
        ? slotTime > todayTime
            ? GestureDetector(
                onTap: () {
                  setState!(() {
                    selectedSlot = time;
                    print("Selected Time : $selectedSlot");
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: isSelected ? gsecondaryColor : gTapColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tme,
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
              setState!(() {
                selectedSlot = time;
                print("Selected Time : $selectedSlot");
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
                  Text(
                    tme,
                    style: TextStyle(
                      color: (isSelected) ? gWhiteColor : gBlackColor,
                      fontSize: (isSelected) ? 14.dp : 12.dp,
                      fontFamily: (isSelected) ? kFontMedium : kFontBook,
                    ),
                  ),
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
    setState(() {
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
    // Navigator.pop(context);
    if (res.runtimeType == ErrorModel) {
      setState(() {
        showSubmitProgress = false;
      });
      final result = res as ErrorModel;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    } else {
      setState(() {
        showSubmitProgress = false;
      });
      getSlotDates();
      final result = res as SuccessMessageModel;
      AppConfig().showSnackbar(context, result.errorMsg ?? '');
    }
    setState(() {
      selectedDate = "";
      selectedSlot = "";
      expandedIndex = null;
    });
    setState(() {
      showSubmitProgress = false;
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
