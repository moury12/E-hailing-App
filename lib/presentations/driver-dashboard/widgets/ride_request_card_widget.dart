import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';

class RideRequestCardWidget extends StatelessWidget {
  final String? dateTime;
  final String? userImg;
  final String? userName;
  final String? rideType;
  final String? tripClass;
  final String? fare;
  final String? distance;
  final String? fromAddress;
  final String? toAddress;
  final String? tripId;

  const RideRequestCardWidget({
    super.key,
    this.dateTime,
    this.userImg,
    this.userName,
    this.rideType,
    this.fare,
    this.distance,
    this.fromAddress,
    this.toAddress,
    this.tripClass,
    this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 12.h,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    text:
                        "${rideType == 'ride' ? "${tripClass?.toLowerCase() == "premium" ? "Premium" : ""} ${AppStaticStrings.ride.tr}" : AppStaticStrings.preBookRide.tr} Request",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: padding6,
                    child: CustomText(
                      text: dateTime ?? '00 00 0000 at 00:00 PM',
                      color: AppColors.kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
            DriverDetails(
              title: AppStaticStrings.tripDistance.tr,
              value: "${(int.parse(distance ?? "0") / 1000).toString()} km",
              fare: fare,
              userImg: userImg,
              userName: userName,
            ),
            FromToTimeLine(
              pickUpAddress: fromAddress,
              dropOffAddress: toAddress,
            ),
            Obx(() {
              return CustomButton(
                isLoading: DashBoardController.to.isLoadingAccept.value,
                onTap: () {
                  // DashBoardController.to.rideRequest.value = false;
                  DashBoardController.to.driverTripAccept(
                    tripId: tripId ?? "",
                    lat:
                        CommonController.to.markerPositionDriver.value.latitude,
                    lng:
                        CommonController
                            .to
                            .markerPositionDriver
                            .value
                            .longitude,
                  );
                },
                title: AppStaticStrings.accept.tr,
              );
            }),
            CustomButton(
              fillColor: AppColors.kWhiteColor,
              textColor: AppColors.kPrimaryColor,
              onTap: () {
                DashBoardController.to.ignoreTrip(tripId ?? "");
              },
              title: AppStaticStrings.findAnother.tr,
            ),
          ],
        ),
      ),
    );
  }
}
