class TripResponseModel {
  PickUpCoordinates? pickUpCoordinates;
  PickUpCoordinates? dropOffCoordinates;
  PickUpCoordinates? driverCoordinates;
  String? sId;
  User? user;
  String? pickUpAddress;
  String? dropOffAddress;
  int? duration;
  int? distance;
  int? estimatedFare;
  int? tollFee;
  int? extraCharge;
  bool? isPeakHourApplied;
  bool? isCouponApplied;
  List<String>? cancellationReason;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Driver? driver;
  String? driverTripAcceptedAt;

  TripResponseModel({
    this.pickUpCoordinates,
    this.dropOffCoordinates,
    this.driverCoordinates,
    this.sId,
    this.user,
    this.pickUpAddress,
    this.dropOffAddress,
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

  TripResponseModel.fromJson(Map<String, dynamic> json) {
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
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    pickUpAddress = json['pickUpAddress'];
    dropOffAddress = json['dropOffAddress'];
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
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    driverTripAcceptedAt = json['driverTripAcceptedAt'];
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
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['pickUpAddress'] = pickUpAddress;
    data['dropOffAddress'] = dropOffAddress;
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

class User {
  PickUpCoordinates? locationCoordinates;
  String? sId;
  String? authId;
  String? name;
  String? email;
  bool? isOnline;
  String? userAccountStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? role;
  String? phoneNumber;
  int? outstandingFee;

  User({
    this.locationCoordinates,
    this.sId,
    this.authId,
    this.name,
    this.email,
    this.isOnline,
    this.userAccountStatus,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.role,
    this.phoneNumber,
    this.outstandingFee,
  });

  User.fromJson(Map<String, dynamic> json) {
    locationCoordinates =
        json['locationCoordinates'] != null
            ? PickUpCoordinates.fromJson(json['locationCoordinates'])
            : null;
    sId = json['_id'];
    authId = json['authId'];
    name = json['name'];
    email = json['email'];
    isOnline = json['isOnline'];
    userAccountStatus = json['userAccountStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    role = json['role'];
    phoneNumber = json['phoneNumber'];
    outstandingFee = json['outstandingFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (locationCoordinates != null) {
      data['locationCoordinates'] = locationCoordinates!.toJson();
    }
    data['_id'] = sId;
    data['authId'] = authId;
    data['name'] = name;
    data['email'] = email;
    data['isOnline'] = isOnline;
    data['userAccountStatus'] = userAccountStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['role'] = role;
    data['phoneNumber'] = phoneNumber;
    data['outstandingFee'] = outstandingFee;
    return data;
  }
}

class Driver {
  PickUpCoordinates? locationCoordinates;
  String? sId;
  String? authId;
  String? name;
  String? email;
  String? profileImage;
  String? phoneNumber;
  String? address;
  bool? isOnline;
  String? idOrPassportNo;
  String? drivingLicenseNo;
  String? licenseType;
  String? licenseExpiry;
  String? idOrPassportImage;
  String? psvLicenseImage;
  String? drivingLicenseImage;
  String? userAccountStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? role;
  bool? isAvailable;
  int? outstandingFee;

  Driver({
    this.locationCoordinates,
    this.sId,
    this.authId,
    this.name,
    this.email,
    this.profileImage,
    this.phoneNumber,
    this.address,
    this.isOnline,
    this.idOrPassportNo,
    this.drivingLicenseNo,
    this.licenseType,
    this.licenseExpiry,
    this.idOrPassportImage,
    this.psvLicenseImage,
    this.drivingLicenseImage,
    this.userAccountStatus,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.role,
    this.isAvailable,
    this.outstandingFee,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    locationCoordinates =
        json['locationCoordinates'] != null
            ? PickUpCoordinates.fromJson(json['locationCoordinates'])
            : null;
    sId = json['_id'];
    authId = json['authId'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    isOnline = json['isOnline'];
    idOrPassportNo = json['idOrPassportNo'];
    drivingLicenseNo = json['drivingLicenseNo'];
    licenseType = json['licenseType'];
    licenseExpiry = json['licenseExpiry'];
    idOrPassportImage = json['id_or_passport_image'];
    psvLicenseImage = json['psv_license_image'];
    drivingLicenseImage = json['driving_license_image'];
    userAccountStatus = json['userAccountStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    role = json['role'];
    isAvailable = json['isAvailable'];
    outstandingFee = json['outstandingFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (locationCoordinates != null) {
      data['locationCoordinates'] = locationCoordinates!.toJson();
    }
    data['_id'] = sId;
    data['authId'] = authId;
    data['name'] = name;
    data['email'] = email;
    data['profile_image'] = profileImage;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['isOnline'] = isOnline;
    data['idOrPassportNo'] = idOrPassportNo;
    data['drivingLicenseNo'] = drivingLicenseNo;
    data['licenseType'] = licenseType;
    data['licenseExpiry'] = licenseExpiry;
    data['id_or_passport_image'] = idOrPassportImage;
    data['psv_license_image'] = psvLicenseImage;
    data['driving_license_image'] = drivingLicenseImage;
    data['userAccountStatus'] = userAccountStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['role'] = role;
    data['isAvailable'] = isAvailable;
    data['outstandingFee'] = outstandingFee;
    return data;
  }
}
