import 'dart:ui';

const String consultationRescheduleStageSubText = "Please reschedule to another date & time that suits you.";
const String consultationStage2SubText = "Make sure to join your consultation within 5 minutes of your consultation time.";
const String consultationStage3SubText = "Your doctor's are hard at work customizing your program. This can take 48-72 hours. We'll notify you once ready.";

const String requestedReportStage1SubText = "Your doctor has requested for a few reports. Do upload them here to proceed further.";
const String requestedReportStage2SubText = "Thanks for uploading your reports.\nYour doctor is now analyzing your case, allow us 2 working days to proceed to the next step.";
const String requestedReportStage3SubText = "View all your reports related to program here.";

const String prepstageText = "Before your program starts we must prime your gut for the detox & healing it will undergo, Start preparing your gut now\nWhile we customize your plan & kit for your program over the next 2-3 days.";
const String prepStage2SubText = "Your kit is now ready to be shipped, schedule a date to have it delivered.";
const String prepStage3SubText = "Your kit will be dispatched soon. Keep prepping your gut until your kit arrives.\n";

const String shippingProcess1 = "Your kit is being processed & will be delivered on or as close to";
const String shippingProcess2 = "Please allow 1-2 days of variance.";

const String prepTrackerText = "Congrats on completing your preparation phase. Fill this tracker to update your doctor on your progress.";

const String mealStartText = "You are now ready to start your main gut reset program.";
const String mealTransText = "Congrats on completing your primary program. We now have to transition you back to regular food you are used to via the transition phase. Start now.";
// const String healingStartText = "You are now ready to start your Healing program.";

const String afterStartProgramText = "Keep the momentum going!";
const String stageCompletedSubText = "Completed";


const String PpcScheduleText = "Thanks for your feedback. Now please schedule your post program consultation with your doctor for a review.";
const String PpcBookedText = "Please ensure to join within 10 minutes of your consultation time.";
const String ppcAfterConsultationText= "Hope you had a pleasant consultation. Your doctors are now preparing your gut maintenance guide. We'll notify you once this is ready.";

List<DashboardStagesData> stageData = [
  DashboardStagesData(title:"Evaluation", subTitle:
    "Congrats on completing your evaluation. This will help us select the right doctor for you based on the details you have entered & will give us preliminary analysis on the direction in which must start your treatment.",
    rightImage: "assets/images/dashboard_stages/Evalutation.png",
    step: "1",
    btn1Name: "View",
    type: StageType.evaluation
  ),
  DashboardStagesData(title:"Consultation", subTitle:
  "Meet your doctor for a detailed consultation designed to understand the root cause of your condition & lay the ground work for your customized program creation.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
    step: "2",
    btn1Name: "Schedule",
    type: StageType.med_consultation
  ),
  DashboardStagesData(
      title:"Request Report",
      subTitle: "Your doctor has requested for a few reports. Do upload them here to proceed further.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
    step: "3",
    btn1Name: "Requested report",
      type: StageType.requested_report
  ),
  DashboardStagesData(
      title:"Analysis",
      subTitle: "Your doctor is now analyzing your case, allow us 2 working days to proceed to the next step. We'll send you a notification when ready.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "4",
      type: StageType.analysis
  ),
  DashboardStagesData(title:"Medical Report", subTitle:
  "Your doctor has completed the case analysis. Here is your medical report from your doctor",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "5",
      btn1Name: "Medical Report",
      type: StageType.medical_report
  ),
  DashboardStagesData(title:"Customizing Your Plan",
      subTitle: "Your program is being customized & created, we will notify you once this is ready. (Approx 48 hours).",
    rightImage: "assets/images/dashboard_stages/Mask Group 43509.png",
    step: "6",
    btn1Name: "Prep",
      btn2Name: "Ship Kit",
      type: StageType.prep_meal
  ),
  DashboardStagesData(title:"Gut Reset Program", subTitle:
  "Start your main gut reset program with a 2-3 day Preparation period to ensure your gut is all set to accept the detox, healing & rebalancing.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
    step: "7",
    btn1Name: "Start Program",
      type: StageType.normal_meal
  ),
  DashboardStagesData(title:"Post Program Consultation", subTitle:
  "Congrats on completing your gut reset program. We now have to reflect on your improvements, please do fill up your feedback form to initiate your post program consultation.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
    step: "8",
    // btn1Name: "Feedback",
    btn2Name: "Schedule",
      type: StageType.post_consultation
  ),
  DashboardStagesData(title:"GMG Program",
      subTitle:
  "Gut maintenance guide is your hand book to ensure a healthy gut for the years to come. We hope you are able to make the most of your learnings with us.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
    step: "9",
    btn1Name: "Program Analysis",
    btn2Name: "View GMG",
    // btn3Name: "View End report",
      type: StageType.gmg
  ),

];

