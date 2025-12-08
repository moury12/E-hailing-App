import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/pagination_loading_widget.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/controllers/driver_settings_controller.dart';
import 'package:e_hailing_app/presentations/profile/widgets/custom_container_with_elevation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class EarningsBarChart extends StatefulWidget {
  const EarningsBarChart({super.key});

  @override
  State<EarningsBarChart> createState() => _EarningsBarChartState();
}

class _EarningsBarChartState extends State<EarningsBarChart> {
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final List<String> typeList = ["coin", "cash"];

  @override
  Widget build(BuildContext context) {
    return CustomContainerWithElevation(
      child: SizedBox(
        height: 250.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 6.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: 'Earnings Growth',
                    style: poppinsBold,
                    fontSize: getFontSizeDefault(),
                  ),
                ),
                DropdownContainerWidget(
                  widget: DropdownButtonHideUnderline(
                    child: Obx(() {
                      final totalYears =
                          DriverSettingsController
                              .to
                              .driverEarningModel
                              .value
                              .totalYears;
                      return DropdownButton<String>(
                        hint: CustomText(text: DateTime.now().year.toString()),
                        value:
                            DriverSettingsController
                                .to
                                .selectedYear
                                .value
                                .value,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                        elevation: 0,
                        style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        isDense: true,
                        borderRadius: BorderRadius.circular(12),
                        onChanged: (String? newValue) {
                          DriverSettingsController.to.selectedYear.value.value =
                              newValue!;
                          DriverSettingsController.to.getDriverEarningReport(
                            year: newValue,
                          );
                        },
                        items:
                            (totalYears ?? []).map<DropdownMenuItem<String>>((
                              num value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: CustomText(text: value.toString()),
                              );
                            }).toList(),
                      );
                    }),
                  ),
                ),

                DropdownContainerWidget(
                  widget: DropdownButtonHideUnderline(
                    child: Obx(() {
                      return DropdownButton<String>(
                        hint: CustomText(text: "cash"),
                        value:
                            DriverSettingsController
                                .to
                                .selectedType
                                .value
                                .value,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                        elevation: 0,
                        style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        isDense: true,
                        borderRadius: BorderRadius.circular(12),
                        onChanged: (String? newValue) {
                          DriverSettingsController.to.selectedType.value.value =
                              newValue!;
                          DriverSettingsController.to.getDriverEarningReport(
                            type: newValue,
                          );
                        },
                        items:
                            typeList.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: CustomText(text: value),
                              );
                            }).toList(),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              final earnings =
                  DriverSettingsController.to.driverEarningModel.value;
              final monthlyRevenue = earnings.monthlyRevenue;
              if(DriverSettingsController.to.isLoadingCar.value){
                return PaginationLoadingWidget();
              }
              if (monthlyRevenue == null || monthlyRevenue.toJson().isEmpty) {
                return  CustomText(text: AppStaticStrings.noDataFound);
              }
              final monthlyEarnings = monthlyRevenue.toJson().values.toList();
              final maxEarning = monthlyEarnings.reduce(
                (value, element) => value > element ? value : element,
              );
              final maxY = maxEarning + (maxEarning * .2);
              return  Flexible(
                fit: FlexFit.loose,

                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            'RM ${rod.toY.toInt()}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitleWidgets,
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: leftTitleWidgets,
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(
                      monthlyEarnings.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: double.parse(
                              monthlyEarnings[index].toString(),
                            ),
                            color: AppColors.kBlueLittleDarkColor,
                            width: 16,
                            borderRadius: BorderRadius.circular(6.r),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: AppColors.kGreyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    gridData: FlGridData(show: false),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < months.length) {
      return Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: CustomText(
          text: months[index],
          style: poppinsRegular,
          fontSize: 10.sp,
          color: AppColors.kBorderColor,
        ),
      );
    }
    return Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = '';
    if (value == 0) {
      text = '0';
    } else if (value < 1000) {
      text = value.toInt().toString(); // Show actual number like 500, 600
    } else {
      text = '${(value ~/ 1000)}k';
    }

    return Padding(
      padding: EdgeInsets.only(right: 6.w),
      child: CustomText(
        text: text,
        style: poppinsMedium,
        color: AppColors.kTextColor,
        fontSize: 10.sp,
      ),
    );
  }
}

class DropdownContainerWidget extends StatelessWidget {
  final Widget widget;

  const DropdownContainerWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingH16V2,
      decoration: BoxDecoration(
        color: Color(0xffDBEAFE),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.kBlueLittleDarkColor),
      ),
      child: widget,
    );
  }
}
