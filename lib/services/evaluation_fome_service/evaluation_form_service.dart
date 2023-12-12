import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import '../../repository/evaluation_form_repository/evanluation_form_repo.dart';

class EvaluationFormService extends ChangeNotifier{
  final EvaluationFormRepository repository;

  EvaluationFormService({required this.repository}) : assert(repository != null);

  Future submitEvaluationFormService(Map form, List<PlatformFile>? medicalReports) async{
    return await repository.submitEvaluationFormRepo(form, medicalReports);
  }

  Future getEvaluationDataService() async{
    return await repository.getEvaluationDataRepo();
  }
  Future getCountryDetailsService(String pinCode, String countryCode) async{
    return await repository.getCountryDetailsRepo(pinCode, countryCode);
  }


}