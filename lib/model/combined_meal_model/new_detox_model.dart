import 'detox_nourish_model/child_detox_model.dart';

class NewDetoxModel {
  String? data;
  int? totalDays;
  ChildDetoxModel? value;
  /// isHealingStarted this is for showing clap sheet in detox screen
  bool? isHealingStarted;
  /// isNourishStarted this is for showing clap sheet in healing screen
  // bool? isNourishStarted;

  NewDetoxModel({this.data, this.totalDays, this.value});

  NewDetoxModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    totalDays = json['total_days'];
    value = json['value'] != null ? new ChildDetoxModel.fromJson(json['value']) : null;
    isHealingStarted = json['is_healing_started'] != null  ? json['is_healing_started'].toString() == "1" ? true : false : false;
    // isNourishStarted = json['is_nourish_started'] != null  ? json['is_nourish_started'].toString() == "1" ? true : false : false;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['total_days'] = this.totalDays;

    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    data['is_healing_started'] = this.isHealingStarted;
    // data['is_nourish_started'] = this.isNourishStarted;
    return data;
  }
}