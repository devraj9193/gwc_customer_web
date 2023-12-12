import 'package:flutter/cupertino.dart';
import 'package:gwc_customer_web/repository/home_repo/home_repository.dart';

class HomeService extends ChangeNotifier{
  final HomeRepository repository;

  HomeService({required this.repository}) : assert(repository != null);

  Future getHomeDetailsService() async{
    return await repository.getHomeDetailsRepo();
  }

  Future getBmiBmrService() async {
    return await repository.getBmiBmrRepo();
  }

  Future submitBmiBmrService(String bmi,String bmr) async {
    return await repository.submitBmiBmrRepo(bmi,bmr);
  }

  Future getGraphService() async{
    return await repository.getGraphListRepo();
  }

  Future gutHealthTrackerService(Map trackerDetails) async{
    return await repository.getHealthTrackerRepo(trackerDetails);
  }

  Future getRemainderService() async {
    return await repository.getRemainderRepo();
  }

  Future submitRemainderService(String waterTiming) async {
    return await repository.submitRemainderRepo(waterTiming);
  }
}