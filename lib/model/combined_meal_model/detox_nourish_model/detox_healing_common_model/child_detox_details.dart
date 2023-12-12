import 'detox_healing_model.dart';

class ChildDetoxHealDetailsModel{
  DetoxHealingModel? items;

  ChildDetoxHealDetailsModel({this.items});

  ChildDetoxHealDetailsModel.fromJson(Map<String, dynamic> map) {
    items = DetoxHealingModel.fromMap(map);

    // (map['details'] as Map).forEach((key, value) {
    //   // print("$key <==> ${(value as List).map((element) =>MealSlot.fromJson(element)) as List<MealSlot>}");
    //   // data!.putIfAbsent(key, () => List.from((value as List).map((element) => MealSlot.fromJson(element))));
    // });
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items!,
    };
  }

}