class ProtocolGuideDayScoreModel {
  int? status;
  int? errorCode;
  String? key;
  int? day;
  int? score;
  String? percentage;
  String? breakfast;
  String? lunch;
  String? dinner;
  String? protocolGuidePdf;

  ProtocolGuideDayScoreModel(
      {this.status,
        this.errorCode,
        this.key,
        this.day,
        this.score,
        this.percentage,
        this.breakfast,
        this.lunch,
        this.dinner,
        this.protocolGuidePdf
      });

  ProtocolGuideDayScoreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    day = json['day'];
    score = json['score'];
    percentage = json['percentage'].toString();
    breakfast = json['breakfast'].toString();
    lunch = json['lunch'].toString();
    dinner = json['dinner'].toString();
    protocolGuidePdf = json['protocol_guide'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['day'] = this.day;
    data['score'] = this.score;
    data['percentage'] = this.percentage;
    data['breakfast'] = this.breakfast;
    data['lunch'] = this.lunch;
    data['dinner'] = this.dinner;
    data['protocol_guide'] = this.protocolGuidePdf;
    return data;
  }
}