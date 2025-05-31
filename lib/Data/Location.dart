class Location {
  String? name;
  int? phone;
  int? latitude;
  int? longitude;

  Location({this.name, this.phone, this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
