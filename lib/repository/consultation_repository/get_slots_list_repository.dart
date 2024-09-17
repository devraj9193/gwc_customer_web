

import '../api_service.dart';

class ConsultationRepository{
  ApiClient apiClient;

  ConsultationRepository({required this.apiClient}) : assert(apiClient != null);

  Future getAppointmentSlotListRepo(String selectedDate, {String? appointmentId}) async{
    return await apiClient.getAppointmentSlotListApi(selectedDate, appointmentId: appointmentId);
  }

  Future getPpcAppointmentSlotListRepo(String selectedDate,String doctorId) async{
    return await apiClient.getPpcAppointmentSlotListApi(selectedDate,doctorId);
  }

  Future bookAppointmentSlotListRepo(String date, String slotTime, String doctorId,{String? appointmentId, bool isPostprogram = false}) async{
    return await apiClient.bookAppointmentApi(date, slotTime, doctorId,appointmentId: appointmentId, isPostprogram: isPostprogram);
  }

  Future getAccessTokenRepo(String kaleyraUID) async{
    return await apiClient.getKaleyraAccessTokenApi(kaleyraUID);
  }

}