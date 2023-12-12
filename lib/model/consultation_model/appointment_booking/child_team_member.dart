
import 'child_user.dart';

class TeamMember {
  int? id;
  String? teamId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  ChildUser? user;

  TeamMember(
      {this.id,
        this.teamId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.user});

  TeamMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'].toString();
    userId = json['user_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new ChildUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_id'] = this.teamId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
