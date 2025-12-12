import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/account_information_controller.dart';

class PenaltyPage extends StatelessWidget {
  static const String routeName = "/penalty";

  const PenaltyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.pendingPenalty.tr),
      body: Container(
        margin: paddingH12V8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.kWhiteColor,
        ),
        width: double.infinity,
        padding: padding12,
        child: Column(
          spacing: 6.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "RM",
              style: poppinsSemiBold,
              fontSize: getFontSizeExtraLarge(),
            ),
            Obx(() {
              return CustomText(
                text: (AccountInformationController.to.userModel.value.coins??0).toString(),
                style: poppinsBold,
                color: AppColors.kPrimaryColor,
                fontSize: getButtonFontSizeLarge(),
              );
            }),
            Divider(color: Colors.black, height: 2, thickness: .5),
            Row(
              spacing: 12.w,
              children: [
                SvgPicture.asset(penaltyPolicyIcon),
                CustomText(
                  text: AppStaticStrings.penaltyPolicy.tr,
                  style: poppinsSemiBold,
                ),
              ],
            ),
            Divider(color: Colors.black, height: 2, thickness: .5),
            CustomText(
              text:AppStaticStrings.pelantyMessage.tr
            ),
          ],
        ),
      ),
    );
  }
}
