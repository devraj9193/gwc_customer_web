import '../api_service.dart';

class ChiefQuestionRepo{
  ApiClient apiClient;

  ChiefQuestionRepo({required this.apiClient});

  Future getChiefQuestionListRepo() async{
    return await apiClient.getChiefQuestionsListApi();
  }

  Future submitChiefQuestionAnswerRepo(Map answers) async{
    return await apiClient.submitChiefQuestionAnswerApi(answers);
  }

  Future submitPollQuestionAnswerRepo(Map answers) async{
    return await apiClient.submitPollQuestionAnswerApi(answers);
  }
}