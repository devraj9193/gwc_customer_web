class GetProgramModel {
  String? data;
  Value? value;

  GetProgramModel({this.data, this.value});

  GetProgramModel.fromJson(Map<String, dynamic> json) {
    print('json:=== $json  ${json['data'].runtimeType} ${json['value'].runtimeType}');
    data = json['data'].toString();
    value = (json['value'] != null ? new Value.fromJson(json['value']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}

class Value {
  int? id;
  String? userId;
  String? startVideoUrl;
  String? tracker_video_url;
  String? recipeVideo;
  String? programId;
  String? isActive;
  String? startProgram;
  String? healingStartProgram;
  String? mealCurrentDay;
  String? healingCurrentDay;
  String? isDetoxCompleted;
  String? isHealingCompleted;
  String? createdAt;
  String? updatedAt;
  Program? program;

  Value(
      {this.id,
        this.userId,
        this.startVideoUrl,
        this.tracker_video_url,
        this.recipeVideo,
        this.programId,
        this.isActive,
        this.startProgram,
        this.healingStartProgram,
        this.mealCurrentDay,
        this.healingCurrentDay,
        this.isDetoxCompleted,
        this.isHealingCompleted,
        this.createdAt,
        this.updatedAt,
        this.program});

  Value.fromJson(Map<String, dynamic> json) {
    print("value from json: $json");
    id = json['id'];
    userId = json['user_id'].toString();
    startVideoUrl = json['video'].toString();
    tracker_video_url = json['tracker_video'].toString();
    recipeVideo = json['recipe_video'].toString();
    programId = json['program_id'].toString();
    isActive = json['is_active'].toString();
    startProgram = json['detox_program'].toString();
    healingStartProgram = json['healing_program'].toString();
    mealCurrentDay = json['detox_present_day'].toString();
    healingCurrentDay = json['healing_present_day'].toString();
    isDetoxCompleted = (json['is_detox_completed'] != null) ? json['is_detox_completed'].toString() : "0";
    isHealingCompleted = (json['is_healing_completed'] != null) ? json['is_healing_completed'].toString() : "0";
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    program = json['detox_days'] != null ? new Program.fromJson(json['detox_days'])
        : json['healing_days'] != null
        ? new Program.fromJson(json['healing_days']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video'] = this.startVideoUrl;
    data['recipe_video'] = this.recipeVideo;
    data['tracker_video'] = this.tracker_video_url;
    data['program_id'] = this.programId;
    data['is_active'] = this.isActive;
    data['detox_program'] = this.startProgram;
    data['healing_program'] = this.healingStartProgram;
    data['sp_current_day'] = this.mealCurrentDay;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.program != null) {
      data['program'] = this.program!.toJson();
    }
    return data;
  }
}

class Program {
  int? id;
  String? issueId;
  String? programId;
  String? name;
  String? noOfDays;
  String? desc;
  String? price;
  String? profile;
  String? createdAt;
  String? updatedAt;

  Program(
      {this.id,
        this.issueId,
        this.programId,
        this.name,
        this.noOfDays,
        this.desc,
        this.price,
        this.profile,
        this.createdAt,
        this.updatedAt});

  Program.fromJson(Map<String, dynamic> json) {
    print("program from json: $json");
    id = json['id'];
    issueId = json['issue_id'].toString();
    programId = json['program_id'].toString();
    name = json['name'].toString();
    noOfDays = json['no_of_days'].toString();
    desc = json['desc'].toString();
    price = json['price'].toString();
    profile = json['profile'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['issue_id'] = this.issueId;
    data['program_id'] = this.programId;
    data['name'] = this.name;
    data['no_of_days'] = this.noOfDays;
    data['desc'] = this.desc;
    data['price'] = this.price;
    data['profile'] = this.profile;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}