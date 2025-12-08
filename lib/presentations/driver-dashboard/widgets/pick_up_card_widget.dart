import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/widgets/row_call_chat_details_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';

class DriverAfterAcceptedWidget extends StatefulWidget {
  final String? dateTime;
  final String? tripId;
  final DriverCurrentTripModel driverCurrentTripModel;
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
    required this.driverCurrentTripModel,
  });

  @override
  State<DriverAfterAcceptedWidget> createState() =>
      _DriverAfterAcceptedWidgetState();
}

class _DriverAfterAcceptedWidgetState extends State<DriverAfterAcceptedWidget> {
  @override
  void initState() {
    if (!DashBoardController.to.afterOnTheWay.value) {
      getInitialEstimatedTime();
    }
    super.initState();
  }

  void getInitialEstimatedTime() async {
    DashBoardController.to.estimatedPickupTime.value = await getEstimatedTime(
      pickupLat:
          CommonController.to.markerPositionDriver.value.latitude.toDouble(),
      pickupLng:
          CommonController.to.markerPositionDriver.value.longitude.toDouble(),
      dropOffLat:
          widget.driverCurrentTripModel.pickUpCoordinates!.coordinates!.last
              .toDouble(),
      dropOffLng:
          widget.driverCurrentTripModel.pickUpCoordinates!.coordinates!.first
              .toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6.h,
      children: [
        CustomText(
          text: AppStaticStrings.pickup.tr,
          fontSize: getFontSizeDefault(),
        ),
        DriverDetails(
          userName:
              widget.user != null
                  ? widget.user?.name
                  : AppStaticStrings.noDataFound.tr,
          userImg:
              widget.user != null
                  ? "${ApiService().baseUrl}/${widget.user?.profileImage}"
                  : AppStaticStrings.noDataFound.tr,
          fare: widget.fare,
          value: "${widget.time} min",
        ),
        FromToTimeLine(showTo: false, pickUpAddress: widget.fromAddress),
        RowCallChatDetailsButton(
          userId: widget.user!.sId.toString(),
          showLastButton: false,
          phoneNumber: widget.user != null ? widget.user?.phoneNumber : "000",
        ),
        Obx(() {
          return DashBoardController.to.afterOnTheWay.value
              ? CustomButton(
                onTap: () {
                  if (widget.tripId != null) {
                    DashBoardController.to.driverTripUpdateStatus(
                      tripId: widget.tripId.toString(),
                      newStatus: DriverTripStatus.arrived.name.toString(),
                    );
                  }
                },
                title: AppStaticStrings.arrive.tr,
                fillColor: AppColors.kPrimaryColor,
                textColor: AppColors.kWhiteColor,
              )
              : CustomButton(
                onTap: () {
                  if (widget.tripId != null) {
                    DashBoardController.to.driverTripUpdateStatus(
                      tripId: widget.tripId.toString(),
                      newStatus: DriverTripStatus.on_the_way.name.toString(),
                    );
                  }
                },
                title:
                    "${AppStaticStrings.pickUpWithin.tr}${DashBoardController.to.estimatedPickupTime.value}",
                fillColor: AppColors.kWhiteColor,
                textColor: AppColors.kPrimaryColor,
              );
        }),
      ],
    );
  }
}
