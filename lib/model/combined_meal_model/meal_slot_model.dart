class MealSlot {
  int? id;
  int? itemId;
  String? name;
  String? benefits;
  String? subtitle;
  String? itemPhoto;
  String? recipeUrl;
  String? howToStore;
  String? howToPrepare;
  List<Ingredient>? ingredient;
  List<Variation>? variation;
  List<Faq>? faq;
  String? cookingTime;

  MealSlot(
      {this.id,
        this.itemId,
        this.name,
        this.benefits,
        this.subtitle,
        this.itemPhoto,
        this.recipeUrl,
        this.howToStore,
        this.howToPrepare,
        this.ingredient,
        this.variation,
        this.faq,
        this.cookingTime
      });

  MealSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    name = json['name'];
    benefits = json['benefits'];
    subtitle = json['subtitle'];
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
    data['benefits'] = this.benefits;
    data['subtitle'] = this.subtitle;
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


class Ingredient {
  String? ingredientName;
  String? ingredientThumbnail;
  String? unit;
  String? qty;
  String? ingredientId;
  String? weightTypeId;

  Ingredient(
      {this.ingredientName,
        this.ingredientThumbnail,
        this.unit,
        this.qty,
        this.ingredientId,
        this.weightTypeId});

  Ingredient.fromJson(Map<String, dynamic> json) {
    ingredientName = json['ingredient_name'].toString();
    ingredientThumbnail = json['ingredient_thumbnail'].toString();
    unit = json['unit'].toString();
    qty = json['qty'].toString();
    ingredientId = json['ingredient_id'].toString();
    weightTypeId = json['weight_type_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ingredient_name'] = this.ingredientName;
    data['ingredient_thumbnail'] = this.ingredientThumbnail;
    data['unit'] = this.unit;
    data['qty'] = this.qty;
    data['ingredient_id'] = this.ingredientId;
    data['weight_type_id'] = this.weightTypeId;
    return data;
  }
}

class Variation {
  String? variationTitle;
  String? variationDescription;

  Variation({this.variationTitle, this.variationDescription});

  Variation.fromJson(Map<String, dynamic> json) {
    variationTitle = json['variation_title'].toString();
    variationDescription = json['variation_description'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variation_title'] = this.variationTitle;
    data['variation_description'] = this.variationDescription;
    return data;
  }
}

class Faq {
  String? faqQuestion;
  String? faqAnswer;

  Faq({this.faqQuestion, this.faqAnswer});

  Faq.fromJson(Map<String, dynamic> json) {
    faqQuestion = json['faq_question'].toString();
    faqAnswer = json['faq_answer'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['faq_question'] = this.faqQuestion;
    data['faq_answer'] = this.faqAnswer;
    return data;
  }
}