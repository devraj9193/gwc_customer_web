import 'child_meal_plan_details_model1.dart';

class DetoxHealingModel{
  String? programDay;
  String? comment;
  String? isDayCompleted;
  String? note;
  Map<String, List<ChildMealPlanDetailsModel1>>? data;

  DetoxHealingModel({this.programDay, this.comment, this.note, this.data, this.isDayCompleted});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data1 = new Map<String, dynamic>();
      data1['present_day'] =  this.programDay;
      data1['comment'] = this.comment;
      data1['note'] = this.note;
      data1['is_day_completed'] = this.isDayCompleted;
      print(data);
    if (this.data != null) {
      data1['data'] = Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson()))));
    }
    return data1;
  }

  DetoxHealingModel.fromMap(Map<String, dynamic> json) {
    programDay = json['present_day'].toString();
    comment = json['comment'];
    note = json['note'];
    isDayCompleted = json['is_day_completed'].toString();
    print(json['data']);
    data = Map.from(json["data"]).map((k, v) => MapEntry<String, List<ChildMealPlanDetailsModel1>>(k, List<ChildMealPlanDetailsModel1>.from(v.map((x) => ChildMealPlanDetailsModel1.fromJson(x)))));
    // print("fromMap: $data");
  }
}