
import '../api_service.dart';

class NotificationRepo{
  ApiClient apiClient;

  NotificationRepo({required this.apiClient}) : assert(apiClient != null);

  Future getNotificationListRepo() async{
    return await apiClient.getNotificationListApi();
  }
}