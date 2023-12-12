class Testimonial {
  int? id;
  String? video;
  String? addedBy;
  String? createdAt;
  String? updatedAt;

  Testimonial(
      {this.id, this.video, this.addedBy, this.createdAt, this.updatedAt});

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    video = json['video'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video'] = this.video;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
