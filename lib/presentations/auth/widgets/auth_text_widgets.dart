import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
class AuthSubTextWidget extends StatelessWidget {
  final String text;
  const AuthSubTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      style: poppinsLight,
      color: AppColors.kTextBlueGreyColor,
    );
  }
}

class AuthTitleTextWidget extends StatelessWidget {
  final String title;
  const AuthTitleTextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: title,
      style: poppinsBold,
      fontSize: getFontSizeExtraLarge(),
    );
  }
}