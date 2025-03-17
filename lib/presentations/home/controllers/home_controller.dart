import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool wantToGo = false.obs;
  RxBool isBottomSheetOpen = true.obs;
  RxBool isDestination = false.obs;
  RxBool setPickup = false.obs;
  RxBool setDestination = false.obs;
  RxBool selectEv = false.obs;
  RxBool addStops = false.obs;
  RxBool isLoadingNewTrip = false.obs;
  RxBool markerDraging = false.obs;
  RxString placeName = 'Fetching location...'.obs;
  AnimationController? controller;
  Rx<LatLng> marketPosition = LatLng(23.8168, 90.3675).obs;
  @override
  void onInit() {
    getPlaceName(marketPosition.value);
    super.onInit();
  }

  GoogleMapController? mapController;
  void onMapCreated(GoogleMapController controller) {
    mapController ??= controller; // Store and reuse the same controller
  }

  bool handleBackNavigation() {
    debugPrint('Previous route: ${Get.previousRoute}');
    debugPrint('Current route: ${Get.currentRoute}');

    // Check if there's a previous route to go back to (excluding nav and root)
    if (Get.previousRoute.isNotEmpty &&
        Get.previousRoute != '/nav' &&
        Get.previousRoute != '/') {
      Get.back();
      return true; // Back navigation handled by Get.back()
    }

    // Handle state transitions within the home screen
    if (selectEv.value) {
      // From Select EV screen -> go back to Set Destination
      selectEv.value = false;
      setDestination.value = true;
      return true; // Handled - don't exit app
    } else if (setDestination.value) {
      // From Set Destination screen -> go back to Set Pickup
      setDestination.value = false;
      setPickup.value = true;
      return true; // Handled - don't exit app
    } else if (setPickup.value) {
      // From Set Pickup screen -> go back to Want To Go
      setPickup.value = false;
      wantToGo.value = true;
      return true; // Handled - don't exit app
    } else if (wantToGo.value) {
      // From Want To Go screen -> go back to initial state
      wantToGo.value = false;
      return true; // Handled - don't exit app
    }

    // No internal state to handle, allow normal back behavior (exit app)
    return false;
  }

  // Helper method to reset all states
  void resetAllStates() {
    wantToGo.value = false;
    setPickup.value = false;
    setDestination.value = false;
    selectEv.value = false;
  }

  // Optional: Methods for transitioning forward through your flow
  void goToWantToGo() {
    resetAllStates();
    wantToGo.value = true;
  }

  void goToSetPickup() {
    resetAllStates();
    setPickup.value = true;
  }

  void goToSetDestination() {
    resetAllStates();
    setDestination.value = true;
  }

  void goToSelectEv() {
    resetAllStates();
    selectEv.value = true;
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
