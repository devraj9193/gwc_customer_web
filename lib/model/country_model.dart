class CountryModel {
  List<Countries>? countries;

  CountryModel({this.countries});

  CountryModel.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countries != null) {
      data['countries'] = this.countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  String? country;
  List<String>? states;

  Countries({this.country, this.states});

  Countries.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    states = json['states'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['states'] = this.states;
    return data;
  }
}