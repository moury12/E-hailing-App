import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';

class AfterArrivedPickupLocationWidget extends StatelessWidget {
  final String? tripId;

  const AfterArrivedPickupLocationWidget({super.key, this.tripId});

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
        CustomButton(
          onTap: () {
            DashBoardController.to.driverTripUpdateStatus(
              tripId: tripId.toString(),
              newStatus: TripStateDriver.picked_up.name.toString(),
            );

            // DashBoardController.to.isArrived.value = false;
            // DashBoardController.to.isTripStarted.value = true;
          },
          title: AppStaticStrings.pickup,
        ),
      ],
    );
  }
}

class SendPaymentRequestWidget extends StatelessWidget {
  final String? dropOffAddress;
  final String tripId;

  const SendPaymentRequestWidget({
    super.key,
    this.dropOffAddress,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        SvgPicture.asset(pickUpLocationIcon),
        Row(
          spacing: 8.h,
          children: [
            SvgPicture.asset(locationIcon),
            Expanded(
              child: CustomText(
                text: dropOffAddress ?? AppStaticStrings.noDataFound,
              ),
            ),
          ],
        ),
        CustomTextField(
          borderColor: AppColors.kGreyColor,
          fillColor: AppColors.kWhiteColor,
          borderRadius: 24.r,
          textEditingController: DashBoardController.to.extraCost,
          keyboardType: TextInputType.number,
          title: "Extra charges(optional)",
        ),
        Obx(() {
          return CustomButton(
            isLoading: DashBoardController.to.isLoadingUpdateTollFee.value,
            onTap: () async {
              if (DashBoardController.to.extraCost.text.isNotEmpty) {
                await DashBoardController.to.updateTollFeeRequest(
                  tripId: tripId,
                );
              }
              logger.d(TripStateDriver.arrived.name.toString());
              DashBoardController.to.driverTripUpdateStatus(
                newStatus: TripStateDriver.arrived.name.toString(),
                tripId: tripId,
              );
            },
            title: AppStaticStrings.sendPaymentRequest,
          );
        }),
      ],
    );
  }
}
