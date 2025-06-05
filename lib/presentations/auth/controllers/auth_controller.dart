import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/custom_space.dart';
import '../../../core/constants/custom_text.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 1), () {
      return showCredentialsDialog();
    });
    reinitializeSignUpControllers();


    super.onInit();
  }

  RxBool isRememberMe = false.obs;



  var tabContent = <Widget>[].obs;
  Rx<AuthProcess> loadingProcess = AuthProcess.none.obs;
  bool isLoading(AuthProcess process) => loadingProcess.value == process;
  bool get isAnyLoading => loadingProcess.value != AuthProcess.none;

  ///=============================controller for signUp ========================///

  Rx<TextEditingController> emailSignUpController = TextEditingController().obs;
  TextEditingController nameSignUpController = TextEditingController();
  TextEditingController phoneSignUpController = TextEditingController();
  Rx<TextEditingController> ageSignUpController = TextEditingController().obs;
  TextEditingController passSignUpController = TextEditingController();

  TextEditingController confirmPassSignUpController = TextEditingController();
  Rx<TextEditingController> emailForgetController = TextEditingController().obs;

  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passLoginController = TextEditingController();

  TextEditingController passNewController = TextEditingController();

  TextEditingController confirmPassNewController = TextEditingController();

  ///------------------------------ sign up method -------------------------///
  Future<void> signUpRequest() async {
    try {
      // Set loading state for this specific process
      loadingProcess.value = AuthProcess.signUp;

      final response = await ApiService().request(
        endpoint: signupEndPoint,
        method: 'POST',
        body: {
          "name": nameSignUpController.text,
          "email": emailSignUpController.value.text,
          "phone": phoneSignUpController.value.text,
          "password": passSignUpController.text,
          "confirm_password": confirmPassSignUpController.text,
        },
        useAuth: false,
      );

      // Clear loading state
      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        // Get.toNamed(VerifyOtpPage.routeName, arguments: verifyEmail);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );

      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    }
  }

  ///------------------------------ verify email method -------------------------///
  Future<void> verifyEmailRequest({
    required String email,
    required bool isAccVerify,
  })
  async {
    try {
      loadingProcess.value = AuthProcess.activateAccount;

      final response = await ApiService().request(
        endpoint: verifyOtpEndPoint,
        useAuth: false,
        method: 'POST',
        body: {
          "email": email,
          "code": otpControllers.map((e) => e.value.text).join(),
        },
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        Boxes.getUserData().put(verifyTokenKey, response['data']['token']);
        logger.d(
          Boxes.getUserData().put(verifyTokenKey, response['data']['token']),
        );
        showCustomSnackbar(title: 'Success', message: response['message']);

        if (isAccVerify) {
          Get.offAllNamed(LoginPage.routeName);
        } else {
          // Get.toNamed(SetNewPasswordPage.routeName);
        }
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );

      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    }
  }

  ///------------------------------ sign in method -------------------------///
  Future<void> signInRequest() async
  {
    try {
      loadingProcess.value = AuthProcess.login;

      final response = await ApiService().request(
        endpoint: loginEndPoint,
        method: 'POST',
        useAuth: false,
        body: {
          "email": AuthController.to.emailLoginController.text,
          "password": AuthController.to.passLoginController.text,
        },
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        if (isRememberMe.value) {
          saveCredentials(
            AuthController.to.emailLoginController.text,
            AuthController.to.passLoginController.text,
            isRememberMe.value,
          );
        }
        showCustomSnackbar(title: 'Success', message: response['message']);
        Boxes.getUserData().put(tokenKey, response['token']);
        // NavigationController.to.isLoggedIn;
        ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
        Get.offAllNamed(NavigationPage.routeName);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );

      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    }
  }

  ///------------------------------ forget password method -------------------------///
  Future<void> forgetPasswordRequest({required String email}) async {
    try {
      loadingProcess.value = AuthProcess.forgetPassword;

      final response = await ApiService().request(
        endpoint: forgetPassEndPoint,
        method: 'POST',
        body: {"email": email},
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        // Get.toNamed(VerifyOtpPage.routeName);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );

      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    }
  }

  ///------------------------------ reset password method -------------------------///
  Future<void> resetPasswordRequest() async {
    try {
      loadingProcess.value = AuthProcess.resetPassword;

      ApiService().setAuthToken(
        Boxes.getUserData().get(verifyTokenKey).toString(),
      );

      final response = await ApiService().request(
        endpoint: resetPasswordEndPoint,
        method: 'POST',
        body: {
          "confirm_password": confirmPassNewController.text,
          "password": passNewController.text,
        },
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message: response['message']);
        ApiService().clearAuthToken();
        Get.offAllNamed(LoginPage.routeName);
      } else {
        logger.e(response);

        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );

      }
    } catch (e) {
      loadingProcess.value = AuthProcess.none;
      logger.e(e.toString());
    }
  }




  clearSignUpController() {
    emailSignUpController.value.clear();
    nameSignUpController.clear();
    passSignUpController.clear();
    confirmPassSignUpController.clear();
  }

  @override
  void onClose() {
    emailSignUpController.value.dispose();
    nameSignUpController.dispose();
    passSignUpController.dispose();
    confirmPassSignUpController.dispose();
    passNewController.dispose();
    confirmPassNewController.dispose();
    super.onClose();
  }

  reinitializeSignUpControllers() {
    if (kDebugMode) {
      emailSignUpController.value.text = 'vaxag42656@bamsrad.com';
      nameSignUpController.text = 'vaxag42656';
      phoneSignUpController.text = '01566026603';
      passSignUpController.text = '12345aA*';
      confirmPassSignUpController.text = '12345aA*';
      // emailLoginController.text = 'vaxag42656@bamsrad.com';
      // passLoginController.text = '12345aA*';

      emailForgetController.value.text =
      'calaga8422@bocapies.com' /*'pihoner651@eligou.com'*/;
      passNewController.text = '12345aA*';
      confirmPassNewController.text = '12345aA*';
    }
  }



  ///------------------------------- OTP section ------------------------------///
  final List<Rx<TextEditingController>> otpControllers = List.generate(
    6,
        (index) => TextEditingController().obs,
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus(); // Move to next field
      }
    } else if (index > 0) {
      focusNodes[index - 1]
          .requestFocus(); // Move to previous field on backspace
    }
  }

  bool checkOtpProvided() {
    for (var controller in otpControllers) {
      if (controller.value.text.isEmpty) {
        return false; // If any field is empty, return false
      }
    }
    return true; // All fields are filled
  }

  String getOtp() {
    return otpControllers.map((e) => e.value.text).join();
  }

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.value.clear();
    }
    focusNodes[0].requestFocus();
  }
  Future<void> showCredentialsDialog() async {
    final credentials = await getCredentials();

    if (credentials.isNotEmpty && credentials['rememberMe'] == true) {
      Get.dialog(
        AlertDialog(

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                textAlign: TextAlign.center,
                text: 'Email: ${credentials['email']}',
                color: AppColors.kExtraLightTextColor,
                fontSize: getFontSizeSemiSmall(),
              ),
              CustomText(
                textAlign: TextAlign.center,
                text:'Password: ${'•' * (credentials['password']?.length ?? 0)}',
                color: AppColors.kExtraLightTextColor,
                fontSize: getFontSizeSemiSmall(),
              ),
              space8H,
              Row(
                spacing: 8.w,
                children: [
                  Expanded(
                    child: CustomButton(
                      textColor: AppColors.kPrimaryColor,
                      fillColor: Colors.transparent,
                      onTap: () => Get.back(),
                      title: AppStaticStrings.cancel.tr,
                    ),
                  ),
                  Expanded(
                      child:  CustomButton(
                        onTap: () {
                          AuthController.to.emailLoginController.text=credentials['email'];
                          AuthController.to.passLoginController.text=credentials['password'];

                          Get.back();
                        },
                        title: AppStaticStrings.confirm.tr,
                      )
                  ),
                ],
              ),

            ],
          ),

        ),
        barrierDismissible: true,
      );
    }
  }

}

