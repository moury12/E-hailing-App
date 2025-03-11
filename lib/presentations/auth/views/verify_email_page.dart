import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/presentations/auth/views/otp_page.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyEmailPage extends StatelessWidget {
  static const String routeName = '/verify-email';
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.verifyYourEmail),
        AuthSubTextWidget(text: AppStaticStrings.weWillSendACode),
        CustomTextField(title: AppStaticStrings.email),

        space4H,
        CustomButton(
          onTap: () {
            Get.toNamed(OtpPage.routeName);
          },
          title: AppStaticStrings.continueButton,
        ),
      ],
    );
  }
}
