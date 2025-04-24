import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/views/verify_identity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/profile_card_item_widget.dart';

class ProfileInfoListWidget extends StatelessWidget {
  const ProfileInfoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        ProfileCardItemWidget(title: AppStaticStrings.fullName, value: 'Robert Smith'),
        ProfileCardItemWidget(title: AppStaticStrings.email, value: 'robertsmith34@gmail.com'),
        ProfileCardItemWidget(title: AppStaticStrings.phoneNumber, value: '+3489 9999 9778'),
        ProfileCardItemWidget(title: AppStaticStrings.location, value: 'Juvenal Ridge, Port Vestach'),
        CustomButton(
          title: AppStaticStrings.verifyYourIdentity,
          onTap: () {
            Get.toNamed(VerifyIdentityPage.routeName);
          },
        ),
      ],
    );
  }
}
