import '../combined_meal_model/meal_slot_model.dart';

class PrepratoryMealModel {
  int? status;
  int? errorCode;
  String? key;
  String? days;
  String? currentDay;
  String? isPrepCompleted;
  String? note;
  String? dosDontPdfLink;
  // early morning <=> Object
  Map<String, SubItems>? data;

  PrepratoryMealModel({this.status, this.note, this.currentDay, this.errorCode, this.key, this.data, this.isPrepCompleted, this.days, this.dosDontPdfLink});

  PrepratoryMealModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    currentDay = json['current_day'].toString();
    isPrepCompleted = json['is_prep_completed'];
    note = json['note'];
    dosDontPdfLink = json['do_dont'];
    days = json['days'].toString();

    if(json['data'] != null){
      data = {};
      (json['data'] as Map).forEach((key, value) {
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
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['current_day'] = this.currentDay;
    data['is_prep_completed'] = this.isPrepCompleted;
    data['days'] = this.days;
    data['note'] = this.note;
    data['do_dont'] = this.dosDontPdfLink;
    if (this.data != null) {
      data['data'] = this.data!;
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


// class MealSlot {
//   int? id;
//   int? itemId;
//   String? name;
//   String? benefits;
//   String? subtitle;
//   String? itemPhoto;
//   String? recipeUrl;
//   String? howToStore;
//   String? howToPrepare;
//   List<Ingredient>? ingredient;
//   List<Variation>? variation;
//   List<Faq>? faq;
//   String? cookingTime;
//
//   MealSlot(
//       {this.id,
//         this.itemId,
//         this.name,
//         this.benefits,
//         this.subtitle,
//         this.itemPhoto,
//         this.recipeUrl,
//         this.howToStore,
//         this.howToPrepare,
//         this.ingredient,
//         this.variation,
//         this.faq,
//         this.cookingTime
//       });
//
//   MealSlot.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     itemId = json['item_id'];
//     name = json['name'];
//     benefits = json['benefits'];
//     subtitle = json['subtitle'];
//     itemPhoto = json['item_photo'];
//     recipeUrl = json['recipe_url'];
//     howToStore = json['how_to_store'];
//     howToPrepare = json['how_to_prepare'];
//     if (json['ingredient'] != null) {
//       ingredient = <Ingredient>[];
//       json['ingredient'].forEach((v) {
//         ingredient!.add(new Ingredient.fromJson(v));
//       });
//     }
//     if (json['variation'] != null) {
//       variation = <Variation>[];
//       json['variation'].forEach((v) {
//         variation!.add(new Variation.fromJson(v));
//       });
//     }
//     if (json['faq'] != null) {
//       faq = <Faq>[];
//       json['faq'].forEach((v) {
//         faq!.add(new Faq.fromJson(v));
//       });
//     }
//     cookingTime = json['cooking_time'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['item_id'] = this.itemId;
//     data['name'] = this.name;
//     data['benefits'] = this.benefits;
//     data['subtitle'] = this.subtitle;
//     data['item_photo'] = this.itemPhoto;
//     data['recipe_url'] = this.recipeUrl;
//     data['how_to_store'] = this.howToStore;
//     data['how_to_prepare'] = this.howToPrepare;
//     if (this.ingredient != null) {
//       data['ingredient'] = this.ingredient!.map((v) => v.toJson()).toList();
//     }
//     if (this.variation != null) {
//       data['variation'] = this.variation!.map((v) => v.toJson()).toList();
//     }
//     if (this.faq != null) {
//       data['faq'] = this.faq!.map((v) => v.toJson()).toList();
//     }
//     data['cooking_time'] = this.cookingTime;
//     return data;
//   }
// }

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
//     ingredientName = json['ingredient_name'].toString();
//     ingredientThumbnail = json['ingredient_thumbnail'].toString();
//     unit = json['unit'].toString();
//     qty = json['qty'].toString();
//     ingredientId = json['ingredient_id'].toString();
//     weightTypeId = json['weight_type_id'].toString();
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
//     variationTitle = json['variation_title'].toString();
//     variationDescription = json['variation_description'].toString();
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
//     faqQuestion = json['faq_question'].toString();
//     faqAnswer = json['faq_answer'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['faq_question'] = this.faqQuestion;
//     data['faq_answer'] = this.faqAnswer;
//     return data;
//   }
// }

