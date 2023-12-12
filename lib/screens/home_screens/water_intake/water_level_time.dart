import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../model/home_model/water_level_time_model.dart';
import '../../../services/home_service/drink_water_controller.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';

class WaterLevelTime extends StatefulWidget {
  const WaterLevelTime({Key? key}) : super(key: key);

  @override
  State<WaterLevelTime> createState() => _WaterLevelTimeState();
}

class _WaterLevelTimeState extends State<WaterLevelTime> {
  double? _height;
  double? _width;

  String? _setTime;

  String? _hour, _minute, _time;

  String? dateTime;

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  DateTime? initialTime;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
    initialTime = DateTime.now();
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _setTime = _time!;
        _setTime = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        timeList[selectedIndex].time = "$_setTime";
        selectedIndex = -1;
        // _waterProgressProvider.setTimeTarget(_setTime ?? '');
      });
      saveIntoSp();
    }
  }

  late DrinkWaterController _waterProgressProvider;

  List<WaterLevelTimeModel> timeList = List.empty(growable: true);

  int selectedIndex = -1;

  var sp = AppConfig().preferences;

  getSharedPreferences() async {
    sp = await SharedPreferences.getInstance();
    readFromSp();
  }

  saveIntoSp() {
    //
    List<String> timeListString =
        timeList.map((time) => jsonEncode(time.toJson())).toList();
    sp?.setStringList('myData', timeListString);
    //
  }

  readFromSp() {
    //
    List<String>? timeListString = sp?.getStringList('myData');
    if (timeListString != null) {
      timeList = timeListString
          .map(
            (time) => WaterLevelTimeModel.fromJson(
              json.decode(time),
            ),
          )
          .toList();
    }
    setState(() {});
    //
  }

  @override
  Widget build(BuildContext context) {
    _waterProgressProvider =
        Provider.of<DrinkWaterController>(context, listen: false);

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: PPConstants().bgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 4.w, top: 1.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 2.h,
                    child: IconButton(
                      onPressed: () {
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
                  SizedBox(
                    height: 6.h,
                    child: const Image(
                      image: AssetImage("assets/images/Gut welness logo.png"),
                    ),
                    //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
                  ),
                ],
              ),
            ),
            buildMainTimeList(),
            Center(
              child: Row(
                children: [
                  buildButtons("Add", () {
                    setState(() {
                      print("setTime : $_setTime");
                      timeList.add(WaterLevelTimeModel(
                        time: "$_setTime",
                      ));
                      // _waterProgressProvider.setTimeTarget(_setTime ?? '');
                    });
                    saveIntoSp();
                  }, kNumberCircleGreen),
                  buildButtons("Reset", () {
                    setState(() {
                      initialTime = DateTime.now();
                      print(initialTime);
                    });
                  }, kNumberCircleRed),
                  // Consumer<DrinkWaterController>(builder: (_, data, child) {
                  //   return Visibility(
                  //     visible: !data.showResetButton,
                  //     child: buildButtons("Reset", () {}, gsecondaryColor),
                  //   );
                  // }),
                ],
              ),
            ),
            buildTimeList(),
          ],
        ),
      ),
    );
  }

  buildMainTimeList() {
    return Center(
      child: SizedBox(
        width: _width,
        height: _height! / 4,
        child: CupertinoDatePicker(
          key: UniqueKey(),
          mode: CupertinoDatePickerMode.time,
          initialDateTime: initialTime,
          onDateTimeChanged: (DateTime newDateTime) {
            _setTime = formatDate(
                DateTime(2019, 08, 1, newDateTime.hour, newDateTime.minute),
                [hh, ':', nn, " ", am]).toString();
            var newTod = TimeOfDay.fromDateTime(newDateTime);
            // _updateTimeFunction(newTod);
          },
          use24hFormat: false,
        ),
      ),
    );
    // Center(
    //   child: InkWell(
    //     onTap: () {
    //       _selectTime(context);
    //     },
    //     child: Container(
    //       margin: EdgeInsets.only(top: 30),
    //       width: _width! / 1.7,
    //       height: _height! / 9,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(color: Colors.grey[200]),
    //       child: TextFormField(
    //         style: TextStyle(fontSize: 40),
    //         textAlign: TextAlign.center,
    //         onSaved: (String? val) {
    //           _setTime = val;
    //         },
    //         enabled: false,
    //         keyboardType: TextInputType.text,
    //         controller: _timeController,
    //         decoration: InputDecoration(
    //             disabledBorder:
    //                 UnderlineInputBorder(borderSide: BorderSide.none),
    //             // labelText: 'Time',
    //             contentPadding: EdgeInsets.all(5)),
    //       ),
    //     ),
    //   ),
    // ),
  }

  buildButtons(String title, func, Color clr) {
    return Expanded(
      child: GestureDetector(
        onTap: func,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: clr,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontFamily: kFontMedium,
                color: gWhiteColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }

  buildTimeList() {
    return   timeList.isEmpty
        ? const SizedBox()
        : Expanded(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: timeList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding:  EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Reminder ${index + 1} : ${timeList[index].time}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.sp,
                          height: 1.5,
                          fontFamily: kFontMedium,
                          color: gTextColor),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectTime(context);
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Icon(
                      Icons.edit,
                      color: gBlackColor,
                      size: 2.h,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        timeList.removeAt(index);
                      });
                      saveIntoSp();
                    },
                    child: Icon(
                      Icons.delete,
                      color: gBlackColor,
                      size: 2.h,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
    //   Consumer<DrinkWaterController>(
    //   builder: (_, data, __) {
    //     data.selectedTimeList.forEach((element) {
    //       print(element);
    //     });
    //     print("Time: ${data.addTime}");
    //
    //     if (data.addTime == "") {
    //       return const SizedBox();
    //     } else {
    //       return Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
    //         child: ListView.builder(
    //           scrollDirection: Axis.vertical,
    //           physics: const ScrollPhysics(),
    //           shrinkWrap: true,
    //           itemCount: data.selectedTimeList.length,
    //           itemBuilder: ((context, index) {
    //             return data.addTime.isEmpty
    //                 ? const SizedBox()
    //                 : Row(
    //                     children: [
    //                       Expanded(
    //                         child: Text(
    //                           "Reminder ${index + 1} : ${data.selectedTimeList[index]}",
    //                           maxLines: 1,
    //                           overflow: TextOverflow.ellipsis,
    //                           style: TextStyle(
    //                               fontSize: 11.sp,
    //                               height: 1.5,
    //                               fontFamily: kFontMedium,
    //                               color: gTextColor),
    //                         ),
    //                       ),
    //                       GestureDetector(
    //                         onTap: () {
    //                           _selectTime(context);
    //                         },
    //                         child: Icon(
    //                           Icons.edit,
    //                           color: gBlackColor,
    //                           size: 2.h,
    //                         ),
    //                       ),
    //                       SizedBox(width: 2.w),
    //                       GestureDetector(
    //                         onTap: () {},
    //                         child: Icon(
    //                           Icons.delete,
    //                           color: gBlackColor,
    //                           size: 2.h,
    //                         ),
    //                       ),
    //                     ],
    //                   );
    //           }),
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}

class TimeProgress {
  String time;
  TimeProgress({required this.time});
}
