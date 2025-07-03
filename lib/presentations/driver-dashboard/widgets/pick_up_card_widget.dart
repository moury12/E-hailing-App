import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:e_hailing_app/presentations/trip/widgets/row_call_chat_details_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';

class DriverAfterAcceptedWidget extends StatelessWidget {
  final String? dateTime;
  final String? tripId;

  final User? user;
  final String? rideType;
  final String? fare;
  final String? time;
  final String? fromAddress;

  const DriverAfterAcceptedWidget({
    super.key,
    this.dateTime,
    this.user,
    this.rideType,
    this.fare,
    this.time,
    this.fromAddress,
    this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6.h,
      children: [
        CustomText(
          text: AppStaticStrings.pickup,
          fontSize: getFontSizeDefault(),
        ),
        DriverDetails(
          userName: user != null ? user?.name : AppStaticStrings.noDataFound,
          userImg:
              user != null
                  ? "${ApiService().baseUrl}/${user?.name}"
                  : AppStaticStrings.noDataFound,
          fare: fare,
          value: "$time min",
        ),
        FromToTimeLine(showTo: false, pickUpAddress: fromAddress),
        RowCallChatDetailsButton(
          showLastButton: false,
          phoneNumber: user != null ? user?.phoneNumber : "000",
        ),
        Obx(() {
          return DashBoardController.to.afterOnTheWay.value
              ? CustomButton(
                onTap: () {
                  if (tripId != null) {
                    DashBoardController.to.driverTripUpdateStatus(
                      tripId: tripId.toString(),
                      newStatus: DriverTripStatus.arrived.name.toString(),
                    );
                  }
                },
                title: AppStaticStrings.arrive,
                fillColor: AppColors.kPrimaryColor,
                textColor: AppColors.kWhiteColor,
              )
              : CustomButton(
                onTap: () {
                  if (tripId != null) {
                    DashBoardController.to.driverTripUpdateStatus(
                      tripId: tripId.toString(),
                      newStatus: DriverTripStatus.on_the_way.name.toString(),
                    );
                  }
                },
                title: AppStaticStrings.pickUpWithin,
                fillColor: AppColors.kWhiteColor,
                textColor: AppColors.kPrimaryColor,
              );
        }),
      ],
    );
  }
}
