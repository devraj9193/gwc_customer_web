/*
Api used ->
var registerUserUrl = "${AppConfig().BASE_URL}/api/register";

Need to pass the
device Id, FcmToken to the api along with those fields data

 */

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/screens/user_registration/new_user/sit_back_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
import '../../../model/error_model.dart';
import '../../../model/new_user_model/register/register_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/new_user_repository/register_screen_repository/register_repo.dart';
import '../../../services/new_user_service/register_screen_service/register_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/unfocus_widget.dart';
import '../../../widgets/widgets.dart';
import 'about_the_program.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameFormKey = GlobalKey<FormState>();
  final ageFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();
  final mobileFormKey = GlobalKey<FormState>();

  late UserRegisterService _userRegisterService;

  SharedPreferences? _pref;

  String? deviceId, fcmToken;

  bool isLoading = false;

  late FocusNode _nameFocus, _ageFocus, _emailFocus, mobileFocus;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  String countryCode = '+91';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userRegisterService = UserRegisterService(registerRepo: repository);
    _nameFocus = FocusNode();
    _nameFocus.addListener(() {});
    emailController.addListener(() {
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
    ageController.addListener(() {
      setState(() {});
    });
    mobileController.addListener(() {
      setState(() {});
    });
    getDeviceId();
  }

  getDeviceId() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      deviceId = _pref!.getString(AppConfig().deviceId);
      // fcmToken = _pref!.getString(AppConfig.FCM_TOKEN);
      fcmToken = _pref!.getString(AppConfig.FCM_WEB_TOKEN);
    });
    print("fcm token: $fcmToken");
    print("devId: $deviceId");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameFocus.removeListener(() { });
    nameController.removeListener(() {});
    ageController.removeListener(() {});
    mobileController.removeListener(() {});
    emailController.removeListener(() {});
    super.dispose();
  }

  Future<bool> onBack() async{
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AboutTheProgram()));
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBack,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: gBackgroundColor,
          body: UnfocusWidget(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 1.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 1.5.w, right: 1.5.w),
                      child: buildAppBar(() {
                        onBack();
                      })
                    ),
                    _mainView()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _mainView(){
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2.h,
          ),
          Text(
            "Heal Your Gut Now",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: eUser().mainHeadingFont,
                fontSize: eUser().mainHeadingFontSize,
                color: eUser().mainHeadingColor
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Full Name',
                style: TextStyle(
                    fontFamily: eUser().userFieldLabelFont,
                    fontSize: eUser().userFieldLabelFontSize,
                    color: eUser().userFieldLabelColor
                ),
              ),
              SizedBox(height: 0.5.h),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: nameFormKey,
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: nameController,
                  cursorColor: gPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                      return 'Please enter your Name';
                    } else {
                      return null;
                    }
                  },
                  focusNode: _nameFocus,
                  decoration:
                  CommonDecoration.buildTextInputDecoration(
                    "Name", nameController,
                    enabledBorder: (nameController.text.isEmpty) ? null : UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: eUser().focusedBorderColor,
                            width: eUser().focusedBorderWidth
                        )
                    ),
                    focusBoder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: eUser().focusedBorderColor,
                            width: eUser().focusedBorderWidth
                        )
                      // borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  style: TextStyle(
                      fontFamily: eUser().userTextFieldFont,
                      fontSize: eUser().userTextFieldFontSize,
                      color: eUser().userTextFieldColor
                  ),
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Text(
                'Age',
                style: TextStyle(
                    fontFamily: eUser().userFieldLabelFont,
                    fontSize: eUser().userFieldLabelFontSize,
                    color: eUser().userFieldLabelColor
                ),
              ),
              SizedBox(height: 0.5.h),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: ageFormKey,
                child: TextFormField(
                  controller: ageController,
                  cursorColor: gPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Age';
                    }
                    else if(int.parse(value) < 10){
                      return 'Age should be Greater than 10';
                    }
                    else if(int.parse(value) >= 100){
                      return 'Age should be Lesser than 100';
                    }
                    else {
                      return null;
                    }
                  },
                  decoration:
                  CommonDecoration.buildTextInputDecoration(
                    "Age", ageController,
                    enabledBorder: (ageController.text.isEmpty) ? null : UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: eUser().focusedBorderColor,
                            width: eUser().focusedBorderWidth
                        )
                    ),
                    focusBoder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: eUser().focusedBorderColor,
                            width: eUser().focusedBorderWidth
                        )
                      // borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  style: TextStyle(
                      fontFamily: eUser().userTextFieldFont,
                      fontSize: eUser().userTextFieldFontSize,
                      color: eUser().userTextFieldColor
                  ),
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                  ],
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Text(
                'Gender',
                style: TextStyle(
                    fontFamily: eUser().userFieldLabelFont,
                    fontSize: eUser().userFieldLabelFontSize,
                    color: eUser().userFieldLabelColor
                ),
              ),
              SizedBox(height: 0.5.h),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: genderSelection(),
              ),
              SizedBox(
                height: 1.0.h,
              ),
              Text(
                'Email',
                style: TextStyle(
                    fontFamily: eUser().userFieldLabelFont,
                    fontSize: eUser().userFieldLabelFontSize,
                    color: eUser().userFieldLabelColor
                ),
              ),
              SizedBox(height: 0.5.h),
              Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: emailFormKey,
                child: TextFormField(
                  controller: emailController,
                  cursorColor: gPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email Address';
                    } else if (!validEmail(value)) {
                      return 'Please enter valid Email Address';
                    }
                  },
                  decoration:
                  CommonDecoration.buildTextInputDecoration(
                    "Email", emailController,
                    enabledBorder: (emailController.text.isEmpty) ? null : UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: eUser().focusedBorderColor,
                            width: eUser().focusedBorderWidth
                        )
                    ),
                    focusBoder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: eUser().focusedBorderColor,
                            width: eUser().focusedBorderWidth
                        )
                      // borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  style: TextStyle(
                      fontFamily: eUser().userTextFieldFont,
                      fontSize: eUser().userTextFieldFontSize,
                      color: eUser().userTextFieldColor
                  ),
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Text(
                'Mobile Number',
                style: TextStyle(
                    fontFamily: eUser().userFieldLabelFont,
                    fontSize: eUser().userFieldLabelFontSize,
                    color: eUser().userFieldLabelColor
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CountryListPick(
                  //   useSafeArea: true,
                  //   appBar: PreferredSize(
                  //     preferredSize: Size(double.infinity, 60),
                  //     child: Padding(
                  //       padding: EdgeInsets.only(
                  //           left: 4.w,
                  //           right: 4.w,
                  //           top: 1.h,
                  //           bottom: 1.h),
                  //       child: buildAppBar(() {
                  //         Navigator.pop(context);
                  //       }),
                  //     ),
                  //   ),
                  //   theme: CountryTheme(
                  //     isShowFlag: false,
                  //     isShowTitle: false,
                  //     isShowCode: true,
                  //     isDownIcon: true,
                  //     showEnglishName: true,
                  //   ),
                  //   // Set default value
                  //   initialSelection: countryCode,
                  //   useUiOverlay: false,
                  //   // or
                  //   // initialSelection: 'US'
                  //   onChanged: (CountryCode? code) {
                  //     print(code!.name);
                  //     print(code.code);
                  //     print(code.dialCode);
                  //     print(code.flagUri);
                  //     setState(() {
                  //       countryCode = code.dialCode ?? '+91';
                  //     });
                  //   },
                  //   // pickerBuilder: (_, countryCode){
                  //   //   return Container(
                  //   //     decoration: BoxDecoration(
                  //   //       border: Border(
                  //   //         bottom: BorderSide(
                  //   //             color: kPrimaryColor, width: 1.0, style: BorderStyle.solid)
                  //   //       ),
                  //   //     ),
                  //   //     child: Text(countryCode?.dialCode ?? '',
                  //   //     style: TextStyle(
                  //   //         fontFamily: "GothamBook",
                  //   //         color: gMainColor,
                  //   //         fontSize: 11.dp),),
                  //   //   );
                  //   // },
                  // ),
                  Expanded(
                    child: CountryCodePicker(
                      // flagDecoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(7),
                      // ),
                      showDropDownButton: false,
                      showFlagDialog: true,
                      hideMainText: false,
                      showFlagMain: false,
                      showCountryOnly: false,
                      textStyle: TextStyle(
                          fontFamily: eUser().userTextFieldFont,
                          fontSize: eUser().userTextFieldFontSize,
                          color: eUser().userTextFieldColor
                      ),
                      padding: EdgeInsets.zero,
                      favorite: ['+91','IN'],
                      initialSelection: countryCode,
                      onChanged: (val){
                        print(val.code);
                        setState(() {
                          countryCode = val.dialCode.toString();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Form(
                      autovalidateMode:
                      AutovalidateMode.disabled,
                      key: mobileFormKey,
                      child: TextFormField(
                        controller: mobileController,
                        cursorColor: gPrimaryColor,
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Mobile Number';
                          } else if (!isPhone(value)) {
                            return 'Please enter valid Mobile Number';
                          }
                        },
                        decoration:
                        CommonDecoration.buildTextInputDecoration(
                          "Mobile Number", mobileController,
                          enabledBorder: (mobileController.text.isEmpty) ? null : UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: eUser().focusedBorderColor,
                                  width: eUser().focusedBorderWidth
                              )
                          ),
                          focusBoder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: eUser().focusedBorderColor,
                                  width: eUser().focusedBorderWidth
                              )
                            // borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().userTextFieldFontSize,
                            color: eUser().userTextFieldColor
                        ),
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.5.h,
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Center(
            child: IntrinsicWidth(
              child: GestureDetector(
                onTap: isLoading ? null : () {
                  if (nameFormKey.currentState!.validate() &&
                      ageFormKey.currentState!.validate() &&
                      emailFormKey.currentState!.validate() &&
                      mobileFormKey.currentState!.validate()) {
                    if (nameController.text.isNotEmpty &&
                        ageController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        mobileController.text.isNotEmpty) {
                      if (_selectedGender != -1) {
                        // testingMethod();
                        submitEnquiryForm(
                            nameController.text,
                            ageController.text,
                            _selectedGender == 0 ? 'male' : 'female',
                            emailController.text,
                            mobileController.text);
                      } else {
                        AppConfig().showSnackbar(
                            context, 'Please Select Gender',
                            isError: true);
                      }
                    }
                  }
                },
                child: Container(
                
                  padding: EdgeInsets.symmetric(
                      vertical: 1.5.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: eUser().buttonColor,
                    borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                    // border: Border.all(
                    //     width: eUser().buttonBorderWidth
                    // ),
                  ),
                  child: (isLoading) ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                      : Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: eUser().buttonTextFont,
                        color: eUser().buttonTextColor,
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
    );
  }

  int _selectedGender = -1;

  genderSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:4.0,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                _selectedGender = 0;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  child: Radio(
                    value: 0,
                    groupValue: _selectedGender,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  'Male',
                  style: TextStyle(
                    color: (_selectedGender == 0) ? kTextColor : gHintTextColor,
                    fontFamily: (_selectedGender == 0) ? kFontMedium : kFontBook,
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 20,),
          GestureDetector(
            onTap: (){
              setState(() {
                _selectedGender = 1;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  // height: 10,
                  child: Radio(
                    value: 1,
                    groupValue: _selectedGender,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  'Female',
                  style: TextStyle(
                    color: (_selectedGender == 1) ? kTextColor : gHintTextColor,
                    fontFamily: (_selectedGender == 1) ? kFontMedium : kFontBook,
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 20,),
          GestureDetector(
            onTap: (){
              setState(() {
                _selectedGender = 2;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  // height: 10,
                  child: Radio(
                    value: 2,
                    groupValue: _selectedGender,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    activeColor: eUser().kRadioButtonColor,
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  'Other',
                  style: TextStyle(
                  color: (_selectedGender == 2) ? kTextColor : gHintTextColor,
                    fontFamily: (_selectedGender == 2) ? kFontMedium : kFontBook,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  final RegisterRepo repository = RegisterRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bool validEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isPhone(String input) =>
      RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);

  void submitEnquiryForm(String name, String age, String gender, String email,
      String mobileNumber) async {
    setState(() {
      isLoading = true;
    });
    print("fcmToken : $fcmToken");
    final res = await _userRegisterService.registerUserService(
        name: name,
        age: int.parse(age),
        gender: gender,
        email: email,
        phone: mobileNumber,
        countryCode: countryCode,
        deviceId: deviceId!,
      fcmToken: '',
      webDeviceToken: fcmToken ?? '',
    );

    print("registerUser:$res");
    print("res.runtimeType: ${res.runtimeType}");

    if (res.runtimeType == RegisterResponse) {
      RegisterResponse response = res;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SitBackScreen(),
        ),
          (route) => false
      );
    }
    else {
      String result = (res as ErrorModel).message ?? '';
      AppConfig().showSnackbar(context, result, isError: true, duration: 4);

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => const SitBackScreen(),
      //     ),
      //         (route) => route.isFirst
      // );
    }
    setState(() {
      isLoading = false;
    });
  }

}
