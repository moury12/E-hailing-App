import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/splash/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button_tap.dart';
import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../home/widgets/google_map_widget.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/nav_item_widget.dart';

class NavigationPage extends StatelessWidget {
  static const String routeName = '/nav';

  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final navController = NavigationController.to;

      int currentIndex = navController.currentNavIndex.value;
      double containerWidth = MediaQuery.of(context).size.width;
      double itemWidth =
          containerWidth / NavigationController.to.navList.length;
      double indicatorPosition =
          itemWidth * currentIndex + (itemWidth - 70.w) / 2 - 12.w;

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (currentIndex == 0) {
            if (!CommonController.to.isDriver.value) {
              final homeController = HomeController.to;
              if (!didPop) {
                homeController.handleBackNavigation();
              }
            } else {
              DashBoardController.to.handleBackNavigation();
            }
          } else {
            debugPrint('------------------');
            debugPrint(currentIndex.toString());
            navController.changeIndex(0);
            debugPrint(currentIndex.toString());
          }
        },
        child: Scaffold(
          appBar: () {
            if (currentIndex == 1) {
              return CustomAppBar(title: AppStaticStrings.myRides);
            }

            if (CommonController.to.isDriver.value) {
              if (currentIndex == 2) {
                return CustomAppBar(title: AppStaticStrings.statics);
              } else if (currentIndex == 3) {
                return CustomAppBar(title: AppStaticStrings.messages);
              }
            } else {
              if (currentIndex == 2) {
                return CustomAppBar(title: AppStaticStrings.messages);
              }
            }

            return null;
          }(),

          body: Stack(
            clipBehavior: Clip.none,
            children: [
              currentIndex == 0
                  ? CommonController.to.isDriver.value
                      ? GoogleMapWidgetForDriver()
                      : GoogleMapWidget()
                  : SizedBox.shrink(),
              IndexedStack(
                clipBehavior: Clip.none,
                index: currentIndex,
                children: navController.getPages(),
              ),
            ],
          ),
          bottomNavigationBar: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 80.w,
                padding: padding6H,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    NavigationController.to.navList.length,
                    (index) {
                      final nav = NavigationController.to.navList[index];
                      return Expanded(
                        child: Tooltip(
                          message: nav.title,
                          child: ButtonTapWidget(
                            onTap: () {
                              navController.changeIndex(index);
                            },
                            child: Padding(
                              padding: padding6H.copyWith(bottom: 6.w),
                              child: NavItem(nav: nav),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              AnimatedPositioned(
                left: indicatorPosition,
                duration: Duration(milliseconds: 200),
                child: Container(
                  margin: padding12H,
                  decoration: BoxDecoration(color: AppColors.kPrimaryColor),
                  height: 3.w,
                  width: 70.w,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
