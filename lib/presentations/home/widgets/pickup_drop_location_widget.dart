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
  final bool? isDisable;
  const PickupDropLocationWidget({super.key, this.isDisable= false});

  @override
  State<PickupDropLocationWidget> createState() =>
      _PickupDropLocationWidgetState();
}

class _PickupDropLocationWidgetState extends State<PickupDropLocationWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (HomeController.to.pickupLocationController.value.text.isEmpty) {
        HomeController.to.setCurrentLocationOnPickUp();
      }
    });
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
            isEnable: widget.isDisable==true? false: true,
            borderRadius: 24.r,
            hintText: AppStaticStrings.pickupLocation.tr,
            fillColor: AppColors.kWhiteColor,
            borderColor: AppColors.kGreyColor,
            // height: 45.h,

            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                HomeController.to.activeField.value = "pickup";
              });
            },
              onChanged: (v) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  HomeController.to.activeField.value = "pickup";
                  HomeController.to.debouncePickupLocation(v);
                });},

            textEditingController:
                HomeController.to.pickupLocationController.value,
            suffixIcon:widget.isDisable==false? ButtonTapWidget(
              onTap: () {
                HomeController.to.pickupLocationController.value.clear();
                HomeController.to.pickupLatLng.value = null;
                CommonController.to.isLoadingOnLocationSuggestion.value=false;
                CommonController.to.addressSuggestion.clear();
              },
              child: Padding(
                padding: padding12,
                child: SvgPicture.asset(crossCircleIcon,height: 10,),
              ),
            ):SizedBox.shrink(),
          );
        }),

        Obx(() {
          return CustomTextField(
            isEnable: widget.isDisable==true? false: true,
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
            hintText: AppStaticStrings.dropLocation.tr,
            fillColor: AppColors.kWhiteColor,
            borderColor: AppColors.kGreyColor,
            textEditingController:
                HomeController.to.dropOffLocationController.value,
            // height: 45.h,
            onChanged: (v) {
              HomeController.to.activeField.value = "dropoff";
              HomeController.to.debounceDropoffLocation(v);
            },
            suffixIcon:widget.isDisable==false? ButtonTapWidget(
              onTap: () {
                HomeController.to.dropOffLocationController.value.clear();
                HomeController.to.dropoffLatLng.value = null;
                CommonController.to.isLoadingOnLocationSuggestion.value=false;
                CommonController.to.addressSuggestion.clear();
              },
              child: Padding(
                padding: padding12,
                child: SvgPicture.asset(crossCircleIcon,height: 10,),
              ),
            ):SizedBox.shrink(),
          );
        }),
      ],
    );
  }
}
