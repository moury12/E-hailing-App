import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/navigation/controllers/navigation_controller.dart';
import 'package:e_hailing_app/presentations/track-ride/controllers/track_ride_controller.dart';
import 'package:e_hailing_app/presentations/trip/views/trip_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../home/widgets/google_map_widget.dart';

class TrackRidePage extends StatefulWidget {
  const TrackRidePage({super.key});

  @override
  State<TrackRidePage> createState() => _TrackRidePageState();
}

class _TrackRidePageState extends State<TrackRidePage>
    with TickerProviderStateMixin {
  late AnimationController controllerForTrackRide;
  late Animation<Offset> offset;

  final double _dragThreshold = 0.2;
  double _dragDistance = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    controllerForTrackRide = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    offset = Tween<Offset>(begin: Offset(0.0, 0.9), end: Offset.zero).animate(
      CurvedAnimation(parent: controllerForTrackRide, curve: Curves.easeOut),
    );

    controllerForTrackRide.forward();
  }

  @override
  void dispose() {
    controllerForTrackRide.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) {
      _isDragging = true;
      _dragDistance = 0.0;
    }

    _dragDistance += details.primaryDelta! / context.size!.height;
    controllerForTrackRide
        .value = (controllerForTrackRide.value - _dragDistance).clamp(0.0, 1.0);
    _dragDistance = 0.0;
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 500) {
      if (velocity > 0) {
        controllerForTrackRide.reverse();
      } else {
        // Fast upward flick - open
        controllerForTrackRide.forward();
      }
    } else {
      // Slower drag - check threshold
      if (controllerForTrackRide.value < 1.0 - _dragThreshold) {
        // Close if we're below the threshold
        controllerForTrackRide.reverse();
      } else {
        // Otherwise open
        controllerForTrackRide.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            CustomAppBarForHomeWidget(
              isBack: true,
              actionIcon: gpsWhiteIcon,
              onBack: () {
                NavigationController.to.changeIndex(0);
              },
              onTap: () {},
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
              child: Obx(() {
                return TrackRideController.to.isDestination.value
                    ? TripDetailsDestinationCard()
                    : Container(
                  margin: padding12,
                      padding: padding16,

                      decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kExtraLightTextColor.withValues(
                              alpha: .5,
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        spacing: 12.w,
                        children: [
                          SvgPicture.asset(carPrimaryIcon),
                          CustomText(
                            text: 'There are currently no active trips.',
                          ),
                          CustomButton(
                            onTap: () {
                              TrackRideController.to.isDestination.value=true;
                            },
                            title: AppStaticStrings.bookATrip,
                          ),
                        ],
                      ),
                    );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
