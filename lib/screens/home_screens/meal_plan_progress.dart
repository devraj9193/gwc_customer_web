import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;

import '../../../model/error_model.dart';
import '../../../repository/api_service.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../../model/home_model/graph_list_model.dart';
import '../../repository/home_repo/home_repository.dart';
import '../../services/home_service/home_service.dart';

class MealPlanProgress extends StatefulWidget {
  const MealPlanProgress({Key? key}) : super(key: key);

  @override
  State<MealPlanProgress> createState() => _MealPlanProgressState();
}

class _MealPlanProgressState extends State<MealPlanProgress> {
  String selectedDetoxDay = "1";
  String selectedHealingDay = "1";
  bool isLoading = false;
  bool isError = false;
  String errorText = '';

  int days = 1;

  List<double> detoxGraph = [];
  List<double> healingGraph = [];

  GraphListModel? graphListModel;
  ZoomPanBehavior? _zoomDetoxPanBehavior;
  ZoomPanBehavior? _zoomHealingPanBehavior;
  TooltipBehavior? _tooltipDetoxBehavior;
  TooltipBehavior? _tooltipHealingBehavior;

  getGraphDetails() async {
    setState(() {
      isLoading = true;
    });
    final res = await HomeService(repository: repository).getGraphService();

    if (res.runtimeType == ErrorModel) {
      final model = res as ErrorModel;
      setState(() {
        isLoading = false;
        isError = true;
        errorText = model.message ?? '';
      });
    } else {
      final model = res as GraphListModel;
      detoxGraph = model.detoxDayWiseProgress!;
      healingGraph = model.healingDayWiseProgress!;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _zoomDetoxPanBehavior = ZoomPanBehavior(
        enableSelectionZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        enablePanning: true);
    _zoomHealingPanBehavior = ZoomPanBehavior(
        enableSelectionZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        enablePanning: true);
    _tooltipDetoxBehavior = TooltipBehavior(enable: true);
    _tooltipHealingBehavior = TooltipBehavior(enable: true);
    getGraphDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 2.w, bottom: 1.h, top: 1.h),
              child: buildAppBar(
                () {
                  Navigator.pop(context);
                },
                showNotificationIcon: false,
                isBackEnable: true,
                showLogo: false,
                showChild: true,
                child: Text(
                  "Meal Progress",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: eUser().mainHeadingColor,
                    fontFamily: eUser().mainHeadingFont,
                    fontSize: eUser().mainHeadingFontSize,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: (isLoading)
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 25.h),
                        child: buildCircularIndicator(),
                      )
                    : view(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  view() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detox Progress",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: eUser().mainHeadingColor,
              fontFamily: eUser().mainHeadingFont,
              fontSize: eUser().userFieldLabelFontSize,
            ),
          ),
          buildDetoxProgress(),
          Text(
            "Healing Progress",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: eUser().mainHeadingColor,
              fontFamily: eUser().mainHeadingFont,
              fontSize: eUser().userFieldLabelFontSize,
            ),
          ),
          buildHealingProgress(),
          Text(
            "Measurements",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: eUser().mainHeadingColor,
              fontFamily: eUser().mainHeadingFont,
              fontSize: eUser().userFieldLabelFontSize,
            ),
          ),
          buildDetoxMeasurements(),
          buildHealingMeasurements(),
        ],
      ),
    );
  }

  final List<ChartData> chartData = [
    ChartData("Day 1", 35),
    ChartData("Day 2", 13),
    ChartData("Day 3", 34),
    ChartData("Day 4", 27),
    ChartData("Day 5", 60),
    ChartData("Day 6", 80),
    ChartData("Day 7", 97),
  ];

  buildDetoxProgress() {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: gBlackColor.withOpacity(0.1),
            offset: const Offset(2, 5),
            blurRadius: 10,
          )
        ],
      ),
      child: SfCartesianChart(
        palette: [
          const Color(0xff36A5F5),
          const Color(0xff36A5F5).withOpacity(0.3),
        ],
        zoomPanBehavior: _zoomDetoxPanBehavior,
        tooltipBehavior: _tooltipDetoxBehavior,
        primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            labelPlacement: LabelPlacement.onTicks),
        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 100,
            axisLine: const AxisLine(width: 1),
            // edgeLabelPlacement: EdgeLabelPlacement.shift,
            // labelFormat: '{value}°F',
            majorTickLines: const MajorTickLines(size: 0)),
        series: <ChartSeries>[
          SplineSeries<double, String>(
            dataSource: detoxGraph,
            enableTooltip: true,
            xValueMapper: (double graph, _) {
              return "Day ${detoxGraph.indexWhere((element) => element == graph) + 1}";
            },
            yValueMapper: (double graph, _) => graph,
            // markerSettings: const MarkerSettings(isVisible: true),
            // name: 'High',
          ),
        ],
      ),
    );
  }

  buildHealingProgress() {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: gBlackColor.withOpacity(0.1),
            offset: const Offset(2, 5),
            blurRadius: 10,
          )
        ],
      ),
      child: SfCartesianChart(
        palette: [
          const Color(0xff72F4A8),
          const Color(0xff72F4A8).withOpacity(0.3),
        ],
        zoomPanBehavior: _zoomHealingPanBehavior,
        tooltipBehavior: _tooltipHealingBehavior,
        primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            labelPlacement: LabelPlacement.onTicks),
        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 100,
            axisLine: const AxisLine(width: 1),
            // edgeLabelPlacement: EdgeLabelPlacement.shift,
            // labelFormat: '{value}°F',
            majorTickLines: const MajorTickLines(size: 0)),
        series: <ChartSeries>[
          SplineSeries<double, String>(
            dataSource: healingGraph,
            enableTooltip: true,
            xValueMapper: (double graph, _) {
              return "Day ${healingGraph.indexWhere((element) => element == graph) + 1}";
            },
            yValueMapper: (double graph, _) => graph,
            // markerSettings: const MarkerSettings(isVisible: true),
            // name: 'High',
          ),
        ],
      ),
    );
  }

  void changedDetoxIndex(String index) {
    setState(() {
      selectedDetoxDay = index;
      print("selectedDay : $selectedDetoxDay");
    });
  }

  void changedHealingIndex(String index) {
    setState(() {
      selectedHealingDay = index;
      print("selectedDay : $selectedHealingDay");
    });
  }

  buildDetoxMeasurements() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: PopupMenuButton(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              offset: const Offset(0, 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...dailyProgress
                          .map(
                            (e) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      changedDetoxIndex(e);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Day $e",
                                    style: TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().userFieldLabelFont,
                                      fontSize:
                                          eUser().userTextFieldHintFontSize,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  height: 1,
                                  color: gGreyColor.withOpacity(0.3),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "Day $selectedDetoxDay",
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().userFieldLabelFont,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    Icon(
                      Icons.expand_more,
                      color: gGreyColor,
                      size: 3.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          GridView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 30,
              mainAxisExtent: 30.h,
            ),
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gBlackColor.withOpacity(0.1),
                      offset: const Offset(2, 5),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Text(
                      "Detox Followed",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().userFieldLabelFont,
                        fontSize: eUser().userFieldLabelFontSize,
                      ),
                    ),
                    Container(
                      height: 20.h,
                      margin: EdgeInsets.only(top: 5.h),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            interval: 10,
                            startAngle: 270,
                            endAngle: 270,
                            showTicks: false,
                            showLabels: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 5,
                              color: const Color(0xff72F4A8).withOpacity(0.3),
                            ),
                            pointers: const <GaugePointer>[
                              RangePointer(
                                value: 90,
                                width: 10,
                                color: Color(0xff72F4A8),
                                enableAnimation: true,
                                // cornerStyle: CornerStyle.bothCurve,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'IBS',
                                        style: TextStyle(
                                          color: const Color(0xff72F4A8),
                                          fontFamily:
                                              eUser().userFieldLabelFont,
                                          fontSize: eUser().mainHeadingFontSize,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        '168',
                                        style: TextStyle(
                                          color: eUser().mainHeadingColor,
                                          fontFamily: eUser().userTextFieldFont,
                                          fontSize: eUser().mainHeadingFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  angle: 270,
                                  positionFactor: 0.1)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gBlackColor.withOpacity(0.1),
                      offset: const Offset(2, 5),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Text(
                      "Detox UnFollowed",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().userFieldLabelFont,
                        fontSize: eUser().userFieldLabelFontSize,
                      ),
                    ),
                    Container(
                      height: 20.h,
                      margin: EdgeInsets.only(top: 5.h),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            interval: 10,
                            startAngle: 0,
                            endAngle: 360,
                            showTicks: false,
                            showLabels: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 5,
                              color: const Color(0xff36A5F5).withOpacity(0.3),
                            ),
                            pointers: const <GaugePointer>[
                              RangePointer(
                                value: 73,
                                width: 10,
                                color: Color(0xff36A5F5),
                                enableAnimation: true,
                                // cornerStyle: CornerStyle.bothCurve,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pro',
                                        style: TextStyle(
                                          color: const Color(0xff36A5F5),
                                          fontFamily:
                                              eUser().userFieldLabelFont,
                                          fontSize: eUser().mainHeadingFontSize,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        '3428.5',
                                        style: TextStyle(
                                          color: eUser().mainHeadingColor,
                                          fontFamily: eUser().userTextFieldFont,
                                          fontSize: eUser().mainHeadingFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  angle: 270,
                                  positionFactor: 0.1)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<String> dailyProgress = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    // "8",
    // "9",
    // "10",
    // "11",
    // "12",
    // "13",
    // "14",
    // "15",
  ];


  buildHealingMeasurements() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: PopupMenuButton(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              offset: const Offset(0, 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...dailyProgress
                          .map(
                            (e) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      changedHealingIndex(e);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Day $e",
                                    style: TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().userFieldLabelFont,
                                      fontSize:
                                          eUser().userTextFieldHintFontSize,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  height: 1,
                                  color: gGreyColor.withOpacity(0.3),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "Day $selectedHealingDay",
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().userFieldLabelFont,
                        fontSize: eUser().userTextFieldHintFontSize,
                      ),
                    ),
                    Icon(
                      Icons.expand_more,
                      color: gGreyColor,
                      size: 3.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          GridView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 30,
              mainAxisExtent: 30.h,
            ),
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gBlackColor.withOpacity(0.1),
                      offset: const Offset(2, 5),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Text(
                      "Healing Followed",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().userFieldLabelFont,
                        fontSize: eUser().userFieldLabelFontSize,
                      ),
                    ),
                    Container(
                      height: 20.h,
                      margin: EdgeInsets.only(top: 5.h),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            interval: 10,
                            startAngle: 0,
                            endAngle: 360,
                            showTicks: false,
                            showLabels: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 5,
                              color: const Color(0xffF3B531).withOpacity(0.3),
                            ),
                            pointers: const <GaugePointer>[
                              RangePointer(
                                value: 73,
                                width: 10,
                                color: Color(0xffF3B531),
                                enableAnimation: true,
                                // cornerStyle: CornerStyle.bothCurve,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'IBS',
                                        style: TextStyle(
                                          color: const Color(0xffF3B531),
                                          fontFamily:
                                              eUser().userFieldLabelFont,
                                          fontSize: eUser().mainHeadingFontSize,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        '168',
                                        style: TextStyle(
                                          color: eUser().mainHeadingColor,
                                          fontFamily: eUser().userTextFieldFont,
                                          fontSize: eUser().mainHeadingFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  angle: 270,
                                  positionFactor: 0.1)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3.h),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gBlackColor.withOpacity(0.1),
                      offset: const Offset(2, 5),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Text(
                      "Healing UnFollowed",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().userFieldLabelFont,
                        fontSize: eUser().userFieldLabelFontSize,
                      ),
                    ),
                    Container(
                      height: 20.h,
                      margin: EdgeInsets.only(top: 5.h),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            interval: 10,
                            startAngle: 0,
                            endAngle: 360,
                            showTicks: false,
                            showLabels: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 5,
                              color: const Color(0xff934CDF).withOpacity(0.3),
                            ),
                            pointers: const <GaugePointer>[
                              RangePointer(
                                value: 73,
                                width: 10,
                                color: Color(0xff934CDF),
                                enableAnimation: true,
                                // cornerStyle: CornerStyle.bothCurve,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pro',
                                        style: TextStyle(
                                          color: const Color(0xff934CDF),
                                          fontFamily:
                                              eUser().userFieldLabelFont,
                                          fontSize: eUser().mainHeadingFontSize,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        '3428.5',
                                        style: TextStyle(
                                          color: eUser().mainHeadingColor,
                                          fontFamily: eUser().userTextFieldFont,
                                          fontSize: eUser().mainHeadingFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  angle: 270,
                                  positionFactor: 0.1)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final HomeRepository repository = HomeRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}

class ChartData {
  ChartData(this.x, this.y);
  final String? x;
  final int? y;
}
