import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/model/car_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool wantToGo = false.obs;
  RxBool isBottomSheetOpen = true.obs;
  RxBool isDestination = false.obs;
  RxBool setPickup = false.obs;
  RxBool setDestination = false.obs;
  RxBool selectEv = false.obs;
  RxBool addStops = false.obs;
  RxBool isLoadingNewTrip = false.obs;
  RxBool isLoadingCar = false.obs;

  RxString selectedAddress = ''.obs;
  RxString activeField = ''.obs; // "pickup" or "dropoff"
  Rx<LatLng?> pickupLatLng = Rx<LatLng?>(null);
  Rx<LatLng?> dropoffLatLng = Rx<LatLng?>(null);
  final RxList<CarModel> carList = <CarModel>[].obs;
  Rx<TextEditingController> pickupLocationController =
      TextEditingController().obs;
  Rx<TextEditingController> dropOffLocationController =
      TextEditingController().obs;
  AnimationController? controller;
  RxString previousRoute = ''.obs;

  void updatePreviousRoute(String route) {
    previousRoute.value = route;
    update(); // Force rebuild
  }

  bool handleBackNavigation() {
    debugPrint('Previous route: ${Get.previousRoute}');
    debugPrint('Current route: ${Get.currentRoute}');

    // Check if there's a previous route to go back to (excluding nav and root)
    if (Get.previousRoute.isNotEmpty &&
        Get.previousRoute != '/nav' &&
        Get.previousRoute != '/') {
      // if(Get.previousRoute =='/nav'){
      // updatePreviousRoute(Get.currentRoute);
      //   resetAllStates();
      // }
      Get.back();
      return true; // Back navigation handled by Get.back()
    }

    // Handle state transitions within the home screen
    if (selectEv.value) {
      // From Select EV screen -> go back to Set Destination
      selectEv.value = false;
      setDestination.value = true;
      return true; // Handled - don't exit app
    } else if (setDestination.value) {
      // From Set Destination screen -> go back to Set Pickup
      setDestination.value = false;
      setPickup.value = true;
      return true; // Handled - don't exit app
    } else if (setPickup.value) {
      // From Set Pickup screen -> go back to Want To Go
      setPickup.value = false;
      wantToGo.value = true;
      return true; // Handled - don't exit app
    } else if (wantToGo.value) {
      // From Want To Go screen -> go back to initial state
      wantToGo.value = false;
      return true; // Handled - don't exit app
    }

    // No internal state to handle, allow normal back behavior (exit app)
    return false;
  }

  // Helper method to reset all states
  void resetAllStates() {
    wantToGo.value = false;
    setPickup.value = false;
    setDestination.value = false;
    selectEv.value = false;
  }

  // Optional: Methods for transitioning forward through your flow
  void goToWantToGo() {
    resetAllStates();
    wantToGo.value = true;
  }

  void goToSetPickup() {
    resetAllStates();
    setPickup.value = true;
  }

  void goToSetDestination() {
    resetAllStates();
    setDestination.value = true;
  }

  void goToSelectEv() {
    resetAllStates();
    selectEv.value = true;
  }

  ///====================save location pagination variable========================///

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt totalCarPages = 5.obs;
  final RxBool isLoadingMore = false.obs;

  ///------------------------------  get car list method -------------------------///

  Future<void> getCarListRequest({bool loadMore = false}) async {
    try {
      if (loadMore && currentPage.value >= totalCarPages.value) {
        return;
      }

      if (loadMore) {
        currentPage.value++;
        isLoadingMore.value = true;
      } else {
        isLoadingCar.value = true;
        currentPage.value = 1;
      }
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getCarEndPoint,
        method: 'GET',
        queryParams: {
          'page': currentPage.value.toString(),
          'limit': itemsPerPage.value.toString(),
          'sort': 'updatedAt',
          // 'order': 'desc',
        },
      );

      isLoadingCar.value = false;
      isLoadingMore.value = false;
      if (response['success'] == true) {
        if (response['data']['meta'] != null) {
          currentPage.value = response['data']['meta']['page'] ?? 1;
          totalCarPages.value =
              response['data']['meta']['totalPage'] ?? 1; // Add this line

          itemsPerPage.value = response['data']['meta']['limit'] ?? 10;
        }
        final newLocation =
            (response['data']["result"] as List)
                .map((e) => CarModel.fromJson(e))
                .toList();

        if (loadMore) {
          carList.addAll(newLocation); // Append for load more
        } else {
          carList.value = newLocation; // Replace for refresh
        }
        logger.d(response);
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingCar.value = false;
    }
  }
}
