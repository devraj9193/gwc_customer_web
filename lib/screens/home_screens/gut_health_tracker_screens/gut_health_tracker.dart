import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class GutHealthTracker extends StatefulWidget {
  const GutHealthTracker({Key? key}) : super(key: key);

  @override
  State<GutHealthTracker> createState() => _GutHealthTrackerState();
}

class _GutHealthTrackerState extends State<GutHealthTracker> {
  final DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.MMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  String selectedSummary = "";

  // final carouselController = CarouselController();

  final dataMap = <String, double>{
    "Stools": 55,
    "Saliva": 32,
    "Hunger": 25,
    "Sweat": 34,
    "Urine": 43,
  };

  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  List<_ChartData>? data;
  TooltipBehavior? _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('Stools', 60),
      _ChartData('Saliva', 38),
      _ChartData('Hunger', 29),
      _ChartData('Sweat', 32),
      _ChartData('Urine', 22),
    ];
    _tooltip = TooltipBehavior(
      enable: true,
      color: gBackgroundColor,
      borderColor: kLineColor,
      canShowMarker: true,
      borderWidth: 1,
      textStyle: TextStyle(
        color: eUser().userFieldLabelColor,
        fontFamily: eUser().userFieldLabelFont,
        fontSize: eUser().userTextFieldHintFontSize,
      ),
      // textAlignment: ChartAlignment.far,
      //       //   // format: 'point.y%',
      //       //   tooltipPosition: TooltipPosition.pointer,
      // builder: (dynamic data, dynamic point, dynamic series,
      //     int pointIndex, int seriesIndex) {
      //   return Container(
      //       child: Text(
      //           'PointIndex : ${pointIndex.toString()}'
      //       )
      //   );
      // }
    );
    super.initState();
  }

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime.now(): [
        Event(
          date: DateTime(2022, 12, 12),
          title: '',
          icon: const Image(
            image: AssetImage("assets/images/gmg/Group 11526.png"),
          ),
          // dot: Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 1.0),
          //   //   color: Colors.red,
          //   height: 5.0,
          //   width: 5.0,
          // ),
        ),
      ],
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gWhiteColor,
      body: Stack(
        children: [
          buildTracker(),
          SizedBox(
            height: 18.h,
            child: const Image(
              image: AssetImage(
                  "assets/images/gut_health_tracker/Group 76925.png"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: 1.h, top: 3.h),
            child: buildAppBar(
              () {
                Navigator.pop(context);
              },
              showNotificationIcon: false,
              isBackEnable: true,
              showLogo: false,
              showChild: true,
              child: Text(
                "Gut Health Tracker",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: eUser().threeBounceIndicatorColor,
                  fontFamily: eUser().mainHeadingFont,
                  fontSize: eUser().mainHeadingFontSize,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            right: 3.w,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const GutHealthTracker();
                    },
                  ),
                );
              },
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: gsecondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: gGreyColor.withOpacity(0.5),
                        offset: const Offset(4, 5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Check Gut Health',
                      style: TextStyle(
                        color: eUser().threeBounceIndicatorColor,
                        fontFamily: eUser().userFieldLabelFont,
                        fontSize: eUser().fieldSuffixTextFontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: SizedBox(
          //     height: 20.h,
          //     child: const Image(
          //       image: AssetImage(
          //           "assets/images/gut_health_tracker/Group 76926.png"),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  buildTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 1.h,
                      bottom: 2.h,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _targetDateTime = DateTime(_targetDateTime.year,
                                  _targetDateTime.month - 1);
                              _currentMonth =
                                  DateFormat.MMMM().format(_targetDateTime);
                            });
                          },
                          child: const Icon(
                            Icons.navigate_before_outlined,
                            color: kNumberCirclePurple,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          _currentMonth,
                          style: TextStyle(
                            fontFamily: "GothamBold",
                            color: kNumberCirclePurple,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _targetDateTime = DateTime(_targetDateTime.year,
                                  _targetDateTime.month + 1);
                              _currentMonth =
                                  DateFormat.MMMM().format(_targetDateTime);
                            });
                          },
                          child: const Icon(
                            Icons.navigate_next_outlined,
                            color: kNumberCirclePurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildCalendar(),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: Text(
                      "Gut Health Results",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: kNumberCirclePurple,
                        fontFamily: eUser().userFieldLabelFont,
                        fontSize: eUser().mainHeadingFontSize,
                      ),
                    ),
                  ),
                  IntrinsicWidth(
                    child: Container(
                      margin: EdgeInsets.only(top: 2.h, bottom: 4.h, left: 3.w),
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: gBackgroundColor,
                        border: Border.all(color: kLineColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Indicator:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: eUser().userFieldLabelColor,
                              fontFamily: eUser().userFieldLabelFont,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Row(
                            children: [
                              Container(
                                height: 2.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: gsecondaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: gGreyColor.withOpacity(0.1),
                                      offset: const Offset(3, 5),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Healthy",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: eUser().userFieldLabelColor,
                                  fontFamily: eUser().userFieldLabelFont,
                                  fontSize: eUser().userTextFieldHintFontSize,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Container(
                                height: 2.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: kNumberCircleAmber,
                                  boxShadow: [
                                    BoxShadow(
                                      color: gGreyColor.withOpacity(0.1),
                                      offset: const Offset(3, 5),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "UnHealthy",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: eUser().userFieldLabelColor,
                                  fontFamily: eUser().userFieldLabelFont,
                                  fontSize: eUser().userTextFieldHintFontSize,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  buildCircleTracker(),
                  SizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image(
                      height: 20.h,
                      image: const AssetImage(
                          "assets/images/gut_health_tracker/Group 76926.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: CalendarCarousel<Event>(
        dayPadding: 2.0,
        dayMainAxisAlignment: MainAxisAlignment.center,
        dayCrossAxisAlignment: CrossAxisAlignment.center,
        weekDayPadding: const EdgeInsets.symmetric(vertical: 5),
        isScrollable: false,
        weekDayBackgroundColor: gWhiteColor,
        selectedDayBorderColor: gsecondaryColor,
        todayBorderColor: kNumberCircleGreen,
        weekdayTextStyle: TextStyle(
          color: gsecondaryColor,
          fontSize: 10.sp,
        ),
        prevDaysTextStyle: TextStyle(
          color: Colors.grey.withOpacity(0.8),
          fontSize: 10.sp,
        ),
        // prevMonthDayBorderColor: Colors.grey.withOpacity(0.2),
        weekDayFormat: WeekdayFormat.narrow,
        onDayPressed: (date, events) {
          setState(() => _currentDate2 = date);
          for (var event in events) {
            AppConfig().showSnackbar(context, '${event.title} $selectedSummary',
                isError: true);
          }
          //  print(event.title));
        },
        daysHaveCircularBorder: true,
        showOnlyCurrentMonthDate: false,
        daysTextStyle: TextStyle(
          fontSize: 9.sp,
          fontFamily: eUser().userFieldLabelFont,
          color: kNumberCircleRed,
        ),
        weekendTextStyle: TextStyle(
          fontFamily: eUser().userFieldLabelFont,
          color: kNumberCircleRed,
          fontSize: 9.sp,
        ),
        // thisMonthDayBorderColor: Colors.grey.withOpacity(0.2),
        weekFormat: false,
        markedDatesMap: _markedDateMap,
        height: 330,
        selectedDateTime: _currentDate2,
        targetDateTime: _targetDateTime,
        customGridViewPhysics: const NeverScrollableScrollPhysics(),
        showHeader: false,
        todayTextStyle: TextStyle(
          color: gWhiteColor,
          fontSize: 9.sp,
        ),
        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        markedDateMoreShowTotal: true,
        todayButtonColor: kNumberCircleGreen,
        selectedDayButtonColor: gsecondaryColor,
        selectedDayTextStyle: TextStyle(
          fontSize: 9.sp,
          color: gWhiteColor,
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
    );
  }

  buildCircleTracker() {
    return SfCircularChart(
      tooltipBehavior: _tooltip,
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Text(
            'Gut Health Indicator',
            style: TextStyle(
              color: eUser().kRadioButtonColor,
              fontFamily: eUser().userFieldLabelFont,
              fontSize: eUser().userTextFieldHintFontSize,
            ),
          ),
        ),
      ],
      series: <CircularSeries<dynamic, dynamic>>[
        DoughnutSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          explode: true,
          radius: "120%",
          // explodeIndex: 0,
          explodeAll: true,
          dataLabelMapper: (_ChartData data, _) => data.x,
          strokeColor: gPrimaryColor,
          enableTooltip: true,
          cornerStyle: CornerStyle.bothFlat,
          explodeOffset: "10%",
          dataLabelSettings: DataLabelSettings(
            offset: const Offset(50, 50),
            isVisible: true,
            textStyle: TextStyle(
              color: eUser().threeBounceIndicatorColor,
              fontFamily: eUser().userFieldLabelFont,
              fontSize: eUser().userTextFieldHintFontSize,
            ),
          ),
          pointColorMapper: (_ChartData data, _) =>
              data.y > 30.0 ? kNumberCircleGreen : gsecondaryColor,
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
