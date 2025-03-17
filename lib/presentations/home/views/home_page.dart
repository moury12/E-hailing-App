import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/notification/views/notification_page.dart';
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_appbar.dart';
import '../widgets/bottom_sheets.dart';
import '../controllers/home_controller.dart';
import '../widgets/trip_details_card_widget.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );


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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Obx(() {
              return CustomAppBarForHomeWidget(
                onBack: () {
HomeController.to.handleBackNavigation();

                },
                onTap: () {
                  Get.toNamed(NotificationPage.routeName);
                },
                isBack:
                    HomeController.to.wantToGo.value ||
                    HomeController.to.setPickup.value ||HomeController.to.setDestination.value ||
                    HomeController.to.selectEv.value,
                actionIcon:
                    HomeController.to.wantToGo.value ||
                            HomeController.to.setPickup.value ||HomeController.to.setDestination.value ||
                            HomeController.to.selectEv.value
                        ? gpsWhiteIcon
                        : notificationIcon,
              );
            }),
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
              child:
                  Get.previousRoute == TripDetailsPage.routeName
                      ? TripDetailsCard()
                      :
    Obx(
      () {
        return HomeController.to.isLoadingNewTrip.value? TripRequestLoadingWidget() : Container(
          // margin: EdgeInsets.only(bottom: 83),
          decoration: BoxDecoration(
            color: AppColors.kLightGreyColor,
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
                    color:
                    AppColors
                        .kPrimaryColor, // Replace with your AppColors.kPrimaryColor
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                space12H,
                // Sheet content - replace with your conditional content
                Obx(() {
                  // Replace this with your actual implementation
                  if (HomeController.to.wantToGo.value) {
                    return HomeWantToGoContentWidget();
                  } else if (HomeController.to.setPickup.value) {
                    return HomeSetLocationWidget();
                  } else if (HomeController.to.setDestination.value) {
                    return HomeSetLocationWidget();
                  }else if (HomeController.to.selectEv.value) {
                    return HomeSelectEvWidget();
                  } else {
                    return HomeInitialContentWidget();
                  }
                }),

                // Add bottom padding for safe area
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      }
    )

            ),
          ),
        ),
      ],
    );
  }
}

