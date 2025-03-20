import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-statics/model/StaticModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/padding_constant.dart';class StaticsGridViewWidget extends StatelessWidget {
  const StaticsGridViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180.w,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.w,
      ),
      itemBuilder: (context, index) => StaticsCardItemWidget(static: staticList[index],),
      itemCount: staticList.length,
    );
  }
}

class StaticsCardItemWidget extends StatelessWidget {
  final StaticModel static;
  const StaticsCardItemWidget({super.key, required this.static});

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
            blurRadius: 6.r,
          ),
        ],
      ),
      child: Column(
        spacing: 8.h,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(static.img, height: 40.w),
          CustomText(text: static.title),
          CustomText(
            text: static.val,
            style: poppinsBold,
            color: AppColors.kPrimaryColor,
            fontSize: getFontSizeDefault(),
          ),
        ],
      ),
    );
  }
}