import 'api_service.dart';

class EnquiryStatusRepository {
  ApiClient apiClient;

  EnquiryStatusRepository({required this.apiClient}) : assert(apiClient != null);

  Future enquiryStatusRepo(String deviceId) async{
    return await apiClient.enquiryStatusApi(deviceId);
  }
}