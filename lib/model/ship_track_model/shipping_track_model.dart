import 'tracking_data_model.dart';

class ShippingTrackModel {
  int status;
  int errorCode;
  Response response;

  ShippingTrackModel({
    required this.status,
    required this.errorCode,
    required this.response,
  });

  factory ShippingTrackModel.fromJson(Map<String, dynamic> json) => ShippingTrackModel(
    status: json["status"],
    errorCode: json["errorCode"],
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "response": response.toJson(),
  };
}

class Response {
  TrackingData trackingData;

  Response({
    required this.trackingData,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    trackingData: TrackingData.fromJson(json["tracking_data"]),
  );

  Map<String, dynamic> toJson() => {
    "tracking_data": trackingData.toJson(),
  };
}

//
// class ShippingTrackModel {
//   TrackingData? trackingData;
//
//   ShippingTrackModel({this.trackingData});
//
//   ShippingTrackModel.fromJson(Map<String, dynamic> json) {
//     trackingData = json['tracking_data'] != null
//         ? new TrackingData.fromJson(json['tracking_data'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.trackingData != null) {
//       data['tracking_data'] = this.trackingData!.toJson();
//     }
//     return data;
//   }
// }
