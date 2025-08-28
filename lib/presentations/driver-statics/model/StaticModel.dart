class StaticModel{
  final String img;
  final String title;
  final String val;

  StaticModel({required this.img, required this.title, required this.val});
}
class StaticsValueModel {
  num? totalEarn;
  num? cash;
  num? coin;
  num? numberOfTrips;
  num? tripDistance;
  num? activeHours;

  StaticsValueModel(
      {this.totalEarn,
        this.cash,
        this.coin,
        this.numberOfTrips,
        this.tripDistance,
        this.activeHours});

  StaticsValueModel.fromJson(Map<String, dynamic> json) {
    totalEarn = json['totalEarn'];
    cash = json['cash'];
    coin = json['coin'];
    numberOfTrips = json['numberOfTrips'];
    tripDistance = json['tripDistance'];
    activeHours = json['activeHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalEarn'] = totalEarn;
    data['cash'] = cash;
    data['coin'] = coin;
    data['numberOfTrips'] = numberOfTrips;
    data['tripDistance'] = tripDistance;
    data['activeHours'] = activeHours;
    return data;
  }
}
