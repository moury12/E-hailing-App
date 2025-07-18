import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/hive_boxes.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/auth/controllers/auth_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/gradient_progress_indicator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../presentations/payment/widgets/ratting_dialog_widget.dart';
import '../../presentations/trip/widgets/trip_cancellation_reason_card_item.dart';
import '../utils/google_map_api_key.dart';

Future<dynamic> tripCancellationDialog({Function()? onSubmit}) {
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
            onTap:
                onSubmit ??
                () {
                  Get.back();
                },
            title: AppStaticStrings.submit,
          ),
        ),
      ],
    ),
  );
}

void showLoadingDialog({required String text}) {
  Get.dialog(
    barrierDismissible: false, // User must wait for data
    AlertDialog(
      content: Column(
        spacing: 8.h,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(text: text, fontSize: getFontSizeDefault()),
          GradientProgressIndicator(),
        ],
      ),
    ),
  );
}

// Function to dismiss the loading dialog
void dismissLoadingDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

Future<String> getEstimatedTime({
  required double pickupLat,
  required double pickupLng,
  required double dropOffLat,
  required double dropOffLng,
}) async {
  final url =
      'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLat,$pickupLng&destinations=$dropOffLat,$dropOffLng&key=${GoogleClient.googleMapUrl}';

  logger.d(url);
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['rows'] != null &&
          data['rows'].isNotEmpty &&
          data['rows'][0]['elements'] != null &&
          data['rows'][0]['elements'].isNotEmpty &&
          data['rows'][0]['elements'][0]['status'] == 'OK') {
        final duration = data['rows'][0]['elements'][0]['duration']['text'];
        return duration;
      } else {
        throw Exception("No duration found or invalid coordinates");
      }
    } else {
      throw Exception(
        "Failed: ${response.statusCode} ${response.reasonPhrase}",
      );
    }
  } catch (e) {
    throw Exception("Error getting estimated time: $e");
  }
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

Future<void> pickImages({
  bool allowMultiple = false,
  RxList<String>? uploadImages,
  RxString? singleImagePath,
  FileType fileType = FileType.image,
}) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: fileType, // Restrict to image files
      allowMultiple: allowMultiple,
      compressionQuality: 50, // Allow multiple selection
    );

    if (result != null) {
      final selectedPaths = result.paths.whereType<String>().toList();

      if (allowMultiple && uploadImages != null) {
        if (uploadImages.length + selectedPaths.length <= 5) {
          uploadImages.addAll(selectedPaths); // Add selected images to the list
        } else {
          // showCustomSnackbar(
          //   title: "Limit Reached",
          //   message: "You can only add up to 5 images.",
          //   type: SnackBarType.alert,
          // );
        }
      } else if (!allowMultiple && singleImagePath != null) {
        singleImagePath.value = result.files.single.path ?? '';
      } else {
        debugPrint("No files selected or improper usage of the method.");
      }
    } else {
      debugPrint("No files selected.");
    }
  } catch (e) {
    debugPrint("File picker error: $e");
  }
}

Future<void> preloadImagesFromUrls(List<String> imageUrls) async {
  for (var imageUrl in imageUrls) {
    if (imageUrl.isNotEmpty) {
      try {
        final imageProvider = CachedNetworkImageProvider(
          "${ApiService().baseUrl}/$imageUrl",
        );
        final completer = Completer<void>();
        bool isCompleted = false;

        imageProvider
            .resolve(const ImageConfiguration())
            .addListener(
              ImageStreamListener(
                (_, __) {
                  if (!isCompleted) {
                    completer.complete();
                    isCompleted = true;
                  }
                },
                onError: (error, stackTrace) {
                  if (!isCompleted) {
                    debugPrint("Error caching URL: $imageUrl / $error");
                    completer.complete();
                    isCompleted = true;
                  }
                },
              ),
            );

        await completer.future;
      } catch (e) {
        debugPrint("Exception while caching URL: $imageUrl / $e");
      }
    }
  }
}

Future<void> showCredentialsDialog() async {
  final credentials = await getCredentials();

  if (credentials.isNotEmpty && credentials['rememberMe'] == true) {
    Get.dialog(
      AlertDialog(
        content: SizedBox(
          width: Get.width * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                textAlign: TextAlign.center,
                text: 'Email: ${credentials['email']}',
                color: AppColors.kExtraLightTextColor,
                fontSize: getFontSizeSemiSmall(),
              ),
              CustomText(
                textAlign: TextAlign.center,
                text:
                    'Password: ${'•' * (credentials['password']?.length ?? 0)}',
                color: AppColors.kExtraLightTextColor,
                fontSize: getFontSizeSemiSmall(),
              ),
              space8H,
              Row(
                spacing: 8.w,
                children: [
                  Expanded(
                    child: CustomButton(
                      textColor: AppColors.kPrimaryColor,
                      fillColor: Colors.transparent,
                      onTap: () => Get.back(),
                      title: AppStaticStrings.cancel.tr,
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        AuthController.to.emailLoginController.text =
                            credentials['email'];
                        AuthController.to.passLoginController.text =
                            credentials['password'];

                        Get.back();
                      },
                      title: AppStaticStrings.confirm.tr,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}

void showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.h,
            children: <Widget>[
              CustomText(text: 'Feature Coming Soon!', style: poppinsBold),
              CustomText(
                text:
                    'This feature is not yet implemented.Please check back in a future update!',

                style: poppinsRegular,
                color: AppColors.kExtraLightTextColor,
              ),

              CustomButton(
                onTap: () {
                  Navigator.pop(context);
                },
                title: "OK",
                // width: ScreenUtil().screenWidth / 3,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> saveCredentials(
  String email,
  String password,
  bool rememberMe,
) async {
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
  SnackPosition position = SnackPosition.TOP, // Default position
}) {
  Color backgroundColor = AppColors.kWhiteColor;
  Color textColor = Colors.black;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = AppColors.kWhiteColor;

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

String formatDateTime(String input) {
  try {
    final utcDate = DateTime.parse(input); // Parse the ISO string
    final localDate = utcDate.toLocal(); // Convert to local timezone

    final datePart = DateFormat('dd MMM yyyy').format(localDate);
    final timePart = DateFormat('hh:mm a').format(localDate);

    return '$datePart at $timePart';
  } catch (e) {
    return 'Invalid date';
  }
}

bool isTodayFunction(String isoDateString) {
  final date = DateTime.parse(isoDateString).toLocal();
  final now = DateTime.now();

  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

String formatTime(String input) {
  try {
    final utcDate = DateTime.parse(input); // Parse the ISO string
    final localDate = utcDate.toLocal(); // Convert to local timezone

    // final datePart = DateFormat('dd MMM yyyy').format(localDate);
    final timePart = DateFormat('hh:mm a').format(localDate);

    return timePart;
  } catch (e) {
    return 'Invalid date';
  }
}

String formatDate(String input) {
  try {
    final utcDate = DateTime.parse(input); // Parse the ISO string
    final localDate = utcDate.toLocal(); // Convert to local timezone

    final datePart = DateFormat('dd MMM yyyy').format(localDate);

    return datePart;
  } catch (e) {
    return 'Invalid date';
  }
}

void callOnPhone({required String phoneNumber}) async {
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
            Padding(padding: padding16V, child: GradientProgressIndicator()),
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
