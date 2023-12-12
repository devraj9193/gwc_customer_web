import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';



class FertilityScreen extends StatefulWidget {
  const FertilityScreen({Key? key}) : super(key: key);

  @override
  State<FertilityScreen> createState() => _FertilityScreenState();
}

class _FertilityScreenState extends State<FertilityScreen> {

  final _pref = AppConfig().preferences;

  final carouselController = CarouselController();
  int _current = 0;


  List reviewList = [
    "assets/images/new_ds/cour1.png",
    "assets/images/new_ds/cour2.png",
    "assets/images/new_ds/cour3.png",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // clearLocal(periods);
    // clearLocal(fertile);
    initializeDateFormatting();
    // adding months to list
    getMonthName();
    getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: gBackgroundColor,
          body: Stack(
            children: [
              mainView(),
              Align(
                alignment: Alignment.bottomCenter,
                child: bottomView(),
              )
            ],
          ),

        )
    );
  }

  mainView(){
    print("main vies called");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 2.h,
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: gMainColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      // SizedBox(
                      //   height: 6.h,
                      //   child: const Image(
                      //     image: AssetImage("assets/images/Gut welness logo.png"),
                      //   ),
                      //   //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
                      // ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      "Fertility Tracker",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().mainHeadingFont,
                        fontSize: eUser().mainHeadingFontSize,
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //           return AlertDialog(
                  //               content: SizedBox(
                  //                 height: 350,
                  //                 child: Column(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: <Widget>[
                  //                     Expanded(child: _yearPickerDialogView()),
                  //                     MaterialButton(
                  //                       child: Text("OK"),
                  //                       onPressed: () {
                  //                         Navigator.pop(context);
                  //                       },
                  //                     )
                  //                   ],
                  //                 ),
                  //               ));
                  //         });
                  //   },
                  // child: Text("2023"))
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month,
                            size: 16,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(DateFormat.y().format(_selectedYear),
                    ),
                        ],
                      )),
                    onTap: () {
                      AppConfig().showSheet(context,
                          Container(
                            height: 350,
                            child: Column(
                              children: <Widget>[
                                _yearPickerDialogView(),
                                // MaterialButton(
                                //   child: Text("OK"),
                                //   onPressed: () {
                                //     Navigator.pop(context);
                                //   },
                                // )
                              ],
                            ),
                          ),
                        bottomSheetHeight: 75.h,
                        sheetCloseOnTap: (){
                        Navigator.pop(context);
                        },
                        isSheetCloseNeeded: true
                      );
                    },
                  ),
                ],
              ),
            )
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  ..._months.map((e) {
                    return monthNameCard(e);
                  }).toList()
                ],
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(
          //     top: 1.h,
          //     bottom: 1.h,
          //     left: 16.0,
          //     right: 16.0,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             _targetDateTime = DateTime(
          //                 _targetDateTime.year, _targetDateTime.month - 1);
          //             print(_targetDateTime);
          //             _currentMonth =
          //                 DateFormat.MMMM().format(_targetDateTime);
          //           });
          //         },
          //         child: Container(
          //           // padding: const EdgeInsets.all(5),
          //           decoration: BoxDecoration(
          //               color: gWhiteColor,
          //               border: Border.all(color: gBlackColor, width: 1),
          //               shape: BoxShape.circle),
          //           child: const Icon(
          //             Icons.navigate_before_outlined,
          //             color: gBlackColor,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 3.w),
          //       Text(
          //         _currentMonth,
          //         style: TextStyle(
          //           fontFamily: kFontBold,
          //           fontSize: 13.sp,
          //         ),
          //       ),
          //       SizedBox(width: 3.w),
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             _targetDateTime = DateTime(
          //                 _targetDateTime.year, _targetDateTime.month + 1);
          //             _currentMonth =
          //                 DateFormat.MMMM().format(_targetDateTime);
          //           });
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //               color: gWhiteColor,
          //               border: Border.all(color: gBlackColor, width: 1),
          //               shape: BoxShape.circle),
          //           child: const Icon(
          //             Icons.navigate_next_outlined,
          //             color: gBlackColor,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          buildCards(),
          SizedBox(height: 2.h),
          // buildCalendar(),
          MultiCalenderView(),
        ],
      ),
    );
  }

  _yearPickerDialogView(){
    return Container(
        height: 250,
        child: Card(
            child: SfDateRangePicker(
              view: DateRangePickerView.decade,
              allowViewNavigation: false,
              navigationMode: DateRangePickerNavigationMode.snap,
              onSelectionChanged: yearSelectionChanged,
            ))
    );
  }

  void yearSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _selectedYear = args.value;

    _finalDMY = "$initDate-${DateFormat('MM').format(DateTime(0, selectedMonthNo))}-${DateFormat.y().format(_selectedYear)}" ;
    updatedDate();
    SchedulerBinding.instance!.addPostFrameCallback((duration) {
      setState(() {});
    });
    print(_selectedYear);
    print("_finalDMY: $_finalDMY");
    Navigator.pop(context);
  }

  buildCards() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
            width: double.maxFinite,
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                  viewportFraction: .8,
                  aspectRatio: 1.2,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: reviewList
                  .map(
                    (e) => Container(
                  decoration: BoxDecoration(
                    color: kNumberCircleRed.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        e,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
          // SizedBox(height: 2.h),
          // Positioned(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: reviewList.map((url) {
          //       int index = reviewList.indexOf(url);
          //       return Container(
          //         width: 8.0,
          //         height: 8.0,
          //         margin: const EdgeInsets.symmetric(
          //             vertical: 4.0, horizontal: 2.0),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: _current == index
          //               ? gsecondaryColor
          //               : kNumberCircleRed.withOpacity(0.3),
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ],
      ),
    );
  }

  bottomView(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(isFreshData)
          Text("Please Select the Period Dates",
          style: TextStyle(
            fontFamily: kFontMedium,
            fontSize: headingFont,
          ),
        ),
        GestureDetector(
          onTap: (){
            if(isFreshData){
              if(_periodDates.length < 3){
                AppConfig().showSnackbar(context, "Please Select Minimum 3 Days", isError: true);
              }
              else{
                calculateFertile();
                storeDataToLocal();
              }
            }
          },
          child: Container(
            width: 60.w,
            height: 7.h,
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.sp),
              boxShadow: [
                BoxShadow(
                  offset: Offset(1, 4),
                  blurRadius: 3,
                  color: kLineColor
                )
              ]
            ),
            child: (!isFreshData) ?
    Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleImage("assets/images/new_ds/noun-ovum.png", kNumberCirclePurple, 1),
                CircleImage("assets/images/new_ds/noun-tampon.png", kNumberCirclePurple, 2),
                CircleImage("assets/images/new_ds/noun-cycle.png", kNumberCirclePurple, 3)
              ],
            ) :
            Center(
              child: Text("SUBMIT",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: kFontBold
                ),
              ),),
          ),
        ),
      ],
    );
  }

  calculateFertile(){
    print("calculateFertile  ${_dateRangePickerSelectionMode}");
    _fertileDates.clear();
    final _start = _periodDates.last.add(Duration(days: 1));
    final _end = _periodDates.last.add(Duration(days: 12));
    _fertileDates.add(PickerDateRange(_start, _end));
    print(_fertileDates);
    // _controller.selectedRanges = _fertileDates;
    isFreshData = false;
    setState(() {});
  }


  /// 1-> purple
  /// 2-> red
  /// 3-> reset
  int selectedMenuItem = 2;

  CircleImage(String imagePath, Color color, int index){
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedMenuItem = index;
          if(index == 1){
            _dateRangePickerSelectionMode = DateRangePickerSelectionMode.multiRange;
          }
          else if(index == 2){
            _dateRangePickerSelectionMode = DateRangePickerSelectionMode.multiple;
          }
          else{
            _dateRangePickerSelectionMode = DateRangePickerSelectionMode.multiple;
            clearData();
          }
          updateToday();
        });
      },
      child: Container(
        height: 5.h,
        width: 5.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedMenuItem == index ? gsecondaryColor : null
        ),
        padding: EdgeInsets.all(6),
        child:  ImageIcon(AssetImage(imagePath),
          color: selectedMenuItem == index ? gWhiteColor : color,
          size: 20,
        ),
      ),
    );
  }

  updateToday(){
    _controller.displayDate = today;
    _finalDMY = DateFormat('dd-MM-yyyy').format(DateTime.now());
    selectedMonthNo = today.month;
    _selectedYear = today;
  }

  final today = DateTime.now();

  String _finalDMY = DateFormat('dd-MM-yyyy').format(DateTime.now());

  // ************ year picker ************

  String initDate = "01";
  DateTime _selectedYear = DateTime.now();

  // ********** end **********************

  // **************************************
  /// month picker horizontal card
  List _months = [];

  int selectedMonthNo = DateTime.now().month;

  getMonthName(){
    for(int i = 1; i <= 12; i++){
      _months.add(DateFormat('MMMM').format(DateTime(0, i)));
    }
    print("MONTHS");
    print(_months);
  }

  // **************************************


  /// need to change this when bottom menu change to 1st
  /// if bottom menu 1 -> multi range
  /// if 2-> multiple
  DateRangePickerSelectionMode _dateRangePickerSelectionMode = DateRangePickerSelectionMode.multiple;

  /// periods dates
  /// user need to select minimum 3 days
  List<DateTime> _periodDates = [];
  //  List<DateTime> _selectedDates = [
  //     DateTime(2023, 05, 25),
  //     DateTime(2023, 05, 28),
  //     DateTime(2023, 06, 01),
  //     DateTime(2023, 06, 10),
  //     DateTime(2023, 06, 12),
  //     DateTime(2023, 06, 15),
  //   ];

  /// fertile dates
  /// this one calculate based on the periods dates selected
  /// For eg, user choose june 1,2,3,4,5 as their periods date
  /// From 5th, 5+12 = 17 days will be fertile
  List<PickerDateRange> _fertileDates = [];

  // List<PickerDateRange> _selectedDateRange = [
  //   PickerDateRange(DateTime(2023, 05, 20), DateTime(2023, 06, 01)),
  //   PickerDateRange(DateTime(2023, 06, 04), DateTime(2023, 06, 20))
  // ];

  DateRangePickerController _controller = DateRangePickerController();

  updatedDate(){
    _controller.displayDate = DateFormat('dd-MM-yyyy').parse(_finalDMY);
    return DateFormat('dd-MM-yyyy').parse(_finalDMY);
  }

  MultiCalenderView(){
    print("view called");
    return IgnorePointer(
      ignoring: !isFreshData,
      child: SfDateRangePicker(
        controller: _controller,
        headerHeight: 0,
        view: DateRangePickerView.month,
        initialDisplayDate: updatedDate(),
        initialSelectedDates: _periodDates,
        initialSelectedRanges: _fertileDates,
        showTodayButton: false,
        showNavigationArrow: true,
        selectionColor: gsecondaryColor,
        rangeSelectionColor: kNumberCirclePurple,
        startRangeSelectionColor: kNumberCirclePurple,
        endRangeSelectionColor: kNumberCirclePurple,
        // uncomment for custom month view
        // allowViewNavigation: false,
        // navigationMode: DateRangePickerNavigationMode.none,
        monthViewSettings: DateRangePickerMonthViewSettings(
            dayFormat: 'EEE',
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              backgroundColor: gWhiteColor,
            )
        ),
        selectionMode: _dateRangePickerSelectionMode,
        onSelectionChanged: (value){
          print(value.value);
          if(_dateRangePickerSelectionMode == DateRangePickerSelectionMode.multiple){
            setState(() {
              print(_dateRangePickerSelectionMode);
              _periodDates = value.value;
              _periodDates = _periodDates..sort((a,b) => a.toString().compareTo(b.toString()));
            });
          }
        },
        onSubmit: (value){
          print("value");
        },
      ),
    );
  }

  getIsSelected(String month){
    if(selectedMonthNo == (_months.indexOf(month)+1)){
      return true;
    }
    else{
      return false;
    }
  }

  monthNameCard(String month){
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedMonthNo = (_months.indexOf(month))+1;
          _finalDMY = "$initDate-${DateFormat('MM').format(DateTime(0, selectedMonthNo))}-${DateFormat.y().format(_selectedYear)}" ;
        });
        updatedDate();
        print("Month chnage: ${_finalDMY}");
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: getIsSelected(month) ? kNumberCirclePurple : null
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(month,
          style: TextStyle(
            fontFamily: getIsSelected(month) ? kFontMedium : kFontBook,
            color: getIsSelected(month) ? gWhiteColor : gTextColor
          ),
        ),
      ),
    );
  }

  static const periods = "period";
  static const fertile = "fertile";


  storeLocal(String key, String value){
    _pref!.setString(key, value);
  }
  getLocal(String key){
    return _pref!.getString(key);
  }
  getKeyExists(String key){
    return _pref!.containsKey(key);
  }
  clearLocal(String key){
    _pref!.remove(key);
  }

  clearData(){
    print("clear");
    setState(() {
      _periodDates.clear();
      _fertileDates.clear();
      _controller.selectedDates = _periodDates;
      _controller.selectedRanges = _fertileDates;
      print(_controller.selectedDates);
      isFreshData = true;
    });
    clearLocal(periods);
    clearLocal(fertile);

  }

  bool isFreshData = false;

  getStoredData(){
    print("getStoredData");
    print(getKeyExists(periods));
    print(getKeyExists(fertile));
    if(getKeyExists(periods) && getKeyExists(fertile)){
      var _dummy = getLocal(periods).toString().replaceAll("[", "").replaceAll("]", "");
      print(_dummy);
      _dummy.split(',').forEach((element) {
        _periodDates.add(DateTime.parse(element.trim()));
      });
      var _dummy1 = getLocal(fertile).toString().replaceAll("[", "").replaceAll("]", "");
      print(_dummy1);
      var _fList = _dummy1.trim().split(',');
      _fertileDates.add(PickerDateRange(DateTime.parse(_fList[0].trim()), DateTime.parse(_fList[1].trim())));
    }
    else{
      isFreshData = true;
    }
    setState(() {});
  }

  storeDataToLocal(){
    storeLocal(periods, _periodDates.toString());
    final _start = _periodDates.last.add(Duration(days: 1));
    final _end = _periodDates.last.add(Duration(days: 12));

    List _m = [_start, _end];
    storeLocal(fertile, _m.toString());
  }

}
