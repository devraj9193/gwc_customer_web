
import 'child_notification_model.dart';

class NotificationModel {

  int? status;
  int? errorCode;
  String? key;
  List<ChildNotificationModel>? data;

	NotificationModel.fromJsonMap(Map<String, dynamic> map): 
		status = map["status"],
		errorCode = map["errorCode"],
		key = map["key"],
		data = List<ChildNotificationModel>.from(map["data"].map((it) => ChildNotificationModel.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['status'] = status;
		data['errorCode'] = errorCode;
		data['key'] = key;
		data['data'] = data != null ? 
			this.data?.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
