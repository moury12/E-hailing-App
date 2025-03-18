import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordPage extends StatelessWidget {
  static const String routeName = '/change-pass';
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.changePassword),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16,
          child: Column(
            spacing: 12.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppStaticStrings.resetYourPassword,
                style: poppinsBold,
                fontSize: getFontSizeExtraLarge(),
              ),
              CustomText(
                text: AppStaticStrings.createAnewPassword,
                color: AppColors.kExtraLightTextColor,
                style: poppinsLight,
              ),
              CustomTextField(
                title: AppStaticStrings.oldPassword,
                isPassword: true,
              ),
              CustomTextField(
                title: AppStaticStrings.newPassword,
                isPassword: true,
              ),
              CustomTextField(
                title: AppStaticStrings.reTypeNewPass,
                isPassword: true,
              ),
              CustomButton(onTap: () {}, title: AppStaticStrings.update),
            ],
          ),
        ),
      ),
    );
  }
}
