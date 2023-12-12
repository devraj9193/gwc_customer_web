class SubmitProblemResponse {
  String? status;
  String? errorCode;
  String? message;

  SubmitProblemResponse({this.status, this.errorCode, this.message});

  SubmitProblemResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    message = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.message;
    return data;
  }
}