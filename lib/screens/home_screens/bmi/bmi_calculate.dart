import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:gwc_customer_web/screens/home_screens/bmi/weight_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import '../../../model/error_model.dart';
import '../../../model/success_message_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/home_repo/home_repository.dart';
import '../../../services/home_service/home_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'bmi_result.dart';
import 'calculate_bmi.dart';
import 'package:http/http.dart' as http;

enum Gender { male, female }

class BMICalculate extends StatefulWidget {
  const BMICalculate({Key? key}) : super(key: key);

  @override
  _BMICalculateState createState() => _BMICalculateState();
}

class _BMICalculateState extends State<BMICalculate> {
  String selectedGender = "";
  num height = 0;
  int weight = 0;
  int age = 0;

  bool isLoading = false;

  List gender = ["male", "female"];

  RulerPickerController? _rulerPickerController;

  final SharedPreferences _pref = AppConfig().preferences!;

  @override
  void initState() {
    super.initState();
    getHeightInCm();
    _rulerPickerController = RulerPickerController(value: height);
    weight = int.parse(_pref.getString(AppConfig.User_weight) ?? '');
    age = int.parse(_pref.getString(AppConfig.User_age) ?? "");
    selectedGender = (_pref.getString(AppConfig.User_gender) ?? '');
    print("weight: ${_pref.getString(AppConfig.User_weight)}");
    print("Gender: ${_pref.getString(AppConfig.User_gender)}");
    print("age: ${_pref.getString(AppConfig.User_age)}");
  }

  getHeightInCm() {
    var a = _pref.getString(AppConfig.User_height);
    print(a);
    var b = a?.split(".");
    double feet = double.parse("${b?.first}");
    double inches = double.parse("${b?.last}");

    height = (feet * 30.48).toInt() + (inches * 2.54).toInt();

    // print("${((feet * 12) + inches)* 2.54}");

    print("height : $height");
  }

