import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/service/trip_socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  static TripController get to => Get.find();
  RxString selectedPaymentMethod = "".obs;
  TextEditingController promoCodeController = TextEditingController();
  final TripSocketService socketService = TripSocketService();
  RxString status = "Disconnected".obs;
  RxBool isRequestingTrip = false.obs;
  RxBool hasActiveTrip = false.obs;
  Rx<Map<String, dynamic>?> currentTrip = Rx<Map<String, dynamic>?>(null);

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
    };
    socketService.connect(CommonController.to.userModel.value.sId ?? "");
  }

  @override
  void onClose() {
    socketService.disconnect();
    super.onClose();
  }
}
