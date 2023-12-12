import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/post_program_model/protocol_calendar_model.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class PPCalendar extends StatefulWidget {
  const PPCalendar({Key? key}) : super(key: key);

  @override
  State<PPCalendar> createState() => _PPCalendarState();
}

class _PPCalendarState extends State<PPCalendar> {
  ProtocolCalendarModel? protocolCalendarModel;

  final DateTime _currentDate = DateTime.now();
  final DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.MMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  bool isLoading = false;
  String selectedSummary = "";

  static const Widget _eventIcon = Image(
    image: AssetImage("assets/images/gmg/Group 11526.png"),
  );
  static const Widget sadIcon = Image(
    image: AssetImage("assets/images/gmg/Group 11527.png"),
  );
  static const Widget notCompletedIcon = Image(
    image: AssetImage("assets/images/gmg/Group 11528.png"),
  );
  static const Widget skippedIcon = Image(
    image: AssetImage("assets/images/gmg/Group 11552.png"),
  );
  static const Widget missedIcon = Image(
    image: AssetImage("assets/images/gmg/Group 11552.png"),
  );

  List<ProtocolCalendar> calendarEvents = [];

  List summaryData = [
    {
      "image": "assets/images/empty_stomach.png",
      "title": "Early Morning",
      "id": 1,
    },
    {
      "image": "assets/images/breakfast_icon.png",
      "title": "Breakfast",
      "id": 2,
    },
    {
      "image": "assets/images/midday_icon.png",
      "title": "Mid Day",
      "id": 3,
    },
    {
      "image": "assets/images/lunch_icon.png",
      "title": "Lunch",
      "id": 4,
    },
    {
      "image": "assets/images/evening_icon.png",
      "title": "Evening",
      "id": 5,
    },
    {
      "image": "assets/images/dinner_icon.png",
      "title": "Dinner",
      "id": 6,
    },
    {
      "image": "assets/images/pp_icon.png",
      "title": "Post Dinner",
      "id": 7,
    },
  ];

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime.now(): [
        Event(
          date: DateTime(2022, 12, 12),
          title: '',
          icon: _eventIcon,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            //   color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
      ],
    },
  );

  Future<List<ProtocolCalendar>?> getPPCalendar() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConfig().BEARER_TOKEN)!;

    final response = await http.get(Uri.parse(ppCalendarUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    //  print("PPCalendar response: ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
      });
      ProtocolCalendarModel jsonData =
          protocolCalendarModelFromJson(response.body);
      List<ProtocolCalendar> arrData = jsonData.protocolCalendar!;
      getData(arrData);
      // print("PPCalendar: ${calendarEvents[0].date?.year}, ${calendarEvents[0].date?.month}, ${calendarEvents[0].date?.day}");
      return arrData;
    } else {
      throw Exception();
    }
  }

  getData(List<ProtocolCalendar> events) {
    calendarEvents = events;
    print("PPCEvents:$calendarEvents");
    print(
        "PPCalendar: ${calendarEvents[0].date?.year}, ${calendarEvents[0].date?.month}, ${calendarEvents[0].date?.day}");
    if (selectedSummary == "Early Morning") {
      return calendarEvents
          .map(
            (e) => _markedDateMap.add(
              DateTime(e.date!.year, e.date!.month, e.date!.day),
              Event(
                date: DateTime(e.date!.year, e.date!.month, e.date!.day),
                title: 'Day ${e.day.toString()}',
                icon: getSummaryCalendarEmoji(e.earlyMorning),
              ),
            ),
          )
          .toList();
    } else if (selectedSummary == "Breakfast") {
      return calendarEvents
          .map(
            (e) => _markedDateMap.add(
              DateTime(e.date!.year, e.date!.month, e.date!.day),
              Event(
                date: DateTime(e.date!.year, e.date!.month, e.date!.day),
                title: 'Day ${e.day.toString()}',
                icon: getSummaryCalendarEmoji(e.breakfast),
              ),
            ),
          )
          .toList();
    } else if (selectedSummary == "Mid Day") {
      return calendarEvents
          .map(
            (e) => _markedDateMap.add(
              DateTime(e.date!.year, e.date!.month, e.date!.day),
              Event(
                date: DateTime(e.date!.year, e.date!.month, e.date!.day),
                title: 'Day ${e.day.toString()}',
                icon: getSummaryCalendarEmoji(e.midDay),
              ),
            ),
          )
          .toList();
    } else if (selectedSummary == "Lunch") {
      return calendarEvents
          .map(
            (e) => _markedDateMap.add(
              DateTime(e.date!.year, e.date!.month, e.date!.day),
              Event(
                date: DateTime(e.date!.year, e.date!.month, e.date!.day),
                title: 'Day ${e.day.toString()}',
                icon: getSummaryCalendarEmoji(e.lunch),
              ),
            ),
          )
          .toList();
    } else if (selectedSummary == "Dinner") {
      return calendarEvents
          .map(
            (e) => _markedDateMap.add(
              DateTime(e.date!.year, e.date!.month, e.date!.day),
              Event(
                date: DateTime(e.date!.year, e.date!.month, e.date!.day),
                title: 'Day ${e.day.toString()}',
                icon: getSummaryCalendarEmoji(e.dinner),
              ),
            ),
          )
          .toList();
    } else if (selectedSummary == "Post Dinner") {
      return calendarEvents
          .map(
            (e) => _markedDateMap.add(
              DateTime(e.date!.year, e.date!.month, e.date!.day),
              Event(
                date: DateTime(e.date!.year, e.date!.month, e.date!.day),
                title: 'Day ${e.day.toString()}',
                icon: getSummaryCalendarEmoji(e.postDinner),
              ),
            ),
          )
          .toList();
    } else {
      return calendarEvents
          .map(
            (e) => _markedDateMap.add(
              DateTime(e.date!.year, e.date!.month, e.date!.day),
              Event(
                date: DateTime(e.date!.year, e.date!.month, e.date!.day),
                title: 'Day ${e.day.toString()}',
                icon: getCalendarEmoji(e.score),
              ),
            ),
          )
          .toList();
    }
  }

  getCalendarEmoji(String? score) {
    // print("Score:${score}");
    if (score == "1") {
      return _eventIcon;
    } else if (score == "2") {
      return notCompletedIcon;
    } else if (score == "3") {
      return sadIcon;
    } else {
      return skippedIcon;
    }
  }

  getSummaryCalendarEmoji(String? score) {
    // print("Score:${score}");
    if (score == "1") {
      return _eventIcon;
    } else if (score == "2") {
      return sadIcon;
    } else {
      return skippedIcon;
    }
  }

  @override
  void initState() {
    super.initState();
    getPPCalendar();
    getData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: buildAppBar(
              () {
                Navigator.pop(context);
              },
              isBackEnable: true,
              showNotificationIcon: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 0.h,
              bottom: 1.h,
              left: 16.0,
              right: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month - 1);
                      _currentMonth = DateFormat.MMMM().format(_targetDateTime);
                    });
                  },
                  child: Container(
                    // padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: gWhiteColor,
                        border: Border.all(color: gBlackColor, width: 1),
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.navigate_before_outlined,
                      color: gBlackColor,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  _currentMonth,
                  style: TextStyle(
                    fontFamily: "GothamBold",
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 3.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month + 1);
                      _currentMonth = DateFormat.MMMM().format(_targetDateTime);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: gWhiteColor,
                        border: Border.all(color: gBlackColor, width: 1),
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.navigate_next_outlined,
                      color: gBlackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tracker summary of your ",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 10.sp,
                  ),
                ),
                (selectedSummary.isEmpty)
                    ? Text(
                        "Day",
                        style: TextStyle(
                          fontFamily: "GothamBook",
                          fontSize: 10.sp,
                        ),
                      )
                    : Text(
                        selectedSummary,
                        style: TextStyle(
                          fontFamily: "GothamBook",
                          fontSize: 10.sp,
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            child: CalendarCarousel<Event>(
              dayPadding: 2.0,
              dayMainAxisAlignment: MainAxisAlignment.end,
              dayCrossAxisAlignment: CrossAxisAlignment.end,
              weekDayPadding: const EdgeInsets.symmetric(vertical: 5),
              isScrollable: false,
              weekDayBackgroundColor: gsecondaryColor,
              selectedDayBorderColor: gPrimaryColor,
              todayBorderColor: gsecondaryColor,
              weekdayTextStyle: TextStyle(
                color: gWhiteColor,
                fontSize: 10.sp,
              ),
              prevDaysTextStyle: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontSize: 10.sp,
              ),
              prevMonthDayBorderColor: Colors.grey.withOpacity(0.2),
              weekDayFormat: WeekdayFormat.narrow,
              onDayPressed: (date, events) {
                // setState(() => _currentDate2 = date);
                for (var event in events) {
                  AppConfig()
                      .showSnackbar(context, '${event.title} $selectedSummary', isError: true);
                }
                //  print(event.title));
              },
              daysHaveCircularBorder: false,
              showOnlyCurrentMonthDate: false,
              daysTextStyle: TextStyle(
                fontSize: 9.sp,
                color: gBlackColor,
              ),
              weekendTextStyle: TextStyle(
                color: Colors.red,
                fontSize: 9.sp,
              ),
              thisMonthDayBorderColor: Colors.grey.withOpacity(0.2),
              weekFormat: false,
              markedDatesMap: _markedDateMap,
              height: 330,
              selectedDateTime: _currentDate2,
              targetDateTime: _targetDateTime,
              customGridViewPhysics: const NeverScrollableScrollPhysics(),
              showHeader: false,
              todayTextStyle: TextStyle(
                color: gPrimaryColor,
                fontSize: 9.sp,
              ),
              markedDateShowIcon: true,
              markedDateIconMaxShown: 1,
              markedDateIconBuilder: (event) {
                return event.icon;
              },
              markedDateMoreShowTotal: true,
              todayButtonColor: Colors.transparent,
              selectedDayButtonColor: Colors.transparent,
              selectedDayTextStyle: TextStyle(
                fontSize: 9.sp,
                color: gBlackColor,
              ),
              minSelectedDate: _currentDate.subtract(const Duration(days: 360)),
              maxSelectedDate: _currentDate.add(const Duration(days: 360)),
              onCalendarChanged: (DateTime date) {
                setState(() {
                  _targetDateTime = date;
                  _currentMonth = DateFormat.MMMM().format(_targetDateTime);
                });
              },
              onDayLongPressed: (DateTime date) {
                print('long pressed date $date');
              },
            ),
          ),
          Expanded(
            child: buildDetails(),
          ),
        ],
      ),
    );
  }

  void changedIndex(String index) {
    setState(() {
      selectedSummary = index;
    });
  }

  buildDetails() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Image(
                  image: const AssetImage("assets/images/gmg/Group 11526.png"),
                  height: 2.5.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Followed - 80 to 100 %",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 8.sp,
                  ),
                ),
                SizedBox(width: 5.w),
                Image(
                  image: const AssetImage("assets/images/gmg/Group 11528.png"),
                  height: 2.5.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Followed - 30 to 80 %",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Image(
                  image: const AssetImage("assets/images/Group 11527.png"),
                  height: 2.5.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Followed - 30 to 0 %",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 8.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Image(
                  image: const AssetImage("assets/images/Group 11552.png"),
                  height: 2.5.h,
                  //color: gGreyColor.withOpacity(0.3),
                ),
                SizedBox(width: 2.w),
                Text(
                  "Skipped",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: summaryData.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      changedIndex(
                        summaryData[index]["title"],
                      );
                      //   print("selectedSummary: $selectedSummary");
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
                      margin:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Image(
                          image: AssetImage(
                            summaryData[index]["image"],
                          ),
                          color: gBlackColor,
                          height: 3.h,
                        ),
                        title: Text(
                          summaryData[index]["title"],
                          style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gBlackColor,
                            // color: value == '0' ? gBlackColor : gWhiteColor,
                            fontSize: 11.sp,
                          ),
                        ),
                        trailing: Visibility(
                          visible: selectedSummary
                              .contains(summaryData[index]["title"]),
                          child: Image.asset(
                            'assets/images/gmg/Symbol.png',
                            height: 3.h,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  // getEmoji(String? data) {
  //   print("object:${data}");
  //   if (data == "1") {
  //     return const Center(
  //       child: Image(
  //         image: AssetImage("assets/images/Group 11526.png"),
  //       ),
  //     );
  //   } else if (data == "2") {
  //     return const Center(
  //       child: Image(
  //         image: AssetImage("assets/images/Group 11528.png"),
  //       ),
  //     );
  //   } else if (data == "3") {
  //     return const Center(
  //       child: Image(
  //         image: AssetImage("assets/images/Group 11527.png"),
  //       ),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }
}
