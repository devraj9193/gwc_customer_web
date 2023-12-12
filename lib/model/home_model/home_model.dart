class HomeScreenModel {
  String? status;
  String? errorCode;
  String? key;
  List<Evaluation>? evaluation;
  List<Consultation>? consultation;
  List<Tracker>? tracker;
  List<Program>? program;
  List<PostConsultation>? postConsultation;
  List<ProtocolGuide>? protocolGuide;

  HomeScreenModel(
      {this.status,
        this.errorCode,
        this.key,
        this.evaluation,
        this.consultation,
        this.tracker,
        this.program,
        this.postConsultation,
        this.protocolGuide});

  HomeScreenModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    key = json['key'];
    if (json['Evaluation'] != null) {
      evaluation = <Evaluation>[];
      json['Evaluation'].forEach((v) {
        evaluation!.add(new Evaluation.fromJson(v));
      });
    }
    if (json['Consultation'] != null) {
      consultation = <Consultation>[];
      json['Consultation'].forEach((v) {
        consultation!.add(new Consultation.fromJson(v));
      });
    }
    if (json['Tracker'] != null) {
      tracker = <Tracker>[];
      json['Tracker'].forEach((v) {
        tracker!.add(new Tracker.fromJson(v));
      });
    }
    if (json['Program'] != null) {
      program = <Program>[];
      json['Program'].forEach((v) {
        program!.add(new Program.fromJson(v));
      });
    }
    if (json['Post_Consultation'] != null) {
      postConsultation = <PostConsultation>[];
      json['Post_Consultation'].forEach((v) {
        postConsultation!.add(new PostConsultation.fromJson(v));
      });
    }
    if (json['Protocol_Guide'] != null) {
      protocolGuide = <ProtocolGuide>[];
      json['Protocol_Guide'].forEach((v) {
        protocolGuide!.add(new ProtocolGuide.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.evaluation != null) {
      data['Evaluation'] = this.evaluation!.map((v) => v.toJson()).toList();
    }
    if (this.consultation != null) {
      data['Consultation'] = this.consultation!.map((v) => v.toJson()).toList();
    }
    if (this.tracker != null) {
      data['Tracker'] = this.tracker!.map((v) => v.toJson()).toList();
    }
    if (this.program != null) {
      data['Program'] = this.program!.map((v) => v.toJson()).toList();
    }
    if (this.postConsultation != null) {
      data['Post_Consultation'] =
          this.postConsultation!.map((v) => v.toJson()).toList();
    }
    if (this.protocolGuide != null) {
      data['Protocol_Guide'] =
          this.protocolGuide!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Evaluation {
  String? evaluationStatus;
  String? evaluationPercentage;
  RewardPoints? rewardPoints;
  String? text;

  Evaluation(
      {this.evaluationStatus,
        this.evaluationPercentage,
        this.rewardPoints,
        this.text});

  Evaluation.fromJson(Map<String, dynamic> json) {
    evaluationStatus = json['evaluation_status'];
    evaluationPercentage = json['evaluation_percentage'];
    rewardPoints = json['reward_points'] != null
        ? new RewardPoints.fromJson(json['reward_points'])
        : null;
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['evaluation_status'] = this.evaluationStatus;
    data['evaluation_percentage'] = this.evaluationPercentage;
    if (this.rewardPoints != null) {
      data['reward_points'] = this.rewardPoints!.toJson();
    }
    data['text'] = this.text;
    return data;
  }
}

class RewardPoints {
  int? id;
  String? name;
  String? type;
  String? point;
  String? createdAt;
  String? updatedAt;

  RewardPoints(
      {this.id,
        this.name,
        this.type,
        this.point,
        this.createdAt,
        this.updatedAt});

  RewardPoints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    point = json['point'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['point'] = this.point;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Consultation {
  String? consultationStatus;
  String? consultationPercentage;
  RewardPoints? rewardPoints;
  String? text;
  String? mr_report;
  ConsultationDetails? bookedStage;

  Consultation(
      {this.consultationStatus,
        this.consultationPercentage,
        this.rewardPoints,
        this.text,
        this.mr_report,
        this.bookedStage
      });

  Consultation.fromJson(Map<String, dynamic> json) {
    consultationStatus = json['consultation_status'];
    consultationPercentage = json['consultation_percentage'];
    rewardPoints = json['reward_points'] != null
        ? new RewardPoints.fromJson(json['reward_points'])
        : null;
    text = json['text'];
    mr_report = json['mr_report'];
    bookedStage = json['consultation_details'] != null
        ? new ConsultationDetails.fromJson(json['consultation_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consultation_status'] = this.consultationStatus;
    data['consultation_percentage'] = this.consultationPercentage;
    if (this.rewardPoints != null) {
      data['reward_points'] = this.rewardPoints!.toJson();
    }
    data['text'] = this.text;
    data['mr_report'] = this.mr_report;
    if (this.bookedStage != null) {
      data['consultation_details'] = this.bookedStage!.toJson();
    }
    return data;
  }
}

class Tracker {
  String? trackerStatus;
  String? trackerPercentage;
  int? rewardPoints;
  String? text;

  Tracker(
      {this.trackerStatus,
        this.trackerPercentage,
        this.rewardPoints,
        this.text});

  Tracker.fromJson(Map<String, dynamic> json) {
    trackerStatus = json['tracker_status'];
    trackerPercentage = json['tracker_percentage'];
    rewardPoints = json['reward_points'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tracker_status'] = this.trackerStatus;
    data['tracker_percentage'] = this.trackerPercentage;
    data['reward_points'] = this.rewardPoints;
    data['text'] = this.text;
    return data;
  }
}

class Program {
  String? programStatus;
  String? programPercentage;
  String? rewardPoints;
  String? text;

  Program(
      {this.programStatus,
        this.programPercentage,
        this.rewardPoints,
        this.text});

  Program.fromJson(Map<String, dynamic> json) {
    programStatus = json['program_status'];
    programPercentage = json['program_percentage'];
    rewardPoints = json['reward_points'].toString();
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_status'] = this.programStatus;
    data['program_percentage'] = this.programPercentage;
    data['reward_poi*nts'] = this.rewardPoints;
    data['text'] = this.text;
    return data;
  }
}

class PostConsultation {
  String? consultationStatus;
  String? consultationPercentage;
  PostRewardPoints? rewardPoints;
  String? text;

  PostConsultation(
      {this.consultationStatus,
        this.consultationPercentage,
        this.rewardPoints,
        this.text});

  PostConsultation.fromJson(Map<String, dynamic> json) {
    consultationStatus = json['consultation_status'];
    consultationPercentage = json['consultation_percentage'];
    rewardPoints = (json['reward_points'].runtimeType != int) ? PostRewardPoints.fromJson(json['reward_points']) : null;
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consultation_status'] = this.consultationStatus;
    data['consultation_percentage'] = this.consultationPercentage;
    data['reward_points'] = this.rewardPoints!.toJson();
    data['text'] = this.text;
    return data;
  }
}

class PostRewardPoints {
  RewardPoints? rewardPoints;

  PostRewardPoints({this.rewardPoints});

  PostRewardPoints.fromJson(Map<String, dynamic> json) {
    rewardPoints = json['reward_points'] != null
        ? new RewardPoints.fromJson(json['reward_points'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rewardPoints != null) {
      data['reward_points'] = this.rewardPoints!.toJson();
    }
    return data;
  }
}

class ProtocolGuide {
  String? consultationStatus;
  String? consultationPercentage;
  int? rewardPoints;
  String? text;

  ProtocolGuide(
      {this.consultationStatus,
        this.consultationPercentage,
        this.rewardPoints,
        this.text});

  ProtocolGuide.fromJson(Map<String, dynamic> json) {
    consultationStatus = json['consultation_status'];
    consultationPercentage = json['consultation_percentage'];
    rewardPoints = json['reward_points'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consultation_status'] = this.consultationStatus;
    data['consultation_percentage'] = this.consultationPercentage;
    data['reward_points'] = this.rewardPoints;
    data['text'] = this.text;
    return data;
  }
}

class ConsultationDetails {
  int? id;
  String? teamPatientId;
  String? date;
  String? slotStartTime;
  String? slotEndTime;
  String? type;
  String? status;
  String? zoomJoinUrl;
  String? zoomStartUrl;
  String? zoomId;
  String? zoomPassword;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentStartTime;
  TeamPatients? teamPatients;
  String? kaleyraJoinurl;


  ConsultationDetails(
      {this.id,
        this.teamPatientId,
        this.date,
        this.slotStartTime,
        this.slotEndTime,
        this.type,
        this.status,
        this.zoomJoinUrl,
        this.zoomStartUrl,
        this.zoomId,
        this.zoomPassword,
        this.createdAt,
        this.updatedAt,
        this.appointmentDate,
        this.appointmentStartTime,
        this.kaleyraJoinurl,
        this.teamPatients});

  ConsultationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamPatientId = json['team_patient_id'].toString();
    date = json['date'];
    slotStartTime = json['slot_start_time'];
    slotEndTime = json['slot_end_time'];
    type = json['type'];
    status = json['status'];
    zoomJoinUrl = json['zoom_join_url'];
    zoomStartUrl = json['zoom_start_url'];
    zoomId = json['zoom_id'];
    zoomPassword = json['zoom_password'];
    kaleyraJoinurl = json['kaleyra_user_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    appointmentDate = json['appointment_date'];
    appointmentStartTime = json['appointment_start_time'];
    teamPatients = json['team_patients'] != null
        ? new TeamPatients.fromJson(json['team_patients'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_patient_id'] = this.teamPatientId;
    data['date'] = this.date;
    data['slot_start_time'] = this.slotStartTime;
    data['slot_end_time'] = this.slotEndTime;
    data['type'] = this.type;
    data['status'] = this.status;
    data['zoom_join_url'] = this.zoomJoinUrl;
    data['zoom_start_url'] = this.zoomStartUrl;
    data['kaleyra_user_url'] = this.kaleyraJoinurl;
    data['zoom_id'] = this.zoomId;
    data['zoom_password'] = this.zoomPassword;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_start_time'] = this.appointmentStartTime;
    if (this.teamPatients != null) {
      data['team_patients'] = this.teamPatients!.toJson();
    }
    return data;
  }
}

class TeamPatients {
  int? id;
  String? teamId;
  String? patientId;
  String? programId;
  String? assignedDate;
  String? uploadTime;
  String? status;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentTime;
  String? updateDate;
  String? updateTime;
  String? manifestUrl;
  String? labelUrl;
  Patient? patient;
  List<Appointments>? appointments;

  TeamPatients(
      {this.id,
        this.teamId,
        this.patientId,
        this.programId,
        this.assignedDate,
        this.uploadTime,
        this.status,
        this.isArchieved,
        this.createdAt,
        this.updatedAt,
        this.appointmentDate,
        this.appointmentTime,
        this.updateDate,
        this.updateTime,
        this.manifestUrl,
        this.labelUrl,
        this.patient,
        this.appointments});

  TeamPatients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    patientId = json['patient_id'];
    programId = json['program_id'];
    assignedDate = json['assigned_date'];
    uploadTime = json['upload_time'];
    status = json['status'];
    isArchieved = json['is_archieved'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    updateDate = json['update_date'];
    updateTime = json['update_time'];
    manifestUrl = json['manifest_url'];
    labelUrl = json['label_url'];
    patient =
    json['patient'] != null ? new Patient.fromJson(json['patient']) : null;
    if (json['appointments'] != null) {
      appointments = <Appointments>[];
      json['appointments'].forEach((v) {
        appointments!.add(new Appointments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_id'] = this.teamId;
    data['patient_id'] = this.patientId;
    data['program_id'] = this.programId;
    data['assigned_date'] = this.assignedDate;
    data['upload_time'] = this.uploadTime;
    data['status'] = this.status;
    data['is_archieved'] = this.isArchieved;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['update_date'] = this.updateDate;
    data['update_time'] = this.updateTime;
    data['manifest_url'] = this.manifestUrl;
    data['label_url'] = this.labelUrl;
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this.appointments != null) {
      data['appointments'] = this.appointments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Patient {
  int? id;
  String? userId;
  String? maritalStatus;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? weight;
  String? status;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  User? user;

  Patient(
      {this.id,
        this.userId,
        this.maritalStatus,
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

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    maritalStatus = json['marital_status'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    weight = json['weight'];
    status = json['status'];
    isArchieved = json['is_archieved'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['marital_status'] = this.maritalStatus;
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

class User {
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
  String? chatId;
  String? loginUsername;
  String? pincode;
  String? isActive;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? signupDate;

  User(
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
        this.chatId,
        this.loginUsername,
        this.pincode,
        this.isActive,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.signupDate});

  User.fromJson(Map<String, dynamic> json) {
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
    otp = json['otp'];
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    deviceId = json['device_id'];
    age = json['age'];
    chatId = json['chat_id'];
    loginUsername = json['login_username'];
    pincode = json['pincode'];
    isActive = json['is_active'].toString();
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    signupDate = json['signup_date'];
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
    data['device_type'] = this.deviceType;
    data['device_id'] = this.deviceId;
    data['age'] = this.age;
    data['chat_id'] = this.chatId;
    data['login_username'] = this.loginUsername;
    data['pincode'] = this.pincode;
    data['is_active'] = this.isActive;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['signup_date'] = this.signupDate;
    return data;
  }
}

class Appointments {
  int? id;
  String? teamPatientId;
  String? date;
  String? slotStartTime;
  String? slotEndTime;
  String? type;
  String? status;
  String? zoomJoinUrl;
  String? zoomStartUrl;
  String? zoomId;
  String? zoomPassword;
  String? kaleyraJoinurl;
  String? createdAt;
  String? updatedAt;
  String? appointmentDate;
  String? appointmentStartTime;

  Appointments(
      {this.id,
        this.teamPatientId,
        this.date,
        this.slotStartTime,
        this.slotEndTime,
        this.type,
        this.status,
        this.zoomJoinUrl,
        this.zoomStartUrl,
        this.zoomId,
        this.zoomPassword,
        this.createdAt,
        this.updatedAt,
        this.appointmentDate,
        this.kaleyraJoinurl,
        this.appointmentStartTime});

  Appointments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamPatientId = json['team_patient_id'];
    date = json['date'];
    slotStartTime = json['slot_start_time'];
    slotEndTime = json['slot_end_time'];
    type = json['type'];
    status = json['status'];
    zoomJoinUrl = json['zoom_join_url'];
    zoomStartUrl = json['zoom_start_url'];
    zoomId = json['zoom_id'];
    zoomPassword = json['zoom_password'];
    kaleyraJoinurl = json['kaleyra_user_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    appointmentDate = json['appointment_date'];
    appointmentStartTime = json['appointment_start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_patient_id'] = this.teamPatientId;
    data['date'] = this.date;
    data['slot_start_time'] = this.slotStartTime;
    data['slot_end_time'] = this.slotEndTime;
    data['type'] = this.type;
    data['status'] = this.status;
    data['zoom_join_url'] = this.zoomJoinUrl;
    data['zoom_start_url'] = this.zoomStartUrl;
    data['zoom_id'] = this.zoomId;
    data['zoom_password'] = this.zoomPassword;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_start_time'] = this.appointmentStartTime;
    data['kaleyra_user_url'] = this.kaleyraJoinurl;
    return data;
  }
}