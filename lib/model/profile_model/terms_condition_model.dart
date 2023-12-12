class TermsConditionModel {
  int? status;
  int? errorCode;
  String? key;
  String? data;

  TermsConditionModel({this.status, this.errorCode, this.key, this.data});

  TermsConditionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['data'] = this.data;
    return data;
  }
}
