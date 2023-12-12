import 'package:file_picker/file_picker.dart';

import '../api_service.dart';
import 'package:http/http.dart';

class FeedbackRepo {
  ApiClient apiClient;

  FeedbackRepo({required this.apiClient}) : assert(apiClient != null);

  Future medicalFeedbackRepo({
    required String resolvedDigestiveIssue,
    required String unresolvedDigestiveIssue,
    required String mealPreferences,
    required String hungerPattern,
    required String bowelPattern,
    required String lifestyleHabits,
  }) async {
    return await apiClient.submitMedicalFeedbackForm(
      resolvedDigestiveIssue: resolvedDigestiveIssue,
      unresolvedDigestiveIssue: unresolvedDigestiveIssue,
      mealPreferences: mealPreferences,
      hungerPattern: hungerPattern,
      bowelPattern: bowelPattern,
      lifestyleHabits: lifestyleHabits,
    );
  }

  Future programFeedbackRepo({
    required int programStatus,
    required String changesAfterProgram,
    required String otherChangesAfterProgram,
    required String didProgramHeal,
    required String stickToPlan,
    required String mealPlanEasyToFollow,
    required String yogaPlanEasyToFollow,
    required String commentsOnMealYogaPlans,
    required String programPositiveHighlights,
    required String programNegativeHighlights,
    required String infusions,
    required String soups,
    required String porridges,
    required String podi,
    required String kheer,
    required String kitItemsImproveSuggestions,
    required String supportFromDoctors,
    required String supportInWhatsappGroup,
    required String homeRemediesDuringProgram,
    required String improvementAndSuggestions,
    required String programImproveHealthAnotherWay,
    required String briefTestimonial,
    required String referProgram,
    required String membership,
    required List<PlatformFile> faceToFeedback,
    required String reasonOfProgramDiscontinue,
  }) async {
    return await apiClient.sumbitProgramFeedbackForm(
      programStatus: programStatus,
      changesAfterProgram: changesAfterProgram,
      otherChangesAfterProgram: otherChangesAfterProgram,
      didProgramHeal: didProgramHeal,
      stickToPlan: stickToPlan,
      mealPlanEasyToFollow: mealPlanEasyToFollow,
      yogaPlanEasyToFollow: yogaPlanEasyToFollow,
      commentsOnMealYogaPlans: commentsOnMealYogaPlans,
      programPositiveHighlights: programPositiveHighlights,
      programNegativeHighlights: programNegativeHighlights,
      infusions: infusions,
      soups: soups,
      porridges: porridges,
      podi: podi,
      kheer: kheer,
      kitItemsImproveSuggestions: kitItemsImproveSuggestions,
      supportFromDoctors: supportFromDoctors,
      supportInWhatsappGroup: supportInWhatsappGroup,
      homeRemediesDuringProgram: homeRemediesDuringProgram,
      improvementAndSuggestions: improvementAndSuggestions,
      programImproveHealthAnotherWay: programImproveHealthAnotherWay,
      briefTestimonial: briefTestimonial,
      referProgram: referProgram,
      membership: membership,
      faceToFeedback: faceToFeedback,
      reasonOfProgramDiscontinue: reasonOfProgramDiscontinue,
    );
  }


  Future getMedicalFeedbackRepo() async{
    return await apiClient.serverGetMedicalFeedbackDetails();
  }

  Future submitGutDiagnosisRepo(Map formDetails) async {
    return await apiClient.submitGutDiagnosisApi(formDetails);
  }

  Future getGutDiagnosisRepo() async{
    return await apiClient.getDiagnosisDetailsApi();
  }
}
