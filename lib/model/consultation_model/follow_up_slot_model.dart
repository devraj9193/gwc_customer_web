// To parse this JSON data, do
//
//     final followUpSlotModel = followUpSlotModelFromJson(jsonString);

import 'dart:convert';

import 'child_slots_model.dart';

FollowUpSlotModel followUpSlotModelFromJson(String str) => FollowUpSlotModel.fromJson(json.decode(str));

String followUpSlotModelToJson(FollowUpSlotModel data) => json.encode(data.toJson());

class FollowUpSlotModel {
  int status;
  int errorCode;
  String key;
  List<ChildSlotModel> data;

  FollowUpSlotModel({
    required this.status,
    required this.errorCode,
    required this.key,
    required this.data,
  });

  factory FollowUpSlotModel.fromJson(Map<String, dynamic> json) => FollowUpSlotModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    data: List<ChildSlotModel>.from(json["data"].map((x) => ChildSlotModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int isBooked;
  String slot;

  Datum({
    required this.isBooked,
    required this.slot,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    isBooked: json["is_booked"],
    slot: json["slot"],
  );

  Map<String, dynamic> toJson() => {
    "is_booked": isBooked,
    "slot": slot,
  };
}
