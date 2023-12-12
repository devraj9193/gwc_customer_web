class GetCountryDetailsModel {
  String? message;
  String? status;
  List<PostOffice>? postOffice;

  GetCountryDetailsModel({this.message, this.status, this.postOffice});

  GetCountryDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['PostOffice'] != null) {
      postOffice = <PostOffice>[];
      json['PostOffice'].forEach((v) {
        postOffice!.add(new PostOffice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.postOffice != null) {
      data['PostOffice'] = this.postOffice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostOffice {
  String? state;
  String? country;
  String? district;
  //
  // String? name;
  // String? description;
  // String? branchType;
  // String? deliveryStatus;
  // String? taluk;
  // String? circle;
  // String? division;
  // String? region;


  PostOffice(
      {
        this.state,
        this.country,
        this.district,
        //
        // this.name,
        // this.description,
        // this.branchType,
        // this.deliveryStatus,
        // this.taluk,
        // this.circle,
        // this.division,
        // this.region,

      });

  PostOffice.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    district = json['District'];
    country = json['Country'];
    //
    // name = json['Name'];
    // description = json['Description'];
    // branchType = json['BranchType'];
    // deliveryStatus = json['DeliveryStatus'];
    // taluk = json['Taluk'];
    // circle = json['Circle'];
    // division = json['Division'];
    // region = json['Region'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['State'] = this.state;
    data['Country'] = this.country;
    data['District'] = this.district;

    // data['Name'] = this.name;
    // data['Description'] = this.description;
    // data['BranchType'] = this.branchType;
    // data['DeliveryStatus'] = this.deliveryStatus;
    // data['Taluk'] = this.taluk;
    // data['Circle'] = this.circle;
    // data['Division'] = this.division;
    // data['Region'] = this.region;
    return data;
  }
}