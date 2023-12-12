import 'package:http/http.dart';

import '../../model/profile_model/terms_condition_model.dart';
import '../api_service.dart';

class FeedbackRepository{
  ApiClient apiClient;

  FeedbackRepository({required this.apiClient}) : assert(apiClient != null);

  Future submitFeedbackRepo(Map feedback, List<MultipartFile> files) async{
    return await apiClient.submitUserFeedbackDetails(feedback, files);
  }
}