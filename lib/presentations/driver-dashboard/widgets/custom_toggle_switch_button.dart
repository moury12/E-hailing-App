import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomToggleSwitch extends StatefulWidget {
  const CustomToggleSwitch({super.key});

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  AlignmentGeometry _alignment = Alignment.centerRight;
  AlignmentGeometry _geometry = Alignment.centerLeft;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _changeAlignment();
      },
      child: Obx(() {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 100.w,
          height: 44.w,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color:
                DashBoardController.to.isDriverActive.value
                    ? Color(0xffBBF7D0)
                    : AppColors.kPrimaryExtraLightColor,
            border: Border.all(
              color:
                  DashBoardController.to.isDriverActive.value
                      ? Color(0xff86EFAC)
                      : AppColors.kBorderColor,
            ),
          ),
          child: Stack(
            children: [
              // Label Text
              AnimatedAlign(
                alignment: _alignment,
                duration: Duration(seconds: 1),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CustomText(
                    text:
                        DashBoardController.to.isDriverActive.value
                            ? AppStaticStrings.active.tr
                            :AppStaticStrings.offline.tr ,
                    style: poppinsMedium,
                    fontSize: getFontSizeSmall(),
                    color: AppColors.kTextColor,
                  ),
                ),
              ),

              AnimatedAlign(
                alignment: _geometry,
                duration: Duration(seconds: 1),
                child: Container(
                  width: 40,
                  height: 40,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          DashBoardController.to.isDriverActive.value
                              ? [Color(0xff22C55E), Color(0xff4ADE80)]
                              : [Color(0xffDDD6FE), Color(0xffF5D0FE)],
                    ),
                    border: Border.all(
                      color:
                          DashBoardController.to.isDriverActive.value
                              ? Color(0xff86EFAC)
                              : AppColors.kBorderColor,
                    ),
                    color:
                        DashBoardController.to.isDriverActive.value
                            ? Colors.green.shade700
                            : Colors.purple.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
