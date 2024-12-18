import 'dart:convert';

import 'child_evaluation_patient.dart';

class ChildGetEvaluationDataModel {
  int? id;
  String? patientId;
  String? weight;
  String? height;
  String? healthProblem;
  String? listProblems;
  String? listProblemsOther;
  String? listBodyIssues;
  String? tongueCoating;
  String? tongueCoatingOther;
  String? anyUrinationIssue;
  String? urineColor;
  String? urineColorOther;
  String? urineSmell;
  String? urineSmellOther;
  String? urineLookLike;
  String? urineLookLikeOther;
  String? closestStoolType;
  String? anyMedicalIntervationDoneBefore;
  String? anyMedicalIntervationDoneBeforeOther;
  String? anyMedicationConsumeAtMoment;
  String? anyTherapiesHaveDoneBefore;
  String? medicalReport;
  String? vegNonVegVegan;
  String? vegNonVegVeganOther;
  String? earlyMorning;
  String? breakfast;
  String? midDay;
  String? lunch;
  String? evening;
  String? dinner;
  String? postDinner;
  String? mentionIfAnyFoodAffectsYourDigesion;
  String? anySpecialDiet;
  String? anyFoodAllergy;
  String? anyIntolerance;
  String? anySevereFoodCravings;
  String? anyDislikeFood;
  String? noGalssesDay;
  String? anyHabbitOrAddiction;
  String? anyHabbitOrAddictionOther;
  String? afterMealPreference;
  String? afterMealPreferenceOther;
  String? hungerPattern;
  String? hungerPatternOther;
  String? bowelPattern;
  String? bowelPatternOther;
  String? createdAt;
  String? updatedAt;
  ChildEvalPatient? patient;

  ChildGetEvaluationDataModel(
      {this.id,
        this.patientId,
        this.weight,
        this.height,
        this.healthProblem,
        this.listProblems,
        this.listProblemsOther,
        this.listBodyIssues,
        this.tongueCoating,
        this.tongueCoatingOther,
        this.anyUrinationIssue,
        this.urineColor,
        this.urineColorOther,
        this.urineSmell,
        this.urineSmellOther,
        this.urineLookLike,
        this.urineLookLikeOther,
        this.closestStoolType,
        this.anyMedicalIntervationDoneBefore,
        this.anyMedicalIntervationDoneBeforeOther,
        this.anyMedicationConsumeAtMoment,
        this.anyTherapiesHaveDoneBefore,
        this.medicalReport,
        this.vegNonVegVegan,
        this.vegNonVegVeganOther,
        this.earlyMorning,
        this.breakfast,
        this.midDay,
        this.lunch,
        this.evening,
        this.dinner,
        this.postDinner,
        this.mentionIfAnyFoodAffectsYourDigesion,
        this.anySpecialDiet,
        this.anyFoodAllergy,
        this.anyIntolerance,
        this.anySevereFoodCravings,
        this.anyDislikeFood,
        this.noGalssesDay,
        this.anyHabbitOrAddiction,
        this.anyHabbitOrAddictionOther,
        this.afterMealPreference,
        this.afterMealPreferenceOther,
        this.hungerPattern,
        this.hungerPatternOther,
        this.bowelPattern,
        this.bowelPatternOther,
        this.createdAt,
        this.updatedAt,
        this.patient,
      });

  ChildGetEvaluationDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'].toString();
    weight = json['weight'].toString();
    height = json['height'].toString();
    healthProblem = json['health_problem'];
    listProblems = json['list_problems'];
    listProblemsOther = json['list_problems_other'];
    listBodyIssues = json['list_body_issues'] ?? '';
    tongueCoating = json['tongue_coating'];
    tongueCoatingOther = json['tongue_coating_other'];
    anyUrinationIssue = json['any_urination_issue'];
    urineColor = json['urine_color'];
    urineColorOther = json['urine_color_other'];
    urineSmell = json['urine_smell'];
    urineSmellOther = json['urine_smell_other'];
    urineLookLike = json['urine_look_like'];
    urineLookLikeOther = json['urine_look_like_other'];
    closestStoolType = json['closest_stool_type'];
    anyMedicalIntervationDoneBefore =
    json['any_medical_intervation_done_before'];
    anyMedicalIntervationDoneBeforeOther =
    json['any_medical_intervation_done_before_other'];
    anyMedicationConsumeAtMoment = json['any_medication_consume_at_moment'];
    anyTherapiesHaveDoneBefore = json['any_therapies_have_done_before'];
    medicalReport = json['medical_report'] ?? '';

