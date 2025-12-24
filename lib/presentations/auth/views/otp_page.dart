import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/controllers/auth_controller.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_text_widgets.dart';
import 'package:e_hailing_app/presentations/auth/widgets/otp_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtpPage extends StatefulWidget {
  static const String routeName = '/otp';

  OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  void initState() {
    AuthController.to.clearOtp();
    super.initState();
  }

  final arg = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.sixDigitCode.tr),
        AuthSubTextWidget(text: AppStaticStrings.enterCodeSent.tr),
        space6H,
        OtpTextField(),
        space4H,
        Obx(() {
          return CustomButton(
            isLoading:
                AuthController.to.loadingProcess.value ==
                AuthProcess.activateAccount,
            onTap: () {
              // Get.toNamed(ResetPasswordPage.routeName);
              if (arg == verifyEmail) {
                AuthController.to.verifyEmailRequest(
                  email: AuthController.to.emailSignUpController.value.text,
                  isAccVerify: true,
                );
              } else {
                AuthController.to.verifyEmailRequest(
                  email: AuthController.to.emailForgetController.value.text,
                  isAccVerify: false,
                );
              }
            },
            title: AppStaticStrings.confirm.tr,
          );
        }),
      ],
    );
  }
}
