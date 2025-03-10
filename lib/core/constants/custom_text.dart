import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style; // Allows full dynamic styling
  final Color? color; // Overrides for individual style properties
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      /*overflow: overflow ?? TextOverflow.ellipsis,*/
      style: style?.copyWith(
            color: color ?? style?.color,
            fontSize: fontSize ?? style?.fontSize,
            fontWeight: fontWeight ?? style?.fontWeight,
          ) ??
          TextStyle(
            color: color ?? AppColors.kTextColor,
            fontSize: fontSize ?? getFontSizeSemiSmall(),
            fontFamily: 'Poppins',
            fontWeight: fontWeight??FontWeight.w500,
          ),
    );
  }
}
