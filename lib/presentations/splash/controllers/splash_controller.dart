import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{
  static SplashController get to =>Get.find();
@override
  void onInit() {
Future.delayed(Duration(seconds: 2),() {
  Get.toNamed(LoginPage.routeName);
},);
super.onInit();
  }
}