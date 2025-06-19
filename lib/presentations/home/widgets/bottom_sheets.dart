import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/pickup_drop_location_widget.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/save-location/views/add_place_page.dart';
import 'package:e_hailing_app/presentations/save-location/views/saved_location_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:e_hailing_app/presentations/trip/views/request_trip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../navigation/controllers/navigation_controller.dart';
import '../../navigation/widgets/custom_container_with_border.dart';
import 'search_field_button_widget.dart';

class HomeSetLocationWidget extends StatelessWidget {
  const HomeSetLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        CustomText(
          text:
              HomeController.to.setDestination.value
                  ? AppStaticStrings.setYourDropOffLocation
                  : AppStaticStrings.setYourPickupLocation,
          style: poppinsSemiBold,
        ),
        Obx(() {
          return CustomWhiteContainerWithBorder(
            img: pickLocationIcon,
            text: NavigationController.to.placeName.value,
            cross: ButtonTapWidget(
              onTap: () {
                NavigationController.to.placeName.value = '';
              },
              child: Padding(
                padding: padding6,
                child: SvgPicture.asset(crossCircleIcon, height: 14.w),
              ),
            ),
          );
        }),
        CustomButton(
          onTap: () {
            if (!HomeController.to.setDestination.value) {
              HomeController.to.setDestination.value = true;
              HomeController.to.setPickup.value = false;
            } else {
              // HomeController.to.selectEv.value = false;
              HomeController.to.selectEv.value = true;
              HomeController.to.setDestination.value = false;
            }
          },
          title: AppStaticStrings.continueButton,
        ),
      ],
    );
  }
}

class HomeSelectEvWidget extends StatelessWidget {
  const HomeSelectEvWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        CustomText(text: AppStaticStrings.selectYourEv, style: poppinsSemiBold),
        ...List.generate(
          4,
          (index) =>
              index == 3
                  ? CarDetailsCardWidget(
                    onTap: () {
                      //   HomeController.to.resetAllStates();
                      //   HomeController.to.isLoadingNewTrip.value = true;
                      //   Future.delayed(Duration(seconds: 4), () {
                      //     HomeController.to.isLoadingNewTrip.value = false;
                      //     Get.toNamed(RequestTripPage.routeName);
                      //   });
                      // },
                      Get.toNamed(RequestTripPage.routeName);
                    },
                  )
                  : SelectCarITemWidget(
                    onTap: () {
                      // HomeController.to.resetAllStates();
                      // HomeController.to.isLoadingNewTrip.value = true;
                      // Future.delayed(Duration(seconds: 4), () {
                      //   HomeController.to.isLoadingNewTrip.value = false;
                      //   Get.toNamed(RequestTripPage.routeName);
                      // });

                      Get.toNamed(RequestTripPage.routeName);
                    },
                  ),
        ),
      ],
    );
  }
}

