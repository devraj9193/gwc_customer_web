
import '../api_service.dart';

class HomeRepository{
  ApiClient apiClient;

  HomeRepository({required this.apiClient}) : assert(apiClient != null);

  Future getHomeDetailsRepo() async{
    return await apiClient.getHomeDetailsApi();
  }

  Future getBmiBmrRepo() async{
    return await apiClient.getBmiBmrApi();
  }

  Future submitBmiBmrRepo(String bmi,String bmr) async{
    return await apiClient.submitBmiBmrApi(bmi,bmr);
  }

  Future getGraphListRepo() async{
    return await apiClient.getGraphListApi();
  }

  Future getHealthTrackerRepo(Map trackerDetails) async{
    return await apiClient.submitGutHealthTrackerApi(trackerDetails);
  }

  Future getRemainderRepo() async{
    return await apiClient.getRemainderApi();
  }

  Future submitRemainderRepo(String waterTiming) async{
    return await apiClient.submitRemainderApi(waterTiming);
  }
}