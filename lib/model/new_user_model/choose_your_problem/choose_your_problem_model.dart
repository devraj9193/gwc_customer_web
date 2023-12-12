import 'child_choose_problem.dart';

class ChooseProblemModel {
  int? status;
  int? errorCode;
  String? key;
  List<ChildChooseProblemModel>? data;

  ChooseProblemModel({this.status, this.errorCode, this.key, this.data});

  ChooseProblemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    if (json['data'] != null) {
      data = <ChildChooseProblemModel>[];
      json['data'].forEach((v) {
        data!.add(ChildChooseProblemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
