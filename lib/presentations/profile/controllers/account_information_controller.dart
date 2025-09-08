import 'dart:io';

import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/profile/model/user_profile_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

import '../../../core/service/socket-service/socket_service.dart';

class AccountInformationController extends GetxController {
  static AccountInformationController get to => Get.find();
  RxBool isLoadingUpdateProfile = false.obs;
  RxBool isLoadingProfile = false.obs;
  RxBool isLoadingLogout = false.obs;
  RxBool isLoadingHelpSupport = false.obs;
  RxBool isLoadingDeleteAcc = false.obs;

  Rx<UserProfileModel> userModel = UserProfileModel().obs;
RxString contactEmail="".obs;
RxString contactNumber="".obs;
  RxList<String> tabs =
      [
        AppStaticStrings.general,
        AppStaticStrings.driving,
        AppStaticStrings.document,
      ].obs;
  var tabContent = <Widget>[].obs;
  RxString profileImgPath = "".obs;
  RxBool isLoadingChangePass = false.obs;
  RxnString pdfError = RxnString();
  ///=====================add dynmic name ====================///
  Rx<TextEditingController> nameController = TextEditingController().obs;

  ///=====================add dynmic email ====================///
  Rx<TextEditingController> placeController = TextEditingController().obs;

  ///=====================add dynmic contactNumber ====================///
  Rx<TextEditingController> contactNumberController =
      TextEditingController().obs;

