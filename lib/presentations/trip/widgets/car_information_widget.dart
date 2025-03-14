import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CarInformationWidget extends StatelessWidget {
  final String title;
  final String value;
  const CarInformationWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          color: AppColors.kExtraLightBlackColor,
          fontSize: getFontSizeSemiSmall(),
        ),
        CustomText(
          text: value,
          style: poppinsBold,
          fontSize: getFontSizeSemiSmall(),
        ),
      ],
    );
  }
}
