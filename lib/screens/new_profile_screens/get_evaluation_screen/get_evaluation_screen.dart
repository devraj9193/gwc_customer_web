import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import '../../../model/error_model.dart';
import '../../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import '../../../model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../../widgets/constants.dart';
import 'package:gwc_customer_web/widgets/dart_extensions.dart';

class GetEvaluationScreen extends StatefulWidget {
  const GetEvaluationScreen({Key? key}) : super(key: key);

  @override
  State<GetEvaluationScreen> createState() => _GetEvaluationScreenState();
}

class _GetEvaluationScreenState extends State<GetEvaluationScreen> {
  Future? _getEvaluationDataFuture;

  @override
  void initState() {
    super.initState();
    _getEvaluationDataFuture = EvaluationFormService(repository: repository)
        .getEvaluationDataService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 2.h),
              Text(
                "Evaluation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kFontBold,
                  color: gBlackColor,
                  fontSize: 16.dp,
                ),
              ),
              SizedBox(height: 3.h),
              FutureBuilder(
                  future: _getEvaluationDataFuture,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      print(snapshot.data.runtimeType);
                      if (snapshot.data.runtimeType == GetEvaluationDataModel) {
                        GetEvaluationDataModel model =
                            snapshot.data as GetEvaluationDataModel;
                        ChildGetEvaluationDataModel? model1 = model.data;
                        getDetails(model1);
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Center(
                              child: SizedBox(
                                width:
                                    MediaQuery.of(context).size.shortestSide >
                                            600
                                        ? 40.w
                                        : double.maxFinite,
                                child: Column(
                                  children: [
                                    expansionTileWidget(
                                      "Personal Details",
                                      buildPersonalDetails(model1),
                                    ),
                                    expansionTileWidget(
                                      "Health",
                                      buildHealthDetails(model1),
                                    ),
                                    expansionTileWidget(
                                      "Diet",
                                      buildDietDetails(model1),
                                    ),
                                    expansionTileWidget(
                                      "Food Habits",
                                      buildFoodHabitsDetails(model1),
                                    ),
                                    expansionTileWidget(
                                      "Life Style",
                                      buildLifeStyleDetails(model1),
                                    ),
                                    expansionTileWidget(
                                      "Bowel Type",
                                      buildBowelDetails(model1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        ErrorModel model = snapshot.data as ErrorModel;
                        print(model.message);
                      }
                    } else if (snapshot.hasError) {
                      print("snapshot.error: ${snapshot.error}");
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: buildCircularIndicator(),
                    );
                  }),
            ],
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     buildAppBar(() {
          //       Navigator.pop(context);
          //     }),
          //     SizedBox(height: 1.5.h),
          //     mainView(),
          //     Text(
          //       "Evaluation",
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontFamily: kFontBold,
          //         color: gBlackColor,
          //         fontSize: 16.dp,
          //       ),
          //     ),
          //     SizedBox(height: 3.h),
          //     FutureBuilder(
          //         future: _getEvaluationDataFuture,
          //         builder: (_, snapshot) {
          //           if (snapshot.hasData) {
          //             print(snapshot.data);
          //             print(snapshot.data.runtimeType);
          //             if (snapshot.data.runtimeType == GetEvaluationDataModel) {
          //               GetEvaluationDataModel model =
          //                   snapshot.data as GetEvaluationDataModel;
          //               ChildGetEvaluationDataModel? model1 = model.data;
          //               getDetails(model1);
          //               return Expanded(
          //                 child: SingleChildScrollView(
          //                   child: Center(
          //                     child: SizedBox( width:
          //                     MediaQuery.of(context).size.shortestSide > 600
          //                         ? 40.w
          //                         : double.maxFinite,
          //                       child: Column(
          //                         children: [
          //                           expansionTileWidget(
          //                             "Personal Details",
          //                             buildPersonalDetails(model1),
          //                           ),
          //                           expansionTileWidget(
          //                             "Health",
          //                             buildHealthDetails(model1),
          //                           ),
          //                           expansionTileWidget(
          //                             "Diet",
          //                             buildDietDetails(model1),
          //                           ),
          //                           expansionTileWidget(
          //                             "Food Habits",
          //                             buildFoodHabitsDetails(model1),
          //                           ),
          //                           expansionTileWidget(
          //                             "Life Style",
          //                             buildLifeStyleDetails(model1),
          //                           ),
          //                           expansionTileWidget(
          //                             "Bowel Type",
          //                             buildBowelDetails(model1),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             } else {
          //               ErrorModel model = snapshot.data as ErrorModel;
          //               print(model.message);
          //             }
          //           } else if (snapshot.hasError) {
          //             print("snapshot.error: ${snapshot.error}");
          //           }
          //           return Padding(padding: EdgeInsets.symmetric(vertical: 20.h),child: buildCircularIndicator(),);
          //         }),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget mainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAppBar(() {
          Navigator.pop(context);
        }),
        SizedBox(height: 1.5.h),
        mainView(),
        Text(
          "Evaluation",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: kFontBold,
            color: gBlackColor,
            fontSize: 16.dp,
          ),
        ),
        SizedBox(height: 3.h),
        FutureBuilder(
            future: _getEvaluationDataFuture,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                print(snapshot.data.runtimeType);
                if (snapshot.data.runtimeType == GetEvaluationDataModel) {
                  GetEvaluationDataModel model =
                      snapshot.data as GetEvaluationDataModel;
                  ChildGetEvaluationDataModel? model1 = model.data;
                  getDetails(model1);
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.shortestSide > 600
                              ? 40.w
                              : double.maxFinite,
                          child: Column(
                            children: [
                              expansionTileWidget(
                                "Personal Details",
                                buildPersonalDetails(model1),
                              ),
                              expansionTileWidget(
                                "Health",
                                buildHealthDetails(model1),
                              ),
                              expansionTileWidget(
                                "Diet",
                                buildDietDetails(model1),
                              ),
                              expansionTileWidget(
                                "Food Habits",
                                buildFoodHabitsDetails(model1),
                              ),
                              expansionTileWidget(
                                "Life Style",
                                buildLifeStyleDetails(model1),
                              ),
                              expansionTileWidget(
                                "Bowel Type",
                                buildBowelDetails(model1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  ErrorModel model = snapshot.data as ErrorModel;
                  print(model.message);
                }
              } else if (snapshot.hasError) {
                print("snapshot.error: ${snapshot.error}");
              }
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: buildCircularIndicator(),
              );
            }),
      ],
    );
  }

  expansionTileWidget(String title, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Card(
        child: ExpansionTile(
          expandedAlignment: Alignment.topLeft,
          backgroundColor: gWhiteColor,
          shape: Border.all(color: gGreyColor, width: 1),
          title: Text(
            title,
            style: TextStyle(
              color: gTextColor,
              fontSize: 14.dp,
              fontFamily: kFontMedium,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 3.w, bottom: 2.h, right: 3.w),
              child: child,
            )
          ],
        ),
      ),
    );
  }

  buildPersonalDetails(ChildGetEvaluationDataModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        buildLabelTextField("Full Name:", fontSize: questionFont),
        SizedBox(height: 1.h),
        Row(
          children: [
            buildContainer(model?.patient?.user?.fname ?? ''),
            SizedBox(width: 2.w),
            buildContainer(model?.patient?.user?.lname ?? ''),
          ],
        ),
        SizedBox(height: 2.h),
        buildLabelTextField('Marital Status:', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile(
          model?.patient?.maritalStatus.toString().capitalize() ?? "",
        ),
        SizedBox(height: 1.h),
        buildLabelTextField('Phone Number', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.patient?.user?.phone ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Email ID', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.patient?.user?.email ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Age', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.patient?.user?.age ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Gender', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile(
          model?.patient?.user?.gender.toString().capitalize() ?? "",
        ),
        SizedBox(height: 1.h),
        buildLabelTextField('Profession', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.patient?.user?.profession ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Address', fontSize: questionFont),
        SizedBox(height: 1.h),
        Row(
          children: [
            buildContainer("${model?.patient?.user?.address ?? ''},"),
            SizedBox(width: 1.w),
            buildContainer(model?.patient?.address2 ?? ''),
          ],
        ),
        SizedBox(height: 1.h),
        buildLabelTextField('Pin Code', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.patient?.user?.pincode ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField('City', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.patient?.city ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('State', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.patient?.state ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Country', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.patient?.country ?? ''),
      ],
    );
  }

  buildHealthDetails(ChildGetEvaluationDataModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        buildLabelTextField('Weight In Kgs', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.weight ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField('Height In Feet & Inches', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.height ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            'Brief Paragraph About Your Current Complaints Are & What You Are Looking To Heal Here',
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.healthProblem ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField('Please Check All That Apply To You',
            fontSize: questionFont),
        SizedBox(height: 1.h),
        showSelectedHealthBox(),
        buildContainer(model?.listProblemsOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField('Please Check All That Apply To You',
            fontSize: questionFont),
        SizedBox(height: 1.h),
        showSelectedHealthBox2(),
        SizedBox(height: 1.h),
        buildLabelTextField('Tongue Coating', fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile("${model?.tongueCoating}"),
        buildContainer(model?.tongueCoatingOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Has Frequency Of Urination Increased Or Decreased In The Recent Past",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile("${model?.anyUrinationIssue}"),
        SizedBox(height: 1.h),
        buildLabelTextField("Urine Color", fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile("${model?.urineColor.toString().capitalize()}"),
        buildContainer(model?.urineColorOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("Urine Smell", fontSize: questionFont),
        SizedBox(height: 1.h),
        showSelectedUrinSmellList(),
        SizedBox(height: 1.h),
        buildContainer(model?.urineSmellOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("What Does Your Urine Look Like",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile("${model?.urineLookLike}"),
        SizedBox(height: 1.h),
        buildContainer(model?.urineLookLikeOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("Which one is the closest match to your stool",
            fontSize: questionFont),
        SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
            buildListTile("${model?.closestStoolType}"),
          ],
        ),
        SizedBox(height: 1.h),
        buildLabelTextField("Medical Interventions Done Before",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        showSelectedMedicalInterventionsList(),
        SizedBox(height: 1.h),
        buildContainer(model?.anyMedicalIntervationDoneBeforeOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            'Any Medications/Supplements/Inhalers/Contraceptives You Consume At The Moment',
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.anyMedicationConsumeAtMoment ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            'Holistic/Alternative Therapies You Have Been Through & When (Ayurveda, Homeopathy) ',
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.anyTherapiesHaveDoneBefore ?? ""),
        SizedBox(height: 2.h),
      ],
    );
  }

  buildDietDetails(ChildGetEvaluationDataModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        buildLabelTextField(
            "To Customize Your Meal Plans & Make It As Simple & Easy For You To Follow As Possible",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        Visibility(
          visible: model?.vegNonVegVegan != null,
          child: buildListTile(
            model?.vegNonVegVegan.toString().trim().toTitleCase() ?? "",
          ),
        ),
        Visibility(
          visible: model?.vegNonVegVeganOther != null,
          child: buildContainer(model?.vegNonVegVeganOther ?? ""),
        ),
        buildLabelTextField(
            "What Do You Usually Have As Your Morning Beverage/Snack",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.earlyMorning ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("What Do You Usually Have For Breakfast",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.breakfast ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "What Do You Usually Have For Mid-Day Snack/Beverage",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.midDay ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("What Do You Usually Have For Lunch",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.lunch ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "What Do You Usually Have For Evening Snack/Beverage",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.evening ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("What Do You Usually Have For Dinner",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.dinner ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("What Do You Usually Have Post Dinner/Beverage",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.postDinner ?? ""),
        // Row(
        //   children: [
        //     Radio(
        //       value: "1-2",
        //       activeColor: kPrimaryColor,
        //       groupValue: model?.noGalssesDay,
        //       onChanged: (value) {},
        //     ),
        //     Text(
        //       '1-2',
        //       style: buildTextStyle(),
        //     ),
        //     SizedBox(width: 3.w),
        //     Radio(
        //       value: "3-4",
        //       activeColor: kPrimaryColor,
        //       groupValue: model?.noGalssesDay,
        //       onChanged: (value) {},
        //     ),
        //     Text(
        //       '3-4',
        //       style: buildTextStyle(),
        //     ),
        //     SizedBox(width: 3.w),
        //     Radio(
        //         value: "6-8",
        //         groupValue: model?.noGalssesDay,
        //         activeColor: kPrimaryColor,
        //         onChanged: (value) {}),
        //     Text(
        //       "6-8",
        //       style: buildTextStyle(),
        //     ),
        //     SizedBox(width: 3.w),
        //     Radio(
        //         value: "9+",
        //         groupValue: model?.noGalssesDay,
        //         activeColor: kPrimaryColor,
        //         onChanged: (value) {}),
        //     Text(
        //       "9+",
        //       style: buildTextStyle(),
        //     ),
        //   ],
        // ),
        SizedBox(height: 2.h),
      ],
    );
  }

  buildFoodHabitsDetails(ChildGetEvaluationDataModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        buildLabelTextField(
            "Do Certain Food Affect Your Digestion? If So Please Provide Details.",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.mentionIfAnyFoodAffectsYourDigesion ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Follow Any Special Diet(Keto,Etc)? If So Please Provide Details",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.anySpecialDiet ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Have Any Known Food Allergy? If So Please Provide Details.",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.anyFoodAllergy ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Have Any Known Intolerance? If So Please Provide Details.",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.anyIntolerance ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Have Any Severe Food Cravings? If So Please Provide Details.",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.anySevereFoodCravings ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Dislike Any Food?Please Mention All Of Them",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildContainer(model?.anyDislikeFood ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("How Many Glasses Of Water Do You Have A Day?",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile("${model?.noGalssesDay}"),
        SizedBox(height: 2.h),
      ],
    );
  }

  buildLifeStyleDetails(ChildGetEvaluationDataModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        buildLabelTextField("Habits Or Addiction", fontSize: questionFont),
        SizedBox(height: 1.h),
        showSelectedHabitsList(),
        buildContainer(model?.anyHabbitOrAddictionOther ?? ""),
        SizedBox(height: 2.h),
      ],
    );
  }

  buildBowelDetails(ChildGetEvaluationDataModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        buildLabelTextField("What is your after meal preference?",
            fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile("${model?.afterMealPreference}"),
        buildContainer(model?.afterMealPreferenceOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("Hunger Pattern", fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile("${model?.hungerPattern}"),
        buildContainer(model?.hungerPatternOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("Bowel Pattern", fontSize: questionFont),
        SizedBox(height: 1.h),
        buildListTile("${model?.bowelPattern}"),
        buildContainer(model?.bowelPatternOther ?? ""),
        SizedBox(height: 1.h),
      ],
    );
  }

  buildLabelTextField(String name,
      {double? fontSize, double textScleFactor = 0.9, Key? key}) {
    return RichText(
      key: key,
      text: TextSpan(
        text: name,
        style: TextStyle(
          fontSize: 14.dp,
          color: gBlackColor,
          height: 1.35,
          fontFamily: kFontBook,
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(
              fontSize: 13.dp,
              color: kPrimaryColor,
              fontFamily: "PoppinsSemiBold",
            ),
          ),
        ],
      ),
      textScaler: TextScaler.linear(textScleFactor),
    );
  }

  buildContainer(String title) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style:
          TextStyle(fontFamily: kFontBold, color: gBlackColor, fontSize: 14.dp),
    );
  }

  buildListTile(String title) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -3), // to compact
      minVerticalPadding: 0,
      minLeadingWidth: 30,
      horizontalTitleGap: 0,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      leading: const Icon(
        Icons.radio_button_checked,
        color: gsecondaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: kFontBold, color: gBlackColor, fontSize: 14.dp),
      ),
    );
  }

  List selectedHealthCheckBox1 = [];
  List selectedHealthCheckBox2 = [];
  List selectedUrinSmellList = [];
  List selectedmedicalInterventionsDoneBeforeList = [];
  List selectedHabitCheckBoxList = [];

  showSelectedHealthBox() {
    print("selectedHealthCheckBox1: $selectedHealthCheckBox1");
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedHealthCheckBox1.length,
      itemBuilder: (context, index) {
        return ListTile(
          visualDensity: const VisualDensity(vertical: -3), // to compact
          minVerticalPadding: 0,
          minLeadingWidth: 30,
          horizontalTitleGap: 0,
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),

          leading: const SizedBox(
            width: 15,
            child: Icon(
              Icons.check_box_outlined,
              color: gsecondaryColor,
            ),
          ),
          title: Text(
            selectedHealthCheckBox1[index] ?? "",
            style: TextStyle(
                fontFamily: kFontBold, color: gBlackColor, fontSize: 14.dp),
          ),
        );
      },
    );
  }

  showSelectedHealthBox2() {
    print("selectedHealthCheckBox2: $selectedHealthCheckBox2");
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedHealthCheckBox2.length,
      itemBuilder: (context, index) {
        return ListTile(
          visualDensity: const VisualDensity(vertical: -3), // to compact
          minVerticalPadding: 0,
          minLeadingWidth: 30,
          horizontalTitleGap: 0,
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedHealthCheckBox2[index] ?? "",
            style: TextStyle(
                fontFamily: kFontBold, color: gBlackColor, fontSize: 14.dp),
          ),
        );
      },
    );
  }

  showSelectedUrinSmellList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedUrinSmellList.length,
      itemBuilder: (context, index) {
        return ListTile(
          visualDensity: const VisualDensity(vertical: -3), // to compact
          minVerticalPadding: 0,
          minLeadingWidth: 30,
          horizontalTitleGap: 0,
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedUrinSmellList[index] ?? "",
            style: TextStyle(
                fontFamily: kFontBold, color: gBlackColor, fontSize: 14.dp),
          ),
        );
      },
    );
  }

  showSelectedMedicalInterventionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedmedicalInterventionsDoneBeforeList.length,
      itemBuilder: (context, index) {
        return ListTile(
          visualDensity: const VisualDensity(vertical: -3), // to compact
          minVerticalPadding: 0,
          minLeadingWidth: 30,
          horizontalTitleGap: 0,
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedmedicalInterventionsDoneBeforeList[index] ?? "",
            style: TextStyle(
                fontFamily: kFontBold, color: gBlackColor, fontSize: 14.dp),
          ),
        );
      },
    );
  }

  showSelectedHabitsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedHabitCheckBoxList.length,
      itemBuilder: (context, index) {
        return ListTile(
          visualDensity: const VisualDensity(vertical: -3), // to compact
          minVerticalPadding: 0,
          minLeadingWidth: 30,
          horizontalTitleGap: 0,
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedHabitCheckBoxList[index] ?? "",
            style: TextStyle(
                fontFamily: kFontBold, color: gBlackColor, fontSize: 14.dp),
          ),
        );
      },
    );
  }

  List<String> splitString(String input) {
    List<String> splitStrings = [];

    // Regular expression pattern to match commas outside of parentheses
    RegExp pattern = RegExp(r',(?![^(]*\))');

    // Split the string using the regex pattern
    Iterable<Match> matches = pattern.allMatches(input);
    int start = 0;
    for (Match match in matches) {
      String substring = input.substring(start, match.end).trim();
      splitStrings.add(substring);
      start = match.end;
    }

    // Add the remaining part of the string
    String remaining = input.substring(start).trim();
    splitStrings.add(remaining);

    return splitStrings;
  }

  void getDetails(ChildGetEvaluationDataModel? model) {
    //---- health checkbox1 ----//
    print(model?.listProblems);
    print("health1");
    List lifeStyle = splitString(jsonDecode("${model?.listProblems}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', ''));
    print("lifeStyle: $lifeStyle");
    selectedHealthCheckBox1 = lifeStyle;
    print("selectedHealthCheckBox1: $selectedHealthCheckBox1");

    //---- health checkbox2 ----//
    print(model?.listBodyIssues);
    List lifeStyle1 = jsonDecode("${model?.listBodyIssues}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle1);
    selectedHealthCheckBox2 = lifeStyle1;
    print("selectedHealthCheckBox2: $selectedHealthCheckBox2");

    //---- urineSmell ----//
    print(model?.urineSmell);
    List lifeStyle2 = jsonDecode("${model?.urineSmell}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle2);
    selectedUrinSmellList = lifeStyle2;
    print("selectedUrinSmellList: $selectedUrinSmellList");

    //---- anyMedicalIntervationDoneBefore ----//
    print(model?.anyMedicalIntervationDoneBefore);
    List lifeStyle3 = jsonDecode("${model?.anyMedicalIntervationDoneBefore}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle3);
    selectedmedicalInterventionsDoneBeforeList = lifeStyle3;
    print(
        "selectedmedicalInterventionsDoneBeforeList: $selectedmedicalInterventionsDoneBeforeList");

    //---- selectedHabitCheckBoxList ----//
    print(model?.anyHabbitOrAddiction);
    List lifeStyle4 = jsonDecode("${model?.anyHabbitOrAddiction}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle4);
    selectedHabitCheckBoxList = lifeStyle4;
    print("selectedHabitCheckBoxList: $selectedHabitCheckBoxList");
  }

  final EvaluationFormRepository repository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
