import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_checkbox_widget.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/presentations/auth/controllers/auth_controller.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:e_hailing_app/presentations/auth/widgets/auth_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class SignupPage extends StatefulWidget {
  static const String routeName = '/signin';

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.createYourAccount.tr),
        AuthSubTextWidget(text: AppStaticStrings.signUpToGetStarted.tr),
        Form(
          key: formKey,
          child: Column(
            spacing: 8.h,
            children: [
              CustomTextField(
                textEditingController: AuthController.to.nameSignUpController,
                title: AppStaticStrings.fullName.tr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.fullNameRequired.tr;
                  }
                  return null;
                },
                isRequired: true,
              ),
              CustomTextField(
                title: AppStaticStrings.email.tr,
                isRequired: true,

                textEditingController:
                AuthController.to.emailSignUpController.value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.emailRequired.tr;
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppStaticStrings.enterValidEmail.tr;
                  }
                  return null;
                },
              ),
              CustomTextField(
                title: AppStaticStrings.phoneNumber.tr,
                keyboardType: TextInputType.number,
                textEditingController: AuthController.to.phoneSignUpController,
                isRequired: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.phoneRequired.tr;
                  } else if (value.length < 8) {
                    return AppStaticStrings.phoneMustbe11.tr;
                  }

                  return null;
                },
              ),

              CustomTextField(
                title: AppStaticStrings.password.tr,
                isPassword: true,
                textEditingController: AuthController.to.passSignUpController,
                isRequired: true,
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
                title: AppStaticStrings.confirmPassword.tr,
                isPassword: true,
                textEditingController:
                AuthController.to.confirmPassSignUpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.passRequired.tr;
                  } else if (value !=
                      AuthController.to.passSignUpController.value.text) {
                    return AppStaticStrings.passNotMatch.tr;
                  }
                  return null;
                },
                isRequired: true,
              ),
            ],
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckBoxWidget(
              isChecked: AuthController.to.isPrivacyPolicyChecked,
            ),
            space6W,
            Expanded(
              child: ButtonTapWidget(
                onTap: () {
                  launchWebsite("https://duducar.co/privacy-policy");
                },
                child: CustomText(
                  text: AppStaticStrings.duduPrivacyPolicy.tr,
                  color: AppColors.kPrimaryColor,
decoration: TextDecoration.underline,
                  // fontSize: getFontSizeSmall(),
                ),
              ),
            ),
          ],
        ),
        SvgPicture.asset(orImage, width: ScreenUtil().screenWidth),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: AppStaticStrings.alreadyHaveAccount.tr,
              style: poppinsRegular,
            ),
            CustomTextButton(
              onPressed: () {
                Get.toNamed(LoginPage.routeName);
              },
              title: AppStaticStrings.logIn.tr,
              fontSize: getFontSizeSemiSmall(),
              textColor: AppColors.kBlueAccentColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        Obx(() {
          return CustomButton(
            isLoading:
            AuthController.to.loadingProcess.value == AuthProcess.signUp,
            onTap: () {
              if (formKey.currentState!.validate()) {
              if(AuthController.to.isPrivacyPolicyChecked.value){
                AuthController.to.signUpRequest();
              }else{
                showCustomSnackbar(title: "Failed", message: "Please agree to DUDU Terms and Conditions and Policy.",type: SnackBarType.alert);
              }
              }
              // Get.toNamed(VerifyEmailPage.routeName);
            },
            title: AppStaticStrings.createAccount.tr,
          );
        }),
        space12H,
        SocialMediaAuthWidget(),
      ],
    );
  }
}
