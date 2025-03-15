import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button_tap.dart';
import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../../core/utils/variables.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/nav_item_widget.dart';

class NavigationPage extends StatelessWidget {
  static const String routeName = '/nav';
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final navController = NavigationController.to;
      final homeController = HomeController.to;
      final currentIndex = navController.currentNavIndex.value;
      double containerWidth = MediaQuery.of(context).size.width;
      double itemWidth = containerWidth / navList.length;
      double indicatorPosition =
          itemWidth * currentIndex + (itemWidth - 70.w) / 2 - 12.w;

      return Scaffold(
        appBar:
            currentIndex == 1
                ? CustomAppBar(title: AppStaticStrings.myRides)
                : currentIndex == 3
                ? CustomAppBar(title: AppStaticStrings.messages)
                : null,
        body: IndexedStack(
          clipBehavior: Clip.none,
          index: currentIndex,
          children: navController.getPages(),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(navList.length, (index) {
                  final nav = navList[index];
                  return Expanded(
                    child: Tooltip(
                      message: nav.title,
                      child: ButtonTapWidget(
                        onTap: () {
                          if (nav.index == 0) {
                            if (homeController
                                    .controller
                                    ?.isForwardOrCompleted ??
                                false) {
                              homeController.controller?.reverse();
                            } else {
                              homeController.controller?.forward();
                            }
                          }
                          navController.currentNavIndex.value = nav.index;
                        },
                        child: Padding(
                          padding: padding6H.copyWith(bottom: 6.w),
                          child: NavItem(nav: nav),
                        ),
                      ),
                    ),
                  );
                }),
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
      );
    });
  }
}
