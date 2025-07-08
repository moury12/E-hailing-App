import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/color_constants.dart';

class CoinContainerWidget extends StatelessWidget {
  final String? coin;

  const CoinContainerWidget({super.key, this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kPrimaryExtraLightColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.kPrimaryColor),
      ),

      child: Padding(
        padding: paddingH16V6,
        child: Row(
          spacing: 12.w,
          children: [SvgPicture.asset(coinIcon), CustomText(text: coin ?? "0")],
        ),
      ),
    );
  }
}
