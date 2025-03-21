import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/profile/views/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../widgets/custom_container_with_elevation.dart';
import '../widgets/earning_bar_chart.dart';

class EarningsPage extends StatelessWidget {
  static const String routeName = '/earnings';
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.earnings),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Column(
            spacing: 12.h,
            children: [
              CustomContainerWithElevation(
                child: Row(
                  children: [
                    SvgPicture.asset(totalEarnIcon, height: 80.w),
                    space24W,
                    Expanded(
                      child: Column(
                        spacing: 8.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: AppStaticStrings.earnings),
                          CustomText(
                            text: 'RM 600',
                            style: poppinsBold,
                            color: AppColors.kPrimaryColor,
                            fontSize: getFontSizeDefault(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                spacing: 12.w,
                children: List.generate(
                  earningList.length,
                  (index) => Expanded(
                    child: CustomContainerWithElevation(
                      child: Column(
                        spacing: 8.h,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            earningList[index].img,
                            height: 40.w,
                          ),
                          CustomText(text: earningList[index].title),
                          CustomText(
                            text: earningList[index].val,
                            style: poppinsBold,
                            color: AppColors.kPrimaryColor,
                            fontSize: getFontSizeDefault(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              EarningsBarChart(),
              CustomButton(
                onTap: () {
                  Get.toNamed(TransactionPage.routeName);
                },
                title: AppStaticStrings.viewTransactionHistory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
