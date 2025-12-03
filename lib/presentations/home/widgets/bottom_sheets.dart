import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/pagination_loading_widget.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/location-service/location_service.dart';
import 'package:e_hailing_app/core/utils/enum.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/pickup_drop_location_widget.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/save-location/views/add_place_page.dart';
import 'package:e_hailing_app/presentations/save-location/views/saved_location_page.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../navigation/controllers/navigation_controller.dart';
import '../../navigation/widgets/custom_container_with_border.dart';
import '../../trip/views/request_trip_page.dart';
import 'search_field_button_widget.dart';

class HomeSetLocationWidget extends StatefulWidget {
  const HomeSetLocationWidget({super.key});

  @override
  State<HomeSetLocationWidget> createState() => _HomeSetLocationWidgetState();
}

class _HomeSetLocationWidgetState extends State<HomeSetLocationWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeController.to.mapDraging.value = true;
      HomeController.to.pickupLatLng.value =
          CommonController.to.markerPositionRider.value;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeController.to.mapDraging.value = false;
    });
    super.dispose();
  }

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
            text:
                HomeController.to.setDestination.value
                    ? HomeController.to.dropoffAddressText.value
                    : HomeController.to.pickupAddressText.value,
            cross: ButtonTapWidget(
              onTap: () {
                if (HomeController.to.setDestination.value) {
                  HomeController.to.dropOffLocationController.value.clear();
                  HomeController.to.dropoffAddressText.value = "";
                  HomeController.to.dropoffLatLng.value = null;
                } else {
                  HomeController.to.pickupLocationController.value.clear();
                  HomeController.to.pickupAddressText.value = "";
                  HomeController.to.pickupLatLng.value = null;
                }
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
            logger.d(HomeController.to.pickupLocationController.value.text);

            if (!HomeController.to.setDestination.value) {
              HomeController.to.setDestination.value = true;
              HomeController.to.setPickup.value = false;
              HomeController.to.dropoffLatLng.value = LocationTrackingService().offsetByDistance(CommonController.to.markerPositionRider.value,
                  1.0, 90);
            } else {

              HomeController.to.wantToGo.value = true;
              HomeController.to.setDestination.value = false;
            }
          },
          title: AppStaticStrings.continueButton,
        ),
        space8H,
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
        // CarDetailsCardWidget(
        //   onTap: () {
        //     //   HomeController.to.resetAllStates();
        //     //   HomeController.to.isLoadingNewTrip.value = true;
        //     //   Future.delayed(Duration(seconds: 4), () {
        //     //     HomeController.to.isLoadingNewTrip.value = false;
        //     //     Get.toNamed(RequestTripPage.routeName);
        //     //   });
        //     // },
        //     Get.toNamed(RequestTripPage.routeName);
        //   },
        // ),
        Obx(() {
          return SelectCarITemWidget(
            fare: HomeController.to.estimatedFare.value,
            onTap: () async {
              // HomeController.to.resetAllStates();
              // await Future.delayed(const Duration(seconds: 3));
              Get.toNamed(
                RequestTripPage.routeName,
                arguments: HomeController.to.tripArgs,
              );
            },
          );
        }),
        space12H,
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
            Obx(() {
              return FloatingActionButton.small(
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: AppColors.kWhiteColor,
                onPressed:
                    HomeController.to.isLoadingPostFair.value
                        ? null
                        : () async {
                          // Clear focus first to prevent refocusing issues
                          HomeController.to.clearAllFocus();
                          FocusScope.of(context).unfocus();

                          // Validate both locations are selected
                          if (HomeController.to.pickupLatLng.value == null ||
                              HomeController.to.dropoffLatLng.value ==
                                  null /*||
                    HomeController.to.distance.value == 0 ||
                    HomeController.to.duration.value == 0*/ ) {
                            logger.d(
                              "Pickup: ${HomeController.to.pickupLatLng.value}",
                            );
                            logger.d(
                              "Dropoff: ${HomeController.to.dropoffLatLng.value}",
                            );

                            showCustomSnackbar(
                              title: "Warning!!",
                              message:
                                  "Please select both pickup and drop-off locations.",
                            );
                            return;
                          }

                          final pickup = HomeController.to.pickupLatLng.value!;
                          final dropoff =
                              HomeController.to.dropoffLatLng.value!;

                          // Check if we need to draw/redraw polyline
                          bool needsPolylineUpdate =
                              !HomeController.to.isPolylineDrawn.value ||
                              HomeController.to.lastPickupLatLng != pickup ||
                              HomeController.to.lastDropoffLatLng != dropoff;

                          if (needsPolylineUpdate) {
                            // Show loading indicator
                            showCustomSnackbar(
                              title: "Please wait...",
                              message: "Finding the best route for you.",
                            );
                            final locationService = LocationTrackingService();

                            bool polylineSuccess = await locationService
                                .drawPolylineBetweenPoints(
                                  pickup,
                                  dropoff,
                                  NavigationController.to.routePolylines,
                                  distance: HomeController.to.distance,
                                  duration: HomeController.to.duration,
                                  userPosition:
                                      CommonController
                                          .to
                                          .markerPositionRider
                                          .value,
                                  mapController:
                                      CommonController.to.mapControllerRider,
                              type: PolylineType.pickupToDropoff,
                                );

                            if (polylineSuccess) {
                              // Update cache only on success
                              HomeController.to.lastPickupLatLng = pickup;
                              HomeController.to.lastDropoffLatLng = dropoff;
                              HomeController.to.isPolylineDrawn.value = true;
                              HomeController.to.tripArgs = {
                                "pickUpAddress":
                                    HomeController
                                        .to
                                        .pickupLocationController
                                        .value
                                        .text,
                                "pickUpLat": pickup.latitude,
                                "pickUpLong": pickup.longitude,
                                "dropOffAddress":
                                    HomeController.to.dropOffLocationController.value.text,
                                "dropOffLat": dropoff.latitude,
                                "dropOffLong": dropoff.longitude,
                                "duration": HomeController.to.duration.value,
                                "tripType":HomeController.to.tripType.value,
                                "distance": HomeController.to.distance.value,

                                // "coupon" will be added later from RequestTripPage
                              };
                              await HomeController.to.getTripFare(
                                duration: HomeController.to.duration.value,
                                distance: HomeController.to.distance.value,
                              );

                              HomeController.to.goToSelectEv();
                              // Navigate to request trip page after successful polyline draw
                              // await Future.delayed(const Duration(seconds: 3));
                              // Get.toNamed(
                              //   RequestTripPage.routeName,
                              //   arguments: HomeController.to.tripArgs,
                              // );
                            } else {
                              // Don't navigate if polyline failed
                              showCustomSnackbar(
                                title: "Unable to proceed",
                                message:
                                    "Please try selecting different locations or check your internet connection.",
                              );
                            }
                          } else {
                            await HomeController.to.getTripFare(
                              duration: HomeController.to.duration.value,
                              distance: HomeController.to.distance.value,
                            );

                            HomeController.to.goToSelectEv();

                            // // Polyline already exists and locations haven't changed
                            // Get.toNamed(
                            //   RequestTripPage.routeName,
                            //   arguments: HomeController.to.tripArgs,
                            // );
                          }
                        },
                shape: const CircleBorder(),
                child:
                    HomeController.to.isLoadingPostFair.value
                        ? PaginationLoadingWidget(color: AppColors.kWhiteColor)
                        : const Icon(Icons.arrow_forward),
              );
            }),
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
            Get.toNamed(SavedLocationPage.routeName, arguments: fromHome);
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
          title: address['name'],
          onTap: () async {
            // final locationService = LocationTrackingService();
            double lat = address['lat'];
            double lng = address['lng'];
            if (isPickup) {
              HomeController.to.pickupLatLng.value = LatLng(lat, lng);
            } else {
              HomeController.to.dropoffLatLng.value = LatLng(lat, lng);
            }
            HomeController.to.selectedAddress.value =
            address['name'];
            // await locationService.getLatLngFromPlace(
            //   placeId,
            //   latLng:
            //   isPickup
            //       ? HomeController.to.pickupLatLng
            //       : HomeController.to.dropoffLatLng,
            //
            //   selectedAddress: HomeController.to.selectedAddress,
            // );

            controllerToUpdate.value.text =
                HomeController.to.selectedAddress.value;
            CommonController.to.addressSuggestion.clear();

            HomeController.to.activeField.value = ''; // Reset
            // HomeController.to.dropOffFocusNode.unfocus();
            // HomeController.to.pickupFocusNode.unfocus();
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
        SearchFieldButtonWidget(
          onTap: () {
            debugPrint(HomeController.to.wantToGo.value.toString());
            HomeController.to.tripType.value="ride";

            HomeController.to.wantToGo.value = true;
          },
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
                img: purpleCarImage2,
                onTap: () {

                  HomeController.to.wantToGo.value = true;
                  HomeController.to.tripType.value="ride";

                },
              ),
              ServiceWidget(
                onTap: () {
                  HomeController.to.wantToGo.value = true;
                  HomeController.to.tripType.value=preBook;
                },
                title: AppStaticStrings.preBookRide,
                img: purpleCarImage2,
              ),
              ServiceWidget(
                backgroundColor: Colors.grey.shade400,
                onTap: () {
                  showComingSoonDialog(context);
                  // HomeController.to.setPickup.value = true;
                },
                title: AppStaticStrings.womanOnlyRide,
                img: purpleCarImage2,
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
  final Color? backgroundColor;

  const ServiceWidget({
    super.key,
    required this.title,
    required this.img,
    this.onTap, this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomWhiteContainerWithBorder(
      backgroundColor: backgroundColor,
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(img, height:50.sp),
          space6H,
          CustomText(text: title, style: poppinsSemiBold, fontSize: 10.sp),
        ],
      ),
    );
  }
}
