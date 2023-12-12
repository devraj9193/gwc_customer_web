import 'child_get_shopping_model.dart';

class GetShoppingListModel {
  int? status;
  int? errorCode;
  Map<String, List<ChildGetShoppingModel>>? ingredients;

  GetShoppingListModel({
    this.status,
    this.errorCode,
    this.ingredients,
  });

  factory GetShoppingListModel.fromJson(Map<String, dynamic> json) =>
      GetShoppingListModel(
        status: json["status"],
        errorCode: json["errorCode"],
        ingredients: Map.from(json["ingredients"]).map(
              (k, v) => MapEntry<String, List<ChildGetShoppingModel>>(
            k,
            List<ChildGetShoppingModel>.from(
              v.map(
                    (x) => ChildGetShoppingModel.fromJson(x),
              ),
            ),
          ),
        ),
        // ingredients: json['ingredients'] != null ? List.from(json["ingredients"]).map((element) => ChildGetShoppingModel.fromJson(element)).toList() : null
        // ingredients: Map.from(json["ingredients"]).map((k, v) => MapEntry<String, List<ChildGetShoppingModel>>(k, List<ChildGetShoppingModel>.from(v.map((x) => ChildGetShoppingModel.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "ingredients": Map.from(ingredients!).map(
          (k, v) => MapEntry<String, dynamic>(
        k,
        List<dynamic>.from(
          v.map(
                (x) => x.toJson(),
          ),
        ),
      ),
    ),
    // "ingredients": List<ChildGetShoppingModel>.from(ingredients!).map((v) => v.toJson()).toList(),

    // "ingredients": Map.from(ingredients!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
  };
}
