import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/evalution_form/web_eval_screens/web_eval_screen.dart';
import 'package:http/http.dart' as http;
import '../../../model/dashboard_model/report_upload_model/report_upload_model.dart';
import '../../../model/error_model.dart';
import '../../../model/evaluation_from_models/evaluation_model_format1.dart';
import '../../../model/evaluation_from_models/get_country_details_model.dart';
import '../../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../check_box_settings.dart';
import 'package:gwc_customer_web/widgets/dart_extensions.dart';

class WebPage1 extends StatefulWidget {
  final ChildGetEvaluationDataModel? model;
  const WebPage1({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<WebPage1> createState() => _WebPage1State();
}

class _WebPage1State extends State<WebPage1> {
  final _pref = AppConfig().preferences;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final fNameKey = GlobalKey<FormState>();
  final lNameKey = GlobalKey<FormState>();
  final maritalKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final ageKey = GlobalKey<FormState>();
  final genderKey = GlobalKey<FormState>();
  final professionKey = GlobalKey<FormState>();
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
  TextEditingController professionController = TextEditingController();
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

  int ft = -1;
  int inches = -1;
  String heightText = '';

  List<String> selectedHealthCheckBox1 = [];
  List selectedHealthCheckBox2 = [];
  List selectedUrinSmellList = [];
  List selectedmedicalInterventionsDoneBeforeList = [];
  List selectedUrinFrequencyList = [];
  List selectedUrinColorList = [];
  List selectedUrinLooksList = [];

  bool medicalInterventionsOtherSelected = false;
  bool urinSmellOtherSelected = false;
  bool urinColorOtherSelected = false;
  bool urinLooksLikeOtherSelected = false;

  String tongueCoatingRadio = "";
  String urinationValue = "";
  String urineColorValue = "";
  String urineLookLikeValue = "";
  String selectedStoolMatch = '';

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
            "Respiratory Diseases (Asthama/Allergic bronchitis/Rhinitis/Sinusitis/Frequent Cold, Cough & Fever/Tonsillitis/Wheezing)"),
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
    CheckBoxSettings(title: "Muscle Cramps & Pain"),
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

  final medicalInterventionsDoneBeforeList = [
    CheckBoxSettings(title: "Surgery"),
    CheckBoxSettings(title: "Stents"),
    CheckBoxSettings(title: "Implants"),
    CheckBoxSettings(title: "None"),
  ];

  final urinSmellList = [
    CheckBoxSettings(title: "Normal urine odour"),
    CheckBoxSettings(title: "Fruity"),
    CheckBoxSettings(title: "Ammonia"),
  ];

  final urinFrequencyList = [
    CheckBoxSettings(title: "Increased"),
    CheckBoxSettings(title: "Decreased"),
    CheckBoxSettings(title: "No Change"),
  ];

  final urinLooksList = [
    CheckBoxSettings(title: "Clear/Transparent"),
    CheckBoxSettings(title: "Foggy/cloudy"),
  ];

  final urinColorList = [
    CheckBoxSettings(title: "Clear"),
    CheckBoxSettings(title: "Pale Yellow"),
    CheckBoxSettings(title: "Red"),
    CheckBoxSettings(title: "Black"),
    CheckBoxSettings(title: "Yellow"),
  ];

  ScrollController? scrollController;

  hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    getEvalDetails();
    pinCodeController.addListener(() {
      setState(() {});
    });
    scrollController = ScrollController();
  }

