import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientProgressIndicator extends StatelessWidget {
  const GradientProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return
         CircularProgressIndicator(
          strokeWidth: 14.w,
          color: AppColors.kPrimaryColor,
          strokeCap: StrokeCap.round,
          backgroundColor: Colors.transparent, // Optional background color


    );
  }
}