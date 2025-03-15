import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/color_constants.dart';
import '../../constants/custom_space.dart';
import '../../constants/fontsize_constant.dart';
import '../../constants/padding_constant.dart';
import '../../constants/text_style_constant.dart';
import '../tab_content_view.dart';
import 'custom_container.dart';

class DynamicTabWidget extends StatelessWidget {
  final RxList<String> tabs;
  final RxList<Widget> tabContent;
  final Function(int)? function;

  const DynamicTabWidget({
    super.key,
    required this.tabs,
    required this.tabContent,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return DefaultTabController(

          length: tabs.length, // Dynamically set the number of tabs
          child: Column(
            children: [

              CustomContainer(
                backgroundColor: AppColors.kWhiteColor,
                padding:padding8,
                widget: TabBar(indicatorPadding: EdgeInsets.zero, padding: EdgeInsets.zero,
                  indicatorColor: Colors.transparent, labelPadding: EdgeInsets.zero,

                  dividerColor: Colors.transparent,
                  overlayColor: const WidgetStatePropertyAll<Color>(
                      Colors.transparent),
                  isScrollable: false, // Keep tabs aligned properly
                  indicator: BoxDecoration(
                    color: AppColors.kPrimaryColor, // Active tab background color
                    borderRadius: BorderRadius.circular(20.r), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2), // Slight shadow for active tab
                      ),
                    ],
                  ),
                  labelColor: AppColors.kWhiteColor,  // Active tab text color
                  unselectedLabelColor:
                      AppColors.kTextDarkBlueColor, // Inactive tab text color
                  labelStyle: poppinsMedium.copyWith(
                    fontSize: getFontSizeSemiSmall(),
                    color: AppColors.kWhiteColor
                  ),
                  unselectedLabelStyle: poppinsMedium.copyWith(
                    fontSize: getFontSizeSemiSmall(),
                    color: AppColors.kTextDarkBlueColor,
                  ),
                  onTap: function ?? (value) {},
                  tabs: tabs
                      .asMap()
                      .entries
                      .map((entry) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Container(
                              height: 40.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    Colors.transparent, // Default for inactive tabs
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: FittedBox(
                                child: CustomText(
                                 text:  entry.value,
                                  // color: AppColors.kTextDarkBlueColor,
                                  style: poppinsMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              space6H,
              TabContentView(
                children: tabContent,
              ),
            ],
          ),
        );
      }
    );
  }
}
