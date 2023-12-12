class FeedbackModel {
  String? status;
  String? errorCode;
  String? errorMsg;

  FeedbackModel(
      {this.status, this.errorCode, this.errorMsg});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    errorMsg = json['errorMsg'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}