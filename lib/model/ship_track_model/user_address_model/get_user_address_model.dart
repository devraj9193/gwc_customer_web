class GetUserAddressModel {
  int? status;
  int? errorCode;
  String? key;
  Data? data;

  GetUserAddressModel({
    this.status,
    this.errorCode,
    this.key,
    this.data,
  });

  factory GetUserAddressModel.fromJson(Map<String, dynamic> json) =>
      GetUserAddressModel(
        status: json["status"],
        errorCode: json["errorCode"],
        key: json["key"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "errorCode": errorCode,
        "key": key,
        "data": data?.toJson(),
      };
}

class Data {
  String? address2;
  String? city;
  String? state;
  String? country;
  User? user;

  Data({
    this.address2,
    this.city,
    this.state,
    this.country,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        address2: json['address2'].toString(),
        city: json["city"].toString(),
        state: json["state"].toString(),
        country: json["country"].toString(),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "address2": address2,
        "city": city,
        "state": state,
        "country": country,
        "user": user?.toJson(),
      };
}

class User {
  String? name;
  String? fname;
  String? lname;
  String? address;
  String? pincode;
  String? phone;
  String? phone2;

  User({
    this.name,
    this.fname,
    this.lname,
    this.address,
    this.pincode,
    this.phone,
    this.phone2,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"].toString(),
        fname: json["fname"].toString(),
        lname: json["lname"].toString(),
        address: json["address"].toString(),
        pincode: json["pincode"].toString(),
        phone: json['phone'].toString(),
    phone2: json['phone2'].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "fname": fname,
        "lname": lname,
        "address": address,
        "pincode": pincode,
        'phone': phone,
    'phone2':phone2,
      };
}
