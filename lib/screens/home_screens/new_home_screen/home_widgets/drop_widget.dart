import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/screens/home_screens/new_home_screen/home_widgets/shadow_text.dart';
import 'package:sizer/sizer.dart';

import 'package:provider/provider.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as Vector;

import '../../../../services/home_service/drink_water_controller.dart';
import '../../../../utils/app_config.dart';
import '../../../../widgets/constants.dart';
import '../../../../widgets/widgets.dart';
import 'container_wrapper.dart';

class WaterProgress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WaterProgressState();
  }
}

class _WaterProgressState extends State<WaterProgress>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  late DrinkWaterController _waterProgressProvider;
  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animationController!.repeat();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _waterProgressProvider = Provider.of<DrinkWaterController>(context, listen: false);
    if(mounted){
      _waterProgressProvider.getLocalData();
    }

  }

  @override
  void dispose() {
    animationController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var current = 80;
    var target = 100;
    var percentage = target > 0 ? current / target * 100 : 100.0;
    var progress = (percentage > 100.0 ? 100.0 : percentage) / 100.0;
    print("%: $percentage");
    print("before progressss: $progress");

    progress = 1.0 - progress;

    print("progressss: $progress");

    // I/flutter (20798): %1: 80.0
    // I/flutter (20798): before progressss1: 0.8
    // I/flutter (20798): progressss1: 0.19999999999999996

    return ContainerWrapper(
      widthScale: 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Stack(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Center(
                          child: Opacity(
                              opacity: 0.4,
                              child: Image.asset('assets/images/gmg/drop3.png'))
                      ),
                      Center(
                        child: Consumer<DrinkWaterController>(
                          builder: (_, data, child){
                            print("waterProgress: ${data.waterProgress}");
                            return AnimatedBuilder(
                              animation: CurvedAnimation(
                                  parent: animationController!,
                                  curve: Curves.easeInOut),
                              builder: (context, child) => ClipPath(
                                child: Image.asset('assets/images/gmg/drop3_filled.png'),
                                clipper: WaveClipper(
                                    data.waterProgress,
                                    (data.waterProgress > 0.0 && data.waterProgress < 1.0)
                                        ? animationController!.value
                                        : 0.0),
                              ),
                            );
                          },
                        ),
                      ),

                      Center(
                        child: Consumer<DrinkWaterController>(
                            builder: (_, data, __){
                              return Column(
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
                                    '${data.currentMl} ml',
                                    shadowColor: Colors.black.withOpacity(0.3),
                                    offsetX: 3.0,
                                    offsetY: 3.0,
                                    blur: 3.0,
                                    style: TextStyle(
                                        color: Colors.white.withAlpha(150),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 40,
                      left: 0,
                      right: -100,
                      child: Consumer<DrinkWaterController>(
                        builder: (_, data, child){
                          return Visibility(
                            visible: data.showAddIcon,
                            child: GestureDetector(
                              onTap: showAddTargetSheet,
                              child: Container(
                                padding: EdgeInsets.all(0.8),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0.5, 0.5),
                                        blurRadius: 2,
                                      )
                                    ]
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.lightBlueAccent,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     offset: Offset(0.5, 0.5),
                                    //     blurRadius: 2,
                                    //   )
                                    // ]
                                  ),
                                  child: Icon(Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                  ,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Remaining',
                        style: TextStyle(
                            color: const Color(0xFF363535),
                            fontWeight: FontWeight.w300),
                      ),
                      Consumer<DrinkWaterController>(
                          builder: (_, data, __){
                            return Text(
                              '${data.remainingMl}',
                              // '${(target - current < 0 ? 0 : target - current)} ml',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
                            );
                          }
                      ),

                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Target',
                          style: TextStyle(
                              color: const Color(0xFF363535),
                              fontWeight: FontWeight.w300),
                        ),
                        Consumer<DrinkWaterController>(
                            builder: (_, data, __){
                              return  Text(
                                '${data.targetMl} ml',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.w600),
                              );
                            }
                        ),

                        // Text(
                        //   '$target ml',
                        //   style: TextStyle(
                        //       fontSize: 20.0, fontWeight: FontWeight.w600),
                        // )
                      ],
                    ))
              ],
            ),
          ],
        ));
  }

  showAddTargetSheet(){
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
      builder: (BuildContext context) =>
          AnimatedPadding(
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
                            child: Image.asset(bsHeadStarsIcon,
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
                            child: SingleChildScrollView(
                              child: StatefulBuilder(
                            builder: (_, setstate){
                              return showTargetUI();
                            }
                        ),))
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
                                BoxShadow(blurRadius: 5, color: gHintTextColor.withOpacity(0.8))
                              ],
                            ),
                            child: CircleAvatar(
                              maxRadius: 40.sp,
                              backgroundColor: kBottomSheetHeadCircleColor,
                              child: Image.asset(bsHeadBellIcon,
                                fit: BoxFit.scaleDown,
                                width: 45,
                                height: 45,
                              ),
                            )
                        )
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel_outlined, color: gsecondaryColor,size: 28,)))
                  ],
                ),
              ),
            ),
          ),
    );
  }

  final _waterDrinkTargetController = TextEditingController();
  final _waterSizeController = TextEditingController();

  showTargetUI(){
    return Container(
      height: 45.h,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelTextField('Set How Much Water You will Drink Per Day(ml)', fontSize: questionFont),
          TextFormField(
            controller: _waterDrinkTargetController,
            cursorColor: kPrimaryColor,
            maxLength: 3,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Set The Target';
              }
              else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", _waterDrinkTargetController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          buildLabelTextField('Provide the glass Measurement(ml) from which glass u will consume water', fontSize: questionFont),
          TextFormField(
            controller: _waterSizeController,
            cursorColor: kPrimaryColor,
            maxLength: 3,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Provide Glass Measurement';
              }
              else {
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
                _waterProgressProvider.setTraget(int.parse(_waterDrinkTargetController.text));
                _waterProgressProvider.setTotalGlassFromQuant(int.parse(_waterSizeController.text));
                Navigator.pop(context);
                },
              child: Container(
                padding:
                EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
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

class WaveClipper extends CustomClipper<Path> {
  final double progress;
  final double animation;

  WaveClipper(this.progress, this.animation);

  @override
  Path getClip(Size size) {
    final double wavesHeight = size.height * 0.1;

    var path = new Path();

    if (progress == 1.0) {
      return path;
    } else if (progress == 0.0) {
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.lineTo(0.0, 0.0);
      return path;
    }

    List<Offset> wavePoints = [];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      var extraHeight = wavesHeight * 0.5;
      extraHeight *= i / (size.width / 2 - size.width);
      var dx = i.toDouble();
      var dy = sin((animation * 360 - i) % 360 * Vector.degrees2Radians) * 5 +
          progress * size.height -
          extraHeight;
      if (!dx.isNaN && !dy.isNaN) {
        wavePoints.add(Offset(dx, dy));
      }
    }

    path.addPolygon(wavePoints, false);

    // finish the line
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(WaveClipper old) =>
      progress != old.progress || animation != old.animation;
}