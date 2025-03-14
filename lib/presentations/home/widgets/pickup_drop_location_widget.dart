import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/components/custom_timeline.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
class PickupDropLocationWidget extends StatelessWidget {
  const PickupDropLocationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTimeline(
      padding: EdgeInsets.zero,
      indicators: <Widget>[
        SvgPicture.asset(pickLocationIcon),
        SvgPicture.asset(dropLocationIcon),
      ],
      children: <Widget>[
        CustomTextField(
          borderRadius: 24.r,
          hintText: AppStaticStrings.pickupLocation,
          fillColor: AppColors.kWhiteColor,
          borderColor: AppColors.kGreyColor,
          height: 38.h,
          suffixIcon: Padding(
            padding: padding8,
            child: SvgPicture.asset(crossCircleIcon),
          ),
        ),
        CustomTextField(
          borderRadius: 24.r,
          hintText: AppStaticStrings.dropLocation,
          fillColor: AppColors.kWhiteColor,
          borderColor: AppColors.kGreyColor,
          height: 38.h,
          suffixIcon: Padding(
            padding: padding8,
            child: SvgPicture.asset(crossCircleIcon),
          ),
        ),
      ],
    );
  }
}
