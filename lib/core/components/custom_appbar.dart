import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/widgets/custom_toggle_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../constants/custom_text.dart';
class CustomAppBarForHome extends StatelessWidget implements PreferredSizeWidget {
  final String? actionIcon;
  final Function()? onTap;
  final Function()? onBack;
  final bool? isBack;
  final bool? isDriver;

  const CustomAppBarForHome({
    super.key,
    this.actionIcon,
    this.onTap,
    this.isBack = false,
    this.onBack,
    this.isDriver = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(

      // backgroundColor: isBack == true ? Colors.transparent : AppColors.kWhiteColor,
      // elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsetsGeometry.only(left: 8.w),
        child:   isBack == true
            ? PrimaryCircleButtonWidget(
          actionIcon: backIcon,
          onTap: onBack ?? () => Get.back(),
        )
            : SvgPicture.asset(primaryLogoIcon),
      ),
      actions: [ if (isDriver == true) CustomToggleSwitch(),
        IconButton(
          onPressed: () {
            callOnPhone(phoneNumber: '999');
          },
          icon: SvgPicture.asset(sosIcon),
        ),
        if (actionIcon != null)
          PrimaryCircleButtonWidget(
            actionIcon: actionIcon,
            onTap: onTap,
          ),

      space8W],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? action;
  final Color? backgroundColor;

  const CustomAppBar({super.key, required this.title, this.action, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: CustomText(text: title, fontSize: getFontSizeDefault()),
      centerTitle: true,
      actions: action ?? [],
    );
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
