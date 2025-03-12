import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool wantToGo = false.obs;
  RxBool setPickup = false.obs;
  RxBool addStops = false.obs;
}
