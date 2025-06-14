import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/color_constants.dart';
import '../constants/custom_space.dart';
import '../constants/fontsize_constant.dart';
import '../constants/padding_constant.dart';
import '../constants/text_style_constant.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height,
    this.width = double.maxFinite,
    required this.onTap,
    this.title = '',
    this.marginVerticel = 0,
    this.marginHorizontal = 0,
    this.fillColor,
    this.textColor = AppColors.kWhiteColor,
    this.borderColor = AppColors.kPrimaryColor,
    this.child,
    this.img,
    this.icon,
    this.fontSize,
    this.radius,
    this.isLoading = false,
    this.padding,
  });

  final double? height;
  final double? radius;
  final double? width;
  final Color? fillColor;
  final Color borderColor;
  final bool? isLoading;

  final Color textColor;

  final VoidCallback onTap;

  final String title;
  final Widget? child;
  final String? img;
  final IconData? icon;
  final EdgeInsets? padding;

  final double marginVerticel;
  final double? fontSize;
  final double marginHorizontal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isLoading == true
              ? () {}
              : () {
                onTap();
              },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: marginVerticel,
          horizontal: marginHorizontal,
        ),
        alignment: Alignment.center,
        height: height,
        padding: padding ?? padding12,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(radius ?? 24.r),
          color: fillColor ?? AppColors.kPrimaryColor,
        ),
        child:
            isLoading == true
                ? const DefaultProgressIndicator(strokeWidth: 2)
                : child ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          title,
                          style: poppinsSemiBold.copyWith(
                            color: textColor,
                            fontSize: fontSize ?? getFontSizeSemiSmall(),
                          ),
                        ),
                        icon != null || img != null
                            ? space8W
                            : const SizedBox.shrink(),
                        img != null
                            ? SvgPicture.asset(
                              img ?? '',
                              height: 24.w,
                              width: 24.w,
                              // color: AppColors.kBlackColor,
                            )
                            : icon != null
                            ? Icon(icon, size: 24.sp)
                            : const SizedBox.shrink(),
                      ],
                    ),
      ),
    );
  }
}

class DefaultProgressIndicator extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;

  const DefaultProgressIndicator({super.key, this.color, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15.w,
      width: 15.w,
      child: CircularProgressIndicator(
        color: color ?? AppColors.kWhiteColor,
        strokeWidth: strokeWidth ?? 2,
      ),
    );
  }
}
