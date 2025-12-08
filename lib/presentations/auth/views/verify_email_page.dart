import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/presentations/auth/controllers/auth_controller.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyEmailPage extends StatelessWidget {
  static const String routeName = '/verify-email';

  VerifyEmailPage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.verifyYourEmail.tr),
        AuthSubTextWidget(text: AppStaticStrings.weWillSendACode.tr),
        Form(
          key: formKey,
          child: CustomTextField(
            title: AppStaticStrings.email.tr,
            textEditingController:
                AuthController.to.emailForgetController.value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStaticStrings.emailRequired.tr;
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return AppStaticStrings.enterValidEmail.tr;
              }
              return null;
            },
          ),
        ),

        space4H,
        Obx(() {
          return CustomButton(
            isLoading:
                AuthController.to.loadingProcess.value ==
                AuthProcess.forgetPassword,
            onTap: () {
              if (formKey.currentState!.validate()) {
                AuthController.to.forgetPasswordRequest(
                  email: AuthController.to.emailForgetController.value.text,
                );
              }
            },
            title: AppStaticStrings.continueButton.tr,
          );
        }),
      ],
    );
  }
}
