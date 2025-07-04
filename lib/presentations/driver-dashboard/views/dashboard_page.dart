import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_refresh_indicator.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/widgets/after_destination_reached_widget.dart';
import 'package:e_hailing_app/presentations/notification/views/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_space.dart';
import '../../../core/constants/padding_constant.dart';
import '../widgets/no_new_ride_request_widget.dart';
import '../widgets/pick_up_card_widget.dart';
import '../widgets/pickup_started_widget.dart';
import '../widgets/ride_request_card_widget.dart';
import '../widgets/trip_start_widget.dart';
import '../widgets/trip_time_details_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  final double _dragThreshold = 0.2;
  double _dragDistance = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    offset = Tween<Offset>(
      begin: Offset(0.0, 0.9),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) {
      _isDragging = true;
      _dragDistance = 0.0;
    }

    _dragDistance += details.primaryDelta! / context.size!.height;
    controller.value = (controller.value - _dragDistance).clamp(0.0, 1.0);
    _dragDistance = 0.0;
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 500) {
      if (velocity > 0) {
        controller.reverse();
      } else {
        // Fast upward flick - open
        controller.forward();
      }
    } else {
      // Slower drag - check threshold
      if (controller.value < 1.0 - _dragThreshold) {
        // Close if we're below the threshold
        controller.reverse();
      } else {
        // Otherwise open
        controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () {
        return DashBoardController.to.getDriverCurrentTripRequest();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              CustomAppBarForHomeWidget(
                isDriver: true,
                onTap: () {
                  Get.toNamed(NotificationPage.routeName);
                },
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: SlideTransition(
                position: offset,
                child: Container(
                  // margin: EdgeInsets.only(bottom: 83),
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(34.r),
                    ),
                  ),
                  child: Padding(
                    padding: padding12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle indicator
                        Container(
                          height: 4.w,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: AppColors.kPrimaryColor,
                            // Replace with your AppColors.kPrimaryColor
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        space12H,
                        Obx(() {
                          DriverCurrentTripModel driverTrip =
                              DashBoardController.to.currentTrip.value;
                          DriverCurrentTripModel availableTrip =
                              DashBoardController.to.availableTrip.value;
                          return DashBoardController.to.findingRide.value
                              ? NoNewRideReqWidget()
                              : DashBoardController.to.rideRequest.value
                              ? RideRequestCardWidget(
                                userName: availableTrip.user?.name,
                                userImg:
                                    "${ApiService().baseUrl}/${availableTrip.user?.name}",

                                fare: availableTrip.estimatedFare.toString(),
                                dateTime: formatDateTime(
                                  availableTrip.createdAt ??
                                      AppStaticStrings.noDataFound,
                                ),
                                distance: availableTrip.distance.toString(),
                                fromAddress: availableTrip.pickUpAddress,
                                rideType: AppStaticStrings.rideReq,
                                toAddress: availableTrip.dropOffAddress,
                              )
                              : DashBoardController.to.afterAccepted.value ||
                                  DashBoardController.to.afterOnTheWay.value
                              ? DriverAfterAcceptedWidget(
                                user: driverTrip.user,
                                fare: driverTrip.estimatedFare.toString(),
                                tripId: driverTrip.sId,
                                fromAddress: driverTrip.pickUpAddress,
                                time: driverTrip.duration.toString(),
                              )
                              : DashBoardController.to.afterArrived.value
                              ? AfterArrivedPickupLocationWidget(
                                tripId: driverTrip.sId,
                              )
                              : DashBoardController.to.afterPickup.value
                              ? AfterPickedUpWidget(
                                tripId: driverTrip.sId,
                                fare: driverTrip.estimatedFare.toString(),
                                fromAddress: driverTrip.pickUpAddress,
                                toAddress: driverTrip.dropOffAddress,
                                user: driverTrip.user,
                                duration: driverTrip.duration.toString(),
                              )
                              : DashBoardController.to.afterTripStarted.value
                              ? AfterTripStartedWidget(
                                tripDistance: driverTrip.distance.toString(),
                                dropOffAddress: driverTrip.dropOffAddress,
                                pickUpAddress: driverTrip.pickUpAddress,
                                estimatedTime: driverTrip.duration.toString(),
                              )
                              : DashBoardController.to.sendPaymentReq.value
                              ? SendPaymentRequestWidget(
                                driverTripResponseModel: driverTrip,
                                tripId: driverTrip.sId.toString(),
                              )
                              : DashBoardController
                                  .to
                                  .afterDestinationReached
                                  .value
                              ? AfterDestinationReachedWidget()
                              : SizedBox.shrink();
                        }),
                        space12H,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
