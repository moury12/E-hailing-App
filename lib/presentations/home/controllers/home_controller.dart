import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/model/car_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/constants/hive_boxes.dart';

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
  RxBool isLoadingCar = false.obs;
  RxBool mapDragable = false.obs;
  RxBool isLoadingPostFair = false.obs;
  RxInt estimatedFare = 0.obs;
  LatLng? lastPickupLatLng;
  LatLng? lastDropoffLatLng;
  RxBool isPolylineDrawn = false.obs;
  RxString selectedAddress = ''.obs;
  RxString activeField = ''.obs; // "pickup" or "dropoff"
  Rx<LatLng?> pickupLatLng = Rx<LatLng?>(null);
  Rx<LatLng?> dropoffLatLng = Rx<LatLng?>(null);
  final RxList<CarModel> carList = <CarModel>[].obs;
  FocusNode pickupFocusNode = FocusNode();
  FocusNode dropOffFocusNode = FocusNode();
  RxInt distance = 0.obs;
  RxInt duration = 0.obs;
  RxString pickupAddressText = 'Drag pin to set your Pickup location'.obs;
  RxString dropoffAddressText = 'Drag pin to set your DropOff location'.obs;
  Rx<TextEditingController> pickupLocationController =
      TextEditingController().obs;
  Rx<TextEditingController> dropOffLocationController =
      TextEditingController().obs;
  AnimationController? controller;
  RxString previousRoute = ''.obs;
  Map<String, dynamic> tripArgs = {};

  bool shouldRedrawPolyline() {
    // Compare current coordinates with previously stored ones
    // Return true if they're different
    return lastPickupLatLng != HomeController.to.pickupLatLng.value ||
        lastDropoffLatLng != HomeController.to.dropoffLatLng.value;
  }

  void resetLocationState() {
    clearAllFocus();
    // Reset polyline state if needed
    isPolylineDrawn.value = false;
    lastPickupLatLng = null;
    lastDropoffLatLng = null;
  }

  void setCurrentLocationOnPickUp() async {
    fetchAndSetAddress(CommonController.to.marketPosition.value);
    HomeController.to.pickupLatLng.value =
        CommonController.to.marketPosition.value;
  }

  void fetchAndSetAddress(LatLng latLng) async {
    pickupLocationController.value.text = await CommonController.to
        .getAddressFromLatLng(latLng);
    pickupAddressText.value = await CommonController.to.getAddressFromLatLng(
      latLng,
    );
  }

  void updatePreviousRoute(String route) {
    previousRoute.value = route;
    update(); // Force rebuild
  }

  bool handleBackNavigation() {
    debugPrint('Previous route: ${Get.previousRoute}');
    debugPrint('Current route: ${Get.currentRoute}');

    // Check if there's a previous route to go back to (excluding nav and root)
    if (Get.previousRoute.isNotEmpty &&
        Get.previousRoute != '/nav' &&
        Get.previousRoute != '/') {
      // if(Get.previousRoute =='/nav'){
      // updatePreviousRoute(Get.currentRoute);
      //   resetAllStates();
      // }
      Get.back();
      return true; // Back navigation handled by Get.back()
    }

    // Handle state transitions within the home screen
    if (selectEv.value) {
      // From Select EV screen -> go back to Set Destination
      selectEv.value = false;
      wantToGo.value = true;
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

  void clearAllFocus() {
    pickupFocusNode.unfocus();
    dropOffFocusNode.unfocus();
    activeField.value = "";
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

  ///------------------------------  get trip fare method -------------------------///

  Future<void> getTripFare({
    required int duration,
    required int distance,
  }) async {
    try {
      isLoadingPostFair.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getTripFareEndpoint,
        method: 'POST',
        body: {"duration": duration, "distance": distance},
      );
      isLoadingPostFair.value = false;
      if (response['success'] == true) {
        estimatedFare.value = response['data']['estimatedFare'];
        goToSelectEv();
        logger.d(response);
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message']);
      }
    } catch (e) {
      isLoadingPostFair.value = false;
      logger.e(e.toString());
    }
  }

  Future<void> getPlaceName(
    LatLng position,
    TextEditingController controller,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        logger.d(place.toString());
        String address =
            ' ${place.subLocality ?? place.subAdministrativeArea} ${place.locality} ${place.country}';
        controller.text = address;

        // ✅ Also update the observable string
        if (setDestination.value) {
          dropoffAddressText.value = address;
        } else {
          pickupAddressText.value = address;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      controller.text = 'unknown location';

      if (setDestination.value) {
        dropoffAddressText.value = 'unknown location';
      } else {
        pickupAddressText.value = 'unknown location';
      }
    }
  }
}
