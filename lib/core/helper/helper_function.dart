import 'dart:async';
import 'dart:io';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
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
import 'package:e_hailing_app/presentations/message/views/chatting_page.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../presentations/payment/widgets/ratting_dialog_widget.dart';
import '../../presentations/trip/widgets/trip_cancellation_reason_card_item.dart';

launchGoogleMapsApp(
  String startLatitude,
  String startLongitude,
  String endLatitude,
  String endLongitude,
) async {
  if (Platform.isIOS) {
    // iOS uses comgooglemaps scheme
    final Uri iosUri = Uri.parse(
      'comgooglemaps://?saddr=$startLatitude,$startLongitude&daddr=$endLatitude,$endLongitude&directionsmode=driving',
    );
    final Uri iosFallback = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude&travelmode=driving',
    );

    if (await canLaunchUrl(iosUri)) {
      await launchUrl(iosUri);
    } else {
      await launchUrl(iosFallback, mode: LaunchMode.externalApplication);
    }
  } else if (Platform.isAndroid) {
    // Android uses geo intent
    final Uri androidUri = Uri.parse(
      'google.navigation:q=$endLatitude,$endLongitude&mode=d',
    );

    if (await canLaunchUrl(androidUri)) {
      await launchUrl(androidUri, mode: LaunchMode.externalApplication);
    } else {
      // fallback to web
      final Uri fallback = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude&travelmode=driving',
      );
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }
}

Future<dynamic> tripCancellationDialog(
  BuildContext context, {
  Function()? onSubmit,
  bool? isLoading,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.kWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        title: CustomText(
          text: AppStaticStrings.tripCancellationTitle.tr,
          style: poppinsSemiBold.copyWith(
            color: AppColors.kTextDarkBlueColor,
            fontSize: getFontSizeExtraLarge(),
          ),
        ),
        titlePadding: padding12.copyWith(bottom: 0),
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: AppColors.kLightBlackColor),
              ...List.generate(
                CommonController.to.tripCancellationList.length,
                (index) => TripCancellationReasonCardItem(index: index),
              ),
              Padding(
                padding: padding12,
                child: CustomButton(
                  isLoading: isLoading,
                  onTap:
                      onSubmit ??
                      () {
                        Navigator.pop(context);
                      },
                  title: AppStaticStrings.submit.tr,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> launchEmail(String toEmail, {String subject = ""}) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: toEmail,
    query: 'subject=$subject',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $emailUri';
  }
}

Future<void> launchWhatsApp(String phoneNumber, {String message = ""}) async {
  final Uri whatsappUri = Uri.parse(
    "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
  );

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $whatsappUri';
  }
}

Future<void> launchWebsite(String url) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // ✅ opens in browser
    );
  } else {
    throw Exception("Could not launch $url");
  }
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

void handleNotificationTap(Map<String, dynamic> data) {
  logger.d(data);
  if (data.containsKey('chatId')) {
    final chatId = data['chatId'];
    Get.toNamed(ChattingPage.routeName, arguments: chatId);
  } else {
    Get.toNamed(NavigationPage.routeName);
  }
}

// Function to dismiss the loading dialog
void dismissLoadingDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
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

void removeImage({
  required RxList<String> uploadImages,
  required String imagePath,
}) {
  if (uploadImages.contains(imagePath)) {
    uploadImages.remove(imagePath);
  } else {
    debugPrint("Image not found in the list.");
  }
}

final ImagePicker _picker = ImagePicker();

Future<void> pickImages({
  bool allowMultiple = false,
  RxList<String>? uploadImages,
  RxString? singleImagePath,
  int imageQuality = 50, // quality from 0-100
}) async {
  try {
    if (allowMultiple && uploadImages != null) {
      // Pick multiple images
      final List<XFile>? images = await _picker.pickMultiImage(
        imageQuality: imageQuality,
      );

      if (images != null && images.isNotEmpty) {
        final selectedPaths = images.map((xfile) => xfile.path).toList();

        if (uploadImages.length + selectedPaths.length <= 5) {
          uploadImages.addAll(selectedPaths);
        } else {
          // showCustomSnackbar(
          //   title: "Limit Reached",
          //   message: "You can only add up to 5 images.",
          //   type: SnackBarType.alert,
          // );
          debugPrint("Image limit reached");
        }
      } else {
        debugPrint("No images selected.");
      }
    } else if (!allowMultiple && singleImagePath != null) {
      // Pick a single image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );

      if (image != null) {
        singleImagePath.value = image.path;
      } else {
        debugPrint("No image selected.");
      }
    } else {
      debugPrint("Improper usage of the method.");
    }
  } catch (e) {
    debugPrint("Image picker error: $e");
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
    await Get.dialog(
      Builder(
        builder:
            (dialogContext) => AlertDialog(
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
                            title: AppStaticStrings.cancel.tr,
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ),

                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              AuthController.to.emailLoginController.text =
                                  credentials['email'];
                              AuthController.to.passLoginController.text =
                                  credentials['password'];

                              Navigator.of(dialogContext).pop();
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

enum SnackBarType { success, failed, alert, info }

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
      backgroundColor = Color(0xffffd9b9);
      textColor = Colors.black;
      break;
    case SnackBarType.info:
      backgroundColor = Color(0xffaad6ff);
      textColor = Colors.black;
      break;
    // TODO: Handle this case.
  }
  // Use Fluttertoast for better reliability on iOS
  Fluttertoast.showToast(
    msg: "$title: $message",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 14.sp,
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
  try {
    // Attempt to launch directly as sometimes canLaunchUrl fails on certain environments
    final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw 'Could not launch $url';
    }
  } catch (e) {
    debugPrint('Error launching phone call: $e');
    // Fallback or better error message
    throw 'Failed to initiate call to $phoneNumber. Make sure a phone app is available.';
  }
}

void showRatingDialogs({required String carId}) {
  Get.dialog(RattingDialogWidget(carID: carId), barrierDismissible: false).then(
    (_) {
      // Called when the dialog is popped
      Boxes.getRattingData().delete("rating");
    },
  );
}

Future<String?> pickDateTime(BuildContext context) async {
  // Pick Date
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate == null) return null;

  // Pick Time
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime == null) return null;

  // Combine and return ISO string
  final dateTime = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );

  return dateTime.toIso8601String();
}
