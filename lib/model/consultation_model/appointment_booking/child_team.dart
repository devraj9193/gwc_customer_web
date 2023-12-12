import 'child_team_member.dart';

class Team {
  int? id;
  String? teamName;
  String? shiftId;
  String? slotsPerDay;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  List<TeamMember>? teamMember;

  Team(
      {this.id,
        this.teamName,
        this.shiftId,
        this.slotsPerDay,
        this.isArchieved,
        this.createdAt,
        this.updatedAt,
        this.teamMember});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    shiftId = json['shift_id'].toString();
    slotsPerDay = json['slots_per_day'];
    isArchieved = json['is_archieved'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['team_member'] != null) {
      teamMember = <TeamMember>[];
      json['team_member'].forEach((v) {
        teamMember!.add(new TeamMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_name'] = this.teamName;
    data['shift_id'] = this.shiftId;
    data['slots_per_day'] = this.slotsPerDay;
    data['is_archieved'] = this.isArchieved;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.teamMember != null) {
      data['team_member'] = this.teamMember!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
