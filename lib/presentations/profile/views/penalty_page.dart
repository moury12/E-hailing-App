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
      appBar: CustomAppBar(title: AppStaticStrings.pendingPenalty),
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
                  text: AppStaticStrings.penaltyPolicy,
                  style: poppinsSemiBold,
                ),
              ],
            ),
            Divider(color: Colors.black, height: 2, thickness: .5),
            CustomText(
              text:
                  "To ensure fairness for all users, Alygo maintains a simple penalty system. Passengers who cancel rides after a driver has accepted may face a ৳30 penalty if this occurs more than three times in a week. If a passenger fails to show up at the pickup location, a minimum fare may still apply. Drivers who cancel after accepting a ride request will see an impact on their rating, and repeated violations could result in temporary suspension. Fake or spam bookings will lead to immediate account action. Additionally, consistent delays by either party may reduce their profile visibility on the platform.",
            ),
          ],
        ),
      ),
    );
  }
}
