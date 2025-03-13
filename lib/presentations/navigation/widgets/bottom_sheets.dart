import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_text_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/components/custom_timeline.dart';
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

// void homeInitialBottomSheet() {
//   Get.bottomSheet(
//
//     barrierColor: Colors.transparent,
//     // isDismissible: false,
//     clipBehavior: Clip.none,
//     Obx(() {
//       return Container(
//         margin: EdgeInsets.only(bottom: 83),
//         decoration: BoxDecoration(
//           color: AppColors.kLightGreyColor,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(34.r)),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: padding12,
//             child:
//                 HomeController.to.wantToGo.value
//                     ? WantToGoContentWidget()
//                     : HomeController.to.setPickup.value
//                     ? SetLocationWidget()
//                     : InitialContentWidget(),
//           ),
//         ),
//       );
//     }),
//     isScrollControlled: true,
//     enableDrag: true,
//     backgroundColor: Colors.transparent,
//   );
// }

class SetLocationWidget extends StatelessWidget {
  const SetLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h ,
      children: [
        CustomText(
          text: AppStaticStrings.setYourPickupLocation,
          style: poppinsSemiBold,
        ),
        Obx(
         () {
            return CustomWhiteContainerWithBorder(
              img: pickLocationIcon,
              text: HomeController.to.placeName.value,
              cross: ButtonTapWidget(
                onTap: () {
                  HomeController.to.placeName.value = '';
                },
                child: Padding(
                  padding: padding6,
                  child: SvgPicture.asset(crossCircleIcon),
                ),
              ),
            );
          }
        ),
        CustomButton(onTap: () {

        },
        title: AppStaticStrings.continueButton,)
      ],
    );
  }
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
        CustomTimeline(
          indicators: <Widget>[
            SvgPicture.asset(pickLocationIcon),
            SvgPicture.asset(dropLocationIcon),
          ],
          children: <Widget>[
            CustomTextField(
              borderRadius: 24.r,
              hintText: AppStaticStrings.pickupLocation,
              fillColor: AppColors.kWhiteColor,
              borderColor: AppColors.kGreyColor,
              height: 38.h,
              suffixIcon: Padding(
                padding: padding8,
                child: SvgPicture.asset(crossCircleIcon),
              ),
            ),
            CustomTextField(
              borderRadius: 24.r,
              hintText: AppStaticStrings.dropLocation,
              fillColor: AppColors.kWhiteColor,
              borderColor: AppColors.kGreyColor,
              height: 38.h,
              suffixIcon: Padding(
                padding: padding8,
                child: SvgPicture.asset(crossCircleIcon),
              ),
            ),
          ],
        ),
        Row(
          spacing: 6.w,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(addIcon),
            CustomText(
              text: AppStaticStrings.addStop,
              fontSize: getFontSizeSmall(),
              fontWeight: FontWeight.w400,
              color: AppColors.kPrimaryColor,
            ),
          ],
        ),
        IconWithTextWidget(
          icon: setLocationIcon,
          text: AppStaticStrings.setLocationFromMap,
          onTap: () {
            debugPrint(HomeController.to.setPickup.value.toString());
            HomeController.to.wantToGo.value = false;
            HomeController.to.setPickup.value = true;
          },
        ),
        IconWithTextWidget(
          icon: savedPlaceIcon,
          text: AppStaticStrings.savedPlace,
        ),
        ...List.generate(
          4,
          (index) => IconWithTextWidget(
            icon: historyIcon,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: 'Tongi Bangladesh'),
                CustomText(
                  text: 'Gazipur, DHaka',
                  fontSize: getFontSizeSmall(),
                  style: poppinsRegular,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class IconWithTextWidget extends StatelessWidget {
  final String? icon;
  final String? text;
  final Widget? child;
  final Function()? onTap;
  const IconWithTextWidget({
    super.key,
    this.icon,
    this.text,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            spacing: 8.w,
            children: [
              SvgPicture.asset(icon ?? ''),
              child ?? CustomText(text: text ?? ''),
            ],
          ),
          Divider(color: AppColors.kGreyColor),
        ],
      ),
    );
  }
}

class InitialContentWidget extends StatelessWidget {
  const InitialContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 6.h,
      children: [
        GestureDetector(
          onTap: () {
            debugPrint(HomeController.to.wantToGo.value.toString());
            HomeController.to.wantToGo.value = true;
          },
          child: SearchFieldButtonWidget(),
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
