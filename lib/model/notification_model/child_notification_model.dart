// class ChildNotificationModel {
//
//   int? id;
//   String? user_id;
//   String? type;
//   String? subject;
//   String? message;
//   String? request_id;
//   String? notification_type;
//   String? is_read;
//   String? added_by;
//   String? created_at;
//   String? updated_at;
//
// 	ChildNotificationModel.fromJsonMap(Map<String, dynamic> map):
// 		id = map["id"],
// 		user_id = map["user_id"].toString(),
// 		type = map["type"].toString(),
// 		subject = map["subject"].toString(),
// 		message = map["message"].toString(),
// 		request_id = map["request_id"].toString(),
// 		notification_type = map["notification_type"].toString(),
// 		is_read = map["is_read"].toString(),
// 		added_by = map["added_by"].toString(),
// 		created_at = map["created_at"].toString(),
// 		updated_at = map["updated_at"].toString();
//
// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		data['id'] = id;
// 		data['user_id'] = user_id;
// 		data['type'] = type;
// 		data['subject'] = subject;
// 		data['message'] = message;
// 		data['request_id'] = request_id;
// 		data['notification_type'] = notification_type;
// 		data['is_read'] = is_read;
// 		data['added_by'] = added_by;
// 		data['created_at'] = created_at;
// 		data['updated_at'] = updated_at;
// 		return data;
// 	}
// }

class ChildNotificationModel {
	int? id;
	int? userId;
	int? doctorId;
	String? type;
	String? subject;
	String? userMsg;
	String? doctorMsg;
	String? successMsg;
	String? isUser;
	String? isDoctor;
	String? isSuccess;
	String? message;
	String? internalMessage;
	String? requestId;
	String? notificationType;
	String? isReadUser;
	String? isReadDoctor;
	String? isReadSuccess;
	int? addedBy;
	String? successMember;
	String? createdAt;
	String? updatedAt;

	ChildNotificationModel.fromJsonMap(Map<String, dynamic> map)
			: id = map["id"],
				userId = map["user_id"],
				type = map["type"].toString(),
				subject = map["subject"].toString(),
				message = map["message"].toString(),
				requestId = map["request_id"].toString(),
				notificationType = map["notification_type"].toString(),
				addedBy = map["added_by"],
				createdAt = map["created_at"].toString(),
				updatedAt = map["updated_at"].toString(),
				doctorId = map['doctor_id'],
				userMsg = map['user_msg'].toString(),
				doctorMsg = map['doctor_msg'].toString(),
				successMsg = map['success_msg'].toString(),
				isUser = map['is_user'].toString(),
				isDoctor = map['is_doctor'].toString(),
				isSuccess = map['is_success'].toString(),
				internalMessage = map['internal_message'].toString(),
				isReadUser = map['is_read_user'].toString(),
				isReadDoctor = map['is_read_doctor'].toString(),
				isReadSuccess = map['is_read_success'].toString(),
				successMember = map['success_member'].toString();

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map<String, dynamic>();
		data['id'] = id;
		data['user_id'] = userId;
		data['type'] = type;
		data['subject'] = subject;
		data['message'] = message;
		data['request_id'] = requestId;
		data['notification_type'] = notificationType;
		data['added_by'] = addedBy;
		data['created_at'] = createdAt;
		data['updated_at'] = updatedAt;
		data['doctor_id'] = doctorId;
		data['user_msg'] = userMsg;
		data['doctor_msg'] = doctorMsg;
		data['success_msg'] = successMsg;
		data['is-user'] = isUser;
		data['is_doctor'] = isDoctor;
		data['is_success'] = isSuccess;
		data['internal_message'] = internalMessage;
		data['is_read_user'] = isReadUser;
		data['is_read_doctor'] = isReadDoctor;
		data['is_read_success'] = isReadSuccess;
		data['success_member'] = successMember;
		return data;
	}
}

// factory ChildNotificationModel.fromJson(Map<String, dynamic> json) => ChildNotificationModel(
// 	id: json["id"],
// 	userId: json["user_id"],
// 	doctorId: json["doctor_id"],
// 	type: json["type"],
// 	subject: json["subject"],
// 	userMsg: json["user_msg"],
// 	doctorMsg: json["doctor_msg"],
// 	successMsg: json["success_msg"],
// 	isUser: json["is_user"],
// 	isDoctor: json["is_doctor"],
// 	isSuccess: json["is_success"],
// 	message: json["message"],
// 	internalMessage: json["internal_message"],
// 	requestId: json["request_id"],
// 	notificationType: json["notification_type"],
// 	isReadUser: json["is_read_user"],
// 	isReadDoctor: json["is_read_doctor"],
// 	isReadSuccess: json["is_read_success"],
// 	addedBy: json["added_by"],
// 	successMember: json["success_member"],
// 	createdAt: json["created_at"],
// 	updatedAt: json["updated_at"],
// );
//
// Map<String, dynamic> toJson() => {
// 	"id": id,
// 	"user_id": userId,
// 	"doctor_id": doctorId,
// 	"type": type,
// 	"subject": subject,
// 	"user_msg": userMsg,
// 	"doctor_msg": doctorMsg,
// 	"success_msg": successMsg,
// 	"is_user": isUser,
// 	"is_doctor": isDoctor,
// 	"is_success": isSuccess,
// 	"message": message,
// 	"internal_message": internalMessage,
// 	"request_id": requestId,
// 	"notification_type": notificationType,
// 	"is_read_user": isReadUser,
// 	"is_read_doctor": isReadDoctor,
// 	"is_read_success": isReadSuccess,
// 	"added_by": addedBy,
// 	"success_member": successMember,
// 	"created_at": createdAt,
// 	"updated_at": updatedAt,
// };
// }
