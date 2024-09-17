class UniqueSlotsModel {
  int status;
  int errorCode;
  List<UniqueSlot> uniqueSlots;

  UniqueSlotsModel({
    required this.status,
    required this.errorCode,
    required this.uniqueSlots,
  });

  factory UniqueSlotsModel.fromJson(Map<String, dynamic> json) => UniqueSlotsModel(
    status: json["status"],
    errorCode: json["errorCode"],
    uniqueSlots: List<UniqueSlot>.from(json["unique_slots"].map((x) => UniqueSlot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "unique_slots": List<dynamic>.from(uniqueSlots.map((x) => x.toJson())),
  };
}

class UniqueSlot {
  int isBooked;
  String slot;
  int isPriority;
  int isShow;
  int userId;
  int doctorId;

  UniqueSlot({
    required this.isBooked,
    required this.slot,
    required this.isPriority,
    required this.isShow,
    required this.userId,
    required this.doctorId,
  });

  factory UniqueSlot.fromJson(Map<String, dynamic> json) => UniqueSlot(
    isBooked: json["is_booked"],
    slot: json["slot"],
    isPriority: json["is_priority"],
    isShow: json["is_show"],
    userId: json["user_id"],
    doctorId: json["doctor_id"],
  );

  Map<String, dynamic> toJson() => {
    "is_booked": isBooked,
    "slot": slot,
    "is_priority": isPriority,
    "is_show": isShow,
    "user_id": userId,
    "doctor_id": doctorId,
  };
}
