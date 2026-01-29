class AssignedCarModel {
  String? sId;
  String? brand;
  String? model;
  String? type;
  String? carClass;
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
  String? eHailingCarPermitImage;
  bool? isAssigned;
  String? createdAt;
  String? updatedAt;
  int? iV;
  AssignedDriver? assignedDriver;

  AssignedCarModel({
    this.sId,
    this.brand,
    this.model,
    this.type,
    this.seats,
    this.carClass,
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
    this.eHailingCarPermitImage,
    this.isAssigned,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.assignedDriver,
  });

  AssignedCarModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    brand = json['brand'];
    model = json['model'];
    type = json['type'];
    carClass = json['class'];
    seats = json['seats'];
    evpNumber = json['evpNumber'];
    evpExpiry = json['evpExpiry'];
    carNumber = json['carNumber'];
    color = json['color'];
    carLicensePlate = json['carLicensePlate'];
    vin = json['vin'];
    insuranceStatus = json['insuranceStatus'];
    registrationDate = json['registrationDate'];
    carImage =
        json['car_image'] != null ? json['car_image'].cast<String>() : null;
    carGrantImage = json['car_grant_image'];
    carInsuranceImage = json['car_insurance_image'];
    eHailingCarPermitImage = json['e_hailing_car_permit_image'];
    isAssigned = json['isAssigned'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    assignedDriver =
        json['assignedDriver'] != null
            ? AssignedDriver.fromJson(json['assignedDriver'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['brand'] = brand;
    data['model'] = model;
    data['type'] = type;
    data['class'] = carClass;
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
    data['e_hailing_car_permit_image'] = eHailingCarPermitImage;
    data['isAssigned'] = isAssigned;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (assignedDriver != null) {
      data['assignedDriver'] = assignedDriver!.toJson();
    }
    return data;
  }
}

class AssignedDriver {
  String? sId;
  String? authId;
  String? name;
  String? email;
  String? role;
  String? profileImage;
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
  bool? isAvailable;
  String? assignedCar;
  int? coins;

  AssignedDriver({
    this.sId,
    this.authId,
    this.name,
    this.email,
    this.role,
    this.profileImage,
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
    this.isAvailable,
    this.assignedCar,
    this.coins,
  });

  AssignedDriver.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    authId = json['authId'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    profileImage = json['profile_image'];
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
    isAvailable = json['isAvailable'];
    assignedCar = json['assignedCar'];
    coins = json['coins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['authId'] = authId;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['profile_image'] = profileImage;
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
    data['isAvailable'] = isAvailable;
    data['assignedCar'] = assignedCar;
    data['coins'] = coins;
    return data;
  }
}

class LocationCoordinates {
  List<double>? coordinates;

  LocationCoordinates({this.coordinates});

  LocationCoordinates.fromJson(Map<String, dynamic> json) {
    coordinates =
        json['coordinates'] != null ? json['coordinates'].cast<double>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    return data;
  }
}
