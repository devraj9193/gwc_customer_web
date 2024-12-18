import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import '../../../model/error_model.dart';
import '../../../model/ship_track_model/ship_track_activity_model.dart';
import '../../../model/ship_track_model/shipping_track_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/shipping_repository/ship_track_repo.dart';
import '../../../services/shipping_service/ship_track_service.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/stepper/stepper_data.dart';
import '../../../widgets/widgets.dart';
import '../../gut_list_screens/new_dashboard_stages.dart';
import 'package:intl/intl.dart';
import '../../../widgets/stepper/another_stepper.dart';
import '../cook_kit_tracking.dart';
import '../new_shipment_approved_screen.dart';

class TrackingWebScreens extends StatefulWidget {
  /// to show the respective design for some stages
  final String currentStage;
  final String? awbNumber;
  final String isForeign;
  /// to select tabs initially
  /// by default 0 -> tracker
  /// 1-> shopping list
  final int initialIndex;
  const TrackingWebScreens({
    Key? key,
    this.awbNumber,
    required this.currentStage,
    this.initialIndex = 0, required this.isForeign,
  }) : super(key: key);

  @override
  State<TrackingWebScreens> createState() => _TrackingWebScreensState();
}

class _TrackingWebScreensState extends State<TrackingWebScreens> {
  @override
  void initState() {
    super.initState();
    if (widget.currentStage.isNotEmpty) {
      if ((widget.currentStage == 'shipping_approved' ||
              widget.currentStage == 'shipping_delivered' ||
              widget.currentStage == 'shipping_packed') &&
          widget.awbNumber != null) {
        shippingTracker();
      } else {
        print("init else");
        setState(() {
          showErrorText = true;
        });
      }
    }
  }

  String awb1 = '119982675';
  String awb2 = '14326322712380';
  String awb3 = '14326322704046';
  double gap = 23.0;
  int activeStep = -1;

  final tableHeadingBg = gHintTextColor.withOpacity(0.4);

  Timer? timer;
  int upperBound = -1;

  List<ShipmentTrackActivities> trackerList = [];
  String estimatedDate = '';
  String estimatedDay = '';
  String deliveredDate = '';
  String shipAddress = '';
  String deliveryStatus = '';
  int tabSize = 2;
  bool isDelivered = false;

  bool showErrorText = false;

  String errorTextResponse = '';

  bool showTrackingProgress = false;

