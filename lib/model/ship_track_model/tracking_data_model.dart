import 'child_shipping_track_model.dart';
import 'qc_response.dart';
import 'ship_track_activity_model.dart';

class TrackingData {
  int? trackStatus;
  int? shipmentStatus;
  List<ChildShipmentTrack>? shipmentTrack;
  List<ShipmentTrackActivities>? shipmentTrackActivities;
  String? trackUrl;
  String? etd;
  QcResponse? qcResponse;
  String? error;

  TrackingData(
      {this.trackStatus,
        this.shipmentStatus,
        this.shipmentTrack,
        this.shipmentTrackActivities,
        this.trackUrl,
        this.etd,
        this.qcResponse,
        this.error
      });

  TrackingData.fromJson(Map<String, dynamic> json) {
    trackStatus = json['track_status'];
    shipmentStatus = json['shipment_status'];
    if (json['shipment_track'] != null) {
      shipmentTrack = <ChildShipmentTrack>[];
      json['shipment_track'].forEach((v) {
        shipmentTrack!.add(new ChildShipmentTrack.fromJson(v));
      });
    }
    if (json['shipment_track_activities'] != null) {
      shipmentTrackActivities = <ShipmentTrackActivities>[];
      json['shipment_track_activities'].forEach((v) {
        shipmentTrackActivities!.add(new ShipmentTrackActivities.fromJson(v));
      });
    }
    trackUrl = json['track_url'];
    etd = json['etd'];
    qcResponse = json['qc_response'] != null
        ? new QcResponse.fromJson(json['qc_response'])
        : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['track_status'] = this.trackStatus;
    data['shipment_status'] = this.shipmentStatus;
    if (this.shipmentTrack != null) {
      data['shipment_track'] =
          this.shipmentTrack!.map((v) => v.toJson()).toList();
    }
    if (this.shipmentTrackActivities != null) {
      data['shipment_track_activities'] =
          this.shipmentTrackActivities!.map((v) => v.toJson()).toList();
    }
    data['track_url'] = this.trackUrl;
    data['etd'] = this.etd;
    if (this.qcResponse != null) {
      data['qc_response'] = this.qcResponse!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}
