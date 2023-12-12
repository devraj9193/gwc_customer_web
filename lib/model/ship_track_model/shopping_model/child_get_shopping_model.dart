class ChildGetShoppingModel {
  ChildGetShoppingModel({
    this.id,
    this.name,
    this.thumbnail,
    // this.teamPatientId,
    // this.ingredientsId,
    // this.createdAt,
    // this.updatedAt,
    // this.ingredients,
    // this.itemWeightId,
    // this.userCustomMealPlanId,
    // this.shopId,
    // this.programDay,
    // this.totalWeight,
    // this.addedBy,
    // this.itemWeight,
    // this.mealItemWeight,
  });

  int? id;
  String? name;
  String? thumbnail;
  // String? teamPatientId;
  // String? ingredientsId;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // ChildIngredients? ingredients;
  // String? itemWeightId;
  // String? userCustomMealPlanId;
  // String? shopId;
  // String? programDay;
  // String? totalWeight;
  // String? addedBy;
  // String? itemWeight;
  // MealItemWeight? mealItemWeight;

  factory ChildGetShoppingModel.fromJson(Map<String, dynamic> json) => ChildGetShoppingModel(
    id: json["id"],
    name: json["name"],
    thumbnail: json["thumbnail"],
    // teamPatientId: json["team_patient_id"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
    // ingredients: ChildIngredients.fromJson(json['ingredient']),
    // ingredientsId: json["ingredients_id"],
    //
    // itemWeightId: json["item_weight_id"],
    // userCustomMealPlanId: json["user_custom_meal_plan_id"],
    // shopId: json["shop_id"],
    // programDay: json["program_day"],
    // totalWeight: json["total_weight"],
    // addedBy: json["added_by"],
    // itemWeight: json["item_weight"],
    // mealItemWeight: MealItemWeight.fromJson(json["meal_item_weight"]),
    //
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name":name,
    "thumbnail":thumbnail,
    // "team_patient_id": teamPatientId,
    // "ingredients_id": ingredientsId,
    // "ingredient": ingredients?.toJson(),
    // "created_at": createdAt?.toIso8601String() ?? '',
    // "updated_at": updatedAt?.toIso8601String() ?? '',
    //
    // "item_weight_id": itemWeightId,
    // "user_custom_meal_plan_id": userCustomMealPlanId,
    // "shop_id": shopId,
    // "program_day": programDay,
    // "total_weight": totalWeight,
    // "added_by": addedBy,
    // "item_weight": itemWeight,
    // "meal_item_weight": mealItemWeight?.toJson(),
    //
  };
}

class MealItemWeight {
  MealItemWeight({
    this.id,
    this.mealPlanItemId,
    this.weight,
    this.weightTypeId,
    this.createdAt,
    this.updatedAt,
    this.mealItem,
    this.weightType,
  });

  int? id;
  String? mealPlanItemId;
  String? weight;
  String? weightTypeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  MealItem? mealItem;
  WeightType? weightType;

  factory MealItemWeight.fromJson(Map<String, dynamic> json) => MealItemWeight(
    id: json["id"],
    mealPlanItemId: json["meal_plan_item_id"],
    weight: json["weight"] == null ? null : json["weight"],
    weightTypeId: json["weight_type_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    mealItem: MealItem.fromJson(json["meal_item"]),
    weightType: WeightType.fromJson(json["weight_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "meal_plan_item_id": mealPlanItemId,
    "weight": weight == null ? null : weight,
    "weight_type_id": weightTypeId,
    "created_at": createdAt?.toIso8601String() ?? '',
    "updated_at": updatedAt?.toIso8601String() ?? '',
    "meal_item": mealItem?.toJson(),
    "weight_type": weightType?.toJson(),
  };
}

class MealItem {
  MealItem({
    this.id,
    this.name,
    this.mealTimingId,
    this.recipeId,
    this.programId,
    this.inCookingKit,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? mealTimingId;
  String? recipeId;
  String? programId;
  String? inCookingKit;
  String? addedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
    id: json["id"],
    name: json["name"],
    mealTimingId: json["meal_timing_id"],
    recipeId: json["recipe_id"],
    programId: json["program_id"],
    inCookingKit: json["in_cooking_kit"],
    addedBy: json["added_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "meal_timing_id": mealTimingId,
    "recipe_id": recipeId,
    "program_id": programId,
    "in_cooking_kit": inCookingKit,
    "added_by": addedBy,
    "created_at": createdAt?.toIso8601String() ?? '',
    "updated_at": updatedAt?.toIso8601String() ?? '',
  };
}

class WeightType {
  WeightType({
    this.id,
    this.unit,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? unit;
  String? createdAt;
  String? updatedAt;

  factory WeightType.fromJson(Map<String, dynamic> json) => WeightType(
    id: json["id"],
    unit: json["unit"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unit": unit,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class ChildIngredients{
  ChildIngredients({
    this.id,
    this.ingredientCategoryId,
    this.name,
    this.thumbnail,
    this.createdAt,
    this.updatedAt,
    this.childIngredientCategory
  });

  int? id;
  String? ingredientCategoryId;
  String? name;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;
  ChildIngredientCategory? childIngredientCategory;

  factory ChildIngredients.fromJson(Map<String, dynamic> json) => ChildIngredients(
      id: json["id"],
      ingredientCategoryId: json["ingredient_category_id"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      name: json['name'],
      thumbnail: json['thumbnail'],
      childIngredientCategory: ChildIngredientCategory.fromJson(json['ingredient_category'])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ingredient_category_id": ingredientCategoryId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "name": name,
    'thumbnail':thumbnail,
    "ingredient_category":childIngredientCategory?.toJson()
  };
}
class ChildIngredientCategory{

  ChildIngredientCategory({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  factory ChildIngredientCategory.fromJson(Map<String, dynamic> json) => ChildIngredientCategory(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}


