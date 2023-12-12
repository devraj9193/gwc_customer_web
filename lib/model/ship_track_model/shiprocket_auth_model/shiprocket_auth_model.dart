class ShipRocketTokenModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  int? companyId;
  String? createdAt;
  String? token;

  ShipRocketTokenModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.companyId,
        this.createdAt,
        this.token});

  ShipRocketTokenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['company_id'] = this.companyId;
    data['created_at'] = this.createdAt;
    data['token'] = this.token;
    return data;
  }
}