
class WaterLevelTimeModel {
  String time;

  WaterLevelTimeModel({
    required this.time,
  });

  factory WaterLevelTimeModel.fromJson(Map<String, dynamic> json) => WaterLevelTimeModel(
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
  };
}