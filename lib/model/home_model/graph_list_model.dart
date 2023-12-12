// To parse this JSON data, do
//
//     final graphListModel = graphListModelFromJson(jsonString);

import 'dart:convert';

GraphListModel graphListModelFromJson(String str) =>
    GraphListModel.fromJson(json.decode(str));

String graphListModelToJson(GraphListModel data) => json.encode(data.toJson());

class GraphListModel {
  int? status;
  int? errorCode;
  ProgramDays? programDays;
  List<double>? detoxDayWiseProgress;
  List<double>? healingDayWiseProgress;

  GraphListModel({
    this.status,
    this.errorCode,
    this.programDays,
    this.detoxDayWiseProgress,
    this.healingDayWiseProgress,
  });

  factory GraphListModel.fromJson(Map<String, dynamic> json) => GraphListModel(
        status: json["status"],
        errorCode: json["errorCode"],
        programDays: ProgramDays.fromJson(json["program_days"]),
        detoxDayWiseProgress: List<double>.from(
            json["detox_day_wise_progress"].map((x) => x?.toDouble())),
        healingDayWiseProgress: List<double>.from(
            json["healing_day_wise_progress"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "errorCode": errorCode,
        "program_days": programDays?.toJson(),
        "detox_day_wise_progress":
            List<dynamic>.from(detoxDayWiseProgress!.map((x) => x)),
        "healing_day_wise_progress":
            List<dynamic>.from(healingDayWiseProgress!.map((x) => x)),
      };
}

class ProgramDays {
  int? id;
  int? userId;
  int? programId;
  int? detoxDaysId;
  int? healingDaysId;
  int? preparatoryProgram;
  String? preparatoryStartedDate;
  int? preparatoryTotalDays;
  int? preparatoryPresentDay;
  int? isPreparatoryCompleted;
  int? detoxProgram;
  String? detoxStartedDate;
  int? detoxTotalDays;
  int? detoxPresentDay;
  String? detoxCompletedDay;
  int? isDetoxCompleted;
  int? healingProgram;
  String? healingStartedDate;
  int? healingTotalDays;
  int? healingPresentDay;
  int? healingCompletedDay;
  int? isHealingCompleted;
  int? nourishProgram;
  String? nourishStartedDate;
  int? nourishTotalDays;
  int? nourishPresentDay;
  int? isNourishCompleted;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  Days? detoxDays;
  Days? healingDays;

  ProgramDays({
    this.id,
    this.userId,
    this.programId,
    this.detoxDaysId,
    this.healingDaysId,
    this.preparatoryProgram,
    this.preparatoryStartedDate,
    this.preparatoryTotalDays,
    this.preparatoryPresentDay,
    this.isPreparatoryCompleted,
    this.detoxProgram,
    this.detoxStartedDate,
    this.detoxTotalDays,
    this.detoxPresentDay,
    this.detoxCompletedDay,
    this.isDetoxCompleted,
    this.healingProgram,
    this.healingStartedDate,
    this.healingTotalDays,
    this.healingPresentDay,
    this.healingCompletedDay,
    this.isHealingCompleted,
    this.nourishProgram,
    this.nourishStartedDate,
    this.nourishTotalDays,
    this.nourishPresentDay,
    this.isNourishCompleted,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.detoxDays,
    this.healingDays,
  });

  factory ProgramDays.fromJson(Map<String, dynamic> json) => ProgramDays(
        id: json["id"],
        userId: json["user_id"],
        programId: json["program_id"],
        detoxDaysId: json["detox_days_id"],
        healingDaysId: json["healing_days_id"],
        preparatoryProgram: json["preparatory_program"],
        preparatoryStartedDate: json["preparatory_started_date"],
        preparatoryTotalDays: json["preparatory_total_days"],
        preparatoryPresentDay: json["preparatory_present_day"],
        isPreparatoryCompleted: json["is_preparatory_completed"],
        detoxProgram: json["detox_program"],
        detoxStartedDate: json["detox_started_date"],
        detoxTotalDays: json["detox_total_days"],
        detoxPresentDay: json["detox_present_day"],
        detoxCompletedDay: (json["detox_completed_day"] == null) ? '-1' : json["detox_completed_day"].toString(),
        isDetoxCompleted: json["is_detox_completed"],
        healingProgram: json["healing_program"],
        healingStartedDate: json["healing_started_date"],
        healingTotalDays: json["healing_total_days"],
        healingPresentDay: json["healing_present_day"],
        healingCompletedDay: json["healing_completed_day"],
        isHealingCompleted: json["is_healing_completed"],
        nourishProgram: json["nourish_program"],
        nourishStartedDate: json["nourish_started_date"],
        nourishTotalDays: json["nourish_total_days"],
        nourishPresentDay: json["nourish_present_day"],
        isNourishCompleted: json["is_nourish_completed"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        detoxDays: Days.fromJson(json["detox_days"]),
        healingDays: Days.fromJson(json["healing_days"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "program_id": programId,
        "detox_days_id": detoxDaysId,
        "healing_days_id": healingDaysId,
        "preparatory_program": preparatoryProgram,
        "preparatory_started_date": preparatoryStartedDate,
        "preparatory_total_days": preparatoryTotalDays,
        "preparatory_present_day": preparatoryPresentDay,
        "is_preparatory_completed": isPreparatoryCompleted,
        "detox_program": detoxProgram,
        "detox_started_date": detoxStartedDate,
        "detox_total_days": detoxTotalDays,
        "detox_present_day": detoxPresentDay,
        "detox_completed_day": detoxCompletedDay,
        "is_detox_completed": isDetoxCompleted,
        "healing_program": healingProgram,
        "healing_started_date": healingStartedDate,
        "healing_total_days": healingTotalDays,
        "healing_present_day": healingPresentDay,
        "healing_completed_day": healingCompletedDay,
        "is_healing_completed": isHealingCompleted,
        "nourish_program": nourishProgram,
        "nourish_started_date": nourishStartedDate,
        "nourish_total_days": nourishTotalDays,
        "nourish_present_day": nourishPresentDay,
        "is_nourish_completed": isNourishCompleted,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "detox_days": detoxDays?.toJson(),
        "healing_days": healingDays?.toJson(),
      };
}

class Days {
  int? id;
  int? programId;
  int? noOfDays;
  dynamic createdAt;
  dynamic updatedAt;

  Days({
    this.id,
    this.programId,
    this.noOfDays,
    this.createdAt,
    this.updatedAt,
  });

  factory Days.fromJson(Map<String, dynamic> json) => Days(
        id: json["id"],
        programId: json["program_id"],
        noOfDays: json["no_of_days"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "program_id": programId,
        "no_of_days": noOfDays,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
