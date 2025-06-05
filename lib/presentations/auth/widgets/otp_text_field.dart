import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../controllers/auth_controller.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField({super.key});

  // final AuthController otpController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Expanded(
          child: Container(
            width: 50.w,
            height: 50.w,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Obx(() {
              return TextField(

                controller: AuthController.to.otpControllers[index].value,
                focusNode: AuthController.to.focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: poppinsMedium.copyWith(
                  fontSize: getFontSizeLarge(),
                  color: AppColors.kTextColor,
                ),

                cursorColor: AppColors.kTextColor,
                maxLength: 1, // Restrict to 1 digit
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: '⚫',
                  fillColor:
                    /*  AuthController.to.controllers[index].value.text.isNotEmpty
                          ? AppColors.kPrimaryColor
                          : */Colors.transparent,
                  filled: true,
                  counterText: "", // Hide character counter
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.kTextColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.kTextColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.kTextColor),
                  ),
                ),
                onChanged: (value) {
                  AuthController.to.onOtpChanged(value, index);
                  AuthController.to.otpControllers[index].refresh();
                },
              );
            }),
          ),
        );
      }),
    );
  }
}
