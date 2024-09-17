import 'dart:convert';

class SubmitMealPlanTrackerModel {
  List<PatientMealTracking>? patientMealTracking;
  String? comment;
  String? day;
  // String? userProgramStatusTracking;
  String? phase;
  String? mealPlanType;
  String? anyMedications;
  String? medicationUsed;
  String? followMealPlan;
  String? anythingMissedInMealPlan;
  String? followYogaModules;
  String? missedAnythingInYogaPlan;
  String? sleep;
  String? stoolFormation;
  String? anySymptoms;
  String? generalHealth;
  String? compareToYesterday;
  String? dazzinessSymptoms;
  String? vomitingSymptoms;
  String? looseMotionSymptoms;
  String? noEvacuationSymptoms;
  String? extremeHeadacheSymptoms;
  String? anxietySymptoms;
  String? part2Symptoms;
  String? part3Symptoms;
  String? healingSigns;
  String? nourishSigns;
  String? previousSymptoms;

  SubmitMealPlanTrackerModel({
    this.patientMealTracking,
    this.comment,
    this.day,
    // this.userProgramStatusTracking,
    this.phase,
    this.mealPlanType,
    this.anyMedications,
    this.medicationUsed,
    this.followMealPlan,
    this.anythingMissedInMealPlan,
    this.followYogaModules,
    this.missedAnythingInYogaPlan,
    this.sleep,
    this.stoolFormation,
    this.anySymptoms,
    this.generalHealth,
    this.compareToYesterday,
    this.dazzinessSymptoms,
    this.vomitingSymptoms,
    this.looseMotionSymptoms,
    this.noEvacuationSymptoms,
    this.extremeHeadacheSymptoms,
    this.anxietySymptoms,
  this.part2Symptoms,
  this.part3Symptoms,
  this.healingSigns,
    this.nourishSigns,
    this.previousSymptoms,
  });

  SubmitMealPlanTrackerModel.fromJson(Map<String, dynamic> json) {
    if (json['patient_meal_tracking'] != null) {
      patientMealTracking = <PatientMealTracking>[];
      json['patient_meal_tracking[]'].forEach((v) {
        patientMealTracking!.add(PatientMealTracking.fromJson(v));
      });
    }
    if (json['comment'] != null) {
      comment = json['comment'];
    }
    if (json['day'] != null) {
      day = json['day'];
    }
    // if (json['user_program_status_tracking'] != null) {
    //   userProgramStatusTracking = json['user_program_status_tracking'];
    // }
    if (json['phase'] != null) {
      phase = json['phase'];
    }
    if (json['meal_plan_type'] != null) {
      mealPlanType = json['meal_plan_type'];
    }
    if (json['any_medications'] != null) {
      anyMedications = json['any_medications'];
    }
    if (json['medication_used'] != null) {
      medicationUsed = json['medication_used'];
    }
    if (json['follow_meal_plan'] != null) {
      followMealPlan = json['follow_meal_plan'];
    }
    if (json['anything_missed_in_meal_plan'] != null) {
      anythingMissedInMealPlan = json['anything_missed_in_meal_plan'];
    }
    if (json['follow_yoga_modules'] != null) {
      followYogaModules = json['follow_yoga_modules'];
    }
    if (json['missed_anything_in_yoga_plan'] != null) {
      missedAnythingInYogaPlan = json['missed_anything_in_yoga_plan'];
    }
    if (json['sleep'] != null) {
      sleep = json['sleep'];
    }
    if (json['stool_formation'] != null) {
      stoolFormation = json['stool_formation'];
    }
    if (json['any_symptoms'] != null) {
      anySymptoms = json['any_symptoms'];
    }

    if (json['general_health'] != null) {
      generalHealth = json['general_health'];
    }
    if (json['compare_yesterday'] != null) {
      compareToYesterday = json['compare_yesterday'];
    }

    if (json['dazziness_symptoms'] != null) {
      dazzinessSymptoms = json['dazziness_symptoms'];
    }
    if (json['vomiting_symptoms'] != null) {
      vomitingSymptoms = json['vomiting_symptoms'];
    }
    if (json['loose_motion_symptoms'] != null) {
      looseMotionSymptoms = json['loose_motion_symptoms'];
    }
    if (json['no_evacuation_symptoms'] != null) {
      noEvacuationSymptoms = json['no_evacuation_symptoms'];
    }
    if (json['extreme_headache_symptoms'] != null) {
      extremeHeadacheSymptoms = json['extreme_headache_symptoms'];
    }
    if (json['anxiety_symptoms'] != null) {
      anxietySymptoms = json['anxiety_symptoms'];
    }
    if (json['part2_symptoms[]'] != null) {
      part2Symptoms = json['part2_symptoms[]'];
    }
    if (json['part3_symptoms[]'] != null) {
      part3Symptoms = json['part3_symptoms[]'];
    }
    if (json['healing_signs[]'] != null) {
      healingSigns = json['healing_signs[]'];
    }
    if (json['nourish_signs[]'] != null) {
      nourishSigns = json['nourish_signs[]'];
    }
    if (json['previous_symptoms'] != null) {
      previousSymptoms = json['previous_symptoms'];
    }
  }

