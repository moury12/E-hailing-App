class DriverLocationUpdateModel {
  String? type;
  List<double>? coordinates;

  DriverLocationUpdateModel({this.type, this.coordinates});

  DriverLocationUpdateModel.fromJson(Map<String, dynamic> json) {
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
