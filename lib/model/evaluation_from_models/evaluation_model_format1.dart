class EvaluationModelFormat1{
  String fname;
  String lname;
  String maritalStatus;
  String phone;
  String email;
  String age;
  String gender;
  String address1;
  String address2;
  String state;
  String city;
  String country;
  String pincode;
  String weight;
  String height;
  String looking_to_heal;
  String checkList1;
  String? checkList1Other;
  String checkList2;
  String tongueCoating;
  String? tongueCoating_other;
  String urinationIssue;
  String urinColor;
  String? urinColor_other;
  String urinSmell;
  String? urinSmell_other;
  String urinLooksLike;
  String? urinLooksLike_other;
  String stoolDetails;
  String medical_interventions;
  String? medical_interventions_other;
  String medication;
  String holistic;
  String? allReportsUploaded;
  String? part;

  EvaluationModelFormat1(
      {
        required this.fname,
        required this.lname,
        required this.maritalStatus,
      required this.phone,
      required this.email,
      required this.age,
      required this.gender,
      required this.address1,
      required this.address2,
      required this.state,
      required this.city,
      required this.country,
      required this.pincode,
      required this.weight,
      required this.height,
      required this.looking_to_heal,
      required this.checkList1,
        this.checkList1Other,
      required this.checkList2,
      required this.tongueCoating,
      this.tongueCoating_other,
      required this.urinationIssue,
      required this.urinColor,
      this.urinColor_other,
      required this.urinSmell,
      this.urinSmell_other,
      required this.urinLooksLike,
      this.urinLooksLike_other,
      required this.stoolDetails,
      required this.medical_interventions,
      this.medical_interventions_other,
      required this.medication,
      required this.holistic,
        this.allReportsUploaded,
        this.part,
      }) ;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.fname;
    data['last_name'] = this.lname;
    data['marital_status'] = this.maritalStatus;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['address'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['health_problem'] = this.looking_to_heal;
    data['list_problems[]'] = this.checkList1;
    if(checkList1Other!.isNotEmpty) data['list_problems_other'] = this.checkList1Other;
    data['list_body_issues[]'] = this.checkList2;
    data['tongue_coating'] = this.tongueCoating;
    if(tongueCoating_other!.isNotEmpty) data['tongue_coating_other'] = this.tongueCoating_other;
    data['any_urination_issue[]'] = this.urinationIssue;
    data['urine_color[]'] = this.urinColor;
    if(urinColor_other!.isNotEmpty) data['urine_color_other'] = this.urinColor_other;
    data['urine_smell[]'] = this.urinSmell;
    if(urinSmell_other!.isNotEmpty) data['urine_smell_other'] = this.urinSmell_other;
    data['urine_look_like'] = this.urinLooksLike;
    if(urinLooksLike_other!.isNotEmpty) data['urine_look_like_other'] = this.urinLooksLike_other;
    data['closest_stool_type'] = this.stoolDetails;
    data['any_medical_intervation_done_before[]'] = this.medical_interventions;
    if(medical_interventions_other!.isNotEmpty) data['any_medical_intervation_done_before_other'] = this.medical_interventions_other;
    data['any_medication_consume_at_moment'] = this.medication;
    data['any_therapies_have_done_before'] = this.holistic;
    if(allReportsUploaded != null) data['all_report_uploaded'] = this.allReportsUploaded;
    data['part'] = this.part;
    return data;
  }

  factory EvaluationModelFormat1.fromMap(Map<String, dynamic> map) {
    return EvaluationModelFormat1(
      fname: map['first_name'] as String,
      lname: map['last_name'] as String,
      maritalStatus: map['marital_status'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      age: map['age'] as String,
      gender: map['gender'] as String,
      address1: map['address'] as String,
      address2: map['address2'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      country: map['country'] as String,
      pincode: map['pincode'] as String,
      weight: map['weight'] as String,
      height: map['height'] as String,
      looking_to_heal: map['looking_to_heal'] as String,
      checkList1: map['checkList1'] as String,
      checkList1Other: map['checkList1Other'] as String,
      checkList2: map['checkList2'] as String,
      tongueCoating: map['tongueCoating'] as String,
      tongueCoating_other: map['tongueCoating_other'] as String,
      urinationIssue: map['urinationIssue'] as String,
      urinColor: map['urinColor'] as String,
      urinColor_other: map['urinColor_other'] as String,
      urinSmell: map['urinSmell'] as String,
      urinSmell_other: map['urinSmell_other'] as String,
      urinLooksLike: map['urinLooksLike'] as String,
      urinLooksLike_other: map['urinLooksLike_other'] as String,
      stoolDetails: map['stoolDetails'] as String,
      medical_interventions: map['medical_interventions'] as String,
      medical_interventions_other: map['medical_interventions_other'] as String,
      medication: map['medication'] as String,
      holistic: map['holistic'] as String,
      allReportsUploaded: map['allReportsUploaded'] as String,
      part: map['part'] as String
    );
  }


}