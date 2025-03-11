import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialMediaAuthWidget extends StatelessWidget {
  const SocialMediaAuthWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CustomText(
            textAlign: TextAlign.center,
            text: AppStaticStrings.orContinueWith,
            style: poppinsSemiBold,
            color: AppColors.kTextDarkBlueColor,
          ),
        ),
        space6H,
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: SvgPicture.asset(googleIcon)),
            IconButton(onPressed: () {}, icon: SvgPicture.asset(appleIcon)),
          ],
        ),
      ],
    );
  }
}
