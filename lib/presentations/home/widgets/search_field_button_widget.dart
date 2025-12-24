import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchFieldButtonWidget extends StatelessWidget {
  final Function()? onTap;
  const SearchFieldButtonWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      borderColor: Colors.transparent,
      fillColor: AppColors.kWhiteColor,
      borderRadius: 24.r,
      hintText: 'Where to go?',
      isEnable: false,
      onTap: onTap ?? () {},
      prefixIcon: Padding(
        padding: padding16,
        child: SvgPicture.asset(searchIcon, height: 16.w),
      ),
    );
  }
}
