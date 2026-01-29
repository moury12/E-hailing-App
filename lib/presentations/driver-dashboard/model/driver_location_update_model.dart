class DriverLocationUpdateModel {
  String? type;
  List<double>? coordinates;

  DriverLocationUpdateModel({this.type, this.coordinates});

  DriverLocationUpdateModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates =
        json['coordinates'] != null ? json['coordinates'].cast<double>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
