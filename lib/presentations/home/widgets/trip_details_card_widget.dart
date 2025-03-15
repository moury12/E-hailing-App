import 'dart:async';

import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/custom_timeline.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constant.dart';
import '../../trip/widgets/row_call_chat_details_button.dart';

class TripDetailsCard extends StatelessWidget {
  const TripDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding12,
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.kPrimaryColor, width: 1.w),
      ),
      padding: padding12,
      child: Obx(() {
        return Column(
          spacing: 8.h,
          children: [
            CustomText(
              text:HomeController.to.isDestination.value?AppStaticStrings.destination: AppStaticStrings.pickup,
              fontSize: getFontSizeDefault(),
            ),
            Row(
              spacing: 12.w,
              children: [
                CustomNetworkImage(
                  imageUrl: dummyProfileImage,
                  boxShape: BoxShape.circle,
                  height: 42.w,
                  width: 42.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Darrell Steward',
                        style: poppinsSemiBold,
                        fontSize: getFontSizeDefault(),
                      ),
                      CustomText(
                        text: '(406) 555-0120',
                        color: AppColors.kLightBlackColor,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text: 'Estimated Time',
                        color: AppColors.kLightBlackColor,
                      ),
                      CustomText(
                        text: '4.00 Min',
                        style: poppinsSemiBold,
                        fontSize: getFontSizeDefault(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!HomeController.to.isDestination.value) CarDetailsCardWidget(),
            ButtonTapWidget(
              onTap: () {
                HomeController.to.isDestination.value = true;
                Timer(Duration(seconds: 1), () {
                  Get.toNamed(PaymentPage.routeName);
                });
              },
              child: FromToTimeLine(showTo: HomeController.to.isDestination.value,),
            ),
            RowCallChatDetailsButton(),
            if (!HomeController.to.isDestination.value)
              CancelTripButtonWidget(),
          ],
        );
      }),
    );
  }
}

class FromToTimeLine extends StatelessWidget {
  final bool? showTo;
  const FromToTimeLine({
    super.key, this.showTo=true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTimeline(
      padding: EdgeInsets.zero,
      indicators: <Widget>[
        SvgPicture.asset(pickLocationIcon),
        if (showTo==true)
          SvgPicture.asset(dropLocationIcon),
      ],
      children: <Widget>[
        FromToWidget(
          details: '1901 Thornridge Cir. Shiloh, Hawaii 81063',
          headline: AppStaticStrings.from,
        ),
        if (showTo==true)
          FromToWidget(
            details: '1901 Thornridge Cir. Shiloh, Hawaii 81063',
            headline: AppStaticStrings.to,
          ),
      ],
    );
  }
}

class FromToWidget extends StatelessWidget {
  final String headline;
  final String details;
  const FromToWidget({
    super.key,
    required this.headline,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: headline,
          style: poppinsSemiBold,
          fontSize: getFontSizeDefault(),
        ),
        CustomText(text: details, color: AppColors.kLightBlackColor),
      ],
    );
  }
}
