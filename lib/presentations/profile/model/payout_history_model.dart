class PayoutHistoryModel {
  String? sId;
  String? user;
  int? amount;
  String? status;
  String? paymentMethod;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PayoutHistoryModel({
    this.sId,
    this.user,
    this.amount,
    this.status,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  PayoutHistoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    amount = json['amount'];
    status = json['status'];
    paymentMethod = json['paymentMethod'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['amount'] = amount;
    data['status'] = status;
    data['paymentMethod'] = paymentMethod;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
