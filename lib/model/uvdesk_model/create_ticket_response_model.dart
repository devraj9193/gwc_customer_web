/// for reply we need message and id will
/// for create ticket all params we need


class CreateReplyTicketModel {

  String? message;
  int? id;
  int? incrementId;
  int? ticketId;

  CreateReplyTicketModel({this.message, this.id, this.incrementId, this.ticketId});

  CreateReplyTicketModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    incrementId = json['incrementId'];
    ticketId = json['ticketId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['id'] = this.id;
    data['incrementId'] = this.incrementId;
    data['ticketId'] = this.ticketId;
    return data;
  }
}



/*
create api
request body params:
type:1
name:test with Attachment
from:abc@gmail.com
reply:testing attachment
subject:attachemnt test
attachments[]: [Multipart files]

response:
{
    "message": "Success ! Ticket has been created successfully.",
    "id": 6,
    "incrementId": 6,
    "ticketId": 2026566
}


reply api
request body params:
threadType:reply
reply:testing attachment
attachments[]: [Multipart files]

response :
{
    "message": "Success ! Reply added successfully.",
    "id": 11453862
}



 */