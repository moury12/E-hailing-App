import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/driver-statics/model/StaticModel.dart';
import 'package:e_hailing_app/presentations/profile/controllers/driver_settings_controller.dart';
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
      appBar: CustomAppBar(title: AppStaticStrings.earnings.tr),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          DriverSettingsController.to.getDriverEarningReport();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
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
                                CustomText(text: AppStaticStrings.earnings.tr),
                                Obx(() {
                                  final tripAnalysis =
                                      DriverSettingsController
                                          .to
                                          .driverEarningModel
                                          .value
                                          .tripPaymentAnalysis;

                                  final coin = tripAnalysis?.coin ?? 0;
                                  final cash = tripAnalysis?.cash ?? 0;

                                  final totalEarnings = coin + cash;
                                  return CustomText(
                                    text: 'RM $totalEarnings',
                                    style: poppinsBold,
                                    color: AppColors.kPrimaryColor,
                                    fontSize: getFontSizeDefault(),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      final tripAnalysis =
                          DriverSettingsController
                              .to
                              .driverEarningModel
                              .value
                              .tripPaymentAnalysis;
                      final coin = tripAnalysis?.coin ?? 0;
                      final cash = tripAnalysis?.cash ?? 0;
                      List<StaticModel> earningList = [
                        StaticModel(
                          img: handCash1Icon,
                          title: AppStaticStrings.handCash.tr,
                          val: 'RM $cash',
                        ),
                        StaticModel(
                          img: onlineCashIcon,
                          title: AppStaticStrings.onlineCash.tr,
                          val: 'RM 0',
                        ),
                        StaticModel(
                          img: coinIcon,
                          title: AppStaticStrings.dCoin.tr,
                          val: 'RM $coin',
                        ),
                      ];
                      return Row(
                        spacing: 12.w,
                        children: List.generate(
                          earningList.length,
                          (index) => Expanded(
                            child: CustomContainerWithElevation(
                              child: Column(
                                spacing: 8.h,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    earningList[index].img,
                                    height: 40.w,
                                  ),
                                  CustomText(
                                    text: earningList[index].title,
                                    textAlign: TextAlign.center,
                                  ),
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
                      );
                    }),
                    EarningsBarChart(),
                    CustomButton(
                      onTap: () {
                        Get.toNamed(TransactionPage.routeName);
                      },
                      title: AppStaticStrings.viewTransactionHistory.tr,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
