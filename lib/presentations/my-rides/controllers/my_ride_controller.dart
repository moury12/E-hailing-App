import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/api-client/api_endpoints.dart';

class MyRideController extends GetxController {
  static MyRideController get to => Get.find();

  ///====================ride pagination variable========================///

  final RxInt currentProductPage = 1.obs;
  final RxInt itemsProductPerPage = 5.obs;
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
    initPaging();
    super.onInit();
  }

  void initPaging() {
    pagingController.addPageRequestListener((pageKey) {
      if (!isAllTripLoading.value) {
        getAllRideRequest(pageKey: pageKey);
      }
    });
  }

  void initializeData() {
    if (pagingController.itemList == null ||
        pagingController.itemList!.isEmpty) {
      pagingController.refresh();
    }
  }

  final PagingController<int, TripResponseModel> pagingController =
      PagingController(firstPageKey: 1);

  Future<void> getAllRideRequest({required int pageKey}) async {
    if (isAllTripLoading.value) return;
    isAllTripLoading.value = true;

    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: getAllTripEndpoint,
        method: 'GET',
        useAuth: true,
        queryParams: {
          'page': pageKey.toString(),
          'limit': "5",
          'status': rideStatus.value,
        },
      );
logger.d(response);
      if (response['success'] == true) {
        final newItems =
            (response['data']['trips'] as List)
                .map((e) => TripResponseModel.fromJson(e))
                .toList();

        // logger.d(newItems.length);

        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.error = 'Error fetching data';

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
      pagingController.error = 'An error occurred';
    } finally {
      isAllTripLoading.value = false;
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
