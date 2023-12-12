class StartProgramOnSwipeModel {
  int? status;
  int? errorCode;
  Response? response;

  StartProgramOnSwipeModel({this.status, this.errorCode, this.response});

  StartProgramOnSwipeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  int? id;
  String? userId;
  String? programId;
  String? isActive;
  String? startProgram;
  String? createdAt;
  String? updatedAt;
  String? spDate;
  String? spCurrentDay;
  String? prepDays;
  String? prepExtended;
  String? prepProgram;
  String? ppDate;
  String? ppCurrentDay;
  bool? isPrepCompleted;
  String? transDays;
  String? transProgram;
  String? tpDate;
  String? tpCurrentDay;
  bool? isTransCompleted;


  Response(
      {this.id,
        this.userId,
        this.programId,
        this.isActive,
        this.startProgram,
        this.spDate,
        this.spCurrentDay,
        this.prepDays,
        this.prepExtended,
        this.prepProgram,
        this.ppDate,
        this.ppCurrentDay,
        this.isPrepCompleted,
        this.transDays,
        this.transProgram,
        this.tpDate,
        this.tpCurrentDay,
        this.isTransCompleted,
        this.createdAt,
        this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'].toString();
    programId = json['program_id'].toString();
    isActive = json['is_active'].toString();
    startProgram = json['start_program'].toString();
    spDate = json['sp_date'].toString();
    spCurrentDay = json['sp_current_day'].toString();
    prepDays = json['prep_days'].toString();
    prepExtended = json['prep_extended'].toString();
    prepProgram = json['prep_program'].toString();
    ppDate = json['pp_date'].toString();
    ppCurrentDay = json['pp_current_day'].toString();
    isPrepCompleted = json['is_prep_completed'] == "0" ? false : true;
    transDays = json['trans_days'].toString();
    transProgram = json['trans_program'].toString();
    tpDate = json['tp_date'].toString();
    tpCurrentDay = json['tp_current_day'].toString();
    isTransCompleted = json['is_trans_completed'] == "0"? false : true;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['program_id'] = this.programId;
    data['is_active'] = this.isActive;
    data['start_program'] = this.startProgram;
    data['sp_date'] = this.spDate;
    data['sp_current_day'] = this.spCurrentDay;
    data['prep_days'] = this.prepDays;
    data['prep_extended'] = this.prepExtended;
    data['prep_program'] = this.prepProgram;
    data['pp_date'] = this.ppDate;
    data['pp_current_day'] = this.ppCurrentDay;
    data['is_prep_completed'] = this.isPrepCompleted;
    data['trans_days'] = this.transDays;
    data['trans_program'] = this.transProgram;
    data['tp_date'] = this.tpDate;
    data['tp_current_day'] = this.tpCurrentDay;
    data['is_trans_completed'] = this.isTransCompleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}