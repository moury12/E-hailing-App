import 'dart:async';

import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../navigation/controllers/navigation_controller.dart';
import '../model/trip_fare_model.dart';

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
  RxBool isLoadingPostReview = false.obs;
  RxBool isLoadingCar = false.obs;
  RxBool mapDragable = false.obs;
  RxBool mapDraging = false.obs;
  RxBool isLoadingPostFair = false.obs;
  RxList<TripFareModel> estimatedFares = <TripFareModel>[].obs;
  Rx<TripFareModel?> selectedFare = Rx<TripFareModel?>(null);
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
  RxString tripType = "ride".obs;
  RxString tripClass = "DUDU".obs;
  List<String> get tripDetailsTabs {
    return [AppStaticStrings.carInfo.tr, AppStaticStrings.driverReview.tr].obs;
  }

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
  var selectedPaymentMethod = Rx<String?>(null);
  TextEditingController promoCode = TextEditingController();
  Map<String, dynamic> tripArgs = {};
  final socket = SocketService();
  RxString status = "Disconnected".obs;
  RxBool isRequestingTrip = false.obs;
  RxBool hasActiveTrip = false.obs;
  Rx<Map<String, dynamic>?> currentTrip = Rx<Map<String, dynamic>?>(null);
  Rx<TripResponseModel> tripAcceptedModel = TripResponseModel().obs;
  Rx<DriverLocationUpdateModel> driverLocationUpdate =
      DriverLocationUpdateModel().obs;
  List<String> cancelReason = [];
  Rx<LatLng?> driverPosition = Rx<LatLng?>(null);
  Timer? _debouncePickup;
  Timer? _debounceDropoff;

  // Other methods for handling suggestions

  void fetchSuggestedPlaces(String query, String type) {
    if (type == 'pickup') {
      CommonController.to.fetchSuggestedPlacesWithRadius(query);
    } else if (type == 'dropoff') {
      CommonController.to.fetchSuggestedPlacesWithRadius(query);
    }
  }

  void debouncePickupLocation(String value) {
    if (_debouncePickup?.isActive ?? false) _debouncePickup!.cancel();
    _debouncePickup = Timer(const Duration(milliseconds: 500), () {
      fetchSuggestedPlaces(value, 'pickup');
    });
  }

  void debounceDropoffLocation(String value) {
    if (_debounceDropoff?.isActive ?? false) _debounceDropoff!.cancel();
    _debounceDropoff = Timer(const Duration(milliseconds: 500), () {
      fetchSuggestedPlaces(value, 'dropoff');
    });
  }

  @override
  void onInit() async {
    initializeSocket();
    await getUserCurrentTrip();
    if (tripAcceptedModel.value.pickUpCoordinates != null &&
        tripAcceptedModel.value.dropOffCoordinates != null) {
      pickupLatLng.value = LatLng(
        double.parse(
          tripAcceptedModel.value.pickUpCoordinates!.coordinates!.last
              .toString(),
        ),
        double.parse(
          tripAcceptedModel.value.pickUpCoordinates!.coordinates!.first
              .toString(),
        ),
      );
      dropoffLatLng.value = LatLng(
        double.parse(
          tripAcceptedModel.value.dropOffCoordinates!.coordinates!.last
              .toString(),
        ),
        double.parse(
          tripAcceptedModel.value.dropOffCoordinates!.coordinates!.first
              .toString(),
        ),
      );
    }
    super.onInit();
  }

  void polyLineShow() async {
    if (tripAcceptedModel.value.sId != null) {
      resetAllStates();
      showTripDetailsCard.value = true;

      // Clear old polylines before drawing new ones
      NavigationController.to.clearPolyline();

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
        type: PolylineType.pickupToDropoff,
      );
      final driverCoords =
          tripAcceptedModel.value.driverCoordinates?.coordinates;
      final pickupCoords =
          tripAcceptedModel.value.pickUpCoordinates?.coordinates;

      if (driverCoords != null &&
          driverCoords.length >= 2 &&
          pickupCoords != null &&
          pickupCoords.length >= 2) {
        double distanceInMeters = Geolocator.distanceBetween(
          pickupCoords.last,
          pickupCoords.first,
          driverCoords.last,
          driverCoords.first,
        );
        if (distanceInMeters >= 100 &&
            (tripAcceptedModel.value.status == 'on_the_way' ||
                tripAcceptedModel.value.status == 'accepted')) {
          await locationService.drawPolylineBetweenPoints(
            LatLng(driverCoords.last, driverCoords.first), // start
            LatLng(pickupCoords.last, pickupCoords.first), // end
            NavigationController.to.routePolylinesDrivers,
            userPosition: LatLng(driverCoords.last, driverCoords.first),
            mapController: CommonController.to.mapControllerRider,
            type: PolylineType.driverToPickup,
            distance: int.tryParse(distanceInMeters.toString())?.obs ?? 0.obs,
            duration:
                int.tryParse(
                  tripAcceptedModel.value.duration?.toString() ?? '0',
                )?.obs ??
                0.obs,
          );
        }
      }

      /*     }*/

      if (tripAcceptedModel.value.status ==
          DriverTripStatus.destination_reached.name) {
        Get.toNamed(
          PaymentPage.routeName,
          arguments: {"user": tripAcceptedModel.value, "role": user},
        );
      }
    }
  }

  ///------------------------------ Post Review method -------------------------///

  Future<void> postReviewRatingRequest({
    required String rating,
    required String review,
    required String carId,
  }) async {
    try {
      isLoadingPostReview.value = true;

      final response = await ApiService().request(
        endpoint: postReviewEndpoint,
        method: 'POST',
        body: {"rating": rating, "review": review, "carId": carId},
      );

      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        Boxes.getRattingData().delete("rating");

        Navigator.pop(Get.context!);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      // loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    } finally {
      isLoadingPostReview.value = false;
    }
  }

  void resetHomePage() {
    // Clear polyline
    isPolylineDrawn.value = false;
    lastPickupLatLng = null;
    lastDropoffLatLng = null;

    // Clear any existing polylines from the map

    // Clear drop off location
    dropoffLatLng.value = null;
    dropoffAddressText.value = 'Drag pin to set your DropOff location';
    dropOffLocationController.value.clear();

    // Set pickup location to user's current location
    setCurrentLocationOnPickUp();

    // Clear active field focus
    clearAllFocus();

    // Reset other related states
    distance.value = 0;
    duration.value = 0;
    estimatedFare.value = 0;
    resetAllStates();
  }

  void initializeSocket() {
    if (socket.socket == null || !socket.socket!.connected) {
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
    socket.off(PaymentEvent.paymentPaid);
    // Now re-register
    socket.on(TripEvents.tripRequested, (data) {
      logger.d('🚕 tripRequested: $data');

      if (data['data']['tripType'] == "pre_book") {
        showCustomSnackbar(
          title: 'Pre Booked ride successfully!',
          message: 'Request sent to admin panel admin will assign you driver!!',
        );
        resetAllStates();
        Get.offAllNamed(
          NavigationPage.routeName,
          arguments: {'reconnectSocket': true /*"pre_book":true*/},
        );
      } else {
        currentTrip.value = data;
        isCancellingTrip.value = false;
      }
    });
    socket.on(PaymentEvent.paymentPaid, (data) {
      logger.d('payment paid: $data');
      CommonController.to.isPaid.value = data['success'];
      if (data['success']) {
        getUserCurrentTrip();
      }
      showCustomSnackbar(title: 'Success', message: data['message']);
    });

    socket.on(TripEvents.tripNoDriverFound, (data) {
      logger.w('❌ No driver found: $data');
      status.value = "No drivers available";
      isRequestingTrip.value = false;
      hasActiveTrip.value = false;
      if (Get.isDialogOpen == true) Get.back();
      // showCustomSnackbar(
      //   title: 'No Drivers Available',
      //   message: 'Sorry, no drivers are available in your area right now.',
      // );

      resetAllStates();
      Get.offAllNamed(
        NavigationPage.routeName,
        arguments: {'reconnectSocket': true},
      ); // Get.back(); Get.back();
    });

    socket.on(TripEvents.tripAccepted, (data) {
      logger.d('✅ Trip accepted: ');
      driverStatus.value = data["message"];
      logger.d(data);
      status.value = "Driver found! Trip accepted";
      resetAllStates();
      logger.i("Dialog open? ${Get.isDialogOpen}");
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      updateDriverLocation();
      tripAcceptedModel.value = TripResponseModel.fromJson(data['data']);
      if (tripAcceptedModel.value.tripType != preBook) {
        CommonController.to.getReviewListRequest(
          driverId: tripAcceptedModel.value.driver!.sId.toString(),
        );

        polyLineShow();
        pickupLatLng.value = LatLng(
          double.parse(
            tripAcceptedModel.value.pickUpCoordinates!.coordinates!.last
                .toString(),
          ),
          double.parse(
            tripAcceptedModel.value.pickUpCoordinates!.coordinates!.first
                .toString(),
          ),
        );
        dropoffLatLng.value = LatLng(
          double.parse(
            tripAcceptedModel.value.dropOffCoordinates!.coordinates!.last
                .toString(),
          ),
          double.parse(
            tripAcceptedModel.value.dropOffCoordinates!.coordinates!.first
                .toString(),
          ),
        );
        Get.offAndToNamed(TripDetailsPage.routeName);
      } else {
        resetAllStates();
        Get.offAllNamed(
          NavigationPage.routeName,
          arguments: {'reconnectSocket': true, "pre_book": true},
        );

        /// TODO
      }
    });

    socket.on(TripEvents.tripDriverLocationUpdate, (data) {
      logger.d('📍 Driver location update: $data');
      driverLocationUpdate.value = DriverLocationUpdateModel.fromJson(
        data['data'],
      );
      updateDriverLocation();
    });
    socket.on(TripEvents.tripUpdateStatus, (data) {
      logger.d('🔄 Trip status update:');
      logger.d(data);
      driverStatus.value = "";
      if (data['success']) {
        // showCustomSnackbar(title: "Trip Status", message: data['message']);
        tripAcceptedModel.value = TripResponseModel.fromJson(data['data']);
        driverStatus.value = data['message'];
        showTripDetailsCard.value = true;
        // updateDriverLocation();
        final status = data['data']['status'];
        if (status == DriverTripStatus.cancelled.name ||
            status == DriverTripStatus.completed.name) {
          driverStatus.value = "";
          if (status == DriverTripStatus.completed.name) {
            // NavigationController.to.currentNavIndex.value=1;
            // MyRideController.to.currentTabIndex.value =2;
            Boxes.getRattingData().put(
              "rating",
              tripAcceptedModel.value.driver?.assignedCar?.sId.toString(),
            );
          }
          tripAcceptedModel.value = TripResponseModel();
          resetAllStates();
          dropOffLocationController.value.clear();
          dropoffLatLng.value = null;
          NavigationController.to.clearPolyline();
          driverPosition.value = null;
          showTripDetailsCard.value = false;

          Get.offAllNamed(
            NavigationPage.routeName,
            arguments: {'reconnectSocket': true},
          );

          for (TripCancellationModel cancel
              in CommonController.to.tripCancellationList) {
            cancel.isChecked.value = false;
          }
          // isCancellingTrip.value = false;
        } else if (status == DriverTripStatus.destination_reached.name) {
          Get.toNamed(
            PaymentPage.routeName,
            arguments: {"user": tripAcceptedModel.value, "role": user},
          );
        }
      }
    });
    socket.on(PaymentEvent.paymentPaid, (data) {
      logger.d('payment paid: $data');
      CommonController.to.isPaid.value = data['success'];
      // if (data['success']) {
      //   getDriverCurrentTripRequest();
      // }
      showCustomSnackbar(title: 'Success', message: data['message']);
    });
    // socket.on(TripEvents.tripUpdateStatus, (data) {
    //   logger.d('🔄 Trip status update:');
    //   logger.d(data);
    //   if (data['success']) {
    //     // showCustomSnackbar(title: "Trip Status", message: data['message']);
    //     tripAcceptedModel.value = TripResponseModel.fromJson(data['data']);
    //     driverStatus.value = data['message'];
    //    showTripDetailsCard.value = true;
    //      // updateDriverLocation();
    //     final status = data['data']['status'];
    //     if (status == DriverTripStatus.cancelled.name ||
    //         status == DriverTripStatus.completed.name) {
    //       if(status == DriverTripStatus.completed.name){
    //         Get.offAll(PaymentInvoicePage(isDriver: false,rideModel: tripAcceptedModel,fromCompleteTrip: true,));
    //         resetAllStates();
    //         NavigationController.to.clearPolyline();
    //         showTripDetailsCard.value = false;
    //       }
    //
    //
    //       else{
    //         Get.offAllNamed(
    //           NavigationPage.routeName,
    //           arguments: {'reconnectSocket': true},
    //         );
    //         resetAllStates();
    //         NavigationController.to.clearPolyline();
    //         showTripDetailsCard.value = false;
    //       }
    //       if (status == DriverTripStatus.completed.name) {
    //
    //         Boxes.getRattingData().put(
    //           "rating",
    //           tripAcceptedModel.value.driver!.assignedCar!.sId.toString(),
    //         );
    //         // showRatingDialogs(
    //         //   carId:
    //         //       tripAcceptedModel.value.driver!.assignedCar!.sId.toString(),
    //         // );
    //       }
    //       for (TripCancellationModel cancel in CommonController.to.tripCancellationList) {
    //         cancel.isChecked.value = false;
    //       }
    //       // isCancellingTrip.value = false;
    //     } else if (status == DriverTripStatus.destination_reached.name) {
    //       Get.toNamed(
    //         PaymentPage.routeName,
    //         arguments: {"user": tripAcceptedModel.value, "role": user},
    //       );
    //     }
    //   }
    // });
  }

  void socketConnection() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(
      Boxes.getUserData().get(tokenKey).toString(),
    );

    socket.connect(decodedToken['userId'], decodedToken['role'] == "DRIVER");
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
        body: {
          "duration": duration,
          "distance": distance,
          // "tripClass": tripClass.value,
        },
      );

      if (response['success'] == true) {
        estimatedFares.value =
            (response['data']['estimatedFare'] as List)
                .map((e) => TripFareModel.fromJson(e))
                .toList();
        if (estimatedFares.isNotEmpty) {
          selectedFare.value = estimatedFares.first;
          estimatedFare.value = selectedFare.value!.finalFare.toInt();
        }
        goToSelectEv();
        logger.d(response);
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message']);
      }
    } catch (e) {
      isLoadingPostFair.value = false;
      logger.e(e.toString());
    } finally {
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

    logger.i(driverPosition.value);
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
      logger.d(response);
      if (response['success'] == true) {
        tripAcceptedModel.value = TripResponseModel.fromJson(response['data']);
        driverStatus.value = tripAcceptedModel.value.status.toString();
        updateDriverLocation();
        CommonController.to.getReviewListRequest(
          driverId: tripAcceptedModel.value.driver!.sId.toString(),
        );
      } else {
        isLoadingUserCurrentTrip.value = false;

        // logger.e(response);
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

  // Future<String> getPlaceNameFromGoogle(LatLng position) async {
  //   final url = Uri.parse(
  //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${GoogleClient.googleMapUrl}',
  //   );
  //
  //   final res = await http.get(url);
  //   if (res.statusCode == 200) {
  //     final data = jsonDecode(res.body);
  //     if (data['results'] != null && data['results'].isNotEmpty) {
  //       logger.d(url);
  //       logger.d(data['results']);
  //       // First result usually has the POI name or formatted address
  //       return data['results'][0]['formatted_address'];
  //     }
  //   }
  //   return "";
  // }

  Future<void> getPlaceName(
    LatLng position,
    TextEditingController controller,
  ) async {
    try {
      String placemarks = await LocationTrackingService().getAddressFromLatLng(
        LatLng(position.latitude, position.longitude),
      );
      if (placemarks.isNotEmpty) {
        String address = placemarks;
        logger.d("Formatted address: $address");

        controller.text = address;

        // ✅ Also update the observable string
        if (setDestination.value) {
          dropoffAddressText.value = address;
          logger.d("Updated dropoff address: $address");
        } else {
          pickupAddressText.value = address;
          logger.d("Updated pickup address: $address");
        }
      } else {
        logger.w("No placemarks found for this location.");
        controller.text = 'Unknown location';

        if (setDestination.value) {
          dropoffAddressText.value = 'Unknown location';
        } else {
          pickupAddressText.value = 'Unknown location';
        }
      }
    } catch (e) {
      logger.e("Error while getting place name: $e");
      controller.text = 'Unknown location';

      if (setDestination.value) {
        dropoffAddressText.value = 'Unknown location';
      } else {
        pickupAddressText.value = 'Unknown location';
      }
    }
  }

  Future<void> requestTrip({required Map<String, dynamic> body}) async {
    if (!socket.socket!.connected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.alert,
      );
      socketConnection();
      return;
    }
    isRequestingTrip.value = true;
    isCancellingTrip.value = true;

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
    if (!socket.socket!.connected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.failed,
      );
      socketConnection();
      return;
    }

    try {
      logger.d("cancel emit");
      socket.emit(TripEvents.tripUpdateStatus, {
        "tripId": tripId,
        "newStatus": status,
        if (reason != null) "reason": reason,
      });

      // Note: The loading state will be reset when the socket response comes back
      // in your registerTripEventListeners() -> tripUpdateStatus event
    } catch (e) {
      // Reset loading state on error

      logger.e('Error updating trip: $e');
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to update trip. Please try again.',
        type: SnackBarType.failed,
      );
    } finally {
      if (status == DriverTripStatus.cancelled.name) {
        // isCancellingTrip.value = false;
      }
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
