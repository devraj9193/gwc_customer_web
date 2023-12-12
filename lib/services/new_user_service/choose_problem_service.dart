import 'package:flutter/cupertino.dart';
import '../../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../../repository/new_user_repository/choose_problem_repository.dart';

class ChooseProblemService extends ChangeNotifier{
  late final ChooseProblemRepository repository;

  ChooseProblemService({required this.repository}) : assert(repository != null);

  Future<ChooseProblemModel> getProblems() async{
    return await repository.getProblemList();
  }

  Future postProblems(String deviceId, {List? problemList, String? otherProblem}) async{
    return await repository.postProblemList(deviceId, problemList: problemList, otherProblem: otherProblem);
  }
}