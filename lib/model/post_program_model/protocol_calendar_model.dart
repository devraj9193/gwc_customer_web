// To parse this JSON data, do
//
//     final protocolCalendarModel = protocolCalendarModelFromJson(jsonString);

import 'dart:convert';

ProtocolCalendarModel protocolCalendarModelFromJson(String str) =>
    ProtocolCalendarModel.fromJson(json.decode(str));

String protocolCalendarModelToJson(ProtocolCalendarModel data) =>
    json.encode(data.toJson());

class ProtocolCalendarModel {
  ProtocolCalendarModel({
    this.status,
    this.errorCode,
    this.key,
    this.protocolCalendar,
  });

  int? status;
  int? errorCode;
  String? key;
  List<ProtocolCalendar>? protocolCalendar;

  factory ProtocolCalendarModel.fromJson(Map<String, dynamic> json) =>
      ProtocolCalendarModel(
        status: json["status"],
        errorCode: json["errorCode"],
        key: json["key"],
        protocolCalendar: List<ProtocolCalendar>.from(
            json["protocol_calendar"].map((x) => ProtocolCalendar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "errorCode": errorCode,
        "key": key,
        "protocol_calendar":
            List<dynamic>.from(protocolCalendar!.map((x) => x.toJson())),
      };
}

class ProtocolCalendar {
  ProtocolCalendar({
    this.date,
    this.day,
    this.score,
    this.color,
    this.earlyMorning,
    this.breakfast,
    this.midDay,
    this.lunch,
    this.evening,
    this.dinner,
    this.postDinner,
  });

  DateTime? date;
  int? day;
  String? score;
  String? color;
  String? earlyMorning;
  String? breakfast;
  String? midDay;
  String? lunch;
  String? evening;
  String? dinner;
  String? postDinner;

  factory ProtocolCalendar.fromJson(Map<String, dynamic> json) =>
      ProtocolCalendar(
        date: DateTime.parse(json["date"]),
        day: json["day"],
        score: json["score"].toString(),
        color: json["color"],
        earlyMorning: json["early_morning"],
        breakfast: json["breakfast"],
        midDay: json["mid_day"],
        lunch: json["lunch"],
        evening: json["evening"],
        dinner: json["dinner"],
        postDinner: json["post_dinner"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "day": day,
        "score": score,
        "color": color,
        "early_morning": earlyMorning,
        "breakfast": breakfast,
        "mid_day": midDay,
        "lunch": lunch,
        "evening": evening,
        "dinner": dinner,
        "post_dinner": postDinner,
      };
}
