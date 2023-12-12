import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/screens/home_screens/water_intake/water_level_time.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../services/home_service/drink_water_controller.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../new_home_screen/home_widgets/drop_widget.dart';
import '../new_home_screen/home_widgets/shadow_text.dart';

class WaterLevelScreen extends StatelessWidget {
  WaterLevelScreen({Key? key}) : super(key: key);

  late DrinkWaterController _waterProgressProvider;

  @override
  Widget build(BuildContext context) {
    _waterProgressProvider =
        Provider.of<DrinkWaterController>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: PPConstants().bgColor,
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w, right: 4.w, top: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                            image: AssetImage(
                                "assets/images/Gut welness logo.png"),
                          ),
                          //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
                        ),
                      ],
                    ),
                    Consumer<DrinkWaterController>(builder: (_, data, child) {
                      return Visibility(
                        visible: !data.showAddIcon,
                        child: GestureDetector(
                          onTap: () {
                            data.resetAllDetails();
                          },
                          child:
                              ImageIcon(AssetImage("assets/images/reset.png")),
                        ),
                      );
                    })
                  ],
                ),
              ),
              WaterProgress(),
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reminder",
                          style:
                              TextStyle(fontSize: 11.sp, fontFamily: kFontBold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    // ExampleAlarmHomeScreen(),
                                 const WaterLevelTime(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  fontSize: 10.5.sp,
                                  fontFamily: kFontMedium,
                                  color: gsecondaryColor),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Set Volume Unit",
                          style:
                              TextStyle(fontSize: 11.sp, fontFamily: kFontBold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Change",
                            style: TextStyle(
                                fontSize: 10.5.sp,
                                fontFamily: kFontMedium,
                                color: gsecondaryColor),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                    Consumer<DrinkWaterController>(builder: (_, data, child) {
                      return Visibility(
                        visible: !data.showAddIcon,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 9),
                              child: Divider(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Update Consumed Water",
                                  style: TextStyle(
                                      fontSize: 11.sp, fontFamily: kFontBold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print("click");
                                    showAddTargetSheet(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          fontSize: 10.5.sp,
                                          fontFamily: kFontMedium,
                                          color: gsecondaryColor),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              )),
              Spacer(),
              GlassDesign(totalGlass: 3)
            ],
          ),
        ),
      ),
    );
  }

  showAddTargetSheet(BuildContext context) {
    print("sheet");
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     top: Radius.circular(30),
      //   ),
      // ),
      builder: (BuildContext context) => AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        // EdgeInsets. only(bottom: MediaQuery.of(context).viewInsets),
        duration: const Duration(milliseconds: 100),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 15.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: kBottomSheetHeadYellow,
                      ),
                      child: Center(
                        child: Image.asset(
                          bsHeadStarsIcon,
                          alignment: Alignment.topRight,
                          fit: BoxFit.scaleDown,
                          width: 30.w,
                          height: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Flexible(
                        child:
                            SingleChildScrollView(child: showTargetUI(context)))
                  ],
                ),
                Positioned(
                    top: 8.h,
                    left: 5,
                    right: 5,
                    child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: gHintTextColor.withOpacity(0.8))
                          ],
                        ),
                        child: CircleAvatar(
                          maxRadius: 40.sp,
                          backgroundColor: kBottomSheetHeadCircleColor,
                          child: Image.asset(
                            bsHeadBellIcon,
                            fit: BoxFit.scaleDown,
                            width: 45,
                            height: 45,
                          ),
                        ))),
                Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: gsecondaryColor,
                          size: 28,
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _waterSizeController = TextEditingController();

  showTargetUI(BuildContext context) {
    return Container(
      height: 45.h,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelTextField('How much water u have consumed now(ml)',
              fontSize: questionFont),
          TextFormField(
            controller: _waterSizeController,
            cursorColor: kPrimaryColor,
            maxLength: 3,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Provide How much water u have consumed';
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", _waterSizeController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          // SizedBox(
          //   height: 3.5.h,
          // ),
          Spacer(),
          Center(
            child: GestureDetector(
              onTap: () {
                _waterProgressProvider
                    .addConsumedWater(int.parse(_waterSizeController.text));
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                decoration: BoxDecoration(
                    color: gsecondaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HistoryGraphScreen extends StatefulWidget {
  const HistoryGraphScreen({Key? key}) : super(key: key);

  @override
  State<HistoryGraphScreen> createState() => _HistoryGraphScreenState();
}

class _HistoryGraphScreenState extends State<HistoryGraphScreen> {
  WaterLevelScreen _waterLevelScreen = WaterLevelScreen();

  @override
  Widget build(BuildContext context) {
    return showPageViewCard();
  }

  normalTextCard() {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reminder",
                style: TextStyle(fontSize: 11.sp, fontFamily: kFontBold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Add",
                  style: TextStyle(
                      fontSize: 10.5.sp,
                      fontFamily: kFontMedium,
                      color: gsecondaryColor),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 9),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Set Volume Unit",
                style: TextStyle(fontSize: 11.sp, fontFamily: kFontBold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Change",
                  style: TextStyle(
                      fontSize: 10.5.sp,
                      fontFamily: kFontMedium,
                      color: gsecondaryColor),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 9),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Update Consumed Water",
                style: TextStyle(fontSize: 11.sp, fontFamily: kFontBold),
              ),
              GestureDetector(
                onTap: () {
                  print("click");
                  _waterLevelScreen.showAddTargetSheet(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Update",
                    style: TextStyle(
                        fontSize: 10.5.sp,
                        fontFamily: kFontMedium,
                        color: gsecondaryColor),
                    textAlign: TextAlign.right,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  ZoomPanBehavior? _zoomDetoxPanBehavior;
  TooltipBehavior? _tooltipDetoxBehavior;

  List<double> detoxGraph = [20, 10, 10, 15, 20];

  graphCard() {
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
        legend: Legend(),
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
              return graph.toString();
            },
            yValueMapper: (double graph, _) => graph,
            // markerSettings: const MarkerSettings(isVisible: true),
            // name: 'High',
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reviewList = [normalTextCard(), graphCard()];
    _zoomDetoxPanBehavior = ZoomPanBehavior(
        enableSelectionZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        enablePanning: true);
    _tooltipDetoxBehavior = TooltipBehavior(enable: true);
  }

  final carouselController = CarouselController();
  int _current = 0;

  List<Widget> reviewList = [];

  showPageViewCard() {
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
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: reviewList.toList(),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: reviewList.map((url) {
              int index = reviewList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? gsecondaryColor
                      : kNumberCircleRed.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class GlassDesign extends StatefulWidget {
  int totalGlass;
  GlassDesign({Key? key, required this.totalGlass}) : super(key: key);

  @override
  State<GlassDesign> createState() => _GlassDesignState();
}

class _GlassDesignState extends State<GlassDesign>
    with TickerProviderStateMixin {
  int totalDays = 7;
  List<DayProgress> _days = [];

  int presentDay = 3;

  String _nofill = "assets/images/gmg/glass.png";
  String _filled = "assets/images/gmg/glass_filled.png";

  AnimationController? animationController;

  late DrinkWaterController _waterProgressProvider;

  @override
  void initState() {
    super.initState();

    for (int i = 1; i <= totalDays + 10; i++) {
      _days.add(DayProgress(
          dayNo: i,
          path: presentDay >= i ? _filled : _nofill,
          isCompleted: presentDay >= i ? true : false));
    }

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animationController!.repeat();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _waterProgressProvider =
        Provider.of<DrinkWaterController>(context, listen: false);
  }

  @override
  void dispose() {
    animationController!.dispose();
    // _waterProgressProvider.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinkWaterController>(
      builder: (_, data, __) {
        print("totalGlasss: ${data.totalGlass}");
        print("con: ${data.currentMl}");
        print("rem: ${data.remainingWaterLevelInExtraGlass}");
        print("consu: ${data.waterConsumedProgress}");
        data.waterConsumedProgress.forEach((element) {
          print(element.qty);
          print(element.waterLevel);
        });
        print("watpro: ${data.waterProgress}");
        print("remml: ${data.remainingMl}");
        print("target: ${data.targetMl}");
        print("mes: ${data.measureGlass}");

        if (data.totalGlass == 0) {
          return Card(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Please Set the Target and Glass Qty By Clicking + icon"),
              ),
            ),
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...data.waterConsumedProgress
                    .map((e) => animatedGlassWidget(e))
                    .toList()
              ],
            ),
          );
        }
      },
    );
  }

  animatedGlassWidget(WaterProgressModel e) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        glassWidget(_nofill),
        if (e.waterLevel != 1.0)
          AnimatedBuilder(
            animation: CurvedAnimation(
                parent: animationController!, curve: Curves.easeInOut),
            builder: (context, child) => ClipPath(
              child: Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: glassWidget(_filled)),
              clipper: WaveClipper(
                  e.waterLevel,
                  (e.waterLevel > 0.0 && e.waterLevel < 1.0)
                      ? animationController!.value
                      : 0.0),
            ),
          ),
        Center(
          child: Column(
            children: <Widget>[
              // ShadowText(
              //   '${(target > 0 ? current / target * 100 : 100).toStringAsFixed(0)}%',
              //   shadowColor: Colors.black.withOpacity(0.5),
              //   offsetX: 3.0,
              //   offsetY: 3.0,
              //   blur: 3.0,
              //   style: TextStyle(
              //       color: Colors.white.withAlpha(200),
              //       fontSize: 40.0,
              //       fontWeight: FontWeight.bold),
              // ),
              ShadowText(
                '${e.qty}\nml',
                shadowColor: Colors.black.withOpacity(0.3),
                offsetX: 3.0,
                offsetY: 3.0,
                blur: 3.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withAlpha(250),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }

  animatedGlassWidget1(DayProgress dayProgress) {
    var current = 40;
    var target = 100;
    var percentage = target > 0 ? current / target * 100 : 100.0;
    var progress = (percentage > 100.0 ? 100.0 : percentage) / 100.0;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        glassWidget(_nofill),
        if (dayProgress.isCompleted)
          AnimatedBuilder(
            animation: CurvedAnimation(
                parent: animationController!, curve: Curves.easeInOut),
            builder: (context, child) => ClipPath(
              child: Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: glassWidget(_filled)),
              clipper: WaveClipper(
                  progress,
                  (progress > 0.0 && progress < 1.0)
                      ? animationController!.value
                      : 0.0),
            ),
          ),
        Center(
          child: Column(
            children: <Widget>[
              // ShadowText(
              //   '${(target > 0 ? current / target * 100 : 100).toStringAsFixed(0)}%',
              //   shadowColor: Colors.black.withOpacity(0.5),
              //   offsetX: 3.0,
              //   offsetY: 3.0,
              //   blur: 3.0,
              //   style: TextStyle(
              //       color: Colors.white.withAlpha(200),
              //       fontSize: 40.0,
              //       fontWeight: FontWeight.bold),
              // ),
              ShadowText(
                '10\nml',
                shadowColor: Colors.black.withOpacity(0.3),
                offsetX: 3.0,
                offsetY: 3.0,
                blur: 3.0,
                style: TextStyle(
                    color: Colors.white.withAlpha(250),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }

  glassWidget(String e) {
    return SizedBox(
      height: 80,
      width: 50,
      child: Image.asset(
        e,
        fit: BoxFit.cover,
      ),
    );
  }
}

class DayProgress {
  int dayNo;
  String path;
  bool isCompleted;
  DayProgress(
      {required this.dayNo, required this.path, this.isCompleted = false});
}

class WaterProgressModel {
  int qty;
  String path;
  bool isCompleted;
  double waterLevel;
  WaterProgressModel(
      {required this.qty,
      required this.path,
      this.isCompleted = false,
      required this.waterLevel});
}
