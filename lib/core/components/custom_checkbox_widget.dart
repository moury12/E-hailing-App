import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  final RxBool isChecked;
  const CustomCheckBoxWidget({super.key, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: () {
        isChecked.value = !isChecked.value;
      },
      radius: 4.r,
      child: Padding(
        padding: padding6,
        child: Obx(
          () {
            return Container(
              height: 16.w,
              width: 16.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: isChecked.value ? AppColors.kPrimaryColor : Colors.transparent,
                border: Border.all(
                  color:
                      isChecked.value
                          ? AppColors.kPrimaryColor
                          : AppColors.kTextColor,
                  width: 1.5.w,
                ),
              ),
              child: isChecked.value? Icon(
                CupertinoIcons.checkmark_alt,
                color: Colors.white,
                size: 13.sp,
              ):SizedBox.shrink(),
            );
          }
        ),
      ),
    );
  }
}
