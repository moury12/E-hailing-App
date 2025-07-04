import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/socket/socket_events_variable.dart';
import 'package:e_hailing_app/core/socket/socket_service.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_location_update_model.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  Rx<DriverCurrentTripModel> currentTrip = DriverCurrentTripModel().obs;
  Rx<DriverLocationUpdateModel> driverUpdatedLocation =
      DriverLocationUpdateModel().obs;
  Rx<DriverCurrentTripModel> availableTrip = DriverCurrentTripModel().obs;

  TextEditingController extraCost = TextEditingController();
  final SocketService socketService = SocketService();
  RxBool isLoadingCurrentTrip = false.obs;
  RxBool isLoadingUpdateTollFee = false.obs;

  @override
  void onInit() async {
    initializeSocket();
    await getDriverCurrentTripRequest();

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
    rideRequest.value = true;
    logger.d(availableTrip.value.sId);
    resetRideFlow(rideType: RideFlowState.rideRequest);
  }

  void initializeSocket() {
    socketService.onConnected = () {
      status.value = 'Connected';
    };
    // socketService.onDisconnected = () {
    //   status.value = 'Disconnected';
    // };

    if (socketService.isConnected) {
      logger.i(
        "---------is driver online?---------------${socketService.isDriverActive}",
      );
      // isDriverActive.value = socketService.isDriverActive;
      socketService.on(DriverEvent.tripAvailableStatus, (data) {
        logger.d(data);
        if (data["success"]) {
          logger.i("onAvailableTrip assigned");
          availableTrip.value = DriverCurrentTripModel.fromJson(data['data']);

          showAvailableTrip();
        }
      });
      socketService.on(DriverEvent.tripUpdateStatus, (data) {
        logger.d(data);
        if (data['success'] == true) {
          currentTrip.value = DriverCurrentTripModel.fromJson(data['data']);

          showCustomSnackbar(
            title: 'Success',
            position: SnackPosition.TOP,
            message: data['message'],
            type: SnackBarType.success,
          );
          if (data['data']['status'] ==
              DriverTripStatus.accepted.name.toString()) {
            afterAccepted.value = true;
            resetRideFlow(rideType: RideFlowState.pickup);
          } else if (data['data']['status'] ==
              DriverTripStatus.picked_up.name.toString()) {
            afterPickup.value = true;
            resetRideFlow(rideType: RideFlowState.isTripStarted);
          } else if (data['data']['status'] ==
              DriverTripStatus.completed.name.toString()) {
            socketService.off(DriverEvent.tripUpdateStatus);
            Get.offAllNamed(NavigationPage.routeName);
          } else if (data['data']['status'] ==
              DriverTripStatus.cancelled.name.toString()) {
            socketService.off(DriverEvent.tripUpdateStatus);
            Get.offAllNamed(NavigationPage.routeName);
          } else if (data['data']['status'] ==
              DriverTripStatus.started.name.toString()) {
            afterTripStarted.value = true;
            resetRideFlow(rideType: RideFlowState.isTripEnd);
          } else if (data['data']['status'] ==
              DriverTripStatus.arrived.name.toString()) {
            afterArrived.value = true;
            resetRideFlow(rideType: RideFlowState.isArrived);
          } else if (data['data']['status'] ==
              DriverTripStatus.on_the_way.name.toString()) {
            afterOnTheWay.value = true;
          } else if (data['data']['status'] ==
              DriverTripStatus.destination_reached.name.toString()) {
            Get.toNamed(
              PaymentPage.routeName,
              arguments: {
                "driver": DashBoardController.to.currentTrip.value,
                "role": driver,
              },
            );
            afterDestinationReached.value = true;
            resetRideFlow(rideType: RideFlowState.destinationReached);
          } else if (data['data']['status'] ==
              DriverTripStatus.completed.name.toString()) {
            Get.offAllNamed(NavigationPage.routeName);
          }
        } else {
          showCustomSnackbar(
            title: 'Failed',
            message: data['message'],
            type: SnackBarType.failed,
          );
        }
      });
      socketService.on(DriverEvent.tripAcceptedStatus, (data) {
        logger.d(data);
        if (data['success'] == true) {
          currentTrip.value = DriverCurrentTripModel.fromJson(data['data']);

          showCustomSnackbar(
            title: 'Success',
            message: data['message'],
            type: SnackBarType.success,
          );
          CommonController.to.startTrackingUserLocation(
            tripId: currentTrip.value.sId,
          );
          DashBoardController.to.afterAccepted.value = true;
          resetRideFlow(rideType: RideFlowState.pickup);
          // Get.toNamed(
          //   PaymentPage.routeName,
          //   arguments: {
          //     "driver": DriverDriverCurrentTripModel).fromJson(data['data']),
          //     "role": driver,
          //   },
          // );
        } else {
          showCustomSnackbar(
            title: 'Failed',
            message: data['message'],
            type: SnackBarType.failed,
          );
        }
      });
      socketService.on(DriverEvent.driverLocationUpdate, (data) {
        logger.d(data);
        if (data['success'] == true) {
          driverUpdatedLocation.value = DriverLocationUpdateModel.fromJson(
            data['data'],
          );

          showCustomSnackbar(
            title: 'Success',
            message: data['message'],
            type: SnackBarType.success,
          );
        } else {
          showCustomSnackbar(
            title: 'Failed',
            message: data['message'],
            type: SnackBarType.failed,
          );
        }
      });
    } else {
      socketService.connect(
        CommonController.to.userModel.value.sId.toString(),
        CommonController.to.userModel.value.role == "DRIVER",
      );
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
  }) async {
    if (!socketService.isConnected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.failed,
      );
      return;
    }

    socketService.emit(DriverEvent.tripUpdateStatus, {
      "tripId": tripId,
      "newStatus": newStatus,
      if (dropOffAddress != null) "dropOffAddress": dropOffAddress,
      if (dropOffLat != null) "dropOffLat": dropOffLat,
      if (dropOffLong != null) "dropOffLong": dropOffLong,
      if (duration != null) "duration": duration,
      if (distance != null) "distance": distance,
    });
  }

  Future<void> driverTripAccept({
    required String tripId,
    required double lat,
    required double lng,
  }) async {
    if (!socketService.isConnected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.failed,
      );
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
      isLoadingCurrentTrip.value = false;
      if (response['success'] == true) {
        logger.d(response);
        currentTrip.value = DriverCurrentTripModel.fromJson(response['data']);
        final trip = currentTrip.value;
        final coords = trip.pickUpCoordinates?.coordinates;
        final dropCoords = trip.dropOffCoordinates?.coordinates;
        if (trip.sId != null && coords != null && dropCoords != null) {
          await drawPolylineBetweenPoints(
            LatLng(coords.last.toDouble(), coords.first.toDouble()),
            LatLng(dropCoords.last.toDouble(), dropCoords.first.toDouble()),
            NavigationController.to.routePolylines,
            distance: int.tryParse(trip.distance.toString())?.obs ?? 0.obs,
            duration: int.tryParse(trip.duration.toString())?.obs ?? 0.obs,
          );

          await CommonController.to.startTrackingUserLocation(tripId: trip.sId);

          updateRideFlowState(trip.status);
        }
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

  @override
  void onClose() {
    socketService.off("online_status");
    super.onClose();
  }
}
