
import '../api_service.dart';

class ShiftSlotsRepository{
  ApiClient apiClient;

  ShiftSlotsRepository({required this.apiClient});

  Future getConsultationSlotsRepo(String selectedDate) async{
    return await apiClient.getConsultationSlotsApi(selectedDate);
  }

  Future getShiftSlotsRepo(String selectedDate,String shiftType,String doctorId) async{
    return await apiClient.getShiftSlotsApi(selectedDate,shiftType,doctorId);
  }

}