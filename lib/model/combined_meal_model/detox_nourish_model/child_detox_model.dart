import 'detox_healing_common_model/child_detox_details.dart';
import 'detox_healing_common_model/detox_healing_model.dart';

class ChildDetoxModel {
  String? isDetoxCompleted;
  String? isHealingCompleted;
  String? currentDay;
  Map<String, DetoxHealingModel>? details;

  ChildDetoxModel({this.isDetoxCompleted, this.isHealingCompleted, this.currentDay, this.details});

  ChildDetoxModel.fromJson(Map<String, dynamic> json) {
    isDetoxCompleted = json['is_detox_completed'].toString();
    isHealingCompleted = json['is_healing_completed'].toString();



    currentDay = json['current_day'].toString();

    if(json['details'] != null){
      details = {};
      /*
      "1": {
                    "program_day": 1,
                    "comment": "",
                    "data": {},
                    "note": "https://gutandhealth.com/storage/uploads/mp_note.pdf"
                },
       */
      (json['details'] as Map).forEach((key, value) {
        // print("$key <==> ${(value as List).map((element) =>MealSlot.fromJson(element)) as List<MealSlot>}");
        // data!.putIfAbsent(key, () => List.from((value as List).map((element) => MealSlot.fromJson(element))));

        details!.addAll({key: DetoxHealingModel.fromMap(value)});
        // print(details);
        // details!.forEach((key, value) {
        //   print(value.toMap());
        // });
        // print("lsnjdj");
        // print(DetoxHealingModel.fromMap(value));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_detox_completed'] = this.isDetoxCompleted;
    data['is_healing_completed'] = this.isHealingCompleted;


    data['current_day'] = this.currentDay;
    if (details != null) {
      data['details'] = details!;
    }
    return data;
  }
}
