import 'app_config.dart';

/// new API's
var getProblemListUrl = "${AppConfig().BASE_URL}/api/list/problem_list";

var submitProblemListUrl = "${AppConfig().BASE_URL}/api/form/submit_problems";

var getAboutProgramUrl = "${AppConfig().BASE_URL}/api/list/welcome_screen";

var registerUserUrl = "${AppConfig().BASE_URL}/api/register";

/// shiprocket Api
var shippingApiLoginUrl = "${AppConfig().shipRocket_AWB_URL}/auth/login";

var shipRocketTrackingApiUrl =
    "${AppConfig().BASE_URL}/api/getData/shiprocket_tracking";

var shippingApiUrl = "${AppConfig().shipRocket_AWB_URL}/courier/track/awb";

var shoppingListApiUrl =
    "${AppConfig().BASE_URL}/api/getData/get_shopping_list";

var shoppingApproveApiUrl =
    "${AppConfig().BASE_URL}/api/submitForm/update_shipping_approval";

var loginWithOtpUrl = "${AppConfig().BASE_URL}/api/otp_login";

var logOutUrl = "${AppConfig().BASE_URL}/api/logout";

var getOtpUrl = "${AppConfig().BASE_URL}/api/sendOTP";

var getAppointmentSlotsListUrl = "${AppConfig().BASE_URL}/api/getData/slots/";

var bookAppointmentUrl =
    "${AppConfig().BASE_URL}/api/getData/bookOnlineAppointment";
// "getData/book";

var enquiryStatusUrl = "${AppConfig().BASE_URL}/api/form/check_enquiry_status";

var submitEvaluationFormUrl =
    "${AppConfig().BASE_URL}/api/submitForm/evaluation_form";

var getPinCodeFormApiUrl = "${AppConfig().BASE_URL}/api/getData/pincode";

var getEvaluationDataUrl =
    "${AppConfig().BASE_URL}/api/getData/get_evaluation_data";

var getDashboardDataUrl =
    "${AppConfig().BASE_URL}/api/getData/get_dashboard_data";

var getUserProfileUrl = "${AppConfig().BASE_URL}/api/user";

var updateUserProfileUrl =
    "${AppConfig().BASE_URL}/api/submitForm/update_user_profile";

var termsConditionUrl = "${AppConfig().BASE_URL}/api/list/terms_and_conditions";

var uploadReportUrl = "${AppConfig().BASE_URL}/api/submitForm/user_report";

var getUserReportListUrl =
    "${AppConfig().BASE_URL}/api/getData/user_reports_list";
var getMealProgramDayListUrl =
    "${AppConfig().BASE_URL}/api/listData/user_program_details";

/// need to pass day number 1,2,3 ....
var getMealPlanDataUrl =
    "${AppConfig().BASE_URL}/api/getDataList/user_day_meal_plan";

var submitDayPlanDetailsUrl =
    "${AppConfig().BASE_URL}/api/submitData/patient_meal_tracking";

var submitMealPlanTrackerUrl =
    "${AppConfig().BASE_URL}/api/submitData/online_patient_meal_tracking";

/// feedback Url
var submitFeedbackUrl = "${AppConfig().BASE_URL}/api/submitForm/feedback";

var getCallSupportUrl = "${AppConfig().BASE_URL}/api/getData/call_support";

var startProgramOnSwipeUrl =
    "${AppConfig().BASE_URL}/api/submitForm/start_program";

var chatGroupIdUrl =
    "${AppConfig().BASE_URL}/api/getData/get_chat_messages_group";

/// this is called after all 15 days completed than on click on next clap ui we need to hit this api
var startPostProgramUrl = "${AppConfig().BASE_URL}/api/submitForm/post_program";

var submitPostProgramMealTrackingUrl =
    "${AppConfig().BASE_URL}/api/submitData/post_program_meal_tracking";

var getPPEarlyMorningUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/early_morning";

var getPPBreakfastUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/breakfast";

var getPPMidDayUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/mid_day";

var getPPLunchUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/lunch";

var getPPEveningUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/evening";

var getPPDinnerUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/dinner";

var getPPPostDinnerUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/post_dinner";

/// this is called on protocol home page and also
/// if user already submited details based on the day selection details will get
var getProtocolDayDetailsUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_day_score";

var doctorRequestedReportListUrl =
    "${AppConfig().BASE_URL}/api/getData/requested_reports_list/doctor_requested_reports";

var submitDoctorRequestedReportUrl =
    "${AppConfig().BASE_URL}/api/submitForm/requested_user_report";

var submitUserReportUploadUrl =
    "${AppConfig().BASE_URL}/api/submitForm/report_upload";

