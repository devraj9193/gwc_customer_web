class GutDataModel {
  String? data;
  String? stringValue;
  HistoryWithMrClass? historyWithMrValue;
  RejectedCaseClass? rejectedCase;
  String? isProgramFeedbackSubmitted;

  GutDataModel({this.data, this.stringValue, this.rejectedCase, this.isProgramFeedbackSubmitted});

  GutDataModel.fromJson(Map<String, dynamic> json) {
    print("json['value'].runtimeType: ${json['value'].runtimeType}");
    print(json['value']);
    if(json['value'].runtimeType == String){
      stringValue = (json['value'].runtimeType == String) ? json['value'].toString() ??'' : '';
    }
    else{
      if(json['data'] == 'consultation_rejected'){
        print("if");
        print("${json['data']}");
        rejectedCase = json['value'] != null ? RejectedCaseClass.fromJson(json['value']) : null;
      }
      else{
        historyWithMrValue = json['value'] != null ? HistoryWithMrClass.fromJson(json['value']) : null;
      }
    }
    data = json['data'].toString();
    isProgramFeedbackSubmitted = json['is_program_feedback_submitted'].toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['value'] = this.stringValue;
    data['is_program_feedback_submitted'] = this.stringValue;
    return data;
  }
}

class RejectedCaseClass{
  String? reason;
  // String? mr;
  HistoryWithMrClass? historyWithMrValue;
  RejectedCaseClass({this.reason, this.historyWithMrValue});

  RejectedCaseClass.fromJson(Map<String, dynamic> json) {
    print("rejected json $json ");
    reason = json['rejected_reason'].toString();
    // mr = json['mr_report'] ?? '';
    historyWithMrValue = json['mr_report'] != null ? HistoryWithMrClass.fromJson(json['mr_report']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rejected_reason'] = this.reason;
    // data['mr_report'] = this.mr;
    data['mr_report'] = this.historyWithMrValue;
    return data;
  }
}

class HistoryWithMrClass {
  ConsultationHistory? consultationHistory;
  String? mr;

  HistoryWithMrClass({this.consultationHistory});

  HistoryWithMrClass.fromJson(Map<String, dynamic> json) {
    print("HistoryWithMrClass: $json");
    consultationHistory = json['consultation_history'] != null
        ? new ConsultationHistory.fromJson(json['consultation_history'])
        : null;
    mr = json['report'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consultationHistory != null) {
      data['consultation_history'] = this.consultationHistory!.toJson();
    }
    if(this.mr != null){
      data['report'] = this.mr;
    }
    return data;
  }
}

class ConsultationHistory {
  String? consultationDate;
  String? consultationStartTime;
  String? consultationEndTime;
  AppointDoctor? appointDoctor;
  String? shippingDeliveryDate;

  ConsultationHistory(
      {this.consultationDate,
        this.consultationStartTime,
        this.consultationEndTime,
        this.appointDoctor,
      this.shippingDeliveryDate});

  ConsultationHistory.fromJson(Map<String, dynamic> json) {
    consultationDate = json['consultation_date'].toString();
    consultationStartTime = json['consultation_start_time'].toString();
    consultationEndTime = json['consultation_end_time'].toString();
    if (json['Appoint_Doctor'] != null) {
        appointDoctor = AppointDoctor.fromJson(json['Appoint_Doctor']);
    }
    shippingDeliveryDate = json['shipping_delivery_date'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consultation_date'] = this.consultationDate;
    data['consultation_start_time'] = this.consultationStartTime;
    data['consultation_end_time'] = this.consultationEndTime;
    if (this.appointDoctor != null) {
      data['Appoint_Doctor'] = this.appointDoctor!.toJson();
    }
    data['shipping_delivery_date'] = this.shippingDeliveryDate;
    return data;
  }
}

class AppointDoctor {
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
  String? isActive;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? signupDate;
  Doctor? doctor;

