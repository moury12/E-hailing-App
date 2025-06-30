import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constant.dart';
import '../../../core/helper/helper_function.dart';

class RowCallChatDetailsButton extends StatelessWidget {
  final String? lastItemName;
  final String? phoneNumber;
  final String? userId;
  final bool? showLastButton;
  final Function()? onTap;

  const RowCallChatDetailsButton({
    super.key,
    this.lastItemName,
    this.onTap,
    this.showLastButton = true,
    this.phoneNumber,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: CustomButton(
            onTap: () {
              callOnPhone(phoneNumber: phoneNumber ?? '01716773054');
            },
            padding: padding8,
            child: SvgPicture.asset(callIcon, height: 24.w),
          ),
        ),
        Expanded(
          child: CustomButton(
            padding: padding8,
            onTap: () {},
            child: SvgPicture.asset(chatIcon, height: 24.w),
          ),
        ),
        showLastButton == true
            ? Expanded(
              child: CustomButton(
                onTap:
                    onTap ??
                    () {
                      HomeController.to.updatePreviousRoute(Get.currentRoute);
                      Get.toNamed(
                        NavigationPage.routeName,
                        arguments: pickupDestination,
                      );
                    },
                title: lastItemName ?? AppStaticStrings.track,
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}

class CancelTripButtonWidget extends StatelessWidget {
  const CancelTripButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () {
        tripCancellationDialog();
      },
      title: AppStaticStrings.cancelTrip,
    );
  }
}
