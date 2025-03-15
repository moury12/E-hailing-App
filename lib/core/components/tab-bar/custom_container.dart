import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/color_constants.dart';

class CustomContainer extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? radius;
  final double? width;
  final Widget widget;
  final Function()? function;
  final EdgeInsets? padding;
  const CustomContainer({
    super.key,
    this.backgroundColor,
    this.radius,
    this.padding,
    required this.widget,
    this.width,
    this.borderColor,
    this.borderWidth,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 1,
        ),
        color: backgroundColor ?? AppColors.kPrimaryColor,
        borderRadius: BorderRadius.circular(radius ?? 50.w),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor:
              function != null
                  ? AppColors.kPrimaryColor
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(radius ?? 50.w),
          onTap: function,
          child: Padding(
            padding:
                padding ??
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: widget,
          ),
        ),
      ),
    );
  }
}
