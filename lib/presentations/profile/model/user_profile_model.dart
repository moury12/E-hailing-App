class UserProfileModel {
  String? sId;
  AuthId? authId;
  String? name;
  String? email;
  String? role;
  String? img;
  String? phoneNumber;
  String? address;
  bool? isOnline;
  LocationCoordinates? locationCoordinates;
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
  num? coins;
  int? iV;
  int? outstandingFee;
  bool? isAvailable;

  UserProfileModel({
    this.sId,
    this.authId,
    this.name,
    this.email,
    this.role,
    this.img,
    this.phoneNumber,
    this.address,
    this.isOnline,
    this.locationCoordinates,
    this.idOrPassportNo,
    this.drivingLicenseNo,
    this.licenseType,
    this.licenseExpiry,
    this.idOrPassportImage,
    this.psvLicenseImage,
    this.drivingLicenseImage,
    this.userAccountStatus,
    this.createdAt,
    this.coins,
    this.updatedAt,
    this.iV,
    this.outstandingFee,
    this.isAvailable,
  });

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    authId = json['authId'] != null ? AuthId.fromJson(json['authId']) : null;
    name = json['name'];
    email = json['email'];
    role = json['role'];
    img = json['profile_image'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    isOnline = json['isOnline'];
    locationCoordinates =
        json['locationCoordinates'] != null
            ? LocationCoordinates.fromJson(json['locationCoordinates'])
            : null;
    idOrPassportNo = json['idOrPassportNo'];
    drivingLicenseNo = json['drivingLicenseNo'];
    licenseType = json['licenseType'];
    licenseExpiry = json['licenseExpiry'];
    idOrPassportImage = json['id_or_passport_image'];
    psvLicenseImage = json['psv_license_image'];
    drivingLicenseImage = json['driving_license_image'];
    userAccountStatus = json['userAccountStatus'];
    createdAt = json['createdAt'];
    coins = json['coins'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    outstandingFee = json['outstandingFee'];
    isAvailable = json['isAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (authId != null) {
      data['authId'] = authId!.toJson();
    }
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['profile_image'] = img;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['isOnline'] = isOnline;
    if (locationCoordinates != null) {
      data['locationCoordinates'] = locationCoordinates!.toJson();
    }
    data['idOrPassportNo'] = idOrPassportNo;
    data['drivingLicenseNo'] = drivingLicenseNo;
    data['licenseType'] = licenseType;
    data['licenseExpiry'] = licenseExpiry;
    data['id_or_passport_image'] = idOrPassportImage;
    data['psv_license_image'] = psvLicenseImage;
    data['driving_license_image'] = drivingLicenseImage;
    data['userAccountStatus'] = userAccountStatus;
    data['createdAt'] = createdAt;
    data['coins'] = coins;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['outstandingFee'] = outstandingFee;
    data['isAvailable'] = isAvailable;
    return data;
  }
}

class AuthId {
  String? sId;
  String? name;
  String? email;
  String? provider;
  String? role;
  bool? isBlocked;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AuthId({
    this.sId,
    this.name,
    this.email,
    this.provider,
    this.role,
    this.isBlocked,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  AuthId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    provider = json['provider'];
    role = json['role'];
    isBlocked = json['isBlocked'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['provider'] = provider;
    data['role'] = role;
    data['isBlocked'] = isBlocked;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class LocationCoordinates {
  String? type;
  List<double>? coordinates;

  LocationCoordinates({this.type, this.coordinates});

  LocationCoordinates.fromJson(Map<String, dynamic> json) {
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
