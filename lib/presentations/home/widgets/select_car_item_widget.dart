import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../trip/views/request_trip_page.dart';

class SelectCarITemWidget extends StatelessWidget {
  final Function()? onTap;
  final Color? fillColor;
  final Color? borderColor;
  final double fare;
  final String? carClass;

  const SelectCarITemWidget({
    super.key,
    this.onTap,
    this.fillColor,
    this.borderColor,
    required this.fare,
    this.carClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor ?? AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: borderColor ?? AppColors.kWhiteColor,
          width: 2.w,
        ),
      ),
      child: ButtonTapWidget(
        onTap: onTap,
        radius: 16.r,
        child: Padding(
          padding: padding8,
          child: Row(
            spacing: 12.w,
            children: [
              Image.asset(purpleCarImage2, height: 45.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: carClass?.toUpperCase() ?? 'Dudu Car',
                      style: poppinsSemiBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    CustomText(text: '4 seat', style: poppinsRegular),
                  ],
                ),
              ),
              // const Spacer(),
              CustomText(text: 'RM $fare'),
            ],
          ),
        ),
      ),
    );
  }
}

class CarDetailsCardWidget extends StatelessWidget {
  final Function()? onTap;
  final double? fare;
  final String? carClass;

  const CarDetailsCardWidget({super.key, this.onTap, this.fare, this.carClass});

  @override
  Widget build(BuildContext context) {
    return SelectCarITemWidget(
      fillColor: AppColors.kPrimaryExtraLightColor,
      borderColor: AppColors.kPrimaryColor,
      onTap:
          onTap ??
          () {
            Get.toNamed(RequestTripPage.routeName);
          },
      fare: fare ?? 12,
      carClass: carClass,
    );
  }
}
