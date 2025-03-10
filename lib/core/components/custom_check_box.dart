import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  const CustomCheckbox(
      {super.key, required this.isChecked, required this.onChanged});

  // bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isChecked);
      },
      child: Container(
        width: 18.w,
        alignment: Alignment.center,
        height: 18.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.kLightTextColor, width: 2.w),
          borderRadius: BorderRadius.circular(2.r),
        ),
        child: isChecked
            ? Icon(CupertinoIcons.checkmark_alt,
                color: isChecked ? AppColors.kLightTextColor : Colors.white,
                size: 16.w)
            : null,
      ),
    );
  }
}
