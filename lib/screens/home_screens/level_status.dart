/*
now r showing coming soon ui
 */

import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:sizer/sizer.dart';
import '../../model/home_model/home_model.dart';
import '../../repository/api_service.dart';
import '../../repository/home_repo/home_repository.dart';
import '../../services/home_service/home_service.dart';
import '../../widgets/comingsoon_widget.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../appointment_screens/consultation_screens/medical_report_details.dart';
import '../appointment_screens/consultation_screens/upload_files.dart';
import '../cook_kit_shipping_screens/cook_kit_tracking.dart';
import '../evalution_form/evaluation_get_details.dart';
import 'common_widget.dart';
import 'package:vertical_percent_indicator/vertical_percent_indicator.dart';
import 'package:http/http.dart' as http;

class LevelStatus extends StatefulWidget {
  const LevelStatus({Key? key}) : super(key: key);

  @override
  State<LevelStatus> createState() => _LevelStatusState();
}

class _LevelStatusState extends State<LevelStatus> {
  List data = [
    22.22,
    32.33,
    10.00,
    100.00,
    77.77,
    55.05,
    77.08,
    66.09,
    99.99,
    10.00,
  ];

  List dailyProgress = [
    1,2,3,4,5,6,7,8,9,10
  ];

  List status = [1, 2, 3, 4, 5, 6, 7];

