import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class PaymentCardItem extends StatelessWidget {
  final String img;
  final String title;
  final Function() onTap;
  const PaymentCardItem({
    super.key,
    required this.img,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: ButtonTapWidget(
        radius: 24.r,
        onTap: onTap,
        child: Padding(
          padding: paddingH16V8,
          child: Row(
            spacing: 12.w,
            children: [
              SvgPicture.asset(img),
              CustomText(text: title, color: AppColors.kTextBlueGreyColor),
            ],
          ),
        ),
      ),
    );
  }
}
