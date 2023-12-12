import 'package:flutter/material.dart';
import 'package:gwc_customer_web/repository/program_repository/program_repository.dart';

import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
import '../../repository/post_program_repo/post_program_repository.dart';

class PostProgramService extends ChangeNotifier{
  final PostProgramRepository repository;

  PostProgramService({required this.repository}) : assert(repository != null);

  Future startPostProgramService() async{
    return await repository.startPostProgramRepo();
  }
  Future getPPMealsOnStagesService(int stage, String day,) async{
    return await repository.getPPMealsOnStagesRepo(stage, day);
  }
///not using
  Future submitPostProgramMealTrackingService(String mealType, int selectedType, int? dayNumber) async{
    return await repository.submitPostProgramMealTrackingRepo(mealType, selectedType, dayNumber);
  }
  // new submmit method
  // followId==> 1-> do and 2-> do not
  Future submitPPMealsService(String stageType,String followId, int itemId, int? dayNumber) async{
    return await repository.submitPPMealsRepo(stageType, followId, itemId, dayNumber);
  }
  /// not using
  Future getProtocolDayDetailsService({String? dayNumber}) async{
    return await repository.getProtocolDayDetailsRepo(dayNumber: dayNumber);
  }

  /// new
  Future getPPDayDetailsService({String? dayNumber}) async{
    return await repository.getPPDayDetailsRepo(dayNumber: dayNumber);
  }
  /// new
  Future getPPDaySummaryService(String dayNumber) async{
    return await repository.getPPDaySummaryRepo(dayNumber);
  }
  /// new
  Future getPPDayCalenderService() async{
    return await repository.getPPDayCalenderRepo();
  }

}