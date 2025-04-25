import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/payment/views/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';

class PickUpStartedWidget extends StatelessWidget {
  const PickUpStartedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        CustomText(
          text: AppStaticStrings.pickup,
          fontSize: getFontSizeDefault(),
        ),
        SvgPicture.asset(pickUpLocationIcon),
        CustomButton(onTap: () {
          DashBoardController.to.isArrived.value=false;
          DashBoardController.to.isTripStarted.value=true;
        },
          title: AppStaticStrings.pickup,)
      ],
    );
  }
}
class SendPaymentRequestWidget extends StatelessWidget {
  const SendPaymentRequestWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 8.h,
      children: [
        SvgPicture.asset(pickUpLocationIcon),
        Row(
          spacing: 8.h,
          children: [
            SvgPicture.asset(locationIcon),
            Expanded(
              child: CustomText(
                text:
                '1901 Thornridge Cir. Shiloh, Hawaii 81063',
              ),
            ),
          ],
        ),
        CustomTextField(
          borderColor: AppColors.kGreyColor,
          fillColor: AppColors.kWhiteColor,
          borderRadius: 24.r,
keyboardType: TextInputType.number,
          title: "Extra charges",
        ),
        CustomButton(onTap: () {
Get.toNamed(PaymentPage.routeName,arguments: driver);
        },title: AppStaticStrings.sendPaymentRequest,)
      ],
    );
  }
}
