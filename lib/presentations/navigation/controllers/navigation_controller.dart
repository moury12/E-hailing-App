import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/views/home_page.dart';
import 'package:e_hailing_app/presentations/message/views/message_page.dart';
import 'package:e_hailing_app/presentations/my-rides/controllers/my_ride_controller.dart';
import 'package:e_hailing_app/presentations/my-rides/views/my_ride_page.dart';
import 'package:e_hailing_app/presentations/profile/views/profile_page.dart';
import 'package:e_hailing_app/presentations/track-ride/views/track_ride_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();
  RxInt currentNavIndex = 0.obs;
  @override
  void onInit() {
    Get.put(HomeController());
    Get.put(MyRideController());
    super.onInit();
  }

  List<Widget> getPages() {
    return [
      HomePage(),
      MyRidePage(),
      TrackRidePage(),
      MessageListPage(),
      ProfilePage(),
      // HomePage(), CartPage(), OrderPage(), NotificationPage()
    ];
  }
}
