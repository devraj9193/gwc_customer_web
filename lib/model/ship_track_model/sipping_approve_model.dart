class ShippingApproveModel {
  String? status;
  String? message;
  int? errorCode;

  ShippingApproveModel({this.status, this.message, this.errorCode});

  ShippingApproveModel.fromJson(Map<String, dynamic> json) {
    status = json['status_code'] ?? json['status'].toString();
    message = json['message'] ?? json['data'] ?? json['error'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorCode'] = this.errorCode;
    return data;
  }
}