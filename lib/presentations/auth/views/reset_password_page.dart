import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordPage extends StatelessWidget {
  static const String routeName = '/reset-pass';
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.resetYourPassword),
        AuthSubTextWidget(text: AppStaticStrings.createAnewPassword),
        space6H,
        CustomTextField(title: AppStaticStrings.newPassword, isPassword: true),
        CustomTextField(
          title: AppStaticStrings.confirmNewPassword,
          isPassword: true,
        ),
        space4H,
        CustomButton(
          onTap: () {
            Get.offAllNamed(LoginPage.routeName);
          },
          title: AppStaticStrings.confirm,
        ),
      ],
    );
  }
}
