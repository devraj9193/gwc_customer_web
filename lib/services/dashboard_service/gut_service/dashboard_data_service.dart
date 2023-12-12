import 'package:flutter/material.dart';

import '../../../repository/dashboard_repo/gut_repository/dashboard_repository.dart';

class GutDataService extends ChangeNotifier{
  late final GutDataRepository repository;

  GutDataService({required this.repository}) : assert(repository != null);

  Future getGutDataService() async{
    return await repository.getGutDataRepo();
  }
  Future submitIsMrReadService() async{
    return await repository.submitIsMrReadRepo();
  }
}