import 'detox_nourish_model/child_nourish_model.dart';

class NewNourishModel {
  String? data;
  int? totalDays;
  String? mealNote;
  ChildNourishModel? value;

  NewNourishModel({this.data, this.mealNote, this.totalDays, this.value});

  NewNourishModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    totalDays = json['total_days'];
    mealNote = json['meal_note'];
    value = json['value'] != null ? new ChildNourishModel.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['meal_note'] = this.mealNote;
    data['total_days'] = this.totalDays;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}
