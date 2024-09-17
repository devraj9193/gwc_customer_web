import 'package:gwc_customer_web/repository/user_slot_for_schedule_repository/schedule_slot_repository.dart';

/// this is FollowUp Call Service
class GetUserScheduleSlotsForService{
  final ScheduleSlotsRepository repository;

  GetUserScheduleSlotsForService({required this.repository}) : assert(repository != null);

  /// to get the list of slots with date
  Future getSlotsDaysForScheduleService() async{
    return await repository.getSlotsDaysForScheduleRepo();
  }

  /// to get the list of slots for selected date
  Future getFollowUpSlotsScheduleService(String selectedDate,{String? appointmentId}) async{
    return await repository.getFollowUpSlotsScheduleRepo(selectedDate,appointmentId: appointmentId);
  }

  Future submitSlotSelectedService(Map data) async{
    return await repository.submitSlotSelectedRepo(data);
  }
}