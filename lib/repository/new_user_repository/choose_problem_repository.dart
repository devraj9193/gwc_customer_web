
import '../../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../../repository/api_service.dart';

class ChooseProblemRepository{
  ApiClient apiClient;

  ChooseProblemRepository({required this.apiClient}) : assert(apiClient != null);

  Future<ChooseProblemModel> getProblemList() async{
    return await apiClient.serverGetProblemList();
  }

  Future postProblemList(String deviceId, {List? problemList, String? otherProblem}) async{
    return await apiClient.submitProblemList(deviceId, problemList: problemList, otherProblem: otherProblem);
  }
}