import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomToggleSwitch extends StatefulWidget {
  const CustomToggleSwitch({super.key});

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  AlignmentGeometry _alignment = Alignment.centerRight;
  AlignmentGeometry _geometry = Alignment.centerLeft;
  bool isActive = false;
  void _changeAlignment() {
    setState(() {
      isActive = !isActive;
      _alignment = isActive ? Alignment.centerLeft : Alignment.centerRight;
      _geometry = !isActive ? Alignment.centerLeft : Alignment.centerRight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _changeAlignment();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 100.w,
        height: 44.w,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:
              isActive ? Color(0xffBBF7D0) : AppColors.kPrimaryExtraLightColor,
          border: Border.all(
            color: isActive ? Color(0xff86EFAC) : AppColors.kBorderColor,
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
                  text: isActive ? "Active" : "Offline",
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
                        isActive
                            ? [Color(0xff22C55E), Color(0xff4ADE80)]
                            : [Color(0xffDDD6FE), Color(0xffF5D0FE)],
                  ),
                  border: Border.all(
                    color:
                        isActive ? Color(0xff86EFAC) : AppColors.kBorderColor,
                  ),
                  color:
                      isActive ? Colors.green.shade700 : Colors.purple.shade400,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
