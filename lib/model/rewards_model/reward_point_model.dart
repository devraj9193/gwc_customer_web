class RewardPointModel {
  String? status;
  String? errorCode;
  String? totalReward;
  List<ChildRewardList>? rewardList;

  RewardPointModel(
      {this.status, this.errorCode, this.totalReward, this.rewardList});

  RewardPointModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    totalReward = json['total_reward'].toString();
    if (json['reward_list'] != null) {
      rewardList = <ChildRewardList>[];
      json['reward_list'].forEach((v) {
        rewardList!.add(new ChildRewardList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['total_reward'] = this.totalReward;
    if (this.rewardList != null) {
      data['reward_list'] = this.rewardList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildRewardList {
  int? id;
  String? patientId;
  String? pointId;
  String? points;
  String? createdAt;
  String? updatedAt;
  RewardPoints? rewardPoints;

  ChildRewardList(
      {this.id,
        this.patientId,
        this.pointId,
        this.points,
        this.createdAt,
        this.updatedAt,
        this.rewardPoints});

  ChildRewardList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'].toString();
    pointId = json['point_id'].toString();
    points = json['points'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rewardPoints = json['reward_points'] != null
        ? new RewardPoints.fromJson(json['reward_points'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['point_id'] = this.pointId;
    data['points'] = this.points;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.rewardPoints != null) {
      data['reward_points'] = this.rewardPoints!.toJson();
    }
    return data;
  }
}

class RewardPoints {
  int? id;
  String? name;
  String? type;
  String? point;
  String? createdAt;
  String? updatedAt;

  RewardPoints(
      {this.id,
        this.name,
        this.type,
        this.point,
        this.createdAt,
        this.updatedAt});

  RewardPoints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    point = json['point'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['point'] = this.point;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}