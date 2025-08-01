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

class ResetPasswordPage extends StatelessWidget {
  static const String routeName = '/reset-pass';

  ResetPasswordPage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
final arg = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.resetYourPassword),
        AuthSubTextWidget(text: AppStaticStrings.createAnewPassword),
        space6H,
        Form(
          key: formKey,
          child: Column(
            spacing: 8.h,
            children: [
              CustomTextField(
                textEditingController: AuthController.to.passNewController,
                title: AppStaticStrings.newPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.passRequired.tr;
                  } else if (value.length < 6) {
                    return AppStaticStrings.passMustbe6.tr;
                  }
                  return null;
                },
                isPassword: true,
              ),
              CustomTextField(
                title: AppStaticStrings.confirmNewPassword,
                textEditingController:
                    AuthController.to.confirmPassNewController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.passRequired.tr;
                  } else if (value !=
                      AuthController.to.passNewController.value.text) {
                    return AppStaticStrings.passNotMatch.tr;
                  }
                  return null;
                },
                isPassword: true,
              ),
            ],
          ),
        ),
        space4H,
        Obx(() {
          return CustomButton(
            isLoading:
                AuthController.to.loadingProcess.value ==
                AuthProcess.resetPassword,
            onTap: () {
              if (formKey.currentState!.validate()) {
                AuthController.to.resetPasswordRequest(email: arg);
              }
            },
            title: AppStaticStrings.confirm,
          );
        }),
      ],
    );
  }
}
