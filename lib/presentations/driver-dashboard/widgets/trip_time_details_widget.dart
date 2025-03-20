import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/dashboard_controller.dart';

class TrimTimeDetails extends StatelessWidget {
  const TrimTimeDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        TitleTextWidget(
          title: 'Trip Time',
          text: '00:31 hr',
        ),
        TitleTextWidget(
          title: 'Estimated Time',
          text: '00:31 hr',
        ),
        FromToTimeLine(),
        CustomButton(
          onTap: () {
            DashBoardController.to.isTripEnd.value =false;
            DashBoardController.to.arrive.value =true;
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