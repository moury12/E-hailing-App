import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_constants.dart';

class PaginationLoadingWidget extends StatelessWidget {
  final Color? color;
  const PaginationLoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding12,
        child: SizedBox(
          height: 10.w,
          width: 10.w,
          child: CircularProgressIndicator(
            color:color?? AppColors.kPrimaryColor,
            strokeWidth: 2.sp,
          ),
        ),
      ),
    );
  }
}
