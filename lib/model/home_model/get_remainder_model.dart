// To parse this JSON data, do
//
//     final getRemainderModel = getRemainderModelFromJson(jsonString);

import 'dart:convert';

GetRemainderModel getRemainderModelFromJson(String str) => GetRemainderModel.fromJson(json.decode(str));

String getRemainderModelToJson(GetRemainderModel data) => json.encode(data.toJson());

class GetRemainderModel {
  int? status;
  int? errorCode;
  String? key;
  List<Remainder>? data;

  GetRemainderModel({
     this.status,
     this.errorCode,
     this.key,
     this.data,
  });

  factory GetRemainderModel.fromJson(Map<String, dynamic> json) => GetRemainderModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"].toString(),
    data: List<Remainder>.from(json["data"].map((x) => Remainder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Remainder {
  int? id;
  int? userId;
  String? waterTimings;
  DateTime? createdAt;
  DateTime? updatedAt;

  Remainder({
    this.id,
    this.userId,
    this.waterTimings,
    this.createdAt,
    this.updatedAt,
  });

  factory Remainder.fromJson(Map<String, dynamic> json) => Remainder(
    id: json["id"],
    userId: json["user_id"],
    waterTimings: json["water_timings"].toString(),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "water_timings": waterTimings,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
