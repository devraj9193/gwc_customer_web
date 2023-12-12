class GetProceedModel {
  String? status;
  int? errorCode;
  String? errorMsg;

  GetProceedModel(
      {this.status, this.errorCode, this.errorMsg});

  GetProceedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}