import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/save-location/model/save_location_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text_button.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/padding_constant.dart';
import '../../../core/constants/text_style_constant.dart';

class SaveLocationController extends GetxController {
  @override
  void onInit() {
    saveLocationPagingController.addPageRequestListener((pageKey) {
      getSaveLocationListRequest(pageKey: pageKey);
    });
    super.onInit();
  }

  static SaveLocationController get to => Get.find();
  Rx<TextEditingController> searchFieldController = TextEditingController().obs;
  RxString lat = ''.obs;
  RxString lng = ''.obs;
  RxString selectedAddress = ''.obs;
  RxBool isLoadingSaveLocation = false.obs;
  RxBool isLoadingSpecificSaveLocation = false.obs;
  RxBool isLoadingDeleteLocation = false.obs;
  RxBool isLoadingSavedLocation = false.obs;
  TextEditingController placeName = TextEditingController();
  Rx<SaveLocationModel> savedSpecificLocation = SaveLocationModel().obs;

  ///====================save location pagination variable========================///

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt totalSaveLocationPages = 5.obs;
  final RxBool isLoadingMore = false.obs;

  final RxList<SaveLocationModel> saveLocationList = <SaveLocationModel>[].obs;
  final PagingController<int, SaveLocationModel> saveLocationPagingController =
      PagingController(firstPageKey: 1);

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
        Get.back();
        placeName.clear();
        searchFieldController.value.clear();
        showCustomSnackbar(title: 'Success', message: response['message']);
        final newLocation = SaveLocationModel.fromJson(response["data"]);
        final oldItems = saveLocationPagingController.itemList ?? [];
        if (!oldItems.any((element) => element.sId == newLocation.sId)) {
          saveLocationPagingController.itemList = [newLocation, ...oldItems];
        }
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message']);
      }
    } catch (e) {
      isLoadingSaveLocation.value = false;
      logger.e(e.toString());
    } finally {
      isLoadingSaveLocation.value = false;
    }
  }

  Future<void> getSaveLocationListRequest({required int pageKey}) async {
    try {
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getSavedLocationEndPoint,
        method: 'GET',
        queryParams: {
          'page': pageKey.toString(),
          'limit': itemsPerPage.value.toString(),
          'sort': 'updatedAt',
        },
      );
      logger.d(response);
      if (response['success'] == true) {
        final meta = response['data']['meta'];
        final totalPages = meta?['totalPage'] ?? 1;
        final currentPage = meta?['page'] ?? 1;
        itemsPerPage.value = meta?['limit'] ?? 10;

        final newItems =
            (response['data']["result"] as List)
                .map((e) => SaveLocationModel.fromJson(e))
                .toList();

        final isLastPage = currentPage >= totalPages;

        if (isLastPage) {
          saveLocationPagingController.appendLastPage(newItems);
        } else {
          saveLocationPagingController.appendPage(newItems, currentPage + 1);
        }
      } else {
        saveLocationPagingController.error =
            response['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      saveLocationPagingController.error = e.toString();
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
        final currentItems = saveLocationPagingController.itemList;
        if (currentItems != null) {
          currentItems.removeWhere((element) => element.sId == locationID);
          saveLocationPagingController.itemList = [...currentItems];
        }
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message']);
      }
    } catch (e) {
      isLoadingDeleteLocation.value = false;
      logger.e(e.toString());
    } finally {
      isLoadingDeleteLocation.value = false;
    }
  }

  ///------------------------------ get specific save location method -------------------------///

  Future<void> getSpecificSavedLocationRequest({required String id}) async {
    try {
      isLoadingSpecificSaveLocation.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getSpecificSaveLocationEndPoint,
        method: 'GET',
        queryParams: {"savedLocationId": id},
      );
      isLoadingSpecificSaveLocation.value = false;
      if (response['success'] == true) {
        logger.d(response);
        savedSpecificLocation.value = SaveLocationModel.fromJson(
          response['data'],
        );
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
      isLoadingSpecificSaveLocation.value = false;
    }
  }

  Future<void> selectLatlngFromSaveLocation({required String id}) async {
    showLoadingDialog(text: "Fetching location details...");

    try {
      await getSpecificSavedLocationRequest(id: id);
      dismissLoadingDialog();

      // Ensure coordinates are not null before proceeding
      if (savedSpecificLocation.value.location?.coordinates == null ||
          savedSpecificLocation.value.location!.coordinates!.length < 2) {
        showCustomSnackbar(
          title: "Error",
          message: "Saved location coordinates are invalid.",
          type: SnackBarType.failed,
        );
        return;
      }

      await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: CustomText(
            text: AppStaticStrings.selectPosition.tr,
            style: poppinsSemiBold,
            textAlign: TextAlign.center,
          ),
          content: CustomText(
            text: AppStaticStrings.whereSetLocation.tr,
            textAlign: TextAlign.center,
          ),
          contentPadding: padding16,
          actionsPadding: padding12.copyWith(top: 0),
          actions: [
            Column(
              spacing: 8.h,
              children: [
                CustomButton(
                  title: AppStaticStrings.pickup.tr,
                  onTap: () {
                    Get.back(); // close dialog
                    _updateHomeControllerLocation(isPickup: true);
                  },
                ),
                CustomButton(
                  title: AppStaticStrings.dropLocation.tr,
                  onTap: () {
                    Get.back(); // close dialog
                    _updateHomeControllerLocation(isPickup: false);
                  },
                ),
                CustomTextButton(
                  title: AppStaticStrings.cancel.tr,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      logger.e("Error in selectLatlngFromSaveLocation: $e");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to load saved location: ${e.toString()}",
        type: SnackBarType.failed,
      );
      dismissLoadingDialog();
    }
  }

  void _updateHomeControllerLocation({required bool isPickup}) {
    final address =
        savedSpecificLocation.value.locationAddress ??
        AppStaticStrings.noDataFound;
    final latLng = LatLng(
      savedSpecificLocation.value.location!.coordinates!.last, // latitude
      savedSpecificLocation.value.location!.coordinates!.first, // longitude
    );

    if (isPickup) {
      HomeController.to.pickupLocationController.value.text = address;
      HomeController.to.pickupLatLng.value = latLng;
    } else {
      HomeController.to.dropOffLocationController.value.text = address;
      HomeController.to.dropoffLatLng.value = latLng;
    }

    // Close the saved locations list screen
    Get.back();
  }

  @override
  void onClose() {
    saveLocationPagingController.dispose();
    super.onClose();
  }
}
