import 'child_meal_plan_details_model.dart';

class MealPlanDetailsModel {
  int? status;
  int? errorCode;
  String? programDay;
  String? comment;
  String? note;
  Map<String, List<ChildMealPlanDetailsModel>>? data;

  MealPlanDetailsModel(
      {this.status, this.note, this.errorCode, this.programDay, this.data, this.comment});

  MealPlanDetailsModel.fromJson(Map<String, dynamic> json) {
    print("json => ${json['data']} ");
    print("run==> ${json['data'].runtimeType}");
    status = json['status'];
    errorCode = json['errorCode'];
    programDay = json['program_day'].toString();
    comment = json['comment'] ?? '';
    note = json['note'] ?? '';
    data = Map.from(json["data"]).map((k, v) => MapEntry<String, List<ChildMealPlanDetailsModel>>(k, List<ChildMealPlanDetailsModel>.from(v.map((x) => ChildMealPlanDetailsModel.fromJson(x)))));

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['program_day'] = this.programDay;
    if (this.data != null) {
      data['data'] = Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson()))));
    }
    return data;
  }
}

