import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  static TripController get to => Get.find();
  RxString selectedPaymentMethod = "".obs;
  @override
  void onInit() {
    selectedPaymentMethod.value = paymentMethodList[0];
    super.onInit();
  }
}
