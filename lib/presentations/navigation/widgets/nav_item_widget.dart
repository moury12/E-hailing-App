import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../controllers/navigation_controller.dart';
import '../model/navigation_model.dart';

class NavItem extends StatelessWidget {
  const NavItem({super.key, required this.nav});

  final NavigationModel nav;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        spacing: 6.h,
        children: [
          SvgPicture.asset(
            colorFilter: ColorFilter.mode(
              NavigationController.to.currentNavIndex.value ==nav.index
                  ? AppColors.kPrimaryColor
                  : AppColors.kTextColor,
              BlendMode.srcIn,
            ),
            nav.img,
            height: 20.w,
            width: 20.w,
          ),
          FittedBox(
            child: CustomText(
              text: nav.title,
              style: poppinsMedium,
              color:
                  NavigationController.to.currentNavIndex.value == nav.index
                      ? AppColors.kPrimaryColor
                      : AppColors.kTextColor,
              fontSize: getFontSizeSmall(),
              // maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    });
  }
}
