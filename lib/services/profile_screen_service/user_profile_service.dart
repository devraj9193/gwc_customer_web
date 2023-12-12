import 'package:flutter/cupertino.dart';

import '../../repository/profile_repository/get_user_profile_repo.dart';

class UserProfileService extends ChangeNotifier{
  final UserProfileRepository repository;

  UserProfileService({required this.repository}) : assert(repository != null);

  Future getUserProfileService() async{
    return await repository.getUserProfileRepo();
  }

  Future updateUserProfileService(Map user) async{
    return await repository.updateUserProfileRepo(user);
  }
}