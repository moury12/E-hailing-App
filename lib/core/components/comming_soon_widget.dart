import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(text: AppStaticStrings.featureComingSoon, style: poppinsBold),
          CustomText(
            textAlign: TextAlign.center,
            text:AppStaticStrings.featureNotImplemented
            ,

            style: poppinsRegular,
            color: AppColors.kExtraLightTextColor,
          ),
        ],
      ),
    );
  }
}
