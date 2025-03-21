import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/profile/widgets/custom_container_with_elevation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarningsBarChart extends StatefulWidget {
  const EarningsBarChart({super.key});

  @override
  State<EarningsBarChart> createState() => _EarningsBarChartState();
}

class _EarningsBarChartState extends State<EarningsBarChart> {
  final List<String> years = ['2023', '2024', '2025'];
  String selectedYear = '2024';

  // Sample data for each month
  final List<double> monthlyEarnings = [
    25000, // Jan
    30000, // Feb
    32000, // Mar
    22000, // Apr
    20000, // May
    28000, // Jun
    30000, // Jul
    24000, // Aug
    20000, // Sep
    27000, // Oct
    28000, // Nov
    30000, // Dec
  ];

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
  @override
  Widget build(BuildContext context) {
    return CustomContainerWithElevation(

      child: SizedBox(
        height: 250.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 CustomText(
                 text:  'Earnings Growth',
                  style: poppinsBold,
                  fontSize: getFontSizeDefault(),
                ),
                Container(
                  padding: paddingH16V2,
                  decoration: BoxDecoration(
                    color: Color(0xffDBEAFE),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.kBlueLittleDarkColor)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedYear,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      elevation: 0,
                      style: TextStyle(
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      isDense: true,
                      borderRadius: BorderRadius.circular(12),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedYear = newValue!;
                        });
                      },
                      items:
                          years.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 40000,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '\$${rod.toY.toInt()}',
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
                          toY: monthlyEarnings[index],
                          color: AppColors.kBlueLittleDarkColor,
                          width: 16,
                          borderRadius: BorderRadius.circular(6.r),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 40000,
                            color: AppColors.kGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < months.length) {
      return Padding(
        padding:  EdgeInsets.only(top:6.h),
        child: CustomText(
         text:  months[index],
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
    } else if (value == 10000) {
      text = '10k';
    } else if (value == 20000) {
      text = '20k';
    } else if (value == 30000) {
      text = '30k';
    } else if (value == 40000) {
      text = '40k';
    }

    return Padding(
      padding:  EdgeInsets.only(right: 6.w),
      child: CustomText(
      text:   text,
        style: poppinsMedium,
        color: AppColors.kTextColor,
        fontSize: 10.sp,

      ),
    );
  }
}
