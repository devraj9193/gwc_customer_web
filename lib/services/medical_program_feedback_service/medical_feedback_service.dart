import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../repository/medical_program_feedback_repo/medical_feedback_repo.dart';

class MedicalFeedbackService extends ChangeNotifier {
  late final FeedbackRepo feedbackRepo;

  MedicalFeedbackService({required this.feedbackRepo});

  Future submitMedicalFeedbackService({
    required String resolvedDigestiveIssue,
    required String unresolvedDigestiveIssue,
    required String mealPreferences,
    required String hungerPattern,
    required String bowelPattern,
    required String lifestyleHabits,
  }) async {
    return await feedbackRepo.medicalFeedbackRepo(
      resolvedDigestiveIssue: resolvedDigestiveIssue,
      unresolvedDigestiveIssue: unresolvedDigestiveIssue,
      mealPreferences: mealPreferences,
      hungerPattern: hungerPattern,
      bowelPattern: bowelPattern,
      lifestyleHabits: lifestyleHabits,
    );
  }

  Future submitProgramFeedbackService({
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
    return await feedbackRepo.programFeedbackRepo(
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


  Future getMedicalFeedbackService() async{
    return await feedbackRepo.getMedicalFeedbackRepo();
  }

  Future submitGutDiagnosisService(Map formDetails) async {
    return await feedbackRepo.submitGutDiagnosisRepo(formDetails);
  }

  Future getGutDiagnosisService() async{
    return await feedbackRepo.getGutDiagnosisRepo();
  }
}
