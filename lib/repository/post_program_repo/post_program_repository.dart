import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
import '../api_service.dart';

class PostProgramRepository{
  ApiClient apiClient;

  PostProgramRepository({required this.apiClient}) : assert(apiClient != null);

  Future startPostProgramRepo() async{
    return await apiClient.startPostProgram();
  }

  Future getPPMealsOnStagesRepo(int stage,String day) async{
    return await apiClient.getPPMealsOnStagesApi(stage, day);
  }
  Future getLunchRepo(String day) async{
    return await apiClient.getLunchOnclickApi(day);
  }
  Future getDinnerRepo(String day) async{
    return await apiClient.getDinnerOnclickApi(day);
  }
  //not using
  Future submitPostProgramMealTrackingRepo(String mealType, int selectedType, int? dayNumber) async{
    return await apiClient.submitPostProgramMealTrackingApi(mealType, selectedType, dayNumber);
  }
  // new method
  Future submitPPMealsRepo(String stageType,String followId, int itemId, int? dayNumber) async{
    return await apiClient.submitPPMealsApi(stageType, followId, itemId, dayNumber);
  }

  /// not using
  Future getProtocolDayDetailsRepo({String? dayNumber}) async{
    return await apiClient.getProtocolDayDetailsApi(dayNumber: dayNumber);
  }

  Future getPPDayDetailsRepo({String? dayNumber}) async{
    return await apiClient.getPPDayDetailsApi(dayNumber: dayNumber);
  }

  Future getPPDaySummaryRepo(String dayNumber) async{
    return await apiClient.getPPDaySummaryApi(dayNumber);
  }

  /// new calender api
  Future getPPDayCalenderRepo() async{
    return await apiClient.getPPCalendarApi();
  }

}