var notificationListUrl =
    "${AppConfig().BASE_URL}/api/getData/notification_list";

var rewardPointsUrl =
    "${AppConfig().BASE_URL}/api/getDataList/get_user_reward_points";

var rewardPointsStagesUrl =
    "${AppConfig().BASE_URL}/api/getDataList/user_stages_levels";

var faqListUrl = "${AppConfig().BASE_URL}/api/getDataList/faq_list";

// var submitStatusTrackerUrl = "${AppConfig().BASE_URL}/api/submitData/patient_meal_tracking";

var getHomeDetailsUrl =
    "${AppConfig().BASE_URL}/api/getDataList/user_stages_data";

var daySummaryUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_summary";

var ppCalendarUrl =
    "${AppConfig().BASE_URL}/api/getDataList/protocol_meal_tracking_calendar";

/// to get the list of prepratory meal list
var prepratoryMealUrl =
    "${AppConfig().BASE_URL}/api/getDataList/user_prep_meal_plan";

var transitionMealUrl =
    "${AppConfig().BASE_URL}/api/getDataList/user_trans_meal_plan";

var submitPrepratoryMealTrackUrl =
    "${AppConfig().BASE_URL}/api/submitForm/prep_meal_submit";
//var submitPrepratoryMealTrackUrl = "${AppConfig().BASE_URL}/api/getData/prep_meal_submit";

var getPrepratoryMealTrackUrl =
    "${AppConfig().BASE_URL}/api/getDataList/tracking_prep_meal";

var submitTransMealTrackingUrl =
    "${AppConfig().BASE_URL}/api/submitData/trans_meal_tracking";

var getUserSlotDaysForScheduleUrl =
    "${AppConfig().BASE_URL}/api/getData/user_slot_days";

var getFollowUpSlotUrl = "${AppConfig().BASE_URL}/api/getData/followup_slots/";

var getPpcAppointmentSlotUrl =
    "${AppConfig().BASE_URL}/api/postCETData/getPPCDoctorSlots";
// "/api/getData/ppc_followup_slots/";

var submitSlotSelectedUrl =
    "${AppConfig().BASE_URL}/api/submitForm/follow_up_book";

var homeRemediesUrl = "${AppConfig().BASE_URL}/api/list/home_remedies";

var submitMedicalFeedbackFormUrl =
    "${AppConfig().BASE_URL}/api/submitForm/medical_feedback";

var submitProgramFeedbackFormUrl =
    "${AppConfig().BASE_URL}/api/submitForm/program_feedback";

var mrReadUrl = "${AppConfig().BASE_URL}/api/getData/is_mr_report_read";

var getMedicalFeedbackDataUrl =
    "${AppConfig().BASE_URL}/api/getData/medical_feedback";

var submitGutDiagnosisFormUrl =
    "${AppConfig().BASE_URL}/api/submitForm/post_gut_type_diagnosis";

var getGutDiagnosisUrl =
    "${AppConfig().BASE_URL}/api/getData/get_gut_type_diagnosis";

var getConsultationSlotsUrl =
    "${AppConfig().BASE_URL}/api/getDataValue/get_unique_slots";

var getShiftSlotsUrl = "${AppConfig().BASE_URL}/api/get_shift_slots";

// Neutri Delight
var getCombinedMealUrl =
    "${AppConfig().BASE_URL}/api/getData/getMasterMealPlans";
// "${AppConfig().BASE_URL}/api/getData/getMealPlans1";
// "${AppConfig().BASE_URL}/api/getData/getMealPlans";
// "${AppConfig().BASE_URL}/api/getData/NutriDelight";

var getUserYogaListUrl =
    "${AppConfig().BASE_URL}/api/getData/getYogaList/";

/// home screen meal progress graph api
var getGraphUrl = "${AppConfig().BASE_URL}/api/listData/progress";

var submitGutHealthTrackerUrl =
    "${AppConfig().BASE_URL}/fem_SaveToolsEvaluation_v1";

var getBmiBmrUrl = "${AppConfig().BASE_URL}/api/getData/get_BMI_BMR";

var submitBmiBmrUrl = "${AppConfig().BASE_URL}/api/submitForm/post_BMI_BMR";

var getRemainderUrl = '${AppConfig().BASE_URL}/api/getData/get_water_reminder';

var submitRemainderUrl =
    '${AppConfig().BASE_URL}/api/submitForm/water_reminder';

var ticketChatApiUrl = '${AppConfig().BASE_URL}/api/getData/track_ticket';

