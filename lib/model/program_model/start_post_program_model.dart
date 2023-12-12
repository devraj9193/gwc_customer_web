class StartPostProgramModel {
  String? status;
  String? errorCode;
  String? response;

  StartPostProgramModel({this.status, this.errorCode, this.response});

  StartPostProgramModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    response = json['response'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['response'] = this.response;

    return data;
  }
}
