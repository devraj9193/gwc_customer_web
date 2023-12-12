import 'tracking_data_model.dart';

class ShippingTrackModel {
  TrackingData? trackingData;

  ShippingTrackModel({this.trackingData});

  ShippingTrackModel.fromJson(Map<String, dynamic> json) {
    trackingData = json['tracking_data'] != null
        ? new TrackingData.fromJson(json['tracking_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trackingData != null) {
      data['tracking_data'] = this.trackingData!.toJson();
    }
    return data;
  }
}