var ticketChatSendApiUrl =
    '${AppConfig().BASE_URL}/api/submitForm/reply_message';

// *************** uvdesk apis *****************
/*
1. list of tickets - https://fembuddy.uvdesk.com/en/api/tickets.json?page=1
2. Ticket details - https://fembuddy.uvdesk.com/en/api/ticket/3.json
3. Threads list - https://fembuddy.uvdesk.com/en/api/ticket/2026155/threads.json
4. Create ticket - https://fembuddy.uvdesk.com/en/api/tickets.json  (type - int, name, from, reply, subject)
5. send a reply - https://fembuddy.uvdesk.com/en/api/ticket/2026552/threads.json (threadType, reply)

 */

// new url
const String uvDesk_baseUrl = "https://support.gutandhealth.com/public/api/v1/";
// "https://uvteam.disol.in/public/api/v1/";

// old url
// const String uvDesk_baseUrl = "https://fembuddy.uvdesk.com/en/api";

// old admin token 040561E3F817A9F9BAA36C50CFF8D0EF41072040561E3F817A9F9BAA36C50CFF8D0EF
/// for getting ticket list/details/ ticket details
// String agentToken = "Bearer 8A07DDBDF6672807F8B4D261E5673500599238A07DDBDF6672807F8B4D261E5673500";

/// using same token for new domain  (uvteam.disol.in)
final _pref = AppConfig().preferences;
// String agentToken = "Bearer ${_pref?.getString(AppConfig.UV_API_ACCESS_TOKEN)}";
// "Bearer HBTCAEHAAAOTTVECVMNJGLWYVXVN3GBJUR0XVZNOJTO4N1Y4LD7LT3LE4PVONODF";

// old agent token 478CBD3B1BD2E2062AE52C0D39D36FF248787478CBD3B1BD2E2062AE52C0D39D36FF2

/// for create/reply ticket we need to use this token
// String adminToken = "Bearer 8E63BC73D879BC04717ECBCCE59BADE4424488E63BC73D879BC04717ECBCCE59BADE4";
// https://fembuddy.uvdesk.com/en/api/tickets.json?customer=1795084
/// to get the ticket list from customer
const String ticketListByCustomerId = "/tickets.json?customer=";

/// this is to create ticket, get list
/// for create make post call
/// for get list make get call
const String ticketListApiPath = "tickets";

const String myProfileApiPath = "/me.json";

/// need to pass increment id -> /ticket/{increment_id}.json
const String ticketDetailsPath = "ticket/";

/// POST
const String createTicketPath = "ticket";

/// this is used to get reply details and also for give reply
/// use post to add reply
/// use get to get details
/// need to pass increment id -> /ticket/{ticketid}/thread.json

const String ticketReplyPath = "ticket/";

getTicketReplyPath(String id) {
  return '${ticketReplyPath + id}/thread';
}

// ************** end of uvdesk api ********

//  old apis
// var welcomeTextUrl = "${AppConfig().BASE_URL}/api/list/welcome_text";
// var postLoginUrl = "${AppConfig().BASE_URL}/login";
// var termsConditionUrl =
//     "${AppConfig().BASE_URL}/api/list/terms_and_conditions";
// var getProblemListUrl = "${AppConfig().BASE_URL}/api/list/problem_list";
// var submitProblemListUrl = "${AppConfig().BASE_URL}/api/form/submit_problems";

// var getThankYouTextUrl = "${AppConfig().BASE_URL}/api/list/thank_you_text";
// var getDocumentTextUrl = "${AppConfig().BASE_URL}/api/list/document_text";
// var registerUserUrl = "${AppConfig().BASE_URL}/api/register";
// var sendOTPUrl = "${AppConfig().BASE_URL}/api/sendOTP";
// var validateOTPUrl = "${AppConfig().BASE_URL}/api/validateOTP";
// var getProgramDetailsUrl =
//     "${AppConfig().BASE_URL}/api/getData/get_program_details";
// var sendPaymentIdUrl = "${AppConfig().BASE_URL}/api/submitForm/payment";
// var getAppointmentSlotsListUrl = "${AppConfig().BASE_URL}/api/getData/slots/";
// var bookAppointmentUrl = "${AppConfig().BASE_URL}/api/getData/book";
// var uploadReportUrl = "${AppConfig().BASE_URL}/api/submitForm/user_report";
// var getUserReportListUrl =
//     "${AppConfig().BASE_URL}/api/getData/user_reports_list";
// var submitEvaluationFormUrl =
//     "${AppConfig().BASE_URL}/api/submitForm/evaluation_form";
// var getUserProfileUrl = "${AppConfig().BASE_URL}/api/user";
