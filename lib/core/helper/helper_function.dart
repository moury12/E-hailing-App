import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/widgets/gradient_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../presentations/payment/widgets/ratting_dialog_widget.dart';
import '../../presentations/trip/widgets/trip_cancellation_reason_card_item.dart';

Future<dynamic> tripCancellationDialog() {
  return Get.defaultDialog(
    backgroundColor: AppColors.kWhiteColor,
    radius: 8.r,
    title: AppStaticStrings.tripCancellationTitle,
    titleStyle: poppinsSemiBold.copyWith(
      color: AppColors.kTextDarkBlueColor,
      fontSize: getFontSizeExtraLarge(),
    ),
    titlePadding: padding12.copyWith(bottom: 0),
    contentPadding: EdgeInsets.zero,
    content: Column(
      children: [
        Divider(color: AppColors.kLightBlackColor),
        ...List.generate(
          tripCancellationList.length,
          (index) => TripCancellationReasonCardItem(index: index),
        ),
        Padding(
          padding: padding12,
          child: CustomButton(
            onTap: () {
              Get.back();
            },
            title: AppStaticStrings.submit,
          ),
        ),
      ],
    ),
  );
}
Future<Map<String, dynamic>> getCredentials() async {
  final authBox = Boxes.getAuthData();
  final rememberMe = authBox.get('rememberMe', defaultValue: false);

  if (rememberMe) {
    return {
      'email': authBox.get('email'),
      'password': authBox.get('password'),
      'rememberMe': rememberMe,
    };
  }

  return {};
}

Future<void> saveCredentials(
    String email,
    String password,
    bool rememberMe,
    )
async {
  if (rememberMe) {
    await Boxes.getAuthData().put('email', email);
    await Boxes.getAuthData().put('password', password);
  } else {
    await Boxes.getAuthData().delete('email');
    await Boxes.getAuthData().delete('password');
  }

  await Boxes.getAuthData().put('rememberMe', rememberMe);
}
enum SnackBarType { success, failed, alert }

void showCustomSnackbar({
  required String title,
  required String message,
  bool noInternet = false,
  Function()? retryTap,
  SnackBarType type = SnackBarType.success,
  SnackPosition position = SnackPosition.BOTTOM, // Default position
})
{
  Color backgroundColor = AppColors.kWhiteColor.withValues(alpha: .5);
  Color textColor = Colors.black;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = AppColors.kWhiteColor.withValues(alpha: .5);

      break;
    case SnackBarType.failed:
      backgroundColor = Color(0xff8a0600);
      textColor = AppColors.kWhiteColor;

      break;
  // TODO: Handle this case.
    case SnackBarType.alert:
      backgroundColor = Color(0xffc86900);
      textColor = AppColors.kWhiteColor;
      break;
  // TODO: Handle this case.
  }
  Get.snackbar(
    title,
    message,
    backgroundColor: backgroundColor,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.all(12),
    colorText: textColor,
    dismissDirection: DismissDirection.horizontal,
    snackPosition: position,
    duration: const Duration(seconds: 3),
    mainButton:
    noInternet == true
        ? TextButton(
      onPressed: retryTap ?? () {},
      child: CustomText(text: 'Retry', color: AppColors.kWhiteColor),
    )
        : null,
  );
}
void callOnPhone({required String phoneNumber})async{
  final url = Uri.parse('tel:$phoneNumber');
  if (await canLaunchUrl(url)) {
  await launchUrl(url);
  } else {
  throw 'Could not launch $url';
  }
}
void showHandCashDialogs(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          spacing: 12.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: AppStaticStrings.handCashPaymentRequest,
              textAlign: TextAlign.center,
              fontSize: getFontSizeDefault(),
            ),
            Padding(
              padding:padding16V,
              child: GradientProgressIndicator(),
            ),
            CustomText(
              text: AppStaticStrings.waitingForDriverConformation,
              style: poppinsLight,
              color: AppColors.kExtraLightTextColor,
            ),
          ],
        ),
      );
    },
  );
  Future.delayed(Duration(seconds: 1), () {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) {
        return RattingDialogWidget();
      },
    );
  });
}
