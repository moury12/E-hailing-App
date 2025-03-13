import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectCarITemWidget extends StatelessWidget {
  final Function()? onTap;
  final Color? fillColor;
  final Color? borderColor;
  const SelectCarITemWidget({
    super.key,
    this.onTap,
    this.fillColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor ?? AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor ?? AppColors.kWhiteColor),
      ),
      child: ButtonTapWidget(
        onTap: onTap,
        radius: 16.r,
        child: Padding(
          padding: padding8,
          child: Row(
            spacing: 12.w,
            children: [
              Image.asset(purpleCarImage, height: 45.w),
              Column(
                children: [
                  CustomText(text: 'Sedan', style: poppinsSemiBold),
                  CustomText(text: '4 seat', style: poppinsRegular),
                ],
              ),
              Spacer(),
              CustomText(text: 'RM 150'),
            ],
          ),
        ),
      ),
    );
  }
}
