import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_location_update_model.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_cancellation_model.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../navigation/controllers/navigation_controller.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool wantToGo = false.obs;
  RxBool isBottomSheetOpen = true.obs;
  RxBool isDestination = false.obs;
  RxBool setPickup = false.obs;
  RxBool setDestination = false.obs;
  RxBool selectEv = false.obs;
  RxBool showTripDetailsCard = false.obs;
  RxBool isLoadingNewTrip = false.obs;
  RxBool isLoadingUserCurrentTrip = false.obs;
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
  final locationService = LocationTrackingService();
  RxInt distance = 0.obs;
  RxInt duration = 0.obs;
  RxBool isCancellingTrip = false.obs;

  RxString pickupAddressText = 'Drag pin to set your Pickup location'.obs;
  RxString dropoffAddressText = 'Drag pin to set your DropOff location'.obs;
  Rx<TextEditingController> pickupLocationController =
      TextEditingController().obs;
  Rx<TextEditingController> dropOffLocationController =
      TextEditingController().obs;
  AnimationController? controller;
  RxString previousRoute = ''.obs;
  RxString driverStatus = ''.obs;
  Map<String, dynamic> tripArgs = {};
  final SocketService socket = SocketService();
  RxString status = "Disconnected".obs;
  RxBool isRequestingTrip = false.obs;
  RxBool hasActiveTrip = false.obs;
  Rx<Map<String, dynamic>?> currentTrip = Rx<Map<String, dynamic>?>(null);
  Rx<TripResponseModel> tripAcceptedModel = TripResponseModel().obs;
  Rx<DriverLocationUpdateModel> driverLocationUpdate =
      DriverLocationUpdateModel().obs;
  List<String> cancelReason = [];
  Rx<LatLng?> driverPosition = Rx<LatLng?>(null);

  @override
  void onInit() async {
    initializeSocket();
    await getUserCurrentTrip();

    super.onInit();
  }

  void polyLineShow() async {
    if (tripAcceptedModel.value.sId != null) {
      resetAllStates();
      showTripDetailsCard.value = true;
      await locationService.drawPolylineBetweenPoints(
        LatLng(
          double.parse(
            tripAcceptedModel.value.pickUpCoordinates!.coordinates!.last
                .toString(),
          ),
          double.parse(
            tripAcceptedModel.value.pickUpCoordinates!.coordinates!.first
                .toString(),
          ),
        ),
        LatLng(
          double.parse(
            tripAcceptedModel.value.dropOffCoordinates!.coordinates!.last
                .toString(),
          ),
          double.parse(
            tripAcceptedModel.value.dropOffCoordinates!.coordinates!.first
                .toString(),
          ),
        ),
        NavigationController.to.routePolylines,
        userPosition: CommonController.to.markerPositionRider.value,
        mapController: CommonController.to.mapControllerRider,
      );
      if (tripAcceptedModel.value.status ==
          DriverTripStatus.destination_reached.name) {
        Get.toNamed(
          PaymentPage.routeName,
          arguments: {"user": tripAcceptedModel.value, "role": user},
        );
      }
    }
  }

  void resetHomePage() {
    // Clear polyline
    isPolylineDrawn.value = false;
    lastPickupLatLng = null;
    lastDropoffLatLng = null;

    // Clear any existing polylines from the map
    if (NavigationController.to.routePolylines.isNotEmpty) {
      NavigationController.to.routePolylines.clear();
    }

    // Clear drop off location
    dropoffLatLng.value = null;
    dropoffAddressText.value = 'Drag pin to set your DropOff location';
    dropOffLocationController.value.clear();

    // Set pickup location to user's current location
    if (CommonController.to.markerPositionRider.value != null) {
      setCurrentLocationOnPickUp();
    } else {
      // If current location is not available, reset pickup to default
      pickupLatLng.value = null;
      pickupAddressText.value = 'Drag pin to set your Pickup location';
      pickupLocationController.value.clear();
    }

    // Clear active field focus
    clearAllFocus();

    // Reset other related states
    distance.value = 0;
    duration.value = 0;
    estimatedFare.value = 0;
    resetAllStates();
  }

  void initializeSocket() {
    if (!socket.isConnected) {
      socketConnection(); // your own connect method
    }

    registerTripEventListeners();

    socket.onConnected = () {
      logger.i("Reconnected");
      registerTripEventListeners(); // re-register on reconnect
    };
  }

  void registerTripEventListeners() {
    logger.i("Listening socket event for rider");


    // Always clean up old listeners
    socket.off(TripEvents.tripRequested);
    socket.off(TripEvents.tripNoDriverFound);
    socket.off(TripEvents.tripAccepted);
    socket.off(TripEvents.tripDriverLocationUpdate);
    socket.off(TripEvents.tripUpdateStatus);

    // Now re-register
    socket.on(TripEvents.tripRequested, (data) {
      logger.d('🚕 tripRequested: $data');
      currentTrip.value = data;
      status.value = 'Trip requested successfully';
      isRequestingTrip.value = false;
      hasActiveTrip.value = true;
      showCustomSnackbar(
        title: 'Success',
        message: 'Trip requested successfully! Looking for nearby drivers...',
      );
    });

    socket.on(TripEvents.tripNoDriverFound, (data) {
      logger.w('❌ No driver found: $data');
      status.value = "No drivers available";
      isRequestingTrip.value = false;
      hasActiveTrip.value = false;
      if (Get.isDialogOpen == true) Get.back();
      showCustomSnackbar(
        title: 'No Drivers Available',
        message: 'Sorry, no drivers are available in your area right now.',
      );
      Future.delayed(Duration(seconds: 2), () {
        Get.back();
      });
      resetHomePage();
    });

    socket.on(TripEvents.tripAccepted, (data) {
      logger.i('✅ Trip accepted: $data');
      status.value = "Driver found! Trip accepted";
      resetAllStates();
      logger.i("Dialog open? ${Get.isDialogOpen}");
      // if (Get.isDialogOpen == true) {
      //   Get.back();
      // }
      tripAcceptedModel.value = TripResponseModel.fromJson(data['data']);
      polyLineShow();

      Get.offAndToNamed(TripDetailsPage.routeName);
    });

    socket.on(TripEvents.tripDriverLocationUpdate, (data) {
      logger.d('📍 Driver location update: $data');
      driverLocationUpdate.value = DriverLocationUpdateModel.fromJson(
        data['data'],
      );
      updateDriverLocation();
    });

    socket.on(TripEvents.tripUpdateStatus, (data) {
      logger.d('🔄 Trip status update: $data');
      if (data['success']) {
        showCustomSnackbar(title: "Trip Status", message: data['message']);
        tripAcceptedModel.value = TripResponseModel.fromJson(data['data']);
        driverStatus.value = data['message'];
        HomeController.to.showTripDetailsCard.value = true;

        final status = data['data']['status'];
        if (status == DriverTripStatus.cancelled.name ||
            status == DriverTripStatus.completed.name) {
          resetAllStates();
          Get.offAllNamed(
            NavigationPage.routeName,
            arguments: {'reconnectSocket': true},
          );
          for (TripCancellationModel cancel in tripCancellationList) {
            cancel.isChecked.value = false;
          }
          isCancellingTrip.value = false;
        } else if (status == DriverTripStatus.destination_reached.name) {
          Get.toNamed(
            PaymentPage.routeName,
            arguments: {"user": tripAcceptedModel.value, "role": user},
          );
        }
      }
    });
  }

  void socketConnection() {
    String userId = CommonController.to.userModel.value.sId ?? "";

    if (userId.isNotEmpty) {
      socket.connect(userId, false);
    } else {
      logger.e('User ID is empty, cannot connect to socket');
    }
  }

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
    fetchAndSetAddress(CommonController.to.markerPositionRider.value);
    HomeController.to.pickupLatLng.value =
        CommonController.to.markerPositionRider.value;
  }

  void fetchAndSetAddress(LatLng latLng) async {
    final locationService = LocationTrackingService();
    pickupLocationController.value.text = await locationService
        .getAddressFromLatLng(latLng);
    pickupAddressText.value = await locationService.getAddressFromLatLng(
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
    }finally{
      isLoadingPostFair.value = false;
    }
  }

  void updateDriverLocation() {
    final updateCoords = driverLocationUpdate.value.coordinates;
    final fallbackCoords =
        tripAcceptedModel.value.driver?.locationCoordinates?.coordinates;

    if (updateCoords != null && updateCoords.length >= 2) {
      driverPosition.value = LatLng(updateCoords.last, updateCoords.first);
    } else if (fallbackCoords != null && fallbackCoords.length >= 2) {
      driverPosition.value = LatLng(fallbackCoords.last, fallbackCoords.first);
    } else {
      driverPosition.value = null;
    }

    // Wait until map controller is ready
    Future.delayed(Duration(milliseconds: 300), () {
      if (CommonController.to.mapControllerRider != null) {
        polyLineShow();
      } else {
        debugPrint("❌ Map controller not ready, retrying polyline...");
        // Retry once more after short delay
        Future.delayed(Duration(milliseconds: 300), () {
          if (CommonController.to.mapControllerRider != null) {
            polyLineShow();
          }
        });
      }
    });
  }

  ///------------------------------  get current trip method -------------------------///

  Future<void> getUserCurrentTrip() async {
    try {
      isLoadingUserCurrentTrip.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getUserCurrentTripEndpoint,
        method: 'GET',
      );
      if (response['success'] == true) {
        tripAcceptedModel.value = TripResponseModel.fromJson(response['data']);
        driverStatus.value = tripAcceptedModel.value.status.toString();
        updateDriverLocation();
      } else {
        isLoadingUserCurrentTrip.value = false;

        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(title: 'Failed', message: response['message']);
        }
      }
    } catch (e) {
      isLoadingUserCurrentTrip.value = false;
      logger.e(e.toString());
    } finally {
      isLoadingUserCurrentTrip.value = false;
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

  Future<void> requestTrip({required Map<String, dynamic> body}) async {
    if (!socket.isConnected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.failed,
      );
      socketConnection();
      return;
    }
    isRequestingTrip.value = true;
    status.value = 'Requesting trip...';
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(Get.context!).size.width * 0.8,
          child: TripRequestLoadingWidget(
            pickUpAddress: body['pickUpAddress'],
            dropOffAddress: body['dropOffAddress'],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    socket.emit(TripEvents.tripRequested, body);
    // Future.delayed(Duration(seconds: 30), () {
    //   if (isRequestingTrip.value) {
    //     isRequestingTrip.value = false;
    //     Get.back(); // Close loading dialog
    //     showCustomSnackbar(
    //       title: 'Request Timeout',
    //       message: 'Trip request timed out. Please try again.',
    //       type: SnackBarType.failed,
    //     );
    //   }
    // });
  }

  Future<void> updateUserTrip({
    required String tripId,
    required String status,
    List<String>? reason,
  }) async {
    if (!socket.isConnected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.failed,
      );
      socketConnection();
      return;
    }

    // Set loading state if it's a cancellation
    if (status == DriverTripStatus.cancelled.name) {
      isCancellingTrip.value = true;
    }

    try {
      socket.emit(DriverEvent.tripUpdateStatus, {
        "tripId": tripId,
        "newStatus": status,
        if (reason != null) "reason": reason,
      });

      // Note: The loading state will be reset when the socket response comes back
      // in your registerTripEventListeners() -> tripUpdateStatus event
    } catch (e) {
      // Reset loading state on error
      if (status == DriverTripStatus.cancelled.name) {
        isCancellingTrip.value = false;
      }
      logger.e('Error updating trip: $e');
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to update trip. Please try again.',
        type: SnackBarType.failed,
      );
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
