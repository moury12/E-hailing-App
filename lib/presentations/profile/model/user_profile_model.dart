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
  String? nrcStatus;
  String? drivingLicenseNo;
  String? licenseType;
  String? licenseExpiry;
  String? idOrPassportImage;
  String? psvLicenseImage;
  String? drivingLicenseImage;
  String? userAccountStatus;
  String? createdAt;
  String? referredBy;
  String? referredCode;
  String? referralCode;
  int? completedReferralCount;
  String? updatedAt;
  String? identificationNum;
  List<dynamic>? nrcImages;

  num? coins;
  num? commission;
  num? balance;
  String? lastPayoutRequest;
  int? iV;
  int? outstandingFee;
  bool? isAvailable;
  AssignedCar? assignedCar;

  UserProfileModel({
    this.sId,
    this.authId,
    this.name,
    this.referredBy,
    this.referredCode,
    this.referralCode,
    this.completedReferralCount,
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
    this.nrcStatus,
    this.licenseExpiry,
    this.idOrPassportImage,
    this.psvLicenseImage,
    this.drivingLicenseImage,
    this.userAccountStatus,
    this.createdAt,
    this.coins,
    this.nrcImages,
    this.identificationNum,
    this.updatedAt,
    this.assignedCar,
    this.iV,
    this.commission,
    this.balance,
    this.lastPayoutRequest,
    this.outstandingFee,
    this.isAvailable,
  });

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    authId = json['authId'] != null ? AuthId.fromJson(json['authId']) : null;
    name = json['name'];
    referredBy = json['referredBy'];
    referredCode = json['referredCode'];
    referralCode = json['referralCode'];
    completedReferralCount = json['completedReferralCount'];
    email = json['email'];
    role = json['role'];
    img = json['profile_image'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    isOnline = json['isOnline'];
    identificationNum = json['identification_number'];
    nrcImages = json['nrc_images'] ?? <String>[];
    isOnline = json['isOnline'];
    nrcStatus = json['nrc_verification_status'];
    assignedCar =
        json['assignedCar'] != null
            ? AssignedCar.fromJson(json['assignedCar'])
            : null;
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
    commission = json['commission'];
    balance = json['balance'];
    lastPayoutRequest = json['lastPayoutRequest'];
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
    data['referredBy'] = referredBy;
    data['referredCode'] = referredCode;
    data['referralCode'] = referralCode;
    data['completedReferralCount'] = completedReferralCount;
    data['email'] = email;
    data['role'] = role;
    data['profile_image'] = img;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['nrc_images'] = nrcImages;
    data['identification_number'] = identificationNum;
    data['isOnline'] = isOnline;
    data['nrc_verification_status'] = nrcStatus;
    if (locationCoordinates != null) {
      data['locationCoordinates'] = locationCoordinates!.toJson();
    }
    data['idOrPassportNo'] = idOrPassportNo;
    if (assignedCar != null) {
      data['assignedCar'] = assignedCar!.toJson();
    }
    data['drivingLicenseNo'] = drivingLicenseNo;
    data['licenseType'] = licenseType;
    data['commission'] = commission;
    data['balance'] = balance;
    data['lastPayoutRequest'] = lastPayoutRequest;
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

class AssignedCar {
  String? sId;
  String? brand;
  String? model;
  String? type;
  int? seats;
  String? evpNumber;
  String? evpExpiry;
  String? carNumber;
  String? color;
  String? carLicensePlate;
  String? vin;
  String? insuranceStatus;
  String? registrationDate;
  List<String>? carImage;
  String? carGrantImage;
  String? carInsuranceImage;
  bool? isAssigned;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? assignedDriver;
  String? eHailingVehiclePermitPdf;

  AssignedCar({
    this.sId,
    this.brand,
    this.model,
    this.type,
    this.seats,
    this.evpNumber,
    this.evpExpiry,
    this.carNumber,
    this.color,
    this.carLicensePlate,
    this.vin,
    this.insuranceStatus,
    this.registrationDate,
    this.carImage,
    this.carGrantImage,
    this.carInsuranceImage,
    this.isAssigned,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.assignedDriver,
    this.eHailingVehiclePermitPdf,
  });

  AssignedCar.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    brand = json['brand'];
    model = json['model'];
    type = json['type'];
    seats = json['seats'];
    evpNumber = json['evpNumber'];
    evpExpiry = json['evpExpiry'];
    carNumber = json['carNumber'];
    color = json['color'];
    carLicensePlate = json['carLicensePlate'];
    vin = json['vin'];
    insuranceStatus = json['insuranceStatus'];
    registrationDate = json['registrationDate'];
    carImage = json['car_image'].cast<String>();
    carGrantImage = json['car_grant_image'];
    carInsuranceImage = json['car_insurance_image'];
    isAssigned = json['isAssigned'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    assignedDriver = json['assignedDriver'];
    eHailingVehiclePermitPdf = json['e_hailing_vehicle_permit_pdf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['brand'] = brand;
    data['model'] = model;
    data['type'] = type;
    data['seats'] = seats;
    data['evpNumber'] = evpNumber;
    data['evpExpiry'] = evpExpiry;
    data['carNumber'] = carNumber;
    data['color'] = color;
    data['carLicensePlate'] = carLicensePlate;
    data['vin'] = vin;
    data['insuranceStatus'] = insuranceStatus;
    data['registrationDate'] = registrationDate;
    data['car_image'] = carImage;
    data['car_grant_image'] = carGrantImage;
    data['car_insurance_image'] = carInsuranceImage;
    data['isAssigned'] = isAssigned;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['assignedDriver'] = assignedDriver;
    data['e_hailing_vehicle_permit_pdf'] = eHailingVehiclePermitPdf;
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
