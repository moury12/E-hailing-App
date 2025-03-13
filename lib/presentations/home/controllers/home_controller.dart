import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool wantToGo = false.obs;
  RxBool isBottomSheetOpen = true.obs;
  RxBool setPickup = false.obs;
  RxBool addStops = false.obs;
  RxBool markerDraging = false.obs;
  RxString placeName = 'Fetching location...'.obs;
  AnimationController? controller;
  Rx<LatLng> marketPosition = LatLng(23.8168, 90.3675).obs;
  @override
  void onInit() {
    getPlaceName(marketPosition.value);
    super.onInit();
  }
  Future<void> getPlaceName(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        placeName.value = '${place.street} ${place.locality} ${place.country}';
      }
    } catch (e) {
      debugPrint(e.toString());
      placeName.value = 'unknown location';
    }
  }
}
