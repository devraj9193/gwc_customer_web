import 'meal_slot_model.dart';

class NewPrepModel {
  String? data;
  int? totalDays;
  String? mealNote;
  ChildPrepModel? childPrepModel;

  NewPrepModel({this.data, this.mealNote, this.totalDays, this.childPrepModel});

  NewPrepModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    totalDays = json['total_days'];
    mealNote = json['meal_note'].toString();
    childPrepModel = json['value'] != null ? new ChildPrepModel.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['total_days'] = this.totalDays;
    data['meal_note'] = this.mealNote;
    if (this.childPrepModel != null) {
      data['value'] = this.childPrepModel!.toJson();
    }
    return data;
  }
}


class ChildPrepModel {
  String? isPrepCompleted;
  int? currentDay;
  Map<String, SubItems>? details;
  String? doDontPdfLink;

  ChildPrepModel({this.isPrepCompleted, this.currentDay,
    this.details, this.doDontPdfLink});

  ChildPrepModel.fromJson(Map<String, dynamic> json) {
    isPrepCompleted = json['is_prep_completed'].toString();
    currentDay = json['current_day'];
    doDontPdfLink = json['do_dont'];

    if(json['details'] != null){
      details = {};
      (json['details'] as Map).forEach((key, value) {
        // print("$key <==> ${(value as List).map((element) =>MealSlot.fromJson(element)) as List<MealSlot>}");
        // data!.putIfAbsent(key, () => List.from((value as List).map((element) => MealSlot.fromJson(element))));
        details!.addAll({key: SubItems.fromJson(value)});
      });

      details!.forEach((key, value) {
        print("$key -- $value");
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_prep_completed'] = this.isPrepCompleted;
    data['current_day'] = this.currentDay;
    data['do_dont'] = this.doDontPdfLink;

    if (details != null) {
      data['details'] = details!;
    }
    return data;
  }
}

class SubItems{
  // [object]
  Map<String, List<MealSlot>>? subItems;

  SubItems({
    this.subItems
  });

  SubItems.fromJson(Map<String, dynamic> json) {
    if(json != null && json.isNotEmpty){
      subItems = {};
      json.forEach((key, value) {
        subItems!.putIfAbsent(key, () => List.from(value).map((element) => MealSlot.fromJson(element)).toList());
      });
    }
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['variation_title'] = this.variationTitle;
//   data['variation_description'] = this.variationDescription;
//   return data;
// }
}




