import 'detox_nourish_model/child_nourish_model.dart';

class NewNourishModel {
  String? data;
  int? totalDays;
  ChildNourishModel? value;

  NewNourishModel({this.data, this.totalDays, this.value});

  NewNourishModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    totalDays = json['total_days'];
    value = json['value'] != null ? new ChildNourishModel.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['total_days'] = this.totalDays;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}
