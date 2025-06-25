import 'package:e_hailing_app/core/socket/socket_service.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:get/get.dart';

import '../../../core/dependency-injection/dependency_injection.dart';
import '../../../core/utils/variables.dart';

class AppController extends GetxController {
  final SocketService socketService = getIt<SocketService>();

  RxString socketStatus = "Disconnected".obs;

  @override
  void onInit() {
    super.onInit();
    setupGlobalSocketListeners();
  }

  void setupGlobalSocketListeners() {
    socketService.onConnected = () {
      socketStatus.value = 'Connected';
      logger.i('Socket connected');
    };

    socketService.onDisconnected = () {
      socketStatus.value = 'Disconnected';
      logger.w('Socket disconnected');
    };

    socketService.onSocketError = (error) {
      socketStatus.value = 'Error: $error';
      logger.e('Socket error: $error');
    };

    // You can even auto-connect here if you want:
    final userId = CommonController.to.userModel.value.sId ?? "";
    if (userId.isNotEmpty) {
      socketService.connect(userId);
    }
  }

  @override
  void onClose() {
    socketService.disconnect();
    super.onClose();
  }
}
