class QcResponse {
  String? qcImage;
  String? qcFailedReason;

  QcResponse({this.qcImage, this.qcFailedReason});

  QcResponse.fromJson(Map<String, dynamic> json) {
    qcImage = json['qc_image'];
    qcFailedReason = json['qc_failed_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qc_image'] = this.qcImage;
    data['qc_failed_reason'] = this.qcFailedReason;
    return data;
  }
}