class User {
  String? name;
  String? email;
  String? age;
  String? gender;
  String? phone;
  int? roleId;
  String? otp;
  String? updatedAt;
  String? createdAt;
  int? id;

  User(
      {this.name,
        this.email,
        this.age,
        this.gender,
        this.phone,
        this.roleId,
        this.otp,
        this.updatedAt,
        this.createdAt,
        this.id});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    age = json['age'];
    gender = json['gender'];
    phone = json['phone'];
    roleId = json['role_id'];
    otp = json['otp'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['role_id'] = this.roleId;
    data['otp'] = this.otp;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}