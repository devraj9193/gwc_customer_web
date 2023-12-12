import 'package:gwc_customer_web/repository/rewards_repository/reward_repository.dart';

class RewardService{
  final RewardRepository repository;

  RewardService({required this.repository}) : assert(repository != null);

  /// to get the list and points of each rewards
  Future getRewardService() async{
    return await repository.getRewardRepo();
  }

  /// this function not using
  Future getRewardStagesService() async{
    return await repository.getRewardStagesRepo();
  }
}