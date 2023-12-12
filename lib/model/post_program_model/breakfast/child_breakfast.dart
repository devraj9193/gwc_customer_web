class Data {
  Data({
    this.dataDo,
    this.doNot,
    this.none,
  });

  Do? dataDo;
  Do? doNot;
  None? none;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dataDo: Do.fromJson(json["do"]),
    doNot: Do.fromJson(json["do not"]),
    none: None.fromJson(json["none"]),
  );

  Map<String, dynamic> toJson() => {
    "do": dataDo!.toJson(),
    "do not": doNot!.toJson(),
    "none": none!.toJson(),
  };
}

class Do {
  Do({
    this.the0,
    this.isSelected,
  });

  The0? the0;
  int? isSelected;

  factory Do.fromJson(Map<String, dynamic> json) => Do(
    the0: The0.fromJson(json["0"]),
    isSelected: json["is_selected"],
  );

  Map<String, dynamic> toJson() => {
    "0": the0!.toJson(),
    "is_selected": isSelected,
  };
}

class The0 {
  The0({
    this.id,
    this.itemId,
    this.name,
  });

  int? id;
  int? itemId;
  String? name;

  factory The0.fromJson(Map<String, dynamic> json) => The0(
    id: json["id"],
    itemId: json["item_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_id": itemId,
    "name": name,
  };
}

class None {
  None({
    this.isSelected,
  });

  int? isSelected;

  factory None.fromJson(Map<String, dynamic> json) => None(
    isSelected: json["is_selected"],
  );

  Map<String, dynamic> toJson() => {
    "is_selected": isSelected,
  };
}