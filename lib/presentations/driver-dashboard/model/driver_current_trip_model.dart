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
  num? waitingFee;
  bool? isPeakHourApplied;
  bool? isCouponApplied;
  List<String>? cancellationReason;
  String? status;
  String? paymentType;
  String? createdAt;
  String? updatedAt;
  String? tripType;
  String? paymentStatus;
  String? pickUpDate;
  num? iV;
  User? driver;
  String? driverTripAcceptedAt;

  DriverCurrentTripModel({
    this.sId,
    this.user,
    this.tripType,
    this.pickUpAddress,
    this.pickUpCoordinates,
    this.dropOffAddress,
    this.dropOffCoordinates,
    this.driverCoordinates,
    this.duration,
    this.distance,
    this.paymentStatus,
    this.estimatedFare,
    this.tollFee,
    this.waitingFee,
    this.extraCharge,
    this.isPeakHourApplied,
    this.isCouponApplied,
    this.cancellationReason,
    this.status,
    this.paymentType,
    this.createdAt,
    this.updatedAt,
    this.pickUpDate,
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
    paymentStatus = json['paymentStatus'];
    distance = json['distance'];
    estimatedFare = json['estimatedFare'];
    tollFee = json['tollFee'];
    waitingFee = json['waitingFee'];
    tripType = json['tripType'];
    pickUpDate = json['pickUpDate'];
    extraCharge = json['extraCharge'];
    isPeakHourApplied = json['isPeakHourApplied'];
    isCouponApplied = json['isCouponApplied'];
    cancellationReason =
        (json['cancellationReason'] as List?)?.cast<String>() ?? [];
    paymentType = json['paymentType'];
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
    data['waitingFee'] = waitingFee;
    data['paymentStatus'] = paymentStatus;
    data['estimatedFare'] = estimatedFare;
    data['tollFee'] = tollFee;
    data['tripType'] = tripType;
    data['extraCharge'] = extraCharge;
    data['isPeakHourApplied'] = isPeakHourApplied;
    data['isCouponApplied'] = isCouponApplied;
    data['cancellationReason'] = cancellationReason;
    data['paymentType'] = paymentType;
    data['status'] = status;
    data['pickUpDate'] = pickUpDate;
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
  String? authId;
  String? name;
  String? email;
  String? role;
  String? profileImage;
  String? phoneNumber;
  String? address;
  bool? isOnline;
  String? idOrPassportImage;
  bool? isAvailable;
  String? idOrPassportNo;
  String? drivingLicenseNo;
  String? licenseType;
  String? licenseExpiry;
  String? psvLicenseImage;
  String? drivingLicenseImage;
  String? userAccountStatus;
  int? outstandingFee;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User({
    this.sId,
    this.authId,
    this.name,
    this.email,
    this.role,
    this.profileImage,
    this.phoneNumber,
    this.address,
    this.isOnline,
    this.idOrPassportImage,
    this.isAvailable,
    this.idOrPassportNo,
    this.drivingLicenseNo,
    this.licenseType,
    this.licenseExpiry,
    this.psvLicenseImage,
    this.drivingLicenseImage,
    this.userAccountStatus,
    this.outstandingFee,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    authId = json['authId'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    profileImage = json['profile_image'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    isOnline = json['isOnline'];
    idOrPassportImage = json['id_or_passport_image'];
    isAvailable = json['isAvailable'];
    idOrPassportNo = json['idOrPassportNo'];
    drivingLicenseNo = json['drivingLicenseNo'];
    licenseType = json['licenseType'];
    licenseExpiry = json['licenseExpiry'];
    psvLicenseImage = json['psv_license_image'];
    drivingLicenseImage = json['driving_license_image'];
    userAccountStatus = json['userAccountStatus'];
    outstandingFee = json['outstandingFee'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['authId'] = this.authId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['profile_image'] = this.profileImage;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['isOnline'] = this.isOnline;
    data['id_or_passport_image'] = this.idOrPassportImage;
    data['isAvailable'] = this.isAvailable;
    data['idOrPassportNo'] = this.idOrPassportNo;
    data['drivingLicenseNo'] = this.drivingLicenseNo;
    data['licenseType'] = this.licenseType;
    data['licenseExpiry'] = this.licenseExpiry;
    data['psv_license_image'] = this.psvLicenseImage;
    data['driving_license_image'] = this.drivingLicenseImage;
    data['userAccountStatus'] = this.userAccountStatus;
    data['outstandingFee'] = this.outstandingFee;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class PickUpCoordinates {
  List<num>? coordinates;
  String? type;

  PickUpCoordinates({this.coordinates, this.type});

  PickUpCoordinates.fromJson(Map<String, dynamic> json) {
    coordinates = (json['coordinates'] as List?)?.cast<num>() ?? [];
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
  List<num>? coordinates;

  DriverCoordinates({this.coordinates});

  DriverCoordinates.fromJson(Map<String, dynamic> json) {
    coordinates = (json['coordinates'] as List?)?.cast<num>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    return data;
  }
}
