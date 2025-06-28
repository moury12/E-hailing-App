import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/socket/socket_events_variable.dart';
import 'package:e_hailing_app/core/socket/socket_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_trip_response_model.dart';
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
  RxBool pickup = false.obs;
  RxBool arrive = false.obs;
  RxBool isTripStarted = false.obs;
  RxBool isTripEnd = false.obs;
  RxBool isArrived = false.obs;
  RxBool isLoadingCurrentTrip = false.obs;
  RxBool isLoadingUpdateTollFee = false.obs;
  RxBool isDriverActive = false.obs;
  RxString status = "Disconnected".obs;
  Rx<DriverCurrentTripModel> currentTrip = DriverCurrentTripModel().obs;
  Rx<DriverTripResponseModel> driverTripResponse =
      DriverTripResponseModel().obs;
  TextEditingController extraCost = TextEditingController();
  final SocketService socketService = SocketService();

  @override
  void onInit() async {
    initializeSocket();
    await getDriverCurrentTripRequest();
    if (currentTrip.value.sId != null) {
      isTripEnd.value = true;
      findingRide.value = false;
    }
    super.onInit();
  }

  void initializeSocket() {
    socketService.onConnected = () {
      status.value = 'Connected';
    };
    socketService.onDisconnected = () {
      status.value = 'Disconnected';
    };

    if (socketService.isConnected) {
      isDriverActive.value = socketService.isDriverActive;
      socketService.on(DriverEvent.tripUpdateStatus, (data) {
        logger.d(data);
        if (data['success'] == true) {
          driverTripResponse.value = DriverTripResponseModel.fromJson(
            data['data'],
          );

          showCustomSnackbar(
            title: 'Success',
            message: data['message'],
            type: SnackBarType.success,
          );
          Get.toNamed(
            PaymentPage.routeName,
            arguments: {
              "driver": DriverTripResponseModel.fromJson(data['data']),
              "role": driver,
            },
          );
        } else {
          showCustomSnackbar(
            title: 'Failed',
            message: data['message'],
            type: SnackBarType.failed,
          );
        }
        // currentTrip.value = data;
        // status.value = 'Trip requested successfully';
        // isRequestingTrip.value = false;
        // hasActiveTrip.value = true;
        // showCustomSnackbar(
        //   title: 'Success',
        //   message: 'Trip requested successfully! Looking for nearby drivers...',
        // );
      });
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
    if (arrive.value) {
      // From payment request back to trip end
      arrive.value = false;
      isTripEnd.value = true;
      return false;
    } else if (isTripEnd.value) {
      // From trip end back to trip started
      isTripEnd.value = false;
      isTripStarted.value = true;
      return false;
    } else if (isTripStarted.value) {
      // From trip started back to pickup started
      isTripStarted.value = false;
      isArrived.value = true;
      return false;
    } else if (isArrived.value) {
      // From pickup started back to pickup
      isArrived.value = false;
      pickup.value = true;
      return false;
    } else if (pickup.value) {
      // From pickup back to ride request
      pickup.value = false;
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

  void resetRideFlow(DashBoardController controller) {
    // Reset all flow states to their default values
    findingRide.value = false;
    rideRequest.value = false;
    pickup.value = false;
    isArrived.value = false;
    isTripStarted.value = false;
    isTripEnd.value = false;
    arrive.value = false;
  }

  @override
  void onClose() {
    socketService.off("online_status");
    super.onClose();
  }
}