  AppointDoctor(
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
        this.isActive,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.signupDate,
        this.doctor});

  AppointDoctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'].toString();
    name = json['name'].toString();
    fname = json['fname'].toString();
    lname = json['lname'].toString();
    email = json['email'].toString();
    emailVerifiedAt = json['email_verified_at'].toString();
    countryCode = json['country_code'].toString();
    phone = json['phone'].toString();
    gender = json['gender'].toString();
    profile = json['profile'].toString();
    address = json['address'].toString();
    otp = json['otp'].toString();
    deviceToken = json['device_token'].toString();
    webDeviceToken = json['web_device_token'].toString();
    deviceType = json['device_type'].toString();
    deviceId = json['device_id'].toString();
    age = json['age'].toString();
    kaleyraUserId = json['kaleyra_user_id'].toString();
    chatId = json['chat_id'].toString();
    loginUsername = json['login_username'].toString();
    pincode = json['pincode'].toString();
    isDoctorAdmin = json['is_doctor_admin'].toString();
    underAdminDoctor = json['under_admin_doctor'].toString();
    isActive = json['is_active'].toString();
    addedBy = json['added_by'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    signupDate = json['signup_date'].toString();
    doctor =
    json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
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
    data['device_token'] = this.deviceToken;
    data['web_device_token'] = this.webDeviceToken;
    data['device_type'] = this.deviceType;
    data['device_id'] = this.deviceId;
    data['age'] = this.age;
    data['kaleyra_user_id'] = this.kaleyraUserId;
    data['chat_id'] = this.chatId;
    data['login_username'] = this.loginUsername;
    data['pincode'] = this.pincode;
    data['is_doctor_admin'] = this.isDoctorAdmin;
    data['under_admin_doctor'] = this.underAdminDoctor;
    data['is_active'] = this.isActive;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['signup_date'] = this.signupDate;
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    return data;
  }
}

class Doctor {
  int? id;
  String? userId;
  String? signupDate;
  String? experience;
  String? weekoff;
  String? desc;
  String? programAssociated;
  String? occupation;
  Specialization? specialization;
  String? isArchieved;
  String? isDoctorAdmin;
  String? asstDoctors;
  String? sign;
  String? registerNumber;
  String? createdAt;
  String? updatedAt;

  Doctor(
      {this.id,
        this.userId,
        this.signupDate,
        this.experience,
        this.weekoff,
        this.desc,
        this.programAssociated,
        this.occupation,
        this.specialization,
        this.isArchieved,
        this.isDoctorAdmin,
        this.asstDoctors,
        this.sign,
        this.registerNumber,
        this.createdAt,
        this.updatedAt});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'].toString();
    signupDate = json['signup_date'].toString();
    experience = json['experience'].toString();
    weekoff = json['weekoff'].toString();
    desc = json['desc'].toString();
    programAssociated = json['program_associated'].toString();
    occupation = json['occupation'].toString();
    specialization = json['specialization'] != null
        ? new Specialization.fromJson(json['specialization'])
        : null;
    isArchieved = json['is_archieved'].toString();
    isDoctorAdmin = json['is_doctor_admin'].toString();
    asstDoctors = json['asst_doctors'].toString();
    sign = json['sign'].toString();
    registerNumber = json['register_number'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['signup_date'] = this.signupDate;
    data['experience'] = this.experience;
    data['weekoff'] = this.weekoff;
    data['desc'] = this.desc;
    data['program_associated'] = this.programAssociated;
    data['occupation'] = this.occupation;
    if (this.specialization != null) {
      data['specialization'] = this.specialization!.toJson();
    }
    data['is_archieved'] = this.isArchieved;
    data['is_doctor_admin'] = this.isDoctorAdmin;
    data['asst_doctors'] = this.asstDoctors;
    data['sign'] = this.sign;
    data['register_number'] = this.registerNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Specialization {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Specialization({this.id, this.name, this.createdAt, this.updatedAt});

  Specialization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}