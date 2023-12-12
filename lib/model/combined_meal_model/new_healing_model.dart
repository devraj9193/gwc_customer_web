import 'detox_nourish_model/child_detox_model.dart';

class NewHealingModel {
  String? data;
  int? totalDays;
  ChildDetoxModel? value;
  /// isHealingStarted this is for showing clap sheet in detox screen
  // bool? isHealingStarted;
  /// isNourishStarted this is for showing clap sheet in healing screen
  bool? isNourishStarted;

  NewHealingModel({this.data, this.totalDays, this.value});

  NewHealingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    totalDays = json['total_days'];
    value = json['value'] != null ? new ChildDetoxModel.fromJson(json['value']) : null;
    // isHealingStarted = json['is_healing_started'] != null  ? json['is_healing_started'].toString() == "1" ? true : false : false;
    isNourishStarted = json['is_nourish_started'] != null  ? json['is_nourish_started'].toString() == "1" ? true : false : false;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['total_days'] = this.totalDays;
    // data['is_healing_started'] = this.isHealingStarted;
    data['is_nourish_started'] = this.isNourishStarted;

    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}