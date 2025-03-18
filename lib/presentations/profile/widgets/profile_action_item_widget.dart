import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ProfileActionItemWidget extends StatelessWidget {
  final String img;
  final String title;
  final Function() onTap;
  const ProfileActionItemWidget({super.key, required this.img, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.kWhiteColor,
        boxShadow: [
          BoxShadow(color: AppColors.kExtraLightGreyTextColor.withValues(alpha: .3), blurRadius: 6.r),
        ],
      ),
      child: ButtonTapWidget(
        onTap: onTap,
        radius: 16.w,
        child: Padding(
          padding: padding14,
          child: Row(
            spacing: 16.w,
            children: [
              SvgPicture.asset(img, height: 18.w),
              CustomText(text: title),
              Spacer(),
              SvgPicture.asset(arrowForwardIcon)
            ],
          ),
        ),
      ),
    );
  }
}