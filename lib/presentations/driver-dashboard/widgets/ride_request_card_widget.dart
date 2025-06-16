import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';

class RideRequestCardWidget extends StatelessWidget {
  const RideRequestCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        Row(
          children: [
            Expanded(child: CustomText(text: AppStaticStrings.preBookRide)),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: padding6,
                child: CustomText(
                  text: '01 jan 2025 at 04:10 PM',
                  color: AppColors.kWhiteColor,
                ),
              ),
            ),
          ],
        ),
        DriverDetails(title: AppStaticStrings.tripDuration, value: '7.68 km'),
        FromToTimeLine(),
        CustomButton(
          onTap: () {
            DashBoardController.to.rideRequest.value = false;
            DashBoardController.to.pickup.value = true;
          },
          title: AppStaticStrings.accept,
        ),
        CustomButton(
          fillColor: AppColors.kWhiteColor,
          textColor: AppColors.kPrimaryColor,
          onTap: () {
            DashBoardController.to.rideRequest.value = false;
            DashBoardController.to.findingRide.value = true;
          },
          title: AppStaticStrings.findAnother,
        ),
      ],
    );
  }
}
