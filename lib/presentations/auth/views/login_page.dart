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
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/presentations/auth/controllers/auth_controller.dart';
import 'package:e_hailing_app/presentations/auth/views/signup_page.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_email_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_checkbox_widget.dart';
import '../widgets/auth_scaffold_structure_widget.dart';
import '../widgets/auth_text_widgets.dart';
import '../widgets/social_media_auth_widget.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    /*WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => ,
    )*/
    Future.delayed(Duration(seconds: 1), () {
      return showCredentialsDialog();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      space: 6.h,
      children: [
        AuthTitleTextWidget(title: AppStaticStrings.welcomeBack.tr),
        AuthSubTextWidget(text: AppStaticStrings.logInToContinue.tr),
        space12H,

        Form(
          key: formKey,
          child: Column(
            spacing: 6.h,
            children: [
              CustomTextField(
                title: AppStaticStrings.email.tr,
                isRequired: true,

                textEditingController: AuthController.to.emailLoginController,
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
                title: AppStaticStrings.password.tr,
                isPassword: true,
                textEditingController: AuthController.to.passLoginController,
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
            ],
          ),
        ),
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
                      text: AppStaticStrings.rememberMe.tr,
                      // fontSize: getFontSizeSmall(),
                    ),
                  ),
                ],
              ),
            ),

            CustomTextButton(
              title: AppStaticStrings.forgotPassword.tr,
              onPressed: () {
                Get.toNamed(VerifyEmailPage.routeName);
              },
            ),
          ],
        ),
        SvgPicture.asset(orImage, width: ScreenUtil().screenWidth),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: AppStaticStrings.dontHaveAccount.tr,
              style: poppinsRegular,
            ),
            CustomTextButton(
              onPressed: () {
                Get.toNamed(SignupPage.routeName);
              },
              title: AppStaticStrings.registerNow.tr,
              fontSize: getFontSizeSemiSmall(),
              textColor: AppColors.kBlueAccentColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        Obx(() {
          return CustomButton(
            isLoading:
                AuthController.to.loadingProcess.value == AuthProcess.login,
            onTap: () {
              if (formKey.currentState!.validate()) {
                AuthController.to.signInRequest();
              }
            },
            title: AppStaticStrings.logIn.tr,
          );
        }),
        space12H,
        SocialMediaAuthWidget(),

        // CustomButton(
        //   onTap: () {
        //     Fluttertoast.showToast(msg: "msg",);
        //   },
        //   title: 'Go to Home',
        // ),
      ],
    );
  }
}
