import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_email_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_identity_page.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text_button.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_space.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/image_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../widgets/social_media_auth_widget.dart';

class SignupPage extends StatelessWidget {
  static const String routeName = '/signin';
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.createYourAccount),
        AuthSubTextWidget(text: AppStaticStrings.signUpToGetStarted),
        CustomTextField(title: AppStaticStrings.fullName),
        CustomTextField(title: AppStaticStrings.email),
        CustomTextField(
          title: AppStaticStrings.phoneNumber,
          keyboardType: TextInputType.number,
        ),
        CustomTextField(
          title: AppStaticStrings.emergencyContactNumber,
          keyboardType: TextInputType.number,
        ),
        CustomTextField(title: AppStaticStrings.password, isPassword: true),
        CustomTextField(
          title: AppStaticStrings.confirmPassword,
          isPassword: true,
        ),
        SvgPicture.asset(orImage, width: ScreenUtil().screenWidth),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: AppStaticStrings.alreadyHaveAccount,
              style: poppinsRegular,
            ),
            CustomTextButton(
              onPressed: () {
                Get.toNamed(LoginPage.routeName);
              },
              title: AppStaticStrings.logIn,
              fontSize: getFontSizeSemiSmall(),
              textColor: AppColors.kBlueAccentColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        CustomButton(onTap: () {
          Get.toNamed(VerifyEmailPage.routeName);
        }, title: AppStaticStrings.createAccount),
        space12H,
        SocialMediaAuthWidget(),
      ],
    );
  }
}
