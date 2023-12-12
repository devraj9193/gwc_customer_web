class LocalStorageDashboardModel {
  String? consultStage;
  String? appointmentModel;
  String? consultStringModel;
  String? mrReport;
  String? prepStage;
  String? prepMealModel;
  String? prepStringModel;
  String? shippingStage;
  String? shippingModel;
  String? shippingStringModel;
  String? mealProgramStage;
  String? mealModel;
  String? mealStringModel;
  String? transStage;
  String? transModel;
  String? transStringModel;
  String? postProgramStage;
  String? postModel;
  String? postStringModel;

  LocalStorageDashboardModel(
      {this.consultStage,
        this.appointmentModel,
        this.consultStringModel,
        this.mrReport,
        this.prepStage,
        this.prepMealModel,
        this.prepStringModel,
        this.shippingStage,
        this.shippingModel,
        this.shippingStringModel,
        this.mealProgramStage,
        this.mealModel,
        this.mealStringModel,
        this.transStage,
        this.transModel,
        this.transStringModel,
        this.postProgramStage,
        this.postModel,
        this.postStringModel});

  LocalStorageDashboardModel.fromJson(Map<String, dynamic> json) {
    consultStage = json['consult_stage'];
    appointmentModel = json['appointment_model'];
    consultStringModel = json['consult_string_model'];
    mrReport = json['mr_report'];
    prepStage = json['prep_stage'];
    prepMealModel = json['prep_meal_model'];
    prepStringModel = json['prep_string_model'];
    shippingStage = json['shipping_stage'];
    shippingModel = json['shipping_model'];
    shippingStringModel = json['shipping_string_model'];
    mealProgramStage = json['meal_program_stage'];
    mealModel = json['meal_model'];
    mealStringModel = json['meal_string_model'];
    transStage = json['trans_stage'];
    transModel = json['trans_model'];
    transStringModel = json['trans_string_model'];
    postProgramStage = json['post_program_stage'];
    postModel = json['post_model'];
    postStringModel = json['post_string_model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consult_stage'] = this.consultStage;
    data['appointment_model'] = this.appointmentModel;
    data['consult_string_model'] = this.consultStringModel;
    data['mr_report'] = this.mrReport;
    data['prep_stage'] = this.prepStage;
    data['prep_meal_model'] = this.prepMealModel;
    data['prep_string_model'] = this.prepStringModel;
    data['shipping_stage'] = this.shippingStage;
    data['shipping_model'] = this.shippingModel;
    data['shipping_string_model'] = this.shippingStringModel;
    data['meal_program_stage'] = this.mealProgramStage;
    data['meal_model'] = this.mealModel;
    data['meal_string_model'] = this.mealStringModel;
    data['trans_stage'] = this.transStage;
    data['trans_model'] = this.transModel;
    data['trans_string_model'] = this.transStringModel;
    data['post_program_stage'] = this.postProgramStage;
    data['post_model'] = this.postModel;
    data['post_string_model'] = this.postStringModel;
    return data;
  }
}