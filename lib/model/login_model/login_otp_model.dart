import 'dart:convert';

class LoginOtpModel {
  String? status;
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
    data['status'] = this.status.toString();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['user_kaleyra_id'] = this.kaleyraUserId;
    data['success_team_kaleyra_id'] = this.kaleyraSuccessId;
    data['user_status'] = this.userEvaluationStatus;
    data['chat_id'] = this.chatId;
    data['associated_success_member'] = this.associatedSuccessMemberKaleyraId;
    data['login_username'] = this.loginUsername;
    data['current_user'] = this.currentUser;
    data['uv_user_id'] = this.uvAgentId;
    data['uv_success_id'] = this.uvSuccessId;
    data['uv_api_access_token'] = this.uvApiAccessToken;
    data['support_number'] = this.supportNumber;
    return data;
  }
}

LoginOtpModel loginOtpFromJson(String str) =>
    LoginOtpModel.fromJson(json.decode(str));

String loginOtpToJson(LoginOtpModel data) => json.encode(data.toJson());
