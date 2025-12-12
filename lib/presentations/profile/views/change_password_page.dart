import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String routeName = '/change-pass';

  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController reEnterNewPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    oldPassController.dispose();
    newPassController.dispose();
    reEnterNewPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.changePassword.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16,
          child: Form(
            key: formKey,
            child: Column(
              spacing: 12.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: AppStaticStrings.resetYourPassword.tr,
                  style: poppinsBold,
                  fontSize: getFontSizeExtraLarge(),
                ),
                CustomText(
                  text: AppStaticStrings.createAnewPassword.tr,
                  color: AppColors.kExtraLightTextColor,
                  style: poppinsLight,
                ),
                CustomTextField(
                  title: AppStaticStrings.oldPassword.tr,
                  isPassword: true,
                  textEditingController: oldPassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired.tr;
                    } else if (value.length < 6) {
                      return AppStaticStrings.passMustbe6.tr;
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  title: AppStaticStrings.newPassword.tr,
                  isPassword: true,
                  textEditingController: newPassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired.tr;
                    } else if (value.length < 6) {
                      return AppStaticStrings.passMustbe6.tr;
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  title: AppStaticStrings.reTypeNewPass.tr,
                  isPassword: true,
                  textEditingController: reEnterNewPassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired.tr;
                    } else if (value != newPassController.text) {
                      return AppStaticStrings.passNotMatch.tr;
                    }
                    return null;
                  },
                ),
                Obx(() {
                  return CustomButton(
                    isLoading:
                        AccountInformationController
                            .to
                            .isLoadingChangePass
                            .value,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        AccountInformationController.to.changePassRequest(
                          oldPass: oldPassController.text,
                          newPass: newPassController.text,
                          confirmPass: reEnterNewPassController.text,
                        );
                      }
                    },
                    title: AppStaticStrings.update.tr,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
