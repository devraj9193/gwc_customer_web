
import '../../repository/notification_repository/notification_repo.dart';

class NotificationService{
  final NotificationRepo repository;

  NotificationService({required this.repository}) : assert(repository != null);

  Future getNotificationListService() async{
    return await repository.getNotificationListRepo();
  }
}