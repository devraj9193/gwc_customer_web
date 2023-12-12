
import '../api_service.dart';

class MessageRepository{
  ApiClient apiClient;

  MessageRepository({required this.apiClient}) : assert(apiClient != null);

  Future getChatGroupIdRepo() async{
    return await apiClient.getChatGroupId();
  }
}