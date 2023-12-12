import '../../repository/api_service.dart';

class LoginOtpRepository{
  ApiClient apiClient;

  LoginOtpRepository({required this.apiClient}) : assert(apiClient != null);

  Future loginWithOtpRepo(String phone, String otp, String fcm) async{
    return await apiClient.serverLoginWithOtpApi(phone, otp, fcm);
  }

  Future getOtpRepo(String phone) async{
    return await apiClient.serverGetOtpApi(phone);
  }

  Future logoutRepo() async{
    return await apiClient.serverLogoutApi();
  }

  Future getAccessTokenRepo(String kaleyraUID) async{
    return await apiClient.getKaleyraAccessTokenApi(kaleyraUID);
  }
}