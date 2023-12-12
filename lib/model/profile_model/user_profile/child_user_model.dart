class ChildUserModel {
  int? id;
  String? roleId;
  String? name;
  String? fname;
  String? lname;
  String? email;
  String? emailVerifiedAt;
  String? countryCode;
  String? phone;
  String? gender;
  String? profile;
  String? address;
  String? otp;
  String? deviceToken;
  String? deviceType;
  String? deviceId;
  String? age;
  String? qbUserId;
  String? qbUsername;
  String? pincode;
  String? kaleyraUID;
  String? isActive;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? associatedSuccessMemberKaleyraId;


  ChildUserModel(
      {this.id,
        this.roleId,
        this.name,
        this.fname,
        this.lname,
        this.email,
        this.emailVerifiedAt,
        this.countryCode,
        this.phone,
        this.gender,
        this.profile,
        this.address,
        this.otp,
        this.deviceToken,
        this.deviceType,
        this.deviceId,
        this.age,
        this.pincode,
        this.isActive,
        this.addedBy,
        this.kaleyraUID,
        this.createdAt,
        this.updatedAt,
        this.associatedSuccessMemberKaleyraId
      });

  ChildUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'].toString();
    name = json['name'];
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    countryCode = json['country_code'];
    phone = json['phone'];
    gender = json['gender'];
    profile = json['profile'];
    address = json['address'];
    otp = json['otp'].toString();
    deviceId = json['kaleyra_user_id'].toString();
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    deviceId = json['device_id'].toString();
    age = json['age'];
    qbUserId = json['chat_id'];
    qbUsername = json['login_username'];
    kaleyraUID = json['kaleyra_user_id'];
    pincode = json['pincode'].toString();
    isActive = json['is_active'].toString();
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    associatedSuccessMemberKaleyraId = json['associated_success_member'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['name'] = this.name;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['profile'] = this.profile;
    data['address'] = this.address;
    data['otp'] = this.otp;
    data['kaleyra_user_id'] = this.kaleyraUID;
    data['device_token'] = this.deviceToken;
    data['device_type'] = this.deviceType;
    data['device_id'] = this.deviceId;
    data['age'] = this.age;
    data['chat_id'] = this.qbUserId;
    data['login_username'] = this.qbUsername;
    data['pincode'] = this.pincode;
    data['is_active'] = this.isActive;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['associated_success_member'] = this.associatedSuccessMemberKaleyraId;
    return data;
  }
}