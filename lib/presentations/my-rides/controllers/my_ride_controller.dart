import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';

import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';

import '../../../core/api-client/api_endpoints.dart';

class MyRideController extends GetxController {
  static MyRideController get to => Get.find();

  ///====================ride pagination variable========================///

  final RxInt currentProductPage = 1.obs;
  final RxInt currentTabIndex = 0.obs;
  final RxInt itemsProductPerPage = 5.obs;
  final RxInt totalProductPages = 5.obs;
  final RxBool isProductLoadingMore = false.obs;
  RxBool isCancellingTrip = false.obs;

  List<String> get tabLabels {
    return [
      AppStaticStrings.ongoing.tr,
      AppStaticStrings.upcoming.tr,
      AppStaticStrings.completed.tr,
    ].obs;
  }

  var tabContent = <Widget>[].obs;
  // RxBool isAllTripLoading = false.obs; // Removed global lock

  @override
  void onInit() {
    initPaging();
    super.onInit();
  }

  void initPaging() {
    pagingControllerForCompletedTrip.addPageRequestListener((pageKey) {
      getAllRideRequest(pageKey: pageKey, rideStatus: "completed");
    });
    pagingControllerForUpcomingTrip.addPageRequestListener((pageKey) {
      getAllRideRequest(pageKey: pageKey,  isPreBooked: true);
    });
  }

  void initializeData() {
    if (pagingControllerForCompletedTrip.itemList == null ||
        pagingControllerForCompletedTrip.itemList!.isEmpty) {
      pagingControllerForCompletedTrip.refresh();
    }
  }

  final PagingController<int, TripResponseModel>
  pagingControllerForCompletedTrip = PagingController(firstPageKey: 1);
  final PagingController<int, TripResponseModel>
  pagingControllerForUpcomingTrip = PagingController(firstPageKey: 1);

  Future<void> getAllRideRequest({
    required int pageKey,
    String? rideStatus,
    bool isPreBooked = false,
  }) async {
    // if (isAllTripLoading.value) return; // Removed lock
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   isAllTripLoading.value = true;
    // });

    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: getAllTripEndpoint,
        method: 'GET',
        useAuth: true,
        queryParams: {
          'page': pageKey.toString(),
          'limit': "5",
          if (rideStatus != null) 'status': rideStatus,
          if (isPreBooked) 'tripType':'pre_book'
        },
      );
      PagingController<int, TripResponseModel> pageController =
          rideStatus == "completed"
              ? pagingControllerForCompletedTrip
              : pagingControllerForUpcomingTrip;
            
      logger.d(response);
      if (response['success'] == true) {
        final newItems =
            (response['data']['trips'] as List)
                .map((e) => TripResponseModel.fromJson(e))
                .toList();

        // logger.d(newItems.length);

        if (newItems.isEmpty) {
          pageController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pageController.appendPage(newItems, nextPageKey);
        }
      } else {
        pageController.error = 'Error fetching data';

        logger.e(response);
        if (kDebugMode) {
          // showCustomSnackbar(
          //   title: 'Failed',
          //   message: response['message'],
          //   type: SnackBarType.failed,
          // );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      PagingController<int, TripResponseModel> pageController =
          rideStatus == "completed"
              ? pagingControllerForCompletedTrip
              : pagingControllerForUpcomingTrip;
      pageController.error = e;
    } finally {
      // isAllTripLoading.value = false; // Removed lock
    }
  }

  Future<void> cancelPreBookTrip({
    required String tripId,
    required String cancellationReason,
  }) async {
    try {
      isCancellingTrip.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: cancelPreBookTripEndpoint,
        method: 'POST',
        body: {"tripId": tripId, "cancellationReason": cancellationReason},
      );

      logger.i("Cancel Pre-Book Trip Response: $response");

      if (response['success'] == true) {
        showCustomSnackbar(
          title: 'Success',
          message: response['message'] ?? 'Trip cancelled successfully',
          type: SnackBarType.success,
        );
        pagingControllerForUpcomingTrip.refresh();
      } else {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'] ?? 'Failed to cancel trip',
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      logger.e("Error cancelling pre-book trip: $e");
      showCustomSnackbar(
        title: 'Error',
        message: 'An error occurred while cancelling the trip',
        type: SnackBarType.failed,
      );
    } finally {
      isCancellingTrip.value = false;
    }
  }

  // @override
  // void onClose() {
  //   pagingController.dispose();
  //   super.onClose();
  // }
  //
  // void disposeResources() {
  //   pagingController.dispose();
  // }
}
