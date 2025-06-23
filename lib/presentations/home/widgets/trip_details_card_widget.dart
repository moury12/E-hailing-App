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
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constant.dart';
import '../../trip/widgets/row_call_chat_details_button.dart';
import 'gradient_progress_indicator.dart';

class TripDetailsPickupCard extends StatelessWidget {
  const TripDetailsPickupCard({super.key});

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
      child: Column(
        spacing: 8.h,
        children: [
          CustomText(
            text: AppStaticStrings.pickup,
            fontSize: getFontSizeDefault(),
          ),
          DriverDetails(),
          CarDetailsCardWidget(),
          ButtonTapWidget(child: FromToTimeLine(showTo: false)),
          RowCallChatDetailsButton(
            lastItemName: AppStaticStrings.details,
            onTap: () {
              Get.toNamed(TripDetailsPage.routeName);
            },
          ),

          CancelTripButtonWidget(),
        ],
      ),
    );
  }
}

class DriverDetails extends StatelessWidget {
  final String? title;
  final String? value;

  const DriverDetails({super.key, this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        CustomNetworkImage(
          imageUrl: dummyProfileImage,
          boxShape: BoxShape.circle,
          height: 42.w,
          width: 42.w,
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Darrell Steward',
                style: poppinsSemiBold,
                fontSize: getFontSizeDefault(),
              ),
              CustomText(text: 'RM 30.00', color: AppColors.kLightBlackColor),
            ],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: title ?? 'Estimated Time',
                color: AppColors.kLightBlackColor,
              ),
              CustomText(
                text: value ?? '4.00 Min',
                style: poppinsSemiBold,
                fontSize: getFontSizeDefault(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TripDetailsDestinationCard extends StatelessWidget {
  const TripDetailsDestinationCard({super.key});

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
      child: Column(
        spacing: 8.h,
        children: [
          CustomText(
            text: AppStaticStrings.destination,
            fontSize: getFontSizeDefault(),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    CustomText(
                      text: "BYD Atto 3",
                      fontSize: getFontSizeDefault(),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: CustomText(
                        text: "VKL8266(WHITE)",
                        color: AppColors.kWhiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(CupertinoIcons.info_circle_fill),
            ],
          ),
          DriverDetails(title: AppStaticStrings.tripDuration, value: '7.68 km'),

          ButtonTapWidget(
            onTap: () {
              Timer(Duration(seconds: 1), () {
                HomeController.to.updatePreviousRoute(Get.currentRoute);
                HomeController.to.resetAllStates();
                Get.toNamed(PaymentPage.routeName);
              });
            },
            child: FromToTimeLine(showTo: true),
          ),
          RowCallChatDetailsButton(
            lastItemName: AppStaticStrings.details,
            onTap: () {
              Get.toNamed(TripDetailsPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class TripRequestLoadingWidget extends StatelessWidget {
  const TripRequestLoadingWidget({
    super.key,
    required this.pickUpAddress,
    required this.dropOffAddress,
  });

  final String pickUpAddress;
  final String dropOffAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding12,
      padding: padding12,
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          colors: [AppColors.kWhiteColor, AppColors.kPrimaryLightColor],
        ),

        // border: Border.all(color: AppColors.kPrimaryColor, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.h,
        children: [
          CustomText(
            text: AppStaticStrings.newTripRequest,
            fontSize: getFontSizeDefault(),
          ),
          FromToTimeLine(
            dropOffAddress: dropOffAddress,
            pickUpAddress: pickUpAddress,
          ),
          GradientProgressIndicator(),
          CustomText(
            text: AppStaticStrings.waitingForDriverConformation,
            color: AppColors.kExtraLightBlackColor,
            fontSize: getFontSizeSmall(),
            style: poppinsRegular,
          ),
        ],
      ),
    );
  }
}

class FromToTimeLine extends StatelessWidget {
  final bool? showTo;
  final String? pickUpAddress;
  final String? dropOffAddress;

  const FromToTimeLine({
    super.key,
    this.showTo = true,
    this.pickUpAddress,
    this.dropOffAddress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTimeline(
      padding: EdgeInsets.zero,
      indicators: <Widget>[
        SvgPicture.asset(pickLocationIcon),
        if (showTo == true) SvgPicture.asset(dropLocationIcon),
      ],
      children: <Widget>[
        FromToWidget(
          details: pickUpAddress ?? "No pick up address provided",
          headline: AppStaticStrings.from,
        ),
        if (showTo == true)
          FromToWidget(
            details: dropOffAddress ?? "No drop off address provided",
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
