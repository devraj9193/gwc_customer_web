import 'package:gwc_customer_web/repository/api_service.dart';

class RewardRepository{
  ApiClient apiClient;

  RewardRepository({required this.apiClient}) : assert(apiClient != null);

  Future getRewardRepo() async{
    return await apiClient.getRewardPointsApi();
  }

  Future getRewardStagesRepo() async{
    return await apiClient.getRewardPointsStagesApi();
  }
}