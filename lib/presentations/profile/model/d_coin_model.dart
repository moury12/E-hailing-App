class DcoinModel {
  String? sId;
  int? coin;
  int? mYR;
  String? createdAt;
  String? updatedAt;

  DcoinModel({this.sId, this.coin, this.mYR, this.createdAt, this.updatedAt});

  DcoinModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    coin = json['coin'];
    mYR = json['MYR'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['coin'] = coin;
    data['MYR'] = mYR;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
