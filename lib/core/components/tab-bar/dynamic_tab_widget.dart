import 'package:e_hailing_app/core/components/tab-bar/tab_content_view.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/color_constants.dart';
import '../../constants/fontsize_constant.dart';
import '../../constants/text_style_constant.dart';
import 'custom_container.dart';

class DynamicTabWidget extends StatelessWidget {
  final List<String> tabs; // Changed from RxList to regular List
  final List<Widget> tabContent; // Changed from RxList to regular List
  final ValueChanged<int>? onTabChanged; // Renamed from 'function' for clarity
final int? initialIndex;
  const DynamicTabWidget({
    super.key,
    required this.tabs,
    required this.tabContent,
    this.onTabChanged, this.initialIndex,
  }) : assert(
         tabs.length == tabContent.length,
         'Tabs and content must have the same length',
       );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex:initialIndex??0 ,
      length: tabs.length, // Dynamically set the number of tabs
      child: Column(
        children: [
          CustomContainer(
            backgroundColor: AppColors.kWhiteColor,
            padding: EdgeInsets.all(4.sp),
            widget: TabBar(
              indicatorPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              indicatorColor: Colors.transparent,
              labelPadding: EdgeInsets.zero,

              dividerColor: Colors.transparent,
              overlayColor: const WidgetStatePropertyAll<Color>(
                Colors.transparent,
              ),
              isScrollable: false,
              // Keep tabs aligned properly
              indicator: BoxDecoration(
                color: AppColors.kPrimaryColor, // Active tab background color
                borderRadius: BorderRadius.circular(20.r), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2), // Slight shadow for active tab
                  ),
                ],
              ),
              labelColor: AppColors.kWhiteColor,
              // Active tab text color
              unselectedLabelColor: AppColors.kTextDarkBlueColor,
              // Inactive tab text color
              labelStyle: poppinsMedium.copyWith(
                fontSize: getFontSizeSemiSmall(),
                color: AppColors.kWhiteColor,
              ),
              unselectedLabelStyle: poppinsMedium.copyWith(
                fontSize: getFontSizeSemiSmall(),
                color: AppColors.kTextDarkBlueColor,
              ),
              onTap: onTabChanged,
              tabs:
                  tabs
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Container(
                            height: 40.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  Colors
                                      .transparent, // Default for inactive tabs
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: FittedBox(
                              child: CustomText(
                                text: entry.value,
                                // color: AppColors.kTextDarkBlueColor,
                                style: poppinsMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          space12H,
          TabContentView(children: tabContent
          ),
        ],
      ),
    );
  }
}
