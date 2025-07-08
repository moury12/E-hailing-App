import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/profile/model/terms_policy_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TermsPolicyController extends GetxController {
  static TermsPolicyController get to => Get.find();
  RxBool isLoadingTerms = false.obs;
  Rx<TermsPolicyModel> termsModel = TermsPolicyModel().obs;

  Future<void> getTermsPrivacyRequest({required String endPoint}) async {
    try {
      isLoadingTerms.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: endPoint,
        method: 'GET',
      );

      if (response['success'] == true) {
        logger.d(response);
        termsModel.value = TermsPolicyModel.fromJson(response['data']);
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
      isLoadingTerms.value = false;
    }
  }
}
