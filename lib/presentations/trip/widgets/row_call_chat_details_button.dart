import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
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
  final Function()? onTap;
  const RowCallChatDetailsButton({
    super.key,  this.lastItemName, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: CustomButton(
            onTap: () {},
            child: SvgPicture.asset(callIcon),
          ),
        ),
        Expanded(
          child: CustomButton(
            onTap: () {},
            child: SvgPicture.asset(chatIcon),
          ),
        ),
        Expanded(
          child: CustomButton(
            onTap:onTap?? () {
              Get.toNamed(
                NavigationPage.routeName,
                arguments: pickupDestination,
              );
            },
            title:lastItemName?? AppStaticStrings.track,
          ),
        ),
      ],
    );
  }
}
class CancelTripButtonWidget extends StatelessWidget {
  const CancelTripButtonWidget({
    super.key,
  });

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
