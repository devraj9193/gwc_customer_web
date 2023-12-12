// To parse this JSON data, do
//
//     final homeRemediesModel = homeRemediesModelFromJson(jsonString);

import 'dart:convert';

HomeRemediesModel homeRemediesModelFromJson(String str) => HomeRemediesModel.fromJson(json.decode(str));

String homeRemediesModelToJson(HomeRemediesModel data) => json.encode(data.toJson());

class HomeRemediesModel {
  HomeRemediesModel({
    required this.status,
    required this.errorCode,
    required this.key,
    required this.data,
  });

  int status;
  int errorCode;
  String key;
  Data data;

  factory HomeRemediesModel.fromJson(Map<String, dynamic> json) => HomeRemediesModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.homeRemedies,
  });

  List<HomeRemedy> homeRemedies;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    homeRemedies: List<HomeRemedy>.from(json["home_remedies"].map((x) => HomeRemedy.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "home_remedies": List<dynamic>.from(homeRemedies.map((x) => x.toJson())),
  };
}

class HomeRemedy {
  HomeRemedy({
    required this.name,
    required this.thumbnail,
    required this.isGeneral,
    required this.knowMore,
    required this.healAtHome,
    required this.healAnywhere,
    required this.whenToReachUs,
  });

  String name;
  String thumbnail;
  String isGeneral;
  String knowMore;
  String healAtHome;
  String healAnywhere;
  String whenToReachUs;

  factory HomeRemedy.fromJson(Map<String, dynamic> json) => HomeRemedy(
    name: json["name"],
    thumbnail: json["thumbnail"],
    isGeneral: json["is_general"].toString(),
    knowMore: json["know_more"],
    healAtHome: json["heal_at_home"],
    healAnywhere: json["heal_anywhere"],
    whenToReachUs: json["when_to_reach_us"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "thumbnail": thumbnail,
    "is_general": isGeneral,
    "know_more": knowMore,
    "heal_at_home": healAtHome,
    "heal_anywhere": healAnywhere,
    "when_to_reach_us": whenToReachUs,
  };
}
