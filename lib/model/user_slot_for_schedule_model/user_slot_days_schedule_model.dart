class GetUserSlotDaysForScheduleModel {
  int? status;
  int? errorCode;
  String? key;
  String? errorMsg;
  List<ChildUserSlotDaysForScheduleModel>? data;

  GetUserSlotDaysForScheduleModel(
      {this.status, this.errorCode, this.key, this.errorMsg, this.data});

  GetUserSlotDaysForScheduleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <ChildUserSlotDaysForScheduleModel>[];
      json['data'].forEach((v) {
        data!.add(new ChildUserSlotDaysForScheduleModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildUserSlotDaysForScheduleModel {
  String? slot;
  String? date;
  String? status;
  String? callStatus;
  bool? booked;
  int? day;
  String? eventId;

  ChildUserSlotDaysForScheduleModel({this.slot, this.date, this.status, this.booked, this.day});

  ChildUserSlotDaysForScheduleModel.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
    date = json['date'];
    status = json['status'];
    callStatus = json['call_status'].toString();
    booked = (json['booked'] == null || json['booked'] != "1") ? false : true;
    day = json['day'];
    eventId =json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot'] = this.slot;
    data['date'] = this.date;
    data['status'] = this.status;
    data['booked'] = this.booked;
    data['call_status'] = this.callStatus;
    data['day'] = this.day;
    data['event_id'] = this.eventId;
    return data;
  }
}