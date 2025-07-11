import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';

class TripResponseModel {
  PickUpCoordinates? pickUpCoordinates;
  PickUpCoordinates? dropOffCoordinates;
  PickUpCoordinates? driverCoordinates;
  String? sId;
  User? user;
  String? pickUpAddress;
  String? dropOffAddress;
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
    cancellationReason =
        (json['cancellationReason'] as List?)?.cast<String>() ?? [];
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
    coordinates = (json['coordinates'] as List?)?.cast<double>() ?? [];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['type'] = type;
    return data;
  }
}

class Driver {
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
  LocationCoordinates? locationCoordinates;
  bool? isAvailable;
  String? idOrPassportNo;
  String? drivingLicenseNo;
  String? licenseType;
  String? licenseExpiry;
  String? psvLicenseImage;
  String? drivingLicenseImage;
  String? userAccountStatus;
  num? outstandingFee;
  String? createdAt;
  String? updatedAt;
  num? iV;
  AssignedCar? assignedCar;

  Driver({
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
    this.locationCoordinates,
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
    this.assignedCar,
  });

  Driver.fromJson(Map<String, dynamic> json) {
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
    locationCoordinates =
        json['locationCoordinates'] != null
            ? LocationCoordinates.fromJson(json['locationCoordinates'])
            : null;
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
    assignedCar =
        json['assignedCar'] != null
            ? AssignedCar.fromJson(json['assignedCar'])
            : null;
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
    data['id_or_passport_image'] = idOrPassportImage;
    if (locationCoordinates != null) {
      data['locationCoordinates'] = locationCoordinates!.toJson();
    }
    data['isAvailable'] = isAvailable;
    data['idOrPassportNo'] = idOrPassportNo;
    data['drivingLicenseNo'] = drivingLicenseNo;
    data['licenseType'] = licenseType;
    data['licenseExpiry'] = licenseExpiry;
    data['psv_license_image'] = psvLicenseImage;
    data['driving_license_image'] = drivingLicenseImage;
    data['userAccountStatus'] = userAccountStatus;
    data['outstandingFee'] = outstandingFee;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (assignedCar != null) {
      data['assignedCar'] = assignedCar!.toJson();
    }
    return data;
  }
}

class LocationCoordinates {
  String? type;
  List<double>? coordinates;

  LocationCoordinates({this.type, this.coordinates});

  LocationCoordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = (json['coordinates'] as List?)?.cast<double>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class AssignedCar {
  String? sId;
  String? brand;
  String? model;
  String? type;
  num? seats;
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
  num? iV;
  String? assignedDriver;

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
    this.eHailingCarPermitImage,
    this.isAssigned,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.assignedDriver,
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
    eHailingCarPermitImage = json['e_hailing_car_permit_image'];
    isAssigned = json['isAssigned'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    assignedDriver = json['assignedDriver'];
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
    data['e_hailing_car_permit_image'] = eHailingCarPermitImage;
    data['isAssigned'] = isAssigned;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['assignedDriver'] = assignedDriver;
    return data;
  }
}
