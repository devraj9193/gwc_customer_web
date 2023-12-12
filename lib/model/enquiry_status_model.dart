class EnquiryStatusModel {
  String? status;
  int? errorCode;
  String? errorMsg;
  int? enquiryStatus;
  double? androidVersion;

  // VersionModel? version;

  EnquiryStatusModel(
      {this.status, this.errorCode,
        this.errorMsg, this.enquiryStatus,
        this.androidVersion});

  EnquiryStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    enquiryStatus = json['enquiry_status'];

    dynamic _version = json['android_user_version'];
    androidVersion = (_version == null) ? 20.0
        : (_version.runtimeType == String) ? double.parse(_version) : _version;
    // version = VersionModel.fromMap(json['android_user_version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    data['enquiry_status'] = this.enquiryStatus;
    data['android_user_version'] = this.androidVersion;

    // data['version'] = this.version;
    return data;
  }
}


class VersionModel{
  double? androidVersion;
  VersionModel({this.androidVersion});

  VersionModel.fromMap(Map map){
    dynamic _version = map['android_user_version'];
    androidVersion = (_version == null) ? 0.0
        : (_version.runtimeType == String) ? double.parse(_version) : _version;
  }

  Map toMap(){
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['android_user_version'] = this.androidVersion;
    return data;
  }
}