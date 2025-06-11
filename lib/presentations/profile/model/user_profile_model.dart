class UserProfileModel {
  String? sId;
  AuthId? authId;
  String? name;
  String? img;
  String? email;
  String? role;
  String? phoneNumber;
  bool? isOnline;
  LocationCoordinates? locationCoordinates;
  String? userAccountStatus;
  int? outstandingFee;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserProfileModel(
      {this.sId,
        this.authId,
        this.name,
        this.img,
        this.email,
        this.role,
        this.phoneNumber,
        this.isOnline,
        this.locationCoordinates,
        this.userAccountStatus,
        this.outstandingFee,
        this.createdAt,
        this.updatedAt,
        this.iV});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    authId =
    json['authId'] != null ? AuthId.fromJson(json['authId']) : null;
    name = json['name'];
    img = json["profile_image"];
    email = json['email'];
    role = json['role'];
    phoneNumber = json['phoneNumber'];
    isOnline = json['isOnline'];
    locationCoordinates = json['locationCoordinates'] != null
        ? LocationCoordinates.fromJson(json['locationCoordinates'])
        : null;
    userAccountStatus = json['userAccountStatus'];
    outstandingFee = json['outstandingFee'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (authId != null) {
      data['authId'] = authId!.toJson();
    }
    data['name'] = name;
    data["profile_image"] = img;
    data['email'] = email;
    data['role'] = role;
    data['phoneNumber'] = phoneNumber;
    data['isOnline'] = isOnline;
    if (locationCoordinates != null) {
      data['locationCoordinates'] = locationCoordinates!.toJson();
    }
    data['userAccountStatus'] = userAccountStatus;
    data['outstandingFee'] = outstandingFee;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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

  AuthId(
      {this.sId,
        this.name,
        this.email,
        this.provider,
        this.role,
        this.isBlocked,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV});

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
