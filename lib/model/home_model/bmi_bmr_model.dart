// To parse this JSON data, do
//
//     final bmiBmrModel = bmiBmrModelFromJson(jsonString);

import 'dart:convert';

BmiBmrModel bmiBmrModelFromJson(String str) => BmiBmrModel.fromJson(json.decode(str));

String bmiBmrModelToJson(BmiBmrModel data) => json.encode(data.toJson());

class BmiBmrModel {
  int? status;
  int? errorCode;
  String? key;
  Data? data;

  BmiBmrModel({
     this.status,
     this.errorCode,
     this.key,
     this.data,
  });

  factory BmiBmrModel.fromJson(Map<String, dynamic> json) => BmiBmrModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  int? userId;
  String? maritalStatus;
  String? address2;
  String? city;
  String? state;
  String? country;
  int? weight;
  String? bmi;
  String? bmr;
  String? status;
  String? shippingDeliveryDate;
  String? rejectedReason;
  int? isArchieved;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  Data({
     this.id,
     this.userId,
     this.maritalStatus,
     this.address2,
     this.city,
     this.state,
     this.country,
     this.weight,
     this.bmi,
     this.bmr,
     this.status,
     this.shippingDeliveryDate,
     this.rejectedReason,
     this.isArchieved,
     this.createdAt,
     this.updatedAt,
     this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    maritalStatus: json["marital_status"].toString(),
    address2: json["address2"].toString(),
    city: json["city"].toString(),
    state: json["state"].toString(),
    country: json["country"].toString(),
    weight: json["weight"],
    bmi: json["BMI"].toString(),
    bmr: json["BMR"].toString(),
    status: json["status"].toString(),
    shippingDeliveryDate: json["shipping_delivery_date"].toString(),
    rejectedReason: json["rejected_reason"].toString(),
    isArchieved: json["is_archieved"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "marital_status": maritalStatus,
    "address2": address2,
    "city": city,
    "state": state,
    "country": country,
    "weight": weight,
    "BMI": bmi,
    "BMR": bmr,
    "status": status,
    "shipping_delivery_date": shippingDeliveryDate,
    "rejected_reason": rejectedReason,
    "is_archieved": isArchieved,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  int? roleId;
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
  String? webDeviceToken;
  String? deviceType;
  String? deviceId;
  String? age;
  String? kaleyraUserId;
  String? chatId;
  String? loginUsername;
  String? pincode;
  int? isDoctorAdmin;
  String? underAdminDoctor;
  String? successUserId;
  String? cetUserId;
  String? cetCompleted;
  String? uvUserId;
  int? isActive;
  String? addedBy;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? signupDate;

  User({
     this.id,
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
     this.webDeviceToken,
     this.deviceType,
     this.deviceId,
     this.age,
     this.kaleyraUserId,
     this.chatId,
     this.loginUsername,
     this.pincode,
     this.isDoctorAdmin,
     this.underAdminDoctor,
     this.successUserId,
     this.cetUserId,
     this.cetCompleted,
     this.uvUserId,
     this.isActive,
     this.addedBy,
     this.latitude,
     this.longitude,
     this.createdAt,
     this.updatedAt,
     this.signupDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    roleId: json["role_id"],
    name: json["name"].toString(),
    fname: json["fname"].toString(),
    lname: json["lname"].toString(),
    email: json["email"].toString(),
    emailVerifiedAt: json["email_verified_at"].toString(),
    countryCode: json["country_code"].toString(),
    phone: json["phone"].toString(),
    gender: json["gender"].toString(),
    profile: json["profile"].toString(),
    address: json["address"].toString(),
    otp: json["otp"].toString(),
    deviceToken: json["device_token"].toString(),
    webDeviceToken: json["web_device_token"].toString(),
    deviceType: json["device_type"].toString(),
    deviceId: json["device_id"].toString(),
    age: json["age"].toString(),
    kaleyraUserId: json["kaleyra_user_id"].toString(),
    chatId: json["chat_id"].toString(),
    loginUsername: json["login_username"].toString(),
    pincode: json["pincode"].toString(),
    isDoctorAdmin: json["is_doctor_admin"],
    underAdminDoctor: json["under_admin_doctor"].toString(),
    successUserId: json["success_user_id"].toString(),
    cetUserId: json["cet_user_id"].toString(),
    cetCompleted: json["cet_completed"].toString(),
    uvUserId: json["uv_user_id"].toString(),
    isActive: json["is_active"],
    addedBy: json["added_by"].toString(),
    latitude: json["latitude"].toString(),
    longitude: json["longitude"].toString(),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    signupDate: json["signup_date"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "name": name,
    "fname": fname,
    "lname": lname,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "country_code": countryCode,
    "phone": phone,
    "gender": gender,
    "profile": profile,
    "address": address,
    "otp": otp,
    "device_token": deviceToken,
    "web_device_token": webDeviceToken,
    "device_type": deviceType,
    "device_id": deviceId,
    "age": age,
    "kaleyra_user_id": kaleyraUserId,
    "chat_id": chatId,
    "login_username": loginUsername,
    "pincode": pincode,
    "is_doctor_admin": isDoctorAdmin,
    "under_admin_doctor": underAdminDoctor,
    "success_user_id": successUserId,
    "cet_user_id": cetUserId,
    "cet_completed": cetCompleted,
    "uv_user_id": uvUserId,
    "is_active": isActive,
    "added_by": addedBy,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "signup_date": signupDate,
  };
}
