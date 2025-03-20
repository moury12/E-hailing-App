import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/trip/widgets/row_call_chat_details_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';

class PickUpCardWidget extends StatelessWidget {
  const PickUpCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6.h,
      children: [
        CustomText(
          text: AppStaticStrings.pickup,
          fontSize: getFontSizeDefault(),
        ),
        DriverDetails(),
        FromToTimeLine(showTo: false),
        RowCallChatDetailsButton(showLastButton: false),
        Obx(() {
          return CustomButton(
            onTap: () {
              DashBoardController.to.arrive.value = true;
              if (DashBoardController.to.arrive.value) {
                DashBoardController.to.pickup.value = false;
                DashBoardController.to.isArrived.value = true;
              }
            },
            title:
                DashBoardController.to.arrive.value
                    ? AppStaticStrings.arrive
                    : AppStaticStrings.pickUpWithin,
            fillColor:
                DashBoardController.to.arrive.value
                    ? AppColors.kPrimaryColor
                    : AppColors.kWhiteColor,
            textColor:
                DashBoardController.to.arrive.value
                    ? AppColors.kWhiteColor
                    : AppColors.kPrimaryColor,
          );
        }),
      ],
    );
  }
}
