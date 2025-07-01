import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  static TripController get to => Get.find();
  RxString selectedPaymentMethod = "".obs;
  TextEditingController promoCodeController = TextEditingController();

  @override
  void onInit() {
    selectedPaymentMethod.value = paymentMethodList[0];

    super.onInit();
  }
}
