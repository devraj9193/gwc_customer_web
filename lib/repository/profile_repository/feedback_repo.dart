import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';

import '../../model/profile_model/terms_condition_model.dart';
import '../api_service.dart';

class FeedbackRepository{
  ApiClient apiClient;

  FeedbackRepository({required this.apiClient}) : assert(apiClient != null);

  Future submitFeedbackRepo(Map feedback, List<PlatformFile> files) async{
    return await apiClient.submitUserFeedbackDetails(feedback, files);
  }
}