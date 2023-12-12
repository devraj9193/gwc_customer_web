class FaqListModel {
  int? status;
  int? errorCode;
  String? key;
  List<FaqList>? faqList;

  FaqListModel({this.status, this.errorCode, this.key, this.faqList});

  FaqListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    if (json['faq_list'] != null) {
      faqList = <FaqList>[];
      json['faq_list'].forEach((v) {
        faqList!.add(new FaqList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.faqList != null) {
      data['faq_list'] = this.faqList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FaqList {
  int? id;
  String? question;
  String? faqType;
  String? type;
  String? answer;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;

  FaqList(
      {this.id,
        this.question,
        this.faqType,
        this.type,
        this.answer,
        this.isArchieved,
        this.createdAt,
        this.updatedAt});

  FaqList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    faqType = json['faq_type'];
    type = json['type'];
    answer = json['answer'];
    isArchieved = json['is_archieved'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['faq_type'] = this.faqType;
    data['type'] = this.type;
    data['answer'] = this.answer;
    data['is_archieved'] = this.isArchieved;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}