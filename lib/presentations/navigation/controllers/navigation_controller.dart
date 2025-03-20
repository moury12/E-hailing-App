import 'package:e_hailing_app/presentations/driver-statics/controllers/statics_controller.dart';
import 'package:e_hailing_app/presentations/driver-statics/views/statics_page.dart';
import 'package:e_hailing_app/presentations/home/views/home_page.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
import 'package:e_hailing_app/presentations/message/views/message_page.dart';
import 'package:e_hailing_app/presentations/my-rides/controllers/my_ride_controller.dart';
import 'package:e_hailing_app/presentations/my-rides/views/my_ride_page.dart';
import 'package:e_hailing_app/presentations/profile/views/profile_page.dart';
import 'package:e_hailing_app/presentations/track-ride/views/track_ride_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/image_constant.dart';
import '../../driver-dashboard/controllers/dashboard_controller.dart';
import '../../driver-dashboard/views/dashboard_page.dart';
import '../../home/controllers/home_controller.dart';
import '../../splash/controllers/common_controller.dart';
import '../../track-ride/controllers/track_ride_controller.dart';
import '../model/navigation_model.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();
  Rx<LatLng> marketPosition = LatLng(23.8168, 90.3675).obs;
  RxString placeName = 'Fetching location...'.obs;
  RxInt currentNavIndex = 0.obs;
  RxBool markerDraging = false.obs;

  @override
  void onInit() {
    getPlaceName(marketPosition.value);
    CommonController.to.isDriver.value
        ? Get.put(DashBoardController())
        : Get.put(HomeController());
    Get.put(MessageController());
    Get.put(MyRideController());
    CommonController.to.isDriver.value
        ? Get.put(StaticsController())
        :  Get.put(TrackRideController());

    super.onInit();
  }

  void changeIndex(int index) {
    currentNavIndex.value = index;
  }

  GoogleMapController? mapController;
  void onMapCreated(GoogleMapController controller) {
    mapController ??= controller; // Store and reuse the same controller
  }

  List<Widget> getPages() {
    return [
      CommonController.to.isDriver.value ? DashboardPage() : HomePage(),
      MyRidePage(),
      CommonController.to.isDriver.value ? StaticsPage() :   TrackRidePage(),
      MessageListPage(),
      ProfilePage(),
    ];
  }
  Future<void> getPlaceName(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        placeName.value = '${place.street} ${place.locality} ${place.country}';
      }
    } catch (e) {
      debugPrint(e.toString());
      placeName.value = 'unknown location';
    }
  }

  RxList<NavigationModel> navList =
      [
        CommonController.to.isDriver.value
            ? NavigationModel(
              title: AppStaticStrings.dashboard,
              img: dashboardIcon,
              index: 0,
            )
            : NavigationModel(
              title: AppStaticStrings.home,
              img: homeIcon,
              index: 0,
            ),
        NavigationModel(
          title: AppStaticStrings.myRides,
          img: rideIcon,
          index: 1,
        ),
        CommonController.to.isDriver.value
            ? NavigationModel(
              title: AppStaticStrings.statics,
              img: staticsIcon,
              index: 2,
            )
            : NavigationModel(
              title: AppStaticStrings.trackRides,
              img: locationIcon,
              index: 2,
            ),
        NavigationModel(
          title: AppStaticStrings.messages,
          img: messageIcon,
          index: 3,
        ),
        NavigationModel(
          title: AppStaticStrings.profile,
          img: profileIcon,
          index: 4,
        ),
      ].obs;
}
