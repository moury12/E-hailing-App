import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fontsize_constant.dart';
import '../constants/text_style_constant.dart';

class CustomAuthAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAuthAppbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: CustomText(
        text: title,
        style: poppinsMedium,
        fontSize: getFontSizeExtraLarge(),
        color: AppColors.kTextColor,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDefaultAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  const CustomDefaultAppbar({
    super.key,
    required this.title, this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: AppColors.kWhiteColor,
      centerTitle: true,
      leading:leading ,
      title: CustomText(
        text: title,
        style: poppinsMedium,
        fontSize: getFontSizeExtraLarge(),
        color: AppColors.kWhiteColor,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
