import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/service/internet_service.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/splash/views/no_internet_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/service/socket-service/socket_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();
  final locationService = LocationTrackingService();

  @override
  void onInit() {
    _initSplashLogic();
    super.onInit();
  }

  void _initSplashLogic() async {
    bool hasInternet = await ConnectionManager().checkConnection();

    if (!hasInternet) {
      Get.offAll(() => const NoInternetPage());
      return;
    }

    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
      Get.offAllNamed(
        NavigationPage.routeName,
        arguments: {'reconnectSocket': true},
      );
    } else {
      Get.offAllNamed(LoginPage.routeName);
    }

  }

  // @override
  // void onInit() {
  //   Future.delayed(Duration(seconds: 2), () async {
  //     if (Boxes.getUserData().get(tokenKey) != null &&
  //         Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
  //       await CommonController.to.initialSetUp();
  //       Get.toNamed(NavigationPage.routeName);
  //     } else {
  //       Get.toNamed(LoginPage.routeName);
  //     }
  //   });
  //
  //   super.onInit();
  // }
}
