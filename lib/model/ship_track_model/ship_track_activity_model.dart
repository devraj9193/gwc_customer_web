class ShipmentTrackActivities {
  String? date;
  String? status;
  String? activity;
  String? location;
  String? srStatus;
  String? srStatusLabel;

  ShipmentTrackActivities(
      {this.date,
        this.status,
        this.activity,
        this.location,
        this.srStatus,
        this.srStatusLabel});

  ShipmentTrackActivities.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    status = json['status'];
    activity = json['activity'];
    location = json['location'];
    srStatus = json['sr-status'].toString();
    srStatusLabel = json['sr-status-label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['status'] = this.status;
    data['activity'] = this.activity;
    data['location'] = this.location;
    data['sr-status'] = this.srStatus;
    data['sr-status-label'] = this.srStatusLabel;
    return data;
  }
}
