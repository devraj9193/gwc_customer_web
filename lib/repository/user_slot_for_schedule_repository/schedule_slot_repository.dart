
import '../api_service.dart';

class ScheduleSlotsRepository{
  ApiClient apiClient;

  ScheduleSlotsRepository({required this.apiClient}) : assert(apiClient != null);

  Future getSlotsDaysForScheduleRepo() async{
    return await apiClient.getSlotsDaysForScheduleApi();
  }

  Future getFollowUpSlotsScheduleRepo(String selectedDate,{String? appointmentId}) async{
    return await apiClient.getFollowUpSlotsApi(selectedDate,appointmentId: appointmentId);
  }

  Future submitSlotSelectedRepo(Map data) async {
    return await apiClient.submitSlotSelectedApi(data);
  }

  }