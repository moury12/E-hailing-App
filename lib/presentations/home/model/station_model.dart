class StationModel {
  String? sId;
  String? title;
  String? address;
  Location? location;
  String? createdAt;
  String? updatedAt;

  StationModel({
    this.sId,
    this.title,
    this.address,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  StationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    address = json['address'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['address'] = address;
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
    if (json['coordinates'] != null) {
      coordinates = <double>[];
      json['coordinates'].forEach((v) {
        coordinates!.add(v.toDouble());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
