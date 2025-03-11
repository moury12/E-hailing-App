import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  RxBool isRememberMe = false.obs;
  final List<Rx<TextEditingController>> controllers = List.generate(6, (index) => TextEditingController().obs);
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  /// Handles user input
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus(); // Move to next field
      }
    } else if (index > 0) {
      focusNodes[index - 1].requestFocus(); // Move to previous field on backspace
    }
  }

  /// Get OTP code
  String getOtp() {
    return controllers.map((e) => e.value.text).join();
  }

  /// Clear OTP fields
  void clearOtp() {
    for (var controller in controllers) {
      controller.value.clear();
    }
    focusNodes[0].requestFocus();
  }
}
