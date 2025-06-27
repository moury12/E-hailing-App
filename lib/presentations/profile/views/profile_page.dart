import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/navigation/controllers/navigation_controller.dart';
import 'package:e_hailing_app/presentations/notification/views/notification_page.dart';
import 'package:e_hailing_app/presentations/profile/views/account_settings_page.dart';
import 'package:e_hailing_app/presentations/profile/views/coin_page.dart';
import 'package:e_hailing_app/presentations/profile/views/earnings_page.dart';
import 'package:e_hailing_app/presentations/profile/views/term_policy_help_page.dart';
import 'package:e_hailing_app/presentations/profile/views/vehicle_details_page.dart';
import 'package:e_hailing_app/presentations/profile/widgets/user_shimmer_widget.dart';
import 'package:e_hailing_app/presentations/save-location/views/saved_location_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constant.dart';
import '../widgets/profile_action_item_widget.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () async {
        CommonController.to.getUserProfileRequest();
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24.r),
              ),
              gradient: LinearGradient(
                colors: [
                  AppColors.kWhiteColor,
                  AppColors.kPrimaryExtraLightColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kExtraLightGreyTextColor,
                  blurRadius: 6.r,
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.viewPaddingOf(context).top),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        NavigationController.to.changeIndex(0);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    CustomText(text: AppStaticStrings.profile),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.hammer,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: padding12.copyWith(top: 0),
                  child: Obx(() {
                    return CommonController.to.isLoadingProfile.value
                        ? UserShimmerWidget()
                        : Row(
                          spacing: 12.w,
                          children: [
                            CustomNetworkImage(
                              imageUrl:
                                  "${ApiService().baseUrl}/${CommonController.to.userModel.value.img}",
                              height: 70.w,
                              width: 70.w,
                              boxShape: BoxShape.circle,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text:
                                        CommonController
                                            .to
                                            .userModel
                                            .value
                                            .name ??
                                        AppStaticStrings.noDataFound,
                                    fontSize: getFontSizeDefault(),
                                    color: AppColors.kTextDarkBlueColor,
                                  ),
                                  CustomText(
                                    text:
                                        CommonController
                                            .to
                                            .userModel
                                            .value
                                            .email ??
                                        AppStaticStrings.noDataFound,
                                    fontSize: getFontSizeSmall(),
                                    color: AppColors.kExtraLightTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: padding16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.h,
                  children: [
                    ProfileActionItemWidget(
                      img: settingsIcon,
                      title: AppStaticStrings.accountSetting,
                      onTap: () {
                        Get.toNamed(AccountSettingsPage.routeName);
                      },
                    ),
                    CommonController.to.isDriver.value
                        ? ProfileActionItemWidget(
                          img: vehicleDetailsIcon,
                          title: AppStaticStrings.vehicleDetails,
                          onTap: () {
                            Get.toNamed(VehicleDetailsPage.routeName);
                          },
                        )
                        : ProfileActionItemWidget(
                          img: coinIcon,
                          title: AppStaticStrings.duduCoinWallet,
                          onTap: () {
                            Get.toNamed(CoinPage.routeName);
                          },
                        ),
                    ProfileActionItemWidget(
                      img: notificationProfileIcon,
                      title: AppStaticStrings.notification,
                      onTap: () {
                        Get.toNamed(NotificationPage.routeName);
                      },
                    ),
                    CommonController.to.isDriver.value
                        ? ProfileActionItemWidget(
                          img: earningIcon,
                          title: AppStaticStrings.earnings,
                          onTap: () {
                            Get.toNamed(EarningsPage.routeName);
                          },
                        )
                        : ProfileActionItemWidget(
                          img: savedLocationIcon,
                          title: AppStaticStrings.savedLocation,
                          onTap: () {
                            Get.toNamed(SavedLocationPage.routeName);
                          },
                        ),
                    CustomText(
                      text: AppStaticStrings.more,
                      fontSize: getFontSizeDefault(),
                    ),
                    ProfileActionItemWidget(
                      img: termsIcon,
                      title: AppStaticStrings.termsAndCondition,
                      onTap: () {
                        Get.toNamed(TermsPolicyHelpPage.routeName);
                      },
                    ),
                    ProfileActionItemWidget(
                      img: privacyIcon,
                      title: AppStaticStrings.privacyPolicy,
                      onTap: () {
                        Get.toNamed(TermsPolicyHelpPage.routeName);
                      },
                    ),
                    ProfileActionItemWidget(
                      img: helpIcon,
                      title: AppStaticStrings.helpSupport,
                      onTap: () {
                        Get.toNamed(TermsPolicyHelpPage.routeName);
                      },
                    ),
                    ProfileActionItemWidget(
                      img: logoutIcon,
                      title: AppStaticStrings.logOut,
                      onTap: () {
                        CommonController.to.onLogout();
                        Get.offAllNamed(LoginPage.routeName);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
