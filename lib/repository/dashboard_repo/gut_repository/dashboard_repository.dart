import '../../api_service.dart';

class GutDataRepository{
  ApiClient apiClient;

  GutDataRepository({required this.apiClient}) : assert(apiClient != null);

  Future getGutDataRepo() async{
    return await apiClient.serverGetGutData();
  }
  Future submitIsMrReadRepo() async{
    return await apiClient.submitIsMrReadApi()();
  }

}