  List<RulerRange> ranges = const [
    RulerRange(begin: 100, end: 300, scale: 0.1),
    // RulerRange(begin: 10, end: 100, scale: 1),
    // RulerRange(begin: 100, end: 1000, scale: 10),
    // RulerRange(begin: 1000, end: 10000, scale: 100),
    // RulerRange(begin: 10000, end: 100000, scale: 1000)
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                    "BMI & BMR Calculator",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: eUser().mainHeadingColor,
                      fontFamily: eUser().mainHeadingFont,
                      fontSize: eUser().mainHeadingFontSize,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = gender[0];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                            color: gWhiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: selectedGender == gender[0]
                                ? Border.all(color: gBlackColor, width: 2)
                                : Border.all(color: kLineColor, width: 1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.male_sharp,
                                size: 8.h,
                                color: selectedGender == gender[0]
                                    ? gMainColor
                                    : gHintTextColor),
                            SizedBox(height: 2.h),
                            Text(
                              "Male",
                              style: selectedGender == gender[0]
                                  ? TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().mainHeadingFont,
                                      fontSize: eUser().userFieldLabelFontSize,
                                    )
                                  : TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().userTextFieldFont,
                                      fontSize: eUser().userFieldLabelFontSize,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = gender[1];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                            color: gWhiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: selectedGender == gender[1]
                                ? Border.all(color: gBlackColor, width: 2)
                                : Border.all(color: kLineColor, width: 1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.female_sharp,
                                size: 8.h,
                                color: selectedGender == gender[1]
                                    ? kBigCircleBorderRed
                                    : gHintTextColor),
                            SizedBox(height: 2.h),
                            Text(
                              "Female",
                              style: selectedGender == gender[1]
                                  ? TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().mainHeadingFont,
                                      fontSize: eUser().userFieldLabelFontSize,
                                    )
                                  : TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().userTextFieldFont,
                                      fontSize: eUser().userFieldLabelFontSize,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: EdgeInsets.symmetric(vertical: 3.h),
                decoration: BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: kLineColor, width: 1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Height (in cm)',
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().mainHeadingFont,
                        fontSize: eUser().mainHeadingFontSize,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            height.toString(),
                            style: TextStyle(
                              color: eUser().mainHeadingColor,
                              fontFamily: eUser().mainHeadingFont,
                              fontSize: eUser().userFieldLabelFontSize,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'cm',
                            style: TextStyle(
                              color: eUser().userTextFieldColor,
                              fontFamily: eUser().userTextFieldFont,
                              fontSize: eUser().userTextFieldFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: kBigCircleBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RulerPicker(
                        controller: _rulerPickerController!,
                        onBuildRulerScaleText: (index, value) {
                          return value.toInt().toString();
                        },
                         ranges: ranges,

                        scaleLineStyleList: const [
                          ScaleLineStyle(
                              color: Colors.grey, width: 1.5, height: 30, scale: 0),
                          ScaleLineStyle(
                              color: Colors.grey, width: 1, height: 25, scale: 5),
                          ScaleLineStyle(
                              color: Colors.grey, width: 1, height: 15, scale: -1)
                        ],

                        onValueChanged: (value) {
                          setState(() {
                            height = value;
                          });
                        },
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        rulerMarginTop: 8,
                        // marker: Container(
                        //     width: 8,
                        //     height: 50,
                        //     decoration: BoxDecoration(
                        //         color: Colors.red.withAlpha(100),
                        //         borderRadius: BorderRadius.circular(5))),
                      ),
                      // RulerPicker(
                      //   controller: _rulerPickerController,
                      //    // beginValue: 120,
                      //   rulerBackgroundColor: kBigCircleBg,
                      //   // endValue: 220,
                      //   // initValue: height,
                      //   // scaleLineStyleList: [
                      //   //   ScaleLineStyle(
                      //   //       color: Colors.grey, width: 1.5, height: 30, scale: 0),
                      //   //   ScaleLineStyle(
                      //   //       color: Colors.grey, width: 1, height: 25, scale: 5),
                      //   //   ScaleLineStyle(
                      //   //       color: Colors.grey, width: 1, height: 15, scale: -1)
                      //   // ],
                      //   // onBuildRulerScalueText: (index, scaleValue) {
                      //   //   return ''.toString();
                      //   // },
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 8.h,
                      //   rulerMarginTop: 1.5.h,
                      //   onValueChanged: (num value) {
                      //     setState(() {
                      //       height = value;
                      //     });
                      //   },
                      //   onBuildRulerScaleText:
                      //       (int index, num value) {
                      //         return value.toInt().toString();
                      //       },
                      //   // marker: Icon(
                      //   //   Icons.arrow_drop_down_sharp,
                      //   //   size: 5.h,
                      //   //   color: gBlackColor,
                      //   // ),
                      // ),
                    ),
                    // Container(
                    //   margin:
                    //       EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    //   padding: EdgeInsets.symmetric(horizontal: 3.w),
                    //   decoration: BoxDecoration(
                    //     color: kBigCircleBg,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: HorizontalPicker(
                    //     height: 10.h,
                    //     minValue: 120,
                    //     maxValue: 220,
                    //     divisions: 1000,
                    //     suffix: "  ",
                    //     initialPosition: InitialPosition.center,
                    //     showCursor: false,
                    //     backgroundColor: kBigCircleBg,
                    //     activeItemTextColor: kNumberCircleRed,
                    //     passiveItemsTextColor: gHintTextColor,
                    //     onChanged: (double newHeight) {
                    //       setState(() {
                    //         height = newHeight.round();
                    //       });
                    //     },
                    //   ),
                    // ),
                    // SliderTheme(
                    //   data: SliderTheme.of(context).copyWith(
                    //     inactiveTrackColor: kNumberCircleAmber.withOpacity(0.3),
                    //     activeTrackColor: kNumberCircleRed,
                    //     thumbColor: Color(0xFFE83D66),
                    //     overlayColor: Color(0x29E83D66),
                    //     thumbShape:
                    //         RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    //     overlayShape:
                    //         RoundSliderOverlayShape(overlayRadius: 20.0),
                    //   ),
                    //   child: Slider(
                    //     value: height.toDouble(),
                    //     min: 120.0,
                    //     max: 220.0,
                    //     onChanged: (double newHeight) {
                    //       setState(() {
                    //         height = newHeight.round();
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 22.h,
                      margin: const EdgeInsets.all(10.0),
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: kLineColor, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weight (in kg)',
                            style: TextStyle(
                              color: eUser().mainHeadingColor,
                              fontFamily: eUser().mainHeadingFont,
                              fontSize: eUser().mainHeadingFontSize,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Container(
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: kBigCircleBg,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Icon(
                                    Icons.arrow_drop_down_sharp,
                                    size: 5.h,
                                    color: gBlackColor,
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) =>
                                        constraints.isTight
                                            ? Container()
                                            : WeightSlider(
                                                minValue: 30,
                                                maxValue: 110,
                                                width: constraints.maxWidth,
                                                value: weight,
                                                onChanged: (val) => setState(
                                                    () => weight = val),
                                                scrollController:
                                                    ScrollController(
                                                  initialScrollOffset:
                                                      (weight - 30) *
                                                          constraints.maxWidth /
                                                          3,
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     buildAgeIcon(
                          //       () {
                          //         setState(() {
                          //           weight--;
                          //         });
                          //       },
                          //       Icons.remove,
                          //     ),
                          //     Text(
                          //       weight.toString(),
                          //       style: TextStyle(
                          //         color: eUser().mainHeadingColor,
                          //         fontFamily: eUser().mainHeadingFont,
                          //         fontSize: eUser().mainHeadingFontSize,
                          //       ),
                          //     ),
                          //     buildAgeIcon(
                          //       () {
                          //         setState(() {
                          //           weight++;
                          //         });
                          //       },
                          //       Icons.add,
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 22.h,
                      margin: const EdgeInsets.all(10.0),
                      padding: EdgeInsets.only(top: 4.h, bottom: 6.h),
                      decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: kLineColor, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                              color: eUser().mainHeadingColor,
                              fontFamily: eUser().mainHeadingFont,
                              fontSize: eUser().mainHeadingFontSize,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildAgeIcon(
                                () {
                                  setState(() {
                                    age--;
                                  });
                                },
                                Icons.remove,
                              ),
                              Text(
                                age.toString(),
                                style: TextStyle(
                                  color: eUser().mainHeadingColor,
                                  fontFamily: eUser().mainHeadingFont,
                                  fontSize: eUser().mainHeadingFontSize,
                                ),
                              ),
                              buildAgeIcon(
                                () {
                                  setState(() {
                                    age++;
                                  });
                                },
                                Icons.add,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: () {
                    CalculateBmi calc = CalculateBmi(
                      height: height.toInt(),
                      weight: weight,
                      gender: selectedGender,
                      age: age,
                    );
                    bookAppointment(
                      context,
                      calc.calculate(),
                      calc.getComment(),
                      calc.getResult(),
                      calc.calculateBmr(),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return ResultPage(
                    //         bmi: calc.calulate(),
                    //         comment: calc.getComment(),
                    //         result: calc.getResult(),
                    //       );
                    //     },
                    //   ),
                    // );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: kNumberCircleRed,
                      borderRadius:
                          BorderRadius.circular(eUser().buttonBorderRadius),
                      // border: Border.all(
                      //     color: eUser().buttonBorderColor,
                      //     width: eUser().buttonBorderWidth
                      // ),
                    ),
                    child:(isLoading)
                        ? buildThreeBounceIndicator(
                        color: eUser().threeBounceIndicatorColor)
                        : Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: eUser().buttonTextFont,
                        color: eUser().buttonTextColor,
                        fontSize: eUser().userFieldLabelFontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildAgeIcon(VoidCallback func, IconData icon) {
    return InkWell(
      onTap: func,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: kLineColor, width: 1)),
        child: Icon(
          icon,
          size: 2.h,
        ),
      ),
    );
  }

  showSymptomsTrackerSheet(BuildContext context, String bmi, String comment,
      String result, String bmr) {
    return AppConfig().showSheet(
        context,
        SizedBox(
          child: ResultPage(
            bmi: bmi,
            comment: comment,
            result: result,
            bmr: bmr,
          ),
        ),
        circleIcon: bsHeadPinIcon,
        bottomSheetHeight: 80.h,
        isSheetCloseNeeded: true, sheetCloseOnTap: () {
      Navigator.pop(context);
    });
  }

  final HomeRepository homeRepository = HomeRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bookAppointment(BuildContext context, String bmi, String comment,
      String result, String bmr) async {
    setState(() {
      isLoading = true;
    });
    final res = await HomeService(repository: homeRepository)
        .submitBmiBmrService(bmi,bmr);
    print("bookAppointment : " + res.runtimeType.toString());
    if (res.runtimeType == SuccessMessageModel) {
      setState(() {
        isLoading = false;
      });
      showSymptomsTrackerSheet(
        context,
        bmi,
        comment,
        result,
        bmr,
      );
    } else {
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        isLoading = false;
      });
    }
  }
}
