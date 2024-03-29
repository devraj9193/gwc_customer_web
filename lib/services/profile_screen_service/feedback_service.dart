import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../../repository/profile_repository/feedback_repo.dart';

class FeedbackService extends ChangeNotifier{
  final FeedbackRepository repository;

  FeedbackService({required this.repository}) : assert(repository != null);

  Future submitFeedbackService(Map feedback, List<PlatformFile> files) async{
    return await repository.submitFeedbackRepo(feedback, files);
  }
}