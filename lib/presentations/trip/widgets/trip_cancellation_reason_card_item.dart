import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_check_box.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TripCancellationReasonCardItem extends StatelessWidget {
  final int index;

  const TripCancellationReasonCardItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: () {
        CommonController.to.tripCancellationList[index].isChecked.value =
            !CommonController.to.tripCancellationList[index].isChecked.value;
        if (CommonController.to.isDriver.value) {
          if (CommonController.to.tripCancellationList[index].isChecked.value) {
            DashBoardController.to.cancelReason.add(
              CommonController.to.tripCancellationList[index].title,
            );
          } else {
            DashBoardController.to.cancelReason.remove(
              CommonController.to.tripCancellationList[index].title,
            );
          }
        } else {
          if (CommonController.to.tripCancellationList[index].isChecked.value) {
            HomeController.to.cancelReason.add(
              CommonController.to.tripCancellationList[index].title,
            );
          } else {
            HomeController.to.cancelReason.remove(
              CommonController.to.tripCancellationList[index].title,
            );
          }
        }
      },
      child: Padding(
        padding: padding12,
        child: Row(
          spacing: 12.w,
          children: [
            Obx(() {
              return CustomCheckbox(
                isChecked:
                    CommonController
                        .to
                        .tripCancellationList[index]
                        .isChecked
                        .value,
                //   onChanged: (value) {
                //
              );
            }),
            Expanded(
              child: CustomText(
                text: CommonController.to.tripCancellationList[index].title,
                style: poppinsMedium,
                fontSize: kDefaultFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
