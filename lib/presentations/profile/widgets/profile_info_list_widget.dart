import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/model/user_profile_model.dart';
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
        Container(
            padding: padding12,
           decoration: BoxDecoration(color: AppColors.kPrimaryLightColor,borderRadius: BorderRadius.circular(8)),
            child: CustomText(text: "${userModel.name} ${AppStaticStrings.referedBy.tr} ${userModel.referredBy}",style: poppinsSemiBold,color: AppColors.kPrimaryColor,)),
        ProfileCardItemWidget(
          title: AppStaticStrings.fullName.tr,
          value: userModel.name ?? AppStaticStrings.noDataFound.tr,
        ),
        ProfileCardItemWidget(
          title: AppStaticStrings.email.tr,
          value: userModel.email ?? AppStaticStrings.noDataFound.tr,
        ),
        ProfileCardItemWidget(
          title: AppStaticStrings.phoneNumber.tr,
          value: userModel.phoneNumber ?? AppStaticStrings.noDataFound.tr,
        ),
        ProfileCardItemWidget(
          title: AppStaticStrings.location.tr,
          value: userModel.address ?? AppStaticStrings.noDataFound.tr,
        ), ProfileCardItemWidget(
          title: AppStaticStrings.yourReferalCode.tr,
          value: userModel.referralCode ?? AppStaticStrings.noDataFound.tr,
        ),

      ],
    );
  }
}