  Map<String, dynamic> toJson() {
    print('to json error ${phase.runtimeType}  ${phase.runtimeType}');
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patientMealTracking != null) {
      data['patient_meal_tracking'] = patientMealTracking!
          .map((v) => jsonEncode(v.toJson()))
          .toList()
          .toString();
    }
    if (comment != null) {
      data['comment'] = comment;
    }
    // data['user_program_status_tracking'] = userProgramStatusTracking;
    if (day != null) {
      data['day'] = day;
    }
    if (phase != null) {
      data['phase'] = phase;
    }
    if(mealPlanType != null){
      data['meal_plan_type'] = mealPlanType;
    }
    if (anyMedications != null) {
      data['any_medications'] = anyMedications;
    }
    if (medicationUsed != null) {
      data['medication_used'] = medicationUsed;
    }
    if (followMealPlan != null) {
      data['follow_meal_plan'] = followMealPlan;
    }
    if (anythingMissedInMealPlan != null) {
      data['anything_missed_in_meal_plan'] = anythingMissedInMealPlan;
    }
    if (followYogaModules != null) {
      data['follow_yoga_modules'] = followYogaModules;
    }
    if (missedAnythingInYogaPlan != null) {
      data['missed_anything_in_yoga_plan'] = missedAnythingInYogaPlan;
    }
    if (sleep != null) {
      data['sleep'] = sleep;
    }
    if (stoolFormation != null) {
      data['stool_formation'] = stoolFormation;
    }
    if (anySymptoms != null) {
      data['any_symptoms'] = anySymptoms;
    }
    if (generalHealth != null) {
      data['general_health'] = generalHealth;
    }
    if (compareToYesterday != null) {
      data['compare_yesterday'] = compareToYesterday;
    }
    if (dazzinessSymptoms != null) {
      data['dazziness_symptoms'] = dazzinessSymptoms;
    }
    if (vomitingSymptoms != null) {
      data['vomiting_symptoms'] = vomitingSymptoms;
    }
    if (looseMotionSymptoms != null) {
      data['loose_motion_symptoms'] = looseMotionSymptoms;
    }
    if (noEvacuationSymptoms != null) {
      data['no_evacuation_symptoms'] = noEvacuationSymptoms;
    }
    if (extremeHeadacheSymptoms != null) {
      data['extreme_headache_symptoms'] = extremeHeadacheSymptoms;
    }
    if (anxietySymptoms != null) {
      data['anxiety_symptoms'] = anxietySymptoms;
    }
    if (part2Symptoms != null) {
      data['part2_symptoms[]'] = part2Symptoms;
    }
    if (part3Symptoms != null) {
      data['part3_symptoms[]'] = part3Symptoms;
    }
    if (healingSigns != null) {
      data['healing_signs[]'] = healingSigns;
    }
    if (nourishSigns != null) {
      data['nourish_signs[]'] = nourishSigns;
    }
    if (previousSymptoms != null) {
      data['previous_symptoms'] = previousSymptoms;
    }
    return data;
  }
}

class PatientMealTracking {
  int? userMealItemId;
  int? day;
  String? status;

  PatientMealTracking({this.userMealItemId, this.day, this.status});

  PatientMealTracking.fromJson(Map<String, dynamic> json) {
    userMealItemId = json['user_meal_item_id'];
    day = json['day'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_meal_item_id'] = userMealItemId;
    data['day'] = day;
    data['status'] = status;
    return data;
  }
}
