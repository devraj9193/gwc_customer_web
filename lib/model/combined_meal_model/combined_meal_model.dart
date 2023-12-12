import 'new_detox_model.dart';
import 'new_healing_model.dart';
import 'new_nourish_model.dart';
import 'new_prep_model.dart';

class CombinedMealModel {
  int? status;
  int? errorCode;
  NewPrepModel? prep;
  NewDetoxModel? detox;
  NewHealingModel? healing;
  NewNourishModel? nourish;
  String? tracker_video_url;


  CombinedMealModel({this.status, this.errorCode,
    this.prep, this.detox, this.healing, this.nourish, this.tracker_video_url});

  CombinedMealModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    prep = json['Prep'] != null ? new NewPrepModel.fromJson(json['Prep']) : null;
    detox = json['Detox'] != null ? new NewDetoxModel.fromJson(json['Detox']) : null;
    healing = json['Healing'] != null ? new NewHealingModel.fromJson(json['Healing']) : null;
    nourish = json['Nourish'] != null ? new NewNourishModel.fromJson(json['Nourish']) : null;
    tracker_video_url = json['tracker_video'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['tracker_video'] = this.tracker_video_url;

    if (this.prep != null) {
      data['Prep'] = this.prep!.toJson();
    }
    if (this.detox != null) {
      data['Detox'] = this.detox!.toJson();
    }
    if (this.healing != null) {
      data['Healing'] = this.healing!.toJson();
    }
    if (this.nourish != null) {
      data['Nourish'] = this.nourish!.toJson();
    }
    return data;
  }
}

// class CombinedMealModel {
//   int? status;
//   int? errorCode;
//   String? key;
//   NewPrepModel? prep;
//   NewDetoxModel? detox;
//   NewHealingModel? healing;
//   NewNourishModel? nourish;
//   String? tracker_video_url;
//
//   CombinedMealModel({
//     this.status,
//     this.errorCode,
//     this.key,
//     this.prep,
//     this.detox,
//     this.healing,
//     this.nourish,
//     this.tracker_video_url,
//   });
//
//   factory CombinedMealModel.fromJson(Map<String, dynamic> json) => CombinedMealModel(
//     status: json["status"],
//     errorCode: json["errorCode"],
//     key: json["key"],
//     prep:json['Prep'] != null ? NewPrepModel.fromJson(json["Prep"]) : null,
//     detox: json['Detox'] != null ? NewDetoxModel.fromJson(json["Detox"]) : null,
//     healing: json['Healing'] != null ? NewHealingModel.fromJson(json["Healing"]) : null,
//     nourish: json['Nourish'] != null ? NewNourishModel.fromJson(json["Nourish"]) : null,
//     tracker_video_url: json["tracker_video"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "errorCode": errorCode,
//     "key": key,
//     "Prep": prep?.toJson(),
//     "Detox": detox?.toJson(),
//     "Healing": healing?.toJson(),
//     "Nourish": nourish?.toJson(),
//     "tracker_video": tracker_video_url,
//   };
// }