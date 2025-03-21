import 'package:e_hailing_app/presentations/profile/controllers/driver_settings_controller.dart';
import 'package:e_hailing_app/presentations/profile/controllers/driver_settings_controller.dart';
import 'package:get/get.dart';

import '../../presentations/auth/controllers/auth_controller.dart';
import '../../presentations/navigation/controllers/navigation_controller.dart';
import '../../presentations/profile/controllers/account_information_controller.dart';
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
    Get.put(NavigationController());
  }
}

class AccountInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountInformationController());
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
