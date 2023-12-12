class PostProgramBaseModel {
  String? status;
  String? message;
  String? errorCode;


  PostProgramBaseModel({this.status, this.message});

  PostProgramBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'] ?? json['errorMsg'] ?? json['error'];
    errorCode = json['errorCode'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorCode'] = this.errorCode;
    return data;
  }
}