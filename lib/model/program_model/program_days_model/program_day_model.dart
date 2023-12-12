import 'child_program_day.dart';

class ProgramDayModel {
  int? status;
  int? errorCode;
  String? presentDay;
  List<ChildProgramDayModel>? data;

  ProgramDayModel({this.status, this.errorCode, this.data, this.presentDay});

  ProgramDayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    presentDay = json['present_day'].toString();
    if (json['data'] != null) {
      data = <ChildProgramDayModel>[];
      json['data'].forEach((v) {
        data!.add(new ChildProgramDayModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['present_day'] = this.presentDay;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
