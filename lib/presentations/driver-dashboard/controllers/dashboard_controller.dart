import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_events_variable.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_location_update_model.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_cancellation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../navigation/controllers/navigation_controller.dart';
import '../../splash/controllers/common_controller.dart';

class DashBoardController extends GetxController {
  static DashBoardController get to => Get.find();
  RxBool findingRide = true.obs;
  RxBool rideRequest = false.obs;
  RxBool acceptRideRequest = false.obs;
  RxBool isPreBookRequest = false.obs;
  RxBool afterAccepted = false.obs;
  RxBool afterOnTheWay = false.obs;
  RxBool afterPickup = false.obs;

  RxBool afterTripStarted = false.obs;
  RxBool afterArrived = false.obs;
  RxBool sendPaymentReq = false.obs;
  RxBool afterDestinationReached = false.obs;
  RxBool isDriverActive = true.obs;
  RxString status = "Disconnected".obs;
  final locationService = LocationTrackingService();
  RxBool isCancellingTrip = false.obs;
  List<String> cancelReason = [];
  Rx<DriverCurrentTripModel> currentTrip = DriverCurrentTripModel().obs;
  Rx<DriverLocationUpdateModel> driverUpdatedLocation =
      DriverLocationUpdateModel().obs;
  Rx<DriverCurrentTripModel> availableTrip = DriverCurrentTripModel().obs;

  TextEditingController extraCost = TextEditingController();
  final  socketService = SocketService();
  RxBool isLoadingCurrentTrip = false.obs;
  RxBool isLoadingUpdateTollFee = false.obs;
  RxString estimatedPickupTime = "0:00 Min".obs;

  @override
  void onInit() async {
    initializeSocket();
   await Future.wait(
        [getDriverCurrentTripRequest() ,
        ]
    );

    super.onInit();
  }

  void resetRideFlow({required RideFlowState rideType}) {
    // Reset all to false
    findingRide.value = false;
    rideRequest.value = false;
    afterAccepted.value = false;
    afterArrived.value = false;
    afterPickup.value = false;
    afterTripStarted.value = false;
    afterDestinationReached.value = false;
    afterOnTheWay.value = false;
    sendPaymentReq.value = false;

    // Enable only the provided one
    switch (rideType) {
      case RideFlowState.findingRide:
        findingRide.value = true;
        break;
      case RideFlowState.rideRequest:
        rideRequest.value = true;
        break;
      case RideFlowState.pickup:
        afterAccepted.value = true;
        break;
      case RideFlowState.isArrived:
        afterArrived.value = true;
        break;
      case RideFlowState.isTripStarted:
        afterPickup.value = true;
        break;
      case RideFlowState.isTripEnd:
        afterTripStarted.value = true;
        break;
      case RideFlowState.destinationReached:
        afterDestinationReached.value = true;
        break;
      case RideFlowState.arrive:
        afterOnTheWay.value = true;
        break;
    }
    logger.i("Flow set to: $rideType");
  }

  void updateRideFlowState(String? status) {
    switch (status) {
      case 'accepted':
        resetRideFlow(rideType: RideFlowState.pickup);
        break;
      case 'on_the_way':
        resetRideFlow(rideType: RideFlowState.arrive);
        break;
      case 'arrived':
        resetRideFlow(rideType: RideFlowState.isArrived);
        break;
      case 'picked_up':
        resetRideFlow(rideType: RideFlowState.isTripStarted);
        break;
      case 'started':
        resetRideFlow(rideType: RideFlowState.isTripEnd);
        break;
      case 'destination_reached':
        resetRideFlow(rideType: RideFlowState.destinationReached);
        break;
      default:
        // If status is unknown, keep everything false
        resetRideFlow(rideType: RideFlowState.findingRide);
    }
  }

  void showAvailableTrip() {
    // rideRequest.value = true;
    logger.d(availableTrip.value.sId);
    resetRideFlow(rideType: RideFlowState.rideRequest);
  }

