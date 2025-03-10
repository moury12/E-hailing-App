import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/custom_space.dart';
import '../constants/custom_text.dart';
import '../constants/fontsize_constant.dart';
import '../constants/padding_constant.dart';
import 'custom_button_tap.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.sizeOf(context).width / 1.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[],
        ),
      ),
    );
  }
}

class DrawerContentWidget extends StatelessWidget {
  final String icon;
  final String text;
  final Function()? onTap;
  const DrawerContentWidget({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Padding(
            padding: padding16,
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 14.w,
                  width: 14.w,
                ),
                space16W,
                Expanded(
                  child: CustomText(
                    text: text,
                    fontSize: getFontSizeSmall(),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xffEEEEEE),
          )
        ],
      ),
    );
  }
}
