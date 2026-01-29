import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FeedbackContentWidget extends StatelessWidget {
  final String title;
  final String img;
  final Function() onTap;
  const FeedbackContentWidget({
    super.key,
    required this.title,
    required this.img,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.kWhiteColor,
      ),

      margin: padding12H.copyWith(bottom: 12.w),
      child: ButtonTapWidget(
        onTap: onTap,
        child: Padding(
          padding: padding12,
          child: Row(
            children: [
              SvgPicture.asset(img),
              space12W,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: title),
                    CustomText(
                      text: AppStaticStrings.helpServiceAvailable.tr,
                      fontSize: getFontSizeSmall(),
                      color: AppColors.kLightBlackColor,
                      style: poppinsRegular,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
