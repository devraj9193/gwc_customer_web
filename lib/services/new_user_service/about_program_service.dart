import 'package:flutter/cupertino.dart';

import '../../repository/new_user_repository/about_program_repository.dart';

class AboutProgramService extends ChangeNotifier{
  late final AboutProgramRepository repository;

  AboutProgramService({required this.repository}) : assert(repository != null);

  Future serverAboutProgramService() async{
    return await repository.serverAboutProgramRepo();
  }
}