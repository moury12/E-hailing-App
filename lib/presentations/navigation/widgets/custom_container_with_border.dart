import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';

class CustomWhiteContainerWithBorder extends StatelessWidget {
  final String? text;
  final String? img;
  final Function()? onTap;
  final Widget? child;
  final TextAlign? textAlign;
  final Widget? cross;
  const CustomWhiteContainerWithBorder({
    super.key,
    this.text,
    this.img,
    this.child,
    this.onTap,
    this.cross,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: AppColors.kWhiteColor,
        border: Border.all(color: AppColors.kBorderColor, width: 0.5.w),
      ),
      child: ButtonTapWidget(
        radius: 24.r,
        onTap: onTap ?? () {},
        child: Padding(
          padding: padding8,
          child:
              child ??
              Row(
                spacing: 6.w,
                children: [
                  SvgPicture.asset(img ?? ''),
                  Expanded(
                    child: CustomText(
                      textAlign: textAlign ?? TextAlign.center,
                      text: text ?? '',
                      maxLines: 1,
                      color: AppColors.kLightBlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  cross ?? SizedBox.shrink(),
                ],
              ),
        ),
      ),
    );
  }
}
