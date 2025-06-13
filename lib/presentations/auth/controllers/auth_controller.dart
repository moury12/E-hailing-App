import 'package:e_hailing_app/core/api-client/api_endpoints.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
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
          Get.offAllNamed(ResetPasswordPage.routeName);
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
        await CommonController.to.checkUserRole();
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
          "email": emailForgetController.value.text,
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String name = googleUser.displayName ?? "User";
      final String email = googleUser.email;
      final response = await ApiService().request(
        endpoint: signupEndPoint,
        method: 'POST',
        body: {
          "name": name,
          "email": email,
          "password": "123456", // dummy password (you may use JWT or token)
          "confirmPassword": "123456",
          "provider": "google",
          "role": "USER",
        },
        useAuth: false,
      );
      logger.d(response.toString());
      isGoogleAuthLoading.value = false;

      if (response['success'] == true) {
        showCustomSnackbar(title: 'Success', message: response['message']);
        Boxes.getUserData().put(tokenKey, response["data"]['accessToken']);
        // NavigationController.to.isLoggedIn;
        ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
        await CommonController.to.checkUserRole();
        Get.offAllNamed(NavigationPage.routeName);
      } else {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      isGoogleAuthLoading.value = false;

      logger.e('Error: $e');
      // Consider showing a user-friendly error message
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

      // final response = await http.post(
      //   Uri.parse('https://appleauth-stbfcg576q-uc.a.run.app'),
      //   headers: {'Content-Type': 'application/json'}, // Add this header
      //   body: jsonEncode({
      //     // Properly encode the JSON
      //     'data': {'idToken': idToken},
      //   }),
      // );

      // logger.d('Backend response: ${response.body}');
      // Map<String, dynamic> responseBody = jsonDecode(response.body);
      // if (responseBody['result']['success'] == true) {
      //   isAppleAuthLoading.value = false;
      //   // Boxes.getUserData().put(
      //   //   tokenKey,
      //   //   responseBody['result']['data']['access_token'],
      //   // );
      //   // Boxes.getUserData().put(
      //   //   refreshTokenKey,
      //   //   responseBody['result']['data']['refresh_token'],
      //   // );
      //   showCustomSnackbar(
      //     title: 'Success',
      //     message: responseBody['result']['data']['message'],
      //   );
      //
      //   logger.d(Boxes.getUserData().get(tokenKey).toString());
      //   Get.offAllNamed(NavigationPage.routeName);
      // }
      // else {
      //   isAppleAuthLoading.value = false;
      //
      //   showCustomSnackbar(
      //     title: 'Failed',
      //     message: response['message'],
      //     type: SnackBarType.failed,
      //   );
      // }
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