List<DashboardStagesData> defaultStageData = [
  DashboardStagesData(title:"Evaluation", subTitle:
  "Congrats on completing your evaluation. This will help us select the right doctor for you based on the details you have entered & will give us preliminary analysis on the direction in which must start your treatment.",
      rightImage: "assets/images/dashboard_stages/Evalutation.png",
      step: "1",
      btn1Name: "View",
      type: StageType.evaluation
  ),
  DashboardStagesData(title:"Consultation", subTitle:
  "Meet your doctor for a detailed consultation designed to understand the root cause of your condition & lay the ground work for your customized program creation.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
      step: "2",
      btn1Name: "Schedule",
      type: StageType.med_consultation
  ),
  DashboardStagesData(
      title:"Request Report",
      subTitle: "Your doctor has requested for a few reports. Do upload them here to proceed further.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "3",
      btn1Name: "Requested report",
      type: StageType.requested_report
  ),
  DashboardStagesData(
      title:"Analysis",
      subTitle: "Your doctor is now analyzing your case, allow us 2 working days to proceed to the next step. We'll send you a notification when ready.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "4",
      type: StageType.analysis
  ),
  DashboardStagesData(title:"Medical Report", subTitle:
  "Your doctor has completed the case analysis. Here is your medical report from your doctor",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "5",
      btn1Name: "Medical Report",
      type: StageType.medical_report
  ),
  DashboardStagesData(title:"Customizing Your Plan",
      subTitle: "Your program is being customized & created, we will notify you once this is ready. (Approx 48 hours).",
      rightImage: "assets/images/dashboard_stages/Mask Group 43509.png",
      step: "6",
      btn1Name: "Prep",
      btn2Name: "Ship Kit",
      type: StageType.prep_meal
  ),
  DashboardStagesData(title:"Gut Reset Program", subTitle:
  "Start your main gut reset program with a 2-3 day Preparation period to ensure your gut is all set to accept the detox, healing & rebalancing.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
      step: "7",
      btn1Name: "Start Program",
      type: StageType.normal_meal
  ),
  DashboardStagesData(title:"Post Program Consultation", subTitle:
  "Congrats on completing your gut reset program. We now have to reflect on your improvements, please do fill up your feedback form to initiate your post program consultation.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
      step: "8",
      btn1Name: "Program Analysis",
      btn2Name: "Schedule",
      type: StageType.post_consultation
  ),
  DashboardStagesData(title:"GMG Program",
      subTitle:
      "Gut maintenance guide is your hand book to ensure a healthy gut for the years to come. We hope you are able to make the most of your learnings with us.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
      step: "9",
      // btn1Name: "View GMG",
      // // btn2Name: "View End report",
      // btn3Name: "Track & Earn",
      type: StageType.gmg
  ),

];

updateStageData(){
 stageData = defaultStageData;
}


class DashboardStagesData{
  String title;
  String subTitle;
  String rightImage;
  String step;
  String? btn1Name;
  // VoidCallback? btn1Tap;
  String? btn2Name;
  // VoidCallback? btn2Tap;
  String? btn3Name;
  // VoidCallback? btn3Tap;
  StageType type;
  Color? bgColor;
  Color? btn1Color;
  Color? btn2Color;
  Color? btn3Color;
  bool showCard;

  DashboardStagesData({
    required this.title,
    required this.subTitle,
    required this.rightImage,
    required this.step,
    this.btn1Name,
    // this.btn1Tap,
    this.btn2Name,
    // this.btn2Tap,
    this.btn3Name,
    // this.btn3Tap,
    required this.type,
    this.bgColor,
    this.btn1Color,
    this.btn2Color,
    this.btn3Color,
    this.showCard = true
});

}

enum StageType {
  evaluation,
  med_consultation,
  requested_report,
  analysis,
  medical_report,
  prep_meal,
  normal_meal,
  post_consultation,
  gmg
}