    vegNonVegVegan = json['veg_nonveg_vegan'];
    print("vegNonVegVegan: $vegNonVegVegan");
    vegNonVegVeganOther = json['veg_nonveg_vegan_other'];

    earlyMorning = json['early_morning'];
    breakfast = json['breakfast'];
    midDay = json['mid_day'];
    lunch = json['lunch'];
    evening = json['evening'];
    dinner = json['dinner'];
    postDinner = json['post_dinner'];

    mentionIfAnyFoodAffectsYourDigesion =
    json['mention_if_any_food_affects_your_digesion'];
    anySpecialDiet = json['any_special_diet'];
    anyFoodAllergy = json['any_food_allergy'];
    anyIntolerance = json['any_intolerance'];
    anySevereFoodCravings = json['any_severe_food_cravings'];
    anyDislikeFood = json['any_dislike_food'];
    noGalssesDay = json['no_galsses_day'];
    anyHabbitOrAddiction = json['any_habbit_or_addiction'];
    anyHabbitOrAddictionOther = json['any_habbit_or_addiction_other'];
    afterMealPreference = json['after_meal_preference'];
    afterMealPreferenceOther = json['after_meal_preference_other'];
    hungerPattern = json['hunger_pattern'];
    hungerPatternOther = json['hunger_pattern_other'];
    bowelPattern = json['bowel_pattern'];
    bowelPatternOther = json['bowel_pattern_other'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    patient =
    json['patient'] != null ? ChildEvalPatient.fromJson(json['patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['weight'] = weight;
    data['height'] = height;
    data['health_problem'] = healthProblem;
    data['list_problems'] = listProblems;
    data['list_problems_other'] = listProblemsOther;
    data['list_body_issues'] = listBodyIssues;
    data['tongue_coating'] = tongueCoating;
    data['tongue_coating_other'] = tongueCoatingOther;
    data['any_urination_issue'] = anyUrinationIssue;
    data['urine_color'] = urineColor;
    data['urine_color_other'] = urineColorOther;
    data['urine_smell'] = urineSmell;
    data['urine_smell_other'] = urineSmellOther;
    data['urine_look_like'] = urineLookLike;
    data['urine_look_like_other'] = urineLookLikeOther;
    data['closest_stool_type'] = closestStoolType;
    data['any_medical_intervation_done_before'] =
        anyMedicalIntervationDoneBefore;
    data['any_medical_intervation_done_before_other'] =
        anyMedicalIntervationDoneBeforeOther;
    data['any_medication_consume_at_moment'] =
        anyMedicationConsumeAtMoment;
    data['any_therapies_have_done_before'] = anyTherapiesHaveDoneBefore;
    data['medical_report'] = medicalReport;

    data['veg_nonveg_vegan'] = vegNonVegVegan;
    data['veg_nonveg_vegan_other'] = vegNonVegVeganOther;

    data['early_morning'] = earlyMorning;
    data['breakfast'] = breakfast;
    data['mid_day'] = midDay;
    data['lunch'] = lunch;
    data['evening'] = evening;
    data['dinner'] = dinner;
    data['post_dinner'] = postDinner;

    data['mention_if_any_food_affects_your_digesion'] =
        mentionIfAnyFoodAffectsYourDigesion;
    data['any_special_diet'] = anySpecialDiet;
    data['any_food_allergy'] = anyFoodAllergy;
    data['any_intolerance'] = anyIntolerance;
    data['any_severe_food_cravings'] = anySevereFoodCravings;
    data['any_dislike_food'] = anyDislikeFood;
    data['no_galsses_day'] = noGalssesDay;
    data['any_habbit_or_addiction'] = anyHabbitOrAddiction;
    data['any_habbit_or_addiction_other'] = anyHabbitOrAddictionOther;
    data['after_meal_preference'] = afterMealPreference;
    data['after_meal_preference_other'] = afterMealPreferenceOther;
    data['hunger_pattern'] = hungerPattern;
    data['hunger_pattern_other'] = hungerPatternOther;
    data['bowel_pattern'] = bowelPattern;
    data['bowel_pattern_other'] = bowelPatternOther;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    return data;
  }

  convertToList(String str){
    List<String> list = jsonDecode(str);
    return list;
  }
}
