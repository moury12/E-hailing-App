import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerSavedLocationItem() {
  return Shimmer.fromColors(
    baseColor: AppColors.kPrimaryExtraLightColor,
    highlightColor: AppColors.kPrimaryLightColor,
    child: Container(
      margin: padding8.copyWith(top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.kWhiteColor,
        border: Border.all(color: AppColors.kPrimaryColor, width: 1.w),
      ),
      child: Padding(
        padding: padding8,
        child: Row(
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 120, color: Colors.white),
                  SizedBox(height: 4),
                  Container(height: 10, width: 180, color: Colors.white),
                ],
              ),
            ),
            const Spacer(),
            Icon(CupertinoIcons.delete, color: Colors.white, size: 20.sp),
          ],
        ),
      ),
    ),
  );
}
