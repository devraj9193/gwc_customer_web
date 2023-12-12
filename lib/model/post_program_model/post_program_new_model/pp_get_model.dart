class PPGetMealModel {
  int? status;
  int? errorCode;
  String? key;
  String? day;
  String? time;
  Data? data;
  List<History>? history;

  PPGetMealModel({this.status, this.errorCode, this.key, this.day, this.time, this.data, this.history});

  PPGetMealModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    day = json['day'];
    time = json['time'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) { history!.add(new History.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['day'] = this.day;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  List<Do>? doMeals;
  List<Do>? doNot;

  Data({this.doMeals, this.doNot});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['do'] != null) {
      doMeals = <Do>[];
      json['do'].forEach((v) { doMeals!.add(new Do.fromJson(v)); });
    }
    if (json['do not'] != null) {
      doNot = <Do>[];
      json['do not'].forEach((v) { doNot!.add(new Do.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doMeals != null) {
      data['do'] = this.doMeals!.map((v) => v.toJson()).toList();
    }
    if (this.doNot != null) {
      data['do not'] = this.doNot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Do {
  int? id;
  int? itemId;
  String? name;
  String? benefits;
  String? itemPhoto;
  String? recipeUrl;
  int? isSelected;

  Do({this.id, this.itemId, this.name, this.benefits, this.itemPhoto, this.recipeUrl, this.isSelected});

  Do.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    name = json['name'];
    benefits = json['benefits'];
    itemPhoto = json['item_photo'];
    recipeUrl = json['recipe_url'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['benefits'] = this.benefits;
    data['item_photo'] = this.itemPhoto;
    data['recipe_url'] = this.recipeUrl;
    data['is_selected'] = this.isSelected;
    return data;
  }
}

class History {
  String? totalScore;
  String? day;

  History({this.totalScore, this.day});

  History.fromJson(Map<String, dynamic> json) {
    totalScore = json['total_score'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_score'] = this.totalScore;
    data['day'] = this.day;
    return data;
  }
}