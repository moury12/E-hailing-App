import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/tab-bar/dynamic_tab_widget.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/profile_card_item_widget.dart';
import '../widgets/profile_info_list_widget.dart';

class AccountInformationPage extends StatelessWidget {
  static const String routeName = '/acc-info';
  const AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    AccountInformationController.to.tabContent.add(ProfileInfoListWidget());
    AccountInformationController.to.tabContent.add(Column(  spacing: 12.h,
      children: [
        ProfileCardItemWidget(
          title: AppStaticStrings.nationalIdPassport,
          value: 'Robert Smith',
        ),
        ProfileCardItemWidget(
          title: AppStaticStrings.drivingLicense,
          value: 'robertsmith34@gmail.com',
        ),
        ProfileCardItemWidget(
          title: AppStaticStrings.licenseType,
          value: '+3489 9999 9778',
        ), ProfileCardItemWidget(
          title: AppStaticStrings.licenseExpire,
          value: 'Juvenal Ridge, Port Vestach',
        ),ProfileCardItemWidget(
          title: AppStaticStrings.evpNumber,
          value: 'Juvenal Ridge, Port Vestach',
        ),ProfileCardItemWidget(
          title: AppStaticStrings.evpValidityPeriod,
          value: 'Juvenal Ridge, Port Vestach',
        ),
      ],
    ));
    AccountInformationController.to.tabContent.add(
      SizedBox(
        width: ScreenUtil().screenWidth,
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: AppStaticStrings.nationalIdPassport),
            CustomNetworkImage(imageUrl: dummyProfileImage,width: 60.w,height: 60.w,),
            CustomText(text: AppStaticStrings.nationalIdPassport),
            CustomNetworkImage(imageUrl: dummyProfileImage,width: 60.w,height: 60.w,),

          ],
        ),
      )
    );
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
                CommonController.to.isDriver.value
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // spacing: 6.w,
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star_rounded,
                            color: AppColors.kYellowColor,
                          ),
                        ),
                        CustomText(
                          text: '4.8',
                          style: poppinsSemiBold,
                          fontSize: getFontSizeSmall(),
                        ),
                        CustomText(
                          text: '(125 reviews)',
                          style: poppinsRegular,
                          fontSize: getFontSizeSmall(),
                          color: AppColors.kExtraLightTextColor,
                        ),
                      ],
                    )
                    : SizedBox.shrink(),
                CommonController.to.isDriver.value
                    ? DynamicTabWidget(
                      tabs: AccountInformationController.to.tabs,
                      tabContent: AccountInformationController.to.tabContent,
                    )
                    : ProfileInfoListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
