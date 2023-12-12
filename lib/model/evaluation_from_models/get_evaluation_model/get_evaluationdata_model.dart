import 'dart:convert';
import 'child_get_evaluation_data_model.dart';

class GetEvaluationDataModel {
  String? status;
  String? errorCode;
  String? key;
  ChildGetEvaluationDataModel? data;

  GetEvaluationDataModel({this.status, this.errorCode, this.key, this.data});

  GetEvaluationDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    key = json['key'];
    data = json['data'] != null ? new ChildGetEvaluationDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
