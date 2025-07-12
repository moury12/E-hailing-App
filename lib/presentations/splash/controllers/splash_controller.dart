import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();
  final locationService = LocationTrackingService();

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 2), () async {
      if (Boxes.getUserData().get(tokenKey) != null &&
          Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
        await CommonController.to.initialSetUp();
        Get.toNamed(NavigationPage.routeName);
      } else {
        Get.toNamed(LoginPage.routeName);
      }
    });

    super.onInit();
  }
}