  getEvalDetails() {
    fnameController.text = widget.model?.patient?.user?.fname ?? '';
    lnameController.text = widget.model?.patient?.user?.lname ?? '';
    mobileController.text = widget.model?.patient?.user?.phone ?? '';
    maritalStatus =
        widget.model?.patient?.maritalStatus.toString().capitalize() ?? '';
    gender = widget.model?.patient?.user?.gender.toString().capitalize() ?? '';
    emailController.text = widget.model?.patient?.user?.email ?? '';
    print("age: ${widget.model?.patient?.user?.toJson()}");
    ageController.text = widget.model?.patient?.user?.age ?? '';
    professionController.text = widget.model?.patient?.user?.profession ?? '';
    address1Controller.text = widget.model?.patient?.user?.address ?? '';
    address2Controller.text = widget.model?.patient?.address2 ?? '';
    stateController.text = widget.model?.patient?.state ?? '';
    cityController.text = widget.model?.patient?.city ?? '';
    countryController.text = widget.model?.patient?.country ?? '';

    pinCodeController.text = widget.model?.patient?.user?.pincode ?? '';
    weightController.text = widget.model?.weight ?? '';
    heightText = widget.model?.height ?? '';
    if (heightText.isNotEmpty) {
      ft = int.tryParse(heightText.split(".").first) ?? -1;
      inches = int.tryParse(heightText.split(".").last) ?? -1;
    }
    healController.text = widget.model?.healthProblem ?? '';
    // if (widget.model!.listProblems!.isNotEmpty) {
    //   selectedHealthCheckBox1
    //       .addAll(List.from(jsonDecode(widget.model?.listProblems ?? '')));
    // }

    selectedHealthCheckBox1 = List.from(
        (selectedHealthCheckBox1.first.split(',') as List)
            .map((e) => e)
            .toList());
    for (var element in healthCheckBox1) {
      print(
          'selectedHealthCheckBox1.any((element1) => element1 == element.title): ${selectedHealthCheckBox1.any((element1) => element1 == element.title)}');
      if (selectedHealthCheckBox1
          .any((element1) => element1 == element.title)) {
        element.value = true;
      }
    }
    checkbox1OtherController.text = widget.model?.listProblemsOther ?? '';
    selectedHealthCheckBox2
        .addAll(List.from(jsonDecode(widget.model?.listBodyIssues ?? '')));
    if (selectedHealthCheckBox2.first != null) {
      selectedHealthCheckBox2 = List.from(
          (selectedHealthCheckBox2.first.split(',') as List)
              .map((e) => e)
              .toList());
      for (var element in healthCheckBox2) {
        if (selectedHealthCheckBox2
            .any((element1) => element1 == element.title)) {
          element.value = true;
        }
      }
    }
    tongueCoatingRadio = widget.model?.tongueCoating ?? '';
    tongueCoatingController.text = widget.model?.tongueCoatingOther ?? '';

    selectedUrinFrequencyList
        .addAll(List.from(jsonDecode(widget.model?.anyUrinationIssue ?? '')));
    selectedUrinFrequencyList = List.from(
        (selectedUrinFrequencyList[0].split(',') as List)
            .map((e) => e)
            .toList());
    urinationValue = selectedUrinFrequencyList.first;
    selectedUrinColorList
        .addAll(List.from(jsonDecode(widget.model?.urineColor ?? '')));
    selectedUrinColorList = List.from(
        (selectedUrinColorList[0].split(',') as List).map((e) => e).toList());
    urineColorValue = selectedUrinColorList.first;
    urinColorController.text = widget.model?.urineColorOther ?? '';

    selectedUrinSmellList
        .addAll(List.from(jsonDecode(widget.model?.urineSmell ?? '')));
    selectedUrinSmellList = List.from(
        (selectedUrinSmellList[0].split(',') as List).map((e) => e).toList());
    for (var element in urinSmellList) {
      print(selectedUrinSmellList);
      print(
          'urinSmellList.any((element1) => element1 == element.title): ${selectedUrinSmellList.any((element1) => element1 == element.title)}');
      if (selectedUrinSmellList.any((element1) => element1 == element.title)) {
        element.value = true;
      }
      if (selectedUrinSmellList.any((element) => element == otherText)) {
        urinSmellOtherSelected = true;
      }
    }
    urinSmellController.text = widget.model?.urineSmellOther ?? '';

    urineLookLikeValue = widget.model?.urineLookLike ?? '';

    urinLooksLikeController.text = widget.model?.urineLookLikeOther ?? '';
    selectedStoolMatch = widget.model?.closestStoolType ?? '';

    selectedmedicalInterventionsDoneBeforeList.addAll(List.from(
        jsonDecode(widget.model?.anyMedicalIntervationDoneBefore ?? '')));
    selectedmedicalInterventionsDoneBeforeList = List.from(
        (selectedmedicalInterventionsDoneBeforeList[0].split(',') as List)
            .map((e) => e)
            .toList());
    for (var element in medicalInterventionsDoneBeforeList) {
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
    }
    print(widget.model?.anyMedicalIntervationDoneBeforeOther);
    medicalInterventionsDoneController.text =
        widget.model?.anyMedicalIntervationDoneBeforeOther ?? '';
    medicationsController.text =
        widget.model?.anyMedicationConsumeAtMoment ?? '';
    holisticController.text = widget.model?.anyTherapiesHaveDoneBefore ?? '';
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (mounted) {
      pinCodeController.removeListener(() {});
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) {
        hideKeyboard();
      },
      child: SingleChildScrollView(
        controller: scrollController!,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(
            children: [
              SizedBox(height: 1.5.h),
              buildPersonalDetails(),
              buildHealthDetails(),
              Center(
                child: ButtonWidget(
                  onPressed: () {
                    checkFields(context);
                  },
                  text: 'Submit',
                  isLoading: isSubmitPressed,
                  buttonWidth: 18.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildPersonalDetails() {
    return Form(
      key: formKey1,
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
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          buildLabelTextField("First Name:",
              fontSize: questionFont, key: fNameKey),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: fnameController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
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
              if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
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
                        fontFamily:
                            maritalStatus == "Single" ? kFontMedium : kFontBook,
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
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
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
                            color:
                                gender == "Other" ? kTextColor : gHintTextColor,
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
          buildLabelTextField('Profession',
              fontSize: questionFont, key: professionKey),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: professionController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your Profession';
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", professionController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.streetAddress,
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
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
            ],
          ),
          SizedBox(height: 2.h),
          buildLabelTextField(
              'Full Postal Address To Deliver Your Ready To Cook Kit',
              fontSize: questionFont,
              key: addresskey),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: address2Controller,
            cursorColor: kPrimaryColor,
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
          buildLabelTextField('Pin Code',
              fontSize: questionFont, key: pincodeKey),
          FocusScope(
            onFocusChange: (value) {
              print(value);
              if (cityController.text.isEmpty) {
                if (!value) {
                  print("editing");
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
                  String code = _pref?.getString(AppConfig.countryCode) ?? 'IN';
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
                          fetchCountry(pinCodeController.text, 'IN');

                          FocusManager.instance.primaryFocus?.unfocus();
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
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
              ],
              textAlign: TextAlign.start,
              keyboardType: const TextInputType.numberWithOptions(),
              maxLength: 6,
            ),
          ),
          SizedBox(height: 2.h),
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
          SizedBox(height: 2.h),
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
          SizedBox(height: 2.h),
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
    );
  }

  bool isPhone(String input) =>
      RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);

  buildHealthDetails() {
    return Form(
      key: formKey2,
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
              } else if (int.parse(value) < 20 || int.parse(value) > 120) {
                return 'Please enter Valid Weight';
              }
              return null;
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
                      setState(
                          () => tongueCoatingRadio = "Coated with white layer");
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
                      setState(
                          () => tongueCoatingRadio = "Coated with black layer");
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
          buildLabelTextField("Urine Color",
              fontSize: questionFont, key: urineColorKey),
          buildUrineColorRadioButton(),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      'Other:',
                      style: buildTextStyle(
                          color: urinSmellOtherSelected
                              ? kTextColor
                              : gHintTextColor,
                          fontFamily:
                              urinSmellOtherSelected ? kFontMedium : kFontBook),
                    ),
                  ),
                  activeColor: kPrimaryColor,
                  value: urinSmellOtherSelected,
                  onChanged: (v) {
                    setState(() {
                      urinSmellOtherSelected = v!;
                      if (urinSmellOtherSelected) {
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
                              color: selectedStoolMatch == "Seperate hard lumps"
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
                        selectedStoolMatch = "Soft blobs with clear cut edges";
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
                        selectedStoolMatch = "Mushy consistency not Mostly";
                      });
                    },
                    child: Row(
                      children: [
                        Radio(
                            value: "Mushy consistency not Mostly",
                            groupValue: selectedStoolMatch,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                selectedStoolMatch = value as String;
                              });
                            }),
                        Text(
                          "Mushy consistency not Mostly",
                          style: buildTextStyle(
                              color: selectedStoolMatch ==
                                      "Mushy consistency not Mostly"
                                  ? kTextColor
                                  : gHintTextColor,
                              fontFamily: selectedStoolMatch ==
                                      "Mushy consistency not Mostly"
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
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
                        if (medicalInterventionsDoneBeforeList.last.value ==
                            true) {
                          selectedmedicalInterventionsDoneBeforeList.clear();
                          medicalInterventionsDoneBeforeList.last.value = false;
                        }
                        selectedmedicalInterventionsDoneBeforeList
                            .add(otherText);
                      } else {
                        selectedmedicalInterventionsDoneBeforeList
                            .remove(otherText);
                      }
                      print(
                          "Medical Interventions : $selectedmedicalInterventionsDoneBeforeList");
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
                      if (value!.isEmpty && medicalInterventionsOtherSelected) {
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
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }

  List<String> lst = List.generate(8, (index) => '${index + 1}').toList();
  List<String> lst1 = List.generate(12, (index) => '$index').toList();

  showDropdown() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Feet',
                  style: TextStyle(
                    fontSize: 14.dp,
                    fontFamily: kFontMedium,
                    color: gBlackColor,
                  ),
                ),
                items: lst
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: gBlackColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: ft == -1 ? null : ft.toString(),
                onChanged: (value) {
                  setState(() {
                    ft = int.tryParse(value!) ?? -1;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 160,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: gWhiteColor,
                  ),
                  elevation: 2,
                ),
                iconStyleData: IconStyleData(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                  ),
                  iconSize: 14.dp,
                  iconEnabledColor: gBlackColor,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: gWhiteColor,
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all(6),
                    thumbVisibility: WidgetStateProperty.all(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Inches',
                  style: TextStyle(
                    fontSize: 14.dp,
                    fontFamily: kFontMedium,
                    color: gBlackColor,
                  ),
                ),
                items: lst1
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: gBlackColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: (inches == -1) ? null : inches.toString(),
                onChanged: (value) {
                  setState(() {
                    inches = int.tryParse(value!) ?? -1;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 160,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: gWhiteColor,
                  ),
                  elevation: 2,
                ),
                iconStyleData: IconStyleData(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                  ),
                  iconSize: 14.dp,
                  iconEnabledColor: gBlackColor,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: gWhiteColor,
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all(6),
                    thumbVisibility: WidgetStateProperty.all(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  buildHealthCheckBox(CheckBoxSettings healthCheckBox, String from) {
    return IntrinsicWidth(
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
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
            if (healthCheckBox.title == healthCheckBox1[12].title) {
              print(" else if");
              setState(() {
                selectedHealthCheckBox1.clear();
                for (var element in healthCheckBox1) {
                  element.value = false;
                }
                selectedHealthCheckBox1.add(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            } else {
              print("else");
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
                for (var element in healthCheckBox2) {
                  if (element != healthCheckBox2.last.title) {
                    element.value = false;
                  }
                }
                if (v == true) {
                  selectedHealthCheckBox2.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                } else {
                  selectedHealthCheckBox2.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                }
              });
            } else {
              if (v == true) {
                setState(() {
                  if (selectedHealthCheckBox2
                      .contains(healthCheckBox2.last.title)) {
                    selectedHealthCheckBox2.removeWhere(
                        (element) => element == healthCheckBox2.last.title);
                    for (var element in healthCheckBox2) {
                      if (element.title == healthCheckBox2.last.title) {
                        element.value = false;
                      }
                    }
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
            if (healthCheckBox.title ==
                medicalInterventionsDoneBeforeList.last.title) {
              print("if");
              setState(() {
                selectedmedicalInterventionsDoneBeforeList.clear();
                medicalInterventionsOtherSelected = false;
                for (var element in medicalInterventionsDoneBeforeList) {
                  if (element.title !=
                      medicalInterventionsDoneBeforeList.last.title) {
                    element.value = false;
                  }
                }
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
        },
      ),
    );
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
      } else if (professionController.text.isEmpty) {
        Scrollable.ensureVisible(professionKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Your Profession",
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
        Scrollable.ensureVisible(urinIncreasedKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(
            context, "Please Select Frequency of Urination",
            isError: true, bottomPadding: 100);
      } else if (urineColorValue.isEmpty) {
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
    } else {
      print("else");
      if (maritalStatus == "") {
        Scrollable.ensureVisible(maritalKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Select Marital Status",
            isError: true, bottomPadding: 100);
      } else if (professionController.text.isEmpty) {
        Scrollable.ensureVisible(professionKey.currentContext!,
            duration: const Duration(milliseconds: 1000));
        AppConfig().showSnackbar(context, "Please Mention Your Profession",
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

        _pref!.setString(AppConfig.eval1, jsonEncode(eval1.toMap()));

        final json = jsonDecode(_pref!.getString(AppConfig.eval1)!);

        print("local map: $json");

        print(urineColorValue);

        Map finalMap = {};
        finalMap.addAll(eval1.toMap().cast());

        callApi(finalMap, null);
      }
    }
  }

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

  createFormMap() {
    return EvaluationModelFormat1(
      fname: fnameController.text.capitalize(),
      lname: lnameController.text.capitalize(),
      maritalStatus: maritalStatus,
      phone: mobileController.text,
      email: emailController.text,
      age: ageController.text,
      gender: gender,
      profession: professionController.text.capitalize(),
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
      print(result);
      setState(() {
        isSubmitPressed = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const WebEvalScreen(),
        ),
      );
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
}
