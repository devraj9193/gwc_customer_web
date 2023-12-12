
class FeedsListModel {
  List<dynamic>? image;
  String? thumbnail;
  Feed? feed;
  String? ago;
  int? likes;
  List<Comments>? comments;

  FeedsListModel({
    this.image,
    this.thumbnail,
    this.feed,
    this.ago,
    this.likes,
    this.comments,
  });

  factory FeedsListModel.fromJson(Map<String, dynamic> json) => FeedsListModel(
    image: List<dynamic>.from(json["image"].map((x) => x)),
    thumbnail: json["thumbnail"].toString(),
    feed: Feed.fromJson(json["feed"]),
    ago: json["ago"].toString(),
    likes: json["likes"],
    comments: List<Comments>.from(json["comments"].map((x) => Comments.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "image": List<dynamic>.from(image!.map((x) => x)),
    "thumbnail": thumbnail,
    "feed": feed?.toJson(),
    "ago": ago,
    "likes": likes,
    "comments": List<dynamic>.from(comments!.map((x) => x)),
  };
}

class Feed {
  int? id;
  String? title;
  String? location;
  String? photo;
  AddedBy? addedBy;
  String? isFeed;
  String? description;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;

  Feed(
      {this.id,
        this.title,
        this.location,
        this.photo,
        this.addedBy,
        this.description,
        this.thumbnail,
        this.isFeed,
        this.createdAt,
        this.updatedAt});

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    location = json['location'];
    photo = json['photo'].toString();
    addedBy = json['added_by'] != null
        ? AddedBy.fromJson(json['added_by'])
        : null;
    isFeed = json["is_feed"];
    description = json["description"];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['location'] = location;
    data['photo'] = photo;
    if (addedBy != null) {
      data['added_by'] = addedBy!.toJson();
    }
    data['is_feed'] = isFeed;
    data['thumbnail'] = thumbnail;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class AddedBy {
  int? id;
  String? roleId;
  String? name;
  String? fname;
  String? lname;
  String? email;
  String? emailVerifiedAt;
  String? countryCode;
  String? phone;
  String? gender;
  String? profile;
  String? address;
  String? otp;
  String? deviceToken;
  String? deviceType;
  String? deviceId;
  String? age;
  String? chatId;
  String? loginUsername;
  String? pincode;
  String? isActive;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? signupDate;

  AddedBy(
      {this.id,
        this.roleId,
        this.name,
        this.fname,
        this.lname,
        this.email,
        this.emailVerifiedAt,
        this.countryCode,
        this.phone,
        this.gender,
        this.profile,
        this.address,
        this.otp,
        this.deviceToken,
        this.deviceType,
        this.deviceId,
        this.age,
        this.chatId,
        this.loginUsername,
        this.pincode,
        this.isActive,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.signupDate});

  AddedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'].toString();
    name = json['name'];
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    countryCode = json['country_code'];
    phone = json['phone'];
    gender = json['gender'];
    profile = json['profile'];
    address = json['address'];
    otp = json['otp'].toString();
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    deviceId = json['device_id'];
    age = json['age'];
    chatId = json['chat_id'];
    loginUsername = json['login_username'];
    pincode = json['pincode'];
    isActive = json['is_active'].toString();
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    signupDate = json['signup_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_id'] = roleId;
    data['name'] = name;
    data['fname'] = fname;
    data['lname'] = lname;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['gender'] = gender;
    data['profile'] = profile;
    data['address'] = address;
    data['otp'] = otp;
    data['device_token'] = deviceToken;
    data['device_type'] = deviceType;
    data['device_id'] = deviceId;
    data['age'] = age;
    data['chat_id'] = chatId;
    data['login_username'] = loginUsername;
    data['pincode'] = pincode;
    data['is_active'] = isActive;
    data['added_by'] = addedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['signup_date'] = signupDate;
    return data;
  }
}

class Comments {
  int? id;
  String? feedId;
  String? type;
  String? value;
  String? createdAt;
  String? updatedAt;

  Comments(
      {this.id,
        this.feedId,
        this.type,
        this.value,
        this.createdAt,
        this.updatedAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'].toString();
    type = json['type'].toString();
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['feed_id'] = feedId;
    data['type'] = type;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}