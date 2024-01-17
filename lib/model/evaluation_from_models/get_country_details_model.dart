class GetCountryDetailsModel {
  int status;
  int errorCode;
  Response response;

  GetCountryDetailsModel({
    required this.status,
    required this.errorCode,
    required this.response,
  });

  factory GetCountryDetailsModel.fromJson(Map<String, dynamic> json) => GetCountryDetailsModel(
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
  String message;
  String status;
  List<PostOffice> postOffice;

  Response({
    required this.message,
    required this.status,
    required this.postOffice,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    message: json["Message"],
    status: json["Status"],
    postOffice: List<PostOffice>.from(json["PostOffice"].map((x) => PostOffice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "PostOffice": List<dynamic>.from(postOffice.map((x) => x.toJson())),
  };
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