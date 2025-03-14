import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_check_box.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class TripCancellationReasonCardItem extends StatelessWidget {
  final int index;
  const TripCancellationReasonCardItem({
    super.key, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding12,
      child: Row(
        spacing: 12.w,
        children: [
          Obx(
                  () {
                return CustomCheckbox(
                  isChecked:
                  tripCancellationList[index].isChecked.value,
                  onChanged: (value) {
                    tripCancellationList[index].isChecked.value = value;
                  },
                );
              }
          ),
          CustomText(
            text: tripCancellationList[index].title,
            style: poppinsMedium,
            fontSize: kDefaultFontSize,
          ),
        ],
      ),
    );
  }
}
