class TripFareModel {
  final double finalFare;
  final String carClass;

  TripFareModel({required this.finalFare, required this.carClass});

  factory TripFareModel.fromJson(Map<String, dynamic> json) {
    return TripFareModel(
      finalFare: (json['finalFare'] ?? 0).toDouble().roundToDouble(),
      carClass: json['class'] ?? '',
    );
  }
}
