import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_accepted_model.dart';
import 'package:e_hailing_app/presentations/trip/service/trip_socket_service.dart';
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/widgets/trip_details_card_widget.dart';
import '../../navigation/views/navigation_page.dart';

class TripController extends GetxController {
  static TripController get to => Get.find();
  RxString selectedPaymentMethod = "".obs;
  TextEditingController promoCodeController = TextEditingController();
  final TripSocketService socketService = TripSocketService();
  RxString status = "Disconnected".obs;
  RxBool isRequestingTrip = false.obs;
  RxBool hasActiveTrip = false.obs;
  Rx<Map<String, dynamic>?> currentTrip = Rx<Map<String, dynamic>?>(null);
  Rx<TripAcceptedModel> tripAcceptedModel = TripAcceptedModel().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value = paymentMethodList[0];
    initializeSocket();
    super.onInit();
  }

  void initializeSocket() {
    // Set up callbacks
    socketService.onConnected = () {
      status.value = 'Connected';
    };
    socketService.onDisconnected = () {
      status.value = 'Disconnected';
    };
    socketService.onTripRequested = (data) {
      currentTrip.value = data;
      status.value = 'Trip requested successfully';
      isRequestingTrip.value = false;
      hasActiveTrip.value = true;
      showCustomSnackbar(
        title: 'Success',
        message: 'Trip requested successfully! Looking for nearby drivers...',
      );
    };
    socketService.onTripNoDriverFound = (data) {
      status.value = "No drivers available";
      isRequestingTrip.value = false;
      hasActiveTrip.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      showCustomSnackbar(
        title: 'No Drivers Available',
        message:
            'Sorry, no drivers are available in your area right now. Please try again later.',
      );
      Future.delayed(Duration(seconds: 3), () {
        Get.offAllNamed(NavigationPage.routeName);
      });

      logger.d('No driver found: $data');
    };
    socketService.onTripAccepted = (data) {
      status.value = "Driver found! Trip accepted";
      isRequestingTrip.value = false;
      hasActiveTrip.value = true;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      tripAcceptedModel.value = data['data'];
      Get.toNamed(TripDetailsPage.routeName);
      logger.d('Trip accepted by driver: $data');
    };
    String userId = CommonController.to.userModel.value.sId ?? "";
    if (userId.isNotEmpty) {
      socketService.connect(userId);
    } else {
      logger.e('User ID is empty, cannot connect to socket');
    }
  }

  Future<void> requestTrip({required Map<String, dynamic> body}) async {
    if (!socketService.isConnected) {
      showCustomSnackbar(
        title: 'Connection Error',
        message: 'Not connected to server. Please wait and try again.',
        type: SnackBarType.failed,
      );
      return;
    }
    isRequestingTrip.value = true;
    status.value = 'Requesting trip...';
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: TripRequestLoadingWidget(
              pickUpAddress: body['pickUpAddress'],
              dropOffAddress: body['dropOffAddress'],
            ),
          ),
    );
    socketService.requestTrip(body: body);
    Future.delayed(Duration(seconds: 30), () {
      if (isRequestingTrip.value) {
        isRequestingTrip.value = false;
        Get.back(); // Close loading dialog
        showCustomSnackbar(
          title: 'Request Timeout',
          message: 'Trip request timed out. Please try again.',
          type: SnackBarType.failed,
        );
      }
    });
  }

  @override
  void onClose() {
    socketService.disconnect();
    super.onClose();
  }
}
