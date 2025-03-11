import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController{
  static NavigationController get to => Get.find();
  RxInt currentNavIndex = 0.obs;
  @override
  void onInit() {

    // Get.put(ProfileController());
    super.onInit();
  }

  List<Widget> getPages() {
    return [
      // HomePage(), CartPage(), OrderPage(), NotificationPage()
    ];
  }
}