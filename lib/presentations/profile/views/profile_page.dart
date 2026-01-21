import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/pagination_loading_widget.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/service/translation-service/translation_controller.dart';
import 'package:e_hailing_app/presentations/notification/views/notification_page.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/views/account_settings_page.dart';
import 'package:e_hailing_app/presentations/profile/views/coin_page.dart';
import 'package:e_hailing_app/presentations/profile/views/earnings_page.dart';
import 'package:e_hailing_app/presentations/profile/views/feedback_page.dart';
import 'package:e_hailing_app/presentations/profile/views/penalty_page.dart';
import 'package:e_hailing_app/presentations/profile/views/term_policy_help_page.dart';
import 'package:e_hailing_app/presentations/profile/views/vehicle_details_page.dart';
import 'package:e_hailing_app/presentations/profile/widgets/user_shimmer_widget.dart';
import 'package:e_hailing_app/presentations/save-location/views/saved_location_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button_tap.dart';
import '../../../core/constants/image_constant.dart';
import '../widgets/profile_action_item_widget.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () async {
        AccountInformationController.to.getUserProfileRequest();
        await AccountInformationController.to.loadPdf();
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
                Padding(
                  padding: padding12.copyWith(top: 0),
                  child: Obx(() {
                    return AccountInformationController
                            .to
                            .isLoadingProfile
                            .value
                        ? UserShimmerWidget()
                        : Row(
                          spacing: 12.w,
                          children: [
                            CustomNetworkImage(
                              imageUrl:
                                  "${ApiService().baseUrl}/${AccountInformationController.to.userModel.value.img}",
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
                                        AccountInformationController
                                            .to
                                            .userModel
                                            .value
                                            .name ??
                                        AppStaticStrings.noDataFound.tr,
                                    fontSize: getFontSizeDefault(),
                                    color: AppColors.kTextDarkBlueColor,
                                  ),
                                  CustomText(
                                    text:
                                        AccountInformationController
                                            .to
                                            .userModel
                                            .value
                                            .email ??
                                        AppStaticStrings.noDataFound.tr,
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
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: padding16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.h,
                  children: [
                    ProfileActionItemWidget(
                      img: settingsIcon,
                      title: AppStaticStrings.accountSetting.tr,
                      onTap: () {
                        Get.toNamed(AccountSettingsPage.routeName);
                      },
                    ),
                    CommonController.to.isDriver.value
                        ? ProfileActionItemWidget(
                          img: vehicleDetailsIcon,
                          title: AppStaticStrings.vehicleDetails.tr,
                          onTap: () {
                            Get.toNamed(VehicleDetailsPage.routeName);
                          },
                        )
                        : ProfileActionItemWidget(
                          img: coinIcon,
                          title: AppStaticStrings.duduCoinWallet.tr,
                          onTap: () {
                            Get.toNamed(CoinPage.routeName);
                          },
                        ),
                    ProfileActionItemWidget(
                      img: notificationProfileIcon,
                      title: AppStaticStrings.notification.tr,
                      onTap: () {
                        Get.toNamed(NotificationPage.routeName);
                      },
                    ),
                    CommonController.to.isDriver.value
                        ? ProfileActionItemWidget(
                          img: earningIcon,
                          title: AppStaticStrings.earnings.tr,
                          onTap: () {
                            Get.toNamed(EarningsPage.routeName);
                          },
                        )
                        : ProfileActionItemWidget(
                          img: savedLocationIcon,
                          title: AppStaticStrings.savedLocation.tr,
                          onTap: () {
                            Get.toNamed(SavedLocationPage.routeName);
                          },
                        ),
                    if (!CommonController.to.isDriver.value)
                      ProfileActionItemWidget(
                        img: penaltyIcon,
                        title: AppStaticStrings.pendingPenalty.tr,
                        onTap: () {
                          Get.to(PenaltyPage());
                        },
                      ),
                    ProfileActionItemWidget(
                      img: languageIcon,
                      title: AppStaticStrings.language.tr,
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            contentPadding: padding8,
                            content: Column(
                              spacing: 6,

                              mainAxisSize: MainAxisSize.min,
                              children: [
                                languageChangeCardWidget(
                                  name: "Malay",
                                  language: "ms",
                                  onTap: () async {
                                    final controller =
                                        Get.find<TranslationController>();
                                    await controller.changeLanguage(
                                      'ms',
                                      'MY',
                                    ); // Saves automatically
                                    Get.back();
                                  },
                                ),
                                languageChangeCardWidget(
                                  name: "English",
                                  language: "en",
                                  onTap: () async {
                                    final controller =
                                        Get.find<TranslationController>();
                                    await controller.changeLanguage(
                                      'en',
                                      'US',
                                    ); // Saves automatically
                                    Get.back();
                                  },
                                ),
                                languageChangeCardWidget(
                                  name: "Chinese",
                                  language: "zh",
                                  onTap: () async {
                                    final controller =
                                        Get.find<TranslationController>();
                                    await controller.changeLanguage(
                                      'zh',
                                      'CN',
                                    ); // Saves automatically
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    CustomText(
                      text: AppStaticStrings.more.tr,
                      fontSize: getFontSizeDefault(),
                    ),
                    ProfileActionItemWidget(
                      img: feedBackIcon,
                      title: AppStaticStrings.feedback.tr,
                      onTap: () {
                        Get.toNamed(FeedbackPage.routeName);
                      },
                    ),
                    ProfileActionItemWidget(
                      img: termsIcon,
                      title: AppStaticStrings.termsAndCondition.tr,
                      onTap: () {
                        Get.toNamed(
                          TermsPolicyHelpPage.routeName,
                          arguments: AppStaticStrings.termsAndCondition.tr,
                        );
                      },
                    ),
                    ProfileActionItemWidget(
                      img: privacyIcon,
                      title: AppStaticStrings.privacyPolicy.tr,
                      onTap: () {
                        Get.toNamed(
                          TermsPolicyHelpPage.routeName,
                          arguments: AppStaticStrings.privacyPolicy.tr,
                        );
                      },
                    ),
                    // ProfileActionItemWidget(
                    //   img: helpIcon,
                    //   title: AppStaticStrings.helpSupport.tr,
                    //   onTap: () {
                    //     Get.toNamed(
                    //       TermsPolicyHelpPage.routeName,
                    //       arguments: AppStaticStrings.helpSupport.tr,
                    //     );
                    //   },
                    // ),
                    Obx(() {
                      return AccountInformationController
                              .to
                              .isLoadingLogout
                              .value
                          ? PaginationLoadingWidget()
                          : ProfileActionItemWidget(
                            img: logoutIcon,
                            title: AppStaticStrings.logOut.tr,
                            onTap: () {
                              AccountInformationController.to.logoutRequest();
                            },
                          );
                    }),
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

class languageChangeCardWidget extends StatelessWidget {
  final String name;
  final String language;
  final Function() onTap;
  const languageChangeCardWidget({
    super.key,
    required this.name,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ButtonTapWidget(
        onTap: onTap,
        child: Padding(
          padding: padding8,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: name),
              CustomText(text: language, style: poppinsSemiBold),
            ],
          ),
        ),
      ),
    );
  }
}
