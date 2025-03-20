import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../home/widgets/trip_details_card_widget.dart';
import '../controllers/dashboard_controller.dart';
class TripStartWidget extends StatelessWidget {
  const TripStartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 8.h,
      children: [
        CustomText(
          text: AppStaticStrings.tripStarted,
          fontSize: getFontSizeDefault(),
        ),
        DriverDetails(),
        FromToTimeLine(),
        CustomButton(
          onTap: () {
            DashBoardController.to.isTripStarted.value=false;
            DashBoardController.to.isTripEnd.value=true;
          },
          title: AppStaticStrings.startTrip,
        ),
      ],
    );
  }
}
