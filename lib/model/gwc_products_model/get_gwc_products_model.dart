class GetGwcProductsModel {
  int? status;
  int? errorCode;
  String? key;
  Map<String, List<GwcProducts>> data;

  GetGwcProductsModel({
    this.status,
    this.errorCode,
    this.key,
    required this.data,
  });

  factory GetGwcProductsModel.fromJson(Map<String, dynamic> json) =>
      GetGwcProductsModel(
        status: json["status"],
        errorCode: json["errorCode"],
        key: json["key"].toString(),
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<GwcProducts>>(k,
                List<GwcProducts>.from(v.map((x) => GwcProducts.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "errorCode": errorCode,
        "key": key,
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}

class GwcProducts {
  int? id;
  int? masterMealId;
  String? mealId;
  String? name;
  String? mealTypeName;
  String? categoryId;
  String? mealCategoryId;
  String? weight;
  String? weightTypeId;
  String? minQty;
  String? maxWeight;
  String? maxQtyUnit;
  String? mealType;
  String? isJain;
  String? price;
  String? orderQty;
  String? orderServings;
  String? isOrderArchieved;
  String? itemPhoto;
  String? recipeVideoUrl;
  String? ingredient;
  String? variation;
  String? benefits;
  String? faq;
  String? howToStore;
  String? howToPrepare;
  String? cookingTime;
  String? subtitle;
  String? recipeId;
  String? mealTimingId;
  String? addedBy;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  Category? category;

  GwcProducts({
    this.id,
    this.masterMealId,
    this.mealId,
    this.name,
    this.mealTypeName,
    this.categoryId,
    this.mealCategoryId,
    this.weight,
    this.weightTypeId,
    this.minQty,
    this.maxWeight,
    this.maxQtyUnit,
    this.mealType,
    this.isJain,
    this.price,
    this.orderQty,
    this.orderServings,
    this.isOrderArchieved,
    this.itemPhoto,
    this.recipeVideoUrl,
    this.ingredient,
    this.variation,
    this.benefits,
    this.faq,
    this.howToStore,
    this.howToPrepare,
    this.cookingTime,
    this.subtitle,
    this.recipeId,
    this.mealTimingId,
    this.addedBy,
    this.isArchieved,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory GwcProducts.fromJson(Map<String, dynamic> json) => GwcProducts(
        id: json["id"],
        masterMealId: json["master_meal_id"],
        mealId: json["meal_Id"].toString(),
        name: json["name"].toString(),
        mealTypeName: json["meal_type_name"].toString(),
        categoryId: json["category_id"].toString(),
        mealCategoryId: json["meal_category_id"].toString(),
        weight: json["weight"].toString(),
        weightTypeId: json["weight_type_id"].toString(),
        minQty: json["min_qty"].toString(),
        maxWeight: json["max_weight"].toString(),
        maxQtyUnit: json["max_qty_unit"].toString(),
        mealType: json["meal_type"].toString(),
        isJain: json["is_jain"].toString(),
        price: json["price"].toString(),
        orderQty: json["order_qty"].toString(),
        orderServings: json["order_servings"].toString(),
        isOrderArchieved: json["is_order_archieved"].toString(),
        itemPhoto: json["item_photo"].toString(),
        recipeVideoUrl: json["recipe_video_url"].toString(),
        ingredient: json["ingredient"].toString(),
        variation: json["variation"].toString(),
        benefits: json["benefits"].toString(),
        faq: json["faq"].toString(),
        howToStore: json["how_to_store"].toString(),
        howToPrepare: json["how_to_prepare"].toString(),
        cookingTime: json["cooking_time"].toString(),
        subtitle: json["subtitle"].toString(),
        recipeId: json["recipe_id"].toString(),
        mealTimingId: json["meal_timing_id"].toString(),
        addedBy: json["added_by"].toString(),
        isArchieved: json["is_archieved"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "master_meal_id": masterMealId,
        "meal_Id": mealId,
        "name": name,
        "meal_type_name": mealTypeName,
        "category_id": categoryId,
        "meal_category_id": mealCategoryId,
        "weight": weight,
        "weight_type_id": weightTypeId,
        "min_qty": minQty,
        "max_weight": maxWeight,
        "max_qty_unit": maxQtyUnit,
        "meal_type": mealType,
        "is_jain": isJain,
        "price": price,
        "order_qty": orderQty,
        "order_servings": orderServings,
        "is_order_archieved": isOrderArchieved,
        "item_photo": itemPhoto,
        "recipe_video_url": recipeVideoUrl,
        "ingredient": ingredient,
        "variation": variation,
        "benefits": benefits,
        "faq": faq,
        "how_to_store": howToStore,
        "how_to_prepare": howToPrepare,
        "cooking_time": cookingTime,
        "subtitle": subtitle,
        "recipe_id": recipeId,
        "meal_timing_id": mealTimingId,
        "added_by": addedBy,
        "is_archieved": isArchieved,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category": category?.toJson(),
      };
}

class Category {
  int? id;
  String? name;
  String? maxAllowed;
  String? createdAt;
  String? updatedAt;

  Category({
    this.id,
    this.name,
    this.maxAllowed,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"].toString(),
        maxAllowed: json["max_allowed"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "max_allowed": maxAllowed,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
