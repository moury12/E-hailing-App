import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_text_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/auth/controllers/auth_controller.dart';
import 'package:e_hailing_app/presentations/auth/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/components/custom_checkbox_widget.dart';
import '../widgets/auth_scaffold_structure_widget.dart';
import '../widgets/auth_text_widgets.dart';
import '../widgets/social_media_auth_widget.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
       space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.welcomeBack),
        AuthSubTextWidget(text: AppStaticStrings.logInToContinue),
        space12H,
        CustomTextField(title: AppStaticStrings.email),
        CustomTextField(title: AppStaticStrings.password, isPassword: true),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CustomCheckBoxWidget(
                    isChecked: AuthController.to.isRememberMe,
                  ),
                  Expanded(
                    child: CustomText(
                      text: AppStaticStrings.rememberMe,
                      // fontSize: getFontSizeSmall(),
                    ),
                  ),
                ],
              ),
            ),

            CustomTextButton(title: AppStaticStrings.forgotPassword),
          ],
        ),
        SvgPicture.asset(orImage, width: ScreenUtil().screenWidth),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: AppStaticStrings.dontHaveAccount,
              style: poppinsRegular,
            ),
            CustomTextButton(
              onPressed: () {
                Get.toNamed(SignupPage.routeName);
              },
              title: AppStaticStrings.registerNow,
              fontSize: getFontSizeSemiSmall(),
              textColor: AppColors.kBlueAccentColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        CustomButton(onTap: () {}, title: AppStaticStrings.logIn),
        space12H,
        SocialMediaAuthWidget(),
      ],
    );
  }
}
