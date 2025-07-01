import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AfterDestinationReachedWidget extends StatelessWidget {
  const AfterDestinationReachedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        CustomText(
          textAlign: TextAlign.center,
          text: "You reached the destination now you need to complete the trip",
        ),
        CustomButton(
          onTap: () {
            Get.toNamed(
              PaymentPage.routeName,
              arguments: {
                "driver": DashBoardController.to.currentTrip.value,
                "role": driver,
              },
            );
          },
          title: AppStaticStrings.payment,
        ),
      ],
    );
  }
}
