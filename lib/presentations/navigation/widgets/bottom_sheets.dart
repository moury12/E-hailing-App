import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../home/widgets/row_more_button_widget.dart';
import '../../home/widgets/search_field_button_widget.dart';
import 'custom_container_with_border.dart';

void homeInitialBottomSheet() {
  Get.bottomSheet(
    barrierColor: Colors.transparent,
    Obx(() {
      return Container(
        margin: EdgeInsets.only(bottom: 83),
        decoration: BoxDecoration(
          color: AppColors.kLightGreyColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(34.r)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: padding12,
            child: HomeController.to.wantToGo.value
                ? WantToGoContentWidget()
                : InitialContentWidget(),
          ),
        ),
      );
    }),
    isScrollControlled: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
  );
}

class WantToGoContentWidget extends StatelessWidget {
  const WantToGoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: AppStaticStrings.selectDestination,
          style: poppinsSemiBold,
        ),
        FixedTimeline(
          children: [
            TimelineTile(nodeAlign: TimelineNodeAlign.start,
              node: SvgPicture.asset(pickLocationIcon),
              contents: CustomTextField(),
            ),
            // TimelineTile(
            //   node: SvgPicture.asset(pickLocationIcon),
            //   contents: CustomTextField(),
            // ),
            TimelineTile(
              node: SvgPicture.asset(pickLocationIcon),
              contents: CustomTextField(),
            ),
            // TimelineTile(node: )
          ],
        ),
      ],
    );
  }
}

class InitialContentWidget extends StatelessWidget {
  const InitialContentWidget({super.key, });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 6.h,
      children: [
        GestureDetector(onTap: () {
          debugPrint(HomeController.to.wantToGo.value.toString());
          HomeController.to.wantToGo.value = true;
        },
          child: SearchFieldButtonWidget(

          ),
        ),
        RowMoreButtonWidget(
          title: AppStaticStrings.recentTip,
          onPressed: () {},
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              spacing: 6.w,
              children: [
                Expanded(
                  child: CustomWhiteContainerWithBorder(
                    text: 'Building 8cvxcgvxfggggggggggggggg,...',
                    img: pickLocationIcon,
                  ),
                ),

                Expanded(
                  child: CustomWhiteContainerWithBorder(
                    text: 'Building 8cvxcgvxfggggggggggggggg,...',
                    img: dropLocationIcon,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(exchangeIcon),
          ],
        ),
        RowMoreButtonWidget(
          onPressed: () {},
          title: AppStaticStrings.savedLocation,
        ),
        Row(
          spacing: 6.w,
          children: [
            ...List.generate(
              3,
              (index) => SizedBox(
                width: ScreenUtil().screenWidth / 3 - 24,
                child: CustomWhiteContainerWithBorder(
                  text: AppStaticStrings.home,
                  img: homeLocationIcon,
                ),
              ),
            ),
          ],
        ),
        CustomText(text: AppStaticStrings.service),
        Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: CustomWhiteContainerWithBorder(
                child: Column(
                  spacing: 6.h,
                  children: [
                    Image.asset(purpleCarImage, height: 64),
                    CustomText(
                      text: AppStaticStrings.ride,
                      style: poppinsSemiBold,
                      fontSize: getFontSizeDefault(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomWhiteContainerWithBorder(
                child: Column(
                  spacing: 6.h,
                  children: [
                    Image.asset(purpleCarImage, height: 64),
                    CustomText(
                      text: AppStaticStrings.preBookRide,
                      style: poppinsSemiBold,
                      fontSize: getFontSizeDefault(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
