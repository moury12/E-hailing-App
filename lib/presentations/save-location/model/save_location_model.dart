class SaveLocationModel {
  String? sId;
  String? user;
  String? locationName;
  String? locationAddress;
  Location? location;
  String? createdAt;
  String? updatedAt;

  SaveLocationModel({
    this.sId,
    this.user,
    this.locationName,
    this.locationAddress,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  SaveLocationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    locationName = json['locationName'];
    locationAddress = json['locationAddress'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['locationName'] = locationName;
    data['locationAddress'] = locationAddress;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
