import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/components/custom_timeline.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';

class PickupDropLocationWidget extends StatefulWidget {
  const PickupDropLocationWidget({super.key});

  @override
  State<PickupDropLocationWidget> createState() =>
      _PickupDropLocationWidgetState();
}

class _PickupDropLocationWidgetState extends State<PickupDropLocationWidget> {
  @override
  void initState() {
    if (HomeController.to.pickupLocationController.value.text.isEmpty) {
      HomeController.to.setCurrentLocationOnPickUp();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTimeline(
      padding: EdgeInsets.zero,
      indicators: <Widget>[
        SvgPicture.asset(pickLocationIcon),
        SvgPicture.asset(dropLocationIcon),
      ],
      children: <Widget>[
        Obx(() {
          return CustomTextField(
            borderRadius: 24.r,
            hintText: AppStaticStrings.pickupLocation,
            fillColor: AppColors.kWhiteColor,
            borderColor: AppColors.kGreyColor,
            onTap: () {
              // Future.delayed(Duration(milliseconds: 50), () {
              //   FocusScope.of(
              //     context,
              //   ).requestFocus(HomeController.to.pickupFocusNode);
              // });
              HomeController.to.activeField.value = "pickup";
              // // FocusScope.of(context).unfocus();
              // HomeController.to.pickupFocusNode.requestFocus(); // 👈 Add this
            },
            // height: 45.h,
            onChanged: (v) {
              HomeController.to.activeField.value = "pickup";
              CommonController.to.fetchSuggestedPlacesWithRadius(v);
            },

            textEditingController:
                HomeController.to.pickupLocationController.value,
            suffixIcon: ButtonTapWidget(
              onTap: () {
                HomeController.to.pickupLocationController.value.clear();
                HomeController.to.pickupLatLng.value = null;
                CommonController.to.isLoadingOnLocationSuggestion.value=false;
                CommonController.to.addressSuggestion.clear();
              },
              child: Padding(
                padding: padding12,
                child: SvgPicture.asset(crossCircleIcon),
              ),
            ),
          );
        }),

        Obx(() {
          return CustomTextField(
            // focusNode: HomeController.to.dropOffFocusNode,
            borderRadius: 24.r,
            onTap: () {
              // FocusScope.of(context).unfocus();
              HomeController.to.activeField.value = "dropoff";
              // Future.delayed(Duration(milliseconds: 50), () {
              //   FocusScope.of(
              //     context,
              //   ).requestFocus(HomeController.to.dropOffFocusNode);
              // });
            },
            hintText: AppStaticStrings.dropLocation,
            fillColor: AppColors.kWhiteColor,
            borderColor: AppColors.kGreyColor,
            textEditingController:
                HomeController.to.dropOffLocationController.value,
            // height: 45.h,
            onChanged: (v) {
              HomeController.to.activeField.value = "dropoff";
              CommonController.to.fetchSuggestedPlacesWithRadius(v);
            },
            suffixIcon: ButtonTapWidget(
              onTap: () {
                HomeController.to.dropOffLocationController.value.clear();
                HomeController.to.dropoffLatLng.value = null;
                CommonController.to.isLoadingOnLocationSuggestion.value=false;
                CommonController.to.addressSuggestion.clear();
              },
              child: Padding(
                padding: padding12,
                child: SvgPicture.asset(crossCircleIcon),
              ),
            ),
          );
        }),
      ],
    );
  }
}
