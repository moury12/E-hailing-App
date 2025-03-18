import 'package:e_hailing_app/presentations/home/views/home_page.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
import 'package:e_hailing_app/presentations/message/views/message_page.dart';
import 'package:e_hailing_app/presentations/my-rides/controllers/my_ride_controller.dart';
import 'package:e_hailing_app/presentations/my-rides/views/my_ride_page.dart';
import 'package:e_hailing_app/presentations/profile/views/profile_page.dart';
import 'package:e_hailing_app/presentations/track-ride/views/track_ride_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../track-ride/controllers/track_ride_controller.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();
  RxInt currentNavIndex = 0.obs;
  @override
  void onInit() {
    Get.put(HomeController());
    Get.put(MessageController());
    Get.put(MyRideController());
    Get.put(TrackRideController());

    super.onInit();
  }
  void changeIndex(int index) {
    currentNavIndex.value = index;
  }
  // void handleDragUpdate(DragUpdateDetails details,
  //     {required AnimationController controller,required bool isDragging,required double dragDistance}) {
  //
  //   if (!isDragging) {
  //     isDragging = true;
  //     dragDistance = 0.0;
  //   }
  //
  //
  //   dragDistance += details.primaryDelta! / ScreenUtil().screenHeight;
  //   controller.value = (controller.value - dragDistance).clamp(0.0, 1.0);
  //   dragDistance = 0.0;
  // }
  //
  // void handleDragEnd(DragEndDetails details, {required AnimationController controller,
  //   required bool isDragging,required double dragDistance, required double dragThreshold}) {
  //   isDragging = false;
  //   final velocity = details.primaryVelocity ?? 0;
  //   if (velocity.abs() > 500) {
  //     if (velocity > 0) {
  //
  //       controller.reverse();
  //     } else {
  //       // Fast upward flick - open
  //       controller.forward();
  //     }
  //   } else {
  //     // Slower drag - check threshold
  //     if (controller.value < 1.0 - dragThreshold) {
  //       // Close if we're below the threshold
  //       controller.reverse();
  //     } else {
  //       // Otherwise open
  //       controller.forward();
  //     }
  //   }
  // }
  List<Widget> getPages() {
    return [
      HomePage(),
      MyRidePage(),
      TrackRidePage(),
      MessageListPage(),
      ProfilePage(),
    ];
  }
}
