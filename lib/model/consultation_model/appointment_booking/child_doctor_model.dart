import 'child_specialization_model.dart';
import 'child_user.dart';

class ChildDoctorModel {
  String? doctorId;
  String? userId;
  String? signupDate;
  String? experience;
  String? weekoff;
  String? desc;
  String? programAssociated;
  String? occupation;
  ChildSpecialization? specialization;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  ChildUser? user;

  ChildDoctorModel(
      {this.doctorId,
        this.userId,
        this.signupDate,
        this.experience,
        this.weekoff,
        this.desc,
        this.programAssociated,
        this.occupation,
        this.specialization,
        this.isArchieved,
        this.createdAt,
        this.updatedAt,
        this.user});

  ChildDoctorModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['id'].toString();
    userId = json['user_id'].toString();
    signupDate = json['signup_date'];
    experience = json['experience'];
    weekoff = json['weekoff'].toString();
    desc = json['desc'];
    programAssociated = json['program_associated'].toString();
    occupation = json['occupation'];
    specialization = json['specialization'] != null
        ? new ChildSpecialization.fromJson(json['specialization'])
        : null;
    isArchieved = json['is_archieved'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new ChildUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.doctorId;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

