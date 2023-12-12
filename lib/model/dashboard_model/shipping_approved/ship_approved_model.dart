class ShippingApprovedModel {
  String? data;
  Value? value;

  ShippingApprovedModel(
      {this.data, this.value});

  ShippingApprovedModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}

class Value {
  int? id;
  String? teamPatientId;
  String? orderId;
  String? shippingId;
  String? awbCode;
  String? courierName;
  String? courierCompanyId;
  String? assignedDateTime;
  String? labelUrl;
  String? manifestUrl;
  String? pickupTokenNumber;
  String? routingCode;
  String? pickupScheduledDate;
  String? status;
  String? addedBy;
  String? createdAt;
  String? updatedAt;

  Value(
      {this.id,
        this.teamPatientId,
        this.orderId,
        this.shippingId,
        this.awbCode,
        this.courierName,
        this.courierCompanyId,
        this.assignedDateTime,
        this.labelUrl,
        this.manifestUrl,
        this.pickupTokenNumber,
        this.routingCode,
        this.pickupScheduledDate,
        this.status,
        this.addedBy,
        this.createdAt,
        this.updatedAt});

  Value.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamPatientId = json['team_patient_id'].toString();
    orderId = json['order_id'].toString();
    shippingId = json['shipping_id'].toString();
    awbCode = json['awb_code'].toString();
    courierName = json['courier_name'].toString();
    courierCompanyId = json['courier_company_id'].toString();
    assignedDateTime = json['assigned_date_time'].toString();
    labelUrl = json['label_url'].toString();
    manifestUrl = json['manifest_url'].toString();
    pickupTokenNumber = json['pickup_token_number'].toString();
    routingCode = json['routing_code'].toString();
    pickupScheduledDate = json['pickup_scheduled_date'].toString();
    status = json['status'].toString();
    addedBy = json['added_by'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_patient_id'] = this.teamPatientId;
    data['order_id'] = this.orderId;
    data['shipping_id'] = this.shippingId;
    data['awb_code'] = this.awbCode;
    data['courier_name'] = this.courierName;
    data['courier_company_id'] = this.courierCompanyId;
    data['assigned_date_time'] = this.assignedDateTime;
    data['label_url'] = this.labelUrl;
    data['manifest_url'] = this.manifestUrl;
    data['pickup_token_number'] = this.pickupTokenNumber;
    data['routing_code'] = this.routingCode;
    data['pickup_scheduled_date'] = this.pickupScheduledDate;
    data['status'] = this.status;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}