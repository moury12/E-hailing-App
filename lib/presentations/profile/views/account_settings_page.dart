import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/profile/views/account_information_page.dart';
import 'package:e_hailing_app/presentations/profile/views/change_password_page.dart';
import 'package:e_hailing_app/presentations/profile/widgets/profile_action_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/constants/app_static_strings_constant.dart';

class AccountSettingsPage extends StatelessWidget {
  static const String routeName = '/acc-settings';
  const AccountSettingsPage({super.key});

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
            ],
          ),
        ),
      ),
    );
  }
}
