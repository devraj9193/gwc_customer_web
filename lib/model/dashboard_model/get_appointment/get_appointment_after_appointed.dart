import 'child_appintment_details.dart';

class GetAppointmentDetailsModel {
  String? data;
  ChildAppointmentDetails? value;

  GetAppointmentDetailsModel(
      {this.data, this.value});

  GetAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    value = json['value'] != null ? new ChildAppointmentDetails.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}



