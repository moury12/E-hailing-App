import 'package:e_hailing_app/core/components/custom_text_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RowMoreButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final String title;
  const RowMoreButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: title),
        CustomTextButton(
          onPressed: onPressed,
          title: AppStaticStrings.more,
          textColor: AppColors.kPrimaryColor,
          fontSize: getFontSizeSemiSmall(),
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
