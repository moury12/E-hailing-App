import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.kWhiteColor),
      child: Padding(
        padding: padding16.copyWith(
          top: MediaQuery.of(context).viewPadding.top,
          bottom: 6.h,
        ),
        child: Row(
          children: [
            SvgPicture.asset(primaryLogoIcon),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(sosIcon),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kPrimaryColor,
              ),
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(notificationIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

