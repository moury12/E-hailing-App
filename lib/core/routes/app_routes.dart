import 'package:e_hailing_app/core/bindings/bindings.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/auth/views/otp_page.dart';
import 'package:e_hailing_app/presentations/auth/views/reset_password_page.dart';
import 'package:e_hailing_app/presentations/auth/views/signup_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_email_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_identity_page.dart';
import 'package:e_hailing_app/presentations/message/views/chatting_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/notification/views/notification_page.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:e_hailing_app/presentations/profile/views/account_information_page.dart';
import 'package:e_hailing_app/presentations/profile/views/account_settings_page.dart';
import 'package:e_hailing_app/presentations/profile/views/change_password_page.dart';
import 'package:e_hailing_app/presentations/profile/views/coin_page.dart';
import 'package:e_hailing_app/presentations/profile/views/earnings_page.dart';
import 'package:e_hailing_app/presentations/profile/views/edit_profile_page.dart';
import 'package:e_hailing_app/presentations/profile/views/term_policy_help_page.dart';
import 'package:e_hailing_app/presentations/profile/views/transaction_page.dart';
import 'package:e_hailing_app/presentations/profile/views/vehicle_details_page.dart';
import 'package:e_hailing_app/presentations/save-location/views/add_place_page.dart';
import 'package:e_hailing_app/presentations/splash/views/splash_page.dart';
import 'package:e_hailing_app/presentations/trip/views/request_trip_page.dart';
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:get/get.dart';

import '../../presentations/save-location/views/saved_location_page.dart';

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
      binding: AccountInformationBinding(),
    ),
    GetPage(
      name: SavedLocationPage.routeName,
      page: () => SavedLocationPage(),
      binding: SaveLocationBinding(),
    ),
    GetPage(
      name: RequestTripPage.routeName,
      page: () => RequestTripPage(),
      binding: TripBinding(),
    ),
    GetPage(
      name: TripDetailsPage.routeName,
      page: () => TripDetailsPage(),
      binding: TripBinding(),
    ),
    GetPage(
      name: PaymentPage.routeName,
      page: () => PaymentPage(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: NavigationPage.routeName,
      page: () => NavigationPage(),
      binding: NavigationBinding(),
    ),

    GetPage(
      name: NotificationPage.routeName,
      page: () => NotificationPage(),
      // binding: NavigationBinding(),
    ),
    GetPage(
      name: TransactionPage.routeName,
      page: () => TransactionPage(),
      // binding: NavigationBinding(),
    ),
    GetPage(
      name: ChattingPage.routeName,
      page: () => ChattingPage(),
      // binding: NavigationBinding(),
    ),
    GetPage(
      name: AccountInformationPage.routeName,
      page: () => AccountInformationPage(),
      binding: AccountInformationBinding(),
    ),
    GetPage(
      name: EditProfilePage.routeName,
      page: () => EditProfilePage(),
      binding: AccountInformationBinding(),
    ),
    GetPage(
      name: AccountSettingsPage.routeName,
      page: () => AccountSettingsPage(),
      // binding: NavigationBinding(),
    ),
    GetPage(
      name: CoinPage.routeName,
      page: () => CoinPage(),
      // binding: NavigationBinding(),
    ),
    GetPage(
      name: TermsPolicyHelpPage.routeName,
      page: () => TermsPolicyHelpPage(),
      // binding: NavigationBinding(),
    ),
    GetPage(
      name: ChangePasswordPage.routeName,
      page: () => ChangePasswordPage(),
      binding: AccountInformationBinding(),
    ),
    GetPage(
      name: VehicleDetailsPage.routeName,
      page: () => VehicleDetailsPage(),
      binding: DriverSettingsBinding(),
    ),
    GetPage(
      name: EarningsPage.routeName,
      page: () => EarningsPage(),
      binding: DriverSettingsBinding(),
    ),
    GetPage(
      name: AddPlacePage.routeName,
      page: () => AddPlacePage(),
      binding: SaveLocationBinding(),
    ),
  ];
}
