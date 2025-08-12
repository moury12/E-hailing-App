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

class SaveLocationController extends GetxController {
  @override
  void onInit() {
    saveLocationPagingController.addPageRequestListener((pageKey) {
      getSaveLocationListRequest(pageKey: pageKey);
    });    super.onInit();
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
  })
  async {
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
    }finally{
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

        final newItems = (response['data']["result"] as List)
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
    }finally{
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
    showLoadingDialog(text: "Set saved location...");

    try {
      await getSpecificSavedLocationRequest(id: id);

      // After the data is fetched successfully, update the UI controllers
      HomeController.to.dropOffLocationController.value.text =
          savedSpecificLocation.value.locationAddress ??
          AppStaticStrings.noDataFound; // Using null-aware operator for safety

      // Ensure coordinates are not null before accessing
      if (savedSpecificLocation.value.location?.coordinates != null &&
          savedSpecificLocation.value.location!.coordinates!.length >= 2) {
        HomeController.to.dropoffLatLng.value = LatLng(
          // LatLng constructor is (latitude, longitude)
          // Ensure you're mapping coordinates correctly:
          // savedSpecificLocation.value.location!.coordinates!.last is latitude
          // savedSpecificLocation.value.location!.coordinates!.first is longitude
          savedSpecificLocation.value.location!.coordinates!.last, // latitude
          savedSpecificLocation.value.location!.coordinates!.first, // longitude
        );
      } else {
        showCustomSnackbar(
          title: "Error",
          message: "Saved location coordinates are invalid.",
          type: SnackBarType.failed,
        );
        logger.e("Error: Saved location coordinates are null or malformed.");
      }

      // 3. Navigate back after operations are complete (and dialog is dismissed)
      // The Get.back() here is to pop the screen/sheet that contained the saved locations list.
      // The dismissLoadingDialog() is to pop the loading dialog itself.
      // Ensure dismissLoadingDialog() is called before Get.back() for the screen,
      // or you can call Get.back() twice if the dialog is on top of the list screen.
      // Generally, call dismissLoadingDialog() first.
    } catch (e) {
      // Handle any errors that occur during the request
      logger.e("Error in selectLatlngFromSaveLocation: $e");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to load saved location: ${e.toString()}",
        type: SnackBarType.failed,
      );
    } finally {
      // 2. Dismiss the loading dialog, regardless of success or failure
      dismissLoadingDialog();
      // This Get.back() is likely intended to close the current screen/sheet
      // where the user selected a saved location.
      Get.back(); // This closes the current screen (e.g., location selection screen)
    }
  }
  @override
  void onClose() {
    saveLocationPagingController.dispose();
    super.onClose();
  }
}
