import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/trip/widgets/car_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentPage extends StatelessWidget {
  static const String routeName = '/payment';
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.payment),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Center(
            child: Column(
              spacing: 8.h,
              children: [
                SvgPicture.asset(successfulIcon),

                CustomText(
                  text: AppStaticStrings.rideEnded,
                  color: AppColors.kExtraLightBlackColor,
                  style: poppinsRegular,
                  fontSize: getFontSizeSmall(),
                ),
                CustomText(
                  text: AppStaticStrings.arriveOnLocation,

                  style: poppinsBold,
                  fontSize: getFontSizeExtraLarge(),
                ),
                CarInformationWidget(
                  title: AppStaticStrings.rent,
                  value: 'RM 150',
                ),
                CarInformationWidget(
                  title: AppStaticStrings.tollFee,
                  value: 'RM 150',
                ),
                Divider(color: AppColors.kGreyColor, height: 2, thickness: 2),
                CarInformationWidget(
                  title: AppStaticStrings.totalPayment,
                  value: 'RM 150',
                ),
                space12H,
                PaymentCardItem(
                  img: cardsIcon,
                  title: AppStaticStrings.creditDebitCards,
                  onTap: () {},
                ),
                space4H,
                PaymentCardItem(
                  img: handCashIcon,
                  title: AppStaticStrings.handCash,
                  onTap: () {},
                ),
                space4H,
                PaymentCardItem(
                  img: coinIcon,
                  title: AppStaticStrings.dCoin,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentCardItem extends StatelessWidget {
  final String img;
  final String title;
  final Function() onTap;
  const PaymentCardItem({
    super.key,
    required this.img,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: ButtonTapWidget(
        radius: 24.r,
        onTap: onTap,
        child: Padding(
          padding: paddingH16V8,
          child: Row(
            spacing: 12.w,
            children: [
              SvgPicture.asset(img),
              CustomText(text: title, color: AppColors.kTextBlueGreyColor),
            ],
          ),
        ),
      ),
    );
  }
}
