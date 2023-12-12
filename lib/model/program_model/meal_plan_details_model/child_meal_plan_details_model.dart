import '../../combined_meal_model/meal_slot_model.dart';
import '../../prepratory_meal_model/prep_meal_model.dart';

class ChildMealPlanDetailsModel {
  String? type;
  String? mealTime;
  int? itemId;
  String? name;
  String? mealWeight;
  String? weightType;
  String? url;
  String? status;
  String? itemImage;
  String? subTitle;
  String? benefits;
  String? howToStore;
  String? howToPrepare;
  List<Ingredient>? ingredient;
  List<Variation>? variation;
  List<Faq>? faq;
  String? cookingTime;

  ChildMealPlanDetailsModel(
      {this.type,
        this.mealTime,
        this.itemId,
        this.name,
        this.mealWeight,
        this.weightType,
        this.url,
        this.status,
        this.subTitle,
        this.itemImage,
        this.benefits,
        this.howToStore,
        this.howToPrepare,
        this.ingredient,
        this.variation,
        this.faq,
        this.cookingTime,
      });

  ChildMealPlanDetailsModel.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    mealTime = json['meal_time'].toString() ?? '';
    itemId = json['item_id'] ?? '';
    name = json['name'].toString() ?? '';
    mealWeight = json['meal_weight'].toString() ?? '';
    weightType = json['weight_type'].toString() ?? '';
    url = json['url'].toString() ?? '';
    status = json['status'].toString() ?? '';
    subTitle = json['subtitle'] ?? '';
    itemImage = json['item_photo'].toString() ?? '';
    benefits = json['benefits'].toString() ?? '';
    howToStore = json['how_to_store'].toString();
    howToPrepare = json['how_to_prepare'].toString();
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
    cookingTime = json['cooking_time'].toString();
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['meal_time'] = this.mealTime;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['meal_weight'] = this.mealWeight;
    data['weight_type'] = this.weightType;
    data['url'] = this.url;
    data['status'] = this.status;
    data['subtitle'] = this.subTitle;
    data['item_photo'] = this.itemImage;
    data['benefits'] = this.benefits;
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
//
// class Ingredient {
//   String? ingredientName;
//   String? ingredientThumbnail;
//   String? unit;
//   String? qty;
//   String? ingredientId;
//   String? weightTypeId;
//
//   Ingredient(
//       {this.ingredientName,
//         this.ingredientThumbnail,
//         this.unit,
//         this.qty,
//         this.ingredientId,
//         this.weightTypeId});
//
//   Ingredient.fromJson(Map<String, dynamic> json) {
//     ingredientName = json['ingredient_name'];
//     ingredientThumbnail = json['ingredient_thumbnail'];
//     unit = json['unit'];
//     qty = json['qty'];
//     ingredientId = json['ingredient_id'];
//     weightTypeId = json['weight_type_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ingredient_name'] = this.ingredientName;
//     data['ingredient_thumbnail'] = this.ingredientThumbnail;
//     data['unit'] = this.unit;
//     data['qty'] = this.qty;
//     data['ingredient_id'] = this.ingredientId;
//     data['weight_type_id'] = this.weightTypeId;
//     return data;
//   }
// }
//
// class Variation {
//   String? variationTitle;
//   String? variationDescription;
//
//   Variation({this.variationTitle, this.variationDescription});
//
//   Variation.fromJson(Map<String, dynamic> json) {
//     variationTitle = json['variation_title'];
//     variationDescription = json['variation_description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['variation_title'] = this.variationTitle;
//     data['variation_description'] = this.variationDescription;
//     return data;
//   }
// }
//
// class Faq {
//   String? faqQuestion;
//   String? faqAnswer;
//
//   Faq({this.faqQuestion, this.faqAnswer});
//
//   Faq.fromJson(Map<String, dynamic> json) {
//     faqQuestion = json['faq_question'];
//     faqAnswer = json['faq_answer'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['faq_question'] = this.faqQuestion;
//     data['faq_answer'] = this.faqAnswer;
//     return data;
//   }
// }