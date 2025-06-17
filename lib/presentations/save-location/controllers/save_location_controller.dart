import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/save-location/model/save_location_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveLocationController extends GetxController {
  static SaveLocationController get to => Get.find();
  Rx<TextEditingController> searchFieldController = TextEditingController().obs;
  RxString lat = ''.obs;
  RxString lng = ''.obs;
  RxString selectedAddress = ''.obs;
  RxBool isLoadingSaveLocation = false.obs;
  RxBool isLoadingDeleteLocation = false.obs;
  RxBool isLoadingSavedLocation = false.obs;
  TextEditingController placeName = TextEditingController();

  ///====================save location pagination variable========================///

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt totalSaveLocationPages = 5.obs;
  final RxBool isLoadingMore = false.obs;

  final RxList<SaveLocationModel> saveLocationList = <SaveLocationModel>[].obs;

  ///------------------------------  save place method -------------------------///

  Future<void> savePlaceRequest({
    required String locationName,
    required String locationAddress,
    required double lat,
    required double lng,
  }) async {
    try {
      isLoadingSaveLocation.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: saveLocationEndPoint,
        method: 'POST',
        body: {
          "locationName": locationName,
          "locationAddress": locationAddress,
          "longitude": lng,
          "latitude": lat,
        },
      );
      isLoadingSaveLocation.value = false;
      if (response['success'] == true) {
        logger.d(response);
        placeName.clear();
        searchFieldController.value.clear();
        showCustomSnackbar(title: 'Success', message: response['message']);
        await getSaveLocationListRequest();
        Get.back();
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message']);
      }
    } catch (e) {
      isLoadingSaveLocation.value = false;
      logger.e(e.toString());
    }
  }

  ///------------------------------  get save location list method -------------------------///

  Future<void> getSaveLocationListRequest({bool loadMore = false}) async {
    try {
      if (loadMore && currentPage.value >= totalSaveLocationPages.value) {
        return;
      }

      if (loadMore) {
        currentPage.value++;
        isLoadingMore.value = true;
      } else {
        isLoadingSavedLocation.value = true;
        currentPage.value = 1;
      }
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getSavedLocationEndPoint,
        method: 'GET',
        queryParams: {
          'page': currentPage.value.toString(),
          'limit': itemsPerPage.value.toString(),
          'sort': 'updatedAt',
          // 'order': 'desc',
        },
      );

      isLoadingSavedLocation.value = false;
      isLoadingMore.value = false;
      if (response['success'] == true) {
        if (response['data']['meta'] != null) {
          currentPage.value = response['data']['meta']['page'] ?? 1;
          totalSaveLocationPages.value =
              response['data']['meta']['totalPage'] ?? 1; // Add this line

          itemsPerPage.value = response['data']['meta']['limit'] ?? 10;
        }
        final newLocation =
            (response['data']["result"] as List)
                .map((e) => SaveLocationModel.fromJson(e))
                .toList();

        if (loadMore) {
          saveLocationList.addAll(newLocation); // Append for load more
        } else {
          saveLocationList.value = newLocation; // Replace for refresh
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
      isLoadingSavedLocation.value = false;
    }
  }

  ///------------------------------  delete place method -------------------------///

  Future<void> deletePlaceRequest({required String locationID}) async {
    try {
      isLoadingDeleteLocation.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: deleteSavedLocationEndPoint,
        method: 'DELETE',
        body: {"savedLocationId": locationID},
      );

      if (response['success'] == true) {
        logger.d(response);

        showCustomSnackbar(title: 'Success', message: response['message']);
        // await getConversationListRequest();

        isLoadingDeleteLocation.value = false;
        await getSaveLocationListRequest();
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message']);
      }
    } catch (e) {
      isLoadingDeleteLocation.value = false;
      logger.e(e.toString());
    }
  }
}
