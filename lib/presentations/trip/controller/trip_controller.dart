import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/socket/socket_events_variable.dart';
import 'package:e_hailing_app/core/socket/socket_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_accepted_model.dart';
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/widgets/trip_details_card_widget.dart';
import '../../navigation/views/navigation_page.dart';

class TripController extends GetxController {
  static TripController get to => Get.find();
  RxString selectedPaymentMethod = "".obs;
  TextEditingController promoCodeController = TextEditingController();
  final SocketService socket = SocketService();
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
    socket.onConnected = () {
      status.value = 'Connected';
    };
    socket.onDisconnected = () {
      status.value = 'Disconnected';
    };
    socket.on(TripEvents.tripRequested, (data) {
      logger.d(data);
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
      socket.off(TripEvents.tripRequested);
      Future.delayed(Duration(seconds: 3), () {
        Get.offAllNamed(NavigationPage.routeName);
      });

      logger.d('No driver found: $data');
    });
    socket.on(TripEvents.tripAccepted, (data) {
      status.value = "Driver found! Trip accepted";
      isRequestingTrip.value = false;
      hasActiveTrip.value = true;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      tripAcceptedModel.value = data['data'];
      Get.toNamed(TripDetailsPage.routeName);
      logger.d('Trip accepted by driver: $data');
    });
    String userId = CommonController.to.userModel.value.sId ?? "";
    if (userId.isNotEmpty) {
      socket.connect(userId);
    } else {
      logger.e('User ID is empty, cannot connect to socket');
    }
  }

  Future<void> requestTrip({required Map<String, dynamic> body}) async {
    if (!socket.isConnected) {
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
    socket.emit("trip_requested", body);
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
    socket.disconnect();
    super.onClose();
  }
}
