import 'package:flutter/cupertino.dart';
import '../../../repository/new_user_repository/register_screen_repository/register_repo.dart';

class UserRegisterService extends ChangeNotifier{
  late final RegisterRepo registerRepo;

  UserRegisterService({required this.registerRepo}) : assert(registerRepo != null);

  Future registerUserService({required String name, required int age, required String gender, required String email, required String countryCode, required String phone, required String deviceId, required String fcmToken}) async{
    return await registerRepo.registerUserRepo(name: name, age: age, gender: gender, email: email,countryCode: countryCode, phone: phone, deviceId: deviceId, fcmToken: fcmToken);
  }

}