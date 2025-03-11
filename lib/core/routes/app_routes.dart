import 'package:e_hailing_app/core/bindings/bindings.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/auth/views/otp_page.dart';
import 'package:e_hailing_app/presentations/auth/views/otp_page.dart';
import 'package:e_hailing_app/presentations/auth/views/reset_password_page.dart';
import 'package:e_hailing_app/presentations/auth/views/reset_password_page.dart';
import 'package:e_hailing_app/presentations/auth/views/signup_page.dart';
import 'package:e_hailing_app/presentations/auth/views/signup_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_email_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_email_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_identity_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_identity_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/splash/views/splash_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static route() => [
    GetPage(
      name: SplashPage.routeName,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: LoginPage.routeName,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: SignupPage.routeName,
      page: () => SignupPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: OtpPage.routeName,
      page: () => OtpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: VerifyEmailPage.routeName,
      page: () => VerifyEmailPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: ResetPasswordPage.routeName,
      page: () => ResetPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: VerifyIdentityPage.routeName,
      page: () => VerifyIdentityPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: NavigationPage.routeName,
      page: () => NavigationPage(),
      binding: NavigationBinding(),
    ),
  ];
}
