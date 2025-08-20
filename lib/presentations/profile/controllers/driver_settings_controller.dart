import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/model/assigned_car_model.dart';
import 'package:e_hailing_app/presentations/profile/model/driver_earning_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/utils/variables.dart';

class DriverSettingsController extends GetxController {
  static DriverSettingsController get to => Get.find();
  RxList<String> tabLabels =
      [AppStaticStrings.general, AppStaticStrings.licensePlate].obs;

  Rx<AssignedCarModel> assignCarModel = AssignedCarModel().obs;
  Rx<DriverEarningModel> driverEarningModel = DriverEarningModel().obs;
  RxBool isLoadingCar = false.obs;
  var selectedYear = Rx<String?>(null).obs;
  var selectedType = Rx<String?>(null).obs;

  @override
  void onInit() {
    if (AccountInformationController.to.userModel.value.assignedCar != null) {
      getDriverAssignedCar();
    }
    getDriverEarningReport();
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
          "carId": AccountInformationController.to.userModel.value.assignedCar.toString(),
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

  Future<void> getDriverEarningReport({String? year, String? type}) async {
    try {
      isLoadingCar.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getDriverEarningReportEndpoint,
        method: 'GET',
        queryParams: {
          "year": year ?? DateTime.now().year.toString(),
          if (type != null) "type": type,
        },
      );
      if (response['success'] == true) {
        logger.d(response);
        driverEarningModel.value = DriverEarningModel.fromJson(
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
    } finally {
      isLoadingCar.value = false;
    }
  }
}
