import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/notification/controller/notification_controller.dart';
import 'package:e_hailing_app/presentations/notification/model/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationCardItemWidget extends StatelessWidget {
  final int? index;
  final NotificationModel notificationModel;

  const NotificationCardItemWidget({
    super.key,
    this.index,
    required this.notificationModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: paddingH12V4,
      decoration: BoxDecoration(
        color:
            notificationModel.isRead == false
                ? AppColors.kUnreadColor
                : AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: AppColors.kLightBlackColor)],
      ),
      child: Padding(
        padding: padding12,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:
                        notificationModel.title ?? AppStaticStrings.noDataFound.tr,
                    style: poppinsMedium,
                    fontSize: getFontSizeSemiSmall(),
                  ),
                  CustomText(
                    text:
                        notificationModel.message ??
                        AppStaticStrings.noDataFound.tr,
                    style: poppinsRegular,
                    fontSize: getFontSizeSmall(),
                    color: AppColors.kExtraLightTextColor,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                NotificationController.to.deleteNotificationRequest(
                  notificationId: notificationModel.sId.toString(),
                );
              },
              icon: Icon(CupertinoIcons.multiply, color: AppColors.kTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
