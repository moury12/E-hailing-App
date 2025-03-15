import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_text_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/components/custom_timeline.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/image_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/presentations/home/controllers/home_controller.dart';
import 'package:e_hailing_app/presentations/home/views/saved_location_page.dart';
import 'package:e_hailing_app/presentations/home/widgets/pickup_drop_location_widget.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/trip/views/request_trip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../core/constants/app_static_strings_constant.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
import 'row_more_button_widget.dart';
import 'search_field_button_widget.dart';
import '../../navigation/widgets/custom_container_with_border.dart';

class HomeSetLocationWidget extends StatelessWidget {
  const HomeSetLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        CustomText(
          text:HomeController.to.selectEv.value?AppStaticStrings.setYourDropOffLocation: AppStaticStrings.setYourPickupLocation,
          style: poppinsSemiBold,
        ),
        Obx(() {
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
        }),
        CustomButton(
          onTap: () {
           if( !HomeController.to.selectEv.value) {
              HomeController.to.selectEv.value = true;
              HomeController.to.setPickup.value = false;
            }else{
             // HomeController.to.selectEv.value = false;
             Get.toNamed(RequestTripPage.routeName);
           }
          },
          title: AppStaticStrings.continueButton,
        ),
      ],
    );
  }
}
class HomeSelectEvWidget extends StatelessWidget {
  const HomeSelectEvWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        CustomText(text: AppStaticStrings.selectYourEv, style: poppinsSemiBold),
        ...List.generate(
          4,
              (index) => index ==3?CarDetailsCardWidget()
                  :SelectCarITemWidget(onTap: () {
Get.toNamed(RequestTripPage.routeName);
          },),
        ),
      ],
    );
  }
}



class HomeWantToGoContentWidget extends StatelessWidget {
  const HomeWantToGoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: AppStaticStrings.selectDestination,
          style: poppinsSemiBold,
        ),
        PickupDropLocationWidget(),
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
          onTap: () {
            Get.toNamed(SavedLocationPage.routeName);
          },
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

class HomeInitialContentWidget extends StatelessWidget {
  const HomeInitialContentWidget({super.key});

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
        space6H,
        CustomText(text: AppStaticStrings.service),
        space6H,

        Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: ServiceWidget(
                title: AppStaticStrings.ride,
                img: purpleCarImage,
              ),
            ),
            Expanded(
              child: ServiceWidget(
                onTap: () {
                  HomeController.to.setPickup.value = true;
                },
                title: AppStaticStrings.preBookRide,
                img: purpleCarImage2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ServiceWidget extends StatelessWidget {
  final String title;
  final String img;
  final Function()? onTap;
  const ServiceWidget({
    super.key,
    required this.title,
    required this.img,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomWhiteContainerWithBorder(
      onTap: onTap,
      child: Column(
        spacing: 6.h,
        children: [
          Image.asset(img, height: 64),
          CustomText(
            text: title,
            style: poppinsSemiBold,
            fontSize: getFontSizeDefault(),
          ),
        ],
      ),
    );
  }
}
