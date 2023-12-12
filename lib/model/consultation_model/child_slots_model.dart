// class ChildSlotModel {
//   String? slot;
//   String? isBooked;
//
//   ChildSlotModel({this.slot, this.isBooked});
//
//   ChildSlotModel.fromJson(Map<String, dynamic> json) {
//     slot = json['slot'];
//     isBooked = json['is_booked'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['slot'] = this.slot;
//     data['is_booked'] = this.isBooked;
//     return data;
//   }
// }

class ChildSlotModel {
  ChildSlotModel({
    this.isBooked,
    this.slot,
  });

  String? isBooked;
  String? slot;

  factory ChildSlotModel.fromJson(Map<String, dynamic> json) => ChildSlotModel(
    isBooked: json["is_booked"].toString(),
    slot: json["slot"],
  );

  Map<String, dynamic> toJson() => {
    "is_booked": isBooked,
    "slot": slot,
  };
}
