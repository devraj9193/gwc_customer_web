import 'child_evaluation_user.dart';

class ChildEvalPatient {
  int? id;
  String? userId;
  String? maritalStatus;
  String? pincode;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? status;
  String? weight;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  ChildEvalUser? user;

  ChildEvalPatient(
      {this.id,
        this.userId,
        this.maritalStatus,
        this.pincode,
        this.address2,
        this.city,
        this.state,
        this.country,
        this.weight,
        this.status,
        this.isArchieved,
        this.createdAt,
        this.updatedAt,
        this.user});

  ChildEvalPatient.fromJson(Map<String, dynamic> json) {
    print("patjson $json");
    json.forEach((key, value) => print(value.runtimeType));
    id = json['id'];
    userId = json['user_id'].toString() ?? '';
    maritalStatus = json['marital_status'] ?? '';
    pincode = json['pincode'] ?? '';
    address2 = json['address2'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    weight = json['weight'].toString() ?? '';
    status = json['status'] ?? '';
    isArchieved = json['is_archieved'].toString() ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    user = json['user'] != null ? new ChildEvalUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['marital_status'] = this.maritalStatus;
    data['pincode'] = this.pincode;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['weight'] = this.weight;
    data['status'] = this.status;
    data['is_archieved'] = this.isArchieved;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
