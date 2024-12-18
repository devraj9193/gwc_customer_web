import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_horizontal_date_picker/flutter_horizontal_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/error_model.dart';
import '../../model/evaluation_from_models/get_country_details_model.dart';
import '../../model/ship_track_model/sipping_approve_model.dart';
import '../../model/ship_track_model/user_address_model/get_user_address_model.dart';
import '../../model/ship_track_model/user_address_model/send_user_address_model.dart';
import '../../repository/api_service.dart';
import '../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../repository/shipping_repository/ship_track_repo.dart';
import '../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../services/shipping_service/ship_track_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/widgets.dart';

class NewShipmentApprovedScreen extends StatefulWidget {
  final String isForeign;
  const NewShipmentApprovedScreen({
    Key? key,
    required this.isForeign,
  }) : super(key: key);

  @override
  State<NewShipmentApprovedScreen> createState() =>
      _NewShipmentApprovedScreenState();
}

class _NewShipmentApprovedScreenState extends State<NewShipmentApprovedScreen> {
  final SharedPreferences _pref = AppConfig().preferences!;

  DateTime selectedDate = DateTime.now();
  String fullAddress = "";
  GetUserAddressModel? getUserAddress;

  bool showAddress = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserAddressData();
  }

  getUserAddressData() async {
    setState(() {
      showAddress = true;
    });
    final result = await ShipTrackService(repository: shipTrackRepository)
        .getUserAddressService();
    print("result: $result");

    if (result.runtimeType == GetUserAddressModel) {
      setState(() {
        print("nutri delight meal plan");
        GetUserAddressModel model = result as GetUserAddressModel;

        getUserAddress = model;

        String? pho = getUserAddress?.data?.user?.phone2 ==
                getUserAddress?.data?.user?.phone
            ? getUserAddress?.data?.user?.phone
            : getUserAddress?.data?.user?.phone2;

        fullAddress =
            "${getUserAddress?.data?.user?.address}, ${getUserAddress?.data?.address2}, ${getUserAddress?.data?.city}, ${getUserAddress?.data?.state}, ${getUserAddress?.data?.country} - ${getUserAddress?.data?.user?.pincode}.\nMob : $pho";

        phoneController =
            TextEditingController(text:pho);

        address1Controller =
            TextEditingController(text: getUserAddress?.data?.user?.address);
        address2Controller =
            TextEditingController(text: getUserAddress?.data?.address2);
        pinCodeController =
            TextEditingController(text: getUserAddress?.data?.user?.pincode);
        cityController =
            TextEditingController(text: getUserAddress?.data?.city);
        stateController =
            TextEditingController(text: getUserAddress?.data?.state);
        countryController =
            TextEditingController(text: getUserAddress?.data?.country);
      });
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showAddress = false;
    });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    print("width: ${MediaQuery.of(context).size.width}");
    print("height: ${MediaQuery.of(context).size.height}");
    final double height = MediaQuery.of(context).size.height;
    return MediaQuery.of(context).size.shortestSide > 600
        ? webViewScreen()
        : Scaffold(
            backgroundColor: kNumberCirclePurple,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 1.8.w, right: 1.w, top: 1.h),
                    child: buildAppBar(
                      () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 3.h, left: 15.w, right: 15.w),
                      child: Text(
                        "Please Pick the date on which you'd like us to deliver the kit.",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.dp,
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
                      child: Center(
                        child: SizedBox(
                            width:
                                MediaQuery.of(context).size.shortestSide > 600
                                    ? 50.w
                                    : double.maxFinite,
                            child: (showAddress)
                                ? Center(
                                    child: buildCircularIndicator(),
                                  )
                                : SingleChildScrollView(
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 3.h),
                                          Center(
                                            child: Image(
                                              image: const AssetImage(
                                                  "assets/images/Group 76497.png"),
                                              height:
                                                  height < 600 ? 18.h : 22.h,
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            child: Text(
                                              getUserAddress
                                                      ?.data?.user?.name ??
                                                  '',
                                              style: TextStyle(
                                                fontFamily: kFontBold,
                                                height: 1.5,
                                                color: eUser().mainHeadingColor,
                                                fontSize: 15.dp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 1.h),
                                            child: Row(
                                              children: [
                                                // Expanded ensures the Text takes up all available space
                                                Expanded(
                                                  child: Text(
                                                    fullAddress,
                                                    style: TextStyle(
                                                      fontFamily: kFontMedium,
                                                      height: 1.5,
                                                      color: eUser()
                                                          .mainHeadingColor,
                                                      fontSize: 14.dp,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 3.w),
                                                GestureDetector(
                                                  onTap: () {
                                                    showPopupDialog();
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/images/Icon feather-edit.svg",
                                                    color: Colors.grey,
                                                    fit: BoxFit.contain,
                                                    height: 3.h,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //       horizontal: 5.w),
                                          //   child: Text(
                                          //     "Mob : ${getUserAddress?.data?.user?.phone ?? ''}",
                                          //     style: TextStyle(
                                          //       fontFamily: kFontBook,
                                          //       height: 1.5,
                                          //       color: eUser().mainHeadingColor,
                                          //       fontSize: 13.dp,
                                          //     ),
                                          //   ),
                                          // ),
                                          SizedBox(height: 1.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            child: Text(
                                              "Choose Day",
                                              style: TextStyle(
                                                fontFamily: kFontMedium,
                                                color: eUser().mainHeadingColor,
                                                fontSize: 13.dp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 2.h),
                                            child: buildChooseDay(),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 1.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Please note:",
                                                  style: TextStyle(
                                                      fontFamily: kFontBold,
                                                      color: kNumberCircleRed,
                                                      fontSize: 12.dp),
                                                ),
                                                SizedBox(height: 1.h),
                                                Text(
                                                  "These are estimates, please allow a 1-2 day margin of variance.",
                                                  style: TextStyle(
                                                    height: 1.3,
                                                    fontFamily: kFontMedium,
                                                    color: eUser()
                                                        .userTextFieldColor,
                                                    fontSize: 12.dp,
                                                  ),
                                                ),
                                                SizedBox(height: 1.h),
                                                Text(
                                                  'Quick check! Is your address and mobile number still the same? Please confirm.',
                                                  style: TextStyle(
                                                    height: 1.3,
                                                    fontFamily: kFontMedium,
                                                    color: eUser()
                                                        .userTextFieldColor,
                                                    fontSize: 12.dp,
                                                  ),
                                                ),
                                                SizedBox(height: 1.h),
                                                widget.isForeign.isEmpty
                                                    ? const SizedBox()
                                                    : Text(
                                                        'Please enter an Indian Mobile Number and Address to  ship your kit.',
                                                        style: TextStyle(
                                                          height: 1.3,
                                                          fontFamily:
                                                              kFontMedium,
                                                          color:
                                                              gsecondaryColor,
                                                          fontSize: 12.dp,
                                                        ),
                                                      ),
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.h),
                                                    child: ButtonWidget(
                                                      onPressed: () async {
                                                        print(
                                                            "Selected Date : $selectedDate");

                                                        if (!isNotToday(
                                                            selectedDate)) {
                                                          AppConfig().showSnackbar(
                                                              context,
                                                              "Please Select Date",
                                                              isError: true);
                                                        } else {
                                                          if (widget
                                                                  .isForeign ==
                                                              "1") {
                                                            bool? confirm =
                                                                await _showConfirmationDialog(
                                                                    context);
                                                            if (confirm ==
                                                                true) {
                                                              // Perform the API call
                                                              sendApproveStatus(
                                                                  "yes");
                                                            }
                                                          } else {
                                                            sendApproveStatus(
                                                                "yes");
                                                          }
                                                        }
                                                      },
                                                      text: 'Submit',
                                                      isLoading: isSubmitted,
                                                      buttonWidth: 20.w,
                                                      radius: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  bool isNotToday(DateTime selectedDate) {
    final now = DateTime.now();
    return !(selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day);
  }

  buildChooseDay() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.h),
      child: HorizontalDatePicker(
        begin: DateTime.now().add(const Duration(days: 6)),
        end: DateTime.now().add(const Duration(days: 30)),
        itemCount: 26,
        itemSpacing: 20,
        selected: selectedDate,
        onSelected: (item) {
          setState(() {
            selectedDate = item;
          });
        },
        selectedColor: gBackgroundColor,
        itemHeight: 65,
        itemWidth: 45,
        itemBuilder: (DateTime itemValue, DateTime? selected) {
          print("this");
          print("itemValue: $itemValue");
          // print(DateFormat("dd/MM/yyyy").format(selectedDate) == DateFormat("dd/MM/yyyy").format(itemValue));
          if (DateFormat("dd/MM/yyyy").format(selectedDate) ==
              DateFormat("dd/MM/yyyy").format(itemValue)) {
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
                      fontSize: 13.dp,
                      color: gWhiteColor,
                    ),
                  ),
                  Text(
                    itemValue.formatted(pattern: "EEE"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontMedium,
                      fontSize: 11.dp,
                      color: gWhiteColor,
                    ),
                  ),
                ],
              ),
            );
          } else {
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
                      fontSize: 11.dp,
                      color: eUser().mainHeadingColor,
                    ),
                  ),
                  Text(
                    itemValue.formatted(pattern: "EEE"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontBook,
                      fontSize: 08.dp,
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
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirmation",
            style: TextStyle(
              color: gBlackColor,
              fontSize: 15.dp,
              fontFamily: kFontBold,
            ),
          ),
          content: Text(
            "Ensure that the address and mobile number provided for the shipment of the kit are verified.",
            style: TextStyle(
              color: gBlackColor,
              fontSize: 15.dp,
              fontFamily: kFontMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  bool isSubmitted = false;

  sendApproveStatus(String status) async {
    print(DateFormat("dd/MM/yyyy").format(selectedDate));
    setState(() {
      isSubmitted = true;
    });
    final res = await ShipTrackService(repository: shipTrackRepository)
        .sendShippingApproveStatusService(status,
            selectedDate: DateFormat("dd/MM/yyyy").format(selectedDate));

    if (res.runtimeType == ShippingApproveModel) {
      ShippingApproveModel model = res as ShippingApproveModel;
      print('success: ${model.message}');
      Navigator.pop(context);
    } else {
      ErrorModel model = res as ErrorModel;
      print('error: ${model.message}');
      AppConfig().showSnackbar(context, model.message!, isError: true);
    }
    setState(() {
      isSubmitted = false;
    });
  }

  showPopupDialog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (_, setstate) {
          updateProgressState = setstate;
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              'Address : ',
              style: TextStyle(
                fontFamily: kFontBold,
                height: 1.5,
                color: eUser().mainHeadingColor,
                fontSize: 15.dp,
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildLabelTextField('Phone', fontSize: questionFont),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: phoneController,
                      cursorColor: kPrimaryColor,
                      // focusNode: phoneFocusNode,
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Phone Number';
                        } else {
                          return null;
                        }
                      },
                      // onFieldSubmitted: (value) {
                      //   if (phoneController.text.isEmpty) {
                      //     getUserAddressFromPhone(value);
                      //   }
                      // },
                      // onChanged: (value) {
                      //   setState(() {
                      //     if (phoneController.text.isEmpty) {
                      //       getUserAddressFromPhone(value);
                      //     }
                      //   }); // Update the icon when text changes
                      // },
                      decoration: CommonDecoration.buildTextInputDecoration(
                        "Phone Number",
                        phoneController,
                        //   suffixIcon: (phoneController.text.length == 10)
                        //       ? GestureDetector(
                        //     onTap: () {
                        //       getUserAddressFromPhone(phoneController.text);
                        //     },
                        //     child: const Icon(
                        //       Icons.keyboard_arrow_right,
                        //       color: gMainColor,
                        //       size: 22,
                        //     ),
                        //   )
                        //       : null,
                      ),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                      ],
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    SizedBox(height: 2.h),
                    buildLabelTextField('Flat/House Number',
                        fontSize: questionFont),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: address1Controller,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Flat/House Number';
                        } else {
                          return null;
                        }
                      },
                      decoration: CommonDecoration.buildTextInputDecoration(
                          "Flat/House Number", address1Controller),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      // keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                      ],
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    SizedBox(height: 2.h),
                    buildLabelTextField(
                      'Full Postal Address To Deliver Your Ready To Cook Kit',
                      fontSize: questionFont,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: address2Controller,
                      cursorColor: kPrimaryColor,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Address';
                        } else if (value.length < 10) {
                          return 'Please enter your Address';
                        } else {
                          return null;
                        }
                      },
                      decoration: CommonDecoration.buildTextInputDecoration(
                          "Enter your Postal Address", address2Controller),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    buildLabelTextField(
                      'Pin Code',
                      fontSize: questionFont,
                    ),
                    FocusScope(
                      onFocusChange: (value) {
                        print(value);
                        if (cityController.text.isEmpty) {
                          if (!value) {
                            print("editing");
                            // String code = _pref?.getString(AppConfig.countryCode) ?? '';
                            if (pinCodeController.text.length < 6) {
                              AppConfig().showSnackbar(
                                  context, 'Pin code should be 6 digits',
                                  bottomPadding: 100);
                            } else {
                              fetchCountry(pinCodeController.text, 'IN');
                            }
                          }
                        }
                      },
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: pinCodeController,
                        cursorColor: kPrimaryColor,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Pin Code';
                          } else if (value.length > 7) {
                            return 'Please enter your valid Pin Code';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (cityController.text.isEmpty) {
                            String code =
                                _pref.getString(AppConfig.countryCode) ?? 'IN';
                            if (code.isNotEmpty && code == 'IN') {
                              fetchCountry(value, 'IN');
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                        decoration: CommonDecoration.buildTextInputDecoration(
                          "Your answer",
                          pinCodeController,
                          suffixIcon: (pinCodeController.text.length != 6)
                              ? null
                              : GestureDetector(
                                  onTap: () {
                                    String code = _pref
                                            .getString(AppConfig.countryCode) ??
                                        '';
                                    print('code: $code');
                                    // if (code.isNotEmpty && code == 'IN') {
                                    //   fetchCountry(pinCodeController.text, code);
                                    // }
                                    fetchCountry(pinCodeController.text, 'IN');

                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: gMainColor,
                                    size: 22,
                                  ),
                                ),
                        ),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[1-9][0-9]*'))
                        ],
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.numberWithOptions(),
                        maxLength: 6,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    buildLabelTextField(
                      'City',
                      fontSize: questionFont,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: cityController,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                          return 'Please Enter City';
                        } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                          return 'Please Enter City';
                        } else {
                          return null;
                        }
                      },
                      decoration: CommonDecoration.buildTextInputDecoration(
                          "Please Select City", cityController),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(height: 2.h),
                    buildLabelTextField(
                      'State',
                      fontSize: questionFont,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: stateController,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                          return 'Please Enter State';
                        } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                          return 'Please Enter State';
                        } else {
                          return null;
                        }
                      },
                      decoration: CommonDecoration.buildTextInputDecoration(
                          "Please Select State", stateController),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(height: 2.h),
                    buildLabelTextField(
                      'Country',
                      fontSize: questionFont,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: countryController,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                          return 'Please Enter Country';
                        } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                          return 'Please Enter Country';
                        } else {
                          return null;
                        }
                      },
                      decoration: CommonDecoration.buildTextInputDecoration(
                          "Please Select Country", countryController),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Close the dialog without doing anything
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontFamily: kFontBook,
                    color: gsecondaryColor,
                    fontSize: 14.dp,
                  ),
                ),
              ),
              ButtonWidget(
                text: "Submit",
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Map finalMap = {
                      'phone2': phoneController.text,
                      "flat_no": address1Controller.text,
                      "address": address2Controller.text,
                      "pincode": pinCodeController.text,
                      "city": cityController.text,
                      "state": stateController.text,
                      "country": countryController.text,
                    };
                    updateAddressData(finalMap);
                  }
                },
                isLoading: isLoading,
                buttonWidth: 15.w,
                radius: 10,
              ),
            ],
          );
        });
      },
    ).then((value) {
      fullAddress = "";
    });
  }

  bool ignoreFields = true;

  void fetchCountry(String pinCode, String countryCode) async {
    Navigator.of(context).push(
      PageRouteBuilder(
          opaque: false, // set to false
          pageBuilder: (_, __, ___) => Container(
                child: buildCircularIndicator(),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                  ],
                ),
              )),
    );

    final res = await EvaluationFormService(repository: evalRepository)
        .getCountryDetailsService(pinCode, countryCode);
    print(res);
    if (res.runtimeType == GetCountryDetailsModel) {
      GetCountryDetailsModel model = res as GetCountryDetailsModel;
      if (model.response.postOffice.isNotEmpty) {
        print(model.response.postOffice.first.state);
        setState(() {
          stateController.text = model.response.postOffice.first.state ?? '';
          cityController.text = model.response.postOffice.first.district ?? '';
          countryController.text =
              model.response.postOffice.first.country ?? '';
        });
      }
    } else {
      ErrorModel model = res as ErrorModel;
      print(model.message!);
      setState(() {
        ignoreFields = false;
      });
      AppConfig().showSnackbar(context, "Please Enter Valid Pincode",
          isError: true, bottomPadding: 100);
    }
    Navigator.pop(context);
  }

  bool isLoading = false;

  /// we r showing in stateful builder so this parameter will be used
  /// when we get setstate we will assign to this parameter based on that logout progress is used
  var updateProgressState;

  updateAddressData(Map user) async {
    updateProgressState(() {
      isLoading = true;
    });

    final res = await ShipTrackService(repository: shipTrackRepository)
        .sendUserAddressService(user);
    Navigator.pop(context);
    if (res.runtimeType == ErrorModel) {
      updateProgressState(() {
        isLoading = false;
      });
      final result = res as ErrorModel;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    } else {
      updateProgressState(() {
        isLoading = false;
      });
      getUserAddressData();
      final result = res as SendUserAddressModel;
      AppConfig().showSnackbar(context, result.errorMsg ?? '');
    }
    updateProgressState(() {
      isLoading = false;
    });
  }

  final EvaluationFormRepository evalRepository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final ShipTrackRepository shipTrackRepository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  webViewScreen() {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
      body: (showAddress)
          ? Center(
              child: buildCircularIndicator(),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: double.maxFinite,
                    margin:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
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
                          buildAppBar(
                            () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(height: 2.h),
                          Center(
                            child: Image(
                              image: const AssetImage(
                                  "assets/images/Group 76497.png"),
                              height: 30.h,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            getUserAddress?.data?.user?.name ?? '',
                            style: TextStyle(
                              fontFamily: kFontBold,
                              height: 2,
                              color: eUser().mainHeadingColor,
                              fontSize: 15.dp,
                            ),
                          ),
                          Text(
                            "Mob : ${getUserAddress?.data?.user?.phone ?? ''}",
                            style: TextStyle(
                              fontFamily: kFontBook,
                              height: 2,
                              color: eUser().mainHeadingColor,
                              fontSize: 13.dp,
                            ),
                          ),
                          Row(
                            children: [
                              // Expanded ensures the Text takes up all available space
                              Expanded(
                                child: Text(
                                  fullAddress,
                                  style: TextStyle(
                                    fontFamily: kFontMedium,
                                    height: 2,
                                    color: eUser().mainHeadingColor,
                                    fontSize: 14.dp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              GestureDetector(
                                onTap: () {
                                  showPopupDialog();
                                },
                                child: SvgPicture.asset(
                                  "assets/images/Icon feather-edit.svg",
                                  color: Colors.grey,
                                  fit: BoxFit.contain,
                                  height: 3.h,
                                ),
                              ),
                            ],
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please Pick the date on which you'd like us to deliver the kit.",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.dp,
                            height: 1.5,
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Choose Day",
                          style: TextStyle(
                            fontFamily: kFontMedium,
                            color: eUser().mainHeadingColor,
                            fontSize: 15.dp,
                          ),
                        ),
                        buildChooseDay(),
                        Text(
                          "Please note:",
                          style: TextStyle(
                              fontFamily: kFontBold,
                              color: kNumberCircleRed,
                              fontSize: 13.dp),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "These are estimates, please allow a 1-2 day margin of variance.",
                          style: TextStyle(
                            height: 1.3,
                            fontFamily: kFontMedium,
                            color: eUser().userTextFieldColor,
                            fontSize: 14.dp,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Quick check! Is your address and mobile number still the same? Please confirm.',
                          style: TextStyle(
                            height: 1.3,
                            fontFamily: kFontMedium,
                            color: eUser().userTextFieldColor,
                            fontSize: 14.dp,
                          ),
                        ),
                        widget.isForeign.isEmpty
                            ? const SizedBox()
                            : Text(
                                'Please enter an Indian Mobile Number and Address to  ship your kit.',
                                style: TextStyle(
                                  height: 1.3,
                                  fontFamily: kFontMedium,
                                  color: gsecondaryColor,
                                  fontSize: 12.dp,
                                ),
                              ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: ButtonWidget(
                              onPressed: () async {
                                if (!isNotToday(selectedDate)) {
                                  AppConfig().showSnackbar(
                                      context, "Please Select Date",
                                      isError: true);
                                } else {
                                  if (widget.isForeign == "1") {
                                    bool? confirm =
                                        await _showConfirmationDialog(context);
                                    if (confirm == true) {
                                      // Perform the API call
                                      sendApproveStatus("yes");
                                    }
                                  } else {
                                    sendApproveStatus("yes");
                                  }
                                  // sendApproveStatus("yes");
                                }
                              },
                              text: 'Submit',
                              isLoading: isSubmitted,
                              buttonWidth: 20.w,
                              radius: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
