class DriverEarningModel {
  TripPaymentAnalysis? tripPaymentAnalysis;
  List<num>? totalYears;
  MonthlyRevenue? monthlyRevenue;

  DriverEarningModel({
    this.tripPaymentAnalysis,
    this.totalYears,
    this.monthlyRevenue,
  });

  DriverEarningModel.fromJson(Map<String, dynamic> json) {
    tripPaymentAnalysis =
        json['tripPaymentAnalysis'] != null
            ? TripPaymentAnalysis.fromJson(json['tripPaymentAnalysis'])
            : null;
    totalYears = (json['total_years'] as List?)?.cast<num>();
    monthlyRevenue =
        json['monthlyRevenue'] != null
            ? MonthlyRevenue.fromJson(json['monthlyRevenue'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tripPaymentAnalysis != null) {
      data['tripPaymentAnalysis'] = tripPaymentAnalysis!.toJson();
    }
    data['total_years'] = totalYears;
    if (monthlyRevenue != null) {
      data['monthlyRevenue'] = monthlyRevenue!.toJson();
    }
    return data;
  }
}

class TripPaymentAnalysis {
  num? coin;
  num? cash;
  num? online;

  TripPaymentAnalysis({this.coin, this.cash, this.online});

  TripPaymentAnalysis.fromJson(Map<String, dynamic> json) {
    coin = json['coin'];
    cash = json['cash'];
    online = json['online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coin'] = coin;
    data['cash'] = cash;
    data['online'] = online;
    return data;
  }
}

class MonthlyRevenue {
  num? january;
  num? february;
  num? march;
  num? april;
  num? may;
  num? june;
  num? july;
  num? august;
  num? september;
  num? october;
  num? november;
  num? december;

  MonthlyRevenue({
    this.january,
    this.february,
    this.march,
    this.april,
    this.may,
    this.june,
    this.july,
    this.august,
    this.september,
    this.october,
    this.november,
    this.december,
  });

  MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    january = json['January'];
    february = json['February'];
    march = json['March'];
    april = json['April'];
    may = json['May'];
    june = json['June'];
    july = json['July'];
    august = json['August'];
    september = json['September'];
    october = json['October'];
    november = json['November'];
    december = json['December'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['January'] = january;
    data['February'] = february;
    data['March'] = march;
    data['April'] = april;
    data['May'] = may;
    data['June'] = june;
    data['July'] = july;
    data['August'] = august;
    data['September'] = september;
    data['October'] = october;
    data['November'] = november;
    data['December'] = december;
    return data;
  }
}
