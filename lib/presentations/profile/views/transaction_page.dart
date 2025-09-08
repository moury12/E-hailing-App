import 'package:e_hailing_app/core/components/comming_soon_widget.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  static const String routeName = '/transaction-history';
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.transactionHistory),
      body:ComingSoonWidget() /*SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Column(
            spacing: 12.h,
            children: List.generate(
              10,
              (index) => CustomContainerWithElevation(
                child: Row(
                  spacing: 12.w,
                  children: [
                    CustomNetworkImage(
                      imageUrl: dummyProfileImage,
                      boxShape: BoxShape.circle,
                      height: 44.w,
                      width: 44.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Albert Flores',
                          style: poppinsMedium,
                          fontSize: getFontSizeDefault(),
                          color: AppColors.kTextDarkBlueColor,
                        ),
                        CustomText(
                          text: 'Via Stripe',
                          style: poppinsRegular,
                          fontSize: getFontSizeSmall(),
                          color: AppColors.kExtraLightTextColor,
                        ),
                      ],
                    ),
                    Spacer(),
                    CustomText(text: '80 RM')
                  ],
                ),
              ),
            ),
          ),
        ),
      ),*/
    );
  }
}
