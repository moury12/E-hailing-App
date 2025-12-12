import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/message/controllers/message_controller.dart';
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
  final String userId;
  final bool? showLastButton;
  final bool? isChatLoading;
  final Function()? onTap;
  final Function()? onChat;

  const RowCallChatDetailsButton({
    super.key,
    this.lastItemName,
    this.onTap,
    this.showLastButton = true,
    this.phoneNumber,
    required this.userId,
    this.onChat,
    this.isChatLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: CustomButton(
            onTap: () {
              callOnPhone(phoneNumber: phoneNumber ?? '00000000000');
            },
            padding: padding8,
            child: SvgPicture.asset(callIcon, height: 24.w),
          ),
        ),
        Expanded(
          child: CustomButton(
            isLoading: isChatLoading,
            padding: padding8,
            onTap: () {
              MessageController.to.createConversationRequest(
                userId: userId.toString(),
              );
            },
            child: SvgPicture.asset(chatIcon, height: 24.w),
          ),
        ),
        showLastButton == true
            ? Expanded(
          child: CustomButton(
            padding: padding8,

            onTap:
            onTap ??
                    () {
                  HomeController.to.updatePreviousRoute(Get.currentRoute);
                  Get.toNamed(
                    NavigationPage.routeName,
                    arguments: pickupDestination,
                  );
                },
            title: lastItemName ?? AppStaticStrings.track.tr,
          ),
        )
            : SizedBox.shrink(),
      ],
    );
  }
}

class CancelTripButtonWidget extends StatelessWidget {
  final Function()? onSubmit;
  final RxBool? isLoading;

  const CancelTripButtonWidget(
      {super.key, this.onSubmit,  this.isLoading});

  @override
  Widget build(BuildContext context) {


      if (isLoading == null) {
        return CustomButton(
          onTap: () => tripCancellationDialog(onSubmit: onSubmit),
          title: AppStaticStrings.cancelTrip.tr,
        );
      }

      return Obx(() {
        final loading = isLoading!.value;
        return CustomButton(
          onTap: loading ? () {} : () => tripCancellationDialog(onSubmit: onSubmit),
          title: loading
              ? AppStaticStrings.tripLoading.tr
              : AppStaticStrings.cancelTrip.tr,
        );
      });
    }


  }

