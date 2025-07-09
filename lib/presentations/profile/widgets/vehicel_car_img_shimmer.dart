import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget buildVehicelImageShimmerRow() {
  return Shimmer.fromColors(
    baseColor: AppColors.kPrimaryLightColor, // kPrimaryLightColor
    highlightColor: AppColors.kPrimaryColor, // kPrimaryColor with opacity
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        5,
        (index) => Container(
          margin: EdgeInsets.only(right: 8.w),
          height: 110.w,
          width: 110.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    ),
  );
}
