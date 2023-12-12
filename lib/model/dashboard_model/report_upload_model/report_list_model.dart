import 'child_report_list_model.dart';

class GetReportListModel {
  String? status;
  int? errorCode;
  String? key;
  String? errorMsg;
  List<ChildReportListModel>? data;

  GetReportListModel({this.status, this.errorCode, this.key, this.errorMsg, this.data});

  GetReportListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'];
    key = json['key'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <ChildReportListModel>[];
      json['data'].forEach((v) {
        data!.add(new ChildReportListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

