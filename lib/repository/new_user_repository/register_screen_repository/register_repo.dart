
import '../../api_service.dart';

class RegisterRepo{
  ApiClient apiClient;

  RegisterRepo({required this.apiClient}) : assert(apiClient != null);

  Future registerUserRepo({required String name, required int age, required String gender, required String email,required String countryCode, required String phone, required String deviceId, required String fcmToken}) async{
    return await apiClient.serverRegisterUser(name: name, age: age, gender: gender, email: email, countryCode: countryCode, phone: phone, deviceId: deviceId, fcmToken: fcmToken);
  }
}