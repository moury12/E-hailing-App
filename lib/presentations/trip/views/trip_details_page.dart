import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/constants/fontsize_constant.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/constants/text_style_constant.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/home/widgets/select_car_item_widget.dart';
import 'package:e_hailing_app/presentations/navigation/widgets/custom_container_with_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/custom_timeline.dart';
import '../../../core/constants/image_constant.dart';
import '../../../core/helper/helper_function.dart';
import '../widgets/car_information_widget.dart';
import '../widgets/row_call_chat_details_button.dart';

class TripDetailsPage extends StatelessWidget {
  static const String routeName = '/trip-details';
  const TripDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStaticStrings.yourTripDetail),
      body: SingleChildScrollView(
        child: Padding(
          padding: padding16.copyWith(top: 0),
          child: Column(
            spacing: 12.h,
            children: [
              CarDetailsCardWidget(),

              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kLightBlackColor.withValues(alpha: .2),
                      blurRadius: 8.r,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryExtraLightColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                      ),
                      padding: padding12,
                      child: Row(
                        spacing: 12.w,
                        children: [
                          Column(
                            children: [
                              CustomNetworkImage(
                                imageUrl: dummyProfileImage,
                                height: 42,
                                width: 42,
                                boxShape: BoxShape.circle,
                              ),
                              space4H,
                              Row(
                                spacing: 4.w,
                                children: [
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: AppColors.kYellowColor,
                                    size: 15.sp,
                                  ),
                                  CustomText(text: '5.0', style: poppinsBold),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Leilani Angel',
                                style: poppinsBold,
                                fontSize: getFontSizeDefault(),
                              ),
                              CustomText(
                                text: 'leilaniangel@gmail.com',
                                style: poppinsRegular,
                                fontSize: getFontSizeSmall(),
                              ),
                              CustomText(
                                text: 'Phone : +12 345 6789',
                                style: poppinsRegular,
                                fontSize: getFontSizeSmall(),
                                color: AppColors.kLightBlackColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: padding12,
                      decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(8.r),
                        ),
                      ),
                      child: Column(
                        spacing: 6.h,
                        children: [
                          CarInformationWidget(
                            title: AppStaticStrings.carType,
                            value: 'Honda HRV',
                          ),
                          CarInformationWidget(
                            title: AppStaticStrings.carColor,
                            value: 'Red',
                          ),
                          CarInformationWidget(
                            title: AppStaticStrings.carNumber,
                            value: 'A89BT',
                          ),
                          CarInformationWidget(
                            title: AppStaticStrings.carSeat,
                            value: '4 Seats',
                          ),
                          CarInformationWidget(
                            title: AppStaticStrings.evpNumber,
                            value: 'EV -A89BT',
                          ),
                          CarInformationWidget(
                            title: AppStaticStrings.evpValidityPeriod,
                            value: 'June 2025',
                          ),
                          space6H,
                          CustomTimeline(
                            padding: EdgeInsets.zero,

                            indicators: <Widget>[
                              SvgPicture.asset(pickLocationIcon),
                              SvgPicture.asset(stopLocationIcon),
                              SvgPicture.asset(dropLocationIcon),
                            ],
                            children: <Widget>[
                              CustomWhiteContainerWithBorder(
                                textAlign: TextAlign.start,
                                text: AppStaticStrings.pickupLocation,
                              ),
                              CustomWhiteContainerWithBorder(
                                textAlign: TextAlign.start,

                                text: AppStaticStrings.stopLocation,
                              ),
                              CustomWhiteContainerWithBorder(
                                textAlign: TextAlign.start,

                                text: AppStaticStrings.dropLocation,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RowCallChatDetailsButton(),
              CancelTripButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

