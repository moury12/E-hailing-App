import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_identity_page.dart';
import 'package:e_hailing_app/presentations/profile/model/user_profile_model.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/profile_card_item_widget.dart';

class ProfileInfoListWidget extends StatelessWidget {
  final UserProfileModel userModel;

  const ProfileInfoListWidget({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        ProfileCardItemWidget(
          title: AppStaticStrings.fullName,
          value: userModel.name ?? AppStaticStrings.noDataFound,
        ),
        ProfileCardItemWidget(
          title: AppStaticStrings.email,
          value: userModel.email ?? AppStaticStrings.noDataFound,
        ),
        ProfileCardItemWidget(
          title: AppStaticStrings.phoneNumber,
          value: userModel.phoneNumber ?? AppStaticStrings.noDataFound,
        ),
        ProfileCardItemWidget(
          title: AppStaticStrings.location,
          value: userModel.address ?? AppStaticStrings.noDataFound,
        ),
        CommonController.to.isDriver.value
            ? SizedBox.shrink()
            : CustomButton(
              title: AppStaticStrings.verifyYourIdentity,
              onTap: () {
                Get.toNamed(VerifyIdentityPage.routeName);
              },
            ),
      ],
    );
  }
}
