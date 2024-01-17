import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

import '../../../model/error_model.dart';
import '../../../model/post_program_model/post_program_new_model/protocol_calendar_model.dart';
import '../../../model/post_program_model/protocol_guide_day_score.dart';
import '../../../repository/api_service.dart';
import '../../../repository/post_program_repo/post_program_repository.dart';
import '../../../services/post_program_service/post_program_service.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../pp_calendar.dart';
import '../protcol_guide_details.dart';
import 'day_breakfast.dart';
import 'pp_redeem_rewards_popuop.dart';


class PPLevelsDemo extends StatefulWidget {
  const PPLevelsDemo({Key? key}) : super(key: key);

  @override
  State<PPLevelsDemo> createState() => _PPLevelsDemoState();
}

class _PPLevelsDemoState extends State<PPLevelsDemo> {

  String protocolGuidePdfLink = '';

  bool isError = false;
  String errorText = '';
  bool isLoading = false;

  String? currentDay;

  List<ProtocolCalendar> protocolData = [];


  Future getPPCalendar() async {
    setState(() {
      isLoading = true;
    });
    final res = await PostProgramService(repository: repository).getPPDayCalenderService();

    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      setState(() {
        isLoading = false;
        isError = true;
        errorText = model.message ?? '';
      });
    }
    else{
      final model = res as ProtocolCalendarModel;
      protocolData.clear();
      protocolData = model.protocolCalendar!;
      print(protocolData.length);
      protocolData.forEach((element) {
        print(element.toJson());
      });

      setState(() {
        isLoading = false;
        currentDay = model.presentDay;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPPCalendar();
    getPPGuidePdfLink();
  }

  getPPGuidePdfLink() async{
    final res = await PostProgramService(repository: repository).getProtocolDayDetailsService();

    if(res.runtimeType != ErrorModel){
      ProtocolGuideDayScoreModel model = res as ProtocolGuideDayScoreModel;
      protocolGuidePdfLink = model.protocolGuidePdf ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:const Color(0xffFAFAFA),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 2.h,
                          child: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios,
                              color: gMainColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          height: 7.h,
                          child: const Image(
                            image: AssetImage("assets/images/Gut welness logo.png"),
                          ),
                          //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PPCalendar(),
                              ),
                            );
                          },
                          child: Image(
                            image: const AssetImage(
                                "assets/images/gmg/noun-calendar-5347015.png"),
                            height: 2.7.h,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                  opaque: false, // set to false
                                  pageBuilder: (_, __, ___) => Container(
                                    child: PPRewardsPopup(),
                                    // width: 70,
                                    // height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                                      ],
                                    ),
                                  )),
                            );
                          },
                          child: Image(
                            image: const AssetImage(
                                "assets/images/gmg/noun-percentage-3119037.png"),
                            height: 3.h,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProtocolGuideDetails(pdfLink: protocolGuidePdfLink,),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 3.5.h,
                            child: Lottie.asset('assets/lottie/alert.json'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  "Gut Maintenance  Indicator",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: kFontBold,
                      color: gPrimaryColor,
                      fontSize: 10.sp),
                ),
              ),
              SizedBox(height: 1.5.h),
              Expanded(
                child: (protocolData.isEmpty) ? (isError) ? Center(child: Text(errorText),)
                    : Center(child: buildCircularIndicator(),) :
                Container(
                  height: 100.h,
                  width: 100.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      presentDayProgress(),
                      SizedBox(
                        height: 5.h,
                      ),
                      Expanded(child: showFiveDays()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showFiveDays(){
    return SingleChildScrollView(
      child: SizedBox(
        child: Center(
          child: Wrap(
            children: [
              ...protocolData.map((e) => remainingDays(e)
              ).toList()
            ],
          ),
        ),
      ),
    );
    return Flexible(child: remainingDays(protocolData[0]));
  }

  newLevels1(){
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          presentDayProgress(),
          // Flexible(child: remainingDays())
        ],
      ),
    );
  }

  presentDayProgress() {
    return bigCircle();
  }

  remainingDays(ProtocolCalendar calender) {
    return Container(
      height: 9.h,
      // height: (no == 0) ? 70 : 9.h,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: smallCircle(calender),
    );
  }

  bigCircle(){
    return Center(
      child: SizedBox(
        height: 75.w,
        width: 75.w,
        child: LiquidCircularProgressIndicator(
          value: 0.02, // Defaults to 0.5.
          valueColor: AlwaysStoppedAnimation(presentDayColor), // Defaults to the current Theme's accentColor.
          backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
          borderColor: Colors.red,
          borderWidth: 8.0,
          direction: Axis.vertical,
          // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(currentDay ?? '',
                style: TextStyle(
                    fontFamily: kFontBold,
                    color: gsecondaryColor,
                    fontSize: 22.sp),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Present Day",
                  style: TextStyle(
                      fontFamily: kFontBook,
                      color: gsecondaryColor,
                      fontSize: 10.sp
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  smallCircle(ProtocolCalendar calender){
    return Visibility(
      visible: calender.day.toString() != currentDay,
      child: GestureDetector(
        onTap: () {
          print(calender.day);
          Navigator.push(context, MaterialPageRoute(builder: (_) => PPDailyTasksUI(day: calender.day.toString(),)));
        },
        child: SizedBox(
          width: 7.6.h,
          height: 7.6.h,
          // width: (no == 0) ? 60 : 7.6.h,
          // height: (no == 0) ? 60 : 7.6.h,
          child: LiquidCircularProgressIndicator(
            value: setWaterLevel(calender), // Defaults to 0.5.
            valueColor: AlwaysStoppedAnimation((calender.day.toString() == currentDay) ? presentDayColor : setWaterColor(calender)), // Defaults to the current Theme's accentColor.
            backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
            borderColor: Colors.red,
            borderWidth: 2.5,
            direction: Axis.vertical,
            // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
            center: Center(child: Text(
                (calender.day.toString().length == 1) ? "Day\n 0${calender.day.toString()}" : "Day\n  ${calender.day.toString()}",
              style: TextStyle(
                  fontFamily: kFontBold,
                  color: gPrimaryColor,
                  fontSize: 10.sp),
            )
            ),

          ),
        ),
      ),
    );
    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     SizedBox(
    //       width: 60,
    //       height: 60,
    //       child: LiquidCircularProgressIndicator(
    //         value: 0.25, // Defaults to 0.5.
    //         valueColor: AlwaysStoppedAnimation(Colors.pink), // Defaults to the current Theme's accentColor.
    //         backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
    //         borderColor: Colors.red,
    //         borderWidth: 2.5,
    //         direction: Axis.vertical,
    //         // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
    //         center: Center(child: Text("Day\n 01")),
    //       ),
    //     ),
    //     SizedBox(
    //       width: 5,
    //     )
    //   ],
    // );
  }



  PostProgramRepository repository = PostProgramRepository(
      apiClient: ApiClient(
          httpClient: http.Client()
      )
  );

  setWaterLevel(ProtocolCalendar calender) {
    if(calender.score == "1"){
      return 0.93;
    }
    else if(calender.score == "2"){
      return 0.75;
    }
    else if(calender.score == "3"){
      return 0.5;
    }
    else if(calender.score == "4" || calender.score!.isEmpty){
      return 0.1;
    }

  }

  Color setWaterColor(ProtocolCalendar calender) {
    if(calender.score == "1"){
      return greenColor;
    }
    else if(calender.score == "2"){
      return yellowColor;
    }
    else if(calender.score == "3"){
      return redColor;
    }
    else if(calender.score == "4" || calender.score!.isEmpty){
      return skipColor;
    }
    return presentDayColor;
  }

  final greenColor = Color(0xff4E7215);
  final yellowColor = Color(0xffC7A102);
  final redColor = Color(0xffD10034);
  final skipColor = Color(0xff707070);
  final presentDayColor = Color(0xffB3B3B3);


}
