class PpcSlotsModel {
  int status;
  int errorCode;
  List<MatchedPpcSlot> matchedPpcSlots;

  PpcSlotsModel({
    required this.status,
    required this.errorCode,
    required this.matchedPpcSlots,
  });

  factory PpcSlotsModel.fromJson(Map<String, dynamic> json) => PpcSlotsModel(
    status: json["status"],
    errorCode: json["errorCode"],
    matchedPpcSlots: List<MatchedPpcSlot>.from(json["matchedPPCSlots"].map((x) => MatchedPpcSlot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "matchedPPCSlots": List<dynamic>.from(matchedPpcSlots.map((x) => x.toJson())),
  };
}

class MatchedPpcSlot {
  int isBooked;
  String slot;
  String slotStartTime;
  String slotEndTime;
  int isPriority;
  int isShow;
  int userId;
  int doctorId;
  String duration;
  List<Booked> booked;

  MatchedPpcSlot({
    required this.isBooked,
    required this.slot,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.isPriority,
    required this.isShow,
    required this.userId,
    required this.doctorId,
    required this.duration,
    required this.booked,
  });

  factory MatchedPpcSlot.fromJson(Map<String, dynamic> json) => MatchedPpcSlot(
    isBooked: json["is_booked"],
    slot: json["slot"],
    slotStartTime: json["slot_start_time"],
    slotEndTime: json["slot_end_time"],
    isPriority: json["is_priority"],
    isShow: json["is_show"],
    userId: json["user_id"],
    doctorId: json["doctor_id"],
    duration: json["duration"],
    booked: List<Booked>.from(json["booked"].map((x) => Booked.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is_booked": isBooked,
    "slot": slot,
    "slot_start_time": slotStartTime,
    "slot_end_time": slotEndTime,
    "is_priority": isPriority,
    "is_show": isShow,
    "user_id": userId,
    "doctor_id": doctorId,
    "duration": duration,
    "booked": List<dynamic>.from(booked.map((x) => x.toJson())),
  };
}

class Booked {
  String slot;
  int duration;

  Booked({
    required this.slot,
    required this.duration,
  });

  factory Booked.fromJson(Map<String, dynamic> json) => Booked(
    slot: json["slot"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "slot": slot,
    "duration": duration,
  };
}
