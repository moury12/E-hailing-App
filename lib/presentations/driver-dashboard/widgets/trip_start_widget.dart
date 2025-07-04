import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../home/widgets/trip_details_card_widget.dart';
import '../controllers/dashboard_controller.dart';

class AfterPickedUpWidget extends StatelessWidget {
  final User? user;
  final String? duration;
  final String? fare;
  final String? fromAddress;
  final String? toAddress;
  final String? tripId;

  const AfterPickedUpWidget({
    super.key,
    this.user,
    this.duration,
    this.fromAddress,
    this.toAddress,
    this.fare,
    this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        CustomText(
          text: AppStaticStrings.tripStarted,
          fontSize: getFontSizeDefault(),
        ),
        DriverDetails(
          userName: user != null ? user?.name : AppStaticStrings.noDataFound,
          userImg: "${ApiService().baseUrl}/${user?.profileImage}",
          fare: fare,
          value: "$duration min",
        ),
        FromToTimeLine(pickUpAddress: fromAddress, dropOffAddress: toAddress),
        CustomButton(
          onTap: () {
            DashBoardController.to.driverTripUpdateStatus(
              tripId: tripId.toString(),
              newStatus: DriverTripStatus.started.name.toString(),
            );
          },
          title: AppStaticStrings.startTrip,
        ),
      ],
    );
  }
}
