import 'package:gwc_customer_web/model/prepratory_meal_model/prep_meal_model.dart';

import '../meal_slot_model.dart';

class ChildNourishModel {
  String? note;
  String? totalDays;
  String? currentDay;
  String? currentDayStatus;
  String? previousDayStatus;
  /// 0/1
  String? isNourishCompleted;
  String? isPostProgramStarted;
  String? dosDontPdfLink;
  Map<String, SubItems>? data;

  // Map<String, List<TransMealSlot>>? data;

  ChildNourishModel({this.totalDays, this.isNourishCompleted, this.isPostProgramStarted, this.currentDay, this.data, this.currentDayStatus, this.previousDayStatus});

  ChildNourishModel.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    totalDays = json['days'].toString();
    currentDayStatus =json['current_day_status'].toString();
    previousDayStatus = json['previous_day_status'].toString();
    dosDontPdfLink = json['do_dont'];

    isPostProgramStarted = json['is_post_program_started'].toString();


    // data = json['data'] != null ? Data.fromJson(json['data']) : null;
    // if(json['data'] != null){
    //   data = {};
    //   (json['data'] as Map).forEach((key, value) {
    //     // print("$key <==> ${(value as List).map((element) =>MealSlot.fromJson(element)) as List<MealSlot>}");
    //     data!.putIfAbsent(key, () => List.from((value as List).map((element) => TransMealSlot.fromJson(element))));
    //   });
    // }

    currentDay = json['current_day'].toString();
    isNourishCompleted = json['is_nourish_completed'].toString();

    if(json['details'] != null){
      data = {};
      (json['details'] as Map).forEach((key, value) {
        // print("$key <==> ${(value as List).map((element) =>MealSlot.fromJson(element)) as List<MealSlot>}");
        // data!.putIfAbsent(key, () => List.from((value as List).map((element) => MealSlot.fromJson(element))));
        data!.addAll({key: SubItems.fromJson(value)});
      });

      data!.forEach((key, value) {
        print("$key -- $value");
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['note'] = this.note;
    data['days'] = this.totalDays;
    data['current_day'] = this.currentDay;
    data['previous_day_status'] = this.previousDayStatus;
    data['current_day_status'] = this.currentDayStatus;
    data['do_dont'] = this.dosDontPdfLink;
    data['is_nourish_completed'] = this.isNourishCompleted;
    data['is_post_program_started'] = this.isPostProgramStarted;

    if (this.data != null) {
      data['details'] = this.data!;
    }
    return data;
  }
}

class TransSubItems{
  // [object]
  Map<String, List<MealSlot>>? subItems;

  TransSubItems({
    this.subItems
  });

  TransSubItems.fromJson(Map<String, dynamic> json) {
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


