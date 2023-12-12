
import '../combined_meal_model/meal_slot_model.dart';

class TransitionMealModel {
  int? status;
  int? errorCode;
  String? key;
  String? note;
  String? totalDays;
  String? currentDay;
  String? currentDayStatus;
  String? previousDayStatus;
  String? isTransMealCompleted;
  String? dosDontPdfLink;
  Map<String, TransSubItems>? data;

  // Map<String, List<TransMealSlot>>? data;

  TransitionMealModel({this.status, this.note, this.errorCode,this.totalDays, this.isTransMealCompleted, this.key, this.currentDay, this.data, this.currentDayStatus, this.previousDayStatus});

  TransitionMealModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    note = json['note'];
    totalDays = json['days'].toString();
    currentDay = json['current_day'].toString();
    currentDayStatus =json['current_day_status'].toString();
    previousDayStatus = json['previous_day_status'].toString();
    isTransMealCompleted = json['is_trans_completed'];
    dosDontPdfLink = json['do_dont'];

    // data = json['data'] != null ? Data.fromJson(json['data']) : null;
    // if(json['data'] != null){
    //   data = {};
    //   (json['data'] as Map).forEach((key, value) {
    //     // print("$key <==> ${(value as List).map((element) =>MealSlot.fromJson(element)) as List<MealSlot>}");
    //     data!.putIfAbsent(key, () => List.from((value as List).map((element) => TransMealSlot.fromJson(element))));
    //   });
    // }

    if(json['data'] != null){
      data = {};
      (json['data'] as Map).forEach((key, value) {
        // print("$key <==> ${(value as List).map((element) =>MealSlot.fromJson(element)) as List<MealSlot>}");
        // data!.putIfAbsent(key, () => List.from((value as List).map((element) => MealSlot.fromJson(element))));
        data!.addAll({key: TransSubItems.fromJson(value)});
      });

      data!.forEach((key, value) {
        print("$key -- $value");
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['note'] = this.note;
    data['days'] = this.totalDays;
    data['current_day'] = this.currentDay;
    data['previous_day_status'] = this.previousDayStatus;
    data['current_day_status'] = this.currentDayStatus;
    data['do_dont'] = this.dosDontPdfLink;
    if (this.data != null) {
      data['data'] = this.data!;
    }
    return data;
  }
}

class TransSubItems{
  // [object]
  Map<String, List<TransMealSlot>>? subItems;

  TransSubItems({
    this.subItems
  });

  TransSubItems.fromJson(Map<String, dynamic> json) {
    if(json != null && json.isNotEmpty){
      subItems = {};
      json.forEach((key, value) {
        subItems!.putIfAbsent(key, () => List.from(value).map((element) => TransMealSlot.fromJson(element)).toList());
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


class TransMealSlot {
  int? id;
  int? itemId;
  String? name;
  String? subTitle;
  String? benefits;
  String? itemPhoto;
  String? recipeUrl;
  String? howToStore;
  String? howToPrepare;
  List<Ingredient>? ingredient;
  List<Variation>? variation;
  List<Faq>? faq;
  String? cookingTime;

  TransMealSlot(
      {this.id,
      this.itemId,
      this.name,
        this.subTitle,
      this.benefits,
      this.itemPhoto,
      this.recipeUrl,
        this.howToStore,
        this.howToPrepare,
        this.ingredient,
        this.variation,
        this.faq,
        this.cookingTime
      });

  TransMealSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    name = json['name'];
    subTitle = json['subtitle'];
    benefits = json['benefits'];
    itemPhoto = json['item_photo'];
    recipeUrl = json['recipe_url'];
    howToStore = json['how_to_store'];
    howToPrepare = json['how_to_prepare'];
    if (json['ingredient'] != null) {
      ingredient = <Ingredient>[];
      json['ingredient'].forEach((v) {
        ingredient!.add(new Ingredient.fromJson(v));
      });
    }
    if (json['variation'] != null) {
      variation = <Variation>[];
      json['variation'].forEach((v) {
        variation!.add(new Variation.fromJson(v));
      });
    }
    if (json['faq'] != null) {
      faq = <Faq>[];
      json['faq'].forEach((v) {
        faq!.add(new Faq.fromJson(v));
      });
    }
    cookingTime = json['cooking_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['subtitle'] = this.subTitle;
    data['benefits'] = this.benefits;
    data['item_photo'] = this.itemPhoto;
    data['recipe_url'] = this.recipeUrl;
    data['how_to_store'] = this.howToStore;
    data['how_to_prepare'] = this.howToPrepare;
    if (this.ingredient != null) {
      data['ingredient'] = this.ingredient!.map((v) => v.toJson()).toList();
    }
    if (this.variation != null) {
      data['variation'] = this.variation!.map((v) => v.toJson()).toList();
    }
    if (this.faq != null) {
      data['faq'] = this.faq!.map((v) => v.toJson()).toList();
    }
    data['cooking_time'] = this.cookingTime;

    return data;
  }
}
