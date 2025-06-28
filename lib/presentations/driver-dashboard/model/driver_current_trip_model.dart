class DriverCurrentTripModel {
  String? sId;
  User? user;
  String? pickUpAddress;
  PickUpCoordinates? pickUpCoordinates;
  String? dropOffAddress;
  PickUpCoordinates? dropOffCoordinates;
  DriverCoordinates? driverCoordinates;
  num? duration;
  num? distance;
  num? estimatedFare;
  num? tollFee;
  num? extraCharge;
  bool? isPeakHourApplied;
  bool? isCouponApplied;
  List<String>? cancellationReason;
  String? status;
  String? createdAt;
  String? updatedAt;
  num? iV;
  User? driver;
  String? driverTripAcceptedAt;

  DriverCurrentTripModel({
    this.sId,
    this.user,
    this.pickUpAddress,
    this.pickUpCoordinates,
    this.dropOffAddress,
    this.dropOffCoordinates,
    this.driverCoordinates,
    this.duration,
    this.distance,
    this.estimatedFare,
    this.tollFee,
    this.extraCharge,
    this.isPeakHourApplied,
    this.isCouponApplied,
    this.cancellationReason,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.driver,
    this.driverTripAcceptedAt,
  });

  DriverCurrentTripModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    pickUpAddress = json['pickUpAddress'];
    pickUpCoordinates =
        json['pickUpCoordinates'] != null
            ? PickUpCoordinates.fromJson(json['pickUpCoordinates'])
            : null;
    dropOffAddress = json['dropOffAddress'];
    dropOffCoordinates =
        json['dropOffCoordinates'] != null
            ? PickUpCoordinates.fromJson(json['dropOffCoordinates'])
            : null;
    driverCoordinates =
        json['driverCoordinates'] != null
            ? DriverCoordinates.fromJson(json['driverCoordinates'])
            : null;
    duration = json['duration'];
    distance = json['distance'];
    estimatedFare = json['estimatedFare'];
    tollFee = json['tollFee'];
    extraCharge = json['extraCharge'];
    isPeakHourApplied = json['isPeakHourApplied'];
    isCouponApplied = json['isCouponApplied'];
    cancellationReason = json['cancellationReason'].cast<String>();
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    driver = json['driver'] != null ? User.fromJson(json['driver']) : null;
    driverTripAcceptedAt = json['driverTripAcceptedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['pickUpAddress'] = pickUpAddress;
    if (pickUpCoordinates != null) {
      data['pickUpCoordinates'] = pickUpCoordinates!.toJson();
    }
    data['dropOffAddress'] = dropOffAddress;
    if (dropOffCoordinates != null) {
      data['dropOffCoordinates'] = dropOffCoordinates!.toJson();
    }
    if (driverCoordinates != null) {
      data['driverCoordinates'] = driverCoordinates!.toJson();
    }
    data['duration'] = duration;
    data['distance'] = distance;
    data['estimatedFare'] = estimatedFare;
    data['tollFee'] = tollFee;
    data['extraCharge'] = extraCharge;
    data['isPeakHourApplied'] = isPeakHourApplied;
    data['isCouponApplied'] = isCouponApplied;
    data['cancellationReason'] = cancellationReason;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    data['driverTripAcceptedAt'] = driverTripAcceptedAt;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? profileImage;

  User({this.sId, this.name, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['profile_image'] = profileImage;
    return data;
  }
}

class PickUpCoordinates {
  List<double>? coordinates;
  String? type;

  PickUpCoordinates({this.coordinates, this.type});

  PickUpCoordinates.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['type'] = type;
    return data;
  }
}

class DriverCoordinates {
  List<double>? coordinates;

  DriverCoordinates({this.coordinates});

  DriverCoordinates.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    return data;
  }
}
