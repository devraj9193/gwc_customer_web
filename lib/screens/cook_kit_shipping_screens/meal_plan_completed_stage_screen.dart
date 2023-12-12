import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_horizontal_date_picker/flutter_horizontal_date_picker.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../model/error_model.dart';
import '../../model/ship_track_model/sipping_approve_model.dart';
import '../../repository/api_service.dart';
import '../../repository/shipping_repository/ship_track_repo.dart';
import '../../services/shipping_service/ship_track_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/widgets.dart';

class NewMealPopupScreen extends StatefulWidget {
  const NewMealPopupScreen({Key? key}) : super(key: key);

  @override
  State<NewMealPopupScreen> createState() => _NewMealPopupScreenState();
}

class _NewMealPopupScreenState extends State<NewMealPopupScreen> {
  DatePickerController dateController = DatePickerController();

  String isSelected = "";
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print("width: ${MediaQuery.of(context).size.width}");
    print("height: ${MediaQuery.of(context).size.height}");
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kNumberCirclePurple,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5.5.h, left: 15.w, right: 15.w),
                child: Text(
                  "Please Pick the date on which you'd like us to deliver the kit.",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.5,
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(top: 4.h),
                decoration: const BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: kLineColor,
                      offset: Offset(2, 3),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        "Choose Day",
                        style: TextStyle(
                            fontFamily: kFontBold,
                            color: eUser().mainHeadingColor,
                            fontSize: 11.sp),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: buildChooseDay(),
                    ),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(top: 2.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image(
                                  image: const AssetImage(
                                      "assets/images/Group 76497.png"),
                                  height: height < 600 ? 22.5.h : 28.h,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                "Please note:",
                                style: TextStyle(
                                    fontFamily: kFontBold,
                                    color: kNumberCircleRed,
                                    fontSize: 11.sp),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                "These are estimates, please allow a 1-2 day margin of variance.",
                                style: TextStyle(
                                    height: 1.3,
                                    fontFamily: kFontMedium,
                                    color: eUser().userTextFieldColor,
                                    fontSize: 10.sp),
                              ),
                              Center(
                                child: GestureDetector(
                                  // onTap: (showLoginProgress) ? null : () {
                                  onTap: () {
                                    sendApproveStatus("yes");
                                  },
                                  child: IntrinsicWidth(
                                    child: Container(
                                      margin:
                                      EdgeInsets.symmetric(vertical: 4.h),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1.5.h, horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        color: kNumberCircleRed,
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border.all(
                                        //     color: eUser().buttonBorderColor,
                                        //     width: eUser().buttonBorderWidth
                                        // ),
                                      ),
                                      child: Center(
                                        child: (isSubmitted)
                                            ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                                            : Text(
                                          'Submit',
                                          style: TextStyle(
                                            fontFamily: eUser().buttonTextFont,
                                            color: gWhiteColor,
                                            fontSize: eUser().buttonTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildChooseDay() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.h),
      child: HorizontalDatePicker(
        begin: DateTime.now().add(Duration(days: 4)),
        end: DateTime.now().add(Duration(days: 30)),
        itemCount: 26,
        itemSpacing: 20,
        selected: selectedDate,
        onSelected: (item) {
          setState(() {
            selectedDate = item;
          });
        },
        selectedColor: gBackgroundColor,
        itemHeight: 55,
        itemWidth: 40,
        itemBuilder: (DateTime itemValue, DateTime? selected) {
          print("this");
          print("itemValue: $itemValue");
          // print(DateFormat("dd/MM/yyyy").format(selectedDate) == DateFormat("dd/MM/yyyy").format(itemValue));
          if(DateFormat("dd/MM/yyyy").format(selectedDate) == DateFormat("dd/MM/yyyy").format(itemValue)){
            return Container(
              height: 55,
              width: 40,
              decoration: BoxDecoration(
                color: gsecondaryColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: kNumberCircleRed.withOpacity(0.5), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    itemValue.formatted(pattern: "dd"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontMedium,
                      fontSize: 11.sp,
                      color: gWhiteColor,
                    ),
                  ),
                  Text(
                    itemValue.formatted(pattern: "EEE"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontMedium,
                      fontSize: 08.sp,
                      color: gWhiteColor,
                    ),
                  ),
                ],
              ),
            );
          }
          else{
            return Container(
              height: 9.h,
              width: 10.w,
              decoration: BoxDecoration(
                border: Border.all(
                    color: kNumberCircleRed.withOpacity(0.5), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    itemValue.formatted(pattern: "dd"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontMedium,
                      fontSize: 11.sp,
                      color: eUser().mainHeadingColor,
                    ),
                  ),
                  Text(
                    itemValue.formatted(pattern: "EEE"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontBook,
                      fontSize: 08.sp,
                      color: eUser().mainHeadingColor,
                    ),
                  ),
                ],
              ),
            );
          }
        },

      ),
    );
    return DatePicker(
      DateTime.now(),
      controller: dateController,
      height: 10.h,
      width: 14.w,
      monthTextStyle: TextStyle(fontSize: 0.sp),
      dateTextStyle: TextStyle(
          fontFamily: kFontBold,
          fontSize: 13.sp,
          color: eUser().mainHeadingColor),
      dayTextStyle: TextStyle(
          fontFamily: kFontBook,
          fontSize: 8.sp,
          color: eUser().mainHeadingColor),
      initialSelectedDate: DateTime.now(),
      selectionColor: gsecondaryColor,
      selectedTextColor: gWhiteColor,
      daysCount: 5,
      onDateChange: (date) {
        setState(() {
          selectedDate = date;
          isLoading = true;
          isSelected = "";
        });
      },
    );
  }

  final ShipTrackRepository shipTrackRepository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );


  bool isSubmitted = false;

  sendApproveStatus(String status) async {
    print(DateFormat("dd/MM/yyyy").format(selectedDate));
    setState(() {
      isSubmitted = true;
    });
    final res = await ShipTrackService(repository: shipTrackRepository)
        .sendShippingApproveStatusService(status, selectedDate: DateFormat("dd/MM/yyyy").format(selectedDate));

    if (res.runtimeType == ShippingApproveModel) {
      ShippingApproveModel model = res as ShippingApproveModel;
      print('success: ${model.message}');
      Navigator.pop(context);
    }
    else {
      ErrorModel model = res as ErrorModel;
      print('error: ${model.message}');
      AppConfig().showSnackbar(context, model.message!, isError: true);
    }
    setState(() {
      isSubmitted = false;
    });
  }

}
