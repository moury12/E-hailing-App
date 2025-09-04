import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/auth/views/login_page.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/model/user_profile_model.dart';
import 'package:e_hailing_app/presentations/profile/views/account_information_page.dart';
import 'package:e_hailing_app/presentations/profile/views/change_password_page.dart';
import 'package:e_hailing_app/presentations/profile/widgets/profile_action_item_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/custom_space.dart';

class AccountSettingsPage extends StatefulWidget {
  static const String routeName = '/acc-settings';

  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.accountSetting),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding14.copyWith(top: 0),
          child: Column(
            spacing: 12.h,
            children: [
              ProfileActionItemWidget(
                img: profileIcon,
                title: AppStaticStrings.accountInformation,
                onTap: () => Get.toNamed(AccountInformationPage.routeName),
              ),
              ProfileActionItemWidget(
                img: changePassIcon,
                title: AppStaticStrings.changePassword,
                onTap: () => Get.toNamed(ChangePasswordPage.routeName),
              ),
              Obx(() {
                return  CommonController.to.isDriver.value ? SizedBox.shrink() :ProfileActionItemWidget(
                  img: deleteAccountIcon,
                  title: AppStaticStrings.deleteAcc,
                  onTap:
                      () =>
                      showDialog(
                        context: context,
                        builder:
                            (context) =>
                            AlertDialog(
                              content: SizedBox(
                                width: Get.width * .8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    CustomText(
                                      text:
                                      AppStaticStrings
                                          .areYouSureYouWantToDelete,
                                      textAlign: TextAlign.center,
                                    ),
                                    space8H,
                                    AccountInformationController.to.userModel.value.authId?.provider== "local"?  Form(
                                      key: formKey,
                                      child:
                                      CustomTextField(
                                        textEditingController: passController,

                                        title: AppStaticStrings.password,
                                        isPassword: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return AppStaticStrings
                                                .passRequired;
                                          }
                                          return null;
                                        },
                                      ),

                                    ):SizedBox.shrink(),
                                    space8H,
                                    Row(
                                      spacing: 8.w,
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            textColor: AppColors.kPrimaryColor,
                                            fillColor: Colors.transparent,
                                            onTap: () => Get.back(),
                                            title: AppStaticStrings.cancel,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomButton(
                                            onTap: () {
                                              if(AccountInformationController.to.userModel.value.authId?.provider== "local"){
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  AccountInformationController
                                                      .to
                                                      .deleteAccRequest(
                                                      password: passController
                                                          .text);
                                                }
                                              }else{
                                                AccountInformationController
                                                    .to
                                                    .deleteAccRequest(
                                                    password: "ghghghf");
                                              }
                                            },
                                            title: AppStaticStrings.delete,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
