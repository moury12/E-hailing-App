import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/custom_appbar.dart';
import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';

class CoinPage extends StatelessWidget {
  static const String routeName = '/coin';
  const CoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.duduCoinWallet),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16,
          child: Column(
            spacing: 12.h,
            children: [
              Container(
                padding: padding12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: AppColors.kWhiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kExtraLightGreyTextColor.withValues(
                        alpha: .3,
                      ),
                      blurRadius: 6.r,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CustomText(text: AppStaticStrings.totalCoin),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryExtraLightColor,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: AppColors.kPrimaryColor),
                      ),

                      child: Padding(
                        padding: paddingH16V6,
                        child: Row(
                          children: [
                            SvgPicture.asset(coinIcon),
                            CustomText(text: '7786'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      content: Column(
                        spacing: 12.h,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(title: AppStaticStrings.addCoin,),
                          CustomButton(onTap: () {
                            Navigator.pop(context);
                          },title: 'Buy Now',)
                        ],
                      ),
                    );
                  },);
                },
                img: addIcon,
                child: Row(
                  spacing: 12.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(addWhiteIcon),
                    CustomText(
                      text: AppStaticStrings.addMoreCoin,
                      style: poppinsSemiBold,
color: AppColors.kWhiteColor,
                      fontSize: getFontSizeSemiSmall(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