  void shippingTracker() async {
    setState(() {
      showTrackingProgress = true;
    });
    final result = await ShipTrackService(repository: repository)
        .getUserProfileService(widget.awbNumber ?? '');
    print("shippingTracker: $result");
    if (result.runtimeType == ShippingTrackModel) {
      ShippingTrackModel data = result;
      if (data.response.trackingData.error != null) {
        setState(() {
          showErrorText = true;
          errorTextResponse = data.response.trackingData.error ?? '';
        });
      } else {
        if (data.response.trackingData.shipmentTrackActivities != null) {
          print(data.response.trackingData.shipmentTrackActivities);
          for (var element
              in data.response.trackingData.shipmentTrackActivities!) {
            trackerList.add(element);
            if (element.srStatusLabel!.toLowerCase() == 'delivered') {
              setState(() {
                isDelivered = true;
              });
            }
          }
        } else {
          setState(() {
            showErrorText = true;
          });
        }
        shipAddress =
            data.response.trackingData.shipmentTrack?.first.deliveredTo ?? '';
        deliveryStatus =
            data.response.trackingData.shipmentTrack?.first.currentStatus ?? '';
        estimatedDate = data.response.trackingData.etd!;
        estimatedDay = DateFormat('EEEE').format(DateTime.parse(estimatedDate));
        deliveredDate =
            data.response.trackingData.shipmentTrack?.first.deliveredDate ?? '';
        //print("estimatedDay: $estimatedDay");
        setState(() {
          upperBound = trackerList.length;
          activeStep = 0;
        });

        timer = Timer.periodic(const Duration(milliseconds: 500), (timer1) {
          //print(timer1.tick);
          //print('activeStep: $activeStep');
          //print('upperBound:$upperBound');
          if (activeStep < upperBound) {
            setState(() {
              activeStep++;
            });
          } else {
            timer1.cancel();
          }
        });
      }
    } else {
      ErrorModel error = result as ErrorModel;

      if (error.message!.contains("Token has expired")) {
        print("called shiprocket token from cook kit tracking");
        GutList().myAppState.getShipRocketToken();
      }
    }
    setState(() {
      showTrackingProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide < 600
        ? CookKitTracking(
            currentStage: widget.currentStage,
            awb_number: widget.awbNumber,
            initialIndex: widget.initialIndex,
      isForeign: widget.isForeign,
          )
        : Scaffold(
            backgroundColor: profileBackGroundColor,
            body: SafeArea(
              child: (showTrackingProgress)
                  ? buildCircularIndicator()
                  : shipRocketUI(context),
            ),
          );
  }

  shipRocketUI(BuildContext context) {
    if (widget.currentStage == 'meal_plan_completed') {
      return NewShipmentApprovedScreen(isForeign: widget.isForeign,);
    } else {
      return mainView();
    }
  }

  mainView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: double.maxFinite,
            margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: gWhiteColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: gBlackColor,
                            size: 2.h,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Track Kit',
                        style: TextStyle(
                          fontSize: 15.dp,
                          fontFamily: kFontMedium,
                          color: gBlackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Center(
                    child: Image.asset(
                      (isDelivered)
                          ? "assets/images/delivered.gif"
                          : "assets/images/truck_moving.gif",
                      height: 25.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: 2.h, bottom: 4.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (isDelivered)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    estimatedDate.isNotEmpty
                                        ? RichText(
                                            text: TextSpan(
                                              text: 'Delivered On : \n',
                                              style: TextStyle(
                                                fontFamily: kFontBook,
                                                color: gBlackColor,
                                                fontSize: 13.dp,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${DateFormat("dd MMM yyyy").format(DateTime.parse(estimatedDate))}(${DateFormat('EEEE').format(DateTime.parse(estimatedDate))})",
                                                  style: TextStyle(
                                                    fontFamily: kFontBold,
                                                    color: gBlackColor,
                                                    fontSize: 15.dp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                              : estimatedDate.isEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order is under processing",
                                          style: TextStyle(
                                            fontSize: 15.dp,
                                            fontFamily: kFontMedium,
                                            color: gBlackColor,
                                            height: 1.5,
                                          ),
                                        ),
                                        Text(
                                          "We will update the Estimated Delivery Date once order is processed",
                                          style: TextStyle(
                                            fontSize: 13.dp,
                                            fontFamily: kFontBook,
                                            color: gBlackColor,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Estimated Delivery Date : ",
                                          style: TextStyle(
                                            fontSize: 13.dp,
                                            fontFamily: kFontBook,
                                            color: gBlackColor,
                                            height: 1.5,
                                          ),
                                        ),
                                        Text(
                                          "${DateFormat("dd MMM yyyy").format(DateTime.parse(estimatedDate))}($estimatedDay)",
                                          style: TextStyle(
                                            fontSize: 15.dp,
                                            fontFamily: kFontMedium,
                                            color: gBlackColor,
                                            height: 1.5,
                                          ),
                                        ),
                                        estimatedDate.isNotEmpty
                                            ? RichText(
                                                text: TextSpan(
                                                  text: 'Delivered On: ',
                                                  style: TextStyle(
                                                    fontFamily: kFontBook,
                                                    color: gBlackColor,
                                                    fontSize: 13.dp,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "${DateFormat("dd MMM yyyy").format(DateTime.parse(estimatedDate))}(${DateFormat('EEEE').format(DateTime.parse(estimatedDate))})",
                                                      style: TextStyle(
                                                        fontFamily: kFontBold,
                                                        color: gBlackColor,
                                                        fontSize: 15.dp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                          SizedBox(height: 3.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status : ",
                                style: TextStyle(
                                  fontSize: 13.dp,
                                  fontFamily: kFontBook,
                                  color: gBlackColor,
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                deliveryStatus,
                                style: TextStyle(
                                  fontSize: 15.dp,
                                  fontFamily: kFontMedium,
                                  color: gBlackColor,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            height: double.maxFinite,
            margin: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 2.w),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: trackingView(),
          ),
        ),
      ],
    );
  }

  trackingView() {
    if ((widget.currentStage == "shipping_approved" ||
            widget.currentStage == "shipping_delivered" ||
            widget.currentStage == "shipping_packed") &&
        widget.awbNumber != null) {
      return (!showErrorText)
          ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text(
                  "Delivery Address",
                  style: TextStyle(
                    fontFamily: kFontBold,
                    fontSize: 15.dp,
                    color: gBlackColor,
                  ),
                ),
                SizedBox(height: 1.h),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: gPrimaryColor,
                    ),
                  ),
                  title: Text(
                    shipAddress,
                    // _pref?.getString(AppConfig.SHIPPING_ADDRESS) ??  "",
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontBook,
                      fontSize: 11.dp,
                      color: gTextColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Center(
                    child: Image.asset(
                      "assets/images/Shipping.gif",
                      height: 40.h,
                    ),
                  ),
                ),
                AnotherStepper(
                  stepperList: getStepper(),
                  gap: gap,
                  isInitialText: true,
                  initialText: getStepperInitialValue(),
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  stepperDirection: Axis.vertical,
                  horizontalStepperHeight: 5,
                  dotWidget: getIcons(),
                  activeBarColor: gPrimaryColor,
                  inActiveBarColor: Colors.grey.shade200,
                  activeIndex: activeStep,
                  barThickness: 5,
                  titleTextStyle: TextStyle(
                    fontSize: 10.dp,
                    fontFamily: kFontMedium,
                  ),
                  subtitleTextStyle: TextStyle(
                    fontSize: 8.dp,
                  ),
                ),
              ],
            ),
          )
          : Center(child: showProductGifWhenTrackerSideError());
    } else {
      return (showErrorText)
          ? Center(child: showProductGifWhenTrackerSideError())
          : const Center(
              child: Image(
                image: AssetImage("assets/images/no_data_found.png"),
                fit: BoxFit.scaleDown,
              ),
            );
    }
  }

  estimatedDateView() {
    if (!isDelivered) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
              text: 'Estimated Delivery Date: ',
              style: TextStyle(
                  fontFamily: kFontBold, color: gPrimaryColor, fontSize: 12.dp),
              children: [
                TextSpan(
                  text: estimatedDate,
                  style: TextStyle(
                      fontFamily: kFontBook,
                      color: gPrimaryColor,
                      fontSize: 10.5.dp),
                )
              ]),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: 'Delivered On: ',
                  style: TextStyle(
                      fontFamily: kFontBold,
                      color: gPrimaryColor,
                      fontSize: 12.dp),
                  children: [
                    TextSpan(
                      text: estimatedDay,
                      style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gMainColor,
                          fontSize: 10.5.dp),
                    )
                  ]),
            ),
            Text(
              estimatedDate,
              style: TextStyle(
                  fontFamily: kFontBook,
                  color: gPrimaryColor,
                  fontSize: 10.5.dp),
            )
          ],
        ),
      );
    }
  }

  getStepper() {
    List<StepperData> stepper = [];
    trackerList.map((e) {
      // String txt = 'Location: ${e.location}';
      //print("txt.length${txt.length}");
      stepper.add(StepperData(
        // title: e.srStatusLabel!.contains('NA') ? 'Activity: ${e.activity}' : 'Activity: ${e.srStatusLabel}',
        title: 'Activity: ${e.srStatusLabel}',
        subtitle: 'Location: ${e.location}',
      ));
    }).toList();
    setState(() {
      gap =
          trackerList.any((element) => element.location!.length > 60) ? 33 : 23;
    });
    return stepper;
  }

  getIcons() {
    // print("activeStep==> $activeStep  trackerList.length => ${trackerList.length}");
    List<Widget> widgets = [];
    for (var i = 0; i < trackerList.length; i++) {
      // print('-i----$i');
      // print(trackerList[i].srStatus != '7');
      if (i == 0 && trackerList[i].srStatus != '7') {
        widgets.add(Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: gPrimaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Icon(
              Icons.radio_button_checked_sharp,
              color: Colors.white,
              size: 15.dp,
            )
            // (!trackerList.every((element) => element.srStatus!.contains('7')) && trackerList.length-1) ? Icon(Icons.radio_button_checked_sharp, color: Colors.white, size: 15.sp,) : Icon(Icons.check, color: Colors.white, size: 15.sp,),
            ));
      } else {
        widgets.add(Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
                color: gPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 15.dp,
            )
            // (!trackerList.every((element) => element.srStatus!.contains('7')) && trackerList.length-1) ? Icon(Icons.radio_button_checked_sharp, color: Colors.white, size: 15.sp,) : Icon(Icons.check, color: Colors.white, size: 15.sp,),
            ));
      }
    }
    return widgets;
  }

  getStepperInitialValue() {
    List<StepperData> stepper = [];
    trackerList.map((e) {
      stepper.add(StepperData(
        title: DateFormat('dd MMM').format(DateTime.parse(e.date!)),
        subtitle: DateFormat('hh:mm a').format(DateTime.parse(e.date!)),
      ));
    }).toList();
    return stepper;
  }

  showProductGifWhenTrackerSideError() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/Shipping.gif"),
        SizedBox(
          height: 1.5.h,
        ),
        Text(
          "Your kit is being dispatched.\nThis page will be updated soon with live tracking details.",
          style: TextStyle(
              fontFamily: kFontBold,
              color: gTextColor,
              fontSize: headingFont,
              height: 1.5),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  final ShipTrackRepository repository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
