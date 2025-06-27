import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/dashboard_controller.dart';

class NoNewRideReqWidget extends StatelessWidget {
  const NoNewRideReqWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        GestureDetector(
          onTap: () {
            // DashBoardController.to.registerDriverListeners();
            DashBoardController.to.findingRide.value = false;
            DashBoardController.to.rideRequest.value = true;
          },
          child: SvgPicture.asset(carPrimaryIcon),
        ),
        CustomText(text: AppStaticStrings.noNewRideReq),
      ],
    );
  }
}
