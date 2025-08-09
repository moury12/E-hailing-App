import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/service/internet_service.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/splash/views/no_internet_page.dart';
import 'package:get/get.dart';

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

    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
      await CommonController.to.initialSetUp();
      Get.offAllNamed(NavigationPage.routeName);
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
