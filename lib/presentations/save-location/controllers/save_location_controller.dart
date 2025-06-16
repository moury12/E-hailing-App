import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveLocationController extends GetxController {
  static SaveLocationController get to => Get.find();
  Rx<TextEditingController> searchFieldController = TextEditingController().obs;
  RxString lat = ''.obs;
  RxString lng = ''.obs;
  RxString selectedAddress = ''.obs;
  RxBool isLoadingSaveLocation = false.obs;
  RxBool isLoadingSavedLocation = false.obs;

  ///====================save location pagination variable========================///

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt totalSaveLocationPages = 5.obs;
  final RxBool isLoadingMore = false.obs;

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

      if (response['success'] == true) {
        logger.d(response);

        showCustomSnackbar(title: 'Success', message: response['message']);
        // await getConversationListRequest();

        isLoadingSaveLocation.value = false;
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

  /*
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
        if (response['pagination'] != null) {
          currentPage.value = response['pagination']['currentPage'] ?? 1;
          totalSaveLocationPages.value =
              response['pagination']['totalPages'] ?? 1; // Add this line

          itemsPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }
        final newCategories =
            (response['data'] as List)
                .map((e) => ConversationModel.fromJson(e))
                .toList();
        final imageUrls =
            newCategories
                .map((cat) => "${ApiService().baseUrl}/${cat.users!.first.img}")
                .where((url) => url.isNotEmpty)
                .toList();
        final imageUrls1 =
            newCategories
                .map((cat) => "${ApiService().baseUrl}/${cat.users!.last.img}")
                .where((url) => url.isNotEmpty)
                .toList();

        preloadImagesFromUrls(imageUrls);
        await preloadImagesFromUrls(imageUrls1);
        if (loadMore) {
          conversationList.addAll(newCategories); // Append for load more
        } else {
          conversationList.value = newCategories; // Replace for refresh
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
*/
}
