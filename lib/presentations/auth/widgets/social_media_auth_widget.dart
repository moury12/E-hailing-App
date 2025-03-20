import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
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
            IconButton(onPressed: () {
              Boxes.getUserRole().put(role,driver );
              CommonController.to.isDriver.value=true;
            }, icon: SvgPicture.asset(googleIcon)),
            IconButton(onPressed: () {
              Boxes.getUserRole().put(role,user );
              CommonController.to.isDriver.value=false;

            }, icon: SvgPicture.asset(appleIcon)),
          ],
        ),
      ],
    );
  }
}
