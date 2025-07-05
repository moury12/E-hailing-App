class ConversationModel {
  String? sId;
  List<Participants>? participants;
  List<String>? messages;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? unRead;

  ConversationModel({
    this.sId,
    this.participants,
    this.messages,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.unRead,
  });

  ConversationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    messages = json['messages'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    unRead = json['unRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    data['messages'] = messages;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['unRead'] = unRead;
    return data;
  }
}

class Participants {
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
  LocationCoordinates? locationCoordinates;
  int? outstandingFee;

  Participants({
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
    this.locationCoordinates,
    this.outstandingFee,
  });

  Participants.fromJson(Map<String, dynamic> json) {
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
    locationCoordinates =
        json['locationCoordinates'] != null
            ? LocationCoordinates.fromJson(json['locationCoordinates'])
            : null;
    outstandingFee = json['outstandingFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    if (locationCoordinates != null) {
      data['locationCoordinates'] = locationCoordinates!.toJson();
    }
    data['outstandingFee'] = outstandingFee;
    return data;
  }
}

class LocationCoordinates {
  List<double>? coordinates;
  String? type;

  LocationCoordinates({this.coordinates, this.type});

  LocationCoordinates.fromJson(Map<String, dynamic> json) {
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
