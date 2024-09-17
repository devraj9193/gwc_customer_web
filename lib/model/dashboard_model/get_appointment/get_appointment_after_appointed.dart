import 'child_appintment_details.dart';

class GetAppointmentDetailsModel {
  String? data;
  ChildAppointmentDetails? value;
  String? isProgramFeedbackSubmitted;

  GetAppointmentDetailsModel(
      {this.data, this.value ,this.isProgramFeedbackSubmitted});

  GetAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    value = json['value'] != null ? ChildAppointmentDetails.fromJson(json['value']) : null;
    isProgramFeedbackSubmitted = json['is_program_feedback_submitted']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    if (value != null) {
      data['value'] = value!.toJson();
    }
    if (isProgramFeedbackSubmitted != null){
      data['is_program_feedback_submitted'] = isProgramFeedbackSubmitted.toString();
    }
    return data;
  }
}