  void initializeSocket() {
    if (socketService.socket==null||!socketService.socket!.connected) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(Boxes.getUserData().get(tokenKey).toString());

      socketService.connect(decodedToken['userId'],decodedToken['role']=="DRIVER");
      // async
      socketService.onConnected = () {
        registerSocketListeners(); // Register events **after** connection
      };
    } else {
      registerSocketListeners(); // Already connected
    }
  }

  ///------------------------------ update Toll fee method -------------------------///

  Future<void> updateTollFeeRequest({required String tripId}) async {
    try {
      isLoadingUpdateTollFee.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: updateTollFeeEndpoint,
        method: 'PATCH',
        body: {"tripId": tripId, "tollFee": extraCost.text},
      );

      if (response['success'] == true) {
        isLoadingUpdateTollFee.value = false;
        // SystemChannels.textInput.invokeMethod('TextInput.hide');

        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
          type: SnackBarType.success,
        );
        logger.d(response);
      } else {
        isLoadingUpdateTollFee.value = false;

        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingUpdateTollFee.value = false;
    }
  }

  Future<void> driverTripUpdateStatus({
    required String tripId,
    required String newStatus,
    String? dropOffAddress,
    double? dropOffLat,
    double? dropOffLong,
    int? duration,
    int? distance,
    List<String>? reason,
  }) async {
    try {
      if (!socketService.socket!.connected) {
        initializeSocket();
        showCustomSnackbar(
          title: 'Connection Error',
          message: 'Not connected to server. Please wait and try again.',
          type: SnackBarType.failed,
        );
        return;
      }

      if (newStatus == DriverTripStatus.cancelled.name) {
        isCancellingTrip.value = true;
      }
      logger.i(newStatus);

      socketService.emit(DriverEvent.tripUpdateStatus, {
        "tripId": tripId,
        "newStatus": newStatus,
        if (dropOffAddress != null) "dropOffAddress": dropOffAddress,
        if (dropOffLat != null) "dropOffLat": dropOffLat,
        if (dropOffLong != null) "dropOffLong": dropOffLong,
        if (duration != null) "duration": duration,
        if (distance != null) "distance": distance,
        if (reason != null) "reason": reason,
      });
    } catch (e) {
      logger.e(e.toString());
    } finally {
      if (newStatus == DriverTripStatus.cancelled.name) {
        isCancellingTrip.value = false;
      }
    }
  }


  Future<void> driverTripAccept({
    required String tripId,
    required double lat,
    required double lng,
  }) async {
    if (!socketService.socket!.connected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.failed,
      );
      initializeSocket();
      return;
    }

    socketService.emit(DriverEvent.tripAcceptedStatus, {
      {"tripId": tripId, "long": lat, "lat": lng},
    });
  }

  Future<void> getDriverCurrentTripRequest() async {
    try {
      isLoadingCurrentTrip.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getCurrentDriverTripEndpoint,
        method: 'GET',
      );
      if (response['success'] == true) {
        logger.d(response);
        currentTrip.value = DriverCurrentTripModel.fromJson(response['data']);
        drawPolylineMethod();
      } else {
        logger.e(response);
        if (kDebugMode) {
          // showCustomSnackbar(
          //   title: 'Failed',
          //   message: response['message'],
          //   type: SnackBarType.failed,
          // );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingCurrentTrip.value = false;
    }finally{
      isLoadingCurrentTrip.value = false;

    }
  }


  Future<void> drawPolylineMethod() async {
    final trip = currentTrip.value;
    final coords = trip.pickUpCoordinates?.coordinates;
    final dropCoords = trip.dropOffCoordinates?.coordinates;
    if (trip.sId != null && coords != null && dropCoords != null) {
      await locationService.drawPolylineBetweenPoints(
        userPosition: CommonController.to.markerPositionDriver.value,
        mapController: CommonController.to.mapControllerDriver,
        LatLng(coords.last.toDouble(), coords.first.toDouble()),
        LatLng(dropCoords.last.toDouble(), dropCoords.first.toDouble()),
        NavigationController.to.routePolylines,
        distance: int.tryParse(trip.distance.toString())?.obs ?? 0.obs,
        duration: int.tryParse(trip.duration.toString())?.obs ?? 0.obs,
      );

      updateRideFlowState(trip.status);
    }
  }

  bool handleBackNavigation() {
    if (afterOnTheWay.value) {
      // From payment request back to trip end
      afterOnTheWay.value = false;
      afterTripStarted.value = true;
      return false;
    } else if (afterTripStarted.value) {
      // From trip end back to trip started
      afterTripStarted.value = false;
      afterPickup.value = true;
      return false;
    } else if (afterPickup.value) {
      // From trip started back to pickup started
      afterPickup.value = false;
      afterArrived.value = true;
      return false;
    } else if (afterArrived.value) {
      // From pickup started back to pickup
      afterArrived.value = false;
      afterAccepted.value = true;
      return false;
    } else if (afterAccepted.value) {
      // From pickup back to ride request
      afterAccepted.value = false;
      rideRequest.value = true;
      return false;
    } else if (rideRequest.value) {
      // From ride request back to finding ride
      rideRequest.value = false;
      findingRide.value = true;
      return false;
    } else if (findingRide.value) {
      return false;
    }

    // Default case: allow the back navigation to occur normally
    return true;
  }

  void removeSocketListeners() {
    socketService.off(DriverEvent.tripAvailableStatus);
    socketService.off(DriverEvent.tripUpdateStatus);
    socketService.off(DriverEvent.tripAcceptedStatus);
    socketService.off(DriverEvent.driverLocationUpdate);
    // ... add all relevant events
  }

  @override
  void onClose() {
    removeSocketListeners();
    super.onClose();
  }

  void registerSocketListeners() {
    // logger.i("🚦 Is driver online? ${socketService.isDriverActive}");

    // Clear all previous listeners to avoid duplication
    removeSocketListeners();
logger.i("Listening socket event for driver");
    // ============ Trip Available Event ============
    socketService.on(DriverEvent.tripAvailableStatus, (data) {
      logger.d("📩 tripAvailableStatus: $data");
      if (data["success"]) {
        // Ensure UI updates happen on the main thread
        WidgetsBinding.instance.addPostFrameCallback((_) {
          availableTrip.value = DriverCurrentTripModel.fromJson(data['data']);
          showAvailableTrip();
          logger.d(rideRequest.value);
        });
      }
    });

    // ============ Trip Update Status Event ============
    socketService.on(DriverEvent.tripUpdateStatus, (data) async {
      logger.d("📩 tripUpdateStatus: $data");

      if (data['success'] != true) {
        _showError(data['message']);
        return;
      }

      currentTrip.value = DriverCurrentTripModel.fromJson(data['data']);
      drawPolylineMethod();

      // showCustomSnackbar(
      //   title: 'Success',
      //   message: data['message'],
      //   position: SnackPosition.TOP,
      //   type: SnackBarType.success,
      // );

      _handleTripStatus(data['data']['status']);
    });

    // ============ Trip Accepted Status ============
    socketService.on(DriverEvent.tripAcceptedStatus, (data) async {
      logger.d("📩 tripAcceptedStatus: $data");

      if (data['success'] == true) {
        currentTrip.value = DriverCurrentTripModel.fromJson(data['data']);
        if(currentTrip.value.tripType!=preBook){
          startTrackingUserLocationMethod(
            tripId: currentTrip.value.sId.toString(),
          );
          drawPolylineMethod();
          DashBoardController.to.afterAccepted.value = true;
          resetRideFlow(rideType: RideFlowState.pickup);
          // _showSuccess(data['message']);
        }else{
          Get.offAllNamed(
            NavigationPage.routeName,
            arguments: {'reconnectSocket': true,"pre_book":true},
          );        }
      } else {
        resetRideFlow(rideType: RideFlowState.findingRide);
        _showError(data['message']);
      }
    });

    // ============ Driver Location Update ============
    socketService.on(DriverEvent.driverLocationUpdate, (data) {
      // logger.d("📩 driverLocationUpdate: $data");

      if (data['success'] == true) {
        driverUpdatedLocation.value = DriverLocationUpdateModel.fromJson(
          data['data'],
        );
        // _showSuccess(data['message']);
      } else {
        // _showError(data['message']);
      }
    });
    socketService.on(PaymentEvent.paymentReceived, (data) {
      logger.d('payment paid: $data');
      CommonController.to.isPaid.value=data['success'];
if(data['success']){
  getDriverCurrentTripRequest();
}
             showCustomSnackbar(
        title: 'Success',
        message: data['message'],
      );
    });
  }

  void startTrackingUserLocationMethod({required String tripId}) async {
    final locationTrackingService = LocationTrackingService();
    await locationTrackingService.startTrackingLocation(
      tripId: tripId,
      markerPosition: CommonController.to.markerPositionDriver,
      mapController: CommonController.to.mapControllerDriver,
    );
  }

  void _handleTripStatus(String status) {
    switch (status) {
      case 'accepted':
        afterAccepted.value = true;
        resetRideFlow(rideType: RideFlowState.pickup);
        break;
      case 'picked_up':
        afterPickup.value = true;
        resetRideFlow(rideType: RideFlowState.isTripStarted);
        break;
      case 'started':
        afterTripStarted.value = true;
        resetRideFlow(rideType: RideFlowState.isTripEnd);
        break;
      case 'arrived':
        afterArrived.value = true;
        resetRideFlow(rideType: RideFlowState.isArrived);
        break;
      case 'on_the_way':
        afterOnTheWay.value = true;
        break;
      case 'destination_reached':
        afterDestinationReached.value = true;
        resetRideFlow(rideType: RideFlowState.destinationReached);
        Get.toNamed(
          PaymentPage.routeName,
          arguments: {
            "driver": DashBoardController.to.currentTrip.value,
            "role": driver,
          },
        );
        break;
      case 'completed':
      case 'cancelled':

      resetController();
        Get.offAllNamed(
          NavigationPage.routeName,
          arguments: {'reconnectSocket': true},
        );
        break;
      default:
        logger.w("Unknown trip status: $status");
    }
  }
  void resetController() {
    // Remove listeners
    removeSocketListeners();

    // Reset all state
    // resetRideFlow(rideType: RideFlowState.findingRide);
    // // currentTrip.value = DriverCurrentTripModel();
    // availableTrip.value = DriverCurrentTripModel();
    // driverUpdatedLocation.value = DriverLocationUpdateModel();
    // extraCost.clear();

    // Reset cancel reasons
    for (TripCancellationModel cancel in tripCancellationList) {
      cancel.isChecked.value = false;
    }

    // Clear polylines
    NavigationController.to.clearPolyline();

    logger.i("DashBoardController reset completed");
  }
  void _showSuccess(String message) {
    showCustomSnackbar(
      title: 'Success',
      message: message,
      type: SnackBarType.success,
    );
  }

  void _showError(String message) {
    showCustomSnackbar(
      title: 'Failed',
      message: message,
      type: SnackBarType.failed,
    );
  }
}
// {
//   "deviceId": "BE2A.250530.026.D1",
//   "token": "f2N4tk1ORTCnRoyqxvp8aD:APA91bHjLOmnqzcPfHtVYMjXt58F1-s4I-IFr2PYwqzUdfP86F4blHNzWmXdjpzdqF0eOH-NnkCmFnw0D_ajb4tGujNs2TqwsiA5-MEDvjA_hKnK-0l_Cfo",
//   "name": "Sadia Bennthe Azad",
//   "email": "tanzibamouri00@gmail.com",
//   "profile_image": "https://lh3.googleusercontent.com/a/ACg8ocIrDyEXo0GdeERbeAwPSADYBXKWXgejhRcFfvdEvsRJjU_wVxw",
//   "phoneNumber": "56151212",
//   "provider": "google",
//   "role": "USER"
// }