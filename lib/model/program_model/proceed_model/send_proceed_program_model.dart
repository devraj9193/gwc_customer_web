import 'dart:convert';

class ProceedProgramDayModel {
  List<PatientMealTracking>? patientMealTracking;
  String? comment;
  String? day;
  String? userProgramStatusTracking;
  String? didUMiss;
  String? missedAnyThingRadio;
  String? withdrawalSymptoms;
  String? detoxification;
  String? haveAnyOtherWorries;
  String? eatSomthingOther;
  String? completedCalmMoveModules;
  String? hadAMedicalExamMedications;
  String? trackingAttachment;

  ProceedProgramDayModel({this.patientMealTracking, this.comment,
    this.day,
    this.userProgramStatusTracking,
    this.didUMiss,
    this.missedAnyThingRadio,
    this.withdrawalSymptoms,
    this.detoxification,
    this.haveAnyOtherWorries,
    this.eatSomthingOther,
    this.completedCalmMoveModules,
    this.hadAMedicalExamMedications,
    this.trackingAttachment
  });

  ProceedProgramDayModel.fromJson(Map<String, dynamic> json) {
    if (json['patient_meal_tracking'] != null) {
      patientMealTracking = <PatientMealTracking>[];
      json['patient_meal_tracking[]'].forEach((v) {
        patientMealTracking!.add(new PatientMealTracking.fromJson(v));
      });
    }
    if(json['comment'] != null){
      comment = json['comment'];
    }
    if(json['day'] != null){
      day = json['day'];
    }
    if(json['user_program_status_tracking'] != null){
      userProgramStatusTracking = json['user_program_status_tracking'];
    }
    if(json['did_u_miss_anything'] != null){
      missedAnyThingRadio = json['did_u_miss_anything'];
    }
    if(json['did_u_miss'] != null){
      didUMiss = json['did_u_miss'];
    }
    if(json['withdrawal_symptoms[]'] != null){
      withdrawalSymptoms = json['withdrawal_symptoms[]'];
    }
    if(json['detoxification[]'] != null){
      detoxification = json['detoxification[]'];
    }
    if(json['have_any_other_worries'] != null){
      haveAnyOtherWorries = json['have_any_other_worries'];
    }
    if(json['eat_something_other'] != null){
      eatSomthingOther = json['eat_something_other'];
    }
    if(json['completed_calm_move_modules'] != null){
      completedCalmMoveModules = json['completed_calm_move_modules'];
    }
    if(json['had_a_medical_exam_medications'] != null){
      hadAMedicalExamMedications = json['had_a_medical_exam_medications'];
    }
    if(json['tracking_attachment'] != null){
      trackingAttachment = json['tracking_attachment'];
    }
  }

  Map<String, dynamic> toJson() {
    print('to json error ${withdrawalSymptoms.runtimeType}  ${detoxification.runtimeType}');
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patientMealTracking != null) {
      data['patient_meal_tracking'] =
          this.patientMealTracking!.map((v) => jsonEncode(v.toJson())).toList().toString();
    }
    if(this.comment != null){
      data['comment'] = this.comment;
    }
    data['user_program_status_tracking'] = this.userProgramStatusTracking;
    if(this.day != null){
      data['day'] = this.day;
    }
    if(this.missedAnyThingRadio != null){
      data['did_u_miss_anything'] = this.missedAnyThingRadio;
    }
    if(this.didUMiss != null){
      data['did_u_miss'] = this.didUMiss;
    }
    if(this.withdrawalSymptoms != null){
      data['withdrawal_symptoms[]'] = this.withdrawalSymptoms;
    }
    if(this.detoxification != null){
      data['detoxification[]'] = this.detoxification;
    }
    if(this.haveAnyOtherWorries != null){
      data['have_any_other_worries'] = this.haveAnyOtherWorries;
    }
    if(this.eatSomthingOther != null){
      data['eat_something_other'] = this.eatSomthingOther;
    }
    if(this.completedCalmMoveModules != null){
      data['completed_calm_move_modules'] = this.completedCalmMoveModules;
    }
    if(this.hadAMedicalExamMedications != null){
      data['had_a_medical_exam_medications'] = this.hadAMedicalExamMedications;
    }
    if(this.trackingAttachment != null){
      data['tracking_attachment'] = this.trackingAttachment;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_meal_item_id'] = this.userMealItemId;
    data['day'] = this.day;
    data['status'] = this.status;
    return data;
  }
}