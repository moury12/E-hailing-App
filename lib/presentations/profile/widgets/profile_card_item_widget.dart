import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/color_constants.dart';
class ProfileCardItemWidget extends StatelessWidget {
  final String title;
  final String value;
  const ProfileCardItemWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24.r),
      color: AppColors.kWhiteColor,
      boxShadow: [
        BoxShadow(
          color: AppColors.kExtraLightGreyTextColor.withValues(alpha: .3),
          blurRadius: 6.r,
        ),
      ],
    ),
      child: Padding(
        padding: padding12,
        child: Row(
          spacing: 12.w,
          children: [
            CustomText(text: title),
            Expanded(
              child: CustomText(
                text: value,
                textAlign: TextAlign.end,
                color: AppColors.kExtraLightTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
