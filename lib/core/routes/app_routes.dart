import 'package:e_hailing_app/presentations/splash/views/splash_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static route() => [
    GetPage(name: SplashPage.routeName, page: () => SplashPage()),
  ];
}
