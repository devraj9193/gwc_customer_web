class SendChiefQaModel {
  int? status;
  int? errorCode;
  String? errorMsg;

  SendChiefQaModel({
    this.status,
    this.errorCode,
    this.errorMsg,
  });

  factory SendChiefQaModel.fromJson(Map<String, dynamic> json) =>
      SendChiefQaModel(
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
