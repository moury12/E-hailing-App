import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/widgets/coin_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DCoinDialogPaymentWidget extends StatelessWidget {
  const DCoinDialogPaymentWidget({
    super.key,
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
                  CoinContainerWidget(),
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
                    CoinContainerWidget(),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  spacing: 6.h,
                  crossAxisAlignment:
                  CrossAxisAlignment.end,

                  children: [
                    CustomText(
                      text: AppStaticStrings.tripDuration,
                      color:
                      AppColors.kExtraLightTextColor,
                    ),
                    CustomText(
                      text: '1.07 km',
                      style: poppinsSemiBold,
                      fontSize: getFontSizeDefault(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          CustomButton(
            onTap: () {},
            title: AppStaticStrings.confirm,
          ),
          // FromToTimeLine()
        ],
      ),
    );
  }
}
