
import '../api_service.dart';

class AboutProgramRepository{
  ApiClient apiClient;

  AboutProgramRepository({required this.apiClient}) : assert(apiClient != null);

  Future serverAboutProgramRepo() async{
    return await apiClient.serverGetAboutProgramDetails();
  }

}