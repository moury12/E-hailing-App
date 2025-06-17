class CarModel {
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
  String? eHailingCarPermitImage;
  bool? isAssigned;
  String? createdAt;
  String? updatedAt;

  CarModel({
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
  });

  CarModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
