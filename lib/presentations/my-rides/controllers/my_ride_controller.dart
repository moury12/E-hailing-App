import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/api-client/api_endpoints.dart';

class MyRideController extends GetxController {
  static MyRideController get to => Get.find();
  RxList<TripResponseModel> myRides = <TripResponseModel>[].obs;

  ///====================ride pagination variable========================///

  final RxInt currentProductPage = 1.obs;
  final RxInt itemsProductPerPage = 10.obs;
  final RxInt totalProductPages = 5.obs;
  final RxBool isProductLoadingMore = false.obs;
  RxString rideStatus = "completed".obs;
  RxList<String> tabLabels =
      [
        AppStaticStrings.ongoing,
        AppStaticStrings.upcoming,
        AppStaticStrings.completed,
      ].obs;
  var tabContent = <Widget>[].obs;
  RxBool isAllTripLoading = false.obs;

  @override
  void onInit() {
    getAllRideRequest();
    super.onInit();
  }

  Future<void> getAllRideRequest({bool loadMore = false}) async {
    try {
      // Don't load more if we've reached the last page
      if (loadMore && currentProductPage.value >= totalProductPages.value) {
        return;
      }

      if (loadMore) {
        isProductLoadingMore.value = true;
        currentProductPage.value++;
        // Don't increment page here - we'll do it after successful response
      } else {
        isAllTripLoading.value = true;
        currentProductPage.value = 1;
      }
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: getAllTripEndpoint,
        method: 'GET',
        useAuth: true,
        queryParams: {
          'page': currentProductPage.value.toString(),
          'limit': itemsProductPerPage.value.toString(),
          'status': rideStatus.value,
        },
      );

      isAllTripLoading.value = false;
      isProductLoadingMore.value = false;

      if (response['success'] == true) {
        if (response["data"]["meta"] != null) {
          currentProductPage.value = response["data"]["meta"]['page'] ?? 1;
          totalProductPages.value =
              response["data"]["meta"]['total'] ?? 1; // Add this line
          itemsProductPerPage.value = response["data"]["meta"]['limit'] ?? 10;
        }

        final newRide =
            (response['data']["trips"] as List)
                .map((e) => TripResponseModel.fromJson(e))
                .toList();

        if (loadMore) {
          // Only increment page after successful load

          myRides.addAll(newRide);
        } else {
          myRides.value = newRide;
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
      isAllTripLoading.value = false;
      isProductLoadingMore.value = false;
    }
  }
}
