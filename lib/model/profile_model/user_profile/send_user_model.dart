class SendUserModel {
  String? fname;
  String? lname;
  String? email;
  String? phone;
  String? gender;
  dynamic? profile;
  String? age;

  SendUserModel(
      {
        this.fname,
        this.lname,
        this.email,
        this.phone,
        this.gender,
        this.profile,
        this.age,
       });

  SendUserModel.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    if(json['photo'].toString().isNotEmpty || json['photo'] != null){
      profile = json['photo'];
    }
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    if(profile != null){
      if(profile != null) data['photo'] = this.profile;
    }
    data['age'] = this.age;
    return data;
  }
}