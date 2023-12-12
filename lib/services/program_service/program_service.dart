import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer_web/repository/program_repository/program_repository.dart';
import 'package:http/http.dart';

import '../../model/program_model/proceed_model/send_proceed_program_model.dart';

class ProgramService extends ChangeNotifier{
  final ProgramRepository repository;

  ProgramService({required this.repository}) : assert(repository != null);

  Future getMealProgramDaysService() async{
    return await repository.getMealProgramDaysRepo();
  }

  /// need to pass day like 1,2,3......
  Future getMealPlanDetailsService(String day) async{
    return await repository.getMealPlanDetailsRepo(day);
  }

  Future proceedDayMealDetailsService(ProceedProgramDayModel day, List<PlatformFile> files, String from,List<PlatformFile> mandatoryFile,) async{
    return await repository.proceedDayMealDetailsRepo(day, files, from,mandatoryFile);
  }

  /// pass startProgram=1
  Future startProgramOnSwipeService(String startProgram) async{
    return await repository.startProgramOnSwipeRepo(startProgram);
  }

  Future getCombinedMealService() async{
    return await repository.getCombinedMealRepo();
  }
}