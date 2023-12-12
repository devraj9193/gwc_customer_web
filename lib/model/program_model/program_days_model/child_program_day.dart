import 'package:flutter/cupertino.dart';

class ChildProgramDayModel {
  String? programId;
  String? dayNumber;
  String? image;
  int? isCompleted;
  Color? color;

  ChildProgramDayModel({this.programId, this.dayNumber, this.image, this.isCompleted});

  ChildProgramDayModel.fromJson(Map<String, dynamic> json) {
    programId = json['program_id'].toString();
    dayNumber = json['day_number'].toString();
    image = json['image'];
    isCompleted = json['is_completed'];
    if(dayNumber == '1' || (int.tryParse(dayNumber!)! % 3) == 1){
      color = const Color(0xffC7F087);
    }
    else if(dayNumber == '2' || (int.tryParse(dayNumber!)! % 3) == 2){
      color = const Color(0xffFFA39F);
    }
    else if(dayNumber == '3' || (int.tryParse(dayNumber!)! % 3) == 0){
      color = const Color(0xffFFE889);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_id'] = this.programId;
    data['day_number'] = this.dayNumber;
    data['image'] = this.image;
    data['is_completed'] = this.isCompleted;
    return data;
  }
}