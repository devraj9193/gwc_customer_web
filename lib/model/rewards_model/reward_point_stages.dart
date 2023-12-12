class RewardPointsStagesModel {
  int? status;
  int? errorCode;
  String? key;
  int? evaluation;
  int? consultationBooked;
  int? consultationDone;
  int? mealItemFollowed;
  int? postProgramConsultationBooked;
  int? postProgramConsultationDone;
  int? maintenanceGuideUpdated;

  RewardPointsStagesModel(
      {this.status,
        this.errorCode,
        this.key,
        this.evaluation,
        this.consultationBooked,
        this.consultationDone,
        this.mealItemFollowed,
        this.postProgramConsultationBooked,
        this.postProgramConsultationDone,
        this.maintenanceGuideUpdated});

  RewardPointsStagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    evaluation = json['evaluation'];
    consultationBooked = json['consultation_booked'];
    consultationDone = json['consultation_done'];
    mealItemFollowed = json['meal_item_followed'];
    postProgramConsultationBooked = json['post_program_consultation_booked'];
    postProgramConsultationDone = json['post_program_consultation_done'];
    maintenanceGuideUpdated = json['maintenance_guide_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['evaluation'] = this.evaluation;
    data['consultation_booked'] = this.consultationBooked;
    data['consultation_done'] = this.consultationDone;
    data['meal_item_followed'] = this.mealItemFollowed;
    data['post_program_consultation_booked'] =
        this.postProgramConsultationBooked;
    data['post_program_consultation_done'] = this.postProgramConsultationDone;
    data['maintenance_guide_updated'] = this.maintenanceGuideUpdated;
    return data;
  }
}