import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/custom_appbar.dart';

class SavedLocationPage extends StatelessWidget {
  static const String routeName = '/save-location';
  const SavedLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.savedLocation),
      body: ListView.builder(
        padding: padding16H,
        itemCount: 5,
        itemBuilder:
            (context, index) =>
                index == 4
                    ? SavedLocationItemWidget(
                      trailingImg: addIcon,
                      title: AppStaticStrings.addLocation,
                      img: saveLocationIcon,
                    )
                    : SavedLocationItemWidget(subText: 'Tongi, Bangladesh',),
      ),
    );
  }
}

class SavedLocationItemWidget extends StatelessWidget {
  final String? img;
  final String? trailingImg;
  final String? title;
  final String? subText;
  const SavedLocationItemWidget({
    super.key,
    this.img,
    this.trailingImg,
    this.title,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding8.copyWith(top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.kWhiteColor,
        border: Border.all(color: AppColors.kPrimaryColor, width: 1.w),
      ),
      child: Padding(
        padding: padding8,
        child: Row(
          spacing: 6.w,
          children: [
            SvgPicture.asset(img ?? homeLocationIcon, height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title ?? AppStaticStrings.home,
                  style: poppinsSemiBold,
                ),
               subText!=null? CustomText(
                  text: subText ?? '',
                  style: poppinsThin,
                  color: AppColors.kLightBlackColor,
                ):SizedBox.shrink(),
              ],
            ),
            Spacer(),
            SvgPicture.asset(trailingImg ?? arrowCircleIcon),
          ],
        ),
      ),
    );
  }
}
