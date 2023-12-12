import 'package:gwc_customer_web/model/consultation_model/appointment_booking/child_team.dart';

import 'child_user_appointment.dart';

class ChildTeamPatientsAppointment {
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
  ChildPatientAppointment? patient;
  Team? team;

  ChildTeamPatientsAppointment(
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
        this.patient, this.team});

  ChildTeamPatientsAppointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'].toString();
    patientId = json['patient_id'].toString();
    programId = json['program_id'].toString();
    assignedDate = json['assigned_date'];
    uploadTime = json['upload_time'];
    status = json['status'];
    isArchieved = json['is_archieved'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    patient =
    json['patient'] != null ? new ChildPatientAppointment.fromJson(json['patient']) : null;
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;

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
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    return data;
  }
}
class ChildPatientAppointment {
  int? id;
  String? userId;
  String? maritalStatus;
  String? pincode;
  String? weight;
  String? status;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  ChildUserAppointment? user;

  ChildPatientAppointment(
      {this.id,
        this.userId,
        this.maritalStatus,
        this.pincode,
        this.weight,
        this.status,
        this.isArchieved,
        this.createdAt,
        this.updatedAt,
        this.user});

  ChildPatientAppointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'].toString();
    maritalStatus = json['marital_status'];
    pincode = json['pincode'];
    weight = json['weight'].toString();
    status = json['status'];
    isArchieved = json['is_archieved'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new ChildUserAppointment.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['marital_status'] = this.maritalStatus;
    data['pincode'] = this.pincode;
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
