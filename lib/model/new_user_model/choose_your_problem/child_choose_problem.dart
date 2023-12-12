class ChildChooseProblemModel {
  int? id;
  String? name;
  String? image;
  String? updatedAt;

  ChildChooseProblemModel({this.id, this.name, this.image, this.updatedAt});

  ChildChooseProblemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
