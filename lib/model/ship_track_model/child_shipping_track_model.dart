class ChildShipmentTrack {
  int? id;
  String? awbCode;
  int? courierCompanyId;
  int? shipmentId;
  int? orderId;
  String? pickupDate;
  String? deliveredDate;
  String? weight;
  int? packages;
  String? currentStatus;
  String? deliveredTo;
  String? destination;
  String? consigneeName;
  String? origin;
  String? courierAgentDetails;
  String? edd;

  ChildShipmentTrack(
      {this.id,
        this.awbCode,
        this.courierCompanyId,
        this.shipmentId,
        this.orderId,
        this.pickupDate,
        this.deliveredDate,
        this.weight,
        this.packages,
        this.currentStatus,
        this.deliveredTo,
        this.destination,
        this.consigneeName,
        this.origin,
        this.courierAgentDetails,
        this.edd});

  ChildShipmentTrack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    awbCode = json['awb_code'];
    courierCompanyId = json['courier_company_id'];
    shipmentId = json['shipment_id'];
    orderId = json['order_id'];
    pickupDate = json['pickup_date'];
    deliveredDate = json['delivered_date'];
    weight = json['weight'];
    packages = json['packages'];
    currentStatus = json['current_status'];
    deliveredTo = json['delivered_to'];
    destination = json['destination'];
    consigneeName = json['consignee_name'];
    origin = json['origin'];
    courierAgentDetails = json['courier_agent_details'];
    edd = json['edd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['awb_code'] = this.awbCode;
    data['courier_company_id'] = this.courierCompanyId;
    data['shipment_id'] = this.shipmentId;
    data['order_id'] = this.orderId;
    data['pickup_date'] = this.pickupDate;
    data['delivered_date'] = this.deliveredDate;
    data['weight'] = this.weight;
    data['packages'] = this.packages;
    data['current_status'] = this.currentStatus;
    data['delivered_to'] = this.deliveredTo;
    data['destination'] = this.destination;
    data['consignee_name'] = this.consigneeName;
    data['origin'] = this.origin;
    data['courier_agent_details'] = this.courierAgentDetails;
    data['edd'] = this.edd;
    return data;
  }
}
