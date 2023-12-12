class ReportUploadModel {
  int? status;
  int? errorCode;
  String? errorMsg;

  ReportUploadModel({this.status, this.errorCode, this.errorMsg});

  ReportUploadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'] ?? json['msg'] ?? json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}