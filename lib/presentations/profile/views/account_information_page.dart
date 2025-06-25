import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/views/edit_profile_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/profile_card_item_widget.dart';
import '../widgets/profile_info_list_widget.dart';

class AccountInformationPage extends StatelessWidget {
  static const String routeName = '/acc-info';

  const AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    AccountInformationController.to.tabContent.add(
      Obx(() {
        return ProfileInfoListWidget(
          userModel: CommonController.to.userModel.value,
        );
      }),
    );
    AccountInformationController.to.tabContent.add(
      Obx(() {
        return Column(
          spacing: 12.h,
          children: [
            ProfileCardItemWidget(
              title: AppStaticStrings.nationalIdPassport,
              value:
                  CommonController.to.userModel.value.idOrPassportNo ??
                  AppStaticStrings.noDataFound,
            ),
            ProfileCardItemWidget(
              title: AppStaticStrings.drivingLicense,
              value:
                  CommonController.to.userModel.value.drivingLicenseNo ??
                  AppStaticStrings.noDataFound,
            ),
            ProfileCardItemWidget(
              title: AppStaticStrings.licenseType,
              value:
                  CommonController.to.userModel.value.licenseType ??
                  AppStaticStrings.noDataFound,
            ),
            ProfileCardItemWidget(
              title: AppStaticStrings.licenseExpire,
              value:
                  CommonController.to.userModel.value.licenseExpiry ??
                  AppStaticStrings.noDataFound,
            ),
            // ProfileCardItemWidget(
            //   title: AppStaticStrings.evpNumber,
            //   value: CommonController.to.userModel.value. ??
            //       AppStaticStrings.noDataFound,
            // ),
            // ProfileCardItemWidget(
            //   title: AppStaticStrings.evpValidityPeriod,
            //   value: 'Juvenal Ridge, Port Vestach',
            // ),
          ],
        );
      }),
    );
    AccountInformationController.to.tabContent.add(
      SizedBox(
        width: ScreenUtil().screenWidth,
        child: Obx(() {
          return Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: AppStaticStrings.drivingLicense),
              CustomNetworkImage(
                isImagePreview: true,
                imageUrl:
                    "${ApiService().baseUrl}/${CommonController.to.userModel.value.drivingLicenseImage}",
                width: 150.w,
                height: 150.w,
              ),
              CustomText(text: AppStaticStrings.nationalIdPassport),
              CustomNetworkImage(
                isImagePreview: true,
                imageUrl:
                    "${ApiService().baseUrl}/${CommonController.to.userModel.value.idOrPassportImage}",
                width: 150.w,
                height: 150.w,
              ),
            ],
          );
        }),
      ),
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStaticStrings.profile,
        action: [
          IconButton(
            onPressed: () {
              Get.toNamed(EditProfilePage.routeName);
            },
            icon: Icon(
              Icons.edit_outlined,
              color: AppColors.kTextColor,
              size: 20.sp,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: padding14,
          child: Center(
            child: Column(
              spacing: 12.h,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return CustomNetworkImage(
                    imageUrl:
                        "${ApiService().baseUrl}/${CommonController.to.userModel.value.img}",
                    height: 100.w,
                    width: 100.w,
                    boxShape: BoxShape.circle,
                  );
                }),
                Obx(() {
                  return CustomText(
                    text:
                        CommonController.to.userModel.value.name ??
                        AppStaticStrings.noDataFound,
                    style: poppinsSemiBold,
                    fontSize: getFontSizeExtraLarge(),
                  );
                }),
                CommonController.to.isDriver.value
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // spacing: 6.w,
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star_rounded,
                            color: AppColors.kYellowColor,
                          ),
                        ),
                        CustomText(
                          text: '4.8',
                          style: poppinsSemiBold,
                          fontSize: getFontSizeSmall(),
                        ),
                        CustomText(
                          text: '(125 reviews)',
                          style: poppinsRegular,
                          fontSize: getFontSizeSmall(),
                          color: AppColors.kExtraLightTextColor,
                        ),
                      ],
                    )
                    : SizedBox.shrink(),
                CommonController.to.isDriver.value
                    ? DynamicTabWidget(
                      tabs: AccountInformationController.to.tabs,
                      tabContent: AccountInformationController.to.tabContent,
                    )
                    : Obx(() {
                      return ProfileInfoListWidget(
                        userModel: CommonController.to.userModel.value,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
