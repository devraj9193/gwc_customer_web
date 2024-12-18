class SendUserAddressModel {
  int? status;
  int? errorCode;
  String? errorMsg;

  SendUserAddressModel({
    this.status,
    this.errorCode,
    this.errorMsg,
  });

  factory SendUserAddressModel.fromJson(Map<String, dynamic> json) =>
      SendUserAddressModel(
        status: json["status"],
        errorCode: json["errorCode"],
        errorMsg: json["errorMsg"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "errorCode": errorCode,
        "errorMsg": errorMsg,
      };
}
