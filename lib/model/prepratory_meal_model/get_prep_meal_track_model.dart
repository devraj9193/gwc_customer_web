
import 'dart:convert';

class GetPreparatoryMealTrackModel {
  GetPreparatoryMealTrackModel({
    required this.status,
    required this.errorCode,
    required this.key,
    this.trackingPrepMeals,
  });

  int status;
  int errorCode;
  String key;
  TrackingPrepMeals? trackingPrepMeals;

  factory GetPreparatoryMealTrackModel.fromJson(Map<String, dynamic> json) => GetPreparatoryMealTrackModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    trackingPrepMeals: (json["tracking_prep_meals"] != null) ? TrackingPrepMeals.fromJson(json["tracking_prep_meals"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "tracking_prep_meals": trackingPrepMeals!.toJson(),
  };
}

class TrackingPrepMeals {
  TrackingPrepMeals({
    required this.id,
    required this.userId,
    required this.teamPatientId,
    required this.hungerImproved,
    required this.appetiteImproved,
    required this.feelingLight,
    required this.feelingEnergetic,
    required this.mildReduction,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  String teamPatientId;
  String hungerImproved;
  String appetiteImproved;
  String feelingLight;
  String feelingEnergetic;
  String mildReduction;
  DateTime createdAt;
  DateTime updatedAt;

  factory TrackingPrepMeals.fromJson(Map<String, dynamic> json) => TrackingPrepMeals(
    id: json["id"],
    userId: json["user_id"],
    teamPatientId: json["team_patient_id"],
    hungerImproved: json["hunger_improved"],
    appetiteImproved: json["appetite_improved"],
    feelingLight: json["feeling_light"],
    feelingEnergetic: json["feeling_energetic"],
    mildReduction: json["mild_reduction"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "team_patient_id": teamPatientId,
    "hunger_improved": hungerImproved,
    "appetite_improved": appetiteImproved,
    "feeling_light": feelingLight,
    "feeling_energetic": feelingEnergetic,
    "mild_reduction": mildReduction,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
