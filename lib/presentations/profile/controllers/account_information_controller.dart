import 'dart:io';

import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AccountInformationController extends GetxController {
  static AccountInformationController get to => Get.find();
  RxBool isLoadingUpdateProfile = false.obs;

  RxList<String> tabs =
      [
        AppStaticStrings.general,
        AppStaticStrings.driving,
        AppStaticStrings.document,
      ].obs;
  var tabContent = <Widget>[].obs;
  RxString profileImgPath = "".obs;

  ///=====================add dynmic name ====================///
  Rx<TextEditingController> nameController = TextEditingController().obs;

  ///=====================add dynmic email ====================///
  Rx<TextEditingController> placeController = TextEditingController().obs;

  ///=====================add dynmic contactNumber ====================///
  Rx<TextEditingController> contactNumberController =
      TextEditingController().obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CommonController.to.getUserProfileRequest(needReinitilaize: true);
    });
    super.onInit();
  }

  ///------------------------------ update profile method -------------------------///

  Future<void> updateProfileRequest() async {
    try {
      isLoadingUpdateProfile.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      Map<String, String> fields = {
        'name': nameController.value.text,
        'phoneNumber': contactNumberController.value.text,
        'address': placeController.value.text,
      };
      Map<String, dynamic> files = {};
      if (profileImgPath.value.isNotEmpty) {
        files['profile_image'] = File(profileImgPath.value);
      }

      final response = await ApiService().multipartRequest(
        endpoint: editProfileEndPoint,
        method: 'PATCH',
        fields: fields,
        files: files,
      );

      if (response['success'] == true) {
        logger.d(response);
        profileImgPath.value = "";
        await CommonController.to.getUserProfileRequest();
        isLoadingUpdateProfile.value = false;
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
        isLoadingUpdateProfile.value = false;
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingUpdateProfile.value = false;
    }
  }
}
