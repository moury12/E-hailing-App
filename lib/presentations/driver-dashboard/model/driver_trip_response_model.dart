class DriverTripResponseModel {
  PickUpCoordinates? pickUpCoordinates;
  PickUpCoordinates? dropOffCoordinates;
  PickUpCoordinates? driverCoordinates;
  bool? isPeakHourApplied;
  bool? isCouponApplied;
  String? sId;
  String? user;
  String? pickUpAddress;
  String? dropOffAddress;
  num? duration;
  num? distance;
  num? estimatedFare;
  num? tollFee;
  num? extraCharge;
  List<String>? cancellationReason;
  String? status;
  String? createdAt;
  String? updatedAt;
  num? iV;
  String? driver;
  String? driverTripAcceptedAt;
  String? driverArrivedAt;
  num? finalFare;
  String? tripCompletedAt;

  DriverTripResponseModel({
    this.pickUpCoordinates,
    this.dropOffCoordinates,
    this.driverCoordinates,
    this.isPeakHourApplied,
    this.isCouponApplied,
    this.sId,
    this.user,
    this.pickUpAddress,
    this.dropOffAddress,
    this.duration,
    this.distance,
    this.estimatedFare,
    this.tollFee,
    this.extraCharge,
    this.cancellationReason,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.driver,
    this.driverTripAcceptedAt,
    this.driverArrivedAt,
    this.finalFare,
    this.tripCompletedAt,
  });

  DriverTripResponseModel.fromJson(Map<String, dynamic> json) {
    pickUpCoordinates =
        json['pickUpCoordinates'] != null
            ? PickUpCoordinates.fromJson(json['pickUpCoordinates'])
            : null;
    dropOffCoordinates =
        json['dropOffCoordinates'] != null
            ? PickUpCoordinates.fromJson(json['dropOffCoordinates'])
            : null;
    driverCoordinates =
        json['driverCoordinates'] != null
            ? PickUpCoordinates.fromJson(json['driverCoordinates'])
            : null;
    isPeakHourApplied = json['isPeakHourApplied'];
    isCouponApplied = json['isCouponApplied'];
    sId = json['_id'];
    user = json['user'];
    pickUpAddress = json['pickUpAddress'];
    dropOffAddress = json['dropOffAddress'];
    duration = json['duration'];
    distance = json['distance'];
    estimatedFare = json['estimatedFare'];
    tollFee = json['tollFee'];
    extraCharge = json['extraCharge'];
    cancellationReason = json['cancellationReason'].cast<String>();
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    driver = json['driver'];
    driverTripAcceptedAt = json['driverTripAcceptedAt'];
    driverArrivedAt = json['driverArrivedAt'];
    finalFare = json['finalFare'];
    tripCompletedAt = json['tripCompletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pickUpCoordinates != null) {
      data['pickUpCoordinates'] = pickUpCoordinates!.toJson();
    }
    if (dropOffCoordinates != null) {
      data['dropOffCoordinates'] = dropOffCoordinates!.toJson();
    }
    if (driverCoordinates != null) {
      data['driverCoordinates'] = driverCoordinates!.toJson();
    }
    data['isPeakHourApplied'] = isPeakHourApplied;
    data['isCouponApplied'] = isCouponApplied;
    data['_id'] = sId;
    data['user'] = user;
    data['pickUpAddress'] = pickUpAddress;
    data['dropOffAddress'] = dropOffAddress;
    data['duration'] = duration;
    data['distance'] = distance;
    data['estimatedFare'] = estimatedFare;
    data['tollFee'] = tollFee;
    data['extraCharge'] = extraCharge;
    data['cancellationReason'] = cancellationReason;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['driver'] = driver;
    data['driverTripAcceptedAt'] = driverTripAcceptedAt;
    data['driverArrivedAt'] = driverArrivedAt;
    data['finalFare'] = finalFare;
    data['tripCompletedAt'] = tripCompletedAt;
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
