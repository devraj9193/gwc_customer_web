class GetChatGroupIdModel {
  String? status;
  String? errorCode;
  String? group;
  List<String>? users;

  GetChatGroupIdModel({
    this.status,
    this.errorCode,
    this.group,
    this.users,
  });

  GetChatGroupIdModel.fromJson(Map<String, dynamic> json) {
    status = json["status"].toString();
    errorCode = json["errorCode"].toString();
    group = json["group"].toString();
    print(json['users'].runtimeType);
    (json['users'] != null) ? json["users"].map((x) {
      if(x == null){
        print(x);
      }
      else{
        print("else $x");
        users?.add(x ?? '');
      }
    }).toList() : [];
    print(users);
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "group": group,
    "users": (users != null) ? List<dynamic>.from(users!.map((x) => x)) : [],
  };
}