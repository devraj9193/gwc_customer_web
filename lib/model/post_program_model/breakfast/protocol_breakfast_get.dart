import 'child_breakfast.dart';

class GetProtocolBreakfastModel {
  GetProtocolBreakfastModel({
    this.status,
    this.errorCode,
    this.key,
    this.day,
    this.time,
    this.data,
    this.history,
  });

  int? status;
  int? errorCode;
  String? key;
  String? day;
  String? time;
  Data? data;
  List<History>? history;

  factory GetProtocolBreakfastModel.fromJson(Map<String, dynamic> json) => GetProtocolBreakfastModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    day: json["day"],
    time: json["time"],
    data: Data.fromJson(json["data"]),
    history: List<History>.from(json["history"].map((x) => History.fromjson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "day": day,
    "time": time,
    "data": data?.toJson(),
    "history": history!.map((e) => e.toJson()).toList(),
  };
}

class History{
  String? day;
  String? totalScore;
  String? lottieReaction;

  History({this.day, this.totalScore, this.lottieReaction});

  History.fromjson(Map map){
    day = map['day'];
    totalScore = map['total_score'];
    if(totalScore == '1'){
      lottieReaction = 'assets/lottie/sad_look.json';
    }
    else if(totalScore == '2'){
      lottieReaction = 'assets/lottie/sad_face.json';
    }
    else if(totalScore == '3'){
      lottieReaction = 'assets/lottie/happy_face.json';
    }
    else{
      lottieReaction = 'assets/lottie/sad_look.json';
    }
  }

  Map<String, dynamic> toJson() => {
    "day":day,
    "total_score": totalScore,
  };
}

