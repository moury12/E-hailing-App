// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class DynamicTabWidget extends StatelessWidget {
//   final List<String> tabs;
//   final List<Widget> tabContent;
//   final Function(int)? function;
//
//   const DynamicTabWidget({
//     super.key,
//     required this.tabs,
//     required this.tabContent,
//     this.function,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//
//       length: tabs.length, // Dynamically set the number of tabs
//       child: Column(
//         children: [
//           SizedBox(height: 16.h), // Add spacing above the tabs
//           CustomContainer(
//             backgroundColor: AppColors.kFadeWhiteColor,
//             padding:padding8,
//             widget: TabBar(indicatorPadding: EdgeInsets.zero, padding: EdgeInsets.zero,
//               indicatorColor: Colors.transparent, labelPadding: EdgeInsets.zero,
//
//               dividerColor: Colors.transparent,
//               overlayColor: const WidgetStatePropertyAll<Color>(
//                   Colors.transparent),
//               isScrollable: false, // Keep tabs aligned properly
//               indicator: BoxDecoration(
//                 color: AppColors.kWhiteColor, // Active tab background color
//                 borderRadius: BorderRadius.circular(20.r), // Rounded corners
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 4,
//                     offset: Offset(0, 2), // Slight shadow for active tab
//                   ),
//                 ],
//               ),
//               labelColor: AppColors.kTextColor, // Active tab text color
//               unselectedLabelColor:
//                   AppColors.kSubTextColor, // Inactive tab text color
//               labelStyle: poppinsMedium.copyWith(
//                 fontSize: getFontSizeDefault(context),
//               ),
//               unselectedLabelStyle: poppinsRegular.copyWith(
//                 fontSize: getFontSizeDefault(context),
//               ),
//               onTap: function ?? (value) {},
//               tabs: tabs
//                   .asMap()
//                   .entries
//                   .map((entry) => Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12.w),
//                         child: Container(
//                           height: 40.h,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color:
//                                 Colors.transparent, // Default for inactive tabs
//                             borderRadius: BorderRadius.circular(20.r),
//                           ),
//                           child: FittedBox(
//                             child: Text(
//                               entry.value,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ))
//                   .toList(),
//             ),
//           ),
//           space16H, // Add spacing below the tabs
//           TabContentView(
//             children: tabContent,
//           ),
//         ],
//       ),
//     );
//   }
// }
