import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/dashboard_controller.dart';

class AfterTripStartedWidget extends StatelessWidget {
  final String? tripDistance;
  final String? estimatedTime;
  final String? pickUpAddress;
  final String? dropOffAddress;

  const AfterTripStartedWidget({
    super.key,
    this.tripDistance,
    this.estimatedTime,
    this.pickUpAddress,
    this.dropOffAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        TitleTextWidget(title: "Distance", text: "$tripDistance km" ?? '00 km'),
        TitleTextWidget(
          title: 'Estimated Time',
          text: "$estimatedTime min" ?? '00:00 min',
        ),
        FromToTimeLine(
          pickUpAddress: pickUpAddress,
          dropOffAddress: dropOffAddress,
        ),
        CustomButton(
          onTap: () {
            DashBoardController.to.afterTripStarted.value = false;
            DashBoardController.to.sendPaymentReq.value = true;
          },
          title: AppStaticStrings.arrived,
        ),
      ],
    );
  }
}

class TitleTextWidget extends StatelessWidget {
  final String title;
  final String text;

  const TitleTextWidget({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [CustomText(text: title), CustomText(text: text)],
    );
  }
}
