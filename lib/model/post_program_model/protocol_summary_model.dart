// To parse this JSON data, do
//
//     final protocolSummary = protocolSummaryFromJson(jsonString);

import 'dart:convert';

ProtocolSummary protocolSummaryFromJson(String str) => ProtocolSummary.fromJson(json.decode(str));

String protocolSummaryToJson(ProtocolSummary data) => json.encode(data.toJson());

class ProtocolSummary {
  ProtocolSummary({
    this.status,
    this.errorCode,
    this.key,
    this.score,
    this.summary,
  });

  int? status;
  int? errorCode;
  String? key;
  int? score;
  List<Summary>? summary;

  factory ProtocolSummary.fromJson(Map<String, dynamic> json) => ProtocolSummary(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    score: json["score"],
    summary: List<Summary>.from(json["summary"].map((x) => Summary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "score": score,
    "summary": List<dynamic>.from(summary!.map((x) => x.toJson())),
  };
}

class Summary {
  Summary({
    this.earlyMorning,
    this.breakfast,
    this.midDay,
    this.lunch,
    this.evening,
    this.dinner,
    this.postDinner,
  });

  String? earlyMorning;
  String? breakfast;
  String? midDay;
  String? lunch;
  String? evening;
  String? dinner;
  String? postDinner;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    earlyMorning: json["early_morning"],
    breakfast: json["breakfast"],
    midDay: json["mid_day"],
    lunch: json["lunch"],
    evening: json["evening"],
    dinner: json["dinner"],
    postDinner: json["post_dinner"],
  );

  Map<String, dynamic> toJson() => {
    "early_morning": earlyMorning,
    "breakfast": breakfast,
    "mid_day": midDay,
    "lunch": lunch,
    "evening": evening,
    "dinner": dinner,
    "post_dinner": postDinner,
  };
}
