import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/profile/model/assigned_car_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/utils/variables.dart';

class DriverSettingsController extends GetxController {
  static DriverSettingsController get to => Get.find();
  RxList<String> tabLabels =
      [AppStaticStrings.general, AppStaticStrings.licensePlate].obs;

  Rx<AssignedCarModel> assignCarModel = AssignedCarModel().obs;
  RxBool isLoadingCar = false.obs;

  @override
  void onInit() {
    if (CommonController.to.userModel.value.assignedCar != null) {
      getDriverAssignedCar();
    }
    super.onInit();
  }

  Future<void> getDriverAssignedCar() async {
    try {
      isLoadingCar.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getCarEndpoint,
        method: 'GET',
        queryParams: {
          "carId": CommonController.to.userModel.value.assignedCar.toString(),
        },
      );
      isLoadingCar.value = false;
      if (response['success'] == true) {
        logger.d(response);
        assignCarModel.value = AssignedCarModel.fromJson(response['data']);

        if (assignCarModel.value.carImage != null &&
            assignCarModel.value.carImage!.isNotEmpty) {
          preloadImagesFromUrls(assignCarModel.value.carImage ?? []);
        }
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
    } finally {
      isLoadingCar.value = false;
    }
  }
}