  @override
  void onInit() async{
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getUserProfileRequest(needReinitilaize: true);
    // });
    await Future.wait([
    getUserProfileRequest(needReinitilaize: true),

      getContactSupportRequest()
    ]);
    if(CommonController.to.isDriver.value){
      loadPdf();
      CommonController.to.getReviewListRequest(driverId: userModel.value.sId.toString());
    }
    super.onInit();
  }
   PdfControllerPinch? pdfController;
RxBool pdfLoading =false.obs;
  Future<void> loadPdf() async {
    try {
      pdfLoading.value=true;
      final url = "${ApiService().baseUrl}/${userModel.value.assignedCar?.eHailingVehiclePermitPdf}";
      logger.d("📄 PDF URL: $url");
if(userModel.value.assignedCar==null||userModel.value.assignedCar?.eHailingVehiclePermitPdf==null||userModel.value.assignedCar!.eHailingVehiclePermitPdf!.isEmpty){
  pdfError.value = "Failed to load PDF. Please try again.";
return;
}
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        pdfController = PdfControllerPinch(
          document: PdfDocument.openData(bytes),
        );


      } else {
        pdfController=null;
        print("Failed to load PDF: ${response.statusCode}");
        // Get.snackbar("Error", "Failed to load PDF");
      }
    } catch (e) {
      pdfError.value = "Failed to load PDF. Please try again.";
      print("PDF Load Error: $e");
      // Get.snackbar("Error", "Failed to load PDF");
    }finally{
      pdfLoading.value=false;
    }
  }
  Future<void> getUserProfileRequest({bool needReinitilaize = false}) async {
    try {
      isLoadingProfile.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getProfileEndPoint,
        method: 'GET',
      );
      logger.d(response);
      if (response['success'] == true) {
        userModel.value = UserProfileModel.fromJson(response['data']);

        if (userModel.value.img != null && userModel.value.img!.isNotEmpty) {
          preloadImagesFromUrls([
            userModel.value.img.toString(),
            userModel.value.drivingLicenseImage.toString(),
            userModel.value.idOrPassportImage.toString(),
            userModel.value.psvLicenseImage.toString(),
          ]);
        }
        if (needReinitilaize) {
          reinitializeProfileControllers();
        }
      } else {
        logger.e(response);

      }
    } catch (e) {
      logger.e(e.toString());
    }finally{
      isLoadingProfile.value = false;

    }
  }
  reinitializeProfileControllers() {
   nameController.value.text =
        userModel.value.name ?? AppStaticStrings.noDataFound;

    ///=====================add dynmic email ====================///
   placeController.value.text =
        userModel.value.address ?? AppStaticStrings.noDataFound;

    ///=====================add dynmic contactNumber ====================///
   contactNumberController.value.text =
        userModel.value.phoneNumber ?? AppStaticStrings.noDataFound;
  }
  ///------------------------------ get contact method -------------------------///


  Future<void> getContactSupportRequest() async {
    try {
      isLoadingHelpSupport.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: getContactEndpoint,
        method: 'GET',
      );
      logger.d(response);
      if (response['success'] == true) {
        contactEmail.value=response['data']['email'];
        contactNumber.value=response['data']['number'];

      } else {
        logger.e(response);

      }
    } catch (e) {
      logger.e(e.toString());
    }finally{
      isLoadingHelpSupport.value = false;

    }
  }

  ///------------------------------ delete profile method -------------------------///

  Future<void> deleteAccRequest({required String password}) async {
    try {
      isLoadingDeleteAcc.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: deleteProfileEndPoint,
        method: 'DELETE',
        useAuth: true,
        body: {"email":userModel.value.email,"password": password},
      );

      isLoadingDeleteAcc.value = false;

      if (response['success'] == true) {
        logger.d(response);
        logoutRequest();
         Get.toNamed(LoginPage.routeName);
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );

      }
    } catch (e) {
      isLoadingDeleteAcc.value = false;
      logger.e(e.toString());
    }
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
        await getUserProfileRequest();
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

  ///------------------------------ change pass method -------------------------///

  Future<void> changePassRequest({
    required String oldPass,
    required String newPass,
    required String confirmPass,
  }) async {
    try {
      isLoadingChangePass.value = true;
      final response = await ApiService().request(
        endpoint: changePasswordEndPoint,
        method: 'PATCH',
        body: {
          "oldPassword": oldPass,
          "newPassword": newPass,
          "confirmPassword": confirmPass,
        },
      );
      isLoadingChangePass.value = false;
      if (response['success'] == true) {
        showCustomSnackbar(title: 'Success', message: response['message']);
        Get.back();
        logger.d(response);
        // Get.back();
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
      isLoadingChangePass.value = false;

      logger.e(e.toString());
    }
  }

  ///------------------------------ log out method -------------------------///

  Future<void> logoutRequest() async {
    try {
      isLoadingLogout.value = true;
      final response = await ApiService().request(
        endpoint: logoutEndpoint,
        method: 'POST',
      );
      isLoadingLogout.value = false;
      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        Boxes.getUserData().delete(tokenKey);
        Boxes.getUserData().delete(roleKey);
        Boxes.getUserRole().delete(role);
        SocketService().disconnect();

        Get.offAllNamed(LoginPage.routeName);
      } else {
        logger.e(response);
        if(kDebugMode){
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }
  //
  // ///------------------------------ delete profile method -------------------------///
  //
  // Future<void> deleteProfileRequest() async {
  //   try {
  //     isLoadingUpdateProfile.value = true;
  //     ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
  //     Map<String, String> fields = {
  //       'name': nameController.value.text,
  //       'phoneNumber': contactNumberController.value.text,
  //       'address': placeController.value.text,
  //     };
  //     Map<String, dynamic> files = {};
  //     if (profileImgPath.value.isNotEmpty) {
  //       files['profile_image'] = File(profileImgPath.value);
  //     }
  //
  //     final response = await ApiService().multipartRequest(
  //       endpoint: editProfileEndPoint,
  //       method: 'PATCH',
  //       fields: fields,
  //       files: files,
  //     );
  //
  //     if (response['success'] == true) {
  //       logger.d(response);
  //       profileImgPath.value = "";
  //       await CommonController.to.getUserProfileRequest();
  //       isLoadingUpdateProfile.value = false;
  //     } else {
  //       logger.e(response);
  //
  //       showCustomSnackbar(
  //         title: 'Failed',
  //         message: response['message'],
  //         type: SnackBarType.failed,
  //       );
  //       isLoadingUpdateProfile.value = false;
  //     }
  //   } catch (e) {
  //     logger.e(e.toString());
  //     isLoadingUpdateProfile.value = false;
  //   }
  // }
}
