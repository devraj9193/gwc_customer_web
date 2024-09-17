// To parse this JSON data, do
//
//     final shiftSlotsModel = shiftSlotsModelFromJson(jsonString);

import 'dart:convert';

ShiftSlotsModel shiftSlotsModelFromJson(String str) => ShiftSlotsModel.fromJson(json.decode(str));

String shiftSlotsModelToJson(ShiftSlotsModel data) => json.encode(data.toJson());

class ShiftSlotsModel {
  int status;
  int errorCode;
  GetAllDoctors getAllDoctors;

  ShiftSlotsModel({
    required this.status,
    required this.errorCode,
    required this.getAllDoctors,
  });

  factory ShiftSlotsModel.fromJson(Map<String, dynamic> json) => ShiftSlotsModel(
    status: json["status"],
    errorCode: json["errorCode"],
    getAllDoctors: GetAllDoctors.fromJson(json["get_all_doctors"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "get_all_doctors": getAllDoctors.toJson(),
  };
}

class GetAllDoctors {
  List<FollowupSlot> followupSlots;

  GetAllDoctors({
    required this.followupSlots,
  });

  factory GetAllDoctors.fromJson(Map<String, dynamic> json) => GetAllDoctors(
    followupSlots: List<FollowupSlot>.from(json["followup_slots"].map((x) => FollowupSlot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "followup_slots": List<dynamic>.from(followupSlots.map((x) => x.toJson())),
  };
}

class FollowupSlot {
  String name;
  String email;
  String gender;
  int userId;
  int doctorId;
  int aptBookedCount;
  int userLeave;
  List<Slot> slots;

  FollowupSlot({
    required this.name,
    required this.email,
    required this.gender,
    required this.userId,
    required this.doctorId,
    required this.aptBookedCount,
    required this.userLeave,
    required this.slots,
  });

  factory FollowupSlot.fromJson(Map<String, dynamic> json) => FollowupSlot(
    name: json["name"],
    email: json["email"],
    gender: json["gender"],
    userId: json["user_id"],
    doctorId: json["doctor_id"],
    aptBookedCount: json["apt_booked_count"],
    userLeave: json["user_leave"],
    slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "gender": gender,
    "user_id": userId,
    "doctor_id": doctorId,
    "apt_booked_count": aptBookedCount,
    "user_leave": userLeave,
    "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
  };
}

class Slot {
  int isBooked;
  String slot;
  int isPriority;
  int isShow;
  int userId;
  int doctorId;

  Slot({
    required this.isBooked,
    required this.slot,
    required this.isPriority,
    required this.isShow,
    required this.userId,
    required this.doctorId,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    isBooked: json["is_booked"],
    slot: json["slot"],
    isPriority: json["is_priority"],
    isShow: json["is_show"],
    userId: json["user_id"],
    doctorId: json["doctor_id"],
  );

  Map<String, dynamic> toJson() => {
    "is_booked": isBooked,
    "slot": slot,
    "is_priority": isPriority,
    "is_show": isShow,
    "user_id": userId,
    "doctor_id": doctorId,
  };
}
