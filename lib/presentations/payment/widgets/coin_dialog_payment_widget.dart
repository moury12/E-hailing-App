import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:e_hailing_app/presentations/profile/widgets/coin_container_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DCoinDialogPaymentWidget extends StatelessWidget {
  final String tripId;
  final String extraCost;

  const DCoinDialogPaymentWidget({
    super.key, required this.tripId, required this.extraCost,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.h,
        children: [
          CustomText(
            text: AppStaticStrings.paymentWithDCoin,
            style: poppinsSemiBold,
            fontSize: getFontSizeDefault(),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.kLightBlackColor,
              ),
            ),
            child: Padding(
              padding: padding12,
              child: Row(
                spacing: 8.w,
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      text:
                      AppStaticStrings.availableCoin,
                    ),
                  ),
                  Obx(() {
                    return CoinContainerWidget(
                      coin: AccountInformationController.to.userModel.value
                          .coins.toString(),);
                  }),
                ],
              ),
            ),
          ),
          Divider(),
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  spacing: 6.h,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: AppStaticStrings.totalCost,
                      color:
                      AppColors.kExtraLightTextColor,
                    ),
                    CoinContainerWidget(coin: extraCost,),
                  ],
                ),
              ),

              // Expanded(
              //   child: Column(
              //     spacing: 6.h,
              //     crossAxisAlignment:
              //     CrossAxisAlignment.end,
              //
              //     children: [
              //       CustomText(
              //         text: AppStaticStrings.tripDuration,
              //         color:
              //         AppColors.kExtraLightTextColor,
              //       ),
              //       CustomText(
              //         text: '1.07 km',
              //         style: poppinsSemiBold,
              //         fontSize: getFontSizeDefault(),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),

          Obx(() {
            return CustomButton(
              isLoading: CommonController.to.isLoadingPayment.value,

              onTap: () {
                CommonController.to.postPaymentRequest(
                  tripId: tripId,
                  fromDcoin: true
                );
              },
              title: AppStaticStrings.confirm,
            );
          }),
          // FromToTimeLine()
        ],
      ),
    );
  }
}
