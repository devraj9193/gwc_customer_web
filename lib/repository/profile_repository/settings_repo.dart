import '../../model/profile_model/terms_condition_model.dart';
import '../api_service.dart';

class SettingsRepository{
  ApiClient apiClient;

  SettingsRepository({required this.apiClient}) : assert(apiClient != null);

  Future<TermsConditionModel> getTermsCondition() async{
    return await apiClient.serverGetTermsAndCondition();
  }

  Future getCallSupportRepo() async{
    return await apiClient.serverGetCallSupportDetails();
  }

  Future getFaqListRepo() async{
    return await apiClient.getFaqListApi();
  }

  // ********** call support kaleyra ***************

  Future getAccessTokenRepo(String kaleyraUID) async{
    return await apiClient.getKaleyraAccessTokenApi(kaleyraUID);
  }

  // ***********************************************

}