class HomeWantToGoContentWidget extends StatelessWidget {
  const HomeWantToGoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // spacing: 6.h,
      children: [
        CustomText(
          text: AppStaticStrings.selectDestination,
          style: poppinsSemiBold,
        ),
        space8H,
        Row(
          children: [
            Expanded(child: PickupDropLocationWidget()),
            FloatingActionButton.small(
              backgroundColor: AppColors.kPrimaryColor,
              foregroundColor: AppColors.kWhiteColor,
              onPressed: () async {
                if (HomeController.to.pickupLatLng.value != null &&
                    HomeController.to.dropoffLatLng.value != null) {
                  await CommonController.to.drawPolylineBetweenPoints(
                    HomeController.to.pickupLatLng.value!,
                    HomeController.to.dropoffLatLng.value!,
                    NavigationController.to.routePolylines,
                  );
                } else {
                  logger.d(HomeController.to.dropoffLatLng.value);
                  logger.d(HomeController.to.pickupLatLng.value);
                  showCustomSnackbar(
                    title: "Warning!!",
                    message: "Provide pickup drop off location both..",
                  );
                }
              },
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
        locationSuggestionList(),
        IconWithTextWidget(
          icon: setLocationIcon,
          text: AppStaticStrings.setLocationFromMap,
          onTap: () {
            debugPrint(HomeController.to.setPickup.value.toString());
            HomeController.to.wantToGo.value = false;
            HomeController.to.setPickup.value = true;
          },
        ),
        IconWithTextWidget(
          icon: savedPlaceIcon,
          text: AppStaticStrings.savedPlace,
          onTap: () {
            Get.toNamed(SavedLocationPage.routeName);
          },
        ),
      ],
    );
  }
}

Widget locationSuggestionList() {
  return Obx(() {
    if (CommonController.to.isLoadingOnLocationSuggestion.value) {
      return DefaultProgressIndicator(color: AppColors.kPrimaryColor);
    }

    if (CommonController.to.addressSuggestion.isEmpty) {
      return SizedBox.shrink();
    }

    // Determine which controller to update
    final isPickup = HomeController.to.activeField.value == "pickup";
    final controllerToUpdate =
        isPickup
            ? HomeController.to.pickupLocationController
            : HomeController.to.dropOffLocationController;

    return Column(
      children: List.generate(CommonController.to.addressSuggestion.length, (
        index,
      ) {
        final address = CommonController.to.addressSuggestion[index];
        return SearchAddress(
          title: address['description'],
          onTap: () async {
            final placeId = address['place_id'];
            await CommonController.to.getLatLngFromPlace(
              placeId,
              latLng:
                  isPickup
                      ? HomeController.to.pickupLatLng
                      : HomeController.to.dropoffLatLng,

              selectedAddress: HomeController.to.selectedAddress,
            );

            controllerToUpdate.value.text =
                HomeController.to.selectedAddress.value;
            CommonController.to.addressSuggestion.clear();

            HomeController.to.activeField.value = ''; // Reset
          },
        );
      }),
    );
  });
}

class IconWithTextWidget extends StatelessWidget {
  final String? icon;
  final String? text;
  final Widget? child;
  final Function()? onTap;

  const IconWithTextWidget({
    super.key,
    this.icon,
    this.text,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            spacing: 8.w,
            children: [
              SvgPicture.asset(icon ?? ''),
              child ?? CustomText(text: text ?? ''),
            ],
          ),
          Divider(color: AppColors.kGreyColor),
        ],
      ),
    );
  }
}

class HomeInitialContentWidget extends StatelessWidget {
  const HomeInitialContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6.h,
      children: [
        GestureDetector(
          onTap: () {
            debugPrint(HomeController.to.wantToGo.value.toString());
            HomeController.to.wantToGo.value = true;
          },
          child: SearchFieldButtonWidget(),
        ),

        CustomText(text: AppStaticStrings.service),

        // space8H,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12.w,
            children: [
              ServiceWidget(
                title: AppStaticStrings.generalRide,
                img: purpleCarImage,
                onTap: () {
                  HomeController.to.wantToGo.value = true;
                },
              ),
              ServiceWidget(
                onTap: () {
                  HomeController.to.setPickup.value = true;
                },
                title: AppStaticStrings.preBookRide,
                img: purpleCarImage,
              ),
              ServiceWidget(
                onTap: () {
                  showComingSoonDialog(context);
                  // HomeController.to.setPickup.value = true;
                },
                title: AppStaticStrings.womanOnlyRide,
                img: purpleCarImage,
              ),
            ],
          ),
        ),
        space8H,
      ],
    );
  }
}

class ServiceWidget extends StatelessWidget {
  final String title;
  final String img;
  final Function()? onTap;

  const ServiceWidget({
    super.key,
    required this.title,
    required this.img,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomWhiteContainerWithBorder(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(img, height: 40.sp),
          CustomText(text: title, style: poppinsSemiBold, fontSize: 10.sp),
        ],
      ),
    );
  }
}
