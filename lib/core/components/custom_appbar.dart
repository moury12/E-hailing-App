import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../constants/custom_text.dart';

class CustomAppBarForHomeWidget extends StatelessWidget {
  final String? actionIcon;
  final Function()? onTap;
  final Function()? onBack;
  final bool? isBack;
  const CustomAppBarForHomeWidget({
    super.key,
    this.actionIcon,
    this.onTap,
    this.isBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isBack == true ? Colors.transparent : AppColors.kWhiteColor,
      ),
      child: Padding(
        padding: padding16.copyWith(
          top: MediaQuery.of(context).viewPadding.top,
          bottom: 6.h,
        ),
        child: Row(
          children: [
            isBack == true
                ? PrimaryCircleButtonWidget(
                  actionIcon: backIcon,
                  onTap:
                      onBack ??
                      () {
                        Get.back();
                      },
                )
                : SvgPicture.asset(primaryLogoIcon),
            Spacer(),
            IconButton(onPressed: () {}, icon: SvgPicture.asset(sosIcon)),
            PrimaryCircleButtonWidget(actionIcon: actionIcon, onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: CustomText(text: title), centerTitle: true);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PrimaryCircleButtonWidget extends StatelessWidget {
  const PrimaryCircleButtonWidget({
    super.key,
    required this.actionIcon,
    this.onTap,
  });

  final String? actionIcon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.w,
      width: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.kPrimaryColor,
      ),
      child: ButtonTapWidget(
        onTap: onTap,

        child: Padding(
          padding: padding12,
          child: SvgPicture.asset(
            actionIcon ?? notificationIcon,
            height: 20.w,
            width: 20.w,
          ),
        ),
      ),
    );
  }
}