  Future? levelFuture;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getHomeData();
  }

  getHomeData() async{
    levelFuture = HomeService(repository: repository).getHomeDetailsService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
            future: levelFuture,
            builder: (_, snapshot){
              return Center(
                child: ComingSoonWidget(imagePath: "assets/images/new_ds/coming_soon.json"),
              );
              // if(snapshot.connectionState == ConnectionState.done){
              //   if(snapshot.hasData){
              //     if(snapshot.data is ErrorModel){
              //       final model = snapshot.data as ErrorModel;
              //       print(model.message);
              //     }
              //     else{
              //       final model = snapshot.data as HomeScreenModel;
              //       addData(model);
              //       return showUI(model);
              //     }
              //   }
              //   else if(snapshot.hasError){
              //     final model = snapshot.data as ErrorModel;
              //     print(model.message);
              //   }
              //   else{
              //     return SizedBox();
              //   }
              // }
              // return buildCircularIndicator();
            },
          )
      ),
    );
  }

  int selectedIndex = 0;

  String selectedStage = '';

  showUI(HomeScreenModel model){
    return Container(
      color: gPrimaryColor,
      child: Column(
        children: [
          buildPercentage(),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                  right: 3.w, top: 3.h, left: 3.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    (l[selectedIndex] is Evaluation) ? buildEvaluationDone(l[selectedIndex] as Evaluation) :
                    (l[selectedIndex] is Consultation && (l[selectedIndex] as Consultation).consultationStatus == 'Consultation Booked') ? buildConsultationBooked(l[selectedIndex] as Consultation) :
                    (l[selectedIndex] is Consultation && (l[selectedIndex] as Consultation).consultationStatus == 'Consultation Done') ? buildConsultationDone(l[selectedIndex] as Consultation) :
                    (l[selectedIndex] is Tracker && (l[selectedIndex] as Tracker).trackerStatus == 'Shipment Delivered') ? buildTracker(l[selectedIndex] as Tracker) :
                    (l[selectedIndex] is Tracker && (l[selectedIndex] as Tracker).trackerStatus == 'Shipment Approved') ? buildTracker(l[selectedIndex] as Tracker) :
                    (l[selectedIndex] is Program && (l[selectedIndex] as Program).programStatus == 'Start Program') ? buildMealPlan(l[selectedIndex] as Program) :
                    (l[selectedIndex] is PostConsultation && (l[selectedIndex] as PostConsultation).consultationStatus == '') ? buildPPBooked(l[selectedIndex] as PostConsultation) :
                    (l[selectedIndex] is ProtocolGuide && (l[selectedIndex] as ProtocolGuide).consultationStatus == 'Protocol Guide') ? buildPPConsultation(l[selectedIndex] as ProtocolGuide) : SizedBox(child: Text(showName() ?? ''),)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildPercentage({String? title, String? percent}) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.h, bottom: 3.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            showName() ?? "",
            style: TextStyle(
              fontFamily: "GothamBook",
              color: gWhiteColor,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (selectedIndex == 0) ? null : () {
                  String stage = '';
                  if(selectedIndex != 0){
                    selectedIndex--;
                    if(l[selectedIndex] is Evaluation){
                      Evaluation e = l[selectedIndex];
                      stage = e.evaluationStatus!;
                    }
                    else if(l[selectedIndex] is Consultation){
                      Consultation c = l[selectedIndex];
                      stage = c.consultationStatus!;
                    }
                    else if(l[selectedIndex] is Tracker){
                      Tracker t = l[selectedIndex];
                      stage = t.trackerStatus!;
                    }
                    else if(l[selectedIndex] is PostConsultation){
                      PostConsultation pp = l[selectedIndex];
                      stage = pp.consultationStatus!;
                    }
                    else if(l[selectedIndex] is ProtocolGuide){
                      ProtocolGuide pg = l[selectedIndex];
                      stage = pg.consultationStatus!;
                    }
                  }
                  setState(() {
                    selectedStage = stage;
                  });
                },
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: (selectedIndex == 0) ? gHintTextColor : gWhiteColor.withOpacity(0.7),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: gBlackColor,
                      offset: Offset(2, 5),
                    ),
                  ],
                ),
                child: SimpleCircularProgressBar(
                    size: 100,
                    startAngle: 100,
                    progressStrokeWidth: 3,
                    valueNotifier: ValueNotifier(double.parse(showCompletedPercent()!.replaceAll('%', '').replaceAll('Complete', ''))),
                    backColor: gPrimaryColor.withOpacity(0.1),
                    progressColors: const [gPrimaryColor, gPrimaryColor],
                    onGetText: (double value) {
                      return Text(
                        showCompletedPercent() ??
                            "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1,
                          fontFamily: "GothamBook",
                          color: gMainColor,
                          fontSize: 10.sp,
                        ),
                      );
                    }),
              ),
              GestureDetector(
                onTap: (selectedIndex == l.length-1) ? null : () {
                  print(double.parse(showCompletedPercent()!.replaceAll('%', '').replaceAll('Complete', '')));
                  print('$selectedIndex  ${l.length-1}');
                  if(selectedIndex != l.length-1){
                    selectedIndex++;
                    print(l[selectedIndex] is Consultation);
                    if(l[selectedIndex] is Consultation){
                      Consultation c = l[selectedIndex];
                      selectedStage = c.consultationStatus!;
                    }
                    else if(l[selectedIndex] is Tracker){
                      Tracker t = l[selectedIndex];
                      selectedStage = t.trackerStatus!;
                    }
                    else if(l[selectedIndex] is PostConsultation){
                      PostConsultation pp = l[selectedIndex];
                      selectedStage = pp.consultationStatus!;
                    }
                    else if(l[selectedIndex] is ProtocolGuide){
                      ProtocolGuide pg = l[selectedIndex];
                      selectedStage = pg.consultationStatus!;
                    }
                  }
                  print(selectedStage);
                  setState(() {

                  });

                },
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: (selectedIndex == l.length-1) ? gHintTextColor : gWhiteColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildEvaluationDone(Evaluation eval) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets(
          points: eval.rewardPoints?.point ?? '',
          value1: '50',
          value2: '40',
          value3: '30',
          value4: '20',
          comments: eval.text ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
        ),
        Text(
          "Evaluation",
          style: TextStyle(
              fontFamily: "GothamMedium",
              color: gPrimaryColor,
              fontSize: 11.sp),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          decoration: BoxDecoration(
            color: gBlackColor.withOpacity(0.01),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EvaluationGetDetails(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage("assets/images/Group 3776.png"),
                      height: 4.h,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "View Evaluation",
                        style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gBlackColor,
                            fontSize: 9.sp
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: gMainColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.h),
                width: double.maxFinite,
                height: 1,
                color: gHintTextColor,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UploadFiles(isFromSettings: true,),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage("assets/images/Group 3828.png"),
                      height: 4.h,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "View Report",
                        style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gBlackColor,
                            fontSize: 9.sp),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: gMainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildConsultationBooked(Consultation c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets(
          points: c.rewardPoints?.point ?? '',
          value1: '50',
          value2: '40',
          value3: '30',
          value4: '20',
          comments: c.text ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
        ),
        Text(
          "Consultation Booked",
          style: TextStyle(
              fontFamily: "GothamMedium",
              color: gPrimaryColor,
              fontSize: 11.sp),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: gBlackColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Your Slot Has Been Booked @ ",
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 11.sp,
                    fontFamily: "GothamBook",
                    color: gBlackColor,
                  ),
                ),
                TextSpan(
                  text: c.bookedStage?.slotStartTime ?? "",
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                    color: gBlackColor,
                  ),
                ),
                TextSpan(
                  text: " on the ",
                  style: TextStyle(
                    fontSize: 11.sp,
                    height: 1.5,
                    fontFamily: "GothamBook",
                    color: gBlackColor,
                  ),
                ),
                TextSpan(
                  text: c.bookedStage?.date ??  "",
                  style: TextStyle(
                    fontSize: 11.sp,
                    height: 1.5,
                    fontFamily: "GothamMedium",
                    color: gBlackColor,
                  ),
                ),
                TextSpan(
                  text: ", Has Been Confirmed",
                  style: TextStyle(
                    fontSize: 11.sp,
                    height: 1.5,
                    fontFamily: "GothamBook",
                    color: gBlackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
          },
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: gMainColor, width: 1),
            ),
            child: Center(
              child: Text(
                'Join',
                style: TextStyle(
                  fontFamily: "GothamBold",
                  color: gsecondaryColor,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildConsultationDone(Consultation c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets(
          points: c.rewardPoints?.point ?? '01Pts',
          value1: '50',
          value2: '40',
          value3: '30',
          value4: '20',
          comments: c.text ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
        ),
        Text(
          "Consultation Done",
          style: TextStyle(
              fontFamily: "GothamMedium",
              color: gPrimaryColor,
              fontSize: 11.sp),
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 2.h),
        //   padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         colors: [gSecondaryColor, gWhiteColor.withOpacity(1)],
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomRight),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Text(
        //     "Your Consultation has been rejected our success team will get back to you soon",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       height: 1.5,
        //         fontFamily: "GothamBook",
        //         color: gWhiteColor,
        //         fontSize: 11.sp),
        //   ),
        // ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.h),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff5CAf33), gWhiteColor.withOpacity(1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "You Have Successfully Completed Your Consultation",
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.5,
                fontFamily: "GothamBook",
                color: gWhiteColor,
                fontSize: 11.sp),
          ),
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 1.h),
        //   padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
        //   decoration: BoxDecoration(
        //     color: gBlackColor.withOpacity(0.05),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: RichText(
        //     textAlign: TextAlign.center,
        //     text: TextSpan(
        //       children: <TextSpan>[
        //         TextSpan(
        //           text: "Your Slot Has Been Booked @ ",
        //           style: TextStyle(
        //             height: 1.5,
        //             fontSize: 11.sp,
        //             fontFamily: "GothamBook",
        //             color: gBlackColor,
        //           ),
        //         ),
        //         TextSpan(
        //           text: "11:00 AM",
        //           style: TextStyle(
        //             height: 1.5,
        //             fontSize: 11.sp,
        //             fontFamily: "GothamMedium",
        //             color: gBlackColor,
        //           ),
        //         ),
        //         TextSpan(
        //           text: " on the ",
        //           style: TextStyle(
        //             fontSize: 11.sp,
        //             height: 1.5,
        //             fontFamily: "GothamBook",
        //             color: gBlackColor,
        //           ),
        //         ),
        //         TextSpan(
        //           text: "28th March 2022",
        //           style: TextStyle(
        //             fontSize: 11.sp,
        //             height: 1.5,
        //             fontFamily: "GothamMedium",
        //             color: gBlackColor,
        //           ),
        //         ),
        //         TextSpan(
        //           text: ", Has Been Confirmed",
        //           style: TextStyle(
        //             fontSize: 11.sp,
        //             height: 1.5,
        //             fontFamily: "GothamBook",
        //             color: gBlackColor,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MedicalReportDetails(pdfLink: c.mr_report ?? '',),
              ),
            );
          },
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: gMainColor, width: 1),
            ),
            child: Center(
              child: Text(
                'View MR Report',
                style: TextStyle(
                  fontFamily: "GothamBold",
                  color: gsecondaryColor,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildTracker(Tracker t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets(
          points: t.rewardPoints?.toString() ?? '01Pts',
          value1: '50',
          value2: '40',
          value3: '30',
          value4: '20',
          comments:t.text ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
        ),
        Text(
          "Tracker",
          style: TextStyle(
              fontFamily: "GothamMedium",
              color: gPrimaryColor,
              fontSize: 11.sp),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          decoration: BoxDecoration(
            color: gBlackColor.withOpacity(0.01),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CookKitTracking(
                        awb_number:  '',
                        currentStage: '',
                        initialIndex: 1,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage("assets/images/Pop up.png"),
                      height: 4.h,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "Shopping List Evaluation",
                        style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gBlackColor,
                            fontSize: 9.sp),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: gMainColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.h),
                width: double.maxFinite,
                height: 1,
                color: gHintTextColor,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CookKitTracking(
                        awb_number:  '',
                        currentStage: '',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage("assets/images/G.png"),
                      height: 4.h,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "Shipping Tracker",
                        style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gBlackColor,
                            fontSize: 9.sp),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: gMainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildMealPlan(Program p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets(
          points: p.rewardPoints ?? '01Pts',
          value1: '50',
          value2: '40',
          value3: '30',
          value4: '20',
          comments:p.text ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
        ),
        Text(
          "Meal Plan",
          style: TextStyle(
              fontFamily: "GothamMedium",
              color: gPrimaryColor,
              fontSize: 11.sp),
        ),
        Container(
          height: 15.h,
          width: double.maxFinite,
          //  margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: gBlackColor.withOpacity(0.01),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: ((context, index) {
              double y = data[index] / 100.toDouble();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: VerticalBarIndicator(
                  width: 5.w,
                  height: 10.h,
                  footerStyle: TextStyle(
                      fontSize: 8.sp,
                      fontFamily: "GothamMedium",
                      color: gPrimaryColor),
                  footer: "Day${dailyProgress[index]}",
                  animationDuration: const Duration(seconds: 1),
                  circularRadius: 0,
                  percent: buildBar(y),
                  color: buildTextColor(y),
                ),
              );
            }),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          decoration: BoxDecoration(
            color: gBlackColor.withOpacity(0.01),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Image(
                image: const AssetImage("assets/images/Pop up.png"),
                height: 4.h,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  "View Present Day MealPlan",
                  style: TextStyle(
                      fontFamily: "GothamBook",
                      color: gBlackColor,
                      fontSize: 9.sp),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: gMainColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildPPBooked(PostConsultation pp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets(
          points: pp.rewardPoints?.toString() ?? '01Pts',
          value1: '50',
          value2: '40',
          value3: '30',
          value4: '20',
          comments: pp.text ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
        ),
        Visibility(
          visible: !pp.consultationPercentage!.contains('0%'),
          child: Text(
            "PP Consultation Booked",
            style: TextStyle(
                fontFamily: "GothamMedium",
                color: gPrimaryColor,
                fontSize: 11.sp),
          ),
        ),
        Visibility(
          visible: !pp.consultationPercentage!.contains('0%'),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: gBlackColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Your Slot Has Been Booked @ ",
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 11.sp,
                      fontFamily: "GothamBook",
                      color: gPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text: "11:00 AM",
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 11.sp,
                      fontFamily: "GothamMedium",
                      color: gPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text: " on the ",
                    style: TextStyle(
                      fontSize: 11.sp,
                      height: 1.5,
                      fontFamily: "GothamBook",
                      color: gPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text: "28th March 2022",
                    style: TextStyle(
                      fontSize: 11.sp,
                      height: 1.5,
                      fontFamily: "GothamMedium",
                      color: gPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text: ", Has Been Confirmed",
                    style: TextStyle(
                      fontSize: 11.sp,
                      height: 1.5,
                      fontFamily: "GothamBook",
                      color: gPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {},
        //   child: Container(
        //     width: double.maxFinite,
        //     padding: EdgeInsets.symmetric(vertical: 1.h),
        //     margin: EdgeInsets.symmetric(vertical: 2.h),
        //     decoration: BoxDecoration(
        //       color: gWhiteColor,
        //       borderRadius: BorderRadius.circular(8),
        //       border: Border.all(color: gMainColor, width: 1),
        //     ),
        //     child: Center(
        //       child: Text(
        //         'Join',
        //         style: TextStyle(
        //           fontFamily: "GothamBold",
        //           color: gSecondaryColor,
        //           fontSize: 13.sp,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  buildPPConsultation(ProtocolGuide pg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets(
          points: pg.rewardPoints?.toString() ?? '01Pts',
          value1: '50',
          value2: '40',
          value3: '30',
          value4: '20',
          comments: pg.text ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
        ),
        Text(
          "PP Consultation",
          style: TextStyle(
              fontFamily: "GothamMedium",
              color: gPrimaryColor,
              fontSize: 11.sp),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 13.h,
          width: double.maxFinite,
          //  margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: gBlackColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(8),
          ),
          child: (pg.consultationPercentage!.contains('0%')) ? Image.asset('assets/images/day graph.png') : ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: ((context, index) {
              double y = data[index] / 100.toDouble();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: VerticalBarIndicator(
                  width: 5.w,
                  height: 8.h,
                  footerStyle: TextStyle(
                      fontSize: 8.sp,
                      fontFamily: "GothamMedium",
                      color: gPrimaryColor),
                  footer: "Day${dailyProgress[index]}",
                  animationDuration: const Duration(microseconds: 5000),
                  circularRadius: 0,
                  percent: buildBar(y),
                  color: buildTextColor(y),
                ),
              );
            }),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          decoration: BoxDecoration(
            color: gBlackColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Image(
                image: const AssetImage("assets/images/Pop up.png"),
                height: 4.h,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  "View Present Day MealPlan",
                  style: TextStyle(
                      fontFamily: "GothamBook",
                      color: gBlackColor,
                      fontSize: 9.sp),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: gMainColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildTextColor(double value) {
    if (0.3 > value) {
      return [gsecondaryColor, gsecondaryColor];
    } else if (0.6 > value) {
      return [gMainColor, gMainColor];
    } else if (1.0 >= value) {
      return [gPrimaryColor, gPrimaryColor];
    }
  }

  buildCenterText(double data) {
    if (100 < data) {
      return Text(
        "100 %",
        style: TextStyle(
            fontSize: 8.sp, fontFamily: "GothamBook", color: gMainColor),
      );
    } else {
      return Text(
        "${data.toStringAsFixed(2)} %",
        style: TextStyle(
            fontSize: 8.sp, fontFamily: "GothamBook", color: gMainColor),
      );
    }
  }

  buildBar(double y) {
    if (1.0 < y) {
      return 1.0;
    } else {
      return y;
    }
  }

  final HomeRepository repository = HomeRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  List l = [];
  void addData(HomeScreenModel model) {
    l.clear();
    model.evaluation!.forEach((element) {
      l.add(element);
    });
    model.consultation!.reversed.forEach((element) {
      l.add(element);
    });
    model.tracker!.forEach((element) {
      l.add(element);
    });
    model.postConsultation!.forEach((element) {
      l.add(element);
    });
    model.protocolGuide!.forEach((element) {
      l.add(element);
    });
    selectedStage = 'Evaluation';
  }

  String? showName() {
    if(l[selectedIndex] is Evaluation){
      return (l[selectedIndex] as Evaluation).evaluationStatus;
    }
    else if(l[selectedIndex] is Consultation){
      return (l[selectedIndex] as Consultation).consultationStatus;
    }
    else if(l[selectedIndex] is Tracker){
      return (l[selectedIndex] as Tracker).trackerStatus;
    }
    else if(l[selectedIndex] is PostConsultation){
      return (l[selectedIndex] as PostConsultation).consultationStatus;
    }
    else if(l[selectedIndex] is ProtocolGuide){
      return (l[selectedIndex] as ProtocolGuide).consultationStatus;
    }
  }

  String? showCompletedPercent() {
    if(l[selectedIndex] is Evaluation){
      return '${(l[selectedIndex] as Evaluation).evaluationPercentage} \n Complete';
    }
    else if(l[selectedIndex] is Consultation){
      return '${(l[selectedIndex] as Consultation).consultationPercentage} \n Complete';
    }
    else if(l[selectedIndex] is Tracker){
      return '${(l[selectedIndex] as Tracker).trackerPercentage} \n Complete';
    }
    else if(l[selectedIndex] is PostConsultation){
      return '${(l[selectedIndex] as PostConsultation).consultationPercentage} \n Complete';
    }
    else if(l[selectedIndex] is ProtocolGuide){
      return '${(l[selectedIndex] as ProtocolGuide).consultationPercentage} \n Complete';
    }
  }

  String? showBottomText() {
    if(l[selectedIndex] is Evaluation){
      return (l[selectedIndex] as Evaluation).text;
    }
    else if(l[selectedIndex] is Consultation){
      return (l[selectedIndex] as Consultation).text;
    }
    else if(l[selectedIndex] is Tracker){
      return (l[selectedIndex] as Tracker).text;
    }
    else if(l[selectedIndex] is PostConsultation){
      return (l[selectedIndex] as PostConsultation).text;
    }
    else if(l[selectedIndex] is ProtocolGuide){
      return (l[selectedIndex] as ProtocolGuide).text;
    }
  }
}
