import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/color_constants.dart';
class CustomContainerWithElevation extends StatelessWidget {
  final Widget child;
  const CustomContainerWithElevation({
    super.key, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: padding12,
        decoration: BoxDecoration(
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: AppColors.kExtraLightTextColor.withValues(alpha: .6),
                blurRadius: 4.r,
                spreadRadius: -2
            ),
          ],
        ),
        child:child
    );
  }
}
