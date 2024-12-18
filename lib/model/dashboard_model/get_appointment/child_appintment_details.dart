import 'package:gwc_customer_web/model/consultation_model/appointment_booking/child_doctor_model.dart';
import 'package:gwc_customer_web/model/consultation_model/appointment_booking/child_team_member.dart';
import 'child_team_patients_appointment.dart';

class ChildAppointmentDetails {
  // this is for protocol guide stage -> reports parameter
  String? programEndReport;
  String? programEndReportUser;
  String? gmgPdfUrl;
  String? mealProtocol;
  // this is for post consultation stage -> parameters
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
  String? kaleyraJoinurl;
  String? kaleyraSuccessTeamId;
  String? appointmentStartTime;
  List<TeamMember>? teamMember;
  ChildDoctorModel? doctor;
  ChildTeamPatientsAppointment? teamPatients;

  ChildAppointmentDetails(
      {this.programEndReport,
      this.programEndReportUser,
      this.gmgPdfUrl,
      this.mealProtocol,
      this.id,
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
      this.kaleyraSuccessTeamId,
      this.teamMember,
      this.doctor,
      this.teamPatients});

  ChildAppointmentDetails.fromJson(Map<String, dynamic> json) {
    programEndReport = json['Program_End_Report'];
    programEndReportUser = json['Program_End_Report_User'];
    gmgPdfUrl = json['gmg'];
    mealProtocol = json['meal_protocol'];
    // post consultation
    id = json['id'];
    teamPatientId = json['team_patient_id'].toString();
    date = json['date'];
    slotStartTime = json['slot_start_time'];
    slotEndTime = json['slot_end_time'];
    type = json['type'].toString();
    status = json['status'];
    zoomJoinUrl = json['zoom_join_url'];
    zoomStartUrl = json['zoom_start_url'];
    zoomId = json['zoom_id'];
    zoomPassword = json['zoom_password'];
    kaleyraJoinurl = json['kaleyra_user_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    kaleyraSuccessTeamId = json['kaleyra_success_team_id'].toString();
    appointmentDate = json['appointment_date'];
    appointmentStartTime =
        json['slot_start_time'] ?? json['appointment_start_time'];
    teamPatients = json['team_patients'] != null
        ? ChildTeamPatientsAppointment.fromJson(json['team_patients'])
        : null;
    if (json['team'] != null) {
      teamMember = <TeamMember>[];
      json['team'].forEach((v) {
        teamMember!.add(TeamMember.fromJson(v));
      });
    }
    print(json['doctor_details']);
    doctor = (json['doctor_details'] != null)
        ? (json['doctor_details']['doctor'] != null)
            ? ChildDoctorModel.fromJson(json['doctor_details']['doctor'])
            : ChildDoctorModel.fromJson(json['doctor_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['team_patient_id'] = teamPatientId;
    data['date'] = date;
    data['slot_start_time'] = slotStartTime;
    data['slot_end_time'] = slotEndTime;
    data['type'] = type;
    data['status'] = status;
    data['zoom_join_url'] = zoomJoinUrl;
    data['zoom_start_url'] = zoomStartUrl;
    data['zoom_id'] = zoomId;
    data['zoom_password'] = zoomPassword;
    data['kaleyra_user_url'] = kaleyraJoinurl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['kaleyra_success_team_id'] = kaleyraSuccessTeamId;
    data['appointment_date'] = appointmentDate;
    data['appointment_start_time'] = appointmentStartTime;
    if (teamPatients != null) {
      data['team_patients'] = teamPatients!.toJson();
    }
    if (teamMember != null) {
      data['team'] = teamMember!.map((v) => v.toJson()).toList();
    }
    if (doctor != null) {
      data['doctor_details'] = doctor!.toJson();
    }
    return data;
  }
}
