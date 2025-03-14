import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_check_box.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../presentations/trip/widgets/trip_cancellation_reason_card_item.dart';

Future<dynamic> tripCancellationDialog() {
  return Get.defaultDialog(
    backgroundColor: AppColors.kWhiteColor,
    radius: 8.r,
    title: AppStaticStrings.tripCancellationTitle,
    titleStyle: poppinsSemiBold.copyWith(
      color: AppColors.kTextDarkBlueColor,
      fontSize: getFontSizeExtraLarge(),
    ),
    titlePadding: padding12.copyWith(bottom: 0),
    contentPadding: EdgeInsets.zero,
    content: Column(
      children: [
        Divider(color: AppColors.kLightBlackColor,),
        ...List.generate(
          tripCancellationList.length,
              (index) => TripCancellationReasonCardItem(index: index,),
        ),
        Padding(
          padding: padding12,
          child: CustomButton(onTap: () {

          },title: AppStaticStrings.submit,
          ),
        )
      ],
    ),
  );
}

