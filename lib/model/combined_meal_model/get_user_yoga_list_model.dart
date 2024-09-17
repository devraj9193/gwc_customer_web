class GetUserYogaListModel {
  int? status;
  int? errorCode;
  String? key;
  List<YogaList>? data;

  GetUserYogaListModel({
    this.status,
    this.errorCode,
    this.key,
    this.data,
  });

  factory GetUserYogaListModel.fromJson(Map<String, dynamic> json) =>
      GetUserYogaListModel(
        status: json["status"],
        errorCode: json["errorCode"],
        key: json["key"],
        data:
            List<YogaList>.from(json["data"].map((x) => YogaList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "errorCode": errorCode,
        "key": key,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class YogaList {
  String? time;
  int? id;
  String? name;
  String url;
  String audioOnlyUrl;
  String videoOnlyUrl;

  YogaList({
    this.time,
    this.id,
    this.name,
    required this.url,
    required this.audioOnlyUrl,
    required this.videoOnlyUrl,
  });

  factory YogaList.fromJson(Map<String, dynamic> json) => YogaList(
        time: json["time"].toString(),
        id: json["id"],
        name: json["name"].toString(),
        url: json["url"] ?? '',
        audioOnlyUrl: json['audio_only_url'] ?? "",
        videoOnlyUrl: json['video_only_url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "id": id,
        "name": name,
        "url": url,
        'audio_only_url': audioOnlyUrl,
        "video_only_url": videoOnlyUrl,
      };
}
