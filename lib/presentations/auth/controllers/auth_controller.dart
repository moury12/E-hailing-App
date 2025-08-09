import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/auth/views/otp_page.dart';
import 'package:e_hailing_app/presentations/auth/views/reset_password_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  @override
  void onInit() {
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
  RxBool isGoogleAuthLoading = false.obs;
  RxBool isAppleAuthLoading = false.obs;

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
          "phoneNumber": phoneSignUpController.text,
          "password": passSignUpController.text,
          "confirmPassword": confirmPassSignUpController.text,
          "provider": "local", //local //google //apple
          "role": "USER",
        },
        useAuth: false,
      );

      // Clear loading state
      loadingProcess.value = AuthProcess.none;
      logger.d(response);
      if (response['success'] == true) {
        showCustomSnackbar(title: 'Success', message: response['message']);
        Get.toNamed(OtpPage.routeName, arguments: verifyEmail);
      } else if (response['message'] ==
          "Already have an account. Please activate") {
        Get.toNamed(OtpPage.routeName, arguments: verifyEmail);
      } else {
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
  }) async {
    try {
      loadingProcess.value = AuthProcess.activateAccount;
      String codeKeyName = isAccVerify ? "activationCode" : "code";
      final response = await ApiService().request(
        endpoint: isAccVerify ? activeAccEndPoint : verifyOtpEndPoint,
        useAuth: false,
        method: 'POST',
        body: {
          "email": email,
          codeKeyName: otpControllers.map((e) => e.value.text).join(),
        },
      );

      loadingProcess.value = AuthProcess.none;

      if (response['success'] == true) {
        logger.d(response);
        // Boxes.getUserData().put(verifyTokenKey, response['data']['token']);
        // logger.d(
        //   Boxes.getUserData().put(verifyTokenKey, response['data']['token']),
        // );
        showCustomSnackbar(title: 'Success', message: response['message']);

        if (isAccVerify) {
          Get.offAllNamed(LoginPage.routeName);
          nameSignUpController.clear();
          passSignUpController.clear();
          confirmPassSignUpController.clear();
          emailSignUpController.value.clear();
          phoneSignUpController.clear();
        } else {
          otpControllers.clear();
          Get.offAllNamed(ResetPasswordPage.routeName, arguments: email);
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
  Future<void> signInRequest() async {
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
        Boxes.getUserData().put(tokenKey, response["data"]['accessToken']);
        // NavigationController.to.isLoggedIn;
        ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
        await CommonController.to.initialSetUp();

        Get.offAllNamed(
          NavigationPage.routeName,
          // arguments: {'reconnectSocket': true},
        );
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
        Get.toNamed(OtpPage.routeName, arguments: "forget");
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
  Future<void> resetPasswordRequest({required String email}) async {
    try {
      loadingProcess.value = AuthProcess.resetPassword;

      ApiService().setAuthToken(
        Boxes.getUserData().get(verifyTokenKey).toString(),
      );

      final response = await ApiService().request(
        endpoint: resetPasswordEndPoint,
        method: 'POST',
        body: {
          "email": email,
          "confirmPassword": confirmPassNewController.text,
          "newPassword": passNewController.text,
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

  Future<void> signInWithGoogle() async {
    try {
      isGoogleAuthLoading.value = true;

      // 🔹 Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isGoogleAuthLoading.value = false;
        return; // User cancelled
      }

      final String name = googleUser.displayName ?? "User";
      final String email = googleUser.email;
      final String photoUrl = googleUser.photoUrl ?? "";

      // 🔹 Send initial data to backend
      final initialResponse = await ApiService().request(
        endpoint: socialEndPoint,
        method: 'POST',
        body: {
          "name": name,
          "email": email,
          "profile_image": photoUrl,
          "provider": "google",
          "role": "USER",
        },
        useAuth: false,
      );

      logger.d(initialResponse.toString());

      // ✅ Success - store token and navigate
      if (initialResponse['success'] == true) {
        Boxes.getUserData().put(
          tokenKey,
          initialResponse["data"]['accessToken'],
        );
        ApiService().setAuthToken(initialResponse["data"]['accessToken']);

        showCustomSnackbar(
          title: 'Success',
          message: initialResponse['message'],
        );
        await CommonController.to.initialSetUp();
        Get.offAllNamed(
          NavigationPage.routeName,
          // arguments: {'reconnectSocket': true},
        );
      } else {
        // 🔁 Retry with phone number if needed
        String userPhoneNumber = '';
        String? phoneNumber = await Get.dialog<String>(
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.h,
              children: [
                CustomTextField(
                  title: AppStaticStrings.phoneNumber,
                  keyboardType: TextInputType.phone,
                  hintText: "e.g. +8801XXXXXXXXX",

                  onChanged: (value) => userPhoneNumber = value,
                ),
                CustomButton(
                  onTap: (){
                    if(userPhoneNumber.isNotEmpty){
                      Get.back(result: userPhoneNumber);
                    }
                  },
                  title: AppStaticStrings.submit.tr,
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );

        // 🚫 Cancelled or empty input
        if (phoneNumber == null || phoneNumber.isEmpty) {
          showCustomSnackbar(
            title: 'Phone Required',
            message: 'Phone number is required to continue.',
            type: SnackBarType.failed,
          );
          return;
        }

        // 🔄 Resend with phone number
        final retryResponse = await ApiService().request(
          endpoint: socialEndPoint,
          method: 'POST',
          body: {
            "name": name,
            "email": email,
            "profile_image": photoUrl,
            "phoneNumber": phoneNumber,
            "provider": "google",
            "role": "USER",
          },
          useAuth: false,
        );

        if (retryResponse['success'] == true) {
          Boxes.getUserData().put(
            tokenKey,
            retryResponse["data"]['accessToken'],
          );
          ApiService().setAuthToken(retryResponse["data"]['accessToken']);

          showCustomSnackbar(
            title: 'Success',
            message: retryResponse['message'],
          );
          // NavigationController.to.isLoggedIn;
          await CommonController.to.initialSetUp();
          Get.offAllNamed(
            NavigationPage.routeName,
            // arguments: {'reconnectSocket': true},
          );
        } else {
          showCustomSnackbar(
            title: 'Failed',
            message: retryResponse['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e('Google Sign-In Error: $e');
      showCustomSnackbar(
        title: 'Error',
        message: 'Something went wrong. Please try again.',
        type: SnackBarType.failed,
      );
    } finally {
      isGoogleAuthLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    try {
      isAppleAuthLoading.value = true;
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Extract the ID token
      final idToken = credential.identityToken;
      logger.d(idToken);
      if (idToken == null) throw Exception('No ID token received');
    } catch (e) {
      isAppleAuthLoading.value = false;
      print("error apple $e");
      // logger.e('Error: $e');
      // Consider showing a user-friendly error message
    }
  }

  reinitializeSignUpControllers() {
    if (kDebugMode) {
      emailSignUpController.value.text = 'cameg29044@lewou.com';
      nameSignUpController.text = 'cameg29044';
      phoneSignUpController.text = '01566026603';
      passSignUpController.text = '123456';
      confirmPassSignUpController.text = '123456';
      emailLoginController.text = 'cameg29044@lewou.com';
      // emailLoginController.text = 'hosainahmed534745@gmail.com';
      passLoginController.text = '123456';

      emailForgetController.value.text =
          'tanzibamouri00@gmail.com' /*'pihoner651@eligou.com'*/;
      passNewController.text = '123456';
      confirmPassNewController.text = '123456';
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
}
