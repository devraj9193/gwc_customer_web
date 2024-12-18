class GetChiefQaListModel {
  int? status;
  int? errorCode;
  String? key;
  List<String>? data;

  GetChiefQaListModel({
     this.status,
     this.errorCode,
     this.key,
     this.data,
  });

  factory GetChiefQaListModel.fromJson(Map<String, dynamic> json) => GetChiefQaListModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"].toString(),
    data: List<String>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "data": List<dynamic>.from(data!.map((x) => x)),
  };
}
