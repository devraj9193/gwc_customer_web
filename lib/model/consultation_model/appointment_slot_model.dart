import 'dart:convert';

import 'child_slots_model.dart';

SlotModel appointmentSlotsFromJson(String str) => SlotModel.fromJson(json.decode(str));

String appointmentSlotsToJson(SlotModel data) => json.encode(data.toJson());

class SlotModel {
  SlotModel({
    this.status,
    this.errorCode,
    this.key,
    this.data,
  });

  String? status;
  int? errorCode;
  String? key;
  Map<String, ChildSlotModel>? data;

  factory SlotModel.fromJson(Map<String, dynamic> json) => SlotModel(
    status: json["status"].toString(),
    errorCode: json["errorCode"],
    key: json["key"],
    data: Map.from(json["data"]).map((k, v) => MapEntry<String, ChildSlotModel>(k, ChildSlotModel.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

