// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gwc_customer/model/error_model.dart';
// import 'package:gwc_customer/model/program_model/proceed_model/get_proceed_model.dart';
// import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
// import 'package:gwc_customer/repository/api_service.dart';
// import 'package:gwc_customer/repository/program_repository/program_repository.dart';
// import 'package:gwc_customer/screens/evalution_form/check_box_settings.dart';
// import 'package:gwc_customer/screens/prepratory%20plan/transition_mealplan_screen.dart';
// import 'package:gwc_customer/screens/program_plans/day_program_plans.dart';
// import 'package:gwc_customer/screens/program_plans/meal_plan_screen.dart';
// import 'package:gwc_customer/screens/program_plans/program_start_screen.dart';
// import 'package:gwc_customer/services/prepratory_service/prepratory_service.dart';
// import 'package:gwc_customer/services/program_service/program_service.dart';
// import 'package:gwc_customer/utils/app_config.dart';
// import 'package:gwc_customer/widgets/constants.dart';
// import 'package:gwc_customer/widgets/unfocus_widget.dart';
// import 'package:gwc_customer/widgets/widgets.dart';
// import 'package:sizer/sizer.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../repository/prepratory_repository/prep_repository.dart';
// import '../../prepratory plan/new/new_transition_design.dart';
//
// // class DayMealTracerUI extends StatefulWidget {
// //   final ProceedProgramDayModel proceedProgramDayModel;
// //   const DayMealTracerUI({Key? key, required this.proceedProgramDayModel}) : super(key: key);
// //
// //   @override
// //   State<DayMealTracerUI> createState() => _DayMealTracerUIState();
// // }
// //
// // class _DayMealTracerUIState extends State<DayMealTracerUI> {
// //
// //   final formKey = GlobalKey<FormState>();
// //   List missedAnything = [
// //     "Yes, I have",  "No, I've Done It All"
// //   ];
// //
// //   String selectedMissedAnything = '';
// //
// //   final mealPlanMissedController = TextEditingController();
// //
// //   final symptomsCheckBox1 = <CheckBoxSettings>[
// //     CheckBoxSettings(title: "Aches, pain, and soreness"),
// //     CheckBoxSettings(title: "Nausea"),
// //     CheckBoxSettings(title: "Vomiting"),
// //     CheckBoxSettings(title: "Diarrhea"),
// //     CheckBoxSettings(title: "Constipation"),
// //     CheckBoxSettings(title: "Headache"),
// //     CheckBoxSettings(title: "fever or flu-like symptoms"),
// //     CheckBoxSettings(title: "Cold"),
// //     CheckBoxSettings(title: "Frequent urination"),
// //     CheckBoxSettings(title: "Urinary tract discharges"),
// //     CheckBoxSettings(title: "Skin eruptions, including boils, hives, and rashes"),
// //     CheckBoxSettings(title: "Emotional Disturbances like anger, despair, sadness, fear"),
// //     CheckBoxSettings(title: "Anxiety, Mood swings, Phobias"),
// //     CheckBoxSettings(title: "Joints &/or Muscle Pain"),
// //     CheckBoxSettings(title: "Chills"),
// //     CheckBoxSettings(title: "Stuffy Nose"),
// //     CheckBoxSettings(title: "Congestion"),
// //     CheckBoxSettings(title: "Change in Blood Pressure"),
// //     CheckBoxSettings(title: "Severe Joint pain / Body ache"),
// //     CheckBoxSettings(title: "Dry cough / Dryness of mouth"),
// //     CheckBoxSettings(title: "Loss of appetite / tastelessness"),
// //     CheckBoxSettings(title: "Severe thirst"),
// //     CheckBoxSettings(title: "Weaker sense of hearing / vision"),
// //     CheckBoxSettings(title: "Reduction in physical, mental, and or digestive capacity"),
// //     CheckBoxSettings(title: "Feeling dizzy / giddiness"),
// //     CheckBoxSettings(title: "Mind agitation"),
// //     CheckBoxSettings(title: "Weakness / restlessness / cramps / sleeplessness"),
// //     CheckBoxSettings(title: "None Of The Above"),
// //   ];
// //   List selectedSymptoms1 = [];
// //
// //   final symptomsCheckBox2 = <CheckBoxSettings>[
// //     CheckBoxSettings(title: "Satisfactory release of Solid waste matter / Gas from stomach and or Urine"),
// //     CheckBoxSettings(title: "Lightness in the Chest / Abdomen"),
// //     CheckBoxSettings(title: "Odour free burps"),
// //     CheckBoxSettings(title: "Freshness in the Mouth"),
// //     CheckBoxSettings(title: "Easily getting hungry, thirsty, or both"),
// //     CheckBoxSettings(title: "Clear tongue/Sense (absence of discharges from sense organs such as the skin's sweat or perspiration, the ears, the nose, the tongue, and the eyes)"),
// //     CheckBoxSettings(title: "Odour free breath"),
// //     CheckBoxSettings(title: "No Body odour"),
// //     CheckBoxSettings(title: "Weight loss"),
// //     CheckBoxSettings(title: "Peaceful Sleep"),
// //     CheckBoxSettings(title: "Easy Digestion"),
// //     CheckBoxSettings(title: "Increased energy levels"),
// //     CheckBoxSettings(title: "Reduced / absence of cravings"),
// //     CheckBoxSettings(title: "Feeling of internal wellbeing and happiness"),
// //     CheckBoxSettings(title: "Reduced / Absence of Detox related Recovery symptoms as mentioned in the previous question"),
// //     CheckBoxSettings(title: "None of the above"),
// //   ];
// //
// //   List selectedSymptoms2 = [];
// //
// //   String selectedCalmModule = '';
// //
// //   final worriesController = TextEditingController();
// //   final eatSomethingController = TextEditingController();
// //   final anyMedicationsController = TextEditingController();
// //
// //   String didYouCompleteCalmMoveModule = '';
// //
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     mealPlanMissedController.addListener(() {
// //       setState(() {
// //
// //       });
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     // TODO: implement dispose
// //     super.dispose();
// //     mealPlanMissedController.removeListener(() { });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         image: DecorationImage(
// //             image: AssetImage("assets/images/eval_bg.png"),
// //             fit: BoxFit.fitWidth,
// //             colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.lighten)
// //         ),
// //       ),
// //       child: SafeArea(
// //         child: Scaffold(
// //           backgroundColor: Colors.transparent,
// //           body: Column(
// //             children: [
// //               Padding(
// //                 padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     buildAppBar(() {
// //                       Navigator.pop(context);
// //                     }),
// //                     SizedBox(
// //                       width: 3.w,
// //                     ),
// //                     Expanded(
// //                       child: Text(
// //                         "Gut Wellness Club \nMeal Tracker Day${widget.proceedProgramDayModel.day ?? ''}",
// //                         textAlign: TextAlign.start,
// //                         style: TextStyle(
// //                             fontFamily: "PoppinsMedium",
// //                             color: Colors.white,
// //                             fontSize: 12.sp),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(
// //                 height: 4.h,
// //               ),
// //               Expanded(
// //                 child: Container(
// //                   width: double.maxFinite,
// //                   padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     boxShadow: [
// //                       BoxShadow(
// //                           blurRadius: 2, color: Colors.grey.withOpacity(0.5))
// //                     ],
// //                     borderRadius: const BorderRadius.only(
// //                       topLeft: Radius.circular(30),
// //                       topRight: Radius.circular(30),
// //                     ),
// //                   ),
// //                   child: SingleChildScrollView(
// //                     physics: const AlwaysScrollableScrollPhysics(),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               crossAxisAlignment: CrossAxisAlignment.center,
// //                               children: [
// //                                 Text(
// //                                   "Gut Detox Program Status Tracker",
// //                                   textAlign: TextAlign.start,
// //                                   style: TextStyle(
// //                                       fontFamily: "PoppinsBold",
// //                                       color: kPrimaryColor,
// //                                       fontSize: 15.sp),
// //                                 ),
// //                                 SizedBox(
// //                                   width: 2.w,
// //                                 ),
// //                                 Expanded(
// //                                   child: Container(
// //                                     height: 1,
// //                                     color: kPrimaryColor,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             Text(
// //                               "Your detox & healing program tracker that takes less than 1 minute to fill but essential for your doctors to track, manage & intervene effectively.",
// //                               textAlign: TextAlign.start,
// //                               style: TextStyle(
// //                                   fontFamily: "PoppinsRegular",
// //                                   color: gMainColor,
// //                                   fontSize: 9.sp),
// //                             ),
// //                           ],
// //                         ),
// //                         SizedBox(
// //                           height: 2.5.h,
// //                         ),
// //                         buildLabelTextField("Have You Missed Anything In Your Meal Or Yoga Plan Today?"),
// //                         SizedBox(
// //                           height: 1.h,
// //                         ),
// //                         ...missedAnything.map((e) => Row(
// //                           children: [
// //                             Radio<String>(
// //                               value: e,
// //                               activeColor: kPrimaryColor,
// //                               groupValue: selectedMissedAnything,
// //                               onChanged: (value) {
// //                                 setState(() {
// //                                   selectedMissedAnything = value as String;
// //                                 });
// //                               },
// //                             ),
// //                             Text(
// //                               e,
// //                               style: buildTextStyle(),
// //                             ),
// //                           ],
// //                         )),
// //                         showRespectiveWidget()
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   showRespectiveWidget() {
// //     if(selectedMissedAnything.contains(missedAnything[0])){
// //       return Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   Text(
// //                     "Missed Items",
// //                     textAlign: TextAlign.start,
// //                     style: TextStyle(
// //                         fontFamily: "PoppinsBold",
// //                         color: kPrimaryColor,
// //                         fontSize: 15.sp),
// //                   ),
// //                   SizedBox(
// //                     width: 2.w,
// //                   ),
// //                   Expanded(
// //                     child: Container(
// //                       height: 1,
// //                       color: kPrimaryColor,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               Text(
// //                 "Important to understand if this will affect your program & how we can fix it :)",
// //                 textAlign: TextAlign.start,
// //                 style: TextStyle(
// //                     fontFamily: "PoppinsRegular",
// //                     color: gMainColor,
// //                     fontSize: 9.sp),
// //               ),
// //             ],
// //           ),
// //           SizedBox(
// //             height: 3.h,
// //           ),
// //           buildLabelTextField("What Did you Miss In Your Meal Plan Or Yoga Today?"),
// //           SizedBox(
// //             height: 0.5.h,
// //           ),
// //           TextFormField(
// //             controller: mealPlanMissedController,
// //             cursorColor: kPrimaryColor,
// //             validator: (value) {
// //               if (value!.isEmpty ) {
// //                 return 'Please Mention What Did you Miss In Your Meal Plan Or Yoga Today?';
// //               }else {
// //                 return null;
// //               }
// //             },
// //             decoration: CommonDecoration.buildTextInputDecoration(
// //                 "Your answer", mealPlanMissedController),
// //             textInputAction: TextInputAction.next,
// //             textAlign: TextAlign.start,
// //             keyboardType: TextInputType.text,
// //           ),
// //           SizedBox(
// //             height: 3.h,
// //           ),
// //           if(mealPlanMissedController.text.isNotEmpty) symptomsTracker()
// //         ],
// //       );
// //     }
// //     else if(selectedMissedAnything.contains(missedAnything[1])){
// //       return symptomsTracker();
// //     }
// //     else return SizedBox.shrink();
// //   }
// //
// //   symptomsTracker(){
// //     return Form(
// //       key: formKey,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   Text(
// //                     "Symptom Tracker",
// //                     textAlign: TextAlign.start,
// //                     style: TextStyle(
// //                         fontFamily: "PoppinsBold",
// //                         color: kPrimaryColor,
// //                         fontSize: 15.sp),
// //                   ),
// //                   SizedBox(
// //                     width: 2.w,
// //                   ),
// //                   Expanded(
// //                     child: Container(
// //                       height: 1,
// //                       color: kPrimaryColor,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               Text(
// //                 "For your doctor to know if you are on track :)",
// //                 textAlign: TextAlign.start,
// //                 style: TextStyle(
// //                     fontFamily: "PoppinsRegular",
// //                     color: gMainColor,
// //                     fontSize: 9.sp),
// //               ),
// //             ],
// //           ),
// //           SizedBox(
// //             height: 3.h,
// //           ),
// //           buildLabelTextField('Did you deal with any of the following withdrawal symptoms from detox today? If "Yes," then choose all that apply. If no, choose none of the above.'),
// //           SizedBox(
// //             height: 1.h,
// //           ),
// //           ...symptomsCheckBox1.map((e)=> buildHealthCheckBox(e, '1')).toList(),
// //           SizedBox(
// //             height: 1.h,
// //           ),
// //           buildLabelTextField('Did any of the following (adequate) detoxification / healing signs and symptoms happen to you today? If "Yes," then choose all that apply. If no, choose none of the above.'),
// //           SizedBox(
// //             height: 2.h,
// //           ),
// //           ...symptomsCheckBox2.map((e)=> buildHealthCheckBox(e, '2')).toList(),
// //           SizedBox(
// //             height: 2.h,
// //           ),
// //           buildLabelTextField('Please let us know if you notice any other signs or have any other worries. If none, enter "No."'),
// //           SizedBox(
// //             height: 1.h,
// //           ),
// //           TextFormField(
// //             controller: worriesController,
// //             cursorColor: kPrimaryColor,
// //             validator: (value) {
// //               if (value!.isEmpty) {
// //                 return 'Please let us know if you notice any other signs or have any other worries.';
// //               }else {
// //                 return null;
// //               }
// //             },
// //             decoration: CommonDecoration.buildTextInputDecoration(
// //                 "Your answer", worriesController),
// //             textInputAction: TextInputAction.next,
// //             textAlign: TextAlign.start,
// //             keyboardType: TextInputType.name,
// //           ),
// //           SizedBox(
// //             height: 2.h,
// //           ),
// //           buildLabelTextField('Did you eat something other than what was on your meal plan? If "Yes", please give more information? If not, type "No."'),
// //           SizedBox(
// //             height: 1.h,
// //           ),
// //           TextFormField(
// //             controller: eatSomethingController,
// //             cursorColor: kPrimaryColor,
// //             validator: (value) {
// //               if (value!.isEmpty) {
// //                 return 'Did you eat something other than what was on your meal plan?';
// //               }else {
// //                 return null;
// //               }
// //             },
// //             decoration: CommonDecoration.buildTextInputDecoration(
// //                 "Your answer", eatSomethingController),
// //             textInputAction: TextInputAction.next,
// //             textAlign: TextAlign.start,
// //             keyboardType: TextInputType.name,
// //           ),
// //           SizedBox(
// //             height: 2.h,
// //           ),
// //           buildLabelTextField('Did you complete the Calm and Move modules suggested today?'),
// //           SizedBox(
// //             height: 1.h,
// //           ),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.start,
// //             children: [
// //               Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   SizedBox(
// //                     width: 25,
// //                     child: Radio(
// //                       value: "Yes",
// //                       activeColor: kPrimaryColor,
// //                       groupValue: selectedCalmModule,
// //                       onChanged: (value) {
// //                         setState(() {
// //                           selectedCalmModule = value as String;
// //                         });
// //                       },
// //                     ),
// //                   ),
// //                   Text(
// //                     'Yes',
// //                     style: buildTextStyle(),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(
// //                 width: 10.w,
// //               ),
// //               Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   SizedBox(
// //                     width: 25,
// //                     child: Radio(
// //                       value: "No",
// //                       activeColor: kPrimaryColor,
// //                       groupValue: selectedCalmModule,
// //                       onChanged: (value) {
// //                         setState(() {
// //                           selectedCalmModule = value as String;
// //                         });
// //                       },
// //                     ),
// //                   ),
// //                   Text(
// //                     'No',
// //                     style: buildTextStyle(),
// //                   ),
// //                 ],
// //               )
// //             ],
// //           ),
// //           SizedBox(
// //             height: 2.h,
// //           ),
// //           buildLabelTextField('Have you had a medical exam or taken any medications during the program? If "Yes", please give more information. Type "No" if not.'),
// //           SizedBox(
// //             height: 1.h,
// //           ),
// //           TextFormField(
// //             controller: anyMedicationsController,
// //             cursorColor: kPrimaryColor,
// //             validator: (value) {
// //               if (value!.isEmpty) {
// //                 return 'Have you had a medical exam or taken any medications during the program?';
// //               }else {
// //                 return null;
// //               }
// //             },
// //             decoration: CommonDecoration.buildTextInputDecoration(
// //                 "Your answer", anyMedicationsController),
// //             textInputAction: TextInputAction.done,
// //             textAlign: TextAlign.start,
// //             keyboardType: TextInputType.name,
// //           ),
// //           SizedBox(
// //             height: 3.h,
// //           ),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //             children: [
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   primary: eUser().buttonColor,
// //                   onSurface: eUser().buttonTextColor,
// //                   padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(eUser().buttonBorderRadius)
// //                   ),
// //                 ),
// //                 onPressed: (){
// //                   if(formKey.currentState!.validate()){
// //                     if(selectedCalmModule.isNotEmpty){
// //                       if(selectedSymptoms1.isNotEmpty){
// //                         if(selectedSymptoms2.isNotEmpty){
// //                           proceed();
// //                         }
// //                         else{
// //                           AppConfig().showSnackbar(context, "Please select Detoxification/healing signs", isError: true);
// //                         }
// //                       }
// //                       else{
// //                         AppConfig().showSnackbar(context, "Please select withdrawal symptoms", isError: true);
// //                       }
// //                     }
// //                     else{
// //                       AppConfig().showSnackbar(context, "Please select Calm & Move Modules", isError: true);
// //                     }
// //                   }
// //                 },
// //                 child: Center(
// //                   child: Text('Submit',
// //                     style: TextStyle(
// //                       fontFamily: "GothamRoundedBold",
// //                       color: Colors.white,
// //                       fontSize: 12.sp,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   buildHealthCheckBox(CheckBoxSettings healthCheckBox, String from) {
// //     return ListTile(
// //       minLeadingWidth: 30,
// //       horizontalTitleGap: 3,
// //       dense: true,
// //       leading: SizedBox(
// //         width: 20,
// //         child: Checkbox(
// //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //           activeColor: kPrimaryColor,
// //           value: healthCheckBox.value,
// //           onChanged: (v) {
// //             if(from == '1'){
// //               if(healthCheckBox.title == symptomsCheckBox1.last.title){
// //                 print("if");
// //                 setState(() {
// //                   selectedSymptoms1.clear();
// //                   symptomsCheckBox1.forEach((element) {
// //                     element.value = false;
// //                   });
// //                   selectedSymptoms1.add(healthCheckBox.title!);
// //                   healthCheckBox.value = v;
// //                 });
// //               }
// //               else{
// //                 print("else");
// //                 if(selectedSymptoms1.contains(symptomsCheckBox1.last.title)){
// //                   print("if");
// //                   setState(() {
// //                     selectedSymptoms1.clear();
// //                     symptomsCheckBox1.last.value = false;
// //                   });
// //                 }
// //                 if(v == true){
// //                   setState(() {
// //                     selectedSymptoms1.add(healthCheckBox.title!);
// //                     healthCheckBox.value = v;
// //                   });
// //                 }
// //                 else{
// //                   setState(() {
// //                     selectedSymptoms1.remove(healthCheckBox.title!);
// //                     healthCheckBox.value = v;
// //                   });
// //                 }
// //               }
// //               print(selectedSymptoms1);
// //             }
// //             else if(from == '2'){
// //               if(healthCheckBox.title == symptomsCheckBox2.last.title){
// //                 print("if");
// //                 setState(() {
// //                   selectedSymptoms2.clear();
// //                   symptomsCheckBox2.forEach((element) {
// //                     element.value = false;
// //                     // if(element.title != symptomsCheckBox2.last.title){
// //                     // }
// //                   });
// //                   if(v == true){
// //                     selectedSymptoms2.add(healthCheckBox.title);
// //                     healthCheckBox.value = v;
// //                   }
// //                   else{
// //                     selectedSymptoms2.remove(healthCheckBox.title!);
// //                     healthCheckBox.value = v;
// //                   }
// //                 });
// //               }
// //               else{
// //                 // print("else");
// //                 if(v == true){
// //                   // print("if");
// //                   setState(() {
// //                     if(selectedSymptoms2.contains(symptomsCheckBox2.last.title)){
// //                       // print("if");
// //                       selectedSymptoms2.removeWhere((element) => element == symptomsCheckBox2.last.title);
// //                       symptomsCheckBox2.forEach((element) {
// //                         element.value = false;
// //                       });
// //                     }
// //                     selectedSymptoms2.add(healthCheckBox.title!);
// //                     healthCheckBox.value = v;
// //                   });
// //                 }
// //                 else{
// //                   setState(() {
// //                     selectedSymptoms2.remove(healthCheckBox.title!);
// //                     healthCheckBox.value = v;
// //                   });
// //                 }
// //               }
// //               print(selectedSymptoms2);
// //             }
// //             // print("${healthCheckBox.title}=> ${healthCheckBox.value}");
// //
// //           },
// //         ),
// //       ),
// //       title: Text(
// //         healthCheckBox.title.toString(),
// //         style: buildTextStyle(),
// //       ),
// //     );
// //   }
// //
// //   void proceed() async {
// //     ProceedProgramDayModel? model;
// //     model = ProceedProgramDayModel(
// //       patientMealTracking: widget.proceedProgramDayModel.patientMealTracking,
// //       comment: widget.proceedProgramDayModel.comment,
// //       userProgramStatusTracking: '1',
// //       day: widget.proceedProgramDayModel.day,
// //       missedAnyThingRadio: selectedMissedAnything,
// //       didUMiss: mealPlanMissedController.text,
// //       withdrawalSymptoms: selectedSymptoms1.join(','),
// //       detoxification: selectedSymptoms2.join(','),
// //       haveAnyOtherWorries: worriesController.text,
// //       eatSomthingOther: eatSomethingController.text,
// //       completedCalmMoveModules: selectedCalmModule,
// //       hadAMedicalExamMedications: anyMedicationsController.text
// //     );
// //     final result = await ProgramService(repository: repository).proceedDayMealDetailsService(model);
// //
// //     print("result: $result");
// //
// //     if(result.runtimeType == GetProceedModel){
// //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DaysProgramPlan()), (route) => route.isFirst);
// //     }
// //     else{
// //       ErrorModel model = result as ErrorModel;
// //       AppConfig().showSnackbar(context, model.message ?? '', isError: true);
// //     }
// //   }
// //
// //   final ProgramRepository repository = ProgramRepository(
// //     apiClient: ApiClient(
// //       httpClient: http.Client(),
// //     ),
// //   );
// //
// //
// // }
//
//
// class TrackerUI extends StatefulWidget {
//   final ProceedProgramDayModel? proceedProgramDayModel;
//   final String from;
//   const TrackerUI({Key? key, this.proceedProgramDayModel, required this.from}) : super(key: key);
//
//   @override
//   State<TrackerUI> createState() => _TrackerUIState();
// }
//
// class _TrackerUIState extends State<TrackerUI> {
//
//   final formKey = GlobalKey<FormState>();
//   List missedAnything = [
//     "Yes, I have",  "No, I've Done It All"
//   ];
//
//   String selectedMissedAnything = '';
//
//   final mealPlanMissedController = TextEditingController();
//
//   final symptomsCheckBox1 = <CheckBoxSettings>[
//     CheckBoxSettings(title: "Aches, pain, and soreness"),
//     CheckBoxSettings(title: "Nausea"),
//     CheckBoxSettings(title: "Vomiting"),
//     CheckBoxSettings(title: "Diarrhea"),
//     CheckBoxSettings(title: "Constipation"),
//     CheckBoxSettings(title: "Headache"),
//     CheckBoxSettings(title: "Fever or flu-like symptoms"),
//     CheckBoxSettings(title: "Cold"),
//     CheckBoxSettings(title: "Frequent urination"),
//     CheckBoxSettings(title: "Urinary tract discharges"),
//     CheckBoxSettings(title: "Skin eruptions, including boils, hives, and rashes"),
//     CheckBoxSettings(title: "Emotional Disturbances like anger, despair, sadness, fear"),
//     CheckBoxSettings(title: "Anxiety, Mood swings, Phobias"),
//     CheckBoxSettings(title: "Joints &/or Muscle Pain"),
//     CheckBoxSettings(title: "Chills"),
//     CheckBoxSettings(title: "Stuffy Nose"),
//     CheckBoxSettings(title: "Congestion"),
//     CheckBoxSettings(title: "Change in Blood Pressure"),
//     CheckBoxSettings(title: "Severe Joint pain / Body ache"),
//     CheckBoxSettings(title: "Dry cough / Dryness of mouth"),
//     CheckBoxSettings(title: "Loss of appetite / tastelessness"),
//     CheckBoxSettings(title: "Severe thirst"),
//     CheckBoxSettings(title: "Weaker sense of hearing / vision"),
//     CheckBoxSettings(title: "Reduction in physical, mental, and or digestive capacity"),
//     CheckBoxSettings(title: "Feeling dizzy / giddiness"),
//     CheckBoxSettings(title: "Mind agitation"),
//     CheckBoxSettings(title: "Weakness / restlessness / cramps / sleeplessness"),
//     CheckBoxSettings(title: "None Of The Above"),
//   ];
//   List selectedSymptoms1 = [];
//
//   final symptomsCheckBox2 = <CheckBoxSettings>[
//     CheckBoxSettings(title: "Satisfactory release of Solid waste matter / Gas from stomach and or Urine"),
//     CheckBoxSettings(title: "Lightness in the Chest / Abdomen"),
//     CheckBoxSettings(title: "Odour free burps"),
//     CheckBoxSettings(title: "Freshness in the Mouth"),
//     CheckBoxSettings(title: "Easily getting hungry, thirsty, or both"),
//     CheckBoxSettings(title: "Clear tongue/Sense (absence of discharges from sense organs such as the skin's sweat or perspiration, the ears, the nose, the tongue, and the eyes)"),
//     CheckBoxSettings(title: "Odour free breath"),
//     CheckBoxSettings(title: "No Body odour"),
//     CheckBoxSettings(title: "Weight loss"),
//     CheckBoxSettings(title: "Peaceful Sleep"),
//     CheckBoxSettings(title: "Easy Digestion"),
//     CheckBoxSettings(title: "Increased energy levels"),
//     CheckBoxSettings(title: "Reduced / absence of cravings"),
//     CheckBoxSettings(title: "Feeling of internal wellbeing and happiness"),
//     CheckBoxSettings(title: "Reduced / Absence of Detox related Recovery symptoms as mentioned in the previous question"),
//     CheckBoxSettings(title: "None of the above"),
//   ];
//
//   List selectedSymptoms2 = [];
//
//   String selectedCalmModule = '';
//
//   final worriesController = TextEditingController();
//   final eatSomethingController = TextEditingController();
//   final anyMedicationsController = TextEditingController();
//
//   String didYouCompleteCalmMoveModule = '';
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     mealPlanMissedController.addListener(() {
//       setState(() {
//
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     mealPlanMissedController.removeListener(() { });
//   }
//
//   double headingFont = 12.sp;
//   double subHeadingFont = 10.sp;
//   double questionFont = 10.sp;
//
//   @override
//   Widget build(BuildContext context) {
//     return UnfocusWidget(
//       child: Container(
//         width: double.maxFinite,
//         // height: 85.h,
//         // padding: EdgeInsets.fromLTRB(12,15, 12, 0),
//         padding: EdgeInsets.fromLTRB(12,15, 12,  MediaQuery.of(context).viewInsets.bottom),
//         // padding: EdgeInsets.only(
//         //     bottom: MediaQuery.of(context).viewInsets.bottom),
//         // decoration: BoxDecoration(
//         //   color: Colors.white,
//         //   boxShadow: [
//         //     BoxShadow(
//         //         blurRadius: 2, color: Colors.grey.withOpacity(0.5))
//         //   ],
//         //   borderRadius: const BorderRadius.only(
//         //     topLeft: Radius.circular(30),
//         //     topRight: Radius.circular(30),
//         //   ),
//         // ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Gut Detox Program Status Tracker",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                           fontFamily: kFontMedium,
//                           color: gBlackColor,
//                           fontSize: headingFont
//                       ),
//                     ),
//                     SizedBox(
//                       width: 2.w,
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: 1,
//                         color: kLineColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Your detox & healing program tracker that takes less than 1 minute to fill but essential for your doctors to track, manage & intervene effectively.",
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                       fontFamily: kFontMedium,
//                       height: 1.4,
//                       color: gHintTextColor,
//                       fontSize: subHeadingFont
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 2.5.h,
//             ),
//             // buildLabelTextField("Have You Missed Anything In Your Meal Or Yoga Plan Today?"),
//             // SizedBox(
//             //   height: 1.h,
//             // ),
//             // ...missedAnything.map((e) => Row(
//             //   children: [
//             //     Radio<String>(
//             //       value: e,
//             //       activeColor: kPrimaryColor,
//             //       groupValue: selectedMissedAnything,
//             //       onChanged: (value) {
//             //         setState(() {
//             //           selectedMissedAnything = value as String;
//             //         });
//             //       },
//             //     ),
//             //     Text(
//             //       e,
//             //       style: buildTextStyle(),
//             //     ),
//             //   ],
//             // )),
//             // showRespectiveWidget()
//             symptomsTracker()
//           ],
//         ),
//       )
//     );
//   }
//
//   showRespectiveWidget() {
//     if(selectedMissedAnything.contains(missedAnything[0])){
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Missed Items",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         fontFamily: "PoppinsBold",
//                         color: kPrimaryColor,
//                         fontSize: 11.sp),
//                   ),
//                   SizedBox(
//                     width: 2.w,
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 1,
//                       color: kPrimaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 "Important to understand if this will affect your program & how we can fix it :)",
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                     fontFamily: "PoppinsRegular",
//                     color: gMainColor,
//                     fontSize: 9.sp),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           buildLabelTextField("What Did you Miss In Your Meal Plan Or Yoga Today?"),
//           SizedBox(
//             height: 0.5.h,
//           ),
//           TextFormField(
//             controller: mealPlanMissedController,
//             cursorColor: kPrimaryColor,
//             validator: (value) {
//               if (value!.isEmpty ) {
//                 return 'Please Mention What Did you Miss In Your Meal Plan Or Yoga Today?';
//               }else {
//                 return null;
//               }
//             },
//             decoration: CommonDecoration.buildTextInputDecoration(
//                 "Your answer", mealPlanMissedController),
//             textInputAction: TextInputAction.next,
//             textAlign: TextAlign.start,
//             keyboardType: TextInputType.text,
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           if(mealPlanMissedController.text.isNotEmpty) symptomsTracker()
//         ],
//       );
//     }
//     else if(selectedMissedAnything.contains(missedAnything[1])){
//       return symptomsTracker();
//     }
//     else return SizedBox.shrink();
//   }
//
//   symptomsTracker(){
//     return Form(
//       key: formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Symptom Tracker",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         fontFamily: kFontMedium,
//                         color: gBlackColor,
//                         fontSize: headingFont
//                     ),
//                   ),
//                   SizedBox(
//                     width: 2.w,
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 1,
//                       color: kLineColor,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "For your doctor to know if you are on track :)",
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                     fontFamily: kFontMedium,
//                     color: gHintTextColor,
//                     fontSize: subHeadingFont
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           buildLabelTextField('Did you deal with any of the following withdrawal symptoms from detox today? If "Yes," then choose all that apply. If no, choose none of the above.', fontSize: questionFont),
//           SizedBox(
//             height: 1.h,
//           ),
//           ...symptomsCheckBox1.map((e)=> buildHealthCheckBox(e, '1')).toList(),
//           SizedBox(
//             height: 1.h,
//           ),
//           buildLabelTextField('Did any of the following (adequate) detoxification / healing signs and symptoms happen to you today? If "Yes," then choose all that apply. If no, choose none of the above.', fontSize: questionFont),
//           SizedBox(
//             height: 2.h,
//           ),
//           ...symptomsCheckBox2.map((e)=> buildHealthCheckBox(e, '2')).toList(),
//           SizedBox(
//             height: 2.h,
//           ),
//           buildLabelTextField('Please let us know if you notice any other signs or have any other worries. If none, enter "No."', fontSize: questionFont),
//           TextFormField(
//             textCapitalization: TextCapitalization.words,
//             controller: worriesController,
//             cursorColor: kPrimaryColor,
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please let us know if you notice any other signs or have any other worries.';
//               }else {
//                 return null;
//               }
//             },
//             decoration: CommonDecoration.buildTextInputDecoration(
//                 "Your answer", worriesController),
//             textInputAction: TextInputAction.next,
//             textAlign: TextAlign.start,
//             keyboardType: TextInputType.name,
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           buildLabelTextField('Did you eat something other than what was on your meal plan? If "Yes", please give more information? If not, type "No."', fontSize: questionFont),
//           TextFormField(
//             textCapitalization: TextCapitalization.words,
//             controller: eatSomethingController,
//             cursorColor: kPrimaryColor,
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Did you eat something other than what was on your meal plan?';
//               }else {
//                 return null;
//               }
//             },
//             decoration: CommonDecoration.buildTextInputDecoration(
//                 "Your answer", eatSomethingController),
//             textInputAction: TextInputAction.next,
//             textAlign: TextAlign.start,
//             keyboardType: TextInputType.name,
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           buildLabelTextField('Did you complete the Calm and Move modules suggested today?', fontSize: questionFont),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: (){
//                   setState(() {
//                     selectedCalmModule = "Yes";
//                   });
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: 25,
//                       child: Radio(
//                         value: "Yes",
//                         activeColor: kPrimaryColor,
//                         groupValue: selectedCalmModule,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCalmModule = value as String;
//                           });
//                         },
//                       ),
//                     ),
//                     Text(
//                       'Yes',
//                       style: buildTextStyle(
//                           color: selectedCalmModule == 'Yes' ? kTextColor : gHintTextColor,
//                           fontFamily: selectedCalmModule == 'Yes' ? kFontMedium : kFontBook),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 10.w,
//               ),
//               GestureDetector(
//                 onTap: (){
//                   setState(() {
//                     selectedCalmModule = "No";
//                   });
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: 25,
//                       child: Radio(
//                         value: "No",
//                         activeColor: kPrimaryColor,
//                         groupValue: selectedCalmModule,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCalmModule = value as String;
//                           });
//                         },
//                       ),
//                     ),
//                     Text(
//                       'No',
//                       style: buildTextStyle(color: selectedCalmModule == 'No' ? kTextColor : gHintTextColor,
//                           fontFamily: selectedCalmModule == 'No' ? kFontMedium : kFontBook),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           buildLabelTextField('Have you had a medical exam or taken any medications during the program? If "Yes", please give more information. Type "No" if not.', fontSize: questionFont),
//           TextFormField(
//             textCapitalization: TextCapitalization.words,
//             controller: anyMedicationsController,
//             cursorColor: kPrimaryColor,
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Have you had a medical exam or taken any medications during the program?';
//               }else {
//                 return null;
//               }
//             },
//             decoration: CommonDecoration.buildTextInputDecoration(
//                 "Your answer", anyMedicationsController),
//             textInputAction: TextInputAction.done,
//             textAlign: TextAlign.start,
//             keyboardType: TextInputType.name,
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: eUser().buttonColor,
//                   onSurface: eUser().buttonTextColor,
//                   padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(eUser().buttonBorderRadius)
//                   ),
//                 ),
//                 onPressed: (){
//                   if(formKey.currentState!.validate()){
//                     if(selectedCalmModule.isNotEmpty){
//                       if(selectedSymptoms1.isNotEmpty){
//                         if(selectedSymptoms2.isNotEmpty){
//                           proceed();
//                         }
//                         else{
//                           Get.snackbar(
//                             "",
//                             'Please select Detoxification/healing signs',
//                             titleText: SizedBox.shrink(),
//                             colorText: gWhiteColor,
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: gsecondaryColor.withOpacity(0.55),
//                           );
//                           // AppConfig().showSnackbar(context, "Please select Detoxification/healing signs", isError: true);
//                         }
//                       }
//                       else{
//                         Get.snackbar(
//                           "",
//                           'Please select withdrawal symptoms',
//                           titleText: SizedBox.shrink(),
//                           colorText: gWhiteColor,
//                           snackPosition: SnackPosition.BOTTOM,
//                           backgroundColor: gsecondaryColor.withOpacity(0.55),
//                         );
//                         // AppConfig().showSnackbar(context, "Please select withdrawal symptoms", isError: true);
//                       }
//                     }
//                     else{
//                       Get.snackbar(
//                         "",
//                         'Please select Calm & Move Modules',
//                         titleText: SizedBox.shrink(),
//                         colorText: gWhiteColor,
//                         snackPosition: SnackPosition.BOTTOM,
//                         backgroundColor: gsecondaryColor.withOpacity(0.55),
//                       );
//                       // Get.showSnackbar(context, "Please select Calm & Move Modules", isError: true);
//                     }
//                   }
//                 },
//                 child: Center(
//                   child: Text('Submit',
//                     style: TextStyle(
//                       fontFamily: eUser().buttonTextFont,
//                       color: eUser().buttonTextColor,
//                       fontSize: eUser().buttonTextSize,
//                     ),
//                   ),
//                 ),
//               ),
//             ],),
//           SizedBox(
//             height: 5.h,
//           )
//         ],
//       ),
//     );
//   }
//
//   buildHealthCheckBox(CheckBoxSettings healthCheckBox, String from) {
//     return IntrinsicWidth(
//       child: CheckboxListTile(
//         visualDensity: VisualDensity(vertical: -3), // to compact
//         contentPadding: EdgeInsets.symmetric(horizontal: 5),
//         controlAffinity: ListTileControlAffinity.leading,
//         title: Transform.translate(
//           offset: const Offset(-10, 0),
//           child: Text(
//             healthCheckBox.title.toString(),
//             style: buildTextStyle(color: healthCheckBox.value == true ? kTextColor : gHintTextColor,
//                 fontFamily: healthCheckBox.value == true ? kFontMedium : kFontBook
//             ),
//           ),
//         ),
//         dense: true,
//         activeColor: kPrimaryColor,
//         value: healthCheckBox.value,
//         onChanged: (v) {
//           if(from == '1'){
//             if(healthCheckBox.title == symptomsCheckBox1.last.title){
//               print("if");
//               setState(() {
//                 selectedSymptoms1.clear();
//                 symptomsCheckBox1.forEach((element) {
//                   element.value = false;
//                 });
//                 selectedSymptoms1.add(healthCheckBox.title!);
//                 healthCheckBox.value = v;
//               });
//             }
//             else{
//               print("else");
//               if(selectedSymptoms1.contains(symptomsCheckBox1.last.title)){
//                 print("if");
//                 setState(() {
//                   selectedSymptoms1.clear();
//                   symptomsCheckBox1.last.value = false;
//                 });
//               }
//               if(v == true){
//                 setState(() {
//                   selectedSymptoms1.add(healthCheckBox.title!);
//                   healthCheckBox.value = v;
//                 });
//               }
//               else{
//                 setState(() {
//                   selectedSymptoms1.remove(healthCheckBox.title!);
//                   healthCheckBox.value = v;
//                 });
//               }
//             }
//             print(selectedSymptoms1);
//           }
//           else if(from == '2'){
//             if(healthCheckBox.title == symptomsCheckBox2.last.title){
//               print("if");
//               setState(() {
//                 selectedSymptoms2.clear();
//                 symptomsCheckBox2.forEach((element) {
//                   element.value = false;
//                   // if(element.title != symptomsCheckBox2.last.title){
//                   // }
//                 });
//                 if(v == true){
//                   selectedSymptoms2.add(healthCheckBox.title);
//                   healthCheckBox.value = v;
//                 }
//                 else{
//                   selectedSymptoms2.remove(healthCheckBox.title!);
//                   healthCheckBox.value = v;
//                 }
//               });
//             }
//             else{
//               // print("else");
//               if(v == true){
//                 // print("if");
//                 setState(() {
//                   if(selectedSymptoms2.contains(symptomsCheckBox2.last.title)){
//                     // print("if");
//                     selectedSymptoms2.removeWhere((element) => element == symptomsCheckBox2.last.title);
//                     symptomsCheckBox2.forEach((element) {
//                       element.value = false;
//                     });
//                   }
//                   selectedSymptoms2.add(healthCheckBox.title!);
//                   healthCheckBox.value = v;
//                 });
//               }
//               else{
//                 setState(() {
//                   selectedSymptoms2.remove(healthCheckBox.title!);
//                   healthCheckBox.value = v;
//                 });
//               }
//             }
//             print(selectedSymptoms2);
//           }
//         },
//       ),
//     );
//     return ListTile(
//       visualDensity: VisualDensity(vertical: -3), // to compact
//       minVerticalPadding: 0,
//       minLeadingWidth: 30,
//       horizontalTitleGap: 0,
//       dense: true,
//       contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//       leading: SizedBox(
//         width: 24,
//         height: 10,
//         child: Checkbox(
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           activeColor: kPrimaryColor,
//           value: healthCheckBox.value,
//           onChanged: (v) {
//             if(from == '1'){
//               if(healthCheckBox.title == symptomsCheckBox1.last.title){
//                 print("if");
//                 setState(() {
//                   selectedSymptoms1.clear();
//                   symptomsCheckBox1.forEach((element) {
//                     element.value = false;
//                   });
//                   selectedSymptoms1.add(healthCheckBox.title!);
//                   healthCheckBox.value = v;
//                 });
//               }
//               else{
//                 print("else");
//                 if(selectedSymptoms1.contains(symptomsCheckBox1.last.title)){
//                   print("if");
//                   setState(() {
//                     selectedSymptoms1.clear();
//                     symptomsCheckBox1.last.value = false;
//                   });
//                 }
//                 if(v == true){
//                   setState(() {
//                     selectedSymptoms1.add(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   });
//                 }
//                 else{
//                   setState(() {
//                     selectedSymptoms1.remove(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   });
//                 }
//               }
//               print(selectedSymptoms1);
//             }
//             else if(from == '2'){
//               if(healthCheckBox.title == symptomsCheckBox2.last.title){
//                 print("if");
//                 setState(() {
//                   selectedSymptoms2.clear();
//                   symptomsCheckBox2.forEach((element) {
//                     element.value = false;
//                     // if(element.title != symptomsCheckBox2.last.title){
//                     // }
//                   });
//                   if(v == true){
//                     selectedSymptoms2.add(healthCheckBox.title);
//                     healthCheckBox.value = v;
//                   }
//                   else{
//                     selectedSymptoms2.remove(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   }
//                 });
//               }
//               else{
//                 // print("else");
//                 if(v == true){
//                   // print("if");
//                   setState(() {
//                     if(selectedSymptoms2.contains(symptomsCheckBox2.last.title)){
//                       // print("if");
//                       selectedSymptoms2.removeWhere((element) => element == symptomsCheckBox2.last.title);
//                       symptomsCheckBox2.forEach((element) {
//                         element.value = false;
//                       });
//                     }
//                     selectedSymptoms2.add(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   });
//                 }
//                 else{
//                   setState(() {
//                     selectedSymptoms2.remove(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   });
//                 }
//               }
//               print(selectedSymptoms2);
//             }
//             // print("${healthCheckBox.title}=> ${healthCheckBox.value}");
//
//           },
//         ),
//       ),
//       title: Text(
//         healthCheckBox.title.toString(),
//         style: buildTextStyle(color: healthCheckBox.value == true ? kTextColor : gHintTextColor,
//           fontFamily: healthCheckBox.value == true ? kFontMedium : kFontBook
//         ),
//       ),
//     );
//   }
//
//   void proceed() async {
//     ProceedProgramDayModel? model;
//     model = (ProgramMealType.program.name == widget.from) ? ProceedProgramDayModel(
//         patientMealTracking: widget.proceedProgramDayModel!.patientMealTracking,
//         comment: widget.proceedProgramDayModel!.comment,
//         userProgramStatusTracking: '1',
//         day: widget.proceedProgramDayModel!.day,
//         missedAnyThingRadio: widget.proceedProgramDayModel!.patientMealTracking!.any((element) => element.status == 'unfollowed') ? missedAnything[0] : missedAnything[1],
//         // didUMiss: mealPlanMissedController.text,
//         didUMiss: widget.proceedProgramDayModel!.comment,
//         withdrawalSymptoms: selectedSymptoms1.join(','),
//         detoxification: selectedSymptoms2.join(','),
//         haveAnyOtherWorries: worriesController.text,
//         eatSomthingOther: eatSomethingController.text,
//         completedCalmMoveModules: selectedCalmModule,
//         hadAMedicalExamMedications: anyMedicationsController.text
//     )
//         : ProceedProgramDayModel(
//         day: widget.proceedProgramDayModel!.day,
//         userProgramStatusTracking: '1',
//
//         //missedAnyThingRadio: selectedMissedAnything,
//         // didUMiss: mealPlanMissedController.text,
//         //didUMiss: "",
//         withdrawalSymptoms: selectedSymptoms1.join(','),
//         detoxification: selectedSymptoms2.join(','),
//         haveAnyOtherWorries: worriesController.text,
//         eatSomthingOther: eatSomethingController.text,
//         completedCalmMoveModules: selectedCalmModule,
//         hadAMedicalExamMedications: anyMedicationsController.text
//     );
//     final result =
//     (ProgramMealType.program.name == widget.from)
//         ? await ProgramService(repository: repository).proceedDayMealDetailsService(model)
//         : await PrepratoryMealService(repository: prepRepository).proceedDayMealDetailsService(model);
//
//     print("result: $result");
//
//     if(result.runtimeType == GetProceedModel){
//       final _pref = AppConfig().preferences;
//       final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);
//
//       (ProgramMealType.program.name == widget.from)
//           ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MealPlanScreen()), (route) => route.isFirst)
//           : Navigator.pushAndRemoveUntil(context,
//           MaterialPageRoute(
//             builder: (context) => NewTransitionDesign(
//                 totalDays: '',
//                 dayNumber:'',
//                 trackerVideoLink: trackerUrl
//             ),
//           ), (route) => route.isFirst);
//     }
//     else{
//       ErrorModel model = result as ErrorModel;
//       AppConfig().showSnackbar(context, model.message ?? '', isError: true);
//     }
//   }
//
//   final ProgramRepository repository = ProgramRepository(
//     apiClient: ApiClient(
//       httpClient: http.Client(),
//     ),
//   );
//
//   final PrepratoryRepository prepRepository = PrepratoryRepository(
//     apiClient: ApiClient(
//       httpClient: http.Client(),
//     ),
//   );
//
//
// }
