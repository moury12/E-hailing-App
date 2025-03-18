import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/views/saved_location_page.dart';
import 'package:e_hailing_app/presentations/navigation/controllers/navigation_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/image_constant.dart';
import '../widgets/profile_action_item_widget.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
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
                padding: padding12,
                child: Row(
                  spacing: 12.w,
                  children: [
                    CustomNetworkImage(
                      imageUrl: dummyProfileImage,
                      height: 70.w,
                      width: 70.w,
                      boxShape: BoxShape.circle,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'your name',
                            fontSize: getFontSizeDefault(),
                            color: AppColors.kTextDarkBlueColor,
                          ),
                          CustomText(
                            text: 'yourname@gmail.com',
                            fontSize: getFontSizeSmall(),
                            color: AppColors.kExtraLightTextColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                    onTap: () {},
                  ),
                  ProfileActionItemWidget(
                    img: coinIcon,
                    title: AppStaticStrings.duduCoinWallet,
                    onTap: () {},
                  ),
                  ProfileActionItemWidget(
                    img: notificationProfileIcon,
                    title: AppStaticStrings.notification,
                    onTap: () {},
                  ), ProfileActionItemWidget(
                    img: savedLocationIcon,
                    title: AppStaticStrings.savedLocation,
                    onTap: () {
                      Get.toNamed(SavedLocationPage.routeName);
                    },
                  ),
                  CustomText(text: AppStaticStrings.more,fontSize: getFontSizeDefault(),),
                  ProfileActionItemWidget(
                    img: termsIcon,
                    title: AppStaticStrings.termsAndCondition,
                    onTap: () {},
                  ),ProfileActionItemWidget(
                    img: privacyIcon,
                    title: AppStaticStrings.privacyPolicy,
                    onTap: () {},
                  ),ProfileActionItemWidget(
                    img: helpIcon,
                    title: AppStaticStrings.helpSupport,
                    onTap: () {},
                  ),ProfileActionItemWidget(
                    img: logoutIcon,
                    title: AppStaticStrings.logOut,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
