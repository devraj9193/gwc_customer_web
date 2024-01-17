/*
we r taking details from this screen
uploading to api in upload report screen

here we r using cityname api to get city and state from pincode
for that used api: "http://www.postalpincode.in/api/pincode/"

here we need to pass pincode for that api

 */

import 'dart:convert';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:gwc_customer_web/widgets/dart_extensions.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
import '../../../utils/app_config.dart';
import '../../model/country_model.dart';
import '../../model/dashboard_model/report_upload_model/report_upload_model.dart';
import '../../model/error_model.dart';
import '../../model/evaluation_from_models/evaluation_model_format1.dart';
import '../../model/evaluation_from_models/get_country_details_model.dart';
import '../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import '../../model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import '../../model/profile_model/user_profile/user_profile_model.dart';
import '../../repository/api_service.dart';
import '../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../services/profile_screen_service/user_profile_service.dart';
import '../../utils/country_list.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../uvdesk/ticket_details_screen.dart';
import 'check_box_settings.dart';
import 'personal_details_screen2.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final bool showData;
  const PersonalDetailsScreen({Key? key, this.padding, this.showData = false})
      : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  Future? _getEvaluationDataFuture;

  final _pref = AppConfig().preferences;

  bool _ignoreFields = true;

  int ft = -1;
  int inches = -1;
  String heightText = '';

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final fnameKey = GlobalKey<FormState>();
  final lNameKey = GlobalKey<FormState>();
  final maritalKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final ageKey = GlobalKey<FormState>();
  final genderKey = GlobalKey<FormState>();
  final flatKey = GlobalKey<FormState>();
  final addresskey = GlobalKey<FormState>();
  final pincodeKey = GlobalKey<FormState>();

  final _healthkey1 = GlobalKey<FormState>();

  final cityKey = GlobalKey<FormState>();
  final stateKey = GlobalKey<FormState>();
  final countryKey = GlobalKey<FormState>();
  final weightKey = GlobalKey<FormState>();
  final heightKey = GlobalKey<FormState>();
  final afterHeightKey = GlobalKey<FormState>();
  final health1Key = GlobalKey<FormState>();
  final health2Key = GlobalKey<FormState>();
  final tongueKey = GlobalKey<FormState>();

  final urinIncreasedKey = GlobalKey<FormState>();
  final urineColorKey = GlobalKey<FormState>();

  final urineSmellkey = GlobalKey<FormState>();
  final urineLooksKey = GlobalKey<FormState>();
  final stoolTypeKey = GlobalKey<FormState>();
  final medicalIntervenKey = GlobalKey<FormState>();
  final medicationKey = GlobalKey<FormState>();
  final holisticKey = GlobalKey<FormState>();

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController healController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  TextEditingController checkbox1OtherController = TextEditingController();
  TextEditingController digestionController = TextEditingController();
  TextEditingController specialDietController = TextEditingController();
  TextEditingController foodAllergyController = TextEditingController();
  TextEditingController intoleranceController = TextEditingController();
  TextEditingController cravingsController = TextEditingController();
  TextEditingController dislikeFoodController = TextEditingController();
  TextEditingController goToBedController = TextEditingController();
  TextEditingController wakeUpController = TextEditingController();
  TextEditingController exerciseController = TextEditingController();
  TextEditingController stoolsController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();
  TextEditingController tongueCoatingController = TextEditingController();
  TextEditingController urinColorController = TextEditingController();
  TextEditingController urinSmellController = TextEditingController();
  TextEditingController urinLooksLikeController = TextEditingController();
  TextEditingController medicalInterventionsDoneController =
      TextEditingController();
  TextEditingController medicationsController = TextEditingController();
  TextEditingController holisticController = TextEditingController();

  String emptyStringMsg = AppConfig().emptyStringMsg;
  String maritalStatus = "";
  String gender = "";
  String foodPreference = "";
  String tasteYouEnjoy = "";
  String mealsYouHaveADay = "";
  final String otherText = "Other";

  String selectedValue5 = "";
  String selectedValue6 = "";
  String selectedValue7 = "";
  String selectedValue8 = "";
  String selectedValue9 = "";
  String selectedValue10 = "";
  String selectedValue11 = "";
  String selectedValue12 = "";
  String selectedValue13 = "";
  String selectedValue14 = "";
  String selectedValue15 = "";
  String selectedValue16 = "";
  String selectedValue17 = "";
  String selectedValue18 = "";
  String selectedValue19 = "";
  String selectedValue20 = "";
  String selectedValue21 = "";
  String selectedValue22 = "";
  String tongueCoatingRadio = "";
  String urinationValue = "";
  String urineColorValue = "";
  String urineLookLikeValue = "";

  final healthCheckBox1 = <CheckBoxSettings>[
    CheckBoxSettings(title: "Autoimmune Diseases"),
    CheckBoxSettings(title: "Endocrine Diseases (Thyroid/Diabetes/PCOS)"),
    CheckBoxSettings(
        title:
            "Heart Diseases (Palpitations/Low Blood Pressure/High Blood Pressure)"),
    CheckBoxSettings(title: "Renal/Kidney Diseases (Kidney Stones)"),
    CheckBoxSettings(
        title: "Liver Diseases (Cirrhosis/Fatty Liver/Hepatitis/Jaundice)"),
    CheckBoxSettings(
        title:
            "Neurological Diseases (Seizures/Fits/Convulsions/Headache/Migraine/Vertigo)"),
    CheckBoxSettings(
        title:
            "Digestive Diseases (Hernia/Hemorrhoids/Piles/Indigestion/Gall Stone/Pancreatitis/Irritable Bowel Syndrome)"),
    CheckBoxSettings(
        title:
            "Skin Diseases (Psoriasis/Acne/Eczema/Herpes,/Skin Allergies/Dandruff/Rashes)"),
    CheckBoxSettings(
        title:
            "Respiratory Diseases (Athama/Allergic bronchitis/Rhinitis/Sinusitis/Frequent Cold, Cough & Fever/Tonsillitis/Wheezing)"),
    CheckBoxSettings(
        title:
            "Reproductive Diseases (PCOD/Infertility/MenstrualDisorders/Heavy or Scanty Period Bleeding/Increased or Decreased Sexual Drive/Painful Periods /Irregular Cycles)"),
    CheckBoxSettings(
        title:
            "Skeletal Muscle Disorders (Muscular Dystrophy/Rheumatoid Arthritis/Arthritis/Spondylitis/Loss ofMuscle Mass)"),
    CheckBoxSettings(
        title:
            "Psychological/Psychiatric Issues (Depression,Anxiety, OCD, ADHD, Mood Disorders, Schizophrenia,Personality Disorders, Eating Disorders)"),
    CheckBoxSettings(title: "None Of The Above"),
    CheckBoxSettings(title: "Other:"),
  ];

  List<String> selectedHealthCheckBox1 = [];

  final healthCheckBox2 = <CheckBoxSettings>[
    CheckBoxSettings(title: "Body Odor"),
    CheckBoxSettings(title: "Dry Mouth"),
    CheckBoxSettings(title: "Severe Thirst"),
    CheckBoxSettings(title: "Severe Sweet Cravings In The Evening/Night"),
    CheckBoxSettings(title: "Astringent/Pungent/Sour Taste In The Mouth"),
    CheckBoxSettings(title: "Burning Sensation In Your Chest"),
    CheckBoxSettings(title: "Heavy Stomach"),
    CheckBoxSettings(title: "Acid Reflux/Belching/Acidic Regurgitation"),
    CheckBoxSettings(title: "Bad Breathe"),
    CheckBoxSettings(title: "Sweet/Salty/Sour Taste In Your Mouth"),
    CheckBoxSettings(title: "Severe Sweet Craving During the Day"),
    CheckBoxSettings(title: "Dryness In The Mouth Inspite Of Salivatio"),
    CheckBoxSettings(title: "Mood Swings"),
    CheckBoxSettings(title: "Chronic Fatigue or Low Energy Levels"),
    CheckBoxSettings(title: "Insomnia"),
    CheckBoxSettings(title: "Frequent Head/Body Aches"),
    CheckBoxSettings(title: "Gurgling Noise In Your Tummy"),
    CheckBoxSettings(title: "Hypersalivation While Feeling Nauseous"),
    CheckBoxSettings(
        title: "Cannot Start My Day Without A Hot Beverage Once I'm Up"),
    CheckBoxSettings(title: "Gas & Bloating"),
    CheckBoxSettings(title: "Constipation"),
    CheckBoxSettings(title: "Low Immunity/ Falling Ill Frequently"),
    CheckBoxSettings(title: "Inflamation"),
    CheckBoxSettings(title: "Muscle Cramps & Painr"),
    CheckBoxSettings(title: "Acne/Skin Breakouts/Boils"),
    CheckBoxSettings(title: "PMS(Women Only)"),
    CheckBoxSettings(title: "Heaviness"),
    CheckBoxSettings(title: "Lack Of Energy Or Lethargy"),
    CheckBoxSettings(title: "Loss Of Appetite"),
    CheckBoxSettings(title: "Increased Salivation"),
    CheckBoxSettings(title: "Profuse Sweating"),
    CheckBoxSettings(title: "Loss Of Taste"),
    CheckBoxSettings(title: "Nausea Or Vomiting"),
    CheckBoxSettings(title: "Metallic Or Bitter Taste"),
    CheckBoxSettings(title: "Weight Loss"),
    CheckBoxSettings(title: "Weight Gain"),
    CheckBoxSettings(title: "Burping"),
    CheckBoxSettings(
        title:
            "Sour Regurgitation/ Food Regurgitation (Food Coming back to your mouth)"),
    CheckBoxSettings(title: "Burning while passing urine"),
    CheckBoxSettings(title: "None Of The Above")
  ];

  final foodCheckBox = [
    CheckBoxSettings(title: "North Indian"),
    CheckBoxSettings(title: "South Indian"),
    CheckBoxSettings(title: "Continental"),
    CheckBoxSettings(title: "Mediterranean"),
  ];

  final sleepCheckBox = [
    CheckBoxSettings(title: "I Toss& Turn Alot In Bed"),
    CheckBoxSettings(title: "I Get The Feeling Refreshed"),
    CheckBoxSettings(title: "I Have Difficulty Falling Asleep"),
    CheckBoxSettings(title: "I Sleep Deep"),
    CheckBoxSettings(title: "I Wake Up Feeling Heavy"),
  ];

  final lifeStyleCheckBox = [
    CheckBoxSettings(title: "Drugs"),
    CheckBoxSettings(title: "Cigarettes"),
    CheckBoxSettings(title: "Alcohol"),
    CheckBoxSettings(title: "Others"),
    CheckBoxSettings(title: "None"),
  ];

  final gutTypeCheckBox = [
    CheckBoxSettings(title: "Dry Mouth"),
    CheckBoxSettings(title: "Astringent/Pungent/Sour Taste In The Mouth"),
    CheckBoxSettings(title: "Severe Thrist"),
    CheckBoxSettings(title: "Burning Sensation In Your Chest"),
    CheckBoxSettings(title: "Acid Reflux/Belching/Acidic Regurgitation"),
    CheckBoxSettings(title: "Severe Sweet Cravings In The Evening/Night"),
    CheckBoxSettings(title: "Bad Breathe"),
    CheckBoxSettings(title: "Chest Burning With Nausia"),
    CheckBoxSettings(title: "Heavy Stomach"),
    CheckBoxSettings(title: "Bloating"),
    CheckBoxSettings(title: "A Lot Of Salivation"),
    CheckBoxSettings(title: "Sweet/Salty/Sour Taste In Your Mouth"),
    CheckBoxSettings(title: "Severe Bitter craving During The Day"),
    CheckBoxSettings(title: "Dryness In The Mouth Inspite Of Salivation"),
    CheckBoxSettings(title: "Gassiness"),
    CheckBoxSettings(title: "Gurgling Noise In Your Tummy"),
    CheckBoxSettings(title: "Hypersalivation While Feeling Nauseous"),
    CheckBoxSettings(
        title: "Cannot Start My Day Without A Hot Beverage Once I'm Up"),
    CheckBoxSettings(title: "None Of The Above"),
    CheckBoxSettings(title: "None"),
  ];
  List selectedHealthCheckBox2 = [];

  //********** not used*************

  final urinFrequencyList = [
    CheckBoxSettings(title: "Increased"),
    CheckBoxSettings(title: "Decreased"),
    CheckBoxSettings(title: "No Change"),
  ];
  List selectedUrinFrequencyList = [];
  //*********************************

  //********** not used*************

  final urinColorList = [
    CheckBoxSettings(title: "Clear"),
    CheckBoxSettings(title: "Pale Yellow"),
    CheckBoxSettings(title: "Red"),
    CheckBoxSettings(title: "Black"),
    CheckBoxSettings(title: "Yellow"),
  ];
  List selectedUrinColorList = [];
  bool urinColorOtherSelected = false;
  // *******************************

  final urinSmellList = [
    CheckBoxSettings(title: "Normal urine odour"),
    CheckBoxSettings(title: "Fruity"),
    CheckBoxSettings(title: "Ammonia"),
  ];
  List selectedUrinSmellList = [];
  bool urinSmellOtherSelected = false;

  //********** not used*************

  final urinLooksList = [
    CheckBoxSettings(title: "Clear/Transparent"),
    CheckBoxSettings(title: "Foggy/cloudy"),
  ];

  List selectedUrinLooksList = [];
  bool urinLooksLikeOtherSelected = false;
  //***********************************

  final medicalInterventionsDoneBeforeList = [
    CheckBoxSettings(title: "Surgery"),
    CheckBoxSettings(title: "Stents"),
    CheckBoxSettings(title: "Implants"),
    CheckBoxSettings(title: "None"),
  ];
  bool medicalInterventionsOtherSelected = false;
  List selectedmedicalInterventionsDoneBeforeList = [];

  String selectedStoolMatch = '';

  List<PlatformFile> medicalRecords = [];

  /// this is used when showdata is true
  List showMedicalReport = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProfileData();
    });
    pinCodeController.addListener(() {
      setState(() {});
    });
    if (widget.showData) {
      _getEvaluationDataFuture = EvaluationFormService(repository: repository)
          .getEvaluationDataService();
    }
    scrollController = ScrollController();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (mounted) {
      pinCodeController.removeListener(() {});
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.showData
          ? BoxDecoration(color: gWhiteColor)
          : const BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage("assets/images/eval_bg.png"),
                  fit: BoxFit.fitWidth,
                  colorFilter:
                      ColorFilter.mode(kPrimaryColor, BlendMode.lighten)),
            ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TicketChatScreen(
                    userName: "${_pref?.getString(AppConfig.User_Name)}",
                    thumbNail:
                    "${_pref?.getString(AppConfig.User_Profile)}",
                    ticketId:
                    "${_pref?.getString(AppConfig.User_ticket_id)}",
                    subject: '',
                    email: "${_pref?.getString(AppConfig.User_Email)}",
                    ticketStatus: 1 ?? -1,
                  ),
                ),
              );
            },
            backgroundColor: gsecondaryColor.withOpacity(0.7),
            child: const ImageIcon(
              AssetImage("assets/images/noun-chat-5153452.png"),
            ),
          ),
          body: widget.showData
              ? FutureBuilder(
                  future: _getEvaluationDataFuture,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      print(snapshot.data.runtimeType);
                      if (snapshot.data.runtimeType == GetEvaluationDataModel) {
                        GetEvaluationDataModel model =
                            snapshot.data as GetEvaluationDataModel;
                        ChildGetEvaluationDataModel? model1 = model.data;
                        storeDetails(model1!);
                        return showUI(context, model: model1);
                      } else {
                        ErrorModel model = snapshot.data as ErrorModel;
                        print(model.message);
                      }
                    } else if (snapshot.hasError) {
                      print("snapshot.error: ${snapshot.error}");
                    }
                    return buildCircularIndicator();
                  })
              : showUI(context),
        ),
      ),
    );
  }

  /// for showData ChildGetEvaluationDataModel? model this is mandatory
  showUI(BuildContext context, {ChildGetEvaluationDataModel? model}) {
    return widget.showData
        ? buildEvaluationForm()
        : GestureDetector(
            onPanDown: (_) {
              hideKeyboard();
            },
            child: Column(
              children: [
                SizedBox(height: 1.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildAppBar(() {
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Expanded(
                  child: Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.grey.withOpacity(0.5))
                        ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: buildEvaluationForm()),
                ),
              ],
            ),
          );
  }

  ScrollController? scrollController;

  hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  buildEvaluationForm({ChildGetEvaluationDataModel? model}) {
    return SingleChildScrollView(
      controller: scrollController!,
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: (widget.padding != null) ? widget.padding : EdgeInsets.zero,
        child: Column(
          children: [
            buildPersonalDetails(),
            buildHealthDetails(),
            // buildFoodHabitsDetails(),
            // buildSleepDetails(),
            // buildLifeStyleDetails(),
            // buildGutTypeDetails(),
            IntrinsicWidth(
              child: GestureDetector(
                onTap: widget.showData
                    ? () {
                        EvaluationModelFormat1 eval1 = createFormMap();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => PersonalDetailsScreen2(
                              evaluationModelFormat1: eval1,
                              showData: true,
                            ),
                          ),
                        );
                      }
                    : () {
                        checkFields(context);
                      },
                child: Container(
                  // width: 40.w,
                  // height: 5.h,
                  padding:
                      EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: eUser().buttonColor,
                    borderRadius:
                        BorderRadius.circular(eUser().buttonBorderRadius),
                    // border: Border.all(
                    //     color: eUser().buttonBorderColor,
                    //     width: eUser().buttonBorderWidth
                    // ),
                  ),
                  child: widget.showData ? Center(
                    child: Text(
                       "Next" ,
                      style: TextStyle(
                        fontFamily: eUser().buttonTextFont,
                        color: eUser().buttonTextColor,
                        fontSize: eUser().buttonTextSize,
                      ),
                    ),) : isSubmitPressed
                      ? buildThreeBounceIndicator(color: gWhiteColor)
                      : Center(
                          child: Text(
                           'Submit',
                          style: TextStyle(
                            fontFamily: eUser().buttonTextFont,
                            color: eUser().buttonTextColor,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildPersonalDetails() {
    return Form(
      key: formKey1,
      child: IgnorePointer(
        ignoring: widget.showData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Personal Details",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: kFontBold,
                          color: gBlackColor,
                          fontSize: headingFont),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: kLineColor,
                      ),
                    ),
                  ],
                ),
                // Text(
                //   "Let Us Know You Better",
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //       fontFamily: kFontMedium,
                //       color: gHintTextColor,
                //       fontSize: subHeadingFont
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            buildLabelTextField("First Name:",
                fontSize: questionFont, key: fnameKey),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: fnameController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  AppConfig().showSnackbar(
                      context, "Please enter your First Name",
                      isError: true, bottomPadding: 100);
                  return 'Please enter your First Name';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", fnameController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Last Name:",
                fontSize: questionFont, key: lNameKey),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: lnameController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  return 'Please enter your Last Name';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", lnameController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Marital Status:',
                fontSize: questionFont, key: maritalKey),
            // Text(
            //   'Marital Status:*',
            //   style: TextStyle(
            //     fontSize: 9.dp,
            //     color: kTextColor,
            //     fontFamily: "PoppinsSemiBold",
            //   ),
            // ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() => maritalStatus = "Single");
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                        value: "Single",
                        activeColor: kPrimaryColor,
                        groupValue: maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            maritalStatus = value as String;
                          });
                        },
                      ),
                      Text(
                        'Single',
                        style: buildTextStyle(
                            color: maritalStatus == "Single"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: maritalStatus == "Single"
                                ? kFontMedium
                                : kFontBook,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => maritalStatus = "Married");
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                        value: "Married",
                        activeColor: kPrimaryColor,
                        groupValue: maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            maritalStatus = value as String;
                          });
                        },
                      ),
                      Text(
                        'Married',
                        style: buildTextStyle(
                            color: maritalStatus == "Married"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: maritalStatus == "Married"
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => maritalStatus = "Separated");
                  },
                  child: Row(
                    children: [
                      Radio(
                          value: "Separated",
                          groupValue: maritalStatus,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            setState(() {
                              maritalStatus = value as String;
                            });
                          }),
                      Text(
                        "Separated",
                        style: buildTextStyle(
                            color: maritalStatus == "Separated"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: maritalStatus == "Separated"
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Phone Number',
                fontSize: questionFont, key: phoneKey),
            // Text(
            //   'Phone Number*',
            //   style: TextStyle(
            //     fontSize: 9.dp,
            //     color: kTextColor,
            //     fontFamily: "PoppinsSemiBold",
            //   ),
            // ),
            IgnorePointer(
              child: TextFormField(
                readOnly: true,
                controller: mobileController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Phone Number';
                  } else if (!isPhone(value)) {
                    return 'Please enter valid Mobile Number';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", mobileController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Email ID -',
                fontSize: questionFont, key: emailKey),
            IgnorePointer(
              child: TextFormField(
                readOnly: true,
                controller: emailController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please enter your Email ID';
                  } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please enter your valid Email ID';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", emailController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Age', fontSize: questionFont, key: ageKey),
            IgnorePointer(
              child: TextFormField(
                readOnly: true,
                controller: ageController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Age';
                  } else if (int.parse(value) < 10) {
                    return 'Age should be Greater than 10';
                  } else if (int.parse(value) >= 100) {
                    return 'Age should be Lesser than 100';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", ageController),
                textInputAction: TextInputAction.next,
                maxLength: 2,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                ],
                textAlign: TextAlign.start,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Gender:',
                fontSize: questionFont, key: genderKey),
            IgnorePointer(
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() => gender = "Male");
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: "Male",
                            activeColor: kPrimaryColor,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value as String;
                              });
                            },
                          ),
                          Text(
                            'Male',
                            style: buildTextStyle(
                                color: gender == "Male"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily:
                                    gender == "Male" ? kFontMedium : kFontBook),
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 3.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => gender = "Female");
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: "Female",
                          activeColor: kPrimaryColor,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value as String;
                            });
                          },
                        ),
                        Text(
                          'Female',
                          style: buildTextStyle(
                              color: gender == "Female"
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily:
                                  gender == "Female" ? kFontMedium : kFontBook),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => gender = "Other");
                    },
                    child: Row(
                      children: [
                        Radio(
                            value: "Other",
                            groupValue: gender,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                gender = value as String;
                              });
                            }),
                        Text(
                          "Other",
                          style: buildTextStyle(
                              color: gender == "Other"
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily:
                                  gender == "Other" ? kFontMedium : kFontBook),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Flat/House Number',
                fontSize: questionFont, key: flatKey),
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
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                'Full Postal Address To Deliver Your Ready To Cook Kit',
                fontSize: questionFont,
                key: addresskey),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: address2Controller,
              cursorColor: kPrimaryColor,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Address';
                } else if (value.length < 10) {
                  // AppConfig().showSnackbar(context, 'Address length should be greater than 10', isError: true,bottomPadding: 100);
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
            buildLabelTextField('Pin Code',
                fontSize: questionFont, key: pincodeKey),
            FocusScope(
              onFocusChange: (value) {
                print(value);
                if (cityController.text.isEmpty) {
                  if (!value) {
                    print("editing");
                    String code = _pref?.getString(AppConfig.countryCode) ?? '';
                    if (pinCodeController.text.length < 6) {
                      AppConfig().showSnackbar(
                          context, 'Pincode should be 6 digits',
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
                        _pref?.getString(AppConfig.countryCode) ?? 'IN';
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
                            String code =
                                _pref?.getString(AppConfig.countryCode) ?? '';
                            print('code: $code');
                            // if (code.isNotEmpty && code == 'IN') {
                            //   fetchCountry(pinCodeController.text, code);
                            // }
                            fetchCountry(pinCodeController.text, 'IN');

                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: gMainColor,
                            size: 22,
                          ),
                        ),
                ),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                ],
                textAlign: TextAlign.start,
                keyboardType: TextInputType.numberWithOptions(),
                maxLength: 6,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('City', fontSize: questionFont, key: cityKey),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: cityController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
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
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('State', fontSize: questionFont, key: stateKey),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: stateController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
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
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Country',
                fontSize: questionFont, key: countryKey),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: countryController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
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
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

  buildHealthDetails() {
    return Form(
      key: formKey2,
      child: IgnorePointer(
        ignoring: widget.showData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Health",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: kFontBold,
                          color: gBlackColor,
                          fontSize: headingFont),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: kLineColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            buildLabelTextField('Weight In Kgs',
                fontSize: questionFont, key: weightKey),
            TextFormField(
              controller: weightController,
              cursorColor: kPrimaryColor,
              maxLength: 3,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Weight';
                } else if (value != null) {
                  if (int.parse(value) < 20 || int.parse(value) > 120) {
                    return 'Please enter Valid Weight';
                  }
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", weightController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Height In Feet & Inches',
                fontSize: questionFont, key: heightKey),
            showDropdown(),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                'Brief Paragraph About Your Current Complaints & What You Are Looking To Heal Here',
                fontSize: questionFont,
                key: afterHeightKey),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: healController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Heal';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", healController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Please check all that apply to you.',
                fontSize: questionFont, key: health1Key),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                ...healthCheckBox1
                    .map((e) => buildHealthCheckBox(e, 'health1'))
                    .toList(),
                Visibility(
                  visible: selectedHealthCheckBox1
                      .any((element) => element.contains("Other:")),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: checkbox1OtherController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty &&
                          selectedHealthCheckBox1
                              .any((element) => element.contains("Other:"))) {
                        Scrollable.ensureVisible(_healthkey1.currentContext!,
                            duration: const Duration(milliseconds: 1000));
                        AppConfig().showSnackbar(context,
                            "Please Mention Other Details with minimum 2 characters",
                            bottomPadding: 100, isError: true);

                        return 'Please Mention Other Details with minimum 2 characters';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Your answer", checkbox1OtherController),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            SizedBox(
              key: _healthkey1,
              height: 2.h,
            ),
            // health checkbox2
            buildLabelTextField(
                'Please check all of the boxes that apply to you.',
                fontSize: questionFont,
                key: health2Key),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                ...healthCheckBox2
                    .map((e) => buildHealthCheckBox(e, 'health2'))
                    .toList(),
                SizedBox(
                  height: 1.h,
                ),
                buildLabelTextField('Tongue Coating', key: tongueKey),
                SizedBox(
                  height: 1.h,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() => tongueCoatingRadio = "clear");
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "clear",
                              groupValue: tongueCoatingRadio,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  tongueCoatingRadio = value as String;
                                });
                              }),
                          Text(
                            "Clear",
                            style: buildTextStyle(
                                color: tongueCoatingRadio == "clear"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: tongueCoatingRadio == "clear"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() =>
                            tongueCoatingRadio = "Coated with white layer");
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "Coated with white layer",
                              groupValue: tongueCoatingRadio,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  tongueCoatingRadio = value as String;
                                });
                              }),
                          Text(
                            "Coated with white layer",
                            style: buildTextStyle(
                                color: tongueCoatingRadio ==
                                        "Coated with white layer"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: tongueCoatingRadio ==
                                        "Coated with white layer"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() =>
                            tongueCoatingRadio = "Coated with yellow layer");
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                              value: "Coated with yellow layer",
                              groupValue: tongueCoatingRadio,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  tongueCoatingRadio = value as String;
                                });
                              }),
                          Text(
                            "Coated with yellow layer",
                            style: buildTextStyle(
                                color: tongueCoatingRadio ==
                                        "Coated with yellow layer"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: tongueCoatingRadio ==
                                        "Coated with yellow layer"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() =>
                            tongueCoatingRadio = "Coated with black layer");
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                              value: "Coated with black layer",
                              groupValue: tongueCoatingRadio,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  tongueCoatingRadio = value as String;
                                });
                              }),
                          Text(
                            "Coated with black layer",
                            style: buildTextStyle(
                                color: tongueCoatingRadio ==
                                        "Coated with black layer"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: tongueCoatingRadio ==
                                        "Coated with black layer"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => tongueCoatingRadio = "other");
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                              value: "other",
                              groupValue: tongueCoatingRadio,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  tongueCoatingRadio = value as String;
                                });
                              }),
                          Text(
                            "Other:",
                            style: buildTextStyle(
                                color: tongueCoatingRadio == "other"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: tongueCoatingRadio == "other"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: tongueCoatingRadio == "other",
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: tongueCoatingController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty &&
                          tongueCoatingRadio.toLowerCase().contains("other")) {
                        AppConfig().showSnackbar(
                            context, "Please enter the tongue coating details",
                            isError: true, bottomPadding: 100);
                        return 'Please enter the tongue coating details';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Your answer", tongueCoatingController),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "Has Frequency Of Urination Increased Or Decreased In The Recent Past?",
                fontSize: questionFont,
                key: urinIncreasedKey),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      urinationValue = "Increased";
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                        value: "Increased",
                        activeColor: kPrimaryColor,
                        groupValue: urinationValue,
                        onChanged: (value) {
                          setState(() {
                            urinationValue = value as String;
                          });
                        },
                      ),
                      Text('Increased',
                          style: buildTextStyle(
                              color: urinationValue == "Increased"
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily: urinationValue == "Increased"
                                  ? kFontMedium
                                  : kFontBook)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      urinationValue = "Decreased";
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                        value: "Decreased",
                        activeColor: kPrimaryColor,
                        groupValue: urinationValue,
                        onChanged: (value) {
                          setState(() {
                            urinationValue = value as String;
                          });
                        },
                      ),
                      Text(
                        'Decreased',
                        style: buildTextStyle(
                            color: urinationValue == "Decreased"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: urinationValue == "Decreased"
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      urinationValue = "No Change";
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                          value: "No Change",
                          groupValue: urinationValue,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            setState(() {
                              urinationValue = value as String;
                            });
                          }),
                      Text(
                        "No Change",
                        style: buildTextStyle(
                            color: urinationValue == "No Change"
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: urinationValue == "No Change"
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Wrap(
            //   // mainAxisSize: MainAxisSize.min,
            //   children: [
            //     ...urinFrequencyList.map(buildWrapingCheckBox).toList()
            //   ],
            // ),
            buildLabelTextField("Urine Color",
                fontSize: questionFont, key: urineColorKey),
            buildUrineColorRadioButton(),
            // ListView(
            //   shrinkWrap: true,
            //   physics: const BouncingScrollPhysics(),
            //   children: [
            //     Wrap(
            //       children: [
            //         ...urinColorList.map(buildWrapingCheckBox).toList(),
            //       ],
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           SizedBox(
            //             width: 20,
            //             child: Checkbox(
            //               activeColor: kPrimaryColor,
            //               value: urinColorOtherSelected,
            //               onChanged: (v) {
            //                 setState(() {
            //                   urinColorOtherSelected = v!;
            //                   if(urinColorOtherSelected){
            //                     selectedUrinColorList.add(otherText);
            //                   }
            //                   else{
            //                     selectedUrinColorList.remove(otherText);
            //                   }
            //                 });
            //               },
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 4,
            //           ),
            //           Text(
            //             'Other:',
            //             style: buildTextStyle(),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: TextFormField(
            //         controller: urinColorController,
            //         cursorColor: kPrimaryColor,
            //         validator: (value) {
            //           if (value!.isEmpty && urinColorOtherSelected) {
            //             return 'Please enter the details about Urin Color';
            //           } else {
            //             return null;
            //           }
            //         },
            //         decoration: CommonDecoration.buildTextInputDecoration(
            //             "Your answer", urinColorController),
            //         textInputAction: TextInputAction.next,
            //         textAlign: TextAlign.start,
            //         keyboardType: TextInputType.text,
            //       ),
            //     ),
            //   ],
            // ),
            Visibility(
              visible: urineColorValue == "Other",
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: urinColorController,
                  cursorColor: kPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty &&
                        urineColorValue.toLowerCase().contains('other')) {
                      AppConfig().showSnackbar(
                          context, "Please enter the details about Urine Color",
                          isError: true, bottomPadding: 100);
                      return 'Please enter the details about Urine Color';
                    } else {
                      return null;
                    }
                  },
                  decoration: CommonDecoration.buildTextInputDecoration(
                      "Your answer", urinColorController),
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Urine Smell",
                fontSize: questionFont, key: urineSmellkey),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    ...urinSmellList
                        .map((e) => buildHealthCheckBox(e, 'smell'))
                        .toList(),
                  ],
                ),
                SizedBox(
                  child: CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Text(
                        'Other:',
                        style: buildTextStyle(
                            color: urinSmellOtherSelected
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: urinSmellOtherSelected
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ),
                    activeColor: kPrimaryColor,
                    value: urinSmellOtherSelected,
                    onChanged: (v) {
                      setState(() {
                        urinSmellOtherSelected = v!;
                        if (urinSmellOtherSelected) {
                          // selectedUrinSmellList.clear();
                          // urinSmellList.forEach((element) {
                          //   element.value = false;
                          // });
                          selectedUrinSmellList.add(otherText);
                        } else {
                          selectedUrinSmellList.remove(otherText);
                        }
                        print(selectedUrinSmellList);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: urinSmellOtherSelected,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: urinSmellController,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value!.isEmpty && urinSmellOtherSelected) {
                          AppConfig().showSnackbar(context,
                              "Please select the details about urine smell",
                              bottomPadding: 100, isError: true);
                          return 'Please select the details about urine smell';
                        } else {
                          return null;
                        }
                      },
                      decoration: CommonDecoration.buildTextInputDecoration(
                          "Your answer", urinSmellController),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("What Does Your Urine Look Like?",
                fontSize: questionFont, key: urineLooksKey),
            buildUrineLookRadioButton(),
            // ListView(
            //   shrinkWrap: true,
            //   physics: const BouncingScrollPhysics(),
            //   children: [
            //     Wrap(
            //       children: [
            //         ...urinLooksList.map(buildHealthCheckBox).toList(),
            //       ],
            //     ),
            //     ListTile(
            //       minLeadingWidth: 0,
            //       leading: SizedBox(
            //         width: 20,
            //         child: Checkbox(
            //           activeColor: kPrimaryColor,
            //           value: urinLooksLikeOtherSelected,
            //           onChanged: (v) {
            //             setState(() {
            //               urinLooksLikeOtherSelected = v!;
            //               if(urinLooksLikeOtherSelected){
            //                 selectedUrinLooksList.add(otherText);
            //               }
            //               else{
            //                 selectedUrinLooksList.remove(otherText);
            //               }
            //             });
            //           },
            //         ),
            //       ),
            //       title: Text(
            //         'Other:',
            //         style: buildTextStyle(),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: TextFormField(
            //         controller: urinLooksLikeController,
            //         cursorColor: kPrimaryColor,
            //         validator: (value) {
            //           if (value!.isEmpty && urinLooksLikeOtherSelected) {
            //             return 'Please enter how Urin Looks';
            //           } else {
            //             return null;
            //           }
            //         },
            //         decoration: CommonDecoration.buildTextInputDecoration(
            //             "Your answer", urinLooksLikeController),
            //         textInputAction: TextInputAction.next,
            //         textAlign: TextAlign.start,
            //         keyboardType: TextInputType.text,
            //       ),
            //     ),
            //   ],
            // ),
            Visibility(
              visible: urineLookLikeValue == "Other",
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: urinLooksLikeController,
                  cursorColor: kPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty &&
                        urineLookLikeValue.toLowerCase().contains('other')) {
                      AppConfig().showSnackbar(
                          context, "Please enter how Urine Looks",
                          isError: true, bottomPadding: 100);
                      return 'Please enter how Urine Looks';
                    } else {
                      return null;
                    }
                  },
                  decoration: CommonDecoration.buildTextInputDecoration(
                      "Your answer", urinLooksLikeController),
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Which one is the closest match to your stool?",
                fontSize: questionFont, key: stoolTypeKey),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    height: 35.h,
                    child: const Image(
                      image: AssetImage("assets/images/stool_image.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStoolMatch = "Seperate hard lumps";
                        });
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "Seperate hard lumps",
                              groupValue: selectedStoolMatch,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedStoolMatch = value as String;
                                });
                              }),
                          Text(
                            "Seperate hard lumps",
                            style: buildTextStyle(
                                color:
                                    selectedStoolMatch == "Seperate hard lumps"
                                        ? kTextColor
                                        : gHintTextColor,
                                fontFamily:
                                    selectedStoolMatch == "Seperate hard lumps"
                                        ? kFontMedium
                                        : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStoolMatch = "Lumpy & sausage like";
                        });
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "Lumpy & sausage like",
                              groupValue: selectedStoolMatch,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedStoolMatch = value as String;
                                });
                              }),
                          Text(
                            "Lumpy & sausage like",
                            style: buildTextStyle(
                                color:
                                    selectedStoolMatch == "Lumpy & sausage like"
                                        ? kTextColor
                                        : gHintTextColor,
                                fontFamily:
                                    selectedStoolMatch == "Lumpy & sausage like"
                                        ? kFontMedium
                                        : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStoolMatch =
                              "Sausage shape with cracks on the surface";
                        });
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "Sausage shape with cracks on the surface",
                              groupValue: selectedStoolMatch,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedStoolMatch = value as String;
                                });
                              }),
                          Text(
                            "Sausage shape with cracks on the surface",
                            style: buildTextStyle(
                                color: selectedStoolMatch ==
                                        "Sausage shape with cracks on the surface"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: selectedStoolMatch ==
                                        "Sausage shape with cracks on the surface"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStoolMatch = "Smooth, soft sausage or snake";
                        });
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "Smooth, soft sausage or snake",
                              groupValue: selectedStoolMatch,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedStoolMatch = value as String;
                                });
                              }),
                          Text(
                            "Smooth, soft sausage or snake",
                            style: buildTextStyle(
                                color: selectedStoolMatch ==
                                        "Smooth, soft sausage or snake"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: selectedStoolMatch ==
                                        "Smooth, soft sausage or snake"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStoolMatch =
                              "Soft blobs with clear cut edges";
                        });
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "Soft blobs with clear cut edges",
                              groupValue: selectedStoolMatch,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedStoolMatch = value as String;
                                });
                              }),
                          Text(
                            "Soft blobs with clear cut edges",
                            style: buildTextStyle(
                                color: selectedStoolMatch ==
                                        "Soft blobs with clear cut edges"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: selectedStoolMatch ==
                                        "Soft blobs with clear cut edges"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStoolMatch =
                              "Mostly consistency with ragged edges";
                        });
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "Mostly consistency with ragged edges",
                              groupValue: selectedStoolMatch,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedStoolMatch = value as String;
                                });
                              }),
                          Text(
                            "Mostly consistency with ragged edges",
                            style: buildTextStyle(
                                color: selectedStoolMatch ==
                                        "Mostly consistency with ragged edges"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: selectedStoolMatch ==
                                        "Mostly consistency with ragged edges"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStoolMatch =
                              "Liquid consistency with no solid pieces";
                        });
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: "Liquid consistency with no solid pieces",
                              groupValue: selectedStoolMatch,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedStoolMatch = value as String;
                                });
                              }),
                          Text(
                            "liquid consistency with no solid pieces",
                            style: buildTextStyle(
                                color: selectedStoolMatch ==
                                        "liquid consistency with no solid pieces"
                                    ? kTextColor
                                    : gHintTextColor,
                                fontFamily: selectedStoolMatch ==
                                        "liquid consistency with no solid pieces"
                                    ? kFontMedium
                                    : kFontBook),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Medical Interventions Done Before",
                fontSize: questionFont, key: medicalIntervenKey),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    ...medicalInterventionsDoneBeforeList
                        .map((e) => buildHealthCheckBox(e, 'interventions'))
                        .toList(),
                  ],
                ),
                SizedBox(
                  child: CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Text(
                        'Other:',
                        style: buildTextStyle(
                            color: medicalInterventionsOtherSelected
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: medicalInterventionsOtherSelected
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ),
                    activeColor: kPrimaryColor,
                    value: medicalInterventionsOtherSelected,
                    onChanged: (v) {
                      setState(() {
                        medicalInterventionsOtherSelected = v!;
                        if (medicalInterventionsOtherSelected) {
                          // new code
                          if (medicalInterventionsDoneBeforeList.last.value ==
                              true) {
                            selectedmedicalInterventionsDoneBeforeList.clear();
                            medicalInterventionsDoneBeforeList.last.value =
                                false;
                          }

                          // old code
                          // selectedmedicalInterventionsDoneBeforeList
                          //     .add(otherText);
                          // selectedmedicalInterventionsDoneBeforeList.clear();
                          // medicalInterventionsDoneBeforeList
                          //     .forEach((element) {
                          //   element.value = false;
                          // });
                          selectedmedicalInterventionsDoneBeforeList
                              .add(otherText);
                        } else {
                          selectedmedicalInterventionsDoneBeforeList
                              .remove(otherText);
                        }

                        print("Medical Interventions : $selectedmedicalInterventionsDoneBeforeList");
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: medicalInterventionsOtherSelected,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: medicalInterventionsDoneController,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value!.isEmpty &&
                            medicalInterventionsOtherSelected) {
                          return 'Please enter Medical Interventions';
                        } else {
                          return null;
                        }
                      },
                      decoration: CommonDecoration.buildTextInputDecoration(
                          "Your answer", medicalInterventionsDoneController),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                'Any Medications/Supplements/Inhalers/Contraceptives You Consume At The Moment',
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: medicationsController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please mention Any Medications Taken before';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", medicationsController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                'Holistic/Alternative Therapies You Have Been Through & When (Ayurveda, Homeopathy) ',
                fontSize: questionFont),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: holisticController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please mention the Therapy taken';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", holisticController),
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            // SizedBox(
            //   height: 2.h,
            // ),
            // buildLabelTextField(
            //     "Please Upload Any & All Medical Records That Might Be Helpful To Evaluate Your Condition Better"),
            // SizedBox(
            //   height: 1.h,
            // ),
            // GestureDetector(
            //   onTap: () async {
            //     final result = await FilePicker.platform
            //         .pickFiles(withReadStream: true, allowMultiple: false);
            //
            //     if (result == null) return;
            //     if (result.files.first.extension!.contains("pdf") ||
            //         result.files.first.extension!.contains("png") ||
            //         result.files.first.extension!.contains("jpg")) {
            //       medicalRecords.add(result.files.first);
            //     } else {
            //       AppConfig().showSnackbar(
            //           context, "Please select png/jpg/Pdf files",
            //           isError: true);
            //     }
            //     setState(() {});
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(8),
            //       border: Border.all(color: gMainColor, width: 1),
            //     ),
            //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         const Icon(
            //           Icons.file_upload_outlined,
            //           color: gMainColor,
            //         ),
            //         const SizedBox(
            //           width: 4,
            //         ),
            //         Text(
            //           'Add File',
            //           style: TextStyle(
            //             fontSize: 10.dp,
            //             color: gMainColor,
            //             fontFamily: "PoppinsRegular",
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // (medicalRecords.isEmpty)
            //         ? Container()
            //         : SizedBox(
            //             width: double.maxFinite,
            //             child: ListView.builder(
            //               itemCount: medicalRecords.length,
            //               shrinkWrap: true,
            //               itemBuilder: (context, index) {
            //                 final file = medicalRecords[index];
            //                 return buildFile(file, index);
            //               },
            //             ),
            //           ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFile(PlatformFile file, int index) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return buildRecordList(file.name, index: index);

    // return Wrap(
    //   children: [
    //     RawChip(
    //         label: Text(file.name),
    //       deleteIcon: Icon(
    //         Icons.cancel,
    //       ),
    //       deleteIconColor: gMainColor,
    //       onDeleted: (){
    //         medicalRecords.removeAt(index);
    //         setState(() {});
    //       },
    //     )
    //   ],
    // );
  }

  checkFields(BuildContext context) {
    print("****");
    print(urineColorValue.toLowerCase().contains("other"));
    print(urineColorValue.toLowerCase().contains("other") &&
        urinColorController.text.isEmpty);
    print(formKey1.currentState!.validate());

    if (formKey1.currentState!.validate() &&
        formKey2.currentState!.validate()) {
      print("if");
      if (maritalStatus == "") {
        Scrollable.ensureVisible(maritalKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Marital Status",
            isError: true, bottomPadding: 100);
      } else if (address1Controller.text.isEmpty) {
        Scrollable.ensureVisible(flatKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Flat Details",
            isError: true, bottomPadding: 100);
      } else if (address2Controller.text.isEmpty ||
          address2Controller.text.length < 10) {
        Scrollable.ensureVisible(addresskey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Postal Address",
            isError: true, bottomPadding: 100);
      } else if (pinCodeController.text.isEmpty) {
        Scrollable.ensureVisible(pincodeKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Pincode",
            isError: true, bottomPadding: 100);
      } else if (int.parse(weightController.text) < 20 ||
          int.parse(weightController.text) > 120) {
        Scrollable.ensureVisible(weightKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please enter Valid Weight",
            isError: true, bottomPadding: 100);
      } else if (ft == -1 || inches == -1) {
        Scrollable.ensureVisible(heightKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Height",
            isError: true, bottomPadding: 100);
      } else if (healController.text.isEmpty) {
        Scrollable.ensureVisible(afterHeightKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention your heal complaints",
            isError: true, bottomPadding: 100);
      } else if (healthCheckBox1.every((element) => element.value == false)) {
        Scrollable.ensureVisible(health1Key.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 option from HealthList1",
            isError: true, bottomPadding: 100);
      } else if (healthCheckBox2.every((element) => element.value == false)) {
        Scrollable.ensureVisible(health2Key.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 option from HealthList2",
            isError: true, bottomPadding: 100);
      } else if (tongueCoatingRadio.isEmpty) {
        Scrollable.ensureVisible(tongueKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Tongue Coating Details",
            isError: true, bottomPadding: 100);
      } else if (tongueCoatingRadio.toLowerCase().contains("other") &&
          tongueCoatingController.text.isEmpty) {
        Scrollable.ensureVisible(tongueKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else if (urinationValue.isEmpty) {
        // else if(urinFrequencyList.every((element) => element.value == false)){
        Scrollable.ensureVisible(urinIncreasedKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Frequency of Urination",
            isError: true, bottomPadding: 100);
      } else if (urineColorValue.isEmpty) {
        // else if(urinColorList.every((element) => element.value == false) && !urinColorOtherSelected){
        Scrollable.ensureVisible(urineColorKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Urine Color",
            isError: true, bottomPadding: 100);
      } else if (urineColorValue.toLowerCase().contains("other") &&
          urinColorController.text.isEmpty) {
        Scrollable.ensureVisible(urineColorKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else if (urinSmellList.every((element) => element.value == false) &&
          !urinSmellOtherSelected) {
        Scrollable.ensureVisible(urineSmellkey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Atleast 1 Urine Smell",
            isError: true, bottomPadding: 100);
      } else if (urinSmellList.any((element) => element.title == "Other") &&
          urinSmellController.text.isEmpty) {
        Scrollable.ensureVisible(urineSmellkey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else if (urineLookLikeValue.isEmpty) {
        Scrollable.ensureVisible(urineLooksKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        // else if(urinLooksList.every((element) => element.value == false) && !urinLooksLikeOtherSelected){
        AppConfig().showSnackbar(context, "Please Select Urine Looks List",
            isError: true, bottomPadding: 100);
      } else if (urineLookLikeValue.toLowerCase().contains("other") &&
          urinLooksLikeController.text.isEmpty) {
        Scrollable.ensureVisible(urineLooksKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else if (selectedStoolMatch.isEmpty) {
        Scrollable.ensureVisible(stoolTypeKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Closest match to your stool",
            isError: true, bottomPadding: 100);
      } else if (medicalInterventionsDoneBeforeList
              .every((element) => element.value == false) &&
          medicalInterventionsOtherSelected == false) {
        Scrollable.ensureVisible(medicalIntervenKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 Medication Intervention",
            isError: true, bottomPadding: 100);
      } else if (medicalInterventionsOtherSelected == true &&
          medicalInterventionsDoneController.text.isEmpty) {
        Scrollable.ensureVisible(medicalIntervenKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else {
        if (ft != -1 && inches != -1) {
          heightText = '$ft.$inches';
          print(heightText);
        }
        formKey1.currentState!.save();
        formKey2.currentState!.save();

        addSelectedValuesToList();
        EvaluationModelFormat1 eval1 = createFormMap();

        // storeToLocal
        _pref!.setString(AppConfig.eval1, jsonEncode(eval1.toMap()));

        final json = jsonDecode(_pref!.getString(AppConfig.eval1)!);
        // var _map = EvaluationModelFormat1.fromMap(json);

        print("local map: $json");

        // print((eval1 as EvaluationModelFormat1).toMap());
        print(urineColorValue);
        Map finalMap = {};
        finalMap.addAll(eval1.toMap().cast());

        callApi(finalMap, null);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         // builder: (ctx) => EvaluationUploadReport(
        //         //     evaluationModelFormat1: eval1,
        //         // )
        //         builder: (ctx) => PersonalDetailsScreen2(
        //               evaluationModelFormat1: eval1,
        //               // medicalReportList:
        //               //     medicalRecords.map((e) => e.path).toList()
        //             )));
      }
    } else {
      print("else");
      if (maritalStatus == "") {
        Scrollable.ensureVisible(maritalKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Marital Status",
            isError: true, bottomPadding: 100);
      } else if (address1Controller.text.isEmpty) {
        Scrollable.ensureVisible(flatKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Flat Details",
            isError: true, bottomPadding: 100);
      } else if (address2Controller.text.isEmpty ||
          address2Controller.text.length < 10) {
        Scrollable.ensureVisible(addresskey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Postal Address",
            isError: true, bottomPadding: 100);
      } else if (pinCodeController.text.isEmpty) {
        Scrollable.ensureVisible(pincodeKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Pincode",
            isError: true, bottomPadding: 100);
      } else if (int.parse(weightController.text) < 20 ||
          int.parse(weightController.text) > 120) {
        Scrollable.ensureVisible(weightKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please enter Valid Weight",
            isError: true, bottomPadding: 100);
      } else if (ft == -1 || inches == -1) {
        Scrollable.ensureVisible(heightKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Height",
            isError: true, bottomPadding: 100);
      } else if (healController.text.isEmpty) {
        Scrollable.ensureVisible(afterHeightKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention your heal complaints",
            isError: true, bottomPadding: 100);
      } else if (healthCheckBox1.every((element) => element.value == false)) {
        Scrollable.ensureVisible(health1Key.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 option from HealthList1",
            isError: true, bottomPadding: 100);
      } else if (healthCheckBox2.every((element) => element.value == false)) {
        Scrollable.ensureVisible(health2Key.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 option from HealthList2",
            isError: true, bottomPadding: 100);
      } else if (tongueCoatingRadio.isEmpty) {
        Scrollable.ensureVisible(tongueKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Tongue Coating Details",
            isError: true, bottomPadding: 100);
      } else if (tongueCoatingRadio.toLowerCase().contains("other") &&
          tongueCoatingController.text.isEmpty) {
        Scrollable.ensureVisible(tongueKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else if (urinationValue.isEmpty) {
        // else if(urinFrequencyList.every((element) => element.value == false)){
        Scrollable.ensureVisible(urinIncreasedKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Frequency of Urination",
            isError: true, bottomPadding: 100);
      } else if (urineColorValue.isEmpty) {
        // else if(urinColorList.every((element) => element.value == false) && !urinColorOtherSelected){
        Scrollable.ensureVisible(urineColorKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Urine Color",
            isError: true, bottomPadding: 100);
      } else if (urineColorValue.toLowerCase().contains("other") &&
          urinColorController.text.isEmpty) {
        Scrollable.ensureVisible(urineColorKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else if (urinSmellList.every((element) => element.value == false) &&
          !urinSmellOtherSelected) {
        Scrollable.ensureVisible(urineSmellkey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Atleast 1 Urine Smell",
            isError: true, bottomPadding: 100);
      } else if (urinSmellList.any((element) => element.title == "Other") &&
          urinSmellController.text.isEmpty) {
        Scrollable.ensureVisible(urineSmellkey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else if (urineLookLikeValue.isEmpty) {
        Scrollable.ensureVisible(urineLooksKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        // else if(urinLooksList.every((element) => element.value == false) && !urinLooksLikeOtherSelected){
        AppConfig().showSnackbar(context, "Please Select Urine Looks List",
            isError: true, bottomPadding: 100);
      } else if (urineLookLikeValue.toLowerCase().contains("other") &&
          urinLooksLikeController.text.isEmpty) {
        Scrollable.ensureVisible(urineLooksKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else if (selectedStoolMatch.isEmpty) {
        Scrollable.ensureVisible(stoolTypeKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Closest match to your stool",
            isError: true, bottomPadding: 100);
      } else if (medicalInterventionsDoneBeforeList
              .every((element) => element.value == false) &&
          medicalInterventionsOtherSelected == false) {
        Scrollable.ensureVisible(medicalIntervenKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 Medication Intervention",
            isError: true, bottomPadding: 100);
      } else if (medicalInterventionsOtherSelected == true &&
          medicalInterventionsDoneController.text.isEmpty) {
        Scrollable.ensureVisible(medicalIntervenKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Details",
            isError: true, bottomPadding: 100);
      } else {
        if (ft != -1 && inches != -1) {
          heightText = '$ft.$inches';
          print(heightText);
        }
        formKey1.currentState!.save();
        formKey2.currentState!.save();

        addSelectedValuesToList();
        EvaluationModelFormat1 eval1 = createFormMap();

        // storeToLocal
        _pref!.setString(AppConfig.eval1, jsonEncode(eval1.toMap()));

        final json = jsonDecode(_pref!.getString(AppConfig.eval1)!);
        // var _map = EvaluationModelFormat1.fromMap(json);

        print("local map: $json");

        // print((eval1 as EvaluationModelFormat1).toMap());
        print(urineColorValue);

        Map finalMap = {};
        finalMap.addAll(eval1.toMap().cast());

        callApi(finalMap, null);
      }
    }
  }

  createFormMap() {
    return EvaluationModelFormat1(
      fname: fnameController.text.capitalize(),
      lname: lnameController.text.capitalize(),
      maritalStatus: maritalStatus,
      phone: mobileController.text,
      email: emailController.text,
      age: ageController.text,
      gender: gender,
      address1: "No. " + address1Controller.text,
      address2: address2Controller.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pincode: pinCodeController.text,
      weight: weightController.text,
      height: heightText,
      looking_to_heal: healController.text,
      checkList1: selectedHealthCheckBox1.join(','),
      checkList1Other: checkbox1OtherController.text,
      checkList2: selectedHealthCheckBox2.join(','),
      tongueCoating: tongueCoatingRadio,
      tongueCoating_other: (tongueCoatingRadio.toLowerCase().contains("other"))
          ? tongueCoatingController.text
          : '',
      urinationIssue: urinationValue,
      urinColor: urineColorValue,
      urinColor_other: urineColorValue.toLowerCase().contains("other")
          ? urinColorController.text
          : '',
      urinSmell: selectedUrinSmellList.join(','),
      urinSmell_other: urinSmellOtherSelected ? urinSmellController.text : '',
      urinLooksLike: urineLookLikeValue,
      urinLooksLike_other: urineLookLikeValue.toLowerCase().contains("other")
          ? urinLooksLikeController.text
          : '',
      stoolDetails: selectedStoolMatch,
      medical_interventions:
          selectedmedicalInterventionsDoneBeforeList.join(','),
      medical_interventions_other: medicalInterventionsOtherSelected
          ? medicalInterventionsDoneController.text
          : '',
      medication: medicationsController.text,
      holistic: holisticController.text,
      part: "1",
    );
  }

  bool isSubmitPressed = false;

  void callApi(Map form, List<PlatformFile>? medicalReports) async {
    setState(() {
      isSubmitPressed = true;
    });
    final res = await EvaluationFormService(repository: evalRepository)
        .submitEvaluationFormService(form, medicalReports);
    print("eval form response" + res.runtimeType.toString());
    if (res.runtimeType == ReportUploadModel) {
      ReportUploadModel result = res;
      setState(() {
        isSubmitPressed = false;
      });
      _pref!.setString(AppConfig.EVAL_STATUS, "evaluation_done");
      // AppConfig().showSnackbar(context, result.message ?? '');
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (ctx) => EvaluationUploadReport(
          //     evaluationModelFormat1: eval1,
          // )
          builder: (ctx) => PersonalDetailsScreen2(
              // evaluationModelFormat1: eval1,
              // medicalReportList:
              //     medicalRecords.map((e) => e.path).toList()
              ),
        ),
      );
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (context) =>
      //       const DashboardScreen()
      //   ), (route) {
      //     print("route.currentResult:${route.currentResult}");
      //     print(route.isFirst);
      //   return route.isFirst;
      // }
      // );
    } else {
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        isSubmitPressed = false;
      });
    }
  }

  final EvaluationFormRepository evalRepository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  List<String> lst = List.generate(8, (index) => '${index + 1}').toList();
  List<String> lst1 = List.generate(12, (index) => '${index}').toList();

  showDropdown() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: CustomDropdownButton2(
              // buttonHeight: 25,
              // buttonWidth: 45.w,
              hint: 'Feet',
              dropdownItems: lst,
              value: ft == -1 ? null : ft.toString(),
              onChanged: (value) {
                setState(() {
                  ft = int.tryParse(value!) ?? -1;
                });
              },
              buttonDecoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor, width: 1),
              ),
              icon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: CustomDropdownButton2(
              // buttonHeight: 25,
              // buttonWidth: 45.w,

              hint: 'Inches',
              dropdownItems: lst1,
              value: (inches == -1) ? null : inches.toString(),
              onChanged: (value) {
                setState(() {
                  inches = int.tryParse(value!) ?? -1;
                });
              },
              buttonDecoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor, width: 1),
              ),
              icon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
        ],
      ),
    );
  }

  buildHealthCheckBox(CheckBoxSettings healthCheckBox, String from) {
    return IntrinsicWidth(
      child: CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        controlAffinity: ListTileControlAffinity.leading,
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            healthCheckBox.title.toString(),
            style: buildTextStyle(
                color:
                    healthCheckBox.value == true ? kTextColor : gHintTextColor,
                fontFamily:
                    healthCheckBox.value == true ? kFontMedium : kFontBook),
          ),
        ),
        dense: true,
        activeColor: kPrimaryColor,
        value: healthCheckBox.value,
        onChanged: (v) {
          if (from == 'health1') {
            // if (healthCheckBox.title == healthCheckBox1[13].title)
            // {
            //   print("if");
            //   setState(() {
            //     selectedHealthCheckBox1.clear();
            //     healthCheckBox1.forEach((element) {
            //       element.value = false;
            //     });
            //     selectedHealthCheckBox1.add(healthCheckBox.title!);
            //     healthCheckBox.value = v;
            //   });
            // }
            // else
            if (healthCheckBox.title == healthCheckBox1[12].title) {
              print(" else if");
              setState(() {
                selectedHealthCheckBox1.clear();
                healthCheckBox1.forEach((element) {
                  element.value = false;
                });
                selectedHealthCheckBox1.add(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            } else {
              print("else");
              // if (selectedHealthCheckBox1
              //     .contains(healthCheckBox1[13].title)) {
              //   print("if");
              //   setState(() {
              //     selectedHealthCheckBox1.clear();
              //     healthCheckBox1[13].value = false;
              //   });
              // }
              // else
              if (selectedHealthCheckBox1.contains(healthCheckBox1[12].title)) {
                print("else if");

                setState(() {
                  selectedHealthCheckBox1.clear();
                  healthCheckBox1[12].value = false;
                });
              }
              if (v == true) {
                setState(() {
                  selectedHealthCheckBox1.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              } else {
                setState(() {
                  selectedHealthCheckBox1.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedHealthCheckBox1);
          } else if (from == 'health2') {
            if (healthCheckBox.title == healthCheckBox2.last.title) {
              print("if");
              setState(() {
                selectedHealthCheckBox2.clear();
                healthCheckBox2.forEach((element) {
                  if (element != healthCheckBox2.last.title) {
                    element.value = false;
                  }
                });
                if (v == true) {
                  selectedHealthCheckBox2.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                } else {
                  selectedHealthCheckBox2.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                }
              });
            } else {
              // print("else");
              if (v == true) {
                // print("if");
                setState(() {
                  if (selectedHealthCheckBox2
                      .contains(healthCheckBox2.last.title)) {
                    // print("if");
                    selectedHealthCheckBox2.removeWhere(
                        (element) => element == healthCheckBox2.last.title);
                    healthCheckBox2.forEach((element) {
                      if (element.title == healthCheckBox2.last.title) {
                        element.value = false;
                      }
                    });
                  }
                  selectedHealthCheckBox2.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              } else {
                setState(() {
                  selectedHealthCheckBox2.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedHealthCheckBox2);
          } else if (from == 'smell') {
            // if (urinSmellOtherSelected) {
            //   if (v == true) {
            //     setState(() {
            //       urinSmellOtherSelected = false;
            //       selectedUrinSmellList.clear();
            //       selectedUrinSmellList.add(healthCheckBox.title);
            //       healthCheckBox.value = v;
            //     });
            //   }
            // }
            // else
            // {
            if (v == true) {
              setState(() {
                selectedUrinSmellList.add(healthCheckBox.title);
                healthCheckBox.value = v;
              });
            } else {
              setState(() {
                selectedUrinSmellList.remove(healthCheckBox.title);
                healthCheckBox.value = v;
              });
            }
            // }
            print(selectedUrinSmellList);
          } else if (from == 'interventions') {
            // if (medicalInterventionsOtherSelected) {
            //   if (v == true) {
            //     setState(() {
            //       medicalInterventionsOtherSelected = false;
            //       selectedmedicalInterventionsDoneBeforeList.clear();
            //       selectedmedicalInterventionsDoneBeforeList
            //           .add(healthCheckBox.title);
            //       healthCheckBox.value = v;
            //     });
            //   }
            // }
            // else
            if (healthCheckBox.title ==
                medicalInterventionsDoneBeforeList.last.title) {
              print("if");
              setState(() {
                selectedmedicalInterventionsDoneBeforeList.clear();
                medicalInterventionsOtherSelected = false;
                medicalInterventionsDoneBeforeList.forEach((element) {
                  if (element.title !=
                      medicalInterventionsDoneBeforeList.last.title) {
                    element.value = false;
                  }
                });
                if (v == true) {
                  selectedmedicalInterventionsDoneBeforeList
                      .add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                } else {
                  selectedmedicalInterventionsDoneBeforeList
                      .remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                }
              });
            } else {
              if (selectedmedicalInterventionsDoneBeforeList
                  .contains(medicalInterventionsDoneBeforeList.last.title)) {
                print("else if");

                setState(() {
                  selectedmedicalInterventionsDoneBeforeList.clear();
                  medicalInterventionsDoneBeforeList.last.value = false;
                });
              }
              if (v == true) {
                setState(() {
                  selectedmedicalInterventionsDoneBeforeList
                      .add(healthCheckBox.title);
                  healthCheckBox.value = v;
                });
              } else {
                setState(() {
                  selectedmedicalInterventionsDoneBeforeList
                      .remove(healthCheckBox.title);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedmedicalInterventionsDoneBeforeList);
          }

          // print("${healthCheckBox.title}=> ${healthCheckBox.value}");
        },
      ),
    );
    // return ListTile(
    //   onTap: (){
    //     print(healthCheckBox.value);
    //     print(healthCheckBox.title);
    //
    //   },
    //   minLeadingWidth: 30,
    //   horizontalTitleGap: 3,
    //   dense: true,
    //   leading: SizedBox(
    //     width: 20,
    //     child: Checkbox(
    //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //       activeColor: kPrimaryColor,
    //       value: healthCheckBox.value,
    //       onChanged: (v) {
    //         if (from == 'health1') {
    //           if (healthCheckBox.title == healthCheckBox1[13].title)
    //           {
    //             print("if");
    //             setState(() {
    //               selectedHealthCheckBox1.clear();
    //               healthCheckBox1.forEach((element) {
    //                 element.value = false;
    //               });
    //               selectedHealthCheckBox1.add(healthCheckBox.title!);
    //               healthCheckBox.value = v;
    //             });
    //           } else if (healthCheckBox.title == healthCheckBox1[12].title) {
    //             print(" else if");
    //             setState(() {
    //               selectedHealthCheckBox1.clear();
    //               healthCheckBox1.forEach((element) {
    //                 element.value = false;
    //               });
    //               selectedHealthCheckBox1.add(healthCheckBox.title!);
    //               healthCheckBox.value = v;
    //             });
    //           } else {
    //             print("else");
    //             if (selectedHealthCheckBox1
    //                 .contains(healthCheckBox1[13].title)) {
    //               print("if");
    //               setState(() {
    //                 selectedHealthCheckBox1.clear();
    //                 healthCheckBox1[13].value = false;
    //               });
    //             } else if (selectedHealthCheckBox1
    //                 .contains(healthCheckBox1[12].title)) {
    //               print("else if");
    //
    //               setState(() {
    //                 selectedHealthCheckBox1.clear();
    //                 healthCheckBox1[12].value = false;
    //               });
    //             }
    //             if (v == true) {
    //               setState(() {
    //                 selectedHealthCheckBox1.add(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               });
    //             } else {
    //               setState(() {
    //                 selectedHealthCheckBox1.remove(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           }
    //           print(selectedHealthCheckBox1);
    //         }
    //         else if (from == 'health2') {
    //           if (healthCheckBox.title == healthCheckBox2.last.title) {
    //             print("if");
    //             setState(() {
    //               selectedHealthCheckBox2.clear();
    //               healthCheckBox2.forEach((element) {
    //                 if (element != healthCheckBox2.last.title) {
    //                   element.value = false;
    //                 }
    //               });
    //               if (v == true) {
    //                 selectedHealthCheckBox2.add(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               } else {
    //                 selectedHealthCheckBox2.remove(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               }
    //             });
    //           } else {
    //             // print("else");
    //             if (v == true) {
    //               // print("if");
    //               setState(() {
    //                 if (selectedHealthCheckBox2
    //                     .contains(healthCheckBox2.last.title)) {
    //                   // print("if");
    //                   selectedHealthCheckBox2.removeWhere(
    //                       (element) => element == healthCheckBox2.last.title);
    //                   healthCheckBox2.forEach((element) {
    //                     if (element.title == healthCheckBox2.last.title) {
    //                       element.value = false;
    //                     }
    //                   });
    //                 }
    //                 selectedHealthCheckBox2.add(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               });
    //             } else {
    //               setState(() {
    //                 selectedHealthCheckBox2.remove(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           }
    //           print(selectedHealthCheckBox2);
    //         }
    //         else if (from == 'smell') {
    //           if (urinSmellOtherSelected) {
    //             if (v == true) {
    //               setState(() {
    //                 urinSmellOtherSelected = false;
    //                 selectedUrinSmellList.clear();
    //                 selectedUrinSmellList.add(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           } else {
    //             if (v == true) {
    //               setState(() {
    //                 selectedUrinSmellList.add(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             } else {
    //               setState(() {
    //                 selectedUrinSmellList.remove(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           }
    //           print(selectedUrinSmellList);
    //         }
    //         else if (from == 'interventions') {
    //           if (medicalInterventionsOtherSelected) {
    //             if (v == true) {
    //               setState(() {
    //                 medicalInterventionsOtherSelected = false;
    //                 selectedmedicalInterventionsDoneBeforeList.clear();
    //                 selectedmedicalInterventionsDoneBeforeList
    //                     .add(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           } else {
    //             if (v == true) {
    //               setState(() {
    //                 selectedmedicalInterventionsDoneBeforeList
    //                     .add(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             } else {
    //               setState(() {
    //                 selectedmedicalInterventionsDoneBeforeList
    //                     .remove(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           }
    //           print(selectedmedicalInterventionsDoneBeforeList);
    //         }
    //
    //         // print("${healthCheckBox.title}=> ${healthCheckBox.value}");
    //       },
    //     ),
    //   ),
    //   title: Text(
    //     healthCheckBox.title.toString(),
    //     style: buildTextStyle(),
    //   ),
    // );
  }

  buildWrapingCheckBox(CheckBoxSettings healthCheckBox) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: kPrimaryColor,
              value: healthCheckBox.value,
              onChanged: (v) {
                setState(() {
                  healthCheckBox.value = v;
                });
              },
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            healthCheckBox.title.toString(),
            style: buildTextStyle(),
          ),
        ],
      ),
    );
  }

  buildFoodCheckBox(CheckBoxSettings foodCheckBox) {
    return ListTile(
      leading: Checkbox(
        activeColor: kPrimaryColor,
        value: foodCheckBox.value,
        onChanged: (v) {
          setState(() {
            foodCheckBox.value = v;
          });
        },
      ),
      title: Text(
        foodCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildSleepCheckBox(CheckBoxSettings sleepCheckBox) {
    return ListTile(
      leading: Checkbox(
        activeColor: kPrimaryColor,
        value: sleepCheckBox.value,
        onChanged: (v) {
          setState(() {
            sleepCheckBox.value = v;
          });
        },
      ),
      title: Text(
        sleepCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildLifeStyleCheckBox(CheckBoxSettings lifeStyleCheckBox) {
    return ListTile(
      leading: Checkbox(
        activeColor: kPrimaryColor,
        value: lifeStyleCheckBox.value,
        onChanged: (v) {
          setState(() {
            lifeStyleCheckBox.value = v;
          });
        },
      ),
      title: Text(
        lifeStyleCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildGutTypeCheckBox(CheckBoxSettings gutTypeCheckBox) {
    return ListTile(
      leading: Checkbox(
        activeColor: kPrimaryColor,
        value: gutTypeCheckBox.value,
        onChanged: (v) {
          setState(() {
            gutTypeCheckBox.value = v;
          });
        },
      ),
      title: Text(
        gutTypeCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  bool validEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isPhone(String input) =>
      RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);

  void addSelectedValuesToList() {
    addHealthCheck1();
    addHealthCheck2();
    addUrinFrequencyDetails();
    addUrinColorDetails();
    addUrinSmelldetails();
    addUrinLooksDetails();
    addMedicalInterventionsDetails();
  }

  void addHealthCheck1() {
    selectedHealthCheckBox1.clear();
    for (var element in healthCheckBox1) {
      if (element.value == true) {
        print(element.title);
        selectedHealthCheckBox1.add(element.title!);
      }
    }
  }

  void addHealthCheck2() {
    selectedHealthCheckBox2.clear();
    for (var element in healthCheckBox2) {
      if (element.value == true) {
        print(element.title);
        selectedHealthCheckBox2.add(element.title!);
      }
    }
  }

  void addUrinFrequencyDetails() {
    selectedUrinFrequencyList.clear();
    for (var element in urinFrequencyList) {
      if (element.value == true) {
        print(element.title);
        selectedUrinFrequencyList.add(element.title!);
      }
    }
  }

  void addUrinColorDetails() {
    selectedUrinColorList.clear();
    if (urinColorList.any((element) => element.value == true) ||
        urinColorOtherSelected) {
      for (var element in urinColorList) {
        if (element.value == true) {
          print(element.title);
          selectedUrinColorList.add(element.title!);
        }
      }
      if (urinColorOtherSelected) {
        selectedUrinColorList.add(otherText);
      }
    }
  }

  void addUrinSmelldetails() {
    selectedUrinSmellList.clear();
    if (urinSmellList.any((element) => element.value == true) ||
        urinSmellOtherSelected) {
      for (var element in urinSmellList) {
        if (element.value == true) {
          print(element.title);
          selectedUrinSmellList.add(element.title!);
        }
      }
      if (urinSmellOtherSelected) {
        selectedUrinSmellList.add(otherText);
      }
    }
  }

  void addUrinLooksDetails() {
    selectedUrinLooksList.clear();
    if (urinLooksList.any((element) => element.value == true) ||
        urinLooksLikeOtherSelected) {
      for (var element in urinLooksList) {
        if (element.value == true) {
          print(element.title);
          selectedUrinLooksList.add(element.title!);
        }
      }
      if (urinLooksLikeOtherSelected) {
        selectedUrinLooksList.add(otherText);
      }
    }
  }

  void addMedicalInterventionsDetails() {
    selectedmedicalInterventionsDoneBeforeList.clear();
    if (medicalInterventionsDoneBeforeList
            .any((element) => element.value == true) ||
        medicalInterventionsOtherSelected) {
      for (var element in medicalInterventionsDoneBeforeList) {
        if (element.value == true) {
          print(element.title);
          selectedmedicalInterventionsDoneBeforeList.add(element.title!);
        }
      }
      if (medicalInterventionsOtherSelected) {
        selectedmedicalInterventionsDoneBeforeList.add(otherText);
      }
    }
  }

  final EvaluationFormRepository repository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void storeDetails(ChildGetEvaluationDataModel model) {
    print('storing');
    print('model.urineColorOther: ${model.urineColorOther}');

    fnameController.text = model.patient?.user?.fname ?? '';
    lnameController.text = model.patient?.user?.lname ?? '';
    mobileController.text = model.patient?.user?.phone ?? '';
    maritalStatus = model.patient?.maritalStatus.toString().capitalize() ?? '';
    gender = model.patient?.user?.gender.toString().capitalize() ?? '';
    emailController.text = model.patient?.user?.email ?? '';
    print("age: ${model.patient?.user?.toJson()}");
    ageController.text = model.patient?.user?.age ?? '';
    address1Controller.text = model.patient?.user?.address ?? '';
    address2Controller.text = model.patient?.address2 ?? '';
    stateController.text = model.patient?.state ?? '';
    cityController.text = model.patient?.city ?? '';
    countryController.text = model.patient?.country ?? '';

    pinCodeController.text = model.patient?.user?.pincode ?? '';
    weightController.text = model.weight ?? '';
    heightText = model.height ?? '';
    if (heightText.isNotEmpty) {
      ft = int.tryParse(heightText.split(".").first) ?? -1;
      inches = int.tryParse(heightText.split(".").last) ?? -1;
    }
    healController.text = model.healthProblem ?? '';
    // print("model.listProblems:${jsonDecode(model.listProblems ?? '')}");
    selectedHealthCheckBox1
        .addAll(List.from(jsonDecode(model.listProblems ?? '')));
    // print("selectedHealthCheckBox1[0]:${(selectedHealthCheckBox1[0].split(',') as List).map((e) => e).toList()}");
    selectedHealthCheckBox1 = List.from(
        (selectedHealthCheckBox1[0].split(',') as List).map((e) => e).toList());
    healthCheckBox1.forEach((element) {
      print(
          'selectedHealthCheckBox1.any((element1) => element1 == element.title): ${selectedHealthCheckBox1.any((element1) => element1 == element.title)}');
      if (selectedHealthCheckBox1
          .any((element1) => element1 == element.title)) {
        element.value = true;
      }
    });

    // selectedHealthCheckBox1.forEach((e1) {
    //   healthCheckBox1.forEach((e2) {
    //     print('e1=>$e1 e2=>${e2.title}');
    //     print("e1 == e2.title:${e1 == e2.title}");
    //     if(e1 == e2.title){
    //       e2.value = true;
    //     }
    //   });
    // });
    checkbox1OtherController.text = model.listProblemsOther ?? '';
    selectedHealthCheckBox2
        .addAll(List.from(jsonDecode(model.listBodyIssues ?? '')));
    if (selectedHealthCheckBox2.first != null) {
      selectedHealthCheckBox2 = List.from(
          (selectedHealthCheckBox2.first.split(',') as List)
              .map((e) => e)
              .toList());
      healthCheckBox2.forEach((element) {
        // print('selectedHealthCheckBox2.any((element1) => element1 == element.title): ${selectedHealthCheckBox2.any((element1) => element1 == element.title)}');
        if (selectedHealthCheckBox2
            .any((element1) => element1 == element.title)) {
          element.value = true;
        }
      });
    }
    tongueCoatingRadio = model.tongueCoating ?? '';
    tongueCoatingController.text = model.tongueCoatingOther ?? '';

    selectedUrinFrequencyList
        .addAll(List.from(jsonDecode(model.anyUrinationIssue ?? '')));
    selectedUrinFrequencyList = List.from(
        (selectedUrinFrequencyList[0].split(',') as List)
            .map((e) => e)
            .toList());
    urinationValue = selectedUrinFrequencyList.first;
    // urinFrequencyList.forEach((element) {
    //   if(selectedUrinFrequencyList.any((element1) => element1 == element.title)){
    //     element.value = true;
    //   }
    // });

    selectedUrinColorList.addAll(List.from(jsonDecode(model.urineColor ?? '')));
    selectedUrinColorList = List.from(
        (selectedUrinColorList[0].split(',') as List).map((e) => e).toList());
    urineColorValue = selectedUrinColorList.first;
    urinColorController.text = model.urineColorOther ?? '';

    // urinColorList.forEach((element) {
    //   if(selectedUrinColorList.any((element1) => element1 == element.title)){
    //     element.value = true;
    //   }
    // });

    selectedUrinSmellList.addAll(List.from(jsonDecode(model.urineSmell ?? '')));
    selectedUrinSmellList = List.from(
        (selectedUrinSmellList[0].split(',') as List).map((e) => e).toList());
    urinSmellList.forEach((element) {
      print(selectedUrinSmellList);
      print(
          'urinSmellList.any((element1) => element1 == element.title): ${selectedUrinSmellList.any((element1) => element1 == element.title)}');
      if (selectedUrinSmellList.any((element1) => element1 == element.title)) {
        element.value = true;
      }
      if (selectedUrinSmellList.any((element) => element == otherText)) {
        urinSmellOtherSelected = true;
      }
    });
    urinSmellController.text = model.urineSmellOther ?? '';

    selectedUrinLooksList
        .addAll(List.from(jsonDecode(model.urineLookLike ?? '')));
    selectedUrinLooksList = List.from(
        (selectedUrinLooksList[0].split(',') as List).map((e) => e).toList());
    urineLookLikeValue = selectedUrinLooksList.first;
    // urinLooksList.forEach((element) {
    //   if(selectedUrinLooksList.any((element1) => element1 == element.title)){
    //     element.value = true;
    //   }
    //   if(selectedUrinLooksList.any((element) => element == otherText)){
    //     urinLooksLikeOtherSelected = true;
    //   }
    // });
    urinLooksLikeController.text = model.urineLookLikeOther ?? '';
    selectedStoolMatch = model.closestStoolType ?? '';

    selectedmedicalInterventionsDoneBeforeList.addAll(
        List.from(jsonDecode(model.anyMedicalIntervationDoneBefore ?? '')));
    selectedmedicalInterventionsDoneBeforeList = List.from(
        (selectedmedicalInterventionsDoneBeforeList[0].split(',') as List)
            .map((e) => e)
            .toList());
    medicalInterventionsDoneBeforeList.forEach((element) {
      print(selectedmedicalInterventionsDoneBeforeList);
      print(element.title);
      print(
          'medicalInterventionsDoneBeforeList.any((element1) => element1 == element.title): ${selectedmedicalInterventionsDoneBeforeList.any((element1) => element1 == element.title)}');
      if (selectedmedicalInterventionsDoneBeforeList
          .any((element1) => element1 == element.title)) {
        element.value = true;
      }
      if (selectedmedicalInterventionsDoneBeforeList
          .any((element) => element == otherText)) {
        medicalInterventionsOtherSelected = true;
      }
    });
    print(model.anyMedicalIntervationDoneBeforeOther);
    medicalInterventionsDoneController.text =
        model.anyMedicalIntervationDoneBeforeOther ?? '';
    medicationsController.text = model.anyMedicationConsumeAtMoment ?? '';
    holisticController.text = model.anyTherapiesHaveDoneBefore ?? '';
    print(
        "model.medicalReport.runtimeType: ${model.medicalReport!.split(',')}");
    List list = jsonDecode(model.medicalReport ?? '');
    print("report list: $list ${list.length}");

    showMedicalReport.clear();
    if (list.isNotEmpty) {
      list.forEach((element) {
        print(element);
        showMedicalReport.add(element.toString());
      });
    }
  }

  showFiles() {
    print(showMedicalReport.runtimeType);
    showMedicalReport.forEach((e) {
      print("e==> $e ${e.runtimeType}");
    });
    final widgetList = showMedicalReport
        .map<Widget>((element) => buildRecordList(element))
        .toList();
    return SizedBox(
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        children: widgetList,
      ),
    );
  }

  buildRecordList(String filename, {int? index}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: getColor(Colors.white, const Color(0xffCBFE86)),
          backgroundColor: getColor(Colors.white, const Color(0xffCBFE86)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                filename.split("/").last,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontSize: 11.dp,
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  medicalRecords.removeAt(index!);
                  setState(() {});
                },
                child: const Icon(
                  Icons.delete_outline_outlined,
                  color: gMainColor,
                )),
          ],
        ),
      ),
    );
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    // ignore: prefer_function_declarations_over_variables
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  TextEditingController editingController = TextEditingController();
  bool isLoading = false;

  List<String> newDataList = [];

  bool showLoading = false;

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

    final res = await EvaluationFormService(repository: repository)
        .getCountryDetailsService(pinCode, countryCode);
    print(res);
    if (res.runtimeType == GetCountryDetailsModel) {
      GetCountryDetailsModel model = res as GetCountryDetailsModel;
      if (model.response.postOffice.isNotEmpty) {
        print(model.response.postOffice.first.state);
        setState(() {
          stateController.text = model.response.postOffice.first.state ?? '';
          cityController.text = model.response.postOffice.first.district ?? '';
          countryController.text = model.response.postOffice.first.country ?? '';
        });
      }
    } else {
      ErrorModel model = res as ErrorModel;
      print(model.message!);
      setState(() {
        _ignoreFields = false;
      });
      AppConfig().showSnackbar(context, "Please Enter Valid Pincode",
          isError: true, bottomPadding: 100);
    }
    Navigator.pop(context);
  }

  Widget buildTabView(
      {required int index,
      required String title,
      required Color color,
      int? itemId}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          heightText = title;
        });
        // onChangedTab(index, id: itemId, title: title);
        Get.back();
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: kFontBook,
          color: gTextColor,
          // color: (statusList[itemId] == title) ? color : gTextColor,
          fontSize: 8.dp,
        ),
      ),
    );
  }

  getProfileData() async {
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
    final res = await UserProfileService(repository: userRepository)
        .getUserProfileService();
    if (res.runtimeType == UserProfileModel) {
      UserProfileModel data = res as UserProfileModel;
      fnameController.text = data.data?.fname ?? '';
      lnameController.text = data.data?.lname ?? '';
      ageController.text = data.data?.age ?? '';
      emailController.text = data.data?.email ?? '';
      mobileController.text = data.data?.phone ?? '';
      gender = (data.data!.gender != null)
          ? data.data!.gender.toString().capitalize()
          : '';
      print(gender);
      print(data.data!.gender.toString());
      setState(() {});
    }
    Navigator.pop(context);
  }

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  buildUrineColorRadioButton() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() => urineColorValue = "Clear");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: "Clear",
                    activeColor: kPrimaryColor,
                    groupValue: urineColorValue,
                    onChanged: (value) {
                      setState(() {
                        urineColorValue = value as String;
                      });
                    },
                  ),
                  Text('Clear',
                      style: buildTextStyle(
                          color: urineColorValue == "Clear"
                              ? kTextColor
                              : gHintTextColor,
                          fontFamily: urineColorValue == "Clear"
                              ? kFontMedium
                              : kFontBook)),
                ],
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            GestureDetector(
              onTap: () {
                setState(() => urineColorValue = "Pale Yellow");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: "Pale Yellow",
                    activeColor: kPrimaryColor,
                    groupValue: urineColorValue,
                    onChanged: (value) {
                      setState(() {
                        urineColorValue = value as String;
                      });
                    },
                  ),
                  Text(
                    'Pale Yellow',
                    style: buildTextStyle(
                        color: urineColorValue == "Pale Yellow"
                            ? kTextColor
                            : gHintTextColor,
                        fontFamily: urineColorValue == "Pale Yellow"
                            ? kFontMedium
                            : kFontBook),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            GestureDetector(
              onTap: () {
                setState(() => urineColorValue = "Red");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      value: "Red",
                      groupValue: urineColorValue,
                      activeColor: kPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          urineColorValue = value as String;
                        });
                      }),
                  Text(
                    "Red",
                    style: buildTextStyle(
                        color: urineColorValue == "Red"
                            ? kTextColor
                            : gHintTextColor,
                        fontFamily:
                            urineColorValue == "Red" ? kFontMedium : kFontBook),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() => urineColorValue = "Black");
              },
              child: Row(
                children: [
                  Radio(
                    value: "Black",
                    activeColor: kPrimaryColor,
                    groupValue: urineColorValue,
                    onChanged: (value) {
                      setState(() {
                        urineColorValue = value as String;
                      });
                    },
                  ),
                  Text(
                    'Black',
                    style: buildTextStyle(
                        color: urineColorValue == "Black"
                            ? kTextColor
                            : gHintTextColor,
                        fontFamily: urineColorValue == "Black"
                            ? kFontMedium
                            : kFontBook),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            GestureDetector(
              onTap: () {
                setState(() => urineColorValue = "Yellow");
              },
              child: Row(
                children: [
                  Radio(
                    value: "Yellow",
                    activeColor: kPrimaryColor,
                    groupValue: urineColorValue,
                    onChanged: (value) {
                      setState(() {
                        urineColorValue = value as String;
                      });
                    },
                  ),
                  Text(
                    'Yellow',
                    style: buildTextStyle(
                        color: urineColorValue == "Yellow"
                            ? kTextColor
                            : gHintTextColor,
                        fontFamily: urineColorValue == "Yellow"
                            ? kFontMedium
                            : kFontBook),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            GestureDetector(
              onTap: () {
                setState(() => urineColorValue = "Other");
              },
              child: Row(
                children: [
                  Radio(
                      value: "Other",
                      groupValue: urineColorValue,
                      activeColor: kPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          urineColorValue = value as String;
                        });
                      }),
                  Text(
                    "Other",
                    style: buildTextStyle(
                        color: urineColorValue == "Other"
                            ? kTextColor
                            : gHintTextColor,
                        fontFamily: urineColorValue == "Other"
                            ? kFontMedium
                            : kFontBook),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildUrineLookRadioButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              urineLookLikeValue = "Clear/Transparent";
            });
          },
          child: Row(
            children: [
              Radio(
                  value: "Clear/Transparent",
                  groupValue: urineLookLikeValue,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      urineLookLikeValue = value as String;
                    });
                  }),
              Text(
                "Clear/Transparent",
                style: buildTextStyle(
                    color: urineLookLikeValue == "Clear/Transparent"
                        ? kTextColor
                        : gHintTextColor,
                    fontFamily: urineLookLikeValue == "Clear/Transparent"
                        ? kFontMedium
                        : kFontBook),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              urineLookLikeValue = "Foggy/cloudy";
            });
          },
          child: Row(
            children: [
              Radio(
                  value: "Foggy/cloudy",
                  groupValue: urineLookLikeValue,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      urineLookLikeValue = value as String;
                    });
                  }),
              Text(
                "Foggy/cloudy",
                style: buildTextStyle(
                    color: urineLookLikeValue == "Foggy/cloudy"
                        ? kTextColor
                        : gHintTextColor,
                    fontFamily: urineLookLikeValue == "Foggy/cloudy"
                        ? kFontMedium
                        : kFontBook),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              urineLookLikeValue = "Other";
            });
          },
          child: Row(
            children: [
              Radio(
                  value: "Other",
                  groupValue: urineLookLikeValue,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      urineLookLikeValue = value as String;
                    });
                  }),
              Text(
                "Other",
                style: buildTextStyle(
                    color: urineLookLikeValue == "Other"
                        ? kTextColor
                        : gHintTextColor,
                    fontFamily: urineLookLikeValue == "Other"
                        ? kFontMedium
                        : kFontBook),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*
variables:
 List<Countries> _countryModel = [];
  List<String> countryList = [];
  List<String> stateList = [];
   String countryValue = "";
  String stateValue = "";
  String cityValue = "";

initstate:
      CountryModel res = CountryModel.fromJson(countries);
    res.countries!.forEach((element) {
      _countryModel.add(element);
      countryList.add(element.country.toString());
    });
    print('countryList: $countryList');

 UI:
   stateDropdown(){
    return GestureDetector(
      onTap: (){
        // openAlertBox();
        editingController.clear();
        newDataList.clear();
        newDataList.addAll(countryList);
        _showCountriesDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(
                color: gHintTextColor,
                width: 1.0,
                style: BorderStyle.solid
            ),)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              countryValue.isEmpty ? 'Select Country' : countryValue,
              style: TextStyle(
                fontFamily: "PoppinsRegular",
                color: gBlackColor,
                fontSize: 10.dp,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_outlined)
          ],
        ),
      ),
    );
  }
  countryDropdown(){
    return GestureDetector(
      onTap: countryValue.isEmpty ? null : (){
        editingController.clear();
        newDataList.clear();
        stateList.clear();
        _countryModel.forEach((element) {
          if(element.country == countryValue){
            stateList.addAll(element.states!);
          }
        });
        newDataList.addAll(stateList);
        _showStatesDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(
                color: gHintTextColor,
                width: 1.0, style: BorderStyle.solid),)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              countryValue.isEmpty ? 'Select Country First' : stateValue.isEmpty ? 'Select State' : stateValue,
              style: TextStyle(
                fontFamily: "PoppinsRegular",
                color: gBlackColor,
                fontSize: 10.dp,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_outlined)
          ],
        ),
      ),
    );
  }


   void _showCountriesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState)
              {
                return AlertDialog(
                  title: Text('Select Country'),
                  content: Container(
                      width: double.minPositive,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                isLoading = true;
                                filterSearchResults(value);
                              });
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)))),
                          ),
                          Expanded(
                            child: !isLoading ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: newDataList == null ? 0 : newDataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  dense: true,
                                  // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                  minVerticalPadding: 0,
                                  title: Text(newDataList[index]),
                                  onTap: () => onSelectedValue(index),
                                );
                              },
                            ) : Text("No records found"),
                          ),
                        ],
                      )),
                );
              });
        });
  }

  void _showStatesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState)
              {
                return AlertDialog(
                  title: Text('Select State'),
                  content: Container(
                      width: double.minPositive,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                isLoading = true;
                                filterSearchResults(value, isCountry: false);
                              });
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)))),
                          ),
                          Expanded(
                            child: !isLoading ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: newDataList == null ? 0 : newDataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  dense: true,
                                  // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                  minVerticalPadding: 0,
                                  title: Text(newDataList[index]),
                                  onTap: () => onSelectedValue(index, isCountry: false),
                                );
                              },
                            ) : Text("No records found"),
                          ),
                        ],
                      )),
                );
              });
        });
  }



   onSelectedValue(int index, {bool isCountry = true})  {
    setState(() {
      print("Selected dialog value is....${newDataList[index]}");
      Navigator.pop(context, newDataList[index]);
      if(isCountry){
        countryValue = newDataList[index];
        stateValue = '';
      }
      else{
        stateValue = newDataList[index];
      }
    });
  }

  filter method:
    void filterSearchResults(String query, {bool isCountry = true}) {
    setState(() {
     if(isCountry){
       newDataList = countryList
           .where((string) => string.toLowerCase().contains(query.toLowerCase()))
           .toList();
     }
     else{
       newDataList = stateList
           .where((string) => string.toLowerCase().contains(query.toLowerCase()))
           .toList();
     }
      debugPrint("Checking Country Name ${newDataList.toString()}");
      isLoading = false;
    });
  }



 */
