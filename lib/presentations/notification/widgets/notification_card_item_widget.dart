import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class NotificationCardItemWidget extends StatelessWidget {
  final int? index;
  const NotificationCardItemWidget({
    super.key, this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:index!%2==0? AppColors.kUnreadColor: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: AppColors.kLightBlackColor)],
      ),
      child: Padding(
        padding: padding12,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Booking Confirmed!',
                    style: poppinsMedium,
                    fontSize: getFontSizeSemiSmall(),
                  ),
                  CustomText(
                    text:
                    'Your ride with Driver John is confirmed. They are on the way!',
                    style: poppinsRegular,
                    fontSize: getFontSizeSmall(),
                    color: AppColors.kExtraLightTextColor,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.multiply,
                color: AppColors.kTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
