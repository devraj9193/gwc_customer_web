import 'dart:convert';

class LoginOtpModel {
  String? status;
  User? user;
  String? accessToken;
  String? tokenType;
  String? kaleyraUserId;
  String? kaleyraSuccessId;
  String? userEvaluationStatus;
  String? chatId;
  String? loginUsername;
  String? currentUser;
  String? associatedSuccessMemberKaleyraId;
  String? uvAgentId;
  String? uvSuccessId;
  String? uvApiAccessToken;
  String? supportNumber;

  LoginOtpModel({
    this.status,
    this.user,
    this.accessToken,
    this.tokenType,
    this.userEvaluationStatus,
    this.kaleyraUserId,
    this.kaleyraSuccessId,
    this.chatId,
    this.loginUsername,
    this.currentUser,
    this.associatedSuccessMemberKaleyraId,
    this.uvAgentId,
    this.uvSuccessId,
    this.uvApiAccessToken,
    this.supportNumber,
  });

  LoginOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    user = User.fromJson(json["user"]);
    accessToken = json['access_token'].toString();
    tokenType = json['token_type'].toString();
    kaleyraUserId = json['user_kaleyra_id'].toString();
    kaleyraSuccessId = json['success_team_kaleyra_id'].toString();
    userEvaluationStatus = json['user_status'].toString();
    chatId = json['chat_id'].toString();
    loginUsername = json['login_username'].toString();
    currentUser = json['current_user'].toString();
    associatedSuccessMemberKaleyraId = json['associated_success_member'].toString();
    uvAgentId = json['uv_user_id'].toString();
    uvSuccessId = json['uv_success_id'].toString();
    uvApiAccessToken = json['uv_api_access_token'] ?? '';
    supportNumber = json['support_number'] ?? '';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status.toString();
    data["user"] =  user?.toJson();
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['user_kaleyra_id'] = kaleyraUserId;
    data['success_team_kaleyra_id'] = kaleyraSuccessId;
    data['user_status'] = userEvaluationStatus;
    data['chat_id'] = chatId;
    data['associated_success_member'] = associatedSuccessMemberKaleyraId;
    data['login_username'] = loginUsername;
    data['current_user'] = currentUser;
    data['uv_user_id'] = uvAgentId;
    data['uv_success_id'] = uvSuccessId;
    data['uv_api_access_token'] = uvApiAccessToken;
    data['support_number'] = supportNumber;
    return data;
  }
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
  String? profession;
  String? profile;
  String? address;
  String? otp;
  String? passOtp;
  String? deviceToken;
  String? webDeviceToken;
  String? deviceType;
  String? deviceId;
  String? age;
  String? kaleyraUserId;
  String? chatId;
  String? loginUsername;
  String? pincode;
  String? isDoctorAdmin;
  String? underAdminDoctor;
  String? successUserId;
  String? cetUserId;
  String? cetCompleted;
  String? uvUserId;
  String? isActive;
  String? addedBy;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
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
     this.profession,
     this.profile,
     this.address,
     this.otp,
     this.passOtp,
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
    profession: json["profession"].toString(),
    profile: json["profile"].toString(),
    address: json["address"].toString(),
    otp: json["otp"].toString(),
    passOtp: json["pass_otp"].toString(),
    deviceToken: json["device_token"].toString(),
    webDeviceToken: json["web_device_token"].toString(),
    deviceType: json["device_type"].toString(),
    deviceId: json["device_id"].toString(),
    age: json["age"].toString(),
    kaleyraUserId: json["kaleyra_user_id"].toString(),
    chatId: json["chat_id"].toString(),
    loginUsername: json["login_username"].toString(),
    pincode: json["pincode"].toString(),
    isDoctorAdmin: json["is_doctor_admin"].toString(),
    underAdminDoctor: json["under_admin_doctor"].toString(),
    successUserId: json["success_user_id"].toString(),
    cetUserId: json["cet_user_id"].toString(),
    cetCompleted: json["cet_completed"].toString(),
    uvUserId: json["uv_user_id"].toString(),
    isActive: json["is_active"].toString(),
    addedBy: json["added_by"].toString(),
    latitude: json["latitude"].toString(),
    longitude: json["longitude"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
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
    "profession": profession,
    "profile": profile,
    "address": address,
    "otp": otp,
    "pass_otp": passOtp,
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
    "created_at": createdAt,
    "updated_at": updatedAt,
    "signup_date": signupDate,
  };
}

LoginOtpModel loginOtpFromJson(String str) =>
    LoginOtpModel.fromJson(json.decode(str));

String loginOtpToJson(LoginOtpModel data) => json.encode(data.toJson());
