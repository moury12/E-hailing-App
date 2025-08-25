import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/service/socket-service/socket_service.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/notification/controller/notification_controller.dart';
import 'package:e_hailing_app/presentations/profile/controllers/d_coin_controller.dart';
import 'package:e_hailing_app/presentations/profile/controllers/driver_settings_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/boundary_controller.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../presentations/auth/controllers/auth_controller.dart';
import '../../presentations/message/controllers/chatting_controller.dart';
import '../../presentations/navigation/controllers/navigation_controller.dart';
import '../../presentations/profile/controllers/account_information_controller.dart';
import '../../presentations/profile/controllers/terms_policy_controller.dart';
import '../../presentations/save-location/controllers/save_location_controller.dart';
import '../../presentations/splash/controllers/common_controller.dart';
import '../../presentations/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class CommonBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CommonController(), permanent: true);
    Get.put(BoundaryController(), permanent: true);
  }
}

class SaveLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SaveLocationController(), permanent: true);
  }
}

// class ProductBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(ProductController());
//   }
// }
//
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}



//
class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    final arguments = Get.arguments;
    if (arguments is Map && arguments['reconnectSocket'] == true)  {
      Future.delayed(Duration(milliseconds: 500), () {

        Map<String, dynamic> decodedToken = JwtDecoder.decode(
            Boxes.getUserData().get(tokenKey).toString());

        SocketService().connect(
            decodedToken['userId'], decodedToken['role'] == "DRIVER");

        // Also re-register driver-specific listeners if user is a driver
        if (CommonController.to.isDriver.value) {
          Future.delayed(Duration(milliseconds: 200), () {
            if (Get.isRegistered<DashBoardController>()) {
              final dashboardController = Get.find<DashBoardController>();
              dashboardController.registerSocketListeners();
            }
          });
        } else {
          Future.delayed(Duration(milliseconds: 200), () {
            if (Get.isRegistered<HomeController>()) {
              final homeController = Get.find<HomeController>();
              homeController.registerTripEventListeners();
            }
          });
        }
      });
    }

  }
}

class TermsPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TermsPolicyController());
  }
}

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}

class ChattingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChattingController());
  }
}

class AccountInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountInformationController());
  }
}

class DCoinBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DCoinController());
  }
}

class DriverSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DriverSettingsController());
  }
}

//
// class ProfileBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(ProfileController());
//   }
// }
//
// class SettingsBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(SettingsController());
//   }
// }
