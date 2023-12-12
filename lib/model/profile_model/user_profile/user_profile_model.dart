import 'child_user_model.dart';

class UserProfileModel {
  String? status;
  String? errorCode;
  String? key;
  ChildUserModel? data;
  String? associatedSuccessMemberKaleyraId;
  String? height;
  String? weight;
  String? ticketId;

  UserProfileModel({this.status, this.errorCode, this.key, this.data,
    this.associatedSuccessMemberKaleyraId
  });

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    key = json['key'];
    data = json['data'] != null ? ChildUserModel.fromJson(json['data']) : null;
    associatedSuccessMemberKaleyraId = json['associated_success_member'].toString();
    height = json['height'].toString();
    weight = json['weight'].toString();
    ticketId = json['ticket_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['ticket_id'] = this.ticketId;
    data['associated_success_member'] = this.associatedSuccessMemberKaleyraId;
    return data;
  }
}
