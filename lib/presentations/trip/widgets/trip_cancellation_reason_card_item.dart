import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_check_box.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
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
        tripCancellationList[index].isChecked.value =
            !tripCancellationList[index].isChecked.value;
        if (tripCancellationList[index].isChecked.value == true) {
         if(CommonController.to.isDriver.value) {
            DashBoardController.to.cancelReason.add(
                tripCancellationList[index].title);
          }   else{
           HomeController.to.cancelReason.add(
               tripCancellationList[index].title);
         }
        }
        ;
      },
      child: Padding(
        padding: padding12,
        child: Row(
          spacing: 12.w,
          children: [
            Obx(() {
              return CustomCheckbox(
                isChecked: tripCancellationList[index].isChecked.value,
                //   onChanged: (value) {
                //
              );
            }),
            CustomText(
              text: tripCancellationList[index].title,
              style: poppinsMedium,
              fontSize: kDefaultFontSize,
            ),
          ],
        ),
      ),
    );
  }
}
