import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/presentations/navigation/widgets/google_map_widget.dart';
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
  Animation<Offset>? offset;

  @override
  void initState() {
    super.initState();
    HomeController.to.controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    offset = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(HomeController.to.controller!);
    HomeController.to.controller!.forward();
  }

  @override
  void dispose() {
    HomeController.to.controller!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GoogleMapWidget(),
        Column(
          children: [
            Obx(() {
              return CustomAppBarForHomeWidget(
                onBack: () {
                  debugPrint(Get.previousRoute);
                   if(Get.previousRoute==TripDetailsPage.routeName){
                  Get.back();
                  }
                  else if (HomeController.to.wantToGo.value) {
                    HomeController.to.wantToGo.value = false;
                  } else if (HomeController.to.setPickup.value) {
                    HomeController.to.setPickup.value = false;
                    HomeController.to.wantToGo.value = true;
                  } else if (HomeController.to.selectEv.value) {
                    HomeController.to.selectEv.value = false;
                    HomeController.to.setPickup.value = true;
                  }
                  else {
                    HomeController.to.wantToGo.value = false;
                    HomeController.to.setPickup.value = false;

                  }
                },
                isBack:
                    HomeController.to.wantToGo.value ||
                    HomeController.to.setPickup.value||
                    HomeController.to.selectEv.value,
                actionIcon:
                    HomeController.to.wantToGo.value ||
                            HomeController.to.setPickup.value||
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
          child:   Get.previousRoute==TripDetailsPage.routeName?
              TripDetailsCard()
              : GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 0) {
                // Dragging down
                HomeController.to.controller?.reverse();
              } else if (details.primaryDelta! < 0) {
                // Dragging up
                HomeController.to.controller?.forward();
              }
            },
            onVerticalDragEnd: (details) {
              if (HomeController.to.controller!.status ==
                  AnimationStatus.completed) {
                // If animation is completed (sheet fully up), keep it open
                HomeController.to.controller?.forward();
              } else if (HomeController.to.controller!.status ==
                  AnimationStatus.dismissed) {
                HomeController.to.controller?.reverse();
              }
            },
            child: SlideTransition(
              position: offset!,

              child: Obx(() {
                return Container(
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
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.kPrimaryColor,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          height: 4.w,
                          width: 26.w,
                        ),
                        space12H,
                     
                        HomeController.to.wantToGo.value
                            ? HomeWantToGoContentWidget()
                            : HomeController.to.setPickup.value
                            ? HomeSetLocationWidget()
                            : HomeController.to.selectEv.value
                            ? HomeSelectEvWidget()
                            : HomeInitialContentWidget(),
                      ],
                    ),
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



