import 'package:flutter/material.dart';

import '../../repository/home_remedies_repository/home_remedies_repository.dart';

class HomeRemediesService extends ChangeNotifier {
  final HomeRemediesRepository repository;

  HomeRemediesService({required this.repository}) : assert(repository != null);

  Future getHomeRemediesService() async{
    return await repository.getHomeRemediesRepo();
  }
}