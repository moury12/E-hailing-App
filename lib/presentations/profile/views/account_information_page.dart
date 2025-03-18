import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/profile_card_item_widget.dart';

class AccountInformationPage extends StatelessWidget {
  static const String routeName = '/acc-info';
  const AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.profile),

      body: SingleChildScrollView(
        child: Padding(
          padding: padding14,
          child: Center(
            child: Column(
              spacing: 12.h,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomNetworkImage(
                  imageUrl: dummyProfileImage,
                  height: 100.w,
                  width: 100.w,
                  boxShape: BoxShape.circle,
                ),
                CustomText(
                  text: 'Robert Smith',
                  style: poppinsSemiBold,
                  fontSize: getFontSizeExtraLarge(),
                ),
                ProfileCardItemWidget(
                  title: AppStaticStrings.fullName,
                  value: 'Robert Smith',
                ),
                ProfileCardItemWidget(
                  title: AppStaticStrings.email,
                  value: 'robertsmith34@gmail.com',
                ), ProfileCardItemWidget(
                  title: AppStaticStrings.phoneNumber,
                  value: '+3489 9999 9778',
                ), ProfileCardItemWidget(
                  title: AppStaticStrings.location,
                  value: 'Juvenal Ridge, Port Vestach',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

