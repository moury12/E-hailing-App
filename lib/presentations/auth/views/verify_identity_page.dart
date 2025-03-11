import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_email_page.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VerifyIdentityPage extends StatelessWidget {
  static const String routeName = '/verify_identity';
  const VerifyIdentityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.verifyYourIdentity),
        CustomTextField(
          title: AppStaticStrings.nricPassport,
          keyboardType: TextInputType.number,
        ),
        space4H,
        CustomText(
          text: AppStaticStrings.uploadNricPassport,
          style: poppinsMedium,
          fontSize: getFontSizeSemiSmall(),
        ),
        CustomButton(
          onTap: () {},
          radius: 4.r,
          fillColor: AppColors.kLightBlueColor,
          child: Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(uploadIcon),
              CustomText(text: AppStaticStrings.uploadImage),
            ],
          ),
        ),
        space4H,
        CustomButton(
          onTap: () {
            Get.toNamed(VerifyEmailPage.routeName);
          },
          title: AppStaticStrings.confirm,
        ),
      ],
    );
  }
}
