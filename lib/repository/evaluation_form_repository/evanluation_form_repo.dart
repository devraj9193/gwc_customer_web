import 'package:file_picker/file_picker.dart';

import '../api_service.dart';

class EvaluationFormRepository{
  ApiClient apiClient;

  EvaluationFormRepository({required this.apiClient}) : assert(apiClient != null);

  Future submitEvaluationFormRepo(Map form, List<PlatformFile>? medicalReports) async{
    return await apiClient.submitEvaluationFormApi(form, medicalReports);
  }

  Future getEvaluationDataRepo() async{
    return await apiClient.serverGetEvaluationDetails();
  }

  Future getCountryDetailsRepo(String pinCode, String countryCode) async{
    return await apiClient.getPinCodeDetails(pinCode, countryCode);
  }
}