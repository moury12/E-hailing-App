import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/socket/socket_events_variable.dart';
import 'package:e_hailing_app/core/socket/socket_service.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController {
  static DashBoardController get to => Get.find();
  RxBool findingRide = true.obs;
  RxBool rideRequest = false.obs;
  RxBool acceptRideRequest = false.obs;
  RxBool isPreBookRequest = false.obs;
  RxBool afterAccepted = false.obs;
  RxBool destinationReached = false.obs;
  RxBool afterPickeup = false.obs;
  RxBool AftertripStarted = false.obs;
  RxBool afterArrived = false.obs;
  RxBool isDriverActive = false.obs;
  RxString status = "Disconnected".obs;
  Rx<DriverCurrentTripModel> currentTrip = DriverCurrentTripModel().obs;
  Rx<DriverCurrentTripModel> availableTrip = DriverCurrentTripModel().obs;

  TextEditingController extraCost = TextEditingController();
  final SocketService socketService = SocketService();
  RxBool isLoadingCurrentTrip = false.obs;
  RxBool isLoadingUpdateTollFee = false.obs;

  @override
  void onInit() async {
    initializeSocket();
    await getDriverCurrentTripRequest();
    if (currentTrip.value.sId != null) {
      if (currentTrip.value.status ==
          TripStateDriver.accepted.name.toString()) {
        afterAccepted.value = true;
        resetRideFlow(rideType: RideFlowState.pickup);
      } else if (currentTrip.value.status ==
          TripStateDriver.picked_up.name.toString()) {
        afterPickeup.value = true;
        resetRideFlow(rideType: RideFlowState.isTripStarted);
      } else if (currentTrip.value.status ==
          TripStateDriver.arrived.name.toString()) {
        afterArrived.value = true;
        resetRideFlow(rideType: RideFlowState.isArrived);
      }
    }
    /*else if (availableTrip.value.sId != null) {
      showAvailableTrip();
    }*/
    super.onInit();
  }

  void resetRideFlow({required RideFlowState rideType}) {
    // Reset all to false
    findingRide.value = false;
    rideRequest.value = false;
    afterAccepted.value = false;
    afterArrived.value = false;
    afterPickeup.value = false;
    AftertripStarted.value = false;
    destinationReached.value = false;

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
        afterPickeup.value = true;
        break;
      case RideFlowState.isTripEnd:
        AftertripStarted.value = true;
        break;
      case RideFlowState.arrive:
        destinationReached.value = true;
        break;
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
    socketService.onDisconnected = () {
      status.value = 'Disconnected';
    };

    if (socketService.isConnected) {
      logger.i(socketService.isDriverActive);
      isDriverActive.value = socketService.isDriverActive;
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
            message: data['message'],
            type: SnackBarType.success,
          );
          if (data['data']['status'] ==
              TripStateDriver.destination_reached.name.toString()) {
            // driverTripUpdateStatus(tripId: tripId, newStatus: newStatus)
          } else if (data['data']['status'] ==
              TripStateDriver.picked_up.name.toString()) {
            afterPickeup.value = true;
            resetRideFlow(rideType: RideFlowState.isTripStarted);
          } else if (data['data']['status'] ==
              TripStateDriver.completed.name.toString()) {
            Get.offAllNamed(NavigationPage.routeName);
          } else {
            Get.toNamed(
              PaymentPage.routeName,
              arguments: {
                "driver": DriverCurrentTripModel.fromJson(data['data']),
                "role": driver,
              },
            );
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
          DashBoardController.to.afterAccepted.value = true;
          resetRideFlow(rideType: RideFlowState.pickup);
          // Get.toNamed(
          //   PaymentPage.routeName,
          //   arguments: {
          //     "driver": DriverTripResponseModel.fromJson(data['data']),
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
      // socketService.onAvailableTrip = (data) {
      //   logger.i("onAvailableTrip assigned");
      //   availableTrip.value = DriverCurrentTripModel.fromJson(data);
      //   showAvailableTrip();
      // };
    } else {
      socketService.onConnected = () {
        isDriverActive.value = socketService.isDriverActive;

        status.value = 'Connected';
      };
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

  Future<void> getDriverCurrentTripRequest({
    bool needReinitilaize = false,
  }) async {
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
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingCurrentTrip.value = false;
    }
  }

  bool handleBackNavigation() {
    if (destinationReached.value) {
      // From payment request back to trip end
      destinationReached.value = false;
      AftertripStarted.value = true;
      return false;
    } else if (AftertripStarted.value) {
      // From trip end back to trip started
      AftertripStarted.value = false;
      afterPickeup.value = true;
      return false;
    } else if (afterPickeup.value) {
      // From trip started back to pickup started
      afterPickeup.value = false;
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
