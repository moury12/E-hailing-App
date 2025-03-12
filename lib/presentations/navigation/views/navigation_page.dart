import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button_tap.dart';
import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../../core/utils/variables.dart';
import '../../home/widgets/row_more_button_widget.dart';
import '../../home/widgets/search_field_button_widget.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/bottom_sheets.dart';
import '../widgets/google_map_widget.dart';
import '../widgets/nav_item_widget.dart';

class NavigationPage extends StatelessWidget {
  static const String routeName = '/nav';
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return IndexedStack(
                index: NavigationController.to.currentNavIndex.value,
                children: NavigationController.to.getPages(),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Stack(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(navList.length, (index) {
                final nav = navList[index];
                return Expanded(
                  child: Tooltip(
                    message: nav.title,
                    child: ButtonTapWidget(
                      onTap: () {
                        if (nav.index == 0) {
                          homeInitialBottomSheet();
                        }
                        NavigationController.to.currentNavIndex.value =
                            nav.index;
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
          Obx(() {
            double containerWidth = MediaQuery.of(context).size.width;
            double itemWidth = containerWidth / navList.length;

            double indicatorPosition =
                itemWidth * NavigationController.to.currentNavIndex.value +
                (itemWidth - 70.w) / 2 -
                12.w;
            return AnimatedPositioned(
              left: indicatorPosition,
              duration: Duration(milliseconds: 200),
              child: Container(
                margin: padding12H,
                decoration: BoxDecoration(color: AppColors.kPrimaryColor),
                height: 3.w,
                width: 70.w,
              ),
            );
          }),
        ],
      ),
    );
  }